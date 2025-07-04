import 'package:get/get.dart';
import 'package:apple_grower/models/bilty_model.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:firebase_database/firebase_database.dart';
import '../../../core/globals.dart' as glb;

class AadhatiSessionController extends GetxController {
  // Separate data for each quality
  RxMap<String, List<double>> qualityWeights = <String, List<double>>{}.obs;
  RxMap<String, List<double>> qualityPrices = <String, List<double>>{}.obs;
  RxMap<String, List<double>> qualityLandingCosts =
      <String, List<double>>{}.obs;
  RxMap<String, List<String>> qualityCategories = <String, List<String>>{}.obs;
  RxMap<String, double> qualityTotalWeights = <String, double>{}.obs;
  RxMap<String, double> qualityTotalPrices = <String, double>{}.obs;

  RxBool sessionActive = false.obs;
  RxString error = ''.obs;
  DatabaseReference? _sessionRef;
  Stream<DatabaseEvent>? _analyticsStream;
  RxBool growerApproval = false.obs;
  RxMap<String, String> highestBidderPerQuality = <String, String>{}.obs;
  RxMap<String, double> highestLandingPerQuality = <String, double>{}.obs;

  @override
  void onInit() {
    super.onInit();
    glb.consignmentID.value="68666675d96b7062a6871a95";
    loadConsignmentBilty().then((_) async {
      await ensureSessionExists();
      _listenToGrowerApproval();
    });
    _listenToRealtimeAnalytics();
    _listenToBids();
  }

  Future<void> loadConsignmentBilty() async {
    try {
      final api = glb.url.value + "/api/consignment/${glb.consignmentID.value}";
      final response = await http.get(Uri.parse(api));
      if (response.statusCode == 200) {
        final json = jsonDecode(response.body);
        if (json['bilty'] != null) {
          final bilty = Bilty.fromJson(json['bilty']);
          // Initialize data structures for each quality
          _initializeQualityData(bilty);
        } else {
          error.value = 'No bilty data found.';
        }
      } else {
        error.value = 'Failed to load consignment: \\${response.statusCode}';
      }
    } catch (e) {
      error.value = 'Error: \\${e.toString()}';
    }
  }

  void _initializeQualityData(Bilty bilty) {
    // Clear existing data
    qualityWeights.clear();
    qualityPrices.clear();
    qualityLandingCosts.clear();
    qualityCategories.clear();

    // Group categories by quality
    final qualityGroups = <String, List<BiltyCategory>>{};
    for (var category in bilty.categories) {
      qualityGroups.putIfAbsent(category.quality, () => []).add(category);
    }

    // Populate data for each quality
    qualityGroups.forEach((quality, categories) {
      qualityCategories[quality] = categories.map((c) => c.category).toList();
      qualityWeights[quality] = categories.map((c) => c.totalWeight).toList();
      qualityPrices[quality] = categories.map((c) => c.pricePerKg).toList();
      qualityLandingCosts[quality] =
          List.filled(categories.length, 0.0); // Initial landing cost is 0
    });

    // Push analytics to Firebase after initializing
    pushAnalyticsToFirebase();
  }

  void _listenToGrowerApproval() {
    final consignmentId = glb.consignmentID.value;
    final approvalRef =
        FirebaseDatabase.instance.ref('sessions/$consignmentId/growerApproval');
    approvalRef.onValue.listen((event) {
      final value = event.snapshot.value;
      growerApproval.value = value == true;
    });
  }

  Future<void> setGrowerApproval(bool value) async {
    final consignmentId = glb.consignmentID.value;
    final sessionRef = FirebaseDatabase.instance.ref('sessions/$consignmentId');
    await sessionRef.update({'growerApproval': value});
    growerApproval.value = value;
  }

  Future<void> startSession(String sessionId) async {
    sessionActive.value = true;
    final consignmentId = glb.consignmentID.value;
    _sessionRef = FirebaseDatabase.instance.ref('sessions/$consignmentId');
    await _sessionRef!.update({
      'status': 'active',
      'startedAt': DateTime.now().toIso8601String(),
      'growerApproval' : false,
      'bids':{}
    });
    _listenToRealtimeAnalytics();
  }

  Future<void> endSession() async {
    sessionActive.value = false;
    final consignmentId = glb.consignmentID.value;
    if (_sessionRef == null) {
      _sessionRef = FirebaseDatabase.instance.ref('sessions/$consignmentId');
    }
    await _sessionRef!.update({
      'status': 'ended',
      'endedAt': DateTime.now().toIso8601String(),
    });
  }

  void _listenToRealtimeAnalytics() {
    final consignmentId = glb.consignmentID.value;
    final analyticsRef =
        FirebaseDatabase.instance.ref('sessions/$consignmentId/analytics');
    _analyticsStream = analyticsRef.onValue;
    _analyticsStream!.listen((event) {
      final data = event.snapshot.value;
      if (data is Map) {
        // Update each quality's data separately
        data.forEach((quality, analytics) {
          if (analytics is List) {
            _updateQualityDataFromAnalytics(quality.toString(), analytics);
          }
        });
      }
    });
  }

  // Update the _updateQualityDataFromAnalytics method
  void _updateQualityDataFromAnalytics(
      String quality, List<dynamic> analytics) {
    final categories =
        analytics.map((e) => e['category'].toString()).toList().cast<String>();
    final weights = analytics
        .map((e) => (e['weight'] ?? 0).toDouble())
        .toList()
        .cast<double>();
    final prices = analytics
        .map((e) => (e['price'] ?? 0).toDouble())
        .toList()
        .cast<double>();
    final landingCosts = analytics
        .map((e) => (e['landingCost'] ?? 0).toDouble())
        .toList()
        .cast<double>();

    qualityCategories[quality] = categories;
    qualityWeights[quality] = weights;
    qualityPrices[quality] = prices;
    qualityLandingCosts[quality] = landingCosts;

    // Calculate totals
    qualityTotalWeights[quality] =
        weights.fold(0, (sum, weight) => sum + weight);
    qualityTotalPrices[quality] = prices.fold(0, (sum, price) => sum + price);

    // Remove quality if all weights are zero
    if (qualityTotalWeights[quality] == 0) {
      qualityCategories.remove(quality);
      qualityWeights.remove(quality);
      qualityPrices.remove(quality);
      qualityLandingCosts.remove(quality);
      qualityTotalWeights.remove(quality);
      qualityTotalPrices.remove(quality);
    }
  }

  // Push analytics data for all qualities to Firebase RTDB
  Future<void> pushAnalyticsToFirebase() async {
    final consignmentId = glb.consignmentID.value;
    final analyticsRef =
        FirebaseDatabase.instance.ref('sessions/$consignmentId/analytics');
    final Map<String, List<Map<String, dynamic>>> analyticsData = {};

    qualityCategories.forEach((quality, categories) {
      analyticsData[sanitizeKey(quality)] = List.generate(
          categories.length,
          (i) => {
                'category': categories[i],
                'weight': qualityWeights[quality]?[i] ?? 0,
                'price': qualityPrices[quality]?[i] ?? 0,
                'landingCost': qualityLandingCosts[quality]?[i] ?? 0,
              });
    });

    await analyticsRef.set(analyticsData);
  }

  Future<void> ensureSessionExists() async {
    final consignmentId = glb.consignmentID.value;
    final sessionRef = FirebaseDatabase.instance.ref('sessions/$consignmentId');
    final snapshot = await sessionRef.get();
    print("here");
    if (!snapshot.exists) {
      print("Creating");
      // Build analytics data
      final Map<String, List<Map<String, dynamic>>> analyticsData = {};
      qualityCategories.forEach((quality, categories) {
        analyticsData[sanitizeKey(quality)] = List.generate(
            categories.length,
            (i) => {
                  'category': categories[i],
                  'weight': qualityWeights[quality]?[i] ?? 0,
                  'price': qualityPrices[quality]?[i] ?? 0,
                  'landingCost': qualityLandingCosts[quality]?[i] ?? 0,
                });
      });
      await sessionRef.set({
        'status': 'inactive',
        'startedAt': DateTime.now().toIso8601String(),
        'analytics': analyticsData,
        'growerApproval' : false,
        'bids':{}
      });
    }
  }

  // Helper to sanitize Firebase keys
  String sanitizeKey(String key) {
    return key.replaceAll(RegExp(r'[.#\$\[\]/]'), '_');
  }

  // Push a bid for a bidder and quality
  Future<void> pushBid(
      String bidderName, String quality, double landingCost) async {
    final consignmentId = glb.consignmentID.value;
    final bidsRef = FirebaseDatabase.instance
        .ref('sessions/$consignmentId/bids/$bidderName');
    await bidsRef.update({sanitizeKey(quality): landingCost});
  }

  // Listen to bids and compute highest per quality
  void _listenToBids() {
    final consignmentId = glb.consignmentID.value;
    final bidsRef =
        FirebaseDatabase.instance.ref('sessions/$consignmentId/bids');
    bidsRef.onValue.listen((event) {
      final data = event.snapshot.value;
      Map<String, double> highestLanding = {};
      Map<String, String> highestBidder = {};
      if (data is Map) {
        data.forEach((bidder, qualities) {
          if (qualities is Map) {
            qualities.forEach((quality, landing) {
              double landingVal = 0;
              if (landing is int) landingVal = landing.toDouble();
              if (landing is double) landingVal = landing;
              if (!highestLanding.containsKey(quality) ||
                  landingVal > highestLanding[quality]!) {
                highestLanding[quality] = landingVal;
                highestBidder[quality] = bidder;
              }
            });
          }
        });
      }
      highestLandingPerQuality.assignAll(highestLanding);
      highestBidderPerQuality.assignAll(highestBidder);
    });
  }
}
