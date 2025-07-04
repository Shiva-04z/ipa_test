import 'package:get/get.dart';


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

  @override
  void onInit() {
    super.onInit();
    loadConsignment();
  }

  Future<void> loadConsignment() async {
    String api = glb.url.value + "/api/consignment/${glb.consignmentID.value}";
    final response = await http.get(Uri.parse(api));
    if (response.statusCode == 200) {
      final json = jsonDecode(response.body);
      searchId.value = json['searchId'] ?? '';
      growerName.value = json['growerName'] ?? '';
      if (json['bilty'] != null) {
        bilty.value = Bilty.fromJson(json['bilty']);
      }
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
