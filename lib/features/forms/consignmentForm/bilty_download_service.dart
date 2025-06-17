import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:universal_html/html.dart' as html;
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';
import 'package:cross_file/cross_file.dart';
import 'dart:io';
import 'consignment_form_controller.dart';
import 'consignment_form_widgets.dart';

class BiltyDownloadService {
  static Future<void> downloadBiltyAsCSV(
      ConsignmentFormController controller) async {
    if (controller.bilty.value == null) return;

    final StringBuffer csv = StringBuffer();

    // Add headers
    csv.writeln(
        'Quality,Category,Size,Pieces/Box,Avg Weight (g),Box Count,Box Weight (kg),Total Weight (kg)');

    // Add data rows
    for (var category in controller.bilty.value!.categories) {
      final key = controller.getUniqueKey(category.quality, category.category);
      final avgWeight = controller.avgWeightControllers[key]?.text ?? '0';
      final boxCount = controller.boxCountControllers[key]?.text ?? '0';
      final boxWeight =
          controller.avgBoxWeights[key]?.value.toStringAsFixed(2) ?? '0.00';
      final totalWeight =
          controller.totalWeights[key]?.value.toStringAsFixed(2) ?? '0.00';

      csv.writeln([
        category.quality,
        category.category,
        category.size,
        category.piecesPerBox,
        avgWeight,
        boxCount,
        boxWeight,
        totalWeight
      ].join(','));
    }

    // Add summary
    csv.writeln('\nSummary');
    csv.writeln('Total Boxes,${controller.totalTableBoxes.value}');
    csv.writeln(
        'Total Weight (kg),${controller.totalTableWeight.value.toStringAsFixed(2)}');

    final fileName =
        'bilty_${DateTime.now().toString().split('.')[0].replaceAll(':', '-')}.csv';
    final csvContent = csv.toString();

    if (kIsWeb) {
      // Web platform
      final blob = html.Blob([csvContent]);
      final url = html.Url.createObjectUrlFromBlob(blob);
      final anchor = html.AnchorElement(href: url)
        ..setAttribute('download', fileName)
        ..click();
      html.Url.revokeObjectUrl(url);
      // Show success message for web
      Get.snackbar(
        'Success',
        'Bilty downloaded successfully',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: const Color(0xff548235),
        colorText: Colors.white,
        duration: Duration(seconds: 5),
      );
    } else {
      // Mobile platforms (Android/iOS)
      try {
        final directory = await getApplicationDocumentsDirectory();
        final file = File('${directory.path}/$fileName');
        await file.writeAsString(csvContent);

        // Share the file using ShareX
        await Share.shareXFiles(
          [XFile(file.path)],
          text: 'Bilty Details',
        );

        // Show success message
        Get.snackbar(
          'Success',
          'Bilty shared successfully',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: const Color(0xff548235),
          colorText: Colors.white,
          duration: Duration(seconds: 5),
        );
      } catch (e) {
        Get.snackbar(
          'Error',
          'Failed to share bilty: $e',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.red,
          colorText: Colors.white,
        );
      }
    }
  }

  static Future<void> downloadBiltyAsPDF(
      ConsignmentFormController controller) async {
    // TODO: Implement PDF download functionality
    // This would require additional PDF generation library
    Get.snackbar(
      'Coming Soon',
      'PDF download functionality will be available soon',
      snackPosition: SnackPosition.BOTTOM,
      backgroundColor: Colors.blue,
      colorText: Colors.white,
    );
  }
}
