import 'package:apple_grower/features/forwardingPage/forwarding_page_controller.dart';
import 'package:apple_grower/navigation/routes_constant.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:get/get.dart';
import 'dart:io';

import 'package:apple_grower/features/forwardingBilty/forward_bilty_controller.dart';
import 'package:apple_grower/models/bilty_model.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:get/get.dart';

import '../forms/consignmentForm/VideoPlayer.dart';


class ForwardPageView  extends GetView<ForwardPageController> {
  RxBool showDetails = false.obs;
  RxBool isMobile = false.obs;
  final RxString selectedQuality = 'AAA'.obs;
  final RxDouble totalWeightOfSelected = 0.0.obs;

  Widget buildDonutChart(
      Map<String, double> data, List<Color> colors, String title,
      {void Function(String quality)? onSectionTap}) {
    RxBool isMobile = (MediaQuery.of(Get.context!).size.width > 900).obs;
    final keys = data.keys.toList();
    final sections = data.entries.map((entry) {
      final index = keys.indexOf(entry.key);
      return PieChartSectionData(
        color: colors[index % colors.length],
        value: entry.value,
        title: "${entry.key}\n${entry.value.toStringAsFixed(1)}%",
        titleStyle: TextStyle(
            fontSize: isMobile.value ? 14 : 10,
            fontWeight: FontWeight.bold,
            color: Colors.white),
        radius: 75,
      );
    }).toList();

    return Column(
      children: [
        Text(title,
            style: TextStyle(
                fontSize: isMobile.value ? 20 : 14,
                fontWeight: FontWeight.bold)),
        SizedBox(height: isMobile.value ? 16 : 40),
        Center(
          child: Container(
            height: isMobile.value ? 300 : 200,
            width: isMobile.value ? 300 : 200,
            child: GestureDetector(
              onTapUp: (details) async {
                // PieChart doesn't provide section tap out of the box, so use PieTouchData if needed
              },
              child: PieChart(
                PieChartData(
                  sections: sections,
                  centerSpaceRadius: isMobile.value ? 60 : 40,
                  sectionsSpace: isMobile.value ? 4 : 2,
                  pieTouchData: PieTouchData(
                    touchCallback: (event, response) {
                      if (response != null &&
                          response.touchedSection != null &&
                          onSectionTap != null) {
                        final idx =
                            response.touchedSection!.touchedSectionIndex;
                        if (idx >= 0 && idx < keys.length) {
                          onSectionTap(keys[idx]);
                        }
                      }
                    },
                  ),
                ),
              ),
            ),
          ),
        ),
        SizedBox(height: isMobile.value ? 16 :40),
        Center(
          child: SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: data.entries.map((entry) {
                final index = data.keys.toList().indexOf(entry.key);
                return Padding(
                  padding: EdgeInsets.only(right: isMobile.value ? 12 : 8),
                  child: buildCategoryBox(
                      entry.key, entry.value, colors[index % colors.length]),
                );
              }).toList(),
            ),
          ),
        ),
      ],
    );
  }

  Widget buildCategoryBox(String category, double percent, Color color) {
    RxBool isMobile = (MediaQuery.of(Get.context!).size.width > 900).obs;
    return Container(
      padding: EdgeInsets.symmetric(
          vertical: isMobile.value ? 12 : 8,
          horizontal: isMobile.value ? 18 : 10),
      decoration: BoxDecoration(
        color: color.withOpacity(0.85),
        borderRadius: BorderRadius.circular(isMobile.value ? 12 : 8),
        boxShadow: [
          BoxShadow(
            color: color.withOpacity(0.25),
            blurRadius: isMobile.value ? 8 : 4,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            category,
            style: TextStyle(
              fontSize: isMobile.value ? 16 : 12,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          SizedBox(width: isMobile.value ? 12 : 4),
          Text(
            "${percent.toStringAsFixed(1)}%",
            style: TextStyle(
              fontSize: isMobile.value ? 18 : 12,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
        ],
      ),
    );
  }

  Color getRowColor(String quality) {
    switch (quality.toUpperCase()) {
      case 'AAA':
        return Colors.red.shade700;
      case 'GP':
        return Colors.green.shade700;
      case 'AA':
        return Colors.yellow.shade700;
      case 'MIX/PEAR':
        return Colors.pink.shade300;
      default:
        return Colors.grey.shade200;
    }
  }

  biltyfinalView() {
    final bilty = controller.bilty.value;
    bool isMobile = !kIsWeb &&
        (defaultTargetPlatform == TargetPlatform.android ||
            defaultTargetPlatform == TargetPlatform.iOS);
    showDetails.value = !(isMobile);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Obx(() => TextButton.icon(
              icon: Icon(
                showDetails.value ? Icons.visibility_off : Icons.visibility,
                color: showDetails.value ? Colors.red : Colors.grey,
              ),
              label:
              Text(showDetails.value ? 'Hide Details' : 'Show Details'),
              onPressed: () {
                showDetails.value = !showDetails.value;
              },
            )),
          ],
        ),
        const SizedBox(height: 8),
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: SingleChildScrollView(
            scrollDirection: Axis.vertical,
            child: Obx(() => DataTable(
              headingRowColor: MaterialStateProperty.resolveWith(
                      (states) => Colors.orange.shade200),
              columns: [
                const DataColumn(label: Text("Quality")),
                const DataColumn(label: Text("Category")),
                if (showDetails.value) ...[
                  const DataColumn(label: Text("Variety")),
                  const DataColumn(label: Text("Size in MM")),
                  const DataColumn(label: Text("No. of Pieces")),
                  const DataColumn(label: Text("Avg. Weight Per Piece")),
                  const DataColumn(label: Text("Avg. Gross Box Weight")),
                  const DataColumn(label: Text("No. of Boxes")),
                  const DataColumn(label: Text("Total Weight")),
                ],
                const DataColumn(label: Text("Price Per Kg")),
                const DataColumn(label: Text("Box Value")),
                const DataColumn(label: Text("Total Price")),
                const DataColumn(label: Text("Image")),
              ],
              rows: List.generate(bilty.categories.length, (index) {
                final category = bilty.categories[index];
                if (category.boxCount == 0)
                  return null; // Hide rows with boxCount == 0
                final bgColor = getRowColor(category.quality);
                return DataRow(
                  color: MaterialStateProperty.resolveWith<Color?>(
                          (Set<MaterialState> states) => bgColor),
                  cells: [
                    DataCell(Text(category.quality,
                        style: const TextStyle(color: Colors.white))),
                    DataCell(Text(category.category,
                        style: const TextStyle(color: Colors.white))),
                    if (showDetails.value) ...[
                      DataCell(Text(category.variety,
                          style: const TextStyle(color: Colors.white))),
                      DataCell(Text(category.size,
                          style: const TextStyle(color: Colors.white))),
                      DataCell(Text("${category.piecesPerBox}",
                          style: const TextStyle(color: Colors.white))),
                      DataCell(Text(
                          "${category.avgWeight.toStringAsFixed(1)}g",
                          style: const TextStyle(color: Colors.white))),
                      DataCell(Text(
                          "${category.avgBoxWeight.toStringAsFixed(1)}kg",
                          style: const TextStyle(color: Colors.white))),
                      DataCell(Text("${category.boxCount}",
                          style: const TextStyle(color: Colors.white))),
                      DataCell(Text(
                          "${category.totalWeight.toStringAsFixed(1)}kg",
                          style: const TextStyle(color: Colors.white))),
                    ],
                    DataCell(Text("${category.pricePerKg}",
                        style: const TextStyle(color: Colors.white))),
                    DataCell(Text("${category.boxValue}",
                        style: const TextStyle(color: Colors.white))),
                    DataCell(Text("${category.totalPrice}",
                        style: const TextStyle(color: Colors.white))),
                    DataCell(
                      category.imagePath != null &&
                          category.imagePath!.isNotEmpty
                          ? GestureDetector(
                        onTap: () {
                          showDialog(
                            context: Get.context!,
                            builder: (context) => AlertDialog(
                              title: Text('Uploaded Image'),
                              content: Image.file(
                                  File(category.imagePath!)),
                              actions: [
                                TextButton(
                                  onPressed: () =>
                                      Navigator.of(context).pop(),
                                  child: const Text('Close'),
                                ),
                              ],
                            ),
                          );
                        },
                        child: const Icon(Icons.check_circle,
                            color: Colors.green),
                      )
                          : const Icon(Icons.camera_alt,
                          color: Colors.white),
                    ),
                  ],
                );
              }).whereType<DataRow>().toList(), // Filter out nulls
            )),
          ),
        ),
        const SizedBox(height: 16),
        // if (isMobile)
        //   Obx(() => controller.bilty.value.videoPath!.isNotEmpty
        //       ? Column(children: [
        //           TextButton.icon(
        //             icon: Icon(Icons.play_circle_fill, color: Colors.green),
        //             label: const Text('Play Video'),
        //             onPressed: () {
        //               showDialog(
        //                 context: Get.context!,
        //                 builder: (context) => AlertDialog(
        //                   title: const Text('Uploaded Video'),
        //                   content: AspectRatio(
        //                     aspectRatio: 16 / 9,
        //                     child: VideoPlayerWidget(
        //                         videoPath: controller.bilty.value.videoPath!),
        //                   ),
        //                   actions: [
        //                     TextButton(
        //                       onPressed: () => Navigator.of(context).pop(),
        //                       child: const Text('Close'),
        //                     ),
        //                   ],
        //                 ),
        //               );
        //             },
        //           ),
        //           const SizedBox(height: 8)
        //         ])
        //       : TextButton.icon(
        //           icon: Icon(Icons.play_circle_fill, color: Colors.grey),
        //           label: const Text('Play Video'),
        //           onPressed: null,
        //         )),
      ],
    );
  }

  Widget buildPercentageBox(String title, String value, Color color) {
    return Container(
      padding: EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(10),
        boxShadow: [
          BoxShadow(
            color: color.withOpacity(0.2),
            blurRadius: 6,
            offset: Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            title,
            style: TextStyle(
              fontSize: isMobile.value ? 14 : 8,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          Text(
            "$value%",
            style: TextStyle(
              fontSize: isMobile.value ? 28 : 14,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final qualityColors = [
      Colors.blue,
      Colors.grey,
      Colors.orange,
      Colors.green,
      Colors.purple,
      Colors.amber
    ];
    final aaaCatColors = [
      Colors.blue,
      Colors.orange,
      Colors.grey,
      Colors.amber,
      Colors.green,
      Colors.purple
    ];
    final Map<String, Color> categoryColorMap = {
      'Extra Large': Colors.blue,
      'Large': Colors.orange,
      'Medium': Colors.green,
      'Small': Colors.purple,
      'Extra Small': Colors.amber,
      'E Extra Small': Colors.teal,
      '240 Count': Colors.brown,
      'Pittu': Colors.red,
      'Seprator': Colors.indigo,
      'Mix/Pear': Colors.pink,
      // Add more as needed
    };


    return Scaffold(
      appBar: AppBar(
        title: const Text('Bilty Analysis'),
        backgroundColor: Colors.orange,
      ),
      backgroundColor: Colors.amber.shade50,
      body: Obx(() {
        final qualityMap = controller.qualityShare;
        final aaaMap = controller.aaaCategoryShare;
        final plotAreaPercent = controller.plotAreaShare.toStringAsFixed(0);
        RxBool isMobile = (MediaQuery.of(Get.context!).size.width > 900).obs;
        return SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Consignment reference info
                Card(
                  color: Colors.orange.shade100,
                  elevation: 2,
                  margin: EdgeInsets.only(bottom: isMobile.value? 18 :  8),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12)),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                        vertical: 12, horizontal: 18),
                    child: isMobile.value ?Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            const Text('Consignment ID: ',
                                style: TextStyle(fontWeight: FontWeight.bold)),
                            Text(controller.searchId.value,
                                style: const TextStyle(fontSize: 16)),
                          ],
                        ),
                        Row(
                          children: [
                            const Text('Grower: ',
                                style: TextStyle(fontWeight: FontWeight.bold)),
                            Text(controller.growerName.value,
                                style: const TextStyle(fontSize: 16)),
                          ],
                        ),
                      ],
                    ): Column(
                      children: [
                        Row(
                          children: [
                            const Text('Consignment ID: ',
                                style: TextStyle(fontWeight: FontWeight.bold)),
                            Text(controller.searchId.value,
                                style: const TextStyle(fontSize: 16)),
                          ],
                        ),
                        Row(
                          children: [
                            const Text('Grower:',
                                style: TextStyle(fontWeight: FontWeight.bold)),
                            Text(controller.growerName.value,
                                style: const TextStyle(fontSize: 16)),
                          ],
                        ),
                      ],

                    ),
                  ),
                ),
                isMobile.value?Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: Card(
                        elevation: 6,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(18)),
                        child: Padding(
                          padding: EdgeInsets.all(
                            isMobile.value ? 18 : 8,
                          ),
                          child: Container(
                            height: isMobile.value ? 500 : 300,
                            child: SingleChildScrollView(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  // Show overall totals above the chart
                                  Obx(() {
                                    final bilty = controller.bilty.value;
                                    return Row(
                                      mainAxisAlignment:
                                      MainAxisAlignment.spaceEvenly,
                                      children: [
                                        Column(
                                          children: [
                                            Text('Total Weight',
                                                style: TextStyle(
                                                    fontWeight: FontWeight.bold,
                                                    color: Colors
                                                        .orange.shade900)),
                                            Text(
                                                '${bilty.totalWeight.toStringAsFixed(2)} kg',
                                                style: TextStyle(
                                                    fontSize: 16,
                                                    fontWeight:
                                                    FontWeight.bold)),
                                          ],
                                        ),
                                        Column(
                                          children: [
                                            Text('Box Count',
                                                style: TextStyle(
                                                    fontWeight: FontWeight.bold,
                                                    color: Colors
                                                        .orange.shade900)),
                                            Text(
                                                '${bilty.totalBoxes.toStringAsFixed(0)}',
                                                style: TextStyle(
                                                    fontSize: 16,
                                                    fontWeight:
                                                    FontWeight.bold)),
                                          ],
                                        ),
                                        Column(
                                          children: [
                                            Text('Total Value',
                                                style: TextStyle(
                                                    fontWeight: FontWeight.bold,
                                                    color: Colors
                                                        .orange.shade900)),
                                            Text(
                                                '₹${bilty.totalValue.toStringAsFixed(2)}',
                                                style: TextStyle(
                                                    fontSize: 16,
                                                    fontWeight:
                                                    FontWeight.bold)),
                                          ],
                                        ),
                                      ],
                                    );
                                  }),
                                  SizedBox(height: 8),
                                  Obx(() => buildDonutChart(
                                    qualityMap,
                                    qualityColors,
                                    "Quality Distribution",
                                    onSectionTap: (quality) {
                                      selectedQuality.value = quality;
                                      // Calculate total weight for selected quality
                                      final total = controller
                                          .bilty.value.categories
                                          .where(
                                              (c) => c.quality == quality)
                                          .fold<double>(
                                          0,
                                              (sum, c) =>
                                          sum + c.totalWeight);
                                      totalWeightOfSelected.value = total;
                                    },
                                  )),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(width: 20),
                    Expanded(
                      child: Card(
                        elevation: 6,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(18)),
                        child: Padding(
                          padding: EdgeInsets.all(isMobile.value ? 18.0 : 8.0),
                          child: Container(
                            height: isMobile.value ? 500 : 300,
                            child: SingleChildScrollView(
                              child: Obx(() {
                                final filteredMap =
                                controller.categoryShareByQuality(
                                    selectedQuality.value);
                                final filteredCats = controller
                                    .bilty.value.categories
                                    .where((c) =>
                                c.quality == selectedQuality.value)
                                    .toList();
                                final filteredWeight =
                                filteredCats.fold<double>(
                                    0, (sum, c) => sum + c.totalWeight);
                                final filteredBoxes = filteredCats.fold<int>(
                                    0, (sum, c) => sum + c.boxCount);
                                final filteredValue = filteredCats.fold<double>(
                                    0, (sum, c) => sum + c.totalPrice);
                                return Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      mainAxisAlignment:
                                      MainAxisAlignment.spaceEvenly,
                                      children: [
                                        Column(
                                          children: [
                                            Text('Total Weight',
                                                style: TextStyle(
                                                    fontWeight: FontWeight.bold,
                                                    color: Colors
                                                        .orange.shade900)),
                                            Text(
                                                '${filteredWeight.toStringAsFixed(2)} kg',
                                                style: TextStyle(
                                                    fontSize: 16,
                                                    fontWeight:
                                                    FontWeight.bold)),
                                          ],
                                        ),
                                        Column(
                                          children: [
                                            Text('Box Count',
                                                style: TextStyle(
                                                    fontWeight: FontWeight.bold,
                                                    color: Colors
                                                        .orange.shade900)),
                                            Text('${filteredBoxes.toString()}',
                                                style: TextStyle(
                                                    fontSize: 16,
                                                    fontWeight:
                                                    FontWeight.bold)),
                                          ],
                                        ),
                                        Column(
                                          children: [
                                            Text('Total Value',
                                                style: TextStyle(
                                                    fontWeight: FontWeight.bold,
                                                    color: Colors
                                                        .orange.shade900)),
                                            Text(
                                                '₹${filteredValue.toStringAsFixed(2)}',
                                                style: TextStyle(
                                                    fontSize: 16,
                                                    fontWeight:
                                                    FontWeight.bold)),
                                          ],
                                        ),
                                      ],
                                    ),
                                    SizedBox(height: 8),
                                    buildDonutChart(
                                      filteredMap,
                                      filteredMap.keys
                                          .map((cat) =>
                                      categoryColorMap[cat] ??
                                          Colors.grey)
                                          .toList(),
                                      '${selectedQuality.value} Category Distribution',
                                    ),
                                  ],
                                );
                              }),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ):Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: Card(
                            elevation: 6,
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(18)),
                            child: Padding(
                              padding: EdgeInsets.all(
                                isMobile.value ? 18 : 8,
                              ),
                              child: Container(
                                height: 450,
                                child: SingleChildScrollView(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      // Show overall totals above the chart
                                      Obx(() {
                                        final bilty = controller.bilty.value;
                                        return Row(
                                          mainAxisAlignment:
                                          MainAxisAlignment.spaceEvenly,
                                          children: [
                                            Column(
                                              children: [
                                                Text('Total Weight',
                                                    style: TextStyle(
                                                        fontWeight: FontWeight.bold,
                                                        color: Colors
                                                            .orange.shade900)),
                                                Text(
                                                    '${bilty.totalWeight.toStringAsFixed(2)} kg',
                                                    style: TextStyle(
                                                        fontSize: 16,
                                                        fontWeight:
                                                        FontWeight.bold)),
                                              ],
                                            ),
                                            Column(
                                              children: [
                                                Text('Box Count',
                                                    style: TextStyle(
                                                        fontWeight: FontWeight.bold,
                                                        color: Colors
                                                            .orange.shade900)),
                                                Text(
                                                    '${bilty.totalBoxes.toStringAsFixed(0)}',
                                                    style: TextStyle(
                                                        fontSize: 16,
                                                        fontWeight:
                                                        FontWeight.bold)),
                                              ],
                                            ),
                                            Column(
                                              children: [
                                                Text('Total Value',
                                                    style: TextStyle(
                                                        fontWeight: FontWeight.bold,
                                                        color: Colors
                                                            .orange.shade900)),
                                                Text(
                                                    '₹${bilty.totalValue.toStringAsFixed(2)}',
                                                    style: TextStyle(
                                                        fontSize: 16,
                                                        fontWeight:
                                                        FontWeight.bold)),
                                              ],
                                            ),
                                          ],
                                        );
                                      }),
                                      SizedBox(height: 8),
                                      Obx(() => buildDonutChart(
                                        qualityMap,
                                        qualityColors,
                                        "Quality Distribution",
                                        onSectionTap: (quality) {
                                          selectedQuality.value = quality;
                                          // Calculate total weight for selected quality
                                          final total = controller
                                              .bilty.value.categories
                                              .where(
                                                  (c) => c.quality == quality)
                                              .fold<double>(
                                              0,
                                                  (sum, c) =>
                                              sum + c.totalWeight);
                                          totalWeightOfSelected.value = total;
                                        },
                                      )),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 20),
                    Row(
                      children: [
                        Expanded(
                          child: Card(
                            elevation: 6,
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(18)),
                            child: Padding(
                              padding: EdgeInsets.all(isMobile.value ? 18.0 : 8.0),
                              child: Container(
                                height: 420,
                                child: SingleChildScrollView(
                                  child: Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Obx(() {
                                      final filteredMap =
                                      controller.categoryShareByQuality(
                                          selectedQuality.value);
                                      final filteredCats = controller
                                          .bilty.value.categories
                                          .where((c) =>
                                      c.quality == selectedQuality.value)
                                          .toList();
                                      final filteredWeight =
                                      filteredCats.fold<double>(
                                          0, (sum, c) => sum + c.totalWeight);
                                      final filteredBoxes = filteredCats.fold<int>(
                                          0, (sum, c) => sum + c.boxCount);
                                      final filteredValue = filteredCats.fold<double>(
                                          0, (sum, c) => sum + c.totalPrice);
                                      return Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Row(
                                            mainAxisAlignment:
                                            MainAxisAlignment.spaceEvenly,
                                            children: [
                                              Column(
                                                children: [
                                                  Text('Total Weight',
                                                      style: TextStyle(
                                                          fontWeight: FontWeight.bold,
                                                          color: Colors
                                                              .orange.shade900)),
                                                  Text(
                                                      '${filteredWeight.toStringAsFixed(2)} kg',
                                                      style: TextStyle(
                                                          fontSize: 16,
                                                          fontWeight:
                                                          FontWeight.bold)),
                                                ],
                                              ),
                                              Column(
                                                children: [
                                                  Text('Box Count',
                                                      style: TextStyle(
                                                          fontWeight: FontWeight.bold,
                                                          color: Colors
                                                              .orange.shade900)),
                                                  Text('${filteredBoxes.toString()}',
                                                      style: TextStyle(
                                                          fontSize: 16,
                                                          fontWeight:
                                                          FontWeight.bold)),
                                                ],
                                              ),
                                              Column(
                                                children: [
                                                  Text('Total Value',
                                                      style: TextStyle(
                                                          fontWeight: FontWeight.bold,
                                                          color: Colors
                                                              .orange.shade900)),
                                                  Text(
                                                      '₹${filteredValue.toStringAsFixed(2)}',
                                                      style: TextStyle(
                                                          fontSize: 16,
                                                          fontWeight:
                                                          FontWeight.bold)),
                                                ],
                                              ),
                                            ],
                                          ),
                                          SizedBox(height: 8),
                                          buildDonutChart(
                                            filteredMap,
                                            filteredMap.keys
                                                .map((cat) =>
                                            categoryColorMap[cat] ??
                                                Colors.grey)
                                                .toList(),
                                            '${selectedQuality.value} Category Distribution',
                                          ),
                                        ],
                                      );
                                    }),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                SizedBox(height: 30),
                ExpansionTile(
                  title: Text('Show Bilty Details',
                      style: TextStyle(fontWeight: FontWeight.bold)),
                  children: [
                    biltyfinalView(),
                  ],
                ),

                Text("Bidding will start at ${controller.date.value.substring(0,10)} and ${controller.startTime.value}"),

                Obx(() {
                  final isScheduled = controller.date.value.isNotEmpty &&
                      controller.startTime.value.isNotEmpty;
                  final canStart = controller.canStartBidding();

                  return Row(
                    children: [
                      Expanded(
                        child: Container(
                          height: 50,
                          child: ElevatedButton(
                            onPressed: controller.canStart.value ? () {
                              Get.toNamed(RoutesConstant.bidderSession);
                            } : null,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: canStart ? Colors.green : Colors.orange,
                            ),
                            child: Text(
                              controller.canStart.value
                                  ? "Start Bidding"
                                  : isScheduled
                                  ? "Bidding Not Started Yet"
                                  : "Schedule Bidding First",
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: Colors.white, ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  );
                }),
                // Invite Methods Section

              ],
            ),
          ),
        );
      }),
    );
  }
}
