import 'dart:io';

import 'package:apple_grower/features/bilty_page/bilty_page_controller.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';

import '../../models/bilty_model.dart';

class BiltyPageView extends GetView<BiltyPageController> {
  final RxBool isEditMode = false.obs;
  final RxBool showDetails = false.obs;
  final ImagePicker _picker = ImagePicker();
  final RxList<String?> imagePaths = <String?>[].obs;
  final RxBool isEditBoxesMode = false.obs;
  final RxBool isEditTotalWeightMode = false.obs;
  final RxString videoPath = ''.obs;

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

  Widget biltyCreate() {
    if (controller.bilty.value == null) {
      controller.bilty.value = Bilty.createDefault();
      controller.biltyValue.value = true;
    }
    final bilty = controller.bilty.value!;
    if (imagePaths.length != bilty.categories.length) {
      imagePaths.value = List<String?>.filled(bilty.categories.length, null);
    }
    bool isMobile = !kIsWeb &&
        (defaultTargetPlatform == TargetPlatform.android ||
            defaultTargetPlatform == TargetPlatform.iOS);
    showDetails.value = !(isMobile);
    return Column(
      children: [
        SizedBox(
          height: 10,
        ),
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            spacing: 10,
            children: [
              Obx(() => TextButton.icon(
                icon: Icon(
                  isEditTotalWeightMode.value
                      ? Icons.check_circle
                      : Icons.edit,
                  color: isEditTotalWeightMode.value
                      ? Colors.green
                      : Colors.orange,
                ),
                label: Text(isEditTotalWeightMode.value
                    ? 'Save Box Weight'
                    : 'Edit Box Weight'),
                onPressed: () {
                  if (isEditTotalWeightMode.value) {
                    isEditTotalWeightMode.value = false;
                    controller.bilty.refresh();
                  } else {
                    isEditTotalWeightMode.value = true;
                    isEditBoxesMode.value = false;
                  }
                },
              )),
              const SizedBox(width: 8),
              Obx(() => TextButton.icon(
                icon: Icon(
                  isEditBoxesMode.value ? Icons.check_circle : Icons.edit,
                  color: isEditBoxesMode.value ? Colors.green : Colors.blue,
                ),
                label: Text(
                    isEditBoxesMode.value ? 'Save Boxes' : 'Edit Boxes'),
                onPressed: () {
                  if (isEditBoxesMode.value) {
                    isEditBoxesMode.value = false;
                    controller.bilty.refresh();
                  } else {
                    isEditBoxesMode.value = true;
                    isEditTotalWeightMode.value = false;
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
              if (isMobile)
                Obx(() => TextButton.icon(
                      icon: const Icon(Icons.add_a_photo, color: Colors.purple),
                      label: const Text('Add Pictures'),
                      onPressed: (isEditBoxesMode.value ||
                              isEditTotalWeightMode.value)
                          ? () async {
                              for (int i = 0;
                                  i < controller.bilty.value!.categories.length;
                                  i++) {
                                final XFile? image = await _picker.pickImage(
                                    source: ImageSource.camera);
                                if (image != null) {
                                  imagePaths[i] = image.path;
                                  await controller.uploadImage(
                                      File(image.path), i);
                                }
                              }
                            }
                          : null,
                    )),
              Obx(() => Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          TextButton.icon(
                            icon: Icon(
                              videoPath.value.isNotEmpty
                                  ? Icons.check_circle
                                  : Icons.videocam,
                              color: videoPath.value.isNotEmpty
                                  ? Colors.green
                                  : Colors.red,
                            ),
                            label: Text(videoPath.value.isNotEmpty
                                ? 'Video Uploaded'
                                : 'Upload Video'),
                            onPressed: (isEditBoxesMode.value ||
                                    isEditTotalWeightMode.value)
                                ? () async {
                                    final XFile? video =
                                        await _picker.pickVideo(
                                      source: ImageSource.camera,
                                      maxDuration: const Duration(seconds: 5),
                                    );
                                    if (video != null) {
                                      videoPath.value = video.path;
                                      await controller
                                          .uploadVideo(File(video.path));
                                    }
                                  }
                                : null,
                          ),
                          const SizedBox(width: 12),
                          const Text('Video limit: 5 seconds',
                              style: TextStyle(color: Colors.grey)),
                        ],
                      ),
                    ],
                  )),
            ],
          ),
        ),
        const SizedBox(height: 8),
        // Video upload section

        Obx(() => Center(
          child: SingleChildScrollView(
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
                      ],
                      const DataColumn(label: Text("Gross Box Weight")),
                      const DataColumn(label: Text("No. of Boxes")),
                      const DataColumn(label: Text("Total Weight")),
                      const DataColumn(label: Text("Image")),
                    ],
                    rows: List.generate(bilty.categories.length, (index) {
                      final category = bilty.categories[index];
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

                          ],
                          isEditTotalWeightMode.value
                              ? DataCell(
                            SizedBox(
                              width: 90,
                              child: TextFormField(
                                initialValue:
                                category.avgBoxWeight.toStringAsFixed(1),
                                keyboardType:
                                TextInputType.numberWithOptions(
                                    decimal: true),
                                style: const TextStyle(color: Colors.white),
                                decoration: const InputDecoration(
                                  border: OutlineInputBorder(),
                                  isDense: true,
                                  contentPadding: EdgeInsets.symmetric(
                                      vertical: 4, horizontal: 6),
                                ),
                                onChanged: (val) {
                                  double? newTotal = double.tryParse(val);
                                  if (newTotal != null) {
                                    controller.bilty.value!
                                        .categories[index] =
                                        category.copyWith(
                                            avgBoxWeight: newTotal,
                                            totalWeight:  newTotal* controller.bilty.value!.categories[index].boxCount
                                        );
                                    controller.bilty.refresh();
                                  }
                                },
                              ),
                            ),
                          )
                              : DataCell(Text(
                              "${category.avgBoxWeight.toStringAsFixed(1)}kg",
                              style: const TextStyle(color: Colors.white))),
                          isEditBoxesMode.value
                              ? DataCell(
                                  SizedBox(
                                    width: 60,
                                    child: TextFormField(
                                      initialValue: category.boxCount.toString(),
                                      keyboardType: TextInputType.number,
                                      style: const TextStyle(color: Colors.white),
                                      decoration: const InputDecoration(
                                        border: OutlineInputBorder(),
                                        isDense: true,
                                        contentPadding: EdgeInsets.symmetric(
                                            vertical: 4, horizontal: 6),
                                      ),
                                      onChanged: (val) {
                                        int? newCount = int.tryParse(val);
                                        if (newCount != null) {
                                          final newTotalWeight =
                                              category.avgBoxWeight * newCount;
                                          controller.bilty.value!
                                                  .categories[index] =
                                              category.copyWith(
                                            boxCount: newCount,
                                            totalWeight: newTotalWeight,
                                          );
                                          controller.bilty.refresh();
                                        }
                                      },
                                    ),
                                  ),
                                )
                              : DataCell(Center(
                                child: Text("${category.boxCount}",
                                    style: const TextStyle(color: Colors.white)),
                              )),
                         DataCell(Text(
                                  "${category.totalWeight.toStringAsFixed(1)}kg",
                                  style: const TextStyle(color: Colors.white))),
                          DataCell(
                            Obx(() {
                              final path = imagePaths[index];
                              final quality = controller
                                  .bilty.value!.categories[index].quality;
                              final category = controller
                                  .bilty.value!.categories[index].category;
                              return path != null
                                  ? (isEditBoxesMode.value ||
                                          isEditTotalWeightMode.value
                                      ? const Icon(Icons.check_circle,
                                          color: Colors.green)
                                      : GestureDetector(
                                          onTap: () {
                                            // Show image in a dialog/card
                                            showDialog(
                                              context: Get.context!,
                                              builder: (context) => AlertDialog(
                                                title: Text('Uploaded Image'),
                                                content: Image.file(File(path)),
                                                actions: [
                                                  TextButton(
                                                    onPressed: () =>
                                                        Navigator.of(context)
                                                            .pop(),
                                                    child: const Text('Close'),
                                                  ),
                                                ],
                                              ),
                                            );
                                          },
                                          child: const Icon(Icons.check_circle,
                                              color: Colors.green),
                                        ))
                                  : IconButton(
                                      icon: const Icon(Icons.camera_alt,
                                          color: Colors.white),
                                      onPressed: (isEditBoxesMode.value ||
                                              isEditTotalWeightMode.value)
                                          ? () async {
                                              bool isMobile = !kIsWeb &&
                                                  (defaultTargetPlatform ==
                                                          TargetPlatform
                                                              .android ||
                                                      defaultTargetPlatform ==
                                                          TargetPlatform.iOS);

                                              if (isMobile &&
                                                  ImageSource.camera ==
                                                      ImageSource.camera) {
                                                final XFile? image =
                                                    await _picker.pickImage(
                                                        source:
                                                            ImageSource.camera);
                                                if (image != null) {
                                                  imagePaths[index] = image.path;
                                                  await controller.uploadImage(
                                                      File(image.path), index);
                                                }
                                              } else {
                                                Get.snackbar(
                                                  "Warning",
                                                  "This functionality is restricted to the mobile app",
                                                  backgroundColor: Colors.yellow,
                                                  colorText: Colors.white,
                                                );
                                              }
                                            }
                                          : null,
                                    );
                            }),
                          ),
                        ],
                      );
                    }),
                  ),
                ),
              ),
        )),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
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
                        child: Center(child: biltyCreate()),
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
                ),
              ),
            ],
          )
        ],
      ),
    );
  }
}
