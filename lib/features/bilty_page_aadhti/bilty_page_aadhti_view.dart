import 'dart:io';

import 'package:apple_grower/features/bilty_page_aadhti/bilty_page_aadhti_controller.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';

import '../../models/bilty_model.dart';
import '../forms/consignmentForm/VideoPlayer.dart';

class BiltyPageAadhtiView extends GetView<BiltyPageAadhtiController> {
  final RxBool showDetails = false.obs;
  final ImagePicker _picker = ImagePicker();
  final RxList<String?> imagePaths = <String?>[].obs;
  final RxString videoPath = ''.obs;
  final RxBool isEditBoxesValueMode = false.obs;
  final RxBool isEditPriceMode = false.obs;
  final RxBool isGaddPricingMode = false.obs;
  final RxDouble gaddPrice = 0.0.obs;

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
    return Obx(() {
      bool isMobile = !kIsWeb &&
          (defaultTargetPlatform == TargetPlatform.android ||
              defaultTargetPlatform == TargetPlatform.iOS);
      return Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              spacing: 20,
              children: [
                Obx(() => TextButton.icon(
                      icon: Icon(
                        isEditBoxesValueMode.value
                            ? Icons.check_circle
                            : Icons.edit,
                        color: isEditBoxesValueMode.value
                            ? Colors.green
                            : Colors.blue,
                      ),
                      label: Text(isEditBoxesValueMode.value
                          ? 'Save Box Value'
                          : 'Edit Box Value'),
                      onPressed: () {
                        if (isEditBoxesValueMode.value) {
                          isEditBoxesValueMode.value = false;
                        } else {
                          isEditBoxesValueMode.value = true;
                          isEditPriceMode.value = false;
                          isGaddPricingMode.value = false;
                        }
                      },
                    )),
                const SizedBox(width: 8),
                Obx(() => TextButton.icon(
                      icon: Icon(
                        isEditPriceMode.value ? Icons.check_circle : Icons.edit,
                        color: isEditPriceMode.value
                            ? Colors.green
                            : Colors.orange,
                      ),
                      label: Text(
                          isEditPriceMode.value ? 'Save Price' : 'Edit Price'),
                      onPressed: () {
                        if (isEditPriceMode.value) {
                          isEditPriceMode.value = false;
                        } else {
                          isEditPriceMode.value = true;
                          isEditBoxesValueMode.value = false;
                          isGaddPricingMode.value = false;
                        }
                      },
                    )),
                const SizedBox(width: 8),
                Obx(() => TextButton.icon(
                      icon: Icon(
                        isGaddPricingMode.value
                            ? Icons.check_circle
                            : Icons.monetization_on,
                        color: isGaddPricingMode.value
                            ? Colors.green
                            : Colors.purple,
                      ),
                      label: Text(isGaddPricingMode.value
                          ? 'Save Gadd Pricing'
                          : 'Gadd Pricing'),
                      onPressed: () {
                        if (isGaddPricingMode.value) {
                          isGaddPricingMode.value = false;
                        } else {
                          isGaddPricingMode.value = true;
                          isEditBoxesValueMode.value = false;
                          isEditPriceMode.value = false;
                        }
                      },
                    )),
                const SizedBox(width: 8),
                Obx(() => TextButton.icon(
                      icon: Icon(
                        showDetails.value
                            ? Icons.visibility_off
                            : Icons.visibility,
                        color: showDetails.value ? Colors.red : Colors.grey,
                      ),
                      label: Text(
                          showDetails.value ? 'Hide Details' : 'Show Details'),
                      onPressed: () {
                        showDetails.value = !showDetails.value;
                      },
                    )),
              ],
            ),
          ),
          Obx(() => isGaddPricingMode.value
              ? Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      SizedBox(
                        width: 180,
                        child: TextFormField(
                          initialValue: gaddPrice.value == 0.0
                              ? ''
                              : gaddPrice.value.toString(),
                          keyboardType:
                              TextInputType.numberWithOptions(decimal: true),
                          decoration: const InputDecoration(
                            labelText: 'Enter Gadd Price (AAA)',
                            border: OutlineInputBorder(),
                            isDense: true,
                          ),
                          onChanged: (val) {
                            double? newVal = double.tryParse(val);
                            if (newVal != null) {
                              gaddPrice.value = newVal;
                            }
                          },
                        ),
                      ),
                      const SizedBox(width: 12),
                      ElevatedButton.icon(
                        onPressed: () {
                          // Set prices by category
                          final bilty = controller.bilty.value;
                          if (bilty != null) {
                            final newCategories = bilty.categories.map((cat) {
                              if (cat.boxCount == 0) return cat;
                              double? newPrice;
                              if (cat.quality.toUpperCase() == 'AAA') {
                                newPrice = gaddPrice.value;
                              } else if (cat.quality.toUpperCase() == 'AA') {
                                newPrice = gaddPrice.value / 2;
                              } else if (cat.quality.toUpperCase() == 'GP') {
                                newPrice = (gaddPrice.value / 2) + 10;
                              }
                              if (newPrice != null) {
                                final newTotalPrice =
                                    newPrice * cat.totalWeight;
                                final newBoxValue =
                                    newTotalPrice / cat.boxCount;
                                return cat.copyWith(
                                  pricePerKg: newPrice,
                                  totalPrice: newTotalPrice,
                                  boxValue: newBoxValue,
                                );
                              }
                              return cat;
                            }).toList();
                            controller.bilty.value =
                                bilty.copyWith(categories: newCategories);
                            updateBiltyTotals();
                          }
                          isGaddPricingMode.value = false;
                        },
                        icon: Icon(Icons.check, color: Colors.white),
                        label: const Text('Apply',
                            style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: Colors.white)),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.purple,
                          padding: const EdgeInsets.symmetric(
                              horizontal: 32, vertical: 16),
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(30)),
                          elevation: 6,
                        ),
                      ),
                    ],
                  ),
                )
              : SizedBox.shrink()),
          const SizedBox(height: 8),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: SingleChildScrollView(
              scrollDirection: Axis.vertical,
              child: DataTable(
                columnSpacing: 12,
                headingRowColor: MaterialStateProperty.resolveWith(
                    (states) => Colors.orange.shade200),
                columns: [
                  const DataColumn(label: Text("Quality")),
                  const DataColumn(label: Text("Category")),
                  if (showDetails.value) ...[
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
                rows: controller.bilty.value!.categories
                    .asMap()
                    .entries
                    .where((entry) => entry.value.boxCount != 0)
                    .map((entry) {
                  final index = entry.key;
                  final category = entry.value;
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
                        DataCell(Center(
                          child: Text("${category.boxCount}",
                              style: const TextStyle(color: Colors.white)),
                        )),
                        DataCell(Text(
                            "${category.totalWeight.toStringAsFixed(1)}kg",
                            style: const TextStyle(color: Colors.white))),
                      ],
                      isEditPriceMode.value
                          ? DataCell(
                              SizedBox(
                                width: 90,
                                child: TextFormField(
                                  initialValue:
                                      category.pricePerKg.toStringAsFixed(1),
                                  keyboardType: TextInputType.numberWithOptions(
                                      decimal: true),
                                  style: const TextStyle(color: Colors.white),
                                  decoration: const InputDecoration(
                                    border: OutlineInputBorder(),
                                    isDense: true,
                                    contentPadding: EdgeInsets.symmetric(
                                        vertical: 4, horizontal: 6),
                                  ),
                                  onChanged: (val) {
                                    double? newPrice = double.tryParse(val);
                                    if (newPrice != null) {
                                      print(category.totalWeight);
                                      final newTotalPrice =
                                          newPrice * category.totalWeight;
                                      final newBoxValue =
                                          newTotalPrice / category.boxCount;
                                      controller.bilty.update((bilty) {
                                        bilty!.categories[index] =
                                            category.copyWith(
                                          pricePerKg: newPrice,
                                          totalPrice: newTotalPrice,
                                          boxValue: newBoxValue,
                                        );
                                      });
                                      updateBiltyTotals();
                                    }
                                  },
                                ),
                              ),
                            )
                          : DataCell(Text(
                              "Rs. ${category.pricePerKg.toStringAsFixed(1)}",
                              style: const TextStyle(color: Colors.white))),
                      isEditBoxesValueMode.value
                          ? DataCell(
                              SizedBox(
                                width: 60,
                                child: TextFormField(
                                  initialValue:
                                      category.boxValue.toStringAsFixed(2),
                                  keyboardType: TextInputType.numberWithOptions(
                                      decimal: true),
                                  style: const TextStyle(color: Colors.white),
                                  decoration: const InputDecoration(
                                    border: OutlineInputBorder(),
                                    isDense: true,
                                    contentPadding: EdgeInsets.symmetric(
                                        vertical: 4, horizontal: 6),
                                  ),
                                  onChanged: (val) {
                                    double? newValue = double.tryParse(val);
                                    if (newValue != null) {
                                      final newTotalPrice =
                                          category.boxCount * newValue;
                                      final newPricePerKg =
                                          newTotalPrice / category.totalWeight;
                                      print(newTotalPrice);
                                      controller.bilty.update((bilty) {
                                        bilty!.categories[index] =
                                            category.copyWith(
                                          boxValue: newValue,
                                          totalPrice: newTotalPrice,
                                          pricePerKg: newPricePerKg,
                                        );
                                      });
                                      updateBiltyTotals();
                                    }
                                  },
                                ),
                              ),
                            )
                          : DataCell(Text(
                              "Rs. ${category.boxValue.toStringAsFixed(2)}",
                              style: const TextStyle(color: Colors.white))),
                      DataCell(Text(
                          "Rs. ${category.totalPrice.toStringAsFixed(2)}",
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
                                      content:
                                          Image.file(File(category.imagePath!)),
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
                            : const Icon(Icons.camera_alt, color: Colors.white),
                      ),
                    ],
                  );
                }).toList(),
              ),
            ),
          ),
          const SizedBox(height: 16),
          Obx(() {
            final bilty = controller.bilty.value;
            final formatter = NumberFormat('#,##0.##');
            Widget summaryCard = bilty == null
                ? SizedBox.shrink()
                : Card(
                    color: Colors.orange.shade50,
                    elevation: 3,
                    margin:
                        const EdgeInsets.symmetric(vertical: 8, horizontal: 0),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16)),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                          vertical: 10, horizontal: 18),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Column(
                            children: [
                              Text('Total Boxes',
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      color: Colors.orange.shade900)),
                              Text(formatter.format(bilty.totalBoxes),
                                  style: TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold)),
                            ],
                          ),
                          Column(
                            children: [
                              Text('Total Weight',
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      color: Colors.orange.shade900)),
                              Text('${formatter.format(bilty.totalWeight)} kg',
                                  style: TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold)),
                            ],
                          ),
                          Column(
                            children: [
                              Text('Total Value',
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      color: Colors.orange.shade900)),
                              Text('₹${formatter.format(bilty.totalValue)}',
                                  style: TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold)),
                            ],
                          ),
                        ],
                      ),
                    ),
                  );
            return bilty != null &&
                    bilty.videoPath != null &&
                    bilty.videoPath!.isNotEmpty
                ? Column(children: [
                    summaryCard,
                    TextButton.icon(
                      icon: Icon(Icons.play_circle_fill, color: Colors.green),
                      label: const Text('Play Video'),
                      onPressed: () {
                        showDialog(
                          context: Get.context!,
                          builder: (context) => AlertDialog(
                            title: const Text('Uploaded Video'),
                            content: AspectRatio(
                              aspectRatio: 16 / 9,
                              child: VideoPlayerWidget(
                                  videoPath: bilty.videoPath!),
                            ),
                            actions: [
                              TextButton(
                                onPressed: () => Navigator.of(context).pop(),
                                child: const Text('Close'),
                              ),
                            ],
                          ),
                        );
                      },
                    ),
                    const SizedBox(height: 8)
                  ])
                : Column(children: [
                    summaryCard,
                    TextButton.icon(
                      icon: Icon(Icons.play_circle_fill, color: Colors.grey),
                      label: const Text('Play Video'),
                      onPressed: null,
                    ),
                  ]);
          }),
        ],
      );
    });
  }

  void updateBiltyTotals() {
    final bilty = controller.bilty.value;
    if (bilty == null) return;
    final categories = bilty.categories;
    final totalBoxes = categories.fold<int>(0, (sum, c) => sum + c.boxCount);
    final totalWeight =
        categories.fold<double>(0, (sum, c) => sum + c.totalWeight);
    final totalValue =
        categories.fold<double>(0, (sum, c) => sum + c.totalPrice);
    controller.bilty.value = bilty.copyWith(
      totalBoxes: totalBoxes.toDouble(),
      totalWeight: totalWeight,
      totalValue: totalValue,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Create Bilty for Consignment"),
      ),
      body: Column(
        children: [
          Expanded(
              child: SingleChildScrollView(
                  child: Container(
                      width: MediaQuery.of(Get.context!).size.width,
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Center(child: biltyfinalView()),
                      )))),
          SizedBox(
            height: 10,
          ),
          Row(
            children: [
              Expanded(
                  child: Container(
                color: Colors.green.shade700,
                height: 40,
                child: ElevatedButton(
                  onPressed: () async {
                    await controller.uploadBilty();
                    Get.back();
                  },
                  child: Text(
                    "Send",
                    style: TextStyle(color: Colors.white),
                  ),
                  style: ElevatedButton.styleFrom(
                      shape: ContinuousRectangleBorder(),
                      backgroundColor: Colors.green.shade700),
                ),
              )),
            ],
          )
        ],
      ),
    );
  }
}
