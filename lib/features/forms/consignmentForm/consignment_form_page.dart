import 'package:apple_grower/features/grower/grower_controller.dart';
import 'package:apple_grower/models/aadhati.dart';
import 'package:apple_grower/models/bilty_model.dart';
import 'package:apple_grower/models/pack_house_model.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'dart:io';
import 'package:image_picker/image_picker.dart';
import 'package:video_player/video_player.dart';

import '../../../core/globals.dart' as glb;
import '../../../models/driving_profile_model.dart';
import '../../../models/transport_model.dart';
import 'VideoPlayer.dart';
import 'consignment_form_controller.dart';

class ConsignmentFormPage extends GetView<ConsignmentFormController> {
  final RxBool isEditMode = false.obs;
  final RxBool showDetails = false.obs;
  final ImagePicker _picker = ImagePicker();
  final RxList<String?> imagePaths = <String?>[].obs;
  final RxBool isEditBoxesMode = false.obs;
  final RxBool isEditTotalWeightMode = false.obs;
  final RxString videoPath = ''.obs;

  Widget driverModeSelection() {
    return Container(
      padding: EdgeInsets.all(8),
      child: Obx(
        () => Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          spacing: 10,
          children: [
            Text(
              "Driver Selection",
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 22),
            ),
            RadioListTile(
                value: "Self",
                groupValue: controller.driverMode.value,
                title: Text("Self"),
                subtitle: Text("Drive by Myself"),
                onChanged: (value) {
                  controller.driverMode.value = value!;
                }),
            RadioListTile(
                value: "Associated",
                groupValue: controller.driverMode.value,
                title: Text("Associated"),
                subtitle: Text("Select One of Associated"),
                onChanged: (value) {
                  controller.driverMode.value = value!;
                }),
            RadioListTile(
                value: "Transport Union",
                groupValue: controller.driverMode.value,
                title: Text("Associated Transport Union"),
                subtitle: Text("Select One of Associated"),
                onChanged: (value) {
                  controller.driverMode.value = value!;
                }),
            RadioListTile(
                value: "Request",
                groupValue: controller.driverMode.value,
                title: Text("Request"),
                subtitle: Text("Request FAS for assignment"),
                onChanged: (value) {
                  controller.driverMode.value = value!;
                }),
          ],
        ),
      ),
    );
  }

  Widget aadhatiModeSelection() {
    return Container(
      padding: EdgeInsets.all(8),
      child: Obx(
        () => Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          spacing: 10,
          children: [
            Text(
              "Agent Selection",
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 22),
            ),
            RadioListTile(
                value: "Associated",
                groupValue: controller.aadhatiMode.value,
                title: Text("Associated"),
                subtitle: Text("Select One of Associated"),
                onChanged: (value) {
                  controller.aadhatiMode.value = value!;
                }),
            RadioListTile(
                value: "Request",
                groupValue: controller.aadhatiMode.value,
                title: Text("Request"),
                subtitle: Text("Request FAS for assignment"),
                onChanged: (value) {
                  controller.aadhatiMode.value = value!;
                }),
          ],
        ),
      ),
    );
  }

  Widget packHouseModeSelection() {
    return Container(
      padding: EdgeInsets.all(8),
      child: Obx(
        () => Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          spacing: 10,
          children: [
            Text(
              "PackHouse Selection",
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 22),
            ),
            RadioListTile(
                value: "Self",
                groupValue: controller.packHouseMode.value,
                title: Text("Self"),
                subtitle: Text("Pack by Myself"),
                onChanged: (value) {
                  controller.packHouseMode.value = value!;
                }),
            RadioListTile(
                value: "Associated",
                groupValue: controller.packHouseMode.value,
                title: Text("Associated"),
                subtitle: Text("Select One of Associated"),
                onChanged: (value) {
                  controller.packHouseMode.value = value!;
                }),
            RadioListTile(
                value: "Request",
                groupValue: controller.packHouseMode.value,
                title: Text("Request"),
                subtitle: Text("Request FAS for assignment"),
                onChanged: (value) {
                  controller.packHouseMode.value = value!;
                }),
          ],
        ),
      ),
    );
  }

  Widget buildSelectionBoxes() {
    return Obx(() {
      {
        return Padding(
          padding: EdgeInsets.all(8),
          child: Column(
            spacing: 10,
            children: [
                Text(
                  "Selections",
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
                ),
              if (controller.driverMode.value == "Associated")
                DropdownButtonFormField<DrivingProfile>(
                  value: controller.drivingProfile.value,
                  items: Get.find<GrowerController>()
                      .drivers
                      .map((driver) => DropdownMenuItem<DrivingProfile>(
                            value: driver,
                            child: Text(driver.name!), // or any display field
                          ))
                      .toList(),
                  onChanged: (value) {
                    controller.drivingProfile.value = value!;
                  },
                  decoration: InputDecoration(
                    labelText: "Select Driver",
                    border: OutlineInputBorder(),
                  ),
                ),
              if (controller.driverMode.value == "Transport Union")
                DropdownButtonFormField<Transport>(
                  value: controller.transportUnion.value,
                  items: Get.find<GrowerController>()
                      .transportUnions
                      .map((transport) => DropdownMenuItem<Transport>(
                    value: transport,
                    child: Text(transport.name), // or any display field
                  ))
                      .toList(),
                  onChanged: (value) {
                    controller.transportUnion.value = value!;
                  },
                  decoration: InputDecoration(
                    labelText: "Select Transport Union",
                    border: OutlineInputBorder(),
                  ),
                ),
              if (controller.aadhatiMode.value == "Associated")
              DropdownButtonFormField<Aadhati>(
                value: controller.aadhati.value,
                items: Get.find<GrowerController>()
                    .commissionAgents
                    .map((agent) => DropdownMenuItem<Aadhati>(
                          value: agent,
                          child: Text(agent.name!), // or any display field
                        ))
                    .toList(),
                onChanged: (value) {
                  controller.aadhati.value = value!;
                },
                decoration: InputDecoration(
                  labelText: "Select Aadhati",
                  border: OutlineInputBorder(),
                ),
              ),
              SizedBox(height: 10,),
      TextFormField(
      controller: controller.trip2AddressController,
      decoration: InputDecoration(
      border: OutlineInputBorder(),
      label: Text("Enter Address")),
      )
            ],
          ),
        );
      }
    });
  }

  Widget Step3() {
    return Column(
      children: [
        driverModeSelection(),
        aadhatiModeSelection(),
        buildSelectionBoxes()
      ],
    );
  }

  Widget buildButton() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Obx(() {
        int step = controller.step.value;

        // Step 0: Only "Next" button
        if (step == 0) {
          return Row(
            spacing: 10,
            children: [
              Expanded(
                child: ElevatedButton(
                  onPressed: () {
                    controller.Step1();
                    controller.addStep();
                  },
                  style: ElevatedButton.styleFrom(
                    shape: BeveledRectangleBorder(),
                    backgroundColor: Colors.purpleAccent.shade400,
                  ),
                  child:
                      const Text("Next", style: TextStyle(color: Colors.white)),
                ),
              ),
            ],
          );
        }

        // Step 1: "Previous" and conditional "Next"
        if (step == 1) {
          bool canProceed = (controller.driverMode.value == "Self" ||
                  controller.consignment.value!.trip1Driverid != null) &&
              (controller.packHouseMode.value == "Self" ||
                  controller.consignment.value!.packhouseId != null);

          return Row(
            spacing: 10,
            children: [
              Expanded(
                child: ElevatedButton(
                  onPressed: () => controller.step.value -= 1,
                  style: ElevatedButton.styleFrom(
                    shape: BeveledRectangleBorder(),
                    backgroundColor: Colors.purpleAccent.shade400,
                  ),
                  child: const Text("Previous",
                      style: TextStyle(color: Colors.white)),
                ),
              ),
              if (canProceed)
                Expanded(
                  child: ElevatedButton(
                    onPressed: (){ controller.Step2();
                      controller.addStep();},
                    style: ElevatedButton.styleFrom(
                      shape: BeveledRectangleBorder(),
                      backgroundColor: Colors.purpleAccent.shade400,
                    ),
                    child: const Text("Next",
                        style: TextStyle(color: Colors.white)),
                  ),
                ),
            ],
          );
        }

        // Step 2: "Previous" and "Next"
        if (step == 2) {
          return Row(
            spacing: 10,
            children: [
              Expanded(
                child: ElevatedButton(
                  onPressed: () => controller.step.value -= 1,
                  style: ElevatedButton.styleFrom(
                    shape: BeveledRectangleBorder(),
                    backgroundColor: Colors.purpleAccent.shade400,
                  ),
                  child: const Text("Previous",
                      style: TextStyle(color: Colors.white)),
                ),
              ),
              Expanded(
                child: ElevatedButton(
                  onPressed: (){ controller.Step3();
        controller.addStep();},
                  style: ElevatedButton.styleFrom(
                    shape: BeveledRectangleBorder(),
                    backgroundColor: Colors.purpleAccent.shade400,
                  ),
                  child:
                      const Text("Next", style: TextStyle(color: Colors.white)),
                ),
              ),
            ],
          );
        }

        // Step 3: Accept/Decline buttons
        if (step == 3) {
          bool canProceed = (controller.driverMode.value == "Self" ||
                  controller.consignment.value!.trip2Driverid != null) &&
              (controller.consignment.value!.aadhatiId != null);
          return (canProceed)
              ? Row(
                  spacing: 10,
                  children: [
                    Expanded(
                      child: ElevatedButton(
                        onPressed: () {
                          // Decline logic
                        },
                        style: ElevatedButton.styleFrom(
                          shape: BeveledRectangleBorder(),
                          backgroundColor: Colors.red,
                        ),
                        child: const Text("Decline Offer",
                            style: TextStyle(color: Colors.white)),
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: ElevatedButton(
                        onPressed: () {

                          controller.Step4();
                          Get.back();
                          // Accept logic
                        },
                        style: ElevatedButton.styleFrom(
                          shape: BeveledRectangleBorder(),
                          backgroundColor: Colors.green,
                        ),
                        child: const Text("Accept for Bidding",
                            style: TextStyle(color: Colors.white)),
                      ),
                    ),
                  ],
                )
              : Row(
                  children: [
                    Expanded(
                      child: ElevatedButton(
                        onPressed: () => controller.step.value -= 1,
                        style: ElevatedButton.styleFrom(
                          shape: BeveledRectangleBorder(),
                          backgroundColor: Colors.purpleAccent.shade400,
                        ),
                        child: const Text("Previous",
                            style: TextStyle(color: Colors.white)),
                      ),
                    ),
                  ],
                );
        }

        return Container(); // default fallback
      }),
    );
  }

  Widget selectionBoxes() {
    return Obx(() => Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            spacing: 10,
            children: [
              if (controller.driverMode.value == "Associated" ||
                  controller.driverMode.value == "Transport Union" ||
                  controller.packHouseMode.value == "Associated")
                Text(
                  "Selections",
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
                ),
              if (controller.driverMode.value == "Associated")
                DropdownButtonFormField<DrivingProfile>(
                  value: controller.drivingProfile.value,
                  items: Get.find<GrowerController>()
                      .drivers
                      .map((driver) => DropdownMenuItem<DrivingProfile>(
                            value: driver,
                            child: Text(driver.name!), // or any display field
                          ))
                      .toList(),
                  onChanged: (value) {
                    controller.drivingProfile.value = value!;
                  },
                  decoration: InputDecoration(
                    labelText: "Select Driver",
                    border: OutlineInputBorder(),
                  ),
                ),
              if (controller.driverMode.value == "Transport Union")
                DropdownButtonFormField<Transport>(
                  value: controller.transportUnion.value,
                  items: Get.find<GrowerController>()
                      .transportUnions
                      .map((transport) => DropdownMenuItem<Transport>(
                            value: transport,
                            child: Text(transport.name), // or any display field
                          ))
                      .toList(),
                  onChanged: (value) {
                    controller.transportUnion.value = value!;
                  },
                  decoration: InputDecoration(
                    labelText: "Select Union",
                    border: OutlineInputBorder(),
                  ),
                ),
              if (controller.packHouseMode.value == "Associated")
                DropdownButtonFormField<PackHouse>(
                  value: controller.packhouse.value,
                  items: Get.find<GrowerController>()
                      .packingHouses
                      .map((packhouse) => DropdownMenuItem<PackHouse>(
                            value: packhouse,
                            child: Text(packhouse.name), // or any display field
                          ))
                      .toList(),
                  onChanged: (value) {
                    controller.packhouse.value = value!;
                  },
                  decoration: InputDecoration(
                    labelText: "Select PackHouse",
                    border: OutlineInputBorder(),
                  ),
                ),
              if (controller.driverMode.value != 'Self' &&
                  controller.packHouseMode.value == "Self")
                TextFormField(
                  controller: controller.trip1AddressController,
                  decoration: InputDecoration(
                      border: OutlineInputBorder(),
                      label: Text("Enter Address")),
                )
            ],
          ),
        ));
  }

  Widget Step1() {
    return Container(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          driverModeSelection(),
          packHouseModeSelection(),
          selectionBoxes()
        ],
      ),
    );
  }

  Widget fallBack() {
    return Column(
      children: [
        if (controller.driverMode.value != 'Self'&&   controller.consignment.value?.trip1Driverid == null)
          Container(
            padding: EdgeInsets.all(8),
            decoration: BoxDecoration(color: Colors.white, boxShadow: [
              BoxShadow(color: Colors.black, blurRadius: 1, spreadRadius: 1)
            ]),
            child: Column(
              spacing: 10,
              children: [
                Center(
                  child: Icon(
                    Icons.warning,
                    color: Colors.amber,
                  ),
                ),
                Text(
                    (controller.driverMode == "Request" &&
                            controller.consignment.value?.trip1Driverid == null)
                        ? "Driver is Not resolved yet"
                        : (controller.consignment.value?.trip1Driverid == null)
                            ? "Driver has not accepted request yet"
                            : "",
                    style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                    textAlign: TextAlign.center),
              ],
            ),
          ),
        SizedBox(
          height: 10,
        ),
        if (controller.packHouseMode.value != "Self" &&   controller.consignment.value?.packhouseId == null)
          Container(
            padding: EdgeInsets.all(8),
            decoration: BoxDecoration(color: Colors.white, boxShadow: [
              BoxShadow(color: Colors.black, blurRadius: 1, spreadRadius: 1)
            ]),
            child: Column(
              spacing: 10,
              children: [
                Center(
                  child: Icon(
                    Icons.warning,
                    color: Colors.amber,
                  ),
                ),
                Text(
                  (controller.packHouseMode == "Request" &&
                      controller.consignment.value?.packhouseId == null)
                      ? "Packhouse is Not resolved yet"
                      : (controller.packHouseMode.value != "Self" &&
                      controller.consignment.value?.packhouseId == null)
                          ? "Packhouse has not accepted request yet"
                          : "",
                  style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          )
      ],
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

  Widget biltyCreate() {
    if (controller.bilty.value == null) {
      controller.bilty.value =
          Bilty.createDefault();
      controller.biltyValue.value = true;
    }
    final bilty = controller.bilty.value!;
    if (imagePaths.length != bilty.categories.length) {
      imagePaths.value = List<String?>.filled(bilty.categories.length, null);
    }
    bool isMobile = !kIsWeb &&
        (defaultTargetPlatform == TargetPlatform.android ||
            defaultTargetPlatform == TargetPlatform.iOS);
    showDetails.value=!(isMobile);
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
            spacing: 20,
            children: [
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
                      isEditTotalWeightMode.value
                          ? Icons.check_circle
                          : Icons.edit,
                      color: isEditTotalWeightMode.value
                          ? Colors.green
                          : Colors.orange,
                    ),
                    label: Text(isEditTotalWeightMode.value
                        ? 'Save Total Weight'
                        : 'Edit Total Weight'),
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
              if (isMobile)Obx(() => TextButton.icon(
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
                                await uploadImage(File(image.path), i);
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
                        onPressed:
                        (isEditBoxesMode.value || isEditTotalWeightMode.value)
                            ? () async {
                          final XFile? video = await _picker.pickVideo(
                            source: ImageSource.camera,
                            maxDuration: const Duration(seconds: 5),
                          );
                          if (video != null) {
                            videoPath.value = video.path;
                            await uploadVideo(File(video.path));
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

        Obx(() => SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: SingleChildScrollView(
                scrollDirection: Axis.vertical,
                child: DataTable(
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
                    ],
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
                        ],
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
                            : DataCell(Text("${category.boxCount}",
                                style: const TextStyle(color: Colors.white))),
                        isEditTotalWeightMode.value
                            ? DataCell(
                                SizedBox(
                                  width: 90,
                                  child: TextFormField(
                                    initialValue:
                                        category.totalWeight.toStringAsFixed(1),
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
                                          totalWeight: newTotal,
                                        );
                                        controller.bilty.refresh();
                                      }
                                    },
                                  ),
                                ),
                              )
                            : DataCell(Text(
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
                                onPressed: (isEditBoxesMode.value || isEditTotalWeightMode.value)
                                    ? () async {
                                  bool isMobile = !kIsWeb &&
                                      (defaultTargetPlatform == TargetPlatform.android ||
                                          defaultTargetPlatform == TargetPlatform.iOS);

                                  if (isMobile && ImageSource.camera == ImageSource.camera) {
                                    final XFile? image = await _picker.pickImage(source: ImageSource.camera);
                                    if (image != null) {
                                      imagePaths[index] = image.path;
                                      await uploadImage(File(image.path), index);
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
            )),
      ],
    );
  }

  biltyView() {
    final bilty = controller.bilty.value;
    if (bilty == null) return SizedBox();
    bool isMobile = !kIsWeb &&
        (defaultTargetPlatform == TargetPlatform.android ||
            defaultTargetPlatform == TargetPlatform.iOS);
    showDetails.value=!(isMobile);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
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
                    ],
                    const DataColumn(label: Text("No. of Boxes")),
                    const DataColumn(label: Text("Total Weight")),
                    if (isMobile) const DataColumn(label: Text("Image")),
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
                        ],
                        DataCell(Text("${category.boxCount}",
                            style: const TextStyle(color: Colors.white))),
                        DataCell(Text(
                            "${category.totalWeight.toStringAsFixed(1)}kg",
                            style: const TextStyle(color: Colors.white))),
                        if (isMobile)
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
                  }),
                )),
          ),
        ),
        const SizedBox(height: 12),
        Obx(() => Row(
              children: [
                TextButton.icon(
                  icon: Icon(Icons.play_circle_fill,
                      color: videoPath.value.isNotEmpty
                          ? Colors.green
                          : Colors.grey),
                  label: const Text('Play Video'),
                  onPressed: videoPath.value.isNotEmpty
                      ? () {
                          showDialog(
                            context: Get.context!,
                            builder: (context) => AlertDialog(
                              title: const Text('Uploaded Video'),
                              content: AspectRatio(
                                aspectRatio: 16 / 9,
                                child: VideoPlayerWidget(
                                    videoPath: videoPath.value),
                              ),
                              actions: [
                                TextButton(
                                  onPressed: () => Navigator.of(context).pop(),
                                  child: const Text('Close'),
                                ),
                              ],
                            ),
                          );
                        }
                      : null,
                ),
              ],
            )),
      ],
    );
  }

  Widget Step2() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        fallBack(),
        if (controller.packHouseMode.value == "Self" &&
               ( controller.driverMode.value == 'Self' ||
            controller.consignment.value?.trip1Driverid!= null))
          biltyCreate(),
        if (controller.packHouseMode.value != "Self" &&
            controller.consignment.value?.packhouseId != null)
          (controller.bilty.value == null)
              ? Container(
                  padding: EdgeInsets.all(8),
                  decoration: BoxDecoration(color: Colors.white, boxShadow: [
                    BoxShadow(
                        color: Colors.black, blurRadius: 1, spreadRadius: 1)
                  ]),
                  child: Column(
                    spacing: 10,
                    children: [
                      Center(
                        child: Icon(
                          Icons.warning,
                          color: Colors.amber,
                        ),
                      ),
                      Text("Packhouse is working on bitly",
                          style: TextStyle(
                              fontSize: 22, fontWeight: FontWeight.bold),
                          textAlign: TextAlign.center),
                    ],
                  ),
                )
              : Center(child:biltyView(),),
      ],
    );
  }

  Widget Step4fallback() {
    return Column(
      children: [
        if(controller.consignment.value?.aadhatiId==null)Container(
          padding: EdgeInsets.all(8),
          decoration: BoxDecoration(color: Colors.white, boxShadow: [
            BoxShadow(color: Colors.black, blurRadius: 1, spreadRadius: 1)
          ]),
          child: Column(
            spacing: 10,
            children: [
              Center(
                child: Icon(
                  Icons.warning,
                  color: Colors.amber,
                ),
              ),
              Text(
                  (controller.aadhatiMode.value == "Request")
                      ? "Aadhati is Not resolved yet"
                        : "Aadhati has not accepted request yet",
                  style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                  textAlign: TextAlign.center),
            ],
          ),
        ),
        SizedBox(
          height: 10,
        )
      ],
    );
  }

  Widget Step4() {
    return Column(
      children: [
        Step4fallback(),
        if (controller.consignment.value?.aadhatiId != null)
          (controller.consignment.value?.currentStage == "Bilty Ready")
              ?biltyfinalView()
              : Container(
                  padding: EdgeInsets.all(8),
                  decoration: BoxDecoration(color: Colors.white, boxShadow: [
                    BoxShadow(
                        color: Colors.black, blurRadius: 1, spreadRadius: 1)
                  ]),
                  child: Column(
                    spacing: 10,
                    children: [
                      Center(
                        child: Icon(
                          Icons.warning,
                          color: Colors.amber,
                        ),
                      ),
                      Text("Aadhati is creating Bilty",
                          style: TextStyle(
                              fontSize: 22, fontWeight: FontWeight.bold),
                          textAlign: TextAlign.center),
                    ],
                  ),
                ),
        SizedBox(
          height: 10,
        ),
      ],
    );
  }

  buildViewSection() {
    return Obx(() {
      if (controller.step.value == 0) {
        return Step1();
      } else if (controller.step.value == 1) {
        return Step2();
      } else if (controller.step.value == 2) {
        return Step3();
      } else {
        return Step4();
      }
    });
  }

  Widget biltySummaryWidget() {
    final Bilty? bilty =controller.consignment.value?.bilty!;
    final totalBoxes =
        bilty?.categories.fold<int>(0, (sum, c) => sum + c.boxCount);
    final totalWeight =
        bilty?.categories.fold<double>(0, (sum, c) => sum + c.totalWeight);
    final totalValue =
        bilty?.categories.fold<double>(0, (sum, c) => sum + c.totalPrice);

    return Card(
      margin: EdgeInsets.symmetric(vertical: 8),
      child: ExpansionTile(
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text('Bilty Summary',
                style: TextStyle(fontWeight: FontWeight.bold)),
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text('Total Boxes: ' + totalBoxes.toString()),
                Text('Total Weight: ' + totalWeight!.toStringAsFixed(2) + ' kg'),
                Text('Total Value: ₹' + totalValue!.toStringAsFixed(2)),
              ],
            ),
          ],
        ),
        children: bilty!.categories
            .map((category) => ListTile(
                  title: Text('${category.quality} - ${category.category}'),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Size: ${category.size}'),
                      Text('Boxes: ${category.boxCount}'),
                      Text(
                          'Weight: ${category.totalWeight.toStringAsFixed(2)} kg'),
                      Text('Value: ₹${category.totalPrice.toStringAsFixed(2)}'),
                    ],
                  ),
                ))
            .toList(),
      ),
    );
  }

  biltyfinalView() {
    final bilty = controller.bilty.value;
    if (bilty == null) return SizedBox();
    bool isMobile = !kIsWeb &&
        (defaultTargetPlatform == TargetPlatform.android ||
            defaultTargetPlatform == TargetPlatform.iOS);
    showDetails.value=!(isMobile);
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
                  }),
                )),
          ),
        ),
        const SizedBox(height: 16),
        if (isMobile)
          Obx(() => videoPath.value.isNotEmpty
              ? Column(children: [
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
                            child:
                                VideoPlayerWidget(videoPath: videoPath.value),
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
              : TextButton.icon(
                  icon: Icon(Icons.play_circle_fill, color: Colors.grey),
                  label: const Text('Play Video'),
                  onPressed: null,
                )),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      appBar: AppBar(
        title: Obx(
            () => Text("Consignment Form Step ${controller.step.value + 1}")),
        backgroundColor: Colors.white,
      ),
      body: Container(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: SingleChildScrollView(
                padding: EdgeInsets.all(8),
                child: buildViewSection(),
              ),
            ),
            buildButton()
          ],
        ),
      ),
    );
  }

  // Placeholder for image upload
  Future<void> uploadImage(File image, int index) async {
    // TODO: Implement upload logic here
  }

  // Placeholder for video upload
  Future<void> uploadVideo(File video) async {
    // TODO: Implement upload logic here
  }
}


