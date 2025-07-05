import 'package:get/get.dart';
import 'package:apple_grower/models/bilty_model.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:firebase_database/firebase_database.dart';
import '../../../core/globals.dart' as glb;
import 'package:apple_grower/models/consignment_model.dart';

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
  Rxn<Consignment> consignment = Rxn<Consignment>();
  RxString highestTotals = "".obs;

  @override
  void onInit() {
    super.onInit();
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
          if (json != null) {
            consignment.value = Consignment.fromJson(json);
          }
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
      'growerApproval': false,
      'bids': {}
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
        'growerApproval': false,
        'bids': {}
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
    final analyticsRef =
        FirebaseDatabase.instance.ref('sessions/$consignmentId/analytics');

    bidsRef.onValue.listen((event) async {
      final data = event.snapshot.value;
      Map<String, double> bidderTotals = {};
      String? highestBidderId;
      String? highestBidderName;
      double highestTotal = 0.0;
      Map<String, double> highestBidderPrices = {};

      if (data is Map) {
        data.forEach((bidderId, bidderData) {
          if (bidderData is Map) {
            final name = bidderData['name'] as String? ?? bidderId;
            final bids = bidderData['bids'];

            if (bids is Map) {
              double total = 0.0;
              Map<String, double> pricePerQuality = {};

              bids.forEach((quality, qualityData) {
                if (qualityData is Map) {
                  // Add totalAmount if exists
                  final totalAmount = qualityData['totalAmount'];
                  if (totalAmount is int || totalAmount is double) {
                    total += (totalAmount as num).toDouble();
                  }

                  // Find first valid bidPerKg
                  for (var item in qualityData.values) {
                    if (item is Map && item.containsKey('bidPerKg')) {
                      final bid = item['bidPerKg'];
                      double bidPerKg = (bid is int)
                          ? bid.toDouble()
                          : (bid as double? ?? 0.0);
                      pricePerQuality[quality] = bidPerKg;
                      break; // break inside .forEach doesn't work, so use for-in instead
                    }
                  }
                }
              });

              bidderTotals[bidderId] = total;

              if (total > highestTotal) {
                highestTotal = total;
                highestBidderId = bidderId;
                highestBidderName = name;
                highestBidderPrices = pricePerQuality;
              }
            }
          }
        });

        // 🔁 Update analytics with highest bidder info
        if (highestBidderId != null && highestBidderPrices.isNotEmpty) {
          final analyticsSnapshot = await analyticsRef.get();
          if (analyticsSnapshot.exists) {
            final Map<dynamic, dynamic> analyticsData =
                analyticsSnapshot.value as Map<dynamic, dynamic>;

            final Map<String, dynamic> updatedAnalytics = {};

            analyticsData.forEach((quality, categories) {
              if (categories is List &&
                  highestBidderPrices.containsKey(quality)) {
                final updatedCategories = categories.map((category) {
                  final updatedCategory =
                      Map<String, dynamic>.from(category as Map);
                  updatedCategory['landingCost'] =
                      highestBidderPrices[quality]!;
                  return updatedCategory;
                }).toList();

                updatedAnalytics[quality] = updatedCategories;
              } else {
                updatedAnalytics[quality] = categories;
              }
            });

            updatedAnalytics['grandTotal'] = highestTotal;
            updatedAnalytics['highestBidder'] = {
              'id': highestBidderId,
              'name': highestBidderName,
              'total': highestTotal,
            };

            await analyticsRef.update(updatedAnalytics);
          }
        }

        highestTotals.value =highestTotal.toStringAsFixed(2);
        // 🧠 Update local state
        highestBidderPerQuality.value = {
          'global': highestBidderName ?? 'Unknown'
        };
        highestLandingPerQuality.value = highestBidderPrices;

        // 🖨️ Print for debug
        print('🔥 New Highest Bidder: $highestBidderName');
        print('💸 Total: ₹${highestTotal.toStringAsFixed(2)}');
        highestBidderPrices.forEach((q, p) {
          print('➡ $q: ₹${p.toStringAsFixed(2)}/kg');
        });
      }
    });
  }
}
