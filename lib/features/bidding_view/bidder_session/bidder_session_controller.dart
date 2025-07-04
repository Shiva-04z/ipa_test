import 'dart:convert';

import 'package:get/get.dart';
import 'package:firebase_database/firebase_database.dart';
import '../../../core/globals.dart' as glb;
import '../../../models/bilty_model.dart';
import 'package:http/http.dart' as http;

class BidderSessionController extends GetxController {
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
    glb.consignmentID.value = "68666675d96b7062a6871a95";
    startSession("68666675d96b7062a6871a95");
    startSession("68666675d96b7062a6871a95");
    _listenToRealtimeAnalytics();
    _listenToBids();
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
      'bids': {"${glb.personName.value}":{"roletype":"${glb.roleType.value}",},
    }});
    _listenToRealtimeAnalytics();
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





  // Helper to sanitize Firebase keys
  String sanitizeKey(String key) {
    return key.replaceAll(RegExp(r'[.#\$\[\]/]'), '_');
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

  // Set a bid for a given bidder, quality, and landing cost in Firebase


  // Get a list of all non-zero categories (qualities with total weight > 0)
  List<String> get nonZeroCategories {
    return qualityCategories.keys
        .where((quality) => (qualityTotalWeights[quality] ?? 0) > 0)
        .toList();
  }

  // Get the minimum price for a given quality (category)
  double getMinPrice(String quality) {
    final prices = qualityPrices[quality] ?? [];
    if (prices.isEmpty) return 0;
    return prices.reduce((a, b) => a < b ? a : b);
  }
}
