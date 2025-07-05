import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:firebase_database/firebase_database.dart';
import '../../../core/globals.dart' as glb;


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
  RxString highestTotals = "".obs;

  // Add bidderName and myBids for view integration
  RxString? bidderName = ''.obs;
  RxMap<String, double> myBids = <String, double>{}.obs;

  RxString highestBidder ="".obs;
  RxString highestAmount ="".obs;

  @override
  void onInit() {
    super.onInit();
    startSession(glb.consignmentID.value);
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
    final bidsRef = _sessionRef!.child('bids');

    final snapshot = await bidsRef.get();

    if (!snapshot.exists) {
      // Create the 'bids' map with this bidder as the first entry
      await bidsRef.set({
        glb.id.value: {
          "roletype": glb.roleType.value,
          "name":glb.personName.value,
        },
      });
    } else {
      // Update only this bidder's entry inside the existing 'bids' map
      await bidsRef.child(glb.id.value).update({
        "roletype": glb.roleType.value,
      });
    }

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
    final bidsRef = FirebaseDatabase.instance.ref('sessions/$consignmentId/bids');
    final analyticsRef = FirebaseDatabase.instance.ref('sessions/$consignmentId/analytics');

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
                      double bidPerKg = (bid is int) ? bid.toDouble() : (bid as double? ?? 0.0);
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
              if (categories is List && highestBidderPrices.containsKey(quality)) {
                final updatedCategories = categories.map((category) {
                  final updatedCategory = Map<String, dynamic>.from(category as Map);
                  updatedCategory['landingCost'] = highestBidderPrices[quality]!;
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

  void setBidderName(String name) {
    bidderName?.value = name;
  }



  // Submit the full bid data (including grand total) to Firebase under the current bidder
  Future<void> submitFullBidData(
      String bidderName, Map<String, dynamic> bidData) async {
    final consignmentId = glb.consignmentID.value;
    final bidsRef = FirebaseDatabase.instance
        .ref('sessions/$consignmentId/bids/$bidderName/fullBid');
    await bidsRef.set(bidData);
  }

  // ... existing controller code ...

  Future<bool> submitCategoryBid(
    String bidderName,
    String quality,
    String category,
    double bidPerKg,
    double weight,
  ) async {
    try {
      final consignmentId = glb.consignmentID.value;
      final databaseRef = FirebaseDatabase.instance.ref();
      final sessionRef = databaseRef.child('sessions/$consignmentId');

      // First check if bids node exists
      final bidsSnapshot = await sessionRef.child('bids').once();

      if (bidsSnapshot.snapshot.value == null) {
        // Create initial bids structure if it doesn't exist
        await sessionRef.child('bids').set({
          bidderName: {
            'roletype': 'Bidder', // Default role for bidders
            'bids': {
              quality: {
                category: {
                  'bidPerKg': bidPerKg,
                  'weight': weight,
                  'total': bidPerKg * weight,
                  'timestamp': ServerValue.timestamp,
                }
              }
            }
          }
        });
      } else {
        // Update existing bids structure
        await sessionRef
            .child('bids/${glb.id.value}/bids/$quality/$category')
            .update({
          'bidPerKg': bidPerKg,
          'weight': weight,
          'total': bidPerKg * weight,
          'timestamp': ServerValue.timestamp,
        });

        // Ensure roletype is set (in case it's a new bidder)
        await sessionRef.child('bids/$bidderName/roletype').set('Bidder');
      }

      return true;
    } catch (e) {
      print('Error submitting bid: $e');
      Get.snackbar(
        'Error',
        'Failed to submit bid: ${e.toString()}',
        backgroundColor: Colors.red[100],
      );
      return false;
    }
  }

  // Function to get current bids for a quality
  Future<Map<String, dynamic>> getBidsForQuality(String quality) async {
    try {
      final consignmentId = glb.consignmentID.value;
      final snapshot = await FirebaseDatabase.instance
          .ref('sessions/$consignmentId/bids')
          .once();

      if (snapshot.snapshot.value == null) return {};

      Map<String, dynamic> allBids = {};
      final bidsData = snapshot.snapshot.value as Map<dynamic, dynamic>;

      bidsData.forEach((bidderName, bidderData) {
        final bids = (bidderData['bids'] as Map<dynamic, dynamic>?)?[quality];
        if (bids != null) {
          allBids[bidderName] = bids;
        }
      });

      return allBids;
    } catch (e) {
      print('Error getting bids: $e');
      return {};
    }
  }

  // Function to get highest bid for a specific category
  Future<Map<String, dynamic>?> getHighestBidForCategory(
    String quality,
    String category,
  ) async {
    try {
      final allBids = await getBidsForQuality(quality);
      if (allBids.isEmpty) return null;

      Map<String, dynamic>? highestBid;
      String? highestBidder;

      allBids.forEach((bidderName, categories) {
        final categoryBid = (categories as Map<dynamic, dynamic>)[category];
        if (categoryBid != null) {
          final currentBid = categoryBid['bidPerKg'] as double;
          if (highestBid == null ||
              currentBid > (highestBid!['bidPerKg'] as double)) {
            highestBid = Map<String, dynamic>.from(categoryBid);
            highestBidder = bidderName;
          }
        }
      });

      return highestBid?..['bidderName'] = highestBidder;
    } catch (e) {
      print('Error getting highest bid: $e');
      return null;
    }
  }

  Future<void> submitQualityBid(String bidderName, String quality,
      Map<String, dynamic> qualityBidData) async {
    try {
      final consignmentId = glb.consignmentID.value;
      final databaseRef = FirebaseDatabase.instance.ref();
      final sessionRef = databaseRef.child('sessions/$consignmentId');

      // Ensure roletype is set (in case it's a new bidder)
      await sessionRef.child('bids/${glb.id.value}/roletype').set('Bidder');

      // Write all subcategory bids and totalAmount for this quality
      for (final entry in qualityBidData.entries) {
        if (entry.key == 'totalAmount') {
          await sessionRef
              .child('bids/${glb.id.value}/bids/$quality/totalAmount')
              .set(entry.value);
        } else {
          await sessionRef
              .child('bids/${glb.id.value}/bids/$quality/${sanitizeKey(entry.key)}')
              .set(entry.value);
        }
      }
    } catch (e) {
      print('Error submitting quality bid: $e');
      Get.snackbar(
        'Error',
        'Failed to submit all bids for $quality: \\${e.toString()}',
        backgroundColor: Colors.red[100],
      );
    }
  }
}
