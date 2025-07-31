import 'dart:convert';
import 'dart:io';
import 'package:flutter/foundation.dart';
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
      return material.Colors.yellow.shade700;
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
      return PdfColor.fromInt(material.Colors.yellow.shade700.value);
    case 'MIX/PEAR':
      return PdfColor.fromInt(material.Colors.pink.shade300.value);
    default:
      return PdfColor.fromInt(material.Colors.grey.shade200.value);
  }
}

PdfColor getPdfHeaderColor() {
  return PdfColor.fromInt(material.Colors.orange.shade200.value);
}

Future<Uint8List> loadImage(
  List<BiltyCategory> categories,
  String quality, // "AAA", "AA", or "GP"
) async {
  // 1. Filter the list for the specified quality
  final filteredList = categories.where((c) => c.quality == quality).toList();

  if (filteredList.isEmpty) {
    throw Exception('No data available for quality: $quality');
  }

  // 2. Generate the three data lists
  final List<String> categoryLabels =
      filteredList.map((c) => c.category).toList();
  final List<double> weightData =
      filteredList.map((c) => c.totalWeight).toList();
  final List<int> boxData = filteredList.map((c) => c.boxCount).toList();

  // 3. Create the simple JSON body as per your sample request
  final body = json.encode({
    'quality': quality,
    'categories': categoryLabels,
    'weights': weightData,
    'boxes': boxData,
  });

  // As requested, the API URL is a placeholder for your local server.
  // You will need to replace this with your actual server address.
  final String apiUrl = 'https://bot-1buv.onrender.com/chart';
  final url = Uri.parse(apiUrl);

  final headers = {
    'Content-Type': 'application/json',
  };

  // 4. Make the API call and get the image data
  try {
    final response = await http.post(url, headers: headers, body: body);

    if (response.statusCode == 200) {
      // Return the image data as a Uint8List
      return response.bodyBytes;
    } else {
      // Provide more detailed error info from your server's response
      throw Exception(
          'Failed to load chart image. Status: ${response.statusCode}, Body: ${response.body}');
    }
  } catch (e) {
    // Catch connection errors, etc.
    throw Exception('Error contacting your chart server: $e');
  }
}

// Helper to draw a donut chart in PDF with side legend
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
  // Filter out zero-value segments
  final filtered = data.entries.where((e) => e.value > 0).toList();
  if (filtered.isEmpty) return pw.SizedBox();
  final keys = filtered.map((e) => e.key).toList();
  final values = filtered.map((e) => e.value).toList();
  final total = values.fold(0.0, (a, b) => a + b);

  // Calculate arc midpoints outside the painter
  final arcMidpoints = <PdfPoint>[];
  double startAngle = -90.0;
  final outerRadius = 35.0;
  final innerRadius = 25.0;
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

  // Calculate arc label positions for percentages
  // Removed arcLabelPoints calculation as percentage labels are no longer needed

  return pw.Column(
    crossAxisAlignment: pw.CrossAxisAlignment.center,
    children: [
      pw.Center(
        child: pw.Text(
          title,
          style: pw.TextStyle(
            font: font,
            fontSize: 18,
            fontWeight: pw.FontWeight.bold,
          ),
          textAlign: pw.TextAlign.left,
        ),
      ),
      pw.Row(
        mainAxisAlignment: pw.MainAxisAlignment.center,
        crossAxisAlignment: pw.CrossAxisAlignment.center,
        children: [
          // Donut chart (fixed outer/inner radius, no arc labels)
          pw.Stack(alignment: pw.Alignment.center, children: [
            pw.Container(
              width: size,
              height: size,
              child: pw.CustomPaint(
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
                    // Draw white separator arc (thin line) at the start of each segment
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
                  // Inner white circle for donut effect
                  ctx.setFillColor(PdfColors.white);
                  ctx.drawEllipse(center.x, center.y, innerRadius, innerRadius);
                  ctx.fillPath();
                },
              ),
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
          pw.SizedBox(width: 20),
          // Legend
          pw.Container(
            height: 200,
            width: 100,
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
                              width: 18,
                              height: 18,
                              decoration: pw.BoxDecoration(
                                color: colors[i % colors.length],
                                borderRadius: pw.BorderRadius.circular(3),
                              ),
                            ),
                            pw.SizedBox(width: 8),
                            pw.Text(
                              keys[i],
                              style: pw.TextStyle(font: font, fontSize: 11),
                            ),
                            pw.SizedBox(width: 8),
                            pw.Text(
                              '${values[i].toStringAsFixed(1)}%',
                              style: pw.TextStyle(
                                  font: font,
                                  fontSize: 13,
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
    final aaaImageBytes = await loadImage(bilty.categories, 'AAA');
    final aaaImage = pw.MemoryImage(aaaImageBytes);
    final aaImageBytes = await loadImage(bilty.categories, 'AA');
    final aaImage = pw.MemoryImage(aaImageBytes);
    final gpImageBytes = await loadImage(bilty.categories, 'GP');
    final gpImage = pw.MemoryImage(gpImageBytes);
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
          // Header: logo left, title right
          pw.Row(
            crossAxisAlignment: pw.CrossAxisAlignment.start,
            children: [
              pw.Container(
                width: 80,
                height: 80,
                child: pw.Image(logoImage),
              ),
              pw.Expanded(child: pw.SizedBox(width: 16)),
              pw.Column(children: [
                pw.Text(
                  'FasCorp',
                  style: pw.TextStyle(
                    font: font,
                    fontSize: 32,
                    fontWeight: pw.FontWeight.bold,
                    color: PdfColors.green,
                  ),
                  textAlign: pw.TextAlign.right,
                ),
                pw.Text(
                  "Farmer as Service Initiative",
                  style: pw.TextStyle(
                    font: font,
                    fontSize: 16,
                    fontWeight: pw.FontWeight.bold,
                    color: PdfColors.green,
                  ),
                )
              ]),
              pw.Expanded(child: pw.SizedBox(width: 16)),
              pw.Container(
                height: 80,
                width: 120,
                child: pw.Center(child: pw.Image(logo2Image)),
              )
            ],
          ),
          if (consignmentNo != null && consignmentNo.isNotEmpty)
            pw.Center(
              child: pw.Text('Consignment No.: $consignmentNo',
                  style: pw.TextStyle(
                      font: font,
                      fontSize: 24,
                      fontWeight: pw.FontWeight.bold)),
            ),
          pw.SizedBox(height: 16),
          // Info,
          pw.Row(children: [
            pw.Padding(
                padding: pw.EdgeInsets.all(8),
                child: pw.Container(
                    width: 250,
                    height: 180,
                    decoration: pw.BoxDecoration(
                        border: pw.Border.all(color: PdfColors.black),
                        borderRadius: pw.BorderRadius.all(
                          pw.Radius.elliptical(12, 12),
                        )),
                    child: pw.Column(
                        mainAxisAlignment: pw.MainAxisAlignment.start,
                        children: [
                          if (growerName != null && growerName.isNotEmpty)
                            pw.Text('Grower Name: $growerName',
                                style: pw.TextStyle(font: font, fontSize: 14)),
                          if (packhouseName != null && packhouseName.isNotEmpty)
                            pw.Text('Packhouse Name: $packhouseName',
                                style: pw.TextStyle(font: font, fontSize: 14)),
                          if (aadhatiName != null && aadhatiName.isNotEmpty)
                            pw.Text('Aadhati Name: $aadhatiName',
                                style: pw.TextStyle(font: font, fontSize: 14)),
                        ]))),
            pw.SizedBox(width: 10),
            if (remark!.isNotEmpty)
              pw.Padding(
                  padding: pw.EdgeInsets.all(8),
                  child: pw.Container(
                      width: 250,
                      height: 300,
                      decoration: pw.BoxDecoration(
                          border: pw.Border.all(color: PdfColors.black),
                          borderRadius: pw.BorderRadius.all(
                            pw.Radius.elliptical(12, 12),
                          )),
                      padding: pw.EdgeInsets.all(8),
                      child: pw.Column(
                          children: [

                            pw.Center(
                              child: pw.Text('Remarks',
                                  style: pw.TextStyle(
                                      font: font,
                                      fontSize: 14,
                                      fontWeight: pw.FontWeight.bold,decoration: pw.TextDecoration.underline,color: PdfColors.yellow )),
                            ),
                        pw.Text("${remark}",
                            style: pw.TextStyle(font: font, fontSize: 10))
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
                  _buildHeaderCell('Quality', font, align: pw.TextAlign.center),
                  _buildHeaderCell('Category', font,
                      align: pw.TextAlign.center),
                  _buildHeaderCell('Variety', font, align: pw.TextAlign.center),
                  _buildHeaderCell('Count', font, align: pw.TextAlign.center),
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
                          _buildDataCell(category.piecesPerBox.toString(), font,
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
          ),
        ],
      ),
    );
    // Add a second page for the charts (2x2 grid)
    pdf.addPage(pw.Page(
      pageFormat: PdfPageFormat.a4,
      build: (pw.Context context) => pw.Center(
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
                    height: 300,
                    width: 300,
                    child: pw.Image(aaaImage, fit: pw.BoxFit.contain),
                  ),
                ]),
            pw.SizedBox(height: 20),
            pw.Row(
              mainAxisAlignment: pw.MainAxisAlignment.center,
              crossAxisAlignment: pw.CrossAxisAlignment.start,
              children: [
                pw.Container(
                  height: 300,
                  width: 300,
                  child: pw.Image(aaImage, fit: pw.BoxFit.contain),
                ),
              ],
            ),
            pw.SizedBox(height: 20),
            pw.Row(
              mainAxisAlignment: pw.MainAxisAlignment.center,
              crossAxisAlignment: pw.CrossAxisAlignment.start,
              children: [
                pw.Container(
                  height: 300,
                  width: 300,
                  child: pw.Image(gpImage, fit: pw.BoxFit.contain),
                ),
              ],
            ),
          ],
        ),
      ),
    ));
    pdf.addPage(
      pw.Page(
        pageFormat: PdfPageFormat.a4,
        build: (pw.Context context) => pw.Center(
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
                  buildDonutChartPdf(
                    data: qualityShare,
                    colors: [PdfColors.red, PdfColors.yellow, PdfColors.green],
                    title: 'Overall',
                    font: font,
                    size: 80,
                    arcWidth: 20,
                    gapDegrees: 4,
                    drawLegendLines: false,
                    totalBoxes: qualityBoxCount.values
                        .fold(0, (sum, v) => (sum ?? 0) + (v ?? 0)),
                    totalWeight: totalWeight,
                  ),
                  pw.SizedBox(width: 24),
                  buildDonutChartPdf(
                    data: aaaCategoryShare,
                    colors: [
                      PdfColors.blue,
                      PdfColors.orange,
                      PdfColors.purple,
                      PdfColors.amber
                    ],
                    title: 'AAA',
                    font: font,
                    size: 80,
                    arcWidth: 20,
                    gapDegrees: 4,
                    drawLegendLines: false,
                    totalBoxes: aaaCatBoxCount.values
                        .fold(0, (sum, v) => (sum ?? 0) + (v ?? 0)),
                    totalWeight: totalAAAWeight,
                  ),
                ],
              ),
              pw.SizedBox(height: 16),
              pw.Divider(color: PdfColors.black),
              pw.SizedBox(height: 20),
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
                      size: 80,
                      arcWidth: 20,
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
                      size: 80,
                      arcWidth: 20,
                      gapDegrees: 4,
                      drawLegendLines: false,
                      totalBoxes: gpCatBoxCount.values
                          .fold(0, (sum, v) => (sum ?? 0) + (v ?? 0)),
                      totalWeight: totalGPWeight,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );

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
        height: 50, // You can tweak this depending on your layout
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
    padding: const pw.EdgeInsets.all(4),
    child: pw.Text(text,
        textAlign: align,
        style: pw.TextStyle(
          color: PdfColors.white,
          font: font,
        )),
  );
}

Future<void> downloadFinalBilty(
  Bilty bilty, {
  String? growerName,
  String? packhouseName,
  String? aadhatiName,
  String? consignmentNo,
  required String websiteUrl,
}) async {
  try {
    print('downloadFinalBilty: categories count = ${bilty.categories.length}');
    for (var i = 0; i < bilty.categories.length; i++) {
      print('downloadFinalBilty: category[$i] = ${bilty.categories[i]}');
    }
    if (bilty.categories.isEmpty) {
      print('downloadFinalBilty: No categories available in the bilty');
      throw Exception('No categories available in the bilty');
    }
    final font = await PdfGoogleFonts.tillanaMedium();
    // Load the image asset
    final logoBytes = await rootBundle.load('assets/images/bilty.png');
    final logoImage = pw.MemoryImage(logoBytes.buffer.asUint8List());
    final pdf = pw.Document();
    pdf.addPage(
      pw.MultiPage(
        pageFormat: PdfPageFormat.a4.landscape,
        build: (pw.Context context) => [
          pw.Center(
            child: pw.Column(children: [
              pw.Row(
                  mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                  children: [
                    pw.Image(logoImage, width: 80, height: 80),
                    pw.Text(
                      'HP Marketing Board Approved - Consignment\nDetails Receipt',
                      style: pw.TextStyle(
                        font: font,
                        fontSize: 24,
                        fontWeight: pw.FontWeight.bold,
                        color: PdfColors.blue200,
                        decoration: pw.TextDecoration.underline,
                      ),
                      textAlign: pw.TextAlign.center,
                    ),
                  ]),
              pw.SizedBox(height: 16),
            ]),
          ),
          pw.Positioned(
            left: 0,
            right: 0,
            bottom: 16,
            child: pw.Center(
              child: pw.Text(
                '*Technology partner Techori',
                style: pw.TextStyle(
                  font: font,
                  fontSize: 12,
                  color: PdfColors.grey,
                ),
              ),
            ),
          ),
          if (growerName != null && growerName.isNotEmpty)
            pw.Text('Grower Name: $growerName',
                style: pw.TextStyle(font: font, fontSize: 14)),
          if (packhouseName != null && packhouseName.isNotEmpty)
            pw.Text('Packhouse Name: $packhouseName',
                style: pw.TextStyle(font: font, fontSize: 14)),
          if (consignmentNo != null && consignmentNo.isNotEmpty)
            pw.Text('Consignment No.: $consignmentNo',
                style: pw.TextStyle(font: font, fontSize: 14)),
          if (aadhatiName != null && aadhatiName.isNotEmpty)
            pw.Text('Aadhati Name: $aadhatiName',
                style: pw.TextStyle(font: font, fontSize: 14)),
          pw.SizedBox(height: 12),
          pw.Table(
            border: pw.TableBorder.all(),
            children: [
              pw.TableRow(
                decoration: pw.BoxDecoration(color: getPdfHeaderColor()),
                children: [
                  _buildHeaderCell('Quality', font),
                  _buildHeaderCell('Category', font),
                  _buildHeaderCell('Variety', font),
                  _buildHeaderCell('Size in MM', font),
                  _buildHeaderCell('No. of Pieces', font),
                  _buildHeaderCell('Avg. Wt/Piece', font),
                  _buildHeaderCell('Box Weight', font),
                  _buildHeaderCell('No. of Boxes', font),
                  _buildHeaderCell('Total Weight', font),
                  _buildHeaderCell('Price Per Kg', font),
                  _buildHeaderCell('Box Value', font),
                  _buildHeaderCell('Total Price', font),
                ],
              ),
              ...bilty.categories
                  .where((category) => category.boxCount > 0)
                  .map((category) => pw.TableRow(
                        decoration: pw.BoxDecoration(
                            color: getPdfRowColor(category.quality)),
                        children: [
                          _buildDataCell(category.quality, font),
                          _buildDataCell(category.category, font),
                          _buildDataCell(category.variety, font),
                          _buildDataCell(category.size, font),
                          _buildDataCell('${category.piecesPerBox}', font),
                          _buildDataCell(
                              '${category.avgWeight.toStringAsFixed(1)}g',
                              font),
                          _buildDataCell(
                              '${category.avgBoxWeight.toStringAsFixed(1)}kg',
                              font),
                          _buildDataCell('${category.boxCount}', font),
                          _buildDataCell(
                              '${category.totalWeight.toStringAsFixed(1)}kg',
                              font),
                          _buildDataCell('${category.pricePerKg}', font),
                          _buildDataCell('${category.boxValue}', font),
                          _buildDataCell('${category.totalPrice}', font),
                        ],
                      )),
            ],
          ),
          pw.SizedBox(height: 24),
          pw.UrlLink(
            destination: websiteUrl,
            child: pw.Text(websiteUrl,
                style: pw.TextStyle(
                  color: PdfColors.blue,
                  decoration: pw.TextDecoration.underline,
                  font: font,
                )),
          ),
          pw.SizedBox(height: 4),
          pw.Text('technology partner Techori',
              style: pw.TextStyle(
                fontSize: 12,
                color: PdfColors.grey,
                font: font,
              )),
        ],
      ),
    );
    final pdfBytes = await pdf.save();
    final fileName = (consignmentNo != null && consignmentNo.isNotEmpty)
        ? '$consignmentNo.pdf'
        : 'final_bilty.pdf';
    if (kIsWeb) {
      await Printing.sharePdf(bytes: pdfBytes, filename: fileName);
    } else {
      final tempDir = Directory.systemTemp;
      final file = File('${tempDir.path}/$fileName');
      await file.writeAsBytes(pdfBytes);
      await Share.shareXFiles([XFile(file.path)],
          text: 'Final Bilty PDF\n$websiteUrl');
    }
  } catch (e) {
    print('Error generating final bilty PDF: $e');
    rethrow;
  }
}
