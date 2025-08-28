import 'dart:convert';
import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:pdf/pdf.dart';
import 'package:printing/printing.dart';
import 'package:share_plus/share_plus.dart';
import 'package:flutter/material.dart' as material;
import '../../../core/globals.dart' as glb;
import 'package:flutter/services.dart' show rootBundle;
// For font support
import '../../../models/bilty_model.dart';
import 'dart:math' as math;
import 'package:http/http.dart' as http;

// Color mapping functions
material.Color getRowColor(String quality) {
  switch (quality.toUpperCase()) {
    case 'AAA':
      return material.Colors.red.shade700;
    case 'GP':
      return material.Colors.green.shade700;
    case 'AA':
      return material.Colors.yellow.shade900;
    case 'MIX/PEAR':
      return material.Colors.pink.shade300;
    default:
      return material.Colors.grey.shade200;
  }
}

PdfColor getPdfRowColor(String quality) {
  switch (quality.toUpperCase()) {
    case 'AAA':
      return PdfColor.fromInt(material.Colors.red.shade700.value);
    case 'GP':
      return PdfColor.fromInt(material.Colors.green.shade700.value);
    case 'AA':
      return PdfColor.fromInt(material.Colors.yellow.shade900.value);
    case 'MIX/PEAR':
      return PdfColor.fromInt(material.Colors.pink.shade300.value);
    default:
      return PdfColor.fromInt(material.Colors.grey.shade200.value);
  }
}

PdfColor getPdfHeaderColor() {
  return PdfColor.fromInt(material.Colors.orange.shade200.value);
}

Future<Uint8List> loadImage(List<BiltyCategory> categories) async {
  // Define the fixed label groups and their hierarchy
  final Map<String, Map<String, List<String>>> qualityHierarchy = {
    'AAA': {
      'AAA (ELLMS)': [
        'Extra Large',
        'Large',
        'Medium',
        'Small',
        'Extra Small',
        'E Extra Small'
      ],
      'AAA (Pittu/Sep/240)': ['240 Count', 'Pittu', 'Seprator'],
    },
    'AA': {
      'AA (ELLMS)': [
        'Extra Large',
        'Large',
        'Medium',
        'Small',
        'Extra Small',
        'E Extra Small'
      ],
      'AA (Pittu/Sep/240)': ['240 Count', 'Pittu', 'Seprator'],
    },
    'GP': {
      'GP': ['Large', 'Medium', 'Small', 'Extra Small'],
    },
    'Mix/Pear': {
      'Mix/Pear': ['Mix & Pears'],
    }
  };

  // Initialize result lists
  final List<String> groupLabels = [];
  final List<double> groupWeights = [];
  final List<int> groupBoxes = [];

  // Process each quality group in order
  qualityHierarchy.forEach((quality, groups) {
    groups.forEach((groupLabel, childCategories) {
      double totalWeight = 0;
      int totalBoxes = 0;

      // Calculate totals for this group
      for (var category in categories) {
        if (childCategories.contains(category.category) &&
            category.quality == quality) {
          totalWeight += category.totalWeight;
          totalBoxes += category.boxCount;
        }
      }

      // Add the group regardless of whether it has values
      groupLabels.add(groupLabel);
      groupWeights.add(totalWeight);
      groupBoxes.add(totalBoxes);
    });
  });

  // Create the JSON body with all grouped data
  final body = json.encode({
    'categories': groupLabels,
    'weights': groupWeights,
    'boxes': groupBoxes,
    'quality': "Overall"
  });

  // API configuration
  const String apiUrl = 'https://bot-1buv.onrender.com/chart';
  final url = Uri.parse(apiUrl);
  final headers = {'Content-Type': 'application/json'};

  // Make the API call
  try {
    final response = await http.post(url, headers: headers, body: body);

    if (response.statusCode == 200) {
      return response.bodyBytes;
    } else {
      throw Exception(
          'Failed to load chart image. Status: ${response.statusCode}, Body: ${response.body}');
    }
  } catch (e) {
    throw Exception('Error contacting chart server: $e');
  }
}

Future<Uint8List> loadGrowerImage(List<BiltyCategory> categories) async {
  // Define the fixed label groups and their hierarchy
  final Map<String, Map<String, List<String>>> qualityHierarchy = {
    'AAA': {
      'AAA (ELLMS)': [
        'Extra Large',
        'Large',
        'Medium',
        'Small',
        'Extra Small',
        'E Extra Small'
      ],
      'AAA (Pittu/Sep/240)': ['240 Count', 'Pittu', 'Seprator'],
    },
    'AA': {
      'AA (ELLMS)': [
        'Extra Large',
        'Large',
        'Medium',
        'Small',
        'Extra Small',
        'E Extra Small'
      ],
      'AA (Pittu/Sep/240)': ['240 Count', 'Pittu', 'Seprator'],
    },
    'GP': {
      'GP': ['Large', 'Medium', 'Small', 'Extra Small'],
    },
    'Mix/Pear': {
      'Mix/Pear': ['Mix & Pears'],
    }
  };

  // Initialize result lists
  final List<String> groupLabels = [];
  final List<double> groupWeights = [];
  final List<double> groupPrices = [];

  // Process each quality group in order
  qualityHierarchy.forEach((quality, groups) {
    groups.forEach((groupLabel, childCategories) {
      double totalWeight = 0;
      double price = 0;

      // Calculate totals for this group
      for (var category in categories) {
        if (childCategories.contains(category.category) &&
            category.quality == quality) {
          totalWeight += category.totalWeight;
          if (category.pricePerKg != 0) {
            price = category.pricePerKg;
          }
        }
      }

      // Add the group regardless of whether it has values
      groupLabels.add(groupLabel);
      groupWeights.add(totalWeight);
      groupPrices.add(price);
    });
  });

  // Create the JSON body with all grouped data
  final body = json.encode({
    'categories': groupLabels,
    'weights': groupWeights,
    'prices': groupPrices,
    'quality': "Overall"
  });

  // API configuration
  const String apiUrl = 'https://bot-1buv.onrender.com/growerChart';
  final url = Uri.parse(apiUrl);
  final headers = {'Content-Type': 'application/json'};

  // Make the API call
  try {
    final response = await http.post(url, headers: headers, body: body);

    if (response.statusCode == 200) {
      return response.bodyBytes;
    } else {
      throw Exception(
          'Failed to load chart image. Status: ${response.statusCode}, Body: ${response.body}');
    }
  } catch (e) {
    throw Exception('Error contacting chart server: $e');
  }
}

Future<Uint8List> loadLadaniImage(List<BiltyCategory> categories) async {
  // Define the fixed label groups and their hierarchy
  final Map<String, Map<String, List<String>>> qualityHierarchy = {
    'AAA': {
      'AAA (ELLMS)': [
        'Extra Large',
        'Large',
        'Medium',
        'Small',
        'Extra Small',
        'E Extra Small'
      ],
      'AAA (Pittu/Sep/240)': ['240 Count', 'Pittu', 'Seprator'],
    },
    'AA': {
      'AA (ELLMS)': [
        'Extra Large',
        'Large',
        'Medium',
        'Small',
        'Extra Small',
        'E Extra Small'
      ],
      'AA (Pittu/Sep/240)': ['240 Count', 'Pittu', 'Seprator'],
    },
    'GP': {
      'GP': ['Large', 'Medium', 'Small', 'Extra Small'],
    },
    'Mix/Pear': {
      'Mix/Pear': ['Mix & Pears'],
    }
  };

  // Initialize result lists
  final List<String> groupLabels = [];
  final List<double> groupWeights = [];
  final List<double> groupPrices = [];

  // Process each quality group in order
  qualityHierarchy.forEach((quality, groups) {
    groups.forEach((groupLabel, childCategories) {
      double totalWeight = 0;
      double price = 0;

      // Calculate totals for this group
      for (var category in categories) {
        if (childCategories.contains(category.category) &&
            category.quality == quality) {
          totalWeight += category.totalWeight;
          if (category.pricePerKg != 0) {
            price = category.pricePerKg;
          }
        }
      }

      // Add the group regardless of whether it has values
      groupLabels.add(groupLabel);
      groupWeights.add(totalWeight);
      groupPrices.add(price);
    });
  });

  // Create the JSON body with all grouped data
  final body = json.encode({
    'categories': groupLabels,
    'weights': groupWeights,
    'prices': groupPrices,
    'landing': glb.landingPrice.value,
    'quality': "Overall"
  });

  // API configuration
  const String apiUrl = 'https://bot-1buv.onrender.com/ladaniChart';
  final url = Uri.parse(apiUrl);
  final headers = {'Content-Type': 'application/json'};

  // Make the API call
  try {
    final response = await http.post(url, headers: headers, body: body);

    if (response.statusCode == 200) {
      return response.bodyBytes;
    } else {
      throw Exception(
          'Failed to load chart image. Status: ${response.statusCode}, Body: ${response.body}');
    }
  } catch (e) {
    throw Exception('Error contacting chart server: $e');
  }
}

double _degreesToRadians(double degrees) => degrees * (math.pi / 180.0);

pw.Widget buildDonutChartPdf({
  required Map<String, double> data,
  required List<PdfColor> colors,
  required String title,
  required pw.Font font,
  double size = 80, // container size, slightly larger than outer radius*2
  double arcWidth = 20, // not used for radius, but for arc thickness if needed
  double gapDegrees = 4,
  bool drawLegendLines = false,
  int? totalBoxes,
  double? totalWeight,
}) {
  final filtered = data.entries.where((e) => e.value > 0).toList();
  if (filtered.isEmpty) return pw.SizedBox();
  final keys = filtered.map((e) => e.key).toList();
  final values = filtered.map((e) => e.value).toList();
  final total = values.fold(0.0, (a, b) => a + b);

  final arcMidpoints = <PdfPoint>[];
  double startAngle = -90.0;
  final outerRadius = 55.0;
  final innerRadius = 40.0;
  for (int i = 0; i < values.length; i++) {
    final sweep = 360 * (values[i] / total) - gapDegrees;
    if (sweep <= 0) {
      startAngle += 360 * (values[i] / total);
      continue;
    }
    final arcStart = _degreesToRadians(startAngle + gapDegrees / 2);
    final arcEnd = _degreesToRadians(startAngle + sweep + gapDegrees / 2);
    final midAngle = arcStart + (arcEnd - arcStart) / 2;
    final midX = size / 2 + (outerRadius - arcWidth / 2) * math.cos(midAngle);
    final midY = size / 2 + (outerRadius - arcWidth / 2) * math.sin(midAngle);
    arcMidpoints.add(PdfPoint(midX, midY));
    startAngle += 360 * (values[i] / total);
  }

  return pw.Column(
    crossAxisAlignment: pw.CrossAxisAlignment.start,
    children: [
      pw.Center(
        child: pw.Text(
          title,
          style: pw.TextStyle(
              font: font,
              fontSize: 18,
              fontWeight: pw.FontWeight.bold,
              decoration: pw.TextDecoration.underline),
          textAlign: pw.TextAlign.left,
        ),
      ),
      pw.Row(
        mainAxisAlignment: pw.MainAxisAlignment.start,
        crossAxisAlignment: pw.CrossAxisAlignment.center,
        children: [
          pw.Container(
            width: 130,
            height: 200,
            child: pw.Stack(alignment: pw.Alignment.center, children: [
              pw.CustomPaint(
                size: PdfPoint(size, size),
                painter: (ctx, pdfSize) {
                  final center = PdfPoint(pdfSize.x / 2, pdfSize.y / 2);
                  double startAngle = -90.0;
                  for (int i = 0; i < values.length; i++) {
                    final sweep = 360 * (values[i] / total) - gapDegrees;
                    if (sweep <= 0) {
                      startAngle += 360 * (values[i] / total);
                      continue;
                    }
                    final arcStart =
                        _degreesToRadians(startAngle + gapDegrees / 2);
                    final arcEnd =
                        _degreesToRadians(startAngle + sweep + gapDegrees / 2);
                    final steps = (sweep.abs() / 2).ceil().clamp(2, 180);
                    ctx.setLineWidth(outerRadius - innerRadius);
                    ctx.setStrokeColor(colors[i % colors.length]);
                    ctx.setLineCap(PdfLineCap.round);
                    for (int s = 0; s <= steps; s++) {
                      final t = s / steps;
                      final angle = arcStart + (arcEnd - arcStart) * t;
                      final x = center.x + outerRadius * math.cos(angle);
                      final y = center.y + outerRadius * math.sin(angle);
                      if (s == 0) {
                        ctx.moveTo(x, y);
                      } else {
                        ctx.lineTo(x, y);
                      }
                    }
                    ctx.strokePath();

                    ctx.setLineWidth((outerRadius - innerRadius) * 0.18);
                    ctx.setStrokeColor(PdfColors.white);
                    ctx.setLineCap(PdfLineCap.round);
                    final sepAngle =
                        _degreesToRadians(startAngle + gapDegrees / 2);
                    final sepSteps = 6;
                    for (int s = 0; s <= sepSteps; s++) {
                      final t = s / sepSteps;
                      final angle = sepAngle + 0.01 * t; // short arc
                      final x = center.x + outerRadius * math.cos(angle);
                      final y = center.y + outerRadius * math.sin(angle);
                      if (s == 0) {
                        ctx.moveTo(x, y);
                      } else {
                        ctx.lineTo(x, y);
                      }
                    }
                    ctx.strokePath();
                    startAngle += 360 * (values[i] / total);
                  }

                  ctx.setFillColor(PdfColors.white);
                  ctx.drawEllipse(center.x, center.y, innerRadius, innerRadius);
                  ctx.fillPath();
                },
              ),
              pw.Center(
                  child: pw.Container(
                width: innerRadius * 1.6, // Adjust size as needed
                height: innerRadius * 1.6,
                child: glb.logoImage.value != null
                    ? pw.Image(pw.MemoryImage(glb.logoImage.value!.bytes))
                    : pw.Container(),
              ))
            ]),
          ),
          pw.SizedBox(width: 7),
          // Legend
          pw.Container(
            height: 200,
            width: 42,
            child: pw.Column(
              mainAxisAlignment: pw.MainAxisAlignment.center,
              crossAxisAlignment: pw.CrossAxisAlignment.start,
              children: [
                pw.SizedBox(height: 18),
                pw.Column(
                  mainAxisAlignment: pw.MainAxisAlignment.center,
                  crossAxisAlignment: pw.CrossAxisAlignment.start,
                  children: [
                    for (int i = 0; i < keys.length; i++)
                      pw.Padding(
                        padding: const pw.EdgeInsets.symmetric(vertical: 6),
                        child: pw.Row(
                          crossAxisAlignment: pw.CrossAxisAlignment.center,
                          children: [
                            pw.Container(
                              width: 10,
                              height: 10,
                              decoration: pw.BoxDecoration(
                                color: colors[i % colors.length],
                                borderRadius: pw.BorderRadius.circular(3),
                              ),
                            ),
                            pw.SizedBox(width: 4),
                            pw.Text(
                              keys[i],
                              style: pw.TextStyle(font: font, fontSize: 9),
                            ),
                            pw.SizedBox(width: 4),
                            pw.Text(
                              '${values[i].toStringAsFixed(1)}%',
                              style: pw.TextStyle(
                                  font: font,
                                  fontSize: 9,
                                  color: PdfColors.grey800),
                            ),
                          ],
                        ),
                      ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
      if (totalBoxes != null || totalWeight != null)
        pw.Padding(
          padding: const pw.EdgeInsets.only(top: 32),
          child: pw.Row(
            mainAxisAlignment: pw.MainAxisAlignment.spaceAround,
            children: [
              if (totalBoxes != null)
                pw.Text(
                  'Total Boxes: $totalBoxes',
                  style: pw.TextStyle(
                    font: font,
                    fontSize: 11,
                    fontWeight: pw.FontWeight.bold,
                    color: PdfColors.grey800,
                  ),
                ),
              pw.SizedBox(width: 2),
              if (totalWeight != null)
                pw.Text(
                  'Total Weight: ${totalWeight.toStringAsFixed(1)} kg',
                  style: pw.TextStyle(
                    font: font,
                    fontSize: 11,
                    fontWeight: pw.FontWeight.bold,
                    color: PdfColors.grey800,
                  ),
                ),
            ],
          ),
        ),
    ],
  );
}

Future<void> shareBilty(Bilty bilty,
    {required String websiteUrl,
    String? growerName,
    String? packhouseName,
    String? consignmentNo,
    String? aadhatiName,
    String? remark}) async {
  try {
    print(
        'shareBilty: categories count =  [38;5;2m${bilty.categories.length} [0m');
    for (var i = 0; i < bilty.categories.length; i++) {
      print('shareBilty: category[ [38;5;2m$i [0m] = ${bilty.categories[i]}');
    }
    if (bilty.categories.isEmpty) {
      print('shareBilty: No categories available in the bilty');
      throw Exception('No categories available in the bilty');
    }
    final font = await PdfGoogleFonts.tillanaMedium();
    // Load the image asset

    final logoBytes = await rootBundle.load('assets/images/bilty.png');
    final logoImage = pw.MemoryImage(logoBytes.buffer.asUint8List());
    final logo2Bytes = await rootBundle.load('assets/images/fas.png');
    final logo2Image = pw.MemoryImage(logo2Bytes.buffer.asUint8List());
    final aaaImageBytes = await loadImage(bilty.categories);
    final aaaImage = pw.MemoryImage(aaaImageBytes);
    final pdf = pw.Document();
    // --- Donut chart data logic (copied from controller) ---
    double totalWeight =
        bilty.categories.fold(0.0, (sum, c) => sum + c.totalWeight);
    Map<String, double> qualityShare = {'AAA': 0, 'AA': 0, 'GP': 0};
    Map<String, int> qualityBoxCount = {'AAA': 0, 'AA': 0, 'GP': 0};
    if (totalWeight > 0) {
      for (var q in ['AAA', 'AA', 'GP']) {
        final weight = bilty.categories
            .where((c) => c.quality == q)
            .fold(0.0, (prev, e) => prev + e.totalWeight);
        qualityShare[q] = weight / totalWeight * 100;
        qualityBoxCount[q] = bilty.categories
            .where((c) => c.quality == q)
            .fold(0, (prev, e) => prev + e.boxCount);
      }
    }
    // AAA category share
    final aaaCategories =
        bilty.categories.where((c) => c.quality == 'AAA').toList();
    final totalAAAWeight =
        aaaCategories.fold(0.0, (sum, e) => sum + e.totalWeight);
    Map<String, double> aaaCategoryShare = {
      'ELLMS': 0,
      'ES,EES,240': 0,
      'Pittu': 0,
      'Seprator': 0,
    };
    Map<String, int> aaaCatBoxCount = {
      'ELLMS': 0,
      'ES,EES,240': 0,
      'Pittu': 0,
      'Seprator': 0,
    };
    if (totalAAAWeight > 0) {
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
      aaaCategoryShare['ELLMS'] = aaaCategories
              .where((c) => ellmsCategories.contains(c.category))
              .fold(0.0, (sum, e) => sum + e.totalWeight) /
          totalAAAWeight *
          100;
      aaaCategoryShare['ES,EES,240'] = aaaCategories
              .where((c) => esEes240Categories.contains(c.category))
              .fold(0.0, (sum, e) => sum + e.totalWeight) /
          totalAAAWeight *
          100;
      aaaCategoryShare['Pittu'] = aaaCategories
              .where((c) => pittuCategories.contains(c.category))
              .fold(0.0, (sum, e) => sum + e.totalWeight) /
          totalAAAWeight *
          100;
      aaaCategoryShare['Seprator'] = aaaCategories
              .where((c) => separatorCategories.contains(c.category))
              .fold(0.0, (sum, e) => sum + e.totalWeight) /
          totalAAAWeight *
          100;
      // Clamp and normalize
      aaaCategoryShare.updateAll((k, v) => v.clamp(0, 100));
      final totalPercent = aaaCategoryShare.values.fold(0.0, (a, b) => a + b);
      if (totalPercent > 0 && (totalPercent - 100).abs() > 0.01) {
        aaaCategoryShare.updateAll((k, v) => v / totalPercent * 100);
      }
      // Box count for each AAA subcategory
      aaaCatBoxCount['ELLMS'] = aaaCategories
          .where((c) => ellmsCategories.contains(c.category))
          .fold(0, (sum, e) => sum + e.boxCount);
      aaaCatBoxCount['ES,EES,240'] = aaaCategories
          .where((c) => esEes240Categories.contains(c.category))
          .fold(0, (sum, e) => sum + e.boxCount);
      aaaCatBoxCount['Pittu'] = aaaCategories
          .where((c) => pittuCategories.contains(c.category))
          .fold(0, (sum, e) => sum + e.boxCount);
      aaaCatBoxCount['Seprator'] = aaaCategories
          .where((c) => separatorCategories.contains(c.category))
          .fold(0, (sum, e) => sum + e.boxCount);
    }
    // PDF colors for charts
    final qualityColors = [
      PdfColors.red,
      PdfColors.yellow,
      PdfColors.green,
    ];
    final aaaCatColors = [
      PdfColors.blue,
      PdfColors.orange,
      PdfColors.purple,
      PdfColors.amber,
    ];
    final aaCategories =
        bilty.categories.where((c) => c.quality == 'AA').toList();
    final totalAAWeight =
        aaCategories.fold(0.0, (sum, e) => sum + e.totalWeight);
    DateTime now = DateTime.now();

    String date = "${now.day}/${now.month}/${now.year}";

    Map<String, double> aaCatMap = {
      'ELLMS': 0,
      'ES,EES,240': 0,
      'Pittu': 0,
      'Seprator': 0,
    };
    Map<String, int> aaCatBoxCount = {
      'ELLMS': 0,
      'ES,EES,240': 0,
      'Pittu': 0,
      'Seprator': 0,
    };

    if (totalAAWeight > 0) {
      // Define the same sub-categories as AAA.
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

      // Calculate weight share for each AA subcategory
      aaCatMap['ELLMS'] = aaCategories
              .where((c) => ellmsCategories.contains(c.category))
              .fold(0.0, (sum, e) => sum + e.totalWeight) /
          totalAAWeight *
          100;
      aaCatMap['ES,EES,240'] = aaCategories
              .where((c) => esEes240Categories.contains(c.category))
              .fold(0.0, (sum, e) => sum + e.totalWeight) /
          totalAAWeight *
          100;
      aaCatMap['Pittu'] = aaCategories
              .where((c) => pittuCategories.contains(c.category))
              .fold(0.0, (sum, e) => sum + e.totalWeight) /
          totalAAWeight *
          100;
      aaCatMap['Seprator'] = aaCategories
              .where((c) => separatorCategories.contains(c.category))
              .fold(0.0, (sum, e) => sum + e.totalWeight) /
          totalAAWeight *
          100;

      // Clamp and normalize percentages
      aaCatMap.updateAll((k, v) => v.clamp(0, 100));
      final totalPercent = aaCatMap.values.fold(0.0, (a, b) => a + b);
      if (totalPercent > 0 && (totalPercent - 100).abs() > 0.01) {
        aaCatMap.updateAll((k, v) => v / totalPercent * 100);
      }

      // Calculate box count for each AA subcategory
      aaCatBoxCount['ELLMS'] = aaCategories
          .where((c) => ellmsCategories.contains(c.category))
          .fold(0, (sum, e) => sum + e.boxCount);
      aaCatBoxCount['ES,EES,240'] = aaCategories
          .where((c) => esEes240Categories.contains(c.category))
          .fold(0, (sum, e) => sum + e.boxCount);
      aaCatBoxCount['Pittu'] = aaCategories
          .where((c) => pittuCategories.contains(c.category))
          .fold(0, (sum, e) => sum + e.boxCount);
      aaCatBoxCount['Seprator'] = aaCategories
          .where((c) => separatorCategories.contains(c.category))
          .fold(0, (sum, e) => sum + e.boxCount);
    }

    // Using a fixed set of colors for consistency, similar to AAA.
    final aaCatColors = [
      PdfColors.blue,
      PdfColors.orange,
      PdfColors.purple,
      PdfColors.amber,
    ];

    final gpCategories =
        bilty.categories.where((c) => c.quality == 'GP').toList();
    final gpCatMap = <String, double>{};
    final gpCatBoxCount = <String, int>{};
    final totalGPWeight =
        gpCategories.fold(0.0, (sum, e) => sum + e.totalWeight);
    for (final c in gpCategories) {
      if (c.totalWeight > 0) {
        gpCatMap[c.category] = (c.totalWeight / totalGPWeight) * 100;
        gpCatBoxCount[c.category] = c.boxCount;
      }
    }
    final gpCatColors = List<PdfColor>.generate(gpCatMap.length,
        (i) => PdfColors.accents[i % PdfColors.accents.length]);

    pdf.addPage(
      pw.MultiPage(
        pageFormat: PdfPageFormat.a4,
        build: (pw.Context context) => [
          pw.Stack(children: [
            // 🔹 Watermark layer
            pw.Column(children: [
              // Header: logo left, title right
              pw.Row(
                crossAxisAlignment: pw.CrossAxisAlignment.center,
                children: [
                  pw.Container(
                    width: 80,
                    height: 60,
                    child: pw.Image(logoImage),
                  ),
                  pw.Expanded(child: pw.SizedBox(width: 16)),
                  pw.Container(
                      height: 60,
                      child: pw.Column(children: [
                        pw.Text(
                          'FasCorp',
                          style: pw.TextStyle(
                            font: font,
                            fontSize: 18,
                            fontWeight: pw.FontWeight.bold,
                            color: PdfColors.green,
                          ),
                          textAlign: pw.TextAlign.right,
                        ),
                        pw.SizedBox(height: 2),
                        pw.Text(
                          "Farming as a Service Initiative",
                          style: pw.TextStyle(
                            font: font,
                            fontSize: 14,
                            fontWeight: pw.FontWeight.bold,
                            color: PdfColors.green,
                          ),
                        ),
                        pw.SizedBox(height: 6),
                      ])),
                  pw.Expanded(child: pw.SizedBox(width: 16)),
                  pw.Container(
                    height: 60,
                    width: 120,
                    child: pw.Center(child: pw.Image(logo2Image)),
                  )
                ],
              ),
              pw.SizedBox(height: 4),
              pw.Divider(color: PdfColors.black, height: 1),
              pw.SizedBox(height: 2),
              pw.Row(children: [
                pw.Padding(
                    padding: pw.EdgeInsets.symmetric(vertical: 4),
                    child: pw.Container(
                        width: 220,
                        height: 80,
                        padding: pw.EdgeInsets.all(4),
                        child: pw.Column(
                            mainAxisAlignment: pw.MainAxisAlignment.spaceAround,
                            crossAxisAlignment: pw.CrossAxisAlignment.start,
                            children: [
                              if (consignmentNo != null &&
                                  consignmentNo.isNotEmpty)
                                pw.Center(
                                  child: pw.Text(
                                      'Consignment No.: $consignmentNo',
                                      style: pw.TextStyle(
                                          font: font,
                                          fontSize: 12,
                                          fontWeight: pw.FontWeight.bold)),
                                ),
                              if (growerName != null && growerName.isNotEmpty)
                                pw.Text('Grower: ${growerName}',
                                    style:
                                        pw.TextStyle(font: font, fontSize: 12)),
                              if (packhouseName != null &&
                                  packhouseName.isNotEmpty)
                                pw.Text('Packhouse: $packhouseName',
                                    style:
                                        pw.TextStyle(font: font, fontSize: 12)),
                            ]))),
                pw.SizedBox(width: 15),
                if (remark!.isNotEmpty)
                  pw.Padding(
                      padding: pw.EdgeInsets.only(top: 4, left: 4, bottom: 4),
                      child: pw.Container(
                          width: 230,
                          height: 80,
                          padding: pw.EdgeInsets.only(top: 4, left: 4),
                          child: pw.Column(
                              crossAxisAlignment: pw.CrossAxisAlignment.start,
                              children: [
                                pw.Center(
                                  child: pw.Text('Remarks',
                                      style: pw.TextStyle(
                                          font: font,
                                          fontSize: 12,
                                          fontWeight: pw.FontWeight.bold,
                                          decoration:
                                              pw.TextDecoration.underline,
                                          color: PdfColors.red)),
                                ),
                                pw.SizedBox(height: 2),
                                pw.Text("${remark}",
                                    textAlign: pw.TextAlign.justify,
                                    style:
                                        pw.TextStyle(font: font, fontSize: 10))
                              ]))),
                pw.SizedBox(height: 16),
              ]),
              // Table
              pw.Table(
                border: pw.TableBorder.all(),
                children: [
                  pw.TableRow(
                    decoration: pw.BoxDecoration(
                      color: getPdfHeaderColor(),
                    ),
                    children: [
                      _buildHeaderCell('Quality', font,
                          align: pw.TextAlign.center),
                      _buildHeaderCell('Category', font,
                          align: pw.TextAlign.center),
                      _buildHeaderCell('Variety', font,
                          align: pw.TextAlign.center),
                      _buildHeaderCell('Count', font,
                          align: pw.TextAlign.center),
                      _buildHeaderCell('Gross Box Weight', font,
                          align: pw.TextAlign.center),
                      _buildHeaderCell('No. of Boxes', font,
                          align: pw.TextAlign.center),
                      _buildHeaderCell('Total Weight', font,
                          align: pw.TextAlign.center),
                    ],
                  ),
                  ...bilty.categories
                      .where((category) => category.boxCount > 0)
                      .map((category) => pw.TableRow(
                            decoration: pw.BoxDecoration(
                                color: getPdfRowColor(category.quality)),
                            children: [
                              _buildDataCell(category.quality, font,
                                  align: pw.TextAlign.center),
                              _buildDataCell(category.category, font,
                                  align: pw.TextAlign.center),
                              _buildDataCell(category.variety, font,
                                  align: pw.TextAlign.center),
                              _buildDataCell(
                                  category.piecesPerBox.toString(), font,
                                  align: pw.TextAlign.center),
                              _buildDataCell(
                                  '${category.avgBoxWeight.toStringAsFixed(1)}kg',
                                  font,
                                  align: pw.TextAlign.center),
                              _buildDataCell('${category.boxCount}', font,
                                  align: pw.TextAlign.center),
                              _buildDataCell(
                                  '${category.totalWeight.toStringAsFixed(1)}kg',
                                  font,
                                  align: pw.TextAlign.center),
                            ],
                          )),
                ],
              ),
              pw.SizedBox(height: 18),
              // App download text
              pw.Center(
                child: pw.Row(
                  mainAxisSize: pw.MainAxisSize.min,
                  children: [
                    pw.Text(
                      'For viewing Images download the app: ',
                      style: pw.TextStyle(
                          font: font, fontSize: 14, color: PdfColors.blueGrey),
                    ),
                    pw.UrlLink(
                      destination: websiteUrl,
                      child: pw.Text(
                        websiteUrl,
                        style: pw.TextStyle(
                          color: PdfColors.blue,
                          decoration: pw.TextDecoration.underline,
                          font: font,
                          fontSize: 14,
                        ),
                      ),
                    ),
                  ],
                ),
              )
            ]),
            pw.Positioned.fill(
              child: pw.Center(
                child: pw.Transform.rotate(
                  angle: -0.5, // Rotate watermark
                  child: pw.Opacity(
                    opacity: 0.5,
                    child: pw.Text(
                      'FASCORP',
                      style: pw.TextStyle(
                        fontSize: 80,
                        color: PdfColors.grey,
                        fontWeight: pw.FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ]),
        ],
      ),
    );
    // Add a second page for the charts (2x2 grid)
    pdf.addPage(
      pw.Page(
        pageFormat: PdfPageFormat.a4,
        build: (pw.Context context) => pw.Stack(children: [
          // 🔹 Watermark layer
          pw.Center(
            child: pw.Column(
              mainAxisAlignment: pw.MainAxisAlignment.center,
              children: [
                pw.Center(
                  child: pw.Text("Bilty Distribution Graphs",
                      style: pw.TextStyle(fontSize: 22)),
                ),
                pw.Divider(color: PdfColors.black),
                pw.SizedBox(height: 16),
                pw.Row(
                  mainAxisAlignment: pw.MainAxisAlignment.center,
                  crossAxisAlignment: pw.CrossAxisAlignment.start,
                  children: [
                    pw.Expanded(
                        child: buildDonutChartPdf(
                      data: qualityShare,
                      colors: [
                        PdfColors.red,
                        PdfColors.yellow,
                        PdfColors.green
                      ],
                      title: 'Overall',
                      font: font,
                      size: 100,
                      arcWidth: 40,
                      gapDegrees: 4,
                      drawLegendLines: false,
                      totalBoxes: qualityBoxCount.values
                          .fold(0, (sum, v) => (sum ?? 0) + (v ?? 0)),
                      totalWeight: totalWeight,
                    )),
                    pw.SizedBox(width: 24),
                    pw.Expanded(
                        child: buildDonutChartPdf(
                      data: aaaCategoryShare,
                      colors: [
                        PdfColors.blue,
                        PdfColors.orange,
                        PdfColors.purple,
                        PdfColors.amber
                      ],
                      title: 'AAA',
                      font: font,
                      size: 100,
                      arcWidth: 40,
                      gapDegrees: 4,
                      drawLegendLines: false,
                      totalBoxes: aaaCatBoxCount.values
                          .fold(0, (sum, v) => (sum ?? 0) + (v ?? 0)),
                      totalWeight: totalAAAWeight,
                    )),
                  ],
                ),
                pw.SizedBox(height: 16),
                pw.Divider(color: PdfColors.black),
                pw.SizedBox(height: 16),
                pw.Row(
                  mainAxisAlignment: pw.MainAxisAlignment.center,
                  crossAxisAlignment: pw.CrossAxisAlignment.start,
                  children: [
                    pw.Expanded(
                      child: buildDonutChartPdf(
                        data: aaCatMap,
                        colors: aaCatColors,
                        title: 'AA',
                        font: font,
                        size: 100,
                        arcWidth: 40,
                        gapDegrees: 4,
                        drawLegendLines: false,
                        totalBoxes: aaCatBoxCount.values
                            .fold(0, (sum, v) => (sum ?? 0) + (v ?? 0)),
                        totalWeight: totalAAWeight,
                      ),
                    ),
                    pw.SizedBox(width: 24),
                    pw.Expanded(
                      child: buildDonutChartPdf(
                        data: gpCatMap,
                        colors: gpCatColors,
                        title: 'GP',
                        font: font,
                        size: 100,
                        arcWidth: 40,
                        gapDegrees: 4,
                        drawLegendLines: false,
                        totalBoxes: gpCatBoxCount.values
                            .fold(0, (sum, v) => (sum ?? 0) + (v ?? 0)),
                        totalWeight: totalGPWeight,
                      ),
                    ),
                  ],
                ),
                pw.SizedBox(height: 12),
              ],
            ),
          ),
          pw.Positioned.fill(
            child: pw.Center(
              child: pw.Transform.rotate(
                angle: -0.5, // Rotate watermark
                child: pw.Opacity(
                  opacity: 0.5,
                  child: pw.Text(
                    'FASCORP',
                    style: pw.TextStyle(
                      fontSize: 80,
                      color: PdfColors.grey,
                      fontWeight: pw.FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ),
          ),
        ]),
      ),
    );
    pdf.addPage(pw.Page(
      pageFormat: PdfPageFormat.a4,
      build: (pw.Context context) => pw.Stack(children: [
        // 🔹 Watermark layer
        pw.Center(
          child: pw.Column(
            mainAxisAlignment: pw.MainAxisAlignment.center,
            children: [
              pw.Center(
                child: pw.Text("Bilty Distribution Graphs",
                    style: pw.TextStyle(fontSize: 22)),
              ),
              pw.Divider(color: PdfColors.black),
              pw.SizedBox(height: 20),
              pw.Row(
                  mainAxisAlignment: pw.MainAxisAlignment.center,
                  crossAxisAlignment: pw.CrossAxisAlignment.start,
                  children: [
                    pw.Container(
                      width: 480,
                      child: pw.Image(aaaImage, fit: pw.BoxFit.contain),
                    ),
                  ]),
              pw.SizedBox(height: 20),
              pw.SizedBox(height: 60),
              pw.Container(
                  child: pw.Text(
                      textAlign: pw.TextAlign.justify,
                      "The Boxes in this Consignment no ${consignmentNo!} has been packed in ${packhouseName!} Pack House under my observation /Supervision for any kind of Human errors while packing more than 5% I take full responsibility of the consignment.")),
              pw.SizedBox(height: 10),
              pw.Column(
                  crossAxisAlignment: pw.CrossAxisAlignment.end,
                  children: [
                    pw.Row(
                        mainAxisAlignment: pw.MainAxisAlignment.end,
                        children: [
                          pw.Text(
                            growerName!,
                            style: pw.TextStyle(fontSize: 12),
                          )
                        ]),
                    pw.Row(
                        mainAxisAlignment: pw.MainAxisAlignment.end,
                        children: [
                          pw.Text("${date}", style: pw.TextStyle(fontSize: 10))
                        ]),
                  ]),
              pw.Container(height: 45),
              pw.Divider(color: PdfColors.black, height: 1),
              pw.SizedBox(height: 4),
              pw.Center(
                child: pw.Text(
                    "Copyright © Dev Bhardwaj 2025. All rights reserved.\n No part of this work shall be copied by any device-mechanical, electronic or other, stored in a retrieval system or transmitted in any form or any means without prior permission",
                    textAlign: pw.TextAlign.center,
                    softWrap: true,
                    maxLines: 3,
                    style: pw.TextStyle(fontSize: 8)),
              )
            ],
          ),
        ),
      ]),
    ));

    final pdfBytes = await pdf.save();
    final fileName = (consignmentNo != null && consignmentNo.isNotEmpty)
        ? '$consignmentNo.pdf'
        : 'bilty_step2.pdf';
    if (kIsWeb) {
      await Printing.sharePdf(bytes: pdfBytes, filename: fileName);
    } else {
      final tempDir = Directory.systemTemp;
      final file = File('${tempDir.path}/$fileName');
      await file.writeAsBytes(pdfBytes);
      await Share.shareXFiles([XFile(file.path)],
          text: 'Bilty PDF\n$websiteUrl');
    }
  } catch (e) {
    print('Error generating PDF: $e');
    rethrow;
  }
}

pw.Widget _buildEnhancedHeaderCell(String text, pw.Font font) {
  return pw.Container(
    padding: const pw.EdgeInsets.all(12),
    decoration: const pw.BoxDecoration(
      border: pw.Border(
        right: pw.BorderSide(color: PdfColors.black, width: 1.0),
      ),
    ),
    child: pw.Text(
      text,
      style: pw.TextStyle(
        font: font,
        fontSize: 11,
        color: PdfColors.black,
        fontWeight: pw.FontWeight.bold,
      ),
      textAlign: pw.TextAlign.center,
      maxLines: 1,
      overflow: pw.TextOverflow.clip,
    ),
  );
}

pw.Widget _buildEnhancedDataCell(String text, pw.Font font) {
  return pw.Container(
    padding: const pw.EdgeInsets.all(12),
    decoration: const pw.BoxDecoration(
      border: pw.Border(
        right: pw.BorderSide(color: PdfColors.black, width: 1.0),
      ),
    ),
    child: pw.Text(
      text,
      style: pw.TextStyle(
        font: font,
        fontSize: 10,
        color: PdfColors.white,
        fontWeight: pw.FontWeight.normal,
      ),
      textAlign: pw.TextAlign.center,
      overflow: pw.TextOverflow.clip,
    ),
  );
}



pw.Widget _buildHeaderCell(String text, pw.Font font,
    {pw.TextAlign align = pw.TextAlign.center}) {
  return pw.Container(
    alignment: pw.Alignment.center,
    padding: const pw.EdgeInsets.all(4),
    child: pw.Transform.rotate(
      angle:
          -270 * math.pi / 180, // Rotate 90° counterclockwise (bottom to top)
      child: pw.Container(
        width: 50,
        height: 52, // You can tweak this depending on your layout
        child: pw.Center(
            child: pw.Text(
          text,
          textAlign: align,
          softWrap: true,
          style: pw.TextStyle(
            fontWeight: pw.FontWeight.bold,
            font: font,
          ),
        )),
      ),
    ),
  );
}

pw.Widget _buildDataCell(String text, pw.Font font,
    {pw.TextAlign align = pw.TextAlign.center}) {
  return pw.Padding(
    padding: const pw.EdgeInsets.all(2),
    child: pw.Text(text,
        textAlign: align,
        style: pw.TextStyle(color: PdfColors.white, font: font, fontSize: 10)),
  );
}

Future<void> downloadBiltyGrower(Bilty bilty,
    {required String websiteUrl,
    String? growerName,
    String? packhouseName,
    String? consignmentNo,
    String? aadhatiName,
    String? remark}) async {
  try {
    Get.defaultDialog(
      // Prevent the user from closing the dialog accidentally
      barrierDismissible: false,

      // Title with improved styling
      title: "Downloading",
      titleStyle: const TextStyle(
        fontWeight: FontWeight.bold,
        fontSize: 18,
      ),

      // Give the dialog rounded corners
      radius: 15.0,

      // Content with better spacing and text alignment
      content: const Column(
        mainAxisSize: MainAxisSize.min, // Ensures the dialog is not unnecessarily tall
        children: [
          CircularProgressIndicator(
            color: Colors.blueAccent,
            strokeWidth: 3.5,
          ),
          SizedBox(height: 20),
          Text(
            "This may take up to 60 seconds. Please wait.",
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 15),
          ),
        ],
      ),
    );
    print(
        'shareBilty: categories count =  [38;5;2m${bilty.categories.length} [0m');
    for (var i = 0; i < bilty.categories.length; i++) {
      print('shareBilty: category[ [38;5;2m$i [0m] = ${bilty.categories[i]}');
    }
    if (bilty.categories.isEmpty) {
      print('shareBilty: No categories available in the bilty');
      throw Exception('No categories available in the bilty');
    }
    final font = await PdfGoogleFonts.tillanaMedium();
    // Load the image asset

    final logoBytes = await rootBundle.load('assets/images/bilty.png');
    final logoImage = pw.MemoryImage(logoBytes.buffer.asUint8List());
    final logo2Bytes = await rootBundle.load('assets/images/fas.png');
    final logo2Image = pw.MemoryImage(logo2Bytes.buffer.asUint8List());
    final aaaImageBytes = await loadGrowerImage(bilty.categories);
    final aaaImage = pw.MemoryImage(aaaImageBytes);
    final pdf = pw.Document();
    // --- Donut chart data logic (copied from controller) ---
    double totalWeight =
        bilty.categories.fold(0.0, (sum, c) => sum + c.totalWeight);
    Map<String, double> qualityShare = {'AAA': 0, 'AA': 0, 'GP': 0};
    Map<String, int> qualityBoxCount = {'AAA': 0, 'AA': 0, 'GP': 0};
    if (totalWeight > 0) {
      for (var q in ['AAA', 'AA', 'GP']) {
        final weight = bilty.categories
            .where((c) => c.quality == q)
            .fold(0.0, (prev, e) => prev + e.totalWeight);
        qualityShare[q] = weight / totalWeight * 100;
        qualityBoxCount[q] = bilty.categories
            .where((c) => c.quality == q)
            .fold(0, (prev, e) => prev + e.boxCount);
      }
    }
    // AAA category share
    final aaaCategories =
        bilty.categories.where((c) => c.quality == 'AAA').toList();
    final totalAAAWeight =
        aaaCategories.fold(0.0, (sum, e) => sum + e.totalWeight);
    Map<String, double> aaaCategoryShare = {
      'ELLMS': 0,
      'ES,EES,240': 0,
      'Pittu': 0,
      'Seprator': 0,
    };
    Map<String, int> aaaCatBoxCount = {
      'ELLMS': 0,
      'ES,EES,240': 0,
      'Pittu': 0,
      'Seprator': 0,
    };
    if (totalAAAWeight > 0) {
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
      aaaCategoryShare['ELLMS'] = aaaCategories
              .where((c) => ellmsCategories.contains(c.category))
              .fold(0.0, (sum, e) => sum + e.totalWeight) /
          totalAAAWeight *
          100;
      aaaCategoryShare['ES,EES,240'] = aaaCategories
              .where((c) => esEes240Categories.contains(c.category))
              .fold(0.0, (sum, e) => sum + e.totalWeight) /
          totalAAAWeight *
          100;
      aaaCategoryShare['Pittu'] = aaaCategories
              .where((c) => pittuCategories.contains(c.category))
              .fold(0.0, (sum, e) => sum + e.totalWeight) /
          totalAAAWeight *
          100;
      aaaCategoryShare['Seprator'] = aaaCategories
              .where((c) => separatorCategories.contains(c.category))
              .fold(0.0, (sum, e) => sum + e.totalWeight) /
          totalAAAWeight *
          100;
      // Clamp and normalize
      aaaCategoryShare.updateAll((k, v) => v.clamp(0, 100));
      final totalPercent = aaaCategoryShare.values.fold(0.0, (a, b) => a + b);
      if (totalPercent > 0 && (totalPercent - 100).abs() > 0.01) {
        aaaCategoryShare.updateAll((k, v) => v / totalPercent * 100);
      }
      // Box count for each AAA subcategory
      aaaCatBoxCount['ELLMS'] = aaaCategories
          .where((c) => ellmsCategories.contains(c.category))
          .fold(0, (sum, e) => sum + e.boxCount);
      aaaCatBoxCount['ES,EES,240'] = aaaCategories
          .where((c) => esEes240Categories.contains(c.category))
          .fold(0, (sum, e) => sum + e.boxCount);
      aaaCatBoxCount['Pittu'] = aaaCategories
          .where((c) => pittuCategories.contains(c.category))
          .fold(0, (sum, e) => sum + e.boxCount);
      aaaCatBoxCount['Seprator'] = aaaCategories
          .where((c) => separatorCategories.contains(c.category))
          .fold(0, (sum, e) => sum + e.boxCount);
    }
    // PDF colors for charts
    final qualityColors = [
      PdfColors.red,
      PdfColors.yellow,
      PdfColors.green,
    ];
    final aaaCatColors = [
      PdfColors.blue,
      PdfColors.orange,
      PdfColors.purple,
      PdfColors.amber,
    ];
    final aaCategories =
        bilty.categories.where((c) => c.quality == 'AA').toList();
    final totalAAWeight =
        aaCategories.fold(0.0, (sum, e) => sum + e.totalWeight);
    DateTime now = DateTime.now();

    String date = "${now.day}/${now.month}/${now.year}";

    Map<String, double> aaCatMap = {
      'ELLMS': 0,
      'ES,EES,240': 0,
      'Pittu': 0,
      'Seprator': 0,
    };
    Map<String, int> aaCatBoxCount = {
      'ELLMS': 0,
      'ES,EES,240': 0,
      'Pittu': 0,
      'Seprator': 0,
    };

    if (totalAAWeight > 0) {
      // Define the same sub-categories as AAA.
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

      // Calculate weight share for each AA subcategory
      aaCatMap['ELLMS'] = aaCategories
              .where((c) => ellmsCategories.contains(c.category))
              .fold(0.0, (sum, e) => sum + e.totalWeight) /
          totalAAWeight *
          100;
      aaCatMap['ES,EES,240'] = aaCategories
              .where((c) => esEes240Categories.contains(c.category))
              .fold(0.0, (sum, e) => sum + e.totalWeight) /
          totalAAWeight *
          100;
      aaCatMap['Pittu'] = aaCategories
              .where((c) => pittuCategories.contains(c.category))
              .fold(0.0, (sum, e) => sum + e.totalWeight) /
          totalAAWeight *
          100;
      aaCatMap['Seprator'] = aaCategories
              .where((c) => separatorCategories.contains(c.category))
              .fold(0.0, (sum, e) => sum + e.totalWeight) /
          totalAAWeight *
          100;

      // Clamp and normalize percentages
      aaCatMap.updateAll((k, v) => v.clamp(0, 100));
      final totalPercent = aaCatMap.values.fold(0.0, (a, b) => a + b);
      if (totalPercent > 0 && (totalPercent - 100).abs() > 0.01) {
        aaCatMap.updateAll((k, v) => v / totalPercent * 100);
      }

      // Calculate box count for each AA subcategory
      aaCatBoxCount['ELLMS'] = aaCategories
          .where((c) => ellmsCategories.contains(c.category))
          .fold(0, (sum, e) => sum + e.boxCount);
      aaCatBoxCount['ES,EES,240'] = aaCategories
          .where((c) => esEes240Categories.contains(c.category))
          .fold(0, (sum, e) => sum + e.boxCount);
      aaCatBoxCount['Pittu'] = aaCategories
          .where((c) => pittuCategories.contains(c.category))
          .fold(0, (sum, e) => sum + e.boxCount);
      aaCatBoxCount['Seprator'] = aaCategories
          .where((c) => separatorCategories.contains(c.category))
          .fold(0, (sum, e) => sum + e.boxCount);
    }

    // Using a fixed set of colors for consistency, similar to AAA.
    final aaCatColors = [
      PdfColors.blue,
      PdfColors.orange,
      PdfColors.purple,
      PdfColors.amber,
    ];

    final gpCategories =
        bilty.categories.where((c) => c.quality == 'GP').toList();
    final gpCatMap = <String, double>{};
    final gpCatBoxCount = <String, int>{};
    final totalGPWeight =
        gpCategories.fold(0.0, (sum, e) => sum + e.totalWeight);
    for (final c in gpCategories) {
      if (c.totalWeight > 0) {
        gpCatMap[c.category] = (c.totalWeight / totalGPWeight) * 100;
        gpCatBoxCount[c.category] = c.boxCount;
      }
    }
    final gpCatColors = List<PdfColor>.generate(gpCatMap.length,
        (i) => PdfColors.accents[i % PdfColors.accents.length]);

    final int totalBoxes =
    bilty.categories.fold(0, (sum, item) => sum + item.boxCount);
    final double grandTotalWeight =
    bilty.categories.fold(0.0, (sum, item) => sum + item.totalWeight);
    final double grandTotalPrice =
    bilty.categories.fold(0.0, (sum, item) => sum + item.totalPrice);

    // Find the 'AAA' 'Extra Large' category to get the bidding price.
    final aaaELCategory = bilty.categories.firstWhere(
          (c) => c.quality == 'AAA' && c.category == 'Extra Large',
    );
    final double biddingPrice = aaaELCategory.pricePerKg;

    pdf.addPage(
      pw.MultiPage(
        pageFormat: PdfPageFormat.a4,
        build: (pw.Context context) => [
          pw.Stack(children: [
            // 🔹 Watermark layer
            pw.Column(children: [
              // Header: logo left, title right
              pw.Row(
                crossAxisAlignment: pw.CrossAxisAlignment.center,
                children: [
                  pw.Container(
                    width: 80,
                    height: 60,
                    child: pw.Image(logoImage),
                  ),
                  pw.Expanded(child: pw.SizedBox(width: 16)),
                  pw.Container(
                      height: 60,
                      child: pw.Column(children: [
                        pw.Text(
                          'FasCorp',
                          style: pw.TextStyle(
                            font: font,
                            fontSize: 18,
                            fontWeight: pw.FontWeight.bold,
                            color: PdfColors.green,
                          ),
                          textAlign: pw.TextAlign.right,
                        ),
                        pw.SizedBox(height: 2),
                        pw.Text(
                          "Farming as a Service Initiative",
                          style: pw.TextStyle(
                            font: font,
                            fontSize: 14,
                            fontWeight: pw.FontWeight.bold,
                            color: PdfColors.green,
                          ),
                        ),
                        pw.SizedBox(height: 6),
                      ])),
                  pw.Expanded(child: pw.SizedBox(width: 16)),
                  pw.Container(
                    height: 60,
                    width: 120,
                    child: pw.Center(child: pw.Image(logo2Image)),
                  )
                ],
              ),
              pw.SizedBox(height: 4),
              pw.Divider(color: PdfColors.black, height: 1),
              pw.SizedBox(height: 2),
              pw.Row(children: [
                pw.Padding(
                    padding: pw.EdgeInsets.symmetric(vertical: 4),
                    child: pw.Container(
                        width: 220,
                        height: 80,
                        padding: pw.EdgeInsets.all(4),
                        child: pw.Column(
                            mainAxisAlignment: pw.MainAxisAlignment.spaceAround,
                            crossAxisAlignment: pw.CrossAxisAlignment.start,
                            children: [
                              if (consignmentNo != null &&
                                  consignmentNo.isNotEmpty)
                                pw.Center(
                                  child: pw.Text(
                                      'Consignment No.: $consignmentNo',
                                      style: pw.TextStyle(
                                          font: font,
                                          fontSize: 12,
                                          fontWeight: pw.FontWeight.bold)),
                                ),
                              if (growerName != null && growerName.isNotEmpty)
                                pw.Text('Grower: ${growerName}',
                                    style:
                                        pw.TextStyle(font: font, fontSize: 12)),
                            ]))),
                pw.SizedBox(width: 15),
                pw.Padding(
                    padding: pw.EdgeInsets.symmetric(vertical: 4),
                    child: pw.Container(
                        width: 220,
                        height: 80,
                        padding: pw.EdgeInsets.all(4),
                        child: pw.Column(
                            mainAxisAlignment: pw.MainAxisAlignment.spaceAround,
                            crossAxisAlignment: pw.CrossAxisAlignment.start,
                            children: [
                              if (packhouseName != null &&
                                  packhouseName.isNotEmpty)
                                pw.Text('Packhouse: $packhouseName',
                                    style:
                                    pw.TextStyle(font: font, fontSize: 12)),
                              if (aadhatiName != null &&
                                  aadhatiName.isNotEmpty)
                                pw.Text('Aadhati: $aadhatiName',
                                    style:
                                    pw.TextStyle(font: font, fontSize: 12)),
                            ]))),
                pw.SizedBox(height: 16),
              ]),
              // Table
              pw.Table(
                border: pw.TableBorder.all(),
                children: [
                  pw.TableRow(
                    decoration: pw.BoxDecoration(
                      color: getPdfHeaderColor(),
                    ),
                    children: [
                      _buildHeaderCell('Quality', font,
                          align: pw.TextAlign.center),
                      _buildHeaderCell('Category', font,
                          align: pw.TextAlign.center),
                      _buildHeaderCell('Variety', font,
                          align: pw.TextAlign.center),
                      _buildHeaderCell('Count', font,
                          align: pw.TextAlign.center),
                      _buildHeaderCell('Gross Weight', font,
                          align: pw.TextAlign.center),
                      _buildHeaderCell('No. of Boxes', font,
                          align: pw.TextAlign.center),
                      _buildHeaderCell('Total Weight', font,
                          align: pw.TextAlign.center),
                      _buildHeaderCell('Price per Kg', font,
                          align: pw.TextAlign.center),
                      _buildHeaderCell('Total Price', font,
                          align: pw.TextAlign.center),
                    ],
                  ),
                  ...bilty.categories
                      .where((category) => category.boxCount > 0)
                      .map((category) => pw.TableRow(
                            decoration: pw.BoxDecoration(
                                color: getPdfRowColor(category.quality)),
                            children: [
                              _buildDataCell(category.quality, font,
                                  align: pw.TextAlign.center),
                              _buildDataCell(category.category, font,
                                  align: pw.TextAlign.center),
                              _buildDataCell(category.variety, font,
                                  align: pw.TextAlign.center),
                              _buildDataCell(
                                  category.piecesPerBox.toString(), font,
                                  align: pw.TextAlign.center),
                              _buildDataCell(
                                  '${category.avgBoxWeight.toStringAsFixed(1)}kg',
                                  font,
                                  align: pw.TextAlign.center),
                              _buildDataCell('${category.boxCount}', font,
                                  align: pw.TextAlign.center),
                              _buildDataCell(
                                  '${category.totalWeight.toStringAsFixed(1)}kg',
                                  font,
                                  align: pw.TextAlign.center),
                              _buildDataCell('Rs.${category.pricePerKg}', font,
                                  align: pw.TextAlign.center),
                              _buildDataCell(
                                  'Rs.${category.totalPrice.toStringAsFixed(1)}',
                                  font,
                                  align: pw.TextAlign.center),
                            ],
                          )),
                ],
              ),
              pw.SizedBox(height: 18),
              // Space between tables
              // Adjust width as needed

              pw.Table(
                border: pw.TableBorder.all(
                ),
                columnWidths: {
                  0: const pw.FlexColumnWidth(1.5),
                  1: const pw.FlexColumnWidth(1.2),
                  2: const pw.FlexColumnWidth(1.8),
                  3: const pw.FlexColumnWidth(1.5),
                },
                children: [
                  // Header Row
                  pw.TableRow(
                    decoration: pw.BoxDecoration(
                      color: PdfColors.amber400,
                      borderRadius: const pw.BorderRadius.only(
                        topLeft: pw.Radius.circular(4),
                        topRight: pw.Radius.circular(4),
                      ),
                    ),
                    children: [
                      _buildEnhancedHeaderCell('Bidding Price', font),
                      _buildEnhancedHeaderCell('No of Boxes', font),
                      _buildEnhancedHeaderCell('Grand Total Weight', font),
                      _buildEnhancedHeaderCell('Grand Total Price', font),
                    ],
                  ),
                  // Data Row
                  pw.TableRow(
                    decoration: const pw.BoxDecoration(
                      color: PdfColors.blueGrey,
                      borderRadius: pw.BorderRadius.only(
                        bottomLeft: pw.Radius.circular(4),
                        bottomRight: pw.Radius.circular(4),
                      ),
                    ),
                    children: [
                      _buildEnhancedDataCell(
                        biddingPrice > 0 ? 'Rs. ${biddingPrice.toStringAsFixed(1)}' : 'N/A',
                        font,
                      ),
                      _buildEnhancedDataCell('$totalBoxes', font),
                      _buildEnhancedDataCell('${grandTotalWeight.toStringAsFixed(1)} kg', font),
                      _buildEnhancedDataCell('Rs. ${grandTotalPrice.toStringAsFixed(1)}', font),
                    ],
                  ),
                ],
              ),
              pw.SizedBox(height: 18),
              // App download text
              pw.Center(
                child: pw.Row(
                  mainAxisSize: pw.MainAxisSize.min,
                  children: [
                    pw.Text(
                      'For viewing Images download the app: ',
                      style: pw.TextStyle(
                          font: font, fontSize: 14, color: PdfColors.blueGrey),
                    ),
                    pw.UrlLink(
                      destination: websiteUrl,
                      child: pw.Text(
                        websiteUrl,
                        style: pw.TextStyle(
                          color: PdfColors.blue,
                          decoration: pw.TextDecoration.underline,
                          font: font,
                          fontSize: 14,
                        ),
                      ),
                    ),
                  ],
                ),
              )
            ]),
            pw.Positioned.fill(
              child: pw.Center(
                child: pw.Transform.rotate(
                  angle: -0.5, // Rotate watermark
                  child: pw.Opacity(
                    opacity: 0.5,
                    child: pw.Text(
                      'FASCORP',
                      style: pw.TextStyle(
                        fontSize: 80,
                        color: PdfColors.grey,
                        fontWeight: pw.FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ]),
        ],
      ),
    );
    // Add a second page for the charts (2x2 grid)
    pdf.addPage(
      pw.Page(
        pageFormat: PdfPageFormat.a4,
        build: (pw.Context context) => pw.Stack(children: [
          // 🔹 Watermark layer
          pw.Center(
            child: pw.Column(
              mainAxisAlignment: pw.MainAxisAlignment.center,
              children: [
                pw.Center(
                  child: pw.Text("Bilty Distribution Graphs",
                      style: pw.TextStyle(fontSize: 22)),
                ),
                pw.Divider(color: PdfColors.black),
                pw.SizedBox(height: 16),
                pw.Row(
                  mainAxisAlignment: pw.MainAxisAlignment.center,
                  crossAxisAlignment: pw.CrossAxisAlignment.start,
                  children: [
                    pw.Expanded(
                        child: buildDonutChartPdf(
                      data: qualityShare,
                      colors: [
                        PdfColors.red,
                        PdfColors.yellow,
                        PdfColors.green
                      ],
                      title: 'Overall',
                      font: font,
                      size: 100,
                      arcWidth: 40,
                      gapDegrees: 4,
                      drawLegendLines: false,
                      totalBoxes: qualityBoxCount.values
                          .fold(0, (sum, v) => (sum ?? 0) + (v ?? 0)),
                      totalWeight: totalWeight,
                    )),
                    pw.SizedBox(width: 24),
                    pw.Expanded(
                        child: buildDonutChartPdf(
                      data: aaaCategoryShare,
                      colors: [
                        PdfColors.blue,
                        PdfColors.orange,
                        PdfColors.purple,
                        PdfColors.amber
                      ],
                      title: 'AAA',
                      font: font,
                      size: 100,
                      arcWidth: 40,
                      gapDegrees: 4,
                      drawLegendLines: false,
                      totalBoxes: aaaCatBoxCount.values
                          .fold(0, (sum, v) => (sum ?? 0) + (v ?? 0)),
                      totalWeight: totalAAAWeight,
                    )),
                  ],
                ),
                pw.SizedBox(height: 16),
                pw.Divider(color: PdfColors.black),
                pw.SizedBox(height: 16),
                pw.Row(
                  mainAxisAlignment: pw.MainAxisAlignment.center,
                  crossAxisAlignment: pw.CrossAxisAlignment.start,
                  children: [
                    pw.Expanded(
                      child: buildDonutChartPdf(
                        data: aaCatMap,
                        colors: aaCatColors,
                        title: 'AA',
                        font: font,
                        size: 100,
                        arcWidth: 40,
                        gapDegrees: 4,
                        drawLegendLines: false,
                        totalBoxes: aaCatBoxCount.values
                            .fold(0, (sum, v) => (sum ?? 0) + (v ?? 0)),
                        totalWeight: totalAAWeight,
                      ),
                    ),
                    pw.SizedBox(width: 24),
                    pw.Expanded(
                      child: buildDonutChartPdf(
                        data: gpCatMap,
                        colors: gpCatColors,
                        title: 'GP',
                        font: font,
                        size: 100,
                        arcWidth: 40,
                        gapDegrees: 4,
                        drawLegendLines: false,
                        totalBoxes: gpCatBoxCount.values
                            .fold(0, (sum, v) => (sum ?? 0) + (v ?? 0)),
                        totalWeight: totalGPWeight,
                      ),
                    ),
                  ],
                ),
                pw.SizedBox(height: 12),
              ],
            ),
          ),
          pw.Positioned.fill(
            child: pw.Center(
              child: pw.Transform.rotate(
                angle: -0.5, // Rotate watermark
                child: pw.Opacity(
                  opacity: 0.5,
                  child: pw.Text(
                    'FASCORP',
                    style: pw.TextStyle(
                      fontSize: 80,
                      color: PdfColors.grey,
                      fontWeight: pw.FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ),
          ),
        ]),
      ),
    );
    pdf.addPage(pw.Page(
      pageFormat: PdfPageFormat.a4,
      build: (pw.Context context) => pw.Stack(children: [
        // 🔹 Watermark layer
        pw.Center(
          child: pw.Column(
            mainAxisAlignment: pw.MainAxisAlignment.center,
            children: [
              pw.Center(
                child: pw.Text("Bilty Distribution Graphs",
                    style: pw.TextStyle(fontSize: 22)),
              ),
              pw.Divider(color: PdfColors.black),
              pw.SizedBox(height: 20),
              pw.Row(
                  mainAxisAlignment: pw.MainAxisAlignment.center,
                  crossAxisAlignment: pw.CrossAxisAlignment.start,
                  children: [
                    pw.Container(
                      width: 480,
                      child: pw.Image(aaaImage, fit: pw.BoxFit.contain),
                    ),
                  ]),
              pw.SizedBox(height: 20),
              pw.SizedBox(height: 60),
              pw.Container(
                  child: pw.Text(
                      textAlign: pw.TextAlign.justify,
                      "The Boxes in this Consignment no ${consignmentNo!} has been packed in ${packhouseName!} Pack House under my observation /Supervision for any kind of Human errors while packing more than 5% I take full responsibility of the consignment.")),
              pw.SizedBox(height: 10),
              pw.Column(
                  crossAxisAlignment: pw.CrossAxisAlignment.end,
                  children: [
                    pw.Row(
                        mainAxisAlignment: pw.MainAxisAlignment.end,
                        children: [
                          pw.Text(
                            growerName!,
                            style: pw.TextStyle(fontSize: 12),
                          )
                        ]),
                    pw.Row(
                        mainAxisAlignment: pw.MainAxisAlignment.end,
                        children: [
                          pw.Text("${date}", style: pw.TextStyle(fontSize: 10))
                        ]),
                  ]),
              pw.Container(height: 45),
              pw.Divider(color: PdfColors.black, height: 1),
              pw.SizedBox(height: 4),
              pw.Center(
                child: pw.Text(
                    "Copyright © Dev Bhardwaj 2025. All rights reserved.\n No part of this work shall be copied by any device-mechanical, electronic or other, stored in a retrieval system or transmitted in any form or any means without prior permission",
                    textAlign: pw.TextAlign.center,
                    softWrap: true,
                    maxLines: 3,
                    style: pw.TextStyle(fontSize: 8)),
              )
            ],
          ),
        ),
      ]),
    ));

    final pdfBytes = await pdf.save();
    final fileName = (consignmentNo != null && consignmentNo.isNotEmpty)
        ? '$consignmentNo.pdf'
        : 'bilty_step2.pdf';

    if (kIsWeb) {
      await Printing.sharePdf(bytes: pdfBytes, filename: fileName);
      Get.back();
    } else {
      final tempDir = Directory.systemTemp;
      final file = File('${tempDir.path}/$fileName');
      await file.writeAsBytes(pdfBytes);
      await Share.shareXFiles([XFile(file.path)],
          text: 'Bilty PDF\n$websiteUrl');
      Get.back();
    }
  } catch (e) {
    print('Error generating PDF: $e');
    rethrow;
  }
}

Future<void> downloadBiltyAadhati(Bilty bilty,
    {required String websiteUrl,
    String? growerName,
    String? packhouseName,
    String? consignmentNo,
    String? ladaniName,
    String? remark}) async {
  try {
    Get.defaultDialog(
      // Prevent the user from closing the dialog accidentally
      barrierDismissible: false,

      // Title with improved styling
      title: "Downloading",
      titleStyle: const TextStyle(
        fontWeight: FontWeight.bold,
        fontSize: 18,
      ),

      // Give the dialog rounded corners
      radius: 15.0,

      // Content with better spacing and text alignment
      content: const Column(
        mainAxisSize: MainAxisSize.min, // Ensures the dialog is not unnecessarily tall
        children: [
          CircularProgressIndicator(
            color: Colors.blueAccent,
            strokeWidth: 3.5,
          ),
          SizedBox(height: 20),
          Text(
            "This may take up to 60 seconds. Please wait.",
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 15),
          ),
        ],
      ),
    );
    for (var i = 0; i < bilty.categories.length; i++) {
      print('shareBilty: category[ [38;5;2m$i [0m] = ${bilty.categories[i]}');
    }
    if (bilty.categories.isEmpty) {
      print('shareBilty: No categories available in the bilty');
      throw Exception('No categories available in the bilty');
    }
    final font = await PdfGoogleFonts.tillanaMedium();
    // Load the image asset

    final logoBytes = await rootBundle.load('assets/images/bilty.png');
    final logoImage = pw.MemoryImage(logoBytes.buffer.asUint8List());
    final logo2Bytes = await rootBundle.load('assets/images/fas.png');
    final logo2Image = pw.MemoryImage(logo2Bytes.buffer.asUint8List());
    final aaaImageBytes = await loadGrowerImage(bilty.categories);
    final aaaImage = pw.MemoryImage(aaaImageBytes);
    final pdf = pw.Document();
    // --- Donut chart data logic (copied from controller) ---
    double totalWeight =
        bilty.categories.fold(0.0, (sum, c) => sum + c.totalWeight);
    Map<String, double> qualityShare = {'AAA': 0, 'AA': 0, 'GP': 0};
    Map<String, int> qualityBoxCount = {'AAA': 0, 'AA': 0, 'GP': 0};
    if (totalWeight > 0) {
      for (var q in ['AAA', 'AA', 'GP']) {
        final weight = bilty.categories
            .where((c) => c.quality == q)
            .fold(0.0, (prev, e) => prev + e.totalWeight);
        qualityShare[q] = weight / totalWeight * 100;
        qualityBoxCount[q] = bilty.categories
            .where((c) => c.quality == q)
            .fold(0, (prev, e) => prev + e.boxCount);
      }
    }
    // AAA category share
    final aaaCategories =
        bilty.categories.where((c) => c.quality == 'AAA').toList();
    final totalAAAWeight =
        aaaCategories.fold(0.0, (sum, e) => sum + e.totalWeight);
    Map<String, double> aaaCategoryShare = {
      'ELLMS': 0,
      'ES,EES,240': 0,
      'Pittu': 0,
      'Seprator': 0,
    };
    Map<String, int> aaaCatBoxCount = {
      'ELLMS': 0,
      'ES,EES,240': 0,
      'Pittu': 0,
      'Seprator': 0,
    };
    if (totalAAAWeight > 0) {
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
      aaaCategoryShare['ELLMS'] = aaaCategories
              .where((c) => ellmsCategories.contains(c.category))
              .fold(0.0, (sum, e) => sum + e.totalWeight) /
          totalAAAWeight *
          100;
      aaaCategoryShare['ES,EES,240'] = aaaCategories
              .where((c) => esEes240Categories.contains(c.category))
              .fold(0.0, (sum, e) => sum + e.totalWeight) /
          totalAAAWeight *
          100;
      aaaCategoryShare['Pittu'] = aaaCategories
              .where((c) => pittuCategories.contains(c.category))
              .fold(0.0, (sum, e) => sum + e.totalWeight) /
          totalAAAWeight *
          100;
      aaaCategoryShare['Seprator'] = aaaCategories
              .where((c) => separatorCategories.contains(c.category))
              .fold(0.0, (sum, e) => sum + e.totalWeight) /
          totalAAAWeight *
          100;
      // Clamp and normalize
      aaaCategoryShare.updateAll((k, v) => v.clamp(0, 100));
      final totalPercent = aaaCategoryShare.values.fold(0.0, (a, b) => a + b);
      if (totalPercent > 0 && (totalPercent - 100).abs() > 0.01) {
        aaaCategoryShare.updateAll((k, v) => v / totalPercent * 100);
      }
      // Box count for each AAA subcategory
      aaaCatBoxCount['ELLMS'] = aaaCategories
          .where((c) => ellmsCategories.contains(c.category))
          .fold(0, (sum, e) => sum + e.boxCount);
      aaaCatBoxCount['ES,EES,240'] = aaaCategories
          .where((c) => esEes240Categories.contains(c.category))
          .fold(0, (sum, e) => sum + e.boxCount);
      aaaCatBoxCount['Pittu'] = aaaCategories
          .where((c) => pittuCategories.contains(c.category))
          .fold(0, (sum, e) => sum + e.boxCount);
      aaaCatBoxCount['Seprator'] = aaaCategories
          .where((c) => separatorCategories.contains(c.category))
          .fold(0, (sum, e) => sum + e.boxCount);
    }
    // PDF colors for charts
    final qualityColors = [
      PdfColors.red,
      PdfColors.yellow,
      PdfColors.green,
    ];
    final aaaCatColors = [
      PdfColors.blue,
      PdfColors.orange,
      PdfColors.purple,
      PdfColors.amber,
    ];
    final aaCategories =
        bilty.categories.where((c) => c.quality == 'AA').toList();
    final totalAAWeight =
        aaCategories.fold(0.0, (sum, e) => sum + e.totalWeight);
    DateTime now = DateTime.now();

    String date = "${now.day}/${now.month}/${now.year}";

    Map<String, double> aaCatMap = {
      'ELLMS': 0,
      'ES,EES,240': 0,
      'Pittu': 0,
      'Seprator': 0,
    };
    Map<String, int> aaCatBoxCount = {
      'ELLMS': 0,
      'ES,EES,240': 0,
      'Pittu': 0,
      'Seprator': 0,
    };

    if (totalAAWeight > 0) {
      // Define the same sub-categories as AAA.
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

      // Calculate weight share for each AA subcategory
      aaCatMap['ELLMS'] = aaCategories
              .where((c) => ellmsCategories.contains(c.category))
              .fold(0.0, (sum, e) => sum + e.totalWeight) /
          totalAAWeight *
          100;
      aaCatMap['ES,EES,240'] = aaCategories
              .where((c) => esEes240Categories.contains(c.category))
              .fold(0.0, (sum, e) => sum + e.totalWeight) /
          totalAAWeight *
          100;
      aaCatMap['Pittu'] = aaCategories
              .where((c) => pittuCategories.contains(c.category))
              .fold(0.0, (sum, e) => sum + e.totalWeight) /
          totalAAWeight *
          100;
      aaCatMap['Seprator'] = aaCategories
              .where((c) => separatorCategories.contains(c.category))
              .fold(0.0, (sum, e) => sum + e.totalWeight) /
          totalAAWeight *
          100;

      // Clamp and normalize percentages
      aaCatMap.updateAll((k, v) => v.clamp(0, 100));
      final totalPercent = aaCatMap.values.fold(0.0, (a, b) => a + b);
      if (totalPercent > 0 && (totalPercent - 100).abs() > 0.01) {
        aaCatMap.updateAll((k, v) => v / totalPercent * 100);
      }

      // Calculate box count for each AA subcategory
      aaCatBoxCount['ELLMS'] = aaCategories
          .where((c) => ellmsCategories.contains(c.category))
          .fold(0, (sum, e) => sum + e.boxCount);
      aaCatBoxCount['ES,EES,240'] = aaCategories
          .where((c) => esEes240Categories.contains(c.category))
          .fold(0, (sum, e) => sum + e.boxCount);
      aaCatBoxCount['Pittu'] = aaCategories
          .where((c) => pittuCategories.contains(c.category))
          .fold(0, (sum, e) => sum + e.boxCount);
      aaCatBoxCount['Seprator'] = aaCategories
          .where((c) => separatorCategories.contains(c.category))
          .fold(0, (sum, e) => sum + e.boxCount);
    }

    // Using a fixed set of colors for consistency, similar to AAA.
    final aaCatColors = [
      PdfColors.blue,
      PdfColors.orange,
      PdfColors.purple,
      PdfColors.amber,
    ];

    final gpCategories =
        bilty.categories.where((c) => c.quality == 'GP').toList();
    final gpCatMap = <String, double>{};
    final gpCatBoxCount = <String, int>{};
    final totalGPWeight =
        gpCategories.fold(0.0, (sum, e) => sum + e.totalWeight);
    for (final c in gpCategories) {
      if (c.totalWeight > 0) {
        gpCatMap[c.category] = (c.totalWeight / totalGPWeight) * 100;
        gpCatBoxCount[c.category] = c.boxCount;
      }
    }
    final gpCatColors = List<PdfColor>.generate(gpCatMap.length,
        (i) => PdfColors.accents[i % PdfColors.accents.length]);
    final int totalBoxes =
    bilty.categories.fold(0, (sum, item) => sum + item.boxCount);
    final double grandTotalWeight =
    bilty.categories.fold(0.0, (sum, item) => sum + item.totalWeight);
    final double grandTotalPrice =
    bilty.categories.fold(0.0, (sum, item) => sum + item.totalPrice);

    // Find the 'AAA' 'Extra Large' category to get the bidding price.
    final aaaELCategory = bilty.categories.firstWhere(
          (c) => c.quality == 'AAA' && c.category == 'Extra Large',
    );
    final double biddingPrice = aaaELCategory.pricePerKg;

    pdf.addPage(
      pw.MultiPage(
        pageFormat: PdfPageFormat.a4,
        build: (pw.Context context) => [
          pw.Stack(children: [
            // 🔹 Watermark layer
            pw.Column(children: [
              // Header: logo left, title right
              pw.Row(
                crossAxisAlignment: pw.CrossAxisAlignment.center,
                children: [
                  pw.Container(
                    width: 80,
                    height: 60,
                    child: pw.Image(logoImage),
                  ),
                  pw.Expanded(child: pw.SizedBox(width: 16)),
                  pw.Container(
                      height: 60,
                      child: pw.Column(children: [
                        pw.Text(
                          'FasCorp',
                          style: pw.TextStyle(
                            font: font,
                            fontSize: 18,
                            fontWeight: pw.FontWeight.bold,
                            color: PdfColors.green,
                          ),
                          textAlign: pw.TextAlign.right,
                        ),
                        pw.SizedBox(height: 2),
                        pw.Text(
                          "Farming as a Service Initiative",
                          style: pw.TextStyle(
                            font: font,
                            fontSize: 14,
                            fontWeight: pw.FontWeight.bold,
                            color: PdfColors.green,
                          ),
                        ),
                        pw.SizedBox(height: 6),
                      ])),
                  pw.Expanded(child: pw.SizedBox(width: 16)),
                  pw.Container(
                    height: 60,
                    width: 120,
                    child: pw.Center(child: pw.Image(logo2Image)),
                  )
                ],
              ),
              pw.SizedBox(height: 4),
              pw.Divider(color: PdfColors.black, height: 1),
              pw.SizedBox(height: 2),
              pw.Row(children: [
                pw.Padding(
                    padding: pw.EdgeInsets.symmetric(vertical: 4),
                    child: pw.Container(
                        width: 220,
                        height: 80,
                        padding: pw.EdgeInsets.all(4),
                        child: pw.Column(
                            mainAxisAlignment: pw.MainAxisAlignment.spaceAround,
                            crossAxisAlignment: pw.CrossAxisAlignment.start,
                            children: [
                              if (consignmentNo != null &&
                                  consignmentNo.isNotEmpty)
                                pw.Center(
                                  child: pw.Text(
                                      'Consignment No.: $consignmentNo',
                                      style: pw.TextStyle(
                                          font: font,
                                          fontSize: 12,
                                          fontWeight: pw.FontWeight.bold)),
                                ),
                              if (growerName != null && growerName.isNotEmpty)
                                pw.Text('Grower: ${growerName}',
                                    style:
                                        pw.TextStyle(font: font, fontSize: 12)),
                            ]))),
                pw.SizedBox(width: 15),
                pw.Padding(
                    padding: pw.EdgeInsets.symmetric(vertical: 4),
                    child: pw.Container(
                        width: 220,
                        height: 80,
                        padding: pw.EdgeInsets.all(4),
                        child: pw.Column(
                            mainAxisAlignment: pw.MainAxisAlignment.spaceAround,
                            crossAxisAlignment: pw.CrossAxisAlignment.start,
                            children: [
                              if (consignmentNo != null &&
                                  consignmentNo.isNotEmpty)
                                if (packhouseName != null &&
                                    packhouseName.isNotEmpty)
                                  pw.Text('Packhouse: $packhouseName',
                                      style: pw.TextStyle(
                                          font: font, fontSize: 12)),
                              if (ladaniName != null && ladaniName.isNotEmpty)
                                pw.Text('ladani: $ladaniName',
                                    style:
                                        pw.TextStyle(font: font, fontSize: 12)),
                            ]))),
                pw.SizedBox(height: 16),
              ]),
              // Table
              pw.Table(
                border: pw.TableBorder.all(),
                children: [
                  pw.TableRow(
                    decoration: pw.BoxDecoration(
                      color: getPdfHeaderColor(),
                    ),
                    children: [
                      _buildHeaderCell('Quality', font,
                          align: pw.TextAlign.center),
                      _buildHeaderCell('Category', font,
                          align: pw.TextAlign.center),
                      _buildHeaderCell('Variety', font,
                          align: pw.TextAlign.center),
                      _buildHeaderCell('Count', font,
                          align: pw.TextAlign.center),
                      _buildHeaderCell('Gross Weight', font,
                          align: pw.TextAlign.center),
                      _buildHeaderCell('No. of Boxes', font,
                          align: pw.TextAlign.center),
                      _buildHeaderCell('Total Weight', font,
                          align: pw.TextAlign.center),
                      _buildHeaderCell('Price perKg', font,
                          align: pw.TextAlign.center),
                      _buildHeaderCell('Total Price', font,
                          align: pw.TextAlign.center),
                    ],
                  ),
                  ...bilty.categories
                      .where((category) => category.boxCount > 0)
                      .map((category) => pw.TableRow(
                            decoration: pw.BoxDecoration(
                                color: getPdfRowColor(category.quality)),
                            children: [
                              _buildDataCell(category.quality, font,
                                  align: pw.TextAlign.center),
                              _buildDataCell(category.category, font,
                                  align: pw.TextAlign.center),
                              _buildDataCell(category.variety, font,
                                  align: pw.TextAlign.center),
                              _buildDataCell(
                                  category.piecesPerBox.toString(), font,
                                  align: pw.TextAlign.center),
                              _buildDataCell(
                                  '${category.avgBoxWeight.toStringAsFixed(1)}kg',
                                  font,
                                  align: pw.TextAlign.center),
                              _buildDataCell('${category.boxCount}', font,
                                  align: pw.TextAlign.center),
                              _buildDataCell(
                                  '${category.totalWeight.toStringAsFixed(1)}kg',
                                  font,
                                  align: pw.TextAlign.center),
                              _buildDataCell(
                                  'Rs.${category.pricePerKg.toStringAsFixed(1)}',
                                  font,
                                  align: pw.TextAlign.center),
                              _buildDataCell(
                                  'Rs.${category.totalPrice.toStringAsFixed(1)}',
                                  font,
                                  align: pw.TextAlign.center),
                            ],
                          )),
                ],
              ),
              pw.SizedBox(height: 18),
              // Space between tables
              // Adjust width as needed

              pw.Table(
                border: pw.TableBorder.all(
                ),
                columnWidths: {
                  0: const pw.FlexColumnWidth(1.5),
                  1: const pw.FlexColumnWidth(1.2),
                  2: const pw.FlexColumnWidth(1.8),
                  3: const pw.FlexColumnWidth(1.5),
                },
                children: [
                  // Header Row
                  pw.TableRow(
                    decoration: pw.BoxDecoration(
                      color: PdfColors.amber400,
                      borderRadius: const pw.BorderRadius.only(
                        topLeft: pw.Radius.circular(4),
                        topRight: pw.Radius.circular(4),
                      ),
                    ),
                    children: [
                      _buildEnhancedHeaderCell('Bidding Price', font),
                      _buildEnhancedHeaderCell('No of Boxes', font),
                      _buildEnhancedHeaderCell('Grand Total Weight', font),
                      _buildEnhancedHeaderCell('Grand Total Price', font),
                    ],
                  ),
                  // Data Row
                  pw.TableRow(
                    decoration: const pw.BoxDecoration(
                      color: PdfColors.blueGrey,
                      borderRadius: pw.BorderRadius.only(
                        bottomLeft: pw.Radius.circular(4),
                        bottomRight: pw.Radius.circular(4),
                      ),
                    ),
                    children: [
                      _buildEnhancedDataCell(
                        biddingPrice > 0 ? 'Rs. ${biddingPrice.toStringAsFixed(1)}' : 'N/A',
                        font,
                      ),
                      _buildEnhancedDataCell('$totalBoxes', font),
                      _buildEnhancedDataCell('${grandTotalWeight.toStringAsFixed(1)} kg', font),
                      _buildEnhancedDataCell('Rs. ${grandTotalPrice.toStringAsFixed(1)}', font),
                    ],
                  ),
                ],
              ),
              pw.SizedBox(height: 18),
              // App download text
              pw.Center(
                child: pw.Row(
                  mainAxisSize: pw.MainAxisSize.min,
                  children: [
                    pw.Text(
                      'For viewing Images download the app: ',
                      style: pw.TextStyle(
                          font: font, fontSize: 14, color: PdfColors.blueGrey),
                    ),
                    pw.UrlLink(
                      destination: websiteUrl,
                      child: pw.Text(
                        websiteUrl,
                        style: pw.TextStyle(
                          color: PdfColors.blue,
                          decoration: pw.TextDecoration.underline,
                          font: font,
                          fontSize: 14,
                        ),
                      ),
                    ),
                  ],
                ),
              )
            ]),
            pw.Positioned.fill(
              child: pw.Center(
                child: pw.Transform.rotate(
                  angle: -0.5, // Rotate watermark
                  child: pw.Opacity(
                    opacity: 0.5,
                    child: pw.Text(
                      'FASCORP',
                      style: pw.TextStyle(
                        fontSize: 80,
                        color: PdfColors.grey,
                        fontWeight: pw.FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ]),
        ],
      ),
    );
    // Add a second page for the charts (2x2 grid)
    pdf.addPage(
      pw.Page(
        pageFormat: PdfPageFormat.a4,
        build: (pw.Context context) => pw.Stack(children: [
          // 🔹 Watermark layer
          pw.Center(
            child: pw.Column(
              mainAxisAlignment: pw.MainAxisAlignment.center,
              children: [
                pw.Center(
                  child: pw.Text("Bilty Distribution Graphs",
                      style: pw.TextStyle(fontSize: 22)),
                ),
                pw.Divider(color: PdfColors.black),
                pw.SizedBox(height: 16),
                pw.Row(
                  mainAxisAlignment: pw.MainAxisAlignment.center,
                  crossAxisAlignment: pw.CrossAxisAlignment.start,
                  children: [
                    pw.Expanded(
                        child: buildDonutChartPdf(
                      data: qualityShare,
                      colors: [
                        PdfColors.red,
                        PdfColors.yellow,
                        PdfColors.green
                      ],
                      title: 'Overall',
                      font: font,
                      size: 100,
                      arcWidth: 40,
                      gapDegrees: 4,
                      drawLegendLines: false,
                      totalBoxes: qualityBoxCount.values
                          .fold(0, (sum, v) => (sum ?? 0) + (v ?? 0)),
                      totalWeight: totalWeight,
                    )),
                    pw.SizedBox(width: 24),
                    pw.Expanded(
                        child: buildDonutChartPdf(
                      data: aaaCategoryShare,
                      colors: [
                        PdfColors.blue,
                        PdfColors.orange,
                        PdfColors.purple,
                        PdfColors.amber
                      ],
                      title: 'AAA',
                      font: font,
                      size: 100,
                      arcWidth: 40,
                      gapDegrees: 4,
                      drawLegendLines: false,
                      totalBoxes: aaaCatBoxCount.values
                          .fold(0, (sum, v) => (sum ?? 0) + (v ?? 0)),
                      totalWeight: totalAAAWeight,
                    )),
                  ],
                ),
                pw.SizedBox(height: 16),
                pw.Divider(color: PdfColors.black),
                pw.SizedBox(height: 16),
                pw.Row(
                  mainAxisAlignment: pw.MainAxisAlignment.center,
                  crossAxisAlignment: pw.CrossAxisAlignment.start,
                  children: [
                    pw.Expanded(
                      child: buildDonutChartPdf(
                        data: aaCatMap,
                        colors: aaCatColors,
                        title: 'AA',
                        font: font,
                        size: 100,
                        arcWidth: 40,
                        gapDegrees: 4,
                        drawLegendLines: false,
                        totalBoxes: aaCatBoxCount.values
                            .fold(0, (sum, v) => (sum ?? 0) + (v ?? 0)),
                        totalWeight: totalAAWeight,
                      ),
                    ),
                    pw.SizedBox(width: 24),
                    pw.Expanded(
                      child: buildDonutChartPdf(
                        data: gpCatMap,
                        colors: gpCatColors,
                        title: 'GP',
                        font: font,
                        size: 100,
                        arcWidth: 40,
                        gapDegrees: 4,
                        drawLegendLines: false,
                        totalBoxes: gpCatBoxCount.values
                            .fold(0, (sum, v) => (sum ?? 0) + (v ?? 0)),
                        totalWeight: totalGPWeight,
                      ),
                    ),
                  ],
                ),
                pw.SizedBox(height: 12),
              ],
            ),
          ),
          pw.Positioned.fill(
            child: pw.Center(
              child: pw.Transform.rotate(
                angle: -0.5, // Rotate watermark
                child: pw.Opacity(
                  opacity: 0.5,
                  child: pw.Text(
                    'FASCORP',
                    style: pw.TextStyle(
                      fontSize: 80,
                      color: PdfColors.grey,
                      fontWeight: pw.FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ),
          ),
        ]),
      ),
    );
    pdf.addPage(pw.Page(
      pageFormat: PdfPageFormat.a4,
      build: (pw.Context context) => pw.Stack(children: [
        // 🔹 Watermark layer
        pw.Center(
          child: pw.Column(
            mainAxisAlignment: pw.MainAxisAlignment.center,
            children: [
              pw.Center(
                child: pw.Text("Bilty Distribution Graphs",
                    style: pw.TextStyle(fontSize: 22)),
              ),
              pw.Divider(color: PdfColors.black),
              pw.SizedBox(height: 20),
              pw.Row(
                  mainAxisAlignment: pw.MainAxisAlignment.center,
                  crossAxisAlignment: pw.CrossAxisAlignment.start,
                  children: [
                    pw.Container(
                      width: 480,
                      child: pw.Image(aaaImage, fit: pw.BoxFit.contain),
                    ),
                  ]),
              pw.SizedBox(height: 20),
              pw.SizedBox(height: 60),
              pw.Container(
                  child: pw.Text(
                      textAlign: pw.TextAlign.justify,
                      "The Boxes in this Consignment no ${consignmentNo!} has been packed in ${packhouseName!} Pack House under my observation /Supervision for any kind of Human errors while packing more than 5% I take full responsibility of the consignment.")),
              pw.SizedBox(height: 10),
              pw.Column(
                  crossAxisAlignment: pw.CrossAxisAlignment.end,
                  children: [
                    pw.Row(
                        mainAxisAlignment: pw.MainAxisAlignment.end,
                        children: [
                          pw.Text(
                            growerName!,
                            style: pw.TextStyle(fontSize: 12),
                          )
                        ]),
                    pw.Row(
                        mainAxisAlignment: pw.MainAxisAlignment.end,
                        children: [
                          pw.Text("${date}", style: pw.TextStyle(fontSize: 10))
                        ]),
                  ]),
              pw.Container(height: 45),
              pw.Divider(color: PdfColors.black, height: 1),
              pw.SizedBox(height: 4),
              pw.Center(
                child: pw.Text(
                    "Copyright © Dev Bhardwaj 2025. All rights reserved.\n No part of this work shall be copied by any device-mechanical, electronic or other, stored in a retrieval system or transmitted in any form or any means without prior permission",
                    textAlign: pw.TextAlign.center,
                    softWrap: true,
                    maxLines: 3,
                    style: pw.TextStyle(fontSize: 8)),
              )
            ],
          ),
        ),
      ]),
    ));

    final pdfBytes = await pdf.save();
    final fileName = (consignmentNo != null && consignmentNo.isNotEmpty)
        ? '$consignmentNo.pdf'
        : 'bilty_step2.pdf';
    if (kIsWeb) {
      await Printing.sharePdf(bytes: pdfBytes, filename: fileName);
    } else {
      final tempDir = Directory.systemTemp;
      final file = File('${tempDir.path}/$fileName');
      await file.writeAsBytes(pdfBytes);
      await Share.shareXFiles([XFile(file.path)],
          text: 'Bilty PDF\n$websiteUrl');
    }
    Get.back();
  } catch (e) {
    print('Error generating PDF: $e');
    rethrow;
  }
}

Future<void> downloadBiltyLadani(Bilty bilty,
    {required String websiteUrl,
    String? growerName,
    String? packhouseName,
    String? consignmentNo,
    String? aadhatiName,
    String? remark}) async {
  try {
    Get.defaultDialog(
      // Prevent the user from closing the dialog accidentally
      barrierDismissible: false,

      // Title with improved styling
      title: "Downloading",
      titleStyle: const TextStyle(
        fontWeight: FontWeight.bold,
        fontSize: 18,
      ),

      // Give the dialog rounded corners
      radius: 15.0,

      // Content with better spacing and text alignment
      content: const Column(
        mainAxisSize: MainAxisSize.min, // Ensures the dialog is not unnecessarily tall
        children: [
          CircularProgressIndicator(
            color: Colors.blueAccent,
            strokeWidth: 3.5,
          ),
          SizedBox(height: 20),
          Text(
            "This may take up to 60 seconds. Please wait.",
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 15),
          ),
        ],
      ),
    );
    print(
        'shareBilty: categories count =  [38;5;2m${bilty.categories.length} [0m');
    for (var i = 0; i < bilty.categories.length; i++) {
      print('shareBilty: category[ [38;5;2m$i [0m] = ${bilty.categories[i]}');
    }
    if (bilty.categories.isEmpty) {
      print('shareBilty: No categories available in the bilty');
      throw Exception('No categories available in the bilty');
    }
    final font = await PdfGoogleFonts.tillanaMedium();
    // Load the image asset

    final logoBytes = await rootBundle.load('assets/images/bilty.png');
    final logoImage = pw.MemoryImage(logoBytes.buffer.asUint8List());
    final logo2Bytes = await rootBundle.load('assets/images/fas.png');
    final logo2Image = pw.MemoryImage(logo2Bytes.buffer.asUint8List());
    final aaaImageBytes = await loadLadaniImage(bilty.categories);
    final aaaImage = pw.MemoryImage(aaaImageBytes);
    final pdf = pw.Document();
    // --- Donut chart data logic (copied from controller) ---
    double totalWeight =
        bilty.categories.fold(0.0, (sum, c) => sum + c.totalWeight);
    Map<String, double> qualityShare = {'AAA': 0, 'AA': 0, 'GP': 0};
    Map<String, int> qualityBoxCount = {'AAA': 0, 'AA': 0, 'GP': 0};
    if (totalWeight > 0) {
      for (var q in ['AAA', 'AA', 'GP']) {
        final weight = bilty.categories
            .where((c) => c.quality == q)
            .fold(0.0, (prev, e) => prev + e.totalWeight);
        qualityShare[q] = weight / totalWeight * 100;
        qualityBoxCount[q] = bilty.categories
            .where((c) => c.quality == q)
            .fold(0, (prev, e) => prev + e.boxCount);
      }
    }
    // AAA category share
    final aaaCategories =
        bilty.categories.where((c) => c.quality == 'AAA').toList();
    final totalAAAWeight =
        aaaCategories.fold(0.0, (sum, e) => sum + e.totalWeight);
    Map<String, double> aaaCategoryShare = {
      'ELLMS': 0,
      'ES,EES,240': 0,
      'Pittu': 0,
      'Seprator': 0,
    };
    Map<String, int> aaaCatBoxCount = {
      'ELLMS': 0,
      'ES,EES,240': 0,
      'Pittu': 0,
      'Seprator': 0,
    };
    if (totalAAAWeight > 0) {
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
      aaaCategoryShare['ELLMS'] = aaaCategories
              .where((c) => ellmsCategories.contains(c.category))
              .fold(0.0, (sum, e) => sum + e.totalWeight) /
          totalAAAWeight *
          100;
      aaaCategoryShare['ES,EES,240'] = aaaCategories
              .where((c) => esEes240Categories.contains(c.category))
              .fold(0.0, (sum, e) => sum + e.totalWeight) /
          totalAAAWeight *
          100;
      aaaCategoryShare['Pittu'] = aaaCategories
              .where((c) => pittuCategories.contains(c.category))
              .fold(0.0, (sum, e) => sum + e.totalWeight) /
          totalAAAWeight *
          100;
      aaaCategoryShare['Seprator'] = aaaCategories
              .where((c) => separatorCategories.contains(c.category))
              .fold(0.0, (sum, e) => sum + e.totalWeight) /
          totalAAAWeight *
          100;
      // Clamp and normalize
      aaaCategoryShare.updateAll((k, v) => v.clamp(0, 100));
      final totalPercent = aaaCategoryShare.values.fold(0.0, (a, b) => a + b);
      if (totalPercent > 0 && (totalPercent - 100).abs() > 0.01) {
        aaaCategoryShare.updateAll((k, v) => v / totalPercent * 100);
      }
      // Box count for each AAA subcategory
      aaaCatBoxCount['ELLMS'] = aaaCategories
          .where((c) => ellmsCategories.contains(c.category))
          .fold(0, (sum, e) => sum + e.boxCount);
      aaaCatBoxCount['ES,EES,240'] = aaaCategories
          .where((c) => esEes240Categories.contains(c.category))
          .fold(0, (sum, e) => sum + e.boxCount);
      aaaCatBoxCount['Pittu'] = aaaCategories
          .where((c) => pittuCategories.contains(c.category))
          .fold(0, (sum, e) => sum + e.boxCount);
      aaaCatBoxCount['Seprator'] = aaaCategories
          .where((c) => separatorCategories.contains(c.category))
          .fold(0, (sum, e) => sum + e.boxCount);
    }
    // PDF colors for charts
    final qualityColors = [
      PdfColors.red,
      PdfColors.yellow,
      PdfColors.green,
    ];
    final aaaCatColors = [
      PdfColors.blue,
      PdfColors.orange,
      PdfColors.purple,
      PdfColors.amber,
    ];
    final aaCategories =
        bilty.categories.where((c) => c.quality == 'AA').toList();
    final totalAAWeight =
        aaCategories.fold(0.0, (sum, e) => sum + e.totalWeight);
    DateTime now = DateTime.now();

    String date = "${now.day}/${now.month}/${now.year}";

    Map<String, double> aaCatMap = {
      'ELLMS': 0,
      'ES,EES,240': 0,
      'Pittu': 0,
      'Seprator': 0,
    };
    Map<String, int> aaCatBoxCount = {
      'ELLMS': 0,
      'ES,EES,240': 0,
      'Pittu': 0,
      'Seprator': 0,
    };

    if (totalAAWeight > 0) {
      // Define the same sub-categories as AAA.
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

      // Calculate weight share for each AA subcategory
      aaCatMap['ELLMS'] = aaCategories
              .where((c) => ellmsCategories.contains(c.category))
              .fold(0.0, (sum, e) => sum + e.totalWeight) /
          totalAAWeight *
          100;
      aaCatMap['ES,EES,240'] = aaCategories
              .where((c) => esEes240Categories.contains(c.category))
              .fold(0.0, (sum, e) => sum + e.totalWeight) /
          totalAAWeight *
          100;
      aaCatMap['Pittu'] = aaCategories
              .where((c) => pittuCategories.contains(c.category))
              .fold(0.0, (sum, e) => sum + e.totalWeight) /
          totalAAWeight *
          100;
      aaCatMap['Seprator'] = aaCategories
              .where((c) => separatorCategories.contains(c.category))
              .fold(0.0, (sum, e) => sum + e.totalWeight) /
          totalAAWeight *
          100;

      // Clamp and normalize percentages
      aaCatMap.updateAll((k, v) => v.clamp(0, 100));
      final totalPercent = aaCatMap.values.fold(0.0, (a, b) => a + b);
      if (totalPercent > 0 && (totalPercent - 100).abs() > 0.01) {
        aaCatMap.updateAll((k, v) => v / totalPercent * 100);
      }

      // Calculate box count for each AA subcategory
      aaCatBoxCount['ELLMS'] = aaCategories
          .where((c) => ellmsCategories.contains(c.category))
          .fold(0, (sum, e) => sum + e.boxCount);
      aaCatBoxCount['ES,EES,240'] = aaCategories
          .where((c) => esEes240Categories.contains(c.category))
          .fold(0, (sum, e) => sum + e.boxCount);
      aaCatBoxCount['Pittu'] = aaCategories
          .where((c) => pittuCategories.contains(c.category))
          .fold(0, (sum, e) => sum + e.boxCount);
      aaCatBoxCount['Seprator'] = aaCategories
          .where((c) => separatorCategories.contains(c.category))
          .fold(0, (sum, e) => sum + e.boxCount);
    }

    // Using a fixed set of colors for consistency, similar to AAA.
    final aaCatColors = [
      PdfColors.blue,
      PdfColors.orange,
      PdfColors.purple,
      PdfColors.amber,
    ];

    final gpCategories =
        bilty.categories.where((c) => c.quality == 'GP').toList();
    final gpCatMap = <String, double>{};
    final gpCatBoxCount = <String, int>{};
    final totalGPWeight =
        gpCategories.fold(0.0, (sum, e) => sum + e.totalWeight);
    for (final c in gpCategories) {
      if (c.totalWeight > 0) {
        gpCatMap[c.category] = (c.totalWeight / totalGPWeight) * 100;
        gpCatBoxCount[c.category] = c.boxCount;
      }
    }
    final gpCatColors = List<PdfColor>.generate(gpCatMap.length,
        (i) => PdfColors.accents[i % PdfColors.accents.length]);


    final int totalBoxes =
    bilty.categories.fold(0, (sum, item) => sum + item.boxCount);
    final double grandTotalWeight =
    bilty.categories.fold(0.0, (sum, item) => sum + item.totalWeight);
    final double grandTotalPrice =
    bilty.categories.fold(0.0, (sum, item) => sum + item.totalPrice);

    // Find the 'AAA' 'Extra Large' category to get the bidding price.
    final aaaELCategory = bilty.categories.firstWhere(
          (c) => c.quality == 'AAA' && c.category == 'Extra Large',
    );
    final double biddingPrice = aaaELCategory.pricePerKg;

    pdf.addPage(
      pw.MultiPage(
        pageFormat: PdfPageFormat.a4,
        build: (pw.Context context) => [
          pw.Stack(children: [
            // 🔹 Watermark layer
            pw.Column(children: [
              // Header: logo left, title right
              pw.Row(
                crossAxisAlignment: pw.CrossAxisAlignment.center,
                children: [
                  pw.Container(
                    width: 80,
                    height: 60,
                    child: pw.Image(logoImage),
                  ),
                  pw.Expanded(child: pw.SizedBox(width: 16)),
                  pw.Container(
                      height: 60,
                      child: pw.Column(children: [
                        pw.Text(
                          'FasCorp',
                          style: pw.TextStyle(
                            font: font,
                            fontSize: 18,
                            fontWeight: pw.FontWeight.bold,
                            color: PdfColors.green,
                          ),
                          textAlign: pw.TextAlign.right,
                        ),
                        pw.SizedBox(height: 2),
                        pw.Text(
                          "Farming as a Service Initiative",
                          style: pw.TextStyle(
                            font: font,
                            fontSize: 14,
                            fontWeight: pw.FontWeight.bold,
                            color: PdfColors.green,
                          ),
                        ),
                        pw.SizedBox(height: 6),
                      ])),
                  pw.Expanded(child: pw.SizedBox(width: 16)),
                  pw.Container(
                    height: 60,
                    width: 120,
                    child: pw.Center(child: pw.Image(logo2Image)),
                  )
                ],
              ),
              pw.SizedBox(height: 4),
              pw.Divider(color: PdfColors.black, height: 1),
              pw.SizedBox(height: 2),
              pw.Row(children: [
                pw.Padding(
                    padding: pw.EdgeInsets.symmetric(vertical: 4),
                    child: pw.Container(
                        width: 220,
                        height: 80,
                        padding: pw.EdgeInsets.all(4),
                        child: pw.Column(
                            mainAxisAlignment: pw.MainAxisAlignment.spaceAround,
                            crossAxisAlignment: pw.CrossAxisAlignment.start,
                            children: [
                              if (consignmentNo != null &&
                                  consignmentNo.isNotEmpty)
                                pw.Center(
                                  child: pw.Text(
                                      'Consignment No.: $consignmentNo',
                                      style: pw.TextStyle(
                                          font: font,
                                          fontSize: 12,
                                          fontWeight: pw.FontWeight.bold)),
                                ),
                              if (growerName != null && growerName.isNotEmpty)
                                pw.Text('Grower: ${growerName}',
                                    style:
                                        pw.TextStyle(font: font, fontSize: 12)),

                            ]))),
                pw.SizedBox(width: 15),
                pw.Padding(
                    padding: pw.EdgeInsets.symmetric(vertical: 4),
                    child: pw.Container(
                        width: 220,
                        height: 80,
                        padding: pw.EdgeInsets.all(4),
                        child: pw.Column(
                            mainAxisAlignment: pw.MainAxisAlignment.spaceAround,
                            crossAxisAlignment: pw.CrossAxisAlignment.start,
                            children: [
                              if (packhouseName != null &&
                                  packhouseName.isNotEmpty)
                                pw.Text('Packhouse: $packhouseName',
                                    style:
                                    pw.TextStyle(font: font, fontSize: 12)),
                              if (aadhatiName != null && aadhatiName.isNotEmpty)
                                pw.Text('Aadhati: $aadhatiName',
                                    style:
                                    pw.TextStyle(font: font, fontSize: 12)),
                            ]))),
                pw.SizedBox(height: 16),
              ]),
              // Table
              pw.Table(
                border: pw.TableBorder.all(),
                children: [
                  pw.TableRow(
                    decoration: pw.BoxDecoration(
                      color: getPdfHeaderColor(),
                    ),
                    children: [
                      _buildHeaderCell('Quality', font,
                          align: pw.TextAlign.center),
                      _buildHeaderCell('Category', font,
                          align: pw.TextAlign.center),
                      _buildHeaderCell('Variety', font,
                          align: pw.TextAlign.center),
                      _buildHeaderCell('Count', font,
                          align: pw.TextAlign.center),
                      _buildHeaderCell('Gross Weight', font,
                          align: pw.TextAlign.center),
                      _buildHeaderCell('No. of Boxes', font,
                          align: pw.TextAlign.center),
                      _buildHeaderCell('Total Weight', font,
                          align: pw.TextAlign.center),
                      _buildHeaderCell('Price perKg', font,
                          align: pw.TextAlign.center),
                      _buildHeaderCell('Total Price', font,
                          align: pw.TextAlign.center),
                    ],
                  ),
                  ...bilty.categories
                      .where((category) => category.boxCount > 0)
                      .map((category) => pw.TableRow(
                            decoration: pw.BoxDecoration(
                                color: getPdfRowColor(category.quality)),
                            children: [
                              _buildDataCell(category.quality, font,
                                  align: pw.TextAlign.center),
                              _buildDataCell(category.category, font,
                                  align: pw.TextAlign.center),
                              _buildDataCell(category.variety, font,
                                  align: pw.TextAlign.center),
                              _buildDataCell(
                                  category.piecesPerBox.toString(), font,
                                  align: pw.TextAlign.center),
                              _buildDataCell(
                                  '${category.avgBoxWeight.toStringAsFixed(1)}kg',
                                  font,
                                  align: pw.TextAlign.center),
                              _buildDataCell('${category.boxCount}', font,
                                  align: pw.TextAlign.center),
                              _buildDataCell(
                                  '${category.totalWeight.toStringAsFixed(1)}kg',
                                  font,
                                  align: pw.TextAlign.center),
                              _buildDataCell(
                                  'Rs.${category.pricePerKg.toStringAsFixed(1)}',
                                  font,
                                  align: pw.TextAlign.center),
                              _buildDataCell(
                                  'Rs.${category.totalPrice.toStringAsFixed(1)}',
                                  font,
                                  align: pw.TextAlign.center),
                            ],
                          )),
                ],
              ),
              pw.SizedBox(height: 18),
               // Space between tables
      // Adjust width as needed

              pw.Table(
                border: pw.TableBorder.all(
                ),
                columnWidths: {
                  0: const pw.FlexColumnWidth(1.5),
                  1: const pw.FlexColumnWidth(1.2),
                  2: const pw.FlexColumnWidth(1.8),
                  3: const pw.FlexColumnWidth(1.5),
                },
                children: [
                  // Header Row
                  pw.TableRow(
                    decoration: pw.BoxDecoration(
                      color: PdfColors.amber400,
                      borderRadius: const pw.BorderRadius.only(
                        topLeft: pw.Radius.circular(4),
                        topRight: pw.Radius.circular(4),
                      ),
                    ),
                    children: [
                      _buildEnhancedHeaderCell('Bidding Price', font),
                      _buildEnhancedHeaderCell('No of Boxes', font),
                      _buildEnhancedHeaderCell('Grand Total Weight', font),
                      _buildEnhancedHeaderCell('Grand Total Price', font),
                    ],
                  ),
                  // Data Row
                  pw.TableRow(
                    decoration: const pw.BoxDecoration(
                      color: PdfColors.blueGrey,
                      borderRadius: pw.BorderRadius.only(
                        bottomLeft: pw.Radius.circular(4),
                        bottomRight: pw.Radius.circular(4),
                      ),
                    ),
                    children: [
                      _buildEnhancedDataCell(
                        biddingPrice > 0 ? 'Rs. ${biddingPrice.toStringAsFixed(1)}' : 'N/A',
                        font,
                      ),
                      _buildEnhancedDataCell('$totalBoxes', font),
                      _buildEnhancedDataCell('${grandTotalWeight.toStringAsFixed(1)} kg', font),
                      _buildEnhancedDataCell('Rs. ${grandTotalPrice.toStringAsFixed(1)}', font),
                    ],
                  ),
                ],
              ),
              pw.SizedBox(height: 18),
              // App download text
              pw.Center(
                child: pw.Row(
                  mainAxisSize: pw.MainAxisSize.min,
                  children: [
                    pw.Text(
                      'For viewing Images download the app: ',
                      style: pw.TextStyle(
                          font: font, fontSize: 14, color: PdfColors.blueGrey),
                    ),
                    pw.UrlLink(
                      destination: websiteUrl,
                      child: pw.Text(
                        websiteUrl,
                        style: pw.TextStyle(
                          color: PdfColors.blue,
                          decoration: pw.TextDecoration.underline,
                          font: font,
                          fontSize: 14,
                        ),
                      ),
                    ),
                  ],
                ),
              )
            ]),
            pw.Positioned.fill(
              child: pw.Center(
                child: pw.Transform.rotate(
                  angle: -0.5, // Rotate watermark
                  child: pw.Opacity(
                    opacity: 0.5,
                    child: pw.Text(
                      'FASCORP',
                      style: pw.TextStyle(
                        fontSize: 80,
                        color: PdfColors.grey,
                        fontWeight: pw.FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ]),
        ],
      ),
    );
    // Add a second page for the charts (2x2 grid)
    pdf.addPage(
      pw.Page(
        pageFormat: PdfPageFormat.a4,
        build: (pw.Context context) => pw.Stack(children: [
          // 🔹 Watermark layer
          pw.Center(
            child: pw.Column(
              mainAxisAlignment: pw.MainAxisAlignment.center,
              children: [
                pw.Center(
                  child: pw.Text("Bilty Distribution Graphs",
                      style: pw.TextStyle(fontSize: 22)),
                ),
                pw.Divider(color: PdfColors.black),
                pw.SizedBox(height: 16),
                pw.Row(
                  mainAxisAlignment: pw.MainAxisAlignment.center,
                  crossAxisAlignment: pw.CrossAxisAlignment.start,
                  children: [
                    pw.Expanded(
                        child: buildDonutChartPdf(
                      data: qualityShare,
                      colors: [
                        PdfColors.red,
                        PdfColors.yellow,
                        PdfColors.green
                      ],
                      title: 'Overall',
                      font: font,
                      size: 100,
                      arcWidth: 40,
                      gapDegrees: 4,
                      drawLegendLines: false,
                      totalBoxes: qualityBoxCount.values
                          .fold(0, (sum, v) => (sum ?? 0) + (v ?? 0)),
                      totalWeight: totalWeight,
                    )),
                    pw.SizedBox(width: 24),
                    pw.Expanded(
                        child: buildDonutChartPdf(
                      data: aaaCategoryShare,
                      colors: [
                        PdfColors.blue,
                        PdfColors.orange,
                        PdfColors.purple,
                        PdfColors.amber
                      ],
                      title: 'AAA',
                      font: font,
                      size: 100,
                      arcWidth: 40,
                      gapDegrees: 4,
                      drawLegendLines: false,
                      totalBoxes: aaaCatBoxCount.values
                          .fold(0, (sum, v) => (sum ?? 0) + (v ?? 0)),
                      totalWeight: totalAAAWeight,
                    )),
                  ],
                ),
                pw.SizedBox(height: 16),
                pw.Divider(color: PdfColors.black),
                pw.SizedBox(height: 16),
                pw.Row(
                  mainAxisAlignment: pw.MainAxisAlignment.center,
                  crossAxisAlignment: pw.CrossAxisAlignment.start,
                  children: [
                    pw.Expanded(
                      child: buildDonutChartPdf(
                        data: aaCatMap,
                        colors: aaCatColors,
                        title: 'AA',
                        font: font,
                        size: 100,
                        arcWidth: 40,
                        gapDegrees: 4,
                        drawLegendLines: false,
                        totalBoxes: aaCatBoxCount.values
                            .fold(0, (sum, v) => (sum ?? 0) + (v ?? 0)),
                        totalWeight: totalAAWeight,
                      ),
                    ),
                    pw.SizedBox(width: 24),
                    pw.Expanded(
                      child: buildDonutChartPdf(
                        data: gpCatMap,
                        colors: gpCatColors,
                        title: 'GP',
                        font: font,
                        size: 100,
                        arcWidth: 40,
                        gapDegrees: 4,
                        drawLegendLines: false,
                        totalBoxes: gpCatBoxCount.values
                            .fold(0, (sum, v) => (sum ?? 0) + (v ?? 0)),
                        totalWeight: totalGPWeight,
                      ),
                    ),
                  ],
                ),
                pw.SizedBox(height: 12),
              ],
            ),
          ),
          pw.Positioned.fill(
            child: pw.Center(
              child: pw.Transform.rotate(
                angle: -0.5, // Rotate watermark
                child: pw.Opacity(
                  opacity: 0.5,
                  child: pw.Text(
                    'FASCORP',
                    style: pw.TextStyle(
                      fontSize: 80,
                      color: PdfColors.grey,
                      fontWeight: pw.FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ),
          ),
        ]),
      ),
    );
    pdf.addPage(pw.Page(
      pageFormat: PdfPageFormat.a4,
      build: (pw.Context context) => pw.Stack(children: [
        // 🔹 Watermark layer
        pw.Center(
          child: pw.Column(
            mainAxisAlignment: pw.MainAxisAlignment.center,
            children: [
              pw.Center(
                child: pw.Text("Bilty Distribution Graphs",
                    style: pw.TextStyle(fontSize: 22)),
              ),
              pw.Divider(color: PdfColors.black),
              pw.SizedBox(height: 20),
              pw.Row(
                  mainAxisAlignment: pw.MainAxisAlignment.center,
                  crossAxisAlignment: pw.CrossAxisAlignment.start,
                  children: [
                    pw.Container(
                      width: 480,
                      child: pw.Image(aaaImage, fit: pw.BoxFit.contain),
                    ),
                  ]),
              pw.SizedBox(height: 20),
              pw.SizedBox(height: 60),
              pw.Container(
                  child: pw.Text(
                      textAlign: pw.TextAlign.justify,
                      "The Boxes in this Consignment no ${consignmentNo!} has been packed in ${packhouseName!} Pack House under my observation /Supervision for any kind of Human errors while packing more than 5% I take full responsibility of the consignment.")),
              pw.SizedBox(height: 10),
              pw.Column(
                  crossAxisAlignment: pw.CrossAxisAlignment.end,
                  children: [
                    pw.Row(
                        mainAxisAlignment: pw.MainAxisAlignment.end,
                        children: [
                          pw.Text(
                            growerName!,
                            style: pw.TextStyle(fontSize: 12),
                          )
                        ]),
                    pw.Row(
                        mainAxisAlignment: pw.MainAxisAlignment.end,
                        children: [
                          pw.Text("${date}", style: pw.TextStyle(fontSize: 10))
                        ]),
                  ]),
              pw.Container(height: 45),
              pw.Divider(color: PdfColors.black, height: 1),
              pw.SizedBox(height: 4),
              pw.Center(
                child: pw.Text(
                    "Copyright © Dev Bhardwaj 2025. All rights reserved.\n No part of this work shall be copied by any device-mechanical, electronic or other, stored in a retrieval system or transmitted in any form or any means without prior permission",
                    textAlign: pw.TextAlign.center,
                    softWrap: true,
                    maxLines: 3,
                    style: pw.TextStyle(fontSize: 8)),
              )
            ],
          ),
        ),
      ]),
    ));

    final pdfBytes = await pdf.save();
    final fileName = (consignmentNo != null && consignmentNo.isNotEmpty)
        ? '$consignmentNo.pdf'
        : 'bilty_step2.pdf';
    if (kIsWeb) {
      await Printing.sharePdf(bytes: pdfBytes, filename: fileName);
    } else {
      final tempDir = Directory.systemTemp;
      final file = File('${tempDir.path}/$fileName');
      await file.writeAsBytes(pdfBytes);
      await Share.shareXFiles([XFile(file.path)],
          text: 'Bilty PDF\n$websiteUrl');
    }
    Get.back();
  } catch (e) {
    print('Error generating PDF: $e');
    rethrow;
  }
}




