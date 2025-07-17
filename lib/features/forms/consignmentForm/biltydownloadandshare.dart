import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:pdf/pdf.dart';
import 'package:printing/printing.dart';
import 'package:share_plus/share_plus.dart';
import 'package:flutter/material.dart' as material;
import 'package:flutter/services.dart' show rootBundle;
// For font support
import '../../../models/bilty_model.dart';

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

Future<void> shareBilty(
  Bilty bilty, {
  required String websiteUrl,
  String? growerName,
  String? packhouseName,
  String? consignmentNo,
  String? aadhatiName,
}) async {
  try {
    print('shareBilty: categories count = ${bilty.categories.length}');
    for (var i = 0; i < bilty.categories.length; i++) {
      print('shareBilty: category[$i] = ${bilty.categories[i]}');
    }
    if (bilty.categories.isEmpty) {
      print('shareBilty: No categories available in the bilty');
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
            child: pw.Column(
                children: [
                  pw.Row(
                    mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                    children: [
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
                      pw.Image(logoImage, width: 80, height: 80),
                    ]
                  ),

              pw.SizedBox(height: 16),
            ]),
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
                  _buildHeaderCell('Avg. Weight Per Piece', font),
                  _buildHeaderCell('Avg. Gross Box Weight', font),
                  _buildHeaderCell('No. of Boxes', font),
                  _buildHeaderCell('Total Weight', font),
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

// Helper function for header cells
pw.Widget _buildHeaderCell(String text, pw.Font font) {
  return pw.Padding(
    padding: const pw.EdgeInsets.all(4),
    child: pw.Text(text,
        style: pw.TextStyle(
          fontWeight: pw.FontWeight.bold,
          font: font,
        )),
  );
}

// Helper function for data cells
pw.Widget _buildDataCell(String text, pw.Font font) {
  return pw.Padding(
    padding: const pw.EdgeInsets.all(4),
    child: pw.Text(text,
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
                  pw.Image(logoImage, width: 80, height: 80),
                ]
              ),
              pw.SizedBox(height: 16),
            ]),
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
                  _buildHeaderCell('Avg. Weight Per Piece', font),
                  _buildHeaderCell('Avg. Gross Box Weight', font),
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
