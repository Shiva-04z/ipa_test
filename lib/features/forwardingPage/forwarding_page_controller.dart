
import 'package:get/get.dart';
import 'dart:typed_data';

import 'package:apple_grower/models/bilty_model.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'dart:math';
import 'package:http/http.dart' as http;
import '../../core/globals.dart' as glb;
import 'dart:convert';

class ForwardPageController extends GetxController {
  Rx<Bilty> bilty = Bilty.createDefault().obs;
  RxString searchId = ''.obs;
  RxString growerName = ''.obs;
  RxString date ="".obs;
  RxString startTime ="".obs;
  RxBool canStart =true.obs;
  Rx<Uint8List> imageBytes = Uint8List(0).obs;


  Future<Map<String, dynamic>> generateChartData(Bilty bilty) async {
    // Define the chart categories
    final chartCategories = [
      'ELLMS Wt.\n%',      // AAA: Extra Large, Large, Medium
      'ES,EES,240\nWt.%',  // AAA: Small, Extra Small, E Extra Small, 240 Count
      'Pittu Wt.%',        // AAA: Pittu
      'Seprator\nWt.%',    // AAA: Seprator
      'AA ELLMS\nWt. %',   // AA: Extra Large, Large, Medium
      'AA ES to\n240 Wt. %', // AA: Small, Extra Small, E Extra Small, 240 Count
      'AA- Pittu %',       // AA: Pittu
      'AA-\nSeprator %',   // AA: Seprator
      'Mix'                // Mix/Pear
    ];

    // Initialize data lists
    final weights = List<double>.filled(chartCategories.length, 0.0);
    final perKgPrices = List<double>.filled(chartCategories.length, 0.0);
    final landingCosts = List<double>.filled(chartCategories.length, 0.0);

    // Process each category
    for (final category in bilty.categories) {
      final quality = category.quality;
      final cat = category.category;
      final weight = category.totalWeight;
      final price = category.pricePerKg;

      if (quality == 'AAA') {
        if (cat.contains('Extra Large') || cat.contains('Large') || cat.contains('Medium')) {
          weights[0] += weight;
          perKgPrices[0] = price;
        } else if (cat.contains('Small') ||
            cat.contains('Extra Small') ||
            cat.contains('E Extra Small') ||
            cat.contains('240 Count')) {
          weights[1] += weight;
          perKgPrices[1] = price;
        } else if (cat.contains('Pittu')) {
          weights[2] += weight;
          perKgPrices[2] = price;
        } else if (cat.contains('Seprator')) {
          weights[3] += weight;
          perKgPrices[3] = price;
        }
      } else if (quality == 'AA') {
        if (cat.contains('Extra Large') || cat.contains('Large') || cat.contains('Medium')) {
          weights[4] += weight;
          perKgPrices[4] = price;
        } else if (cat.contains('Small') ||
            cat.contains('Extra Small') ||
            cat.contains('E Extra Small') ||
            cat.contains('240 Count')) {
          weights[5] += weight;
          perKgPrices[5] = price;
        } else if (cat.contains('Pittu')) {
          weights[6] += weight;
          perKgPrices[6] = price;
        } else if (cat.contains('Seprator')) {
          weights[7] += weight;
          perKgPrices[7] = price;
        }
      } else if (quality == 'Mix/Pear') {
        weights[8] += weight;
        perKgPrices[8] = price;
      }
    }

    // Calculate landing costs (10% more than price per kg)
    for (int i = 0; i < landingCosts.length; i++) {
      landingCosts[i] = perKgPrices[i] + glb.landingPrice.value;
    }

    // Prepare the request payload
    return {
      'categories': chartCategories,
      'weights': weights,
      'per_kg_prices': perKgPrices,
      'landing_costs': landingCosts,
      'quality': bilty.categories.isNotEmpty ? bilty.categories.first.quality : 'GP'
    };
  }

  Future<Uint8List> postGenerateGraph(Bilty bilty, {String serverUrl = 'https://bot-1buv.onrender.com/generate_chart'}) async {
    try {
      // Generate the chart data
      final chartData = await generateChartData(bilty);

      // Make the POST request
      final response = await http.post(
        Uri.parse(serverUrl),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(chartData),
      );

      if (response.statusCode == 200) {
        final jsonData = jsonDecode(response.body);
        // Convert List<dynamic> to List<int> then to Uint8List
        final bytes = List<int>.from(jsonData['image']);
        return Uint8List.fromList(bytes);
      } else {
        throw Exception('Failed to generate chart: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error generating chart: $e');
    }

  }




  @override
  void onInit() {
    super.onInit();
    loadConsignment();
  }

  Future<void> loadConsignment() async {
    print(glb.consignmentID.value);
    String api = glb.url.value + "/api/consignment/${glb.consignmentID.value}";
    final response = await http.get(Uri.parse(api));
    if (response.statusCode == 200) {
      final json = jsonDecode(response.body);
      searchId.value = json['searchId'] ?? '';
      growerName.value = json['growerName'] ?? '';
      date.value=json['date']??"";
      startTime.value =json ['startTime']??"";
      if (json['bilty'] != null) {
        bilty.value = Bilty.fromJson(json['bilty']);
      }
      imageBytes.value = await postGenerateGraph(bilty.value);
    }
  }

  Map<String, double> get qualityShare {
    final map = <String, double>{};
    final total = bilty.value.totalWeight;

    if (total == 0) return {'AAA': 0, 'AA': 0, 'GP': 0};

    for (var q in ['AAA', 'AA', 'GP']) {
      final weight = bilty.value.categories
          .where((c) => c.quality == q)
          .fold(0.0, (prev, e) => prev + e.totalWeight);
      map[q] = weight / total * 100;
    }

    return map;
  }

  bool isBiddingScheduled() {
    return date.value.isNotEmpty &&
        startTime.value.isNotEmpty;
  }

  bool canStartBidding() {
    if (!isBiddingScheduled()) return false;

    try {
      final scheduledDate = DateTime.parse(date.value);
      final timeParts = startTime.value.split(':');
      final scheduledDateTime = scheduledDate.add(Duration(
        hours: int.parse(timeParts[0]),
        minutes: int.parse(timeParts[1]),
      ));

      return true;
    } catch (e) {
      return true;
    }
  }


  double get plotAreaShare {
    final totalWeight = bilty.value.totalWeight;
    if (totalWeight == 0) return 0;

    final plotWeight = bilty.value.categories
        .where((c) =>
    c.quality == 'AAA' &&
        ['Extra Large', 'Large', 'Medium'].contains(c.category))
        .fold(0.0, (sum, e) => sum + e.totalWeight);

    return plotWeight / totalWeight * 100;
  }

  Map<String, double> get aaaCategoryShare {
    final aaaCategories =
    bilty.value.categories.where((c) => c.quality == 'AAA');
    final totalAAAWeight =
    aaaCategories.fold(0.0, (sum, e) => sum + e.totalWeight);

    if (totalAAAWeight == 0) {
      return {
        'ELLMS': 0,
        'ES,EES,240': 0,
        'Pittu': 0,
        'Seprator': 0,
      };
    }

    // Define category groups
    final ellmsCategories = [
      'Extra Large',
      'Large',
      'Medium',
      'Small',
      'Extra Small'
    ];
    final esEes240Categories = ['E Extra Small', '240 Count'];
    final pittuCategories = ['Pittu'];
    final separatorCategories = ['Seprator'];

    final result = {
      'ELLMS': aaaCategories
          .where((c) => ellmsCategories.contains(c.category))
          .fold(0.0, (sum, e) => sum + e.totalWeight) /
          totalAAAWeight *
          100,
      'ES,EES,240': aaaCategories
          .where((c) => esEes240Categories.contains(c.category))
          .fold(0.0, (sum, e) => sum + e.totalWeight) /
          totalAAAWeight *
          100,
      'Pittu': aaaCategories
          .where((c) => pittuCategories.contains(c.category))
          .fold(0.0, (sum, e) => sum + e.totalWeight) /
          totalAAAWeight *
          100,
      'Seprator': aaaCategories
          .where((c) => separatorCategories.contains(c.category))
          .fold(0.0, (sum, e) => sum + e.totalWeight) /
          totalAAAWeight *
          100,
    };

    // Clamp each value to [0, 100]
    result.updateAll((k, v) => v.clamp(0, 100));

    // Normalize so the sum is exactly 100%
    final totalPercent = result.values.fold(0.0, (a, b) => a + b);
    if (totalPercent > 0 && (totalPercent - 100).abs() > 0.01) {
      result.updateAll((k, v) => v / totalPercent * 100);
    }

    return result;
  }

  /// Returns a map of category name to percentage for a given quality (e.g., 'AAA', 'AA', 'GP')
  Map<String, double> categoryShareByQuality(String quality) {
    final categories =
    bilty.value.categories.where((c) => c.quality == quality);
    final totalWeight = categories.fold(0.0, (sum, c) => sum + c.totalWeight);
    if (totalWeight == 0) {
      // Return all categories for this quality with 0%
      return {for (var c in categories) c.category: 0.0};
    }
    final result = <String, double>{};
    for (var c in categories) {
      result[c.category] = (c.totalWeight / totalWeight * 100).clamp(0, 100);
    }
    // Normalize to 100%
    final totalPercent = result.values.fold(0.0, (a, b) => a + b);
    if (totalPercent > 0 && (totalPercent - 100).abs() > 0.01) {
      result.updateAll((k, v) => v / totalPercent * 100);
    }
    return result;
  }


}
