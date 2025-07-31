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
    RxBool editVariety = false.obs;

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
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                "Tools",
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 22),
              ),
            ),
          ],
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
              TextButton.icon(
                icon: Icon(
                  Icons.category
                  ,color:  Colors.red,
                ),
                label: Text("Change variety"),
                onPressed: () {
                  Get.defaultDialog(
                      title: "Change Variety",
                      content: Column(
                        children: [
                          Container(
                            padding:EdgeInsets.all(8),
                            child: TextFormField(
                              controller: controller.varietyController,
                              decoration: InputDecoration(
                                  hintText: "Enter Varity Name for bilty",
                                  border: OutlineInputBorder(
                                      borderRadius: BorderRadius.all(
                                          Radius.elliptical(12, 12)))),
                            ),
                          ),
                          ElevatedButton(onPressed: (){
                            controller.bilty.value = controller.changeVariety(bilty, controller.varietyController.text);
                            Get.back();
                          }, child: Text("SUBMIT"))
                        ],
                      ));
                },
              ),
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
                        controller.imgUrl.value =
                        await controller.uploadImage(File(image.path), i);
                        imagePaths[i] = controller.imgUrl.value;
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
                        onPressed: () async {
                          final XFile? video = await _picker.pickVideo(
                            source: ImageSource.camera,
                            maxDuration: const Duration(seconds: 5),
                          );
                          if (video != null) {
                            videoPath.value = video.path;
                            await controller.uploadVideo(File(video.path));
                          }
                        },
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

        Obx(() => SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: SingleChildScrollView(
            scrollDirection: Axis.vertical,
            child: DataTable(
              headingRowColor: MaterialStateProperty.resolveWith(
                      (states) => Colors.orange.shade200),
              columnSpacing: 12,
              columns: [
                const DataColumn(label: Text("Quality")),
                const DataColumn(label: Text("Category")),
                if (showDetails.value) ...[
                  const DataColumn(label: Text("Variety")),
                  const DataColumn(label: Text("Size in MM"))
                ],
                const DataColumn(label: Text("Counts")),
                if (showDetails.value) ...[
                  const DataColumn(label: Text("Avg. Wt/Piece")),
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
                    DataCell(Center(
                      child: Text(
                        category.quality,
                        style: const TextStyle(
                          color: Colors.white,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    )),
                    DataCell(Center(
                      child: Text(category.category,
                          style: const TextStyle(color: Colors.white),
                          textAlign: TextAlign.center),
                    )),
                    if (showDetails.value) ...[
                      DataCell(Center(
                        child: Text(category.variety,
                            style: const TextStyle(color: Colors.white),
                            textAlign: TextAlign.center),
                      )),
                      DataCell(Center(
                        child: Text(category.size,
                            style: const TextStyle(color: Colors.white),
                            textAlign: TextAlign.center),
                      )),
                    ],
                    DataCell(Center(
                      child: Text("${category.piecesPerBox}",
                          style: const TextStyle(color: Colors.white),
                          textAlign: TextAlign.center),
                    )),
                    if (showDetails.value) ...[
                      DataCell(Center(
                        child: Text(
                            "${category.avgWeight.toStringAsFixed(1)}g",
                            style: const TextStyle(color: Colors.white),
                            textAlign: TextAlign.center),
                      )),
                    ],
                    isEditTotalWeightMode.value
                        ? DataCell(
                      SizedBox(
                        width: 90,
                        child: TextFormField(
                          initialValue: category.avgBoxWeight
                              .toStringAsFixed(1),
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
                                      totalWeight: newTotal *
                                          controller
                                              .bilty
                                              .value!
                                              .categories[index]
                                              .boxCount);
                              controller.bilty.refresh();
                            }
                          },
                        ),
                      ),
                    )
                        : DataCell(Center(
                      child: Text(
                          "${category.avgBoxWeight.toStringAsFixed(1)}kg",
                          style: const TextStyle(color: Colors.white),
                          textAlign: TextAlign.center),
                    )),
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
                          style: const TextStyle(color: Colors.white),
                          textAlign: TextAlign.center),
                    )),
                    DataCell(Center(
                      child: Text(
                          "${category.totalWeight.toStringAsFixed(1)}kg",
                          style: const TextStyle(color: Colors.white),
                          textAlign: TextAlign.center),
                    )),
                    DataCell(
                      Obx(() {
                        final path = imagePaths[index];
                        final quality = controller
                            .bilty.value!.categories[index].quality;
                        final category = controller
                            .bilty.value!.categories[index].category;
                        return path != null
                            ? InkWell(
                          child: const Icon(
                            Icons.check_circle,
                            color: Colors.green,
                          ),
                          onTap: () {
                            // Show image in a dialog/card
                            showDialog(
                              context: Get.context!,
                              builder: (context) => AlertDialog(
                                title: Text('Uploaded Image'),
                                content: Image.network(path),
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
                        )
                            : IconButton(
                            icon: const Icon(Icons.camera_alt,
                                color: Colors.white),
                            onPressed: () async {
                              print("Yi");
                              bool isMobile = !kIsWeb &&
                                  (defaultTargetPlatform ==
                                      TargetPlatform.android ||
                                      defaultTargetPlatform ==
                                          TargetPlatform.iOS);

                              if (isMobile &&
                                  ImageSource.camera ==
                                      ImageSource.camera) {
                                print("here");
                                final XFile? image =
                                await _picker.pickImage(
                                    source: ImageSource.camera);
                                if (image != null) {
                                  print("Here");
                                  controller.imgUrl.value = await controller.uploadImage(
                                      File(image.path), index);
                                  print(controller.imgUrl.value);

                                  imagePaths[index] = controller.imgUrl.value;
                                }
                              } else {
                                print("Can't Add");
                                Get.snackbar(
                                  "Warning",
                                  "This functionality is restricted to the mobile app",
                                  backgroundColor: Colors.yellow,
                                  colorText: Colors.white,
                                );
                              }
                            });
                      }),
                    ),
                  ],
                );
              }),
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
