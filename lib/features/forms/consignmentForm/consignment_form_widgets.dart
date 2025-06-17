import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../core/globals.dart' as glb;
import '../../../models/driving_profile_model.dart';
import '../../../models/pack_house_model.dart';
import 'consignment_form_controller.dart';
import 'dart:io';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'bilty_download_service.dart';
import 'dart:convert';

InputDecoration getInputDecoration(String label, {IconData? prefixIcon}) {
  return InputDecoration(
    labelText: label,
    prefixIcon: prefixIcon != null ? Icon(prefixIcon) : null,
    border: OutlineInputBorder(
      borderRadius: BorderRadius.circular(8),
      borderSide: BorderSide(color: Colors.grey[300]!),
    ),
    enabledBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(8),
      borderSide: BorderSide(color: Colors.grey[300]!),
    ),
    focusedBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(8),
      borderSide: BorderSide(color: Color(0xff548235)),
    ),
    filled: true,
    fillColor: Colors.white,
    contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
  );
}

Widget buildDriverSelectionCard(ConsignmentFormController controller) {
  return Obx(
    () => Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Select Driver:',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: Color(0xff548235),
          ),
        ),
        SizedBox(height: 16),
        ListTile(
          title: const Text('Self'),
          subtitle: Text('You will handle the driving yourself'),
          leading: Radio<String>(
            value: 'Self',
            groupValue: controller.selectedDriverOption.value,
            onChanged: (value) {
              controller.selectedDriverOption.value = value!;
              controller.selectedDriver.value = null;
              controller.resolvedDriverDetails.value = null;
            },
          ),
        ),
        ListTile(
          title: const Text('My Drivers'),
          subtitle: Text('Select from your saved drivers'),
          leading: Radio<String>(
            value: 'My Drivers',
            groupValue: controller.selectedDriverOption.value,
            onChanged: (value) {
              controller.selectedDriverOption.value = 'My Drivers';
              controller.resolvedDriverDetails.value = null;
            },
          ),
        ),
        ListTile(
          title: const Text('Request Support'),
          subtitle: Text('FAS will assign a driver before dispatch'),
          leading: Radio<String>(
            value: 'Request Support',
            groupValue: controller.selectedDriverOption.value,
            onChanged: (value) {
              controller.selectedDriverOption.value = 'Request Support';
              controller.selectedDriver.value = null;
            },
          ),
        ),
      ],
    ),
  );
}

Widget buildPackhouseSelectionCard(ConsignmentFormController controller) {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Text(
        'Select Packhouse:',
        style: TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.bold,
          color: Color(0xff548235),
        ),
      ),
      SizedBox(height: 16),
      ListTile(
        title: const Text('Self'),
        subtitle: Text('You will handle the packing yourself'),
        leading: Radio<String>(
          value: 'Self',
          groupValue: controller.selectedPackhouseOption.value,
          onChanged: (value) {
            controller.selectedPackhouseOption.value = value;
            controller.selectedPackhouse.value = null;
            controller.resolvedPackhouseDetails.value = null;
          },
        ),
      ),
      ListTile(
        title: const Text('My Packhouses'),
        subtitle: Text('Select from your saved packhouses'),
        leading: Radio<String>(
          value: 'My Packhouses',
          groupValue: controller.selectedPackhouseOption.value,
          onChanged: (value) {
            controller.selectedPackhouseOption.value = value;
            controller.resolvedPackhouseDetails.value = null;
          },
        ),
      ),
      ListTile(
        title: const Text('Request Support'),
        subtitle: Text('FAS will assign a packhouse near your farm'),
        leading: Radio<String>(
          value: 'Request Support',
          groupValue: controller.selectedPackhouseOption.value,
          onChanged: (value) {
            controller.selectedPackhouseOption.value = value;
            controller.selectedPackhouse.value = null;
          },
        ),
      ),
    ],
  );
}

Widget buildPackhouseDetailsCard(ConsignmentFormController controller) {
  if (controller.selectedPackhouseOption.value == null)
    return SizedBox.shrink();

  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      if (controller.selectedPackhouseOption.value == 'My Packhouses') ...[
        DropdownButtonFormField<PackHouse>(
          decoration: getInputDecoration('Select Packhouse',
              prefixIcon: Icons.business),
          value: controller.selectedPackhouse.value,
          items: glb.availablePackHouses.map((PackHouse packhouse) {
            return DropdownMenuItem<PackHouse>(
              value: packhouse,
              child: Text(packhouse.name),
            );
          }).toList(),
          onChanged: (PackHouse? newValue) {
            controller.selectedPackhouse.value = newValue;
          },
          validator: (value) =>
              value == null ? 'Please select a packhouse' : null,
        ),
      ] else if (controller.selectedPackhouseOption.value ==
          'Request Support') ...[
        ElevatedButton.icon(
          onPressed: controller.isPackhouseSupportRequested.value
              ? null
              : controller.requestPackhouseSupport,
          icon: Icon(Icons.support_agent),
          label: Text('Request Packhouse Support'),
          style: ElevatedButton.styleFrom(
            backgroundColor: Color(0xff548235),
            foregroundColor: Colors.white,
            padding: EdgeInsets.symmetric(vertical: 12, horizontal: 24),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
          ),
        ),
        SizedBox(height: 16),
        if (controller.isPackhouseSupportRequested.value)
          Center(
            child: Column(
              children: [
                CircularProgressIndicator(),
                SizedBox(height: 8),
                Text('Requesting packhouse support...'),
              ],
            ),
          )
        else if (controller.resolvedPackhouseDetails.value != null)
          Container(
            padding: EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.grey[50],
              borderRadius: BorderRadius.circular(8),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Assigned Packhouse:',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 8),
                Text(
                    'Name: ${controller.resolvedPackhouseDetails.value!.name}'),
                Text(
                    'Contact: ${controller.resolvedPackhouseDetails.value!.phoneNumber}'),
                if (controller.resolvedPackhouseDetails.value!.address != null)
                  Text(
                      'Address: ${controller.resolvedPackhouseDetails.value!.address}'),
              ],
            ),
          ),
      ],
    ],
  );
}

Color getQualityColor(String quality) {
  switch (quality) {
    case 'AAA':
      return Color(0xFF8B0000); // Dark Red
    case 'AA':
      return Color(0xFFFF8C00); // Orange
    case 'GP':
      return Color(0xFF2E7D32); // Green
    case 'Mix/Pear':
      return Color(0xFFFFD700); // Yellow
    default:
      return Colors.grey;
  }
}



Widget buildBiltyStepMobile(ConsignmentFormController controller) {
  return Column(
    mainAxisSize: MainAxisSize.min,
    children: [
      SizedBox(
        height: 450,
        child: SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            children: controller.bilty.value?.categories.map((category) {
                  final key = controller.getUniqueKey(
                      category.quality, category.category);
                  final qualityColor = getQualityColor(category.quality);
                  final isPearCategory = category.quality == 'Mix/Pear' &&
                      category.category == 'Pear';

                  return Container(
                    width: 300,
                    margin: EdgeInsets.symmetric(vertical: 8),
                    child: Card(
                      elevation: 4,
                      child: Container(
                        decoration: BoxDecoration(
                          color: qualityColor,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                '${category.quality} - ${category.category}',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              SizedBox(height: 16),
                              _buildInfoRow('Size', category.size),
                              _buildInfoRow(
                                'Pieces/Box',
                                isPearCategory
                                    ? _buildEditableField(
                                        controller,
                                        category.quality,
                                        category.category,
                                        'piecesPerBox',
                                        category.piecesPerBox.toString(),
                                      )
                                    : category.piecesPerBox.toString(),
                              ),
                              _buildInfoRow(
                                'Avg Weight (g)',
                                _buildEditableField(
                                  controller,
                                  category.quality,
                                  category.category,
                                  'avgWeight',
                                  controller.avgWeightControllers[key]?.text ??
                                      '0',
                                ),
                              ),
                              _buildInfoRow(
                                'Box Count',
                                _buildEditableField(
                                  controller,
                                  category.quality,
                                  category.category,
                                  'boxCount',
                                  controller.boxCountControllers[key]?.text ??
                                      '0',
                                ),
                              ),
                              _buildInfoRow(
                                'Box Weight (kg)',
                                controller.avgBoxWeights[key]?.value
                                        .toStringAsFixed(2) ??
                                    '0.00',
                              ),
                              _buildInfoRow(
                                'Total Weight (kg)',
                                controller.totalWeights[key]?.value
                                        .toStringAsFixed(2) ??
                                    '0.00',
                              ),
                              SizedBox(height: 16),
                              _buildImagePreview(
                                controller,
                                category.quality,
                                category.category,
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  );
                }).toList() ??
                [],
          ),
        ),
      ),
      Container(
        width: double.infinity,
        padding: EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.grey[50],
          borderRadius: BorderRadius.circular(8),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 4,
              offset: Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: ElevatedButton.icon(
                onPressed: controller.isDownloading.value
                    ? null
                    : () async {
                  controller.isDownloading.value = true;
                  try {
                    await BiltyDownloadService.downloadBiltyAsCSV(
                        controller);
                  } finally {
                    controller.isDownloading.value = false;
                  }
                },
                icon: controller.isDownloading.value
                    ? const SizedBox(
                  width: 20,
                  height: 20,
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                    valueColor:
                    AlwaysStoppedAnimation<Color>(Colors.white),
                  ),
                )
                    : Icon(Icons.download),
                label: Text(controller.isDownloading.value
                    ? 'Downloading...'
                    : 'Download Bilty'),
                style: ElevatedButton.styleFrom( shape: ContinuousRectangleBorder(),
                  backgroundColor: Color(0xff548235),
                  foregroundColor: Colors.white,
                ),
              ),
            ),
            Text(
              'Summary',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Color(0xff548235),
              ),
            ),
            SizedBox(height: 8),
            Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Total Boxes',
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.grey[600],
                        ),
                      ),
                      SizedBox(height: 4),
                      Text(
                        controller.totalTableBoxes.value.toString(),
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Total Weight',
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.grey[600],
                        ),
                      ),
                      SizedBox(height: 4),
                      Text(
                        '${controller.totalTableWeight.value.toStringAsFixed(2)} kg',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
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
  );
}

Widget buildBiltyStepDesktop(ConsignmentFormController controller) {
  return Column(
    mainAxisSize: MainAxisSize.min,
    children: [
      SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: DataTable(
          columnSpacing: 16,
          horizontalMargin: 16,
          headingRowColor: MaterialStateProperty.all(Colors.grey.shade200),
          columns: [
            DataColumn(
                label: Text('Quality',
                    style: TextStyle(fontWeight: FontWeight.bold))),
            DataColumn(
                label: Text('Category',
                    style: TextStyle(fontWeight: FontWeight.bold))),
            DataColumn(
                label: Text('Size',
                    style: TextStyle(fontWeight: FontWeight.bold))),
            DataColumn(
                label: Text('Pieces/Box',
                    style: TextStyle(fontWeight: FontWeight.bold))),
            DataColumn(
                label: Text('Avg Weight (g)',
                    style: TextStyle(fontWeight: FontWeight.bold))),
            DataColumn(
                label: Text('Box Count',
                    style: TextStyle(fontWeight: FontWeight.bold))),
            DataColumn(
                label: Text('Box Weight (kg)',
                    style: TextStyle(fontWeight: FontWeight.bold))),
            DataColumn(
                label: Text('Total Weight (kg)',
                    style: TextStyle(fontWeight: FontWeight.bold))),
            DataColumn(
                label: Text('Image',
                    style: TextStyle(fontWeight: FontWeight.bold))),
          ],
          rows: controller.bilty.value?.categories.map((category) {
                final key = controller.getUniqueKey(
                    category.quality, category.category);
                final qualityColor = getQualityColor(category.quality);
                final isPearCategory = category.quality == 'Mix/Pear' &&
                    category.category == 'Pear';

                return DataRow(
                  color: MaterialStateProperty.all(qualityColor),
                  cells: [
                    DataCell(Text(category.quality,
                        style: TextStyle(color: Colors.white))),
                    DataCell(Text(category.category,
                        style: TextStyle(color: Colors.white))),
                    DataCell(Text(category.size,
                        style: TextStyle(color: Colors.white))),
                    DataCell(
                      isPearCategory
                          ? _buildEditableCell(
                              controller,
                              category.quality,
                              category.category,
                              'piecesPerBox',
                              category.piecesPerBox.toString(),
                            )
                          : Text(category.piecesPerBox.toString(),
                              style: TextStyle(color: Colors.white)),
                    ),
                    DataCell(_buildEditableCell(
                      controller,
                      category.quality,
                      category.category,
                      'avgWeight',
                      controller.avgWeightControllers[key]?.text ?? '0',
                    )),
                    DataCell(_buildEditableCell(
                      controller,
                      category.quality,
                      category.category,
                      'boxCount',
                      controller.boxCountControllers[key]?.text ?? '0',
                    )),
                    DataCell(Text(
                      controller.avgBoxWeights[key]?.value.toStringAsFixed(2) ??
                          '0.00',
                      style: TextStyle(color: Colors.white),
                    )),
                    DataCell(Text(
                      controller.totalWeights[key]?.value.toStringAsFixed(2) ??
                          '0.00',
                      style: TextStyle(color: Colors.white),
                    )),
                    DataCell(_buildImageCell(
                      controller,
                      category.quality,
                      category.category,
                    )),
                  ],
                );
              }).toList() ??
              [],
        ),
      ),
      Padding(
        padding: const EdgeInsets.all(8.0),
        child: Container(
          width: double.infinity,
          padding: EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.grey[50],
            borderRadius: BorderRadius.circular(8),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.05),
                blurRadius: 4,
                offset: Offset(0, 2),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Container(
                  child: ElevatedButton.icon(
                    onPressed: controller.isDownloading.value
                        ? null
                        : () async {
                      controller.isDownloading.value = true;
                      try {
                        await BiltyDownloadService.downloadBiltyAsCSV(
                            controller);
                      } finally {
                        controller.isDownloading.value = false;
                      }
                    },
                    icon: controller.isDownloading.value
                        ? const SizedBox(
                      width: 20,
                      height: 20,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        valueColor:
                        AlwaysStoppedAnimation<Color>(Colors.white),
                      ),
                    )
                        : Icon(Icons.download),
                    label: Text(controller.isDownloading.value
                        ? 'Downloading...'
                        : 'Download CSV'),
                    style: ElevatedButton.styleFrom( shape: ContinuousRectangleBorder(),
                      backgroundColor: Color(0xff548235),
                      foregroundColor: Colors.white,
                    ),
                  ),
                ),
              ),
              Text(
                'Summary',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Color(0xff548235),
                ),
              ),
              SizedBox(height: 8),
              Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Total Boxes',
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.grey[600],
                          ),
                        ),
                        SizedBox(height: 4),
                        Text(
                          controller.totalTableBoxes.value.toString(),
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Total Weight',
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.grey[600],
                          ),
                        ),
                        SizedBox(height: 4),
                        Text(
                          '${controller.totalTableWeight.value.toStringAsFixed(2)} kg',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    ],
  );
}

Widget _buildInfoRow(String label, dynamic value) {
  return Padding(
    padding: const EdgeInsets.symmetric(vertical: 4.0),
    child: Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: TextStyle(
            color: Colors.white70,
            fontSize: 14,
          ),
        ),
        if (value is Widget)
          value
        else
          Text(
            value.toString(),
            style: TextStyle(
              color: Colors.white,
              fontSize: 14,
              fontWeight: FontWeight.bold,
            ),
          ),
      ],
    ),
  );
}

Widget _buildEditableField(
  ConsignmentFormController controller,
  String quality,
  String category,
  String fieldType,
  String value,
) {
  final isEditing = controller.isFieldEditing(quality, category, fieldType);
  final key = controller.getUniqueKey(quality, category);

  return Container(
    width: 100,
    child: Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Expanded(
          child: isEditing
              ? TextField(
                  controller: fieldType == 'avgWeight'
                      ? controller.avgWeightControllers[key]
                      : fieldType == 'boxCount'
                          ? controller.boxCountControllers[key]
                          : controller.piecesPerBoxControllers[key],
                  keyboardType: fieldType == 'avgWeight'
                      ? TextInputType.numberWithOptions(decimal: true)
                      : TextInputType.number,
                  maxLength: fieldType == 'boxCount' ? 3 : null,
                  style: TextStyle(color: Colors.white),
                  decoration: InputDecoration(
                    isDense: true,
                    contentPadding: EdgeInsets.symmetric(vertical: 8),
                    border: InputBorder.none,
                    counterText: '',
                    hintText: 'Enter value',
                    hintStyle: TextStyle(color: Colors.white70),
                  ),
                  onChanged: (value) {
                    if (fieldType == 'avgWeight') {
                      controller.updateAvgWeight(quality, category, value);
                    } else if (fieldType == 'boxCount') {
                      controller.updateBoxCount(quality, category, value);
                    } else if (fieldType == 'piecesPerBox') {
                      controller.updatePiecesPerBox(quality, category, value);
                    }
                  },
                  onSubmitted: (_) {
                    controller.clearEditingField();
                  },
                )
              : Text(
                  value,
                  style: TextStyle(color: Colors.white),
                ),
        ),
        IconButton(
          icon: Icon(
            isEditing ? Icons.check : Icons.edit,
            size: 20,
            color: Colors.white70,
          ),
          onPressed: () {
            if (isEditing) {
              controller.clearEditingField();
            } else {
              controller.setEditingField(quality, category, fieldType);
            }
          },
        ),
      ],
    ),
  );
}

Widget _buildImagePreview(
  ConsignmentFormController controller,
  String quality,
  String category,
) {
  final hasImage = controller.hasImage(quality, category);
  final imagePath = controller.getImagePath(quality, category);

  return GestureDetector(
    onTap: () {
      if (!hasImage) {
        controller.pickImage(quality, category);
      }
    },
    child: Container(
      width: double.infinity,
      height: 100,
      decoration: BoxDecoration(
        border: Border.all(color: Colors.white30),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Stack(
        fit: StackFit.expand,
        children: [
          if (hasImage && imagePath != null)
            ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: imagePath.startsWith('data:image')
                  ? Image.memory(
                      base64Decode(imagePath.split(',')[1]),
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) {
                        return _buildImagePlaceholder();
                      },
                    )
                  : Image.network(
                      imagePath,
                      fit: BoxFit.cover,
                      loadingBuilder: (context, child, loadingProgress) {
                        if (loadingProgress == null) return child;
                        return Center(
                          child: CircularProgressIndicator(
                            value: loadingProgress.expectedTotalBytes != null
                                ? loadingProgress.cumulativeBytesLoaded /
                                    loadingProgress.expectedTotalBytes!
                                : null,
                            valueColor:
                                AlwaysStoppedAnimation<Color>(Colors.white),
                          ),
                        );
                      },
                      errorBuilder: (context, error, stackTrace) {
                        return _buildImagePlaceholder();
                      },
                    ),
            )
          else
            _buildImagePlaceholder(),
          if (hasImage)
            Positioned(
              top: 4,
              right: 4,
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    padding: EdgeInsets.all(4),
                    decoration: BoxDecoration(
                      color: Colors.black54,
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: Icon(
                      Icons.image,
                      color: Colors.white,
                      size: 16,
                    ),
                  ),
                  SizedBox(width: 4),
                  IconButton(
                    icon: Icon(Icons.camera_alt, color: Colors.white),
                    onPressed: () => controller.pickImage(quality, category),
                    style: IconButton.styleFrom(
                      backgroundColor: Colors.black54,
                      padding: EdgeInsets.all(4),
                    ),
                  ),
                  SizedBox(width: 4),
                  IconButton(
                    icon: Icon(Icons.delete, color: Colors.white),
                    onPressed: () => controller.removeImage(quality, category),
                    style: IconButton.styleFrom(
                      backgroundColor: Colors.black54,
                      padding: EdgeInsets.all(4),
                    ),
                  ),
                ],
              ),
            ),
        ],
      ),
    ),
  );
}

Widget _buildImagePlaceholder() {
  return Container(
    decoration: BoxDecoration(
      color: Colors.black12,
      borderRadius: BorderRadius.circular(8),
    ),
    child: Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.camera_alt, color: Colors.white70, size: 32),
          SizedBox(height: 4),
          Text(
            'Tap to take picture',
            style: TextStyle(
              color: Colors.white70,
              fontSize: 12,
            ),
          ),
        ],
      ),
    ),
  );
}

Widget _buildEditableCell(
  ConsignmentFormController controller,
  String quality,
  String category,
  String fieldType,
  String value,
) {
  final isEditing = controller.isFieldEditing(quality, category, fieldType);
  final key = controller.getUniqueKey(quality, category);
  final qualityColor = getQualityColor(quality);

  return Container(
    padding: EdgeInsets.symmetric(horizontal: 8),
    decoration: BoxDecoration(
      border: Border.all(
        color: isEditing ? Colors.white : Colors.grey.shade300,
        width: isEditing ? 2 : 1,
      ),
      borderRadius: BorderRadius.circular(4),
    ),
    child: Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Expanded(
          child: isEditing
              ? TextField(
                  controller: fieldType == 'avgWeight'
                      ? controller.avgWeightControllers[key]
                      : fieldType == 'boxCount'
                          ? controller.boxCountControllers[key]
                          : controller.piecesPerBoxControllers[key],
                  keyboardType: fieldType == 'avgWeight'
                      ? TextInputType.numberWithOptions(decimal: true)
                      : TextInputType.number,
                  maxLength: fieldType == 'boxCount' ? 3 : null,
                  style: TextStyle(color: Colors.white),
                  decoration: InputDecoration(
                    isDense: true,
                    contentPadding: EdgeInsets.symmetric(vertical: 8),
                    border: InputBorder.none,
                    counterText: '',
                  ),
                  onChanged: (value) {
                    if (fieldType == 'avgWeight') {
                      controller.updateAvgWeight(quality, category, value);
                    } else if (fieldType == 'boxCount') {
                      controller.updateBoxCount(quality, category, value);
                    } else if (fieldType == 'piecesPerBox') {
                      controller.updatePiecesPerBox(quality, category, value);
                    }
                  },
                  enableInteractiveSelection: false,
                  enableIMEPersonalizedLearning: false,
                  onTap: () {
                    final textController = fieldType == 'avgWeight'
                        ? controller.avgWeightControllers[key]
                        : fieldType == 'boxCount'
                            ? controller.boxCountControllers[key]
                            : controller.piecesPerBoxControllers[key];
                    if (textController != null) {
                      textController.selection = TextSelection.fromPosition(
                        TextPosition(offset: textController.text.length),
                      );
                    }
                  },
                )
              : Text(
                  value,
                  style: TextStyle(color: Colors.white),
                  selectionColor: Colors.transparent,
                ),
        ),
        IconButton(
          icon: Icon(
            isEditing ? Icons.check : Icons.edit,
            size: 20,
            color: isEditing ? Colors.white : Colors.white70,
          ),
          onPressed: () {
            if (isEditing) {
              controller.clearEditingField();
            } else {
              controller.setEditingField(quality, category, fieldType);
            }
          },
        ),
      ],
    ),
  );
}

Widget _buildImageCell(
  ConsignmentFormController controller,
  String quality,
  String category,
) {
  final hasImage = controller.hasImage(quality, category);
  final imagePath = controller.getImagePath(quality, category);

  return Row(
    mainAxisSize: MainAxisSize.min,
    children: [
      Container(
        width: 40,
        height: 40,
        decoration: BoxDecoration(
          border: Border.all(color: Colors.grey.shade300),
          borderRadius: BorderRadius.circular(4),
        ),
        child: hasImage && imagePath != null
            ? ClipRRect(
                borderRadius: BorderRadius.circular(4),
                child: kIsWeb
                    ? Image.network(
                        imagePath,
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) {
                          return Icon(Icons.error, color: Colors.red);
                        },
                      )
                    : Image.file(
                        File(imagePath),
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) {
                          return Icon(Icons.error, color: Colors.red);
                        },
                      ),
              )
            : Icon(Icons.camera_alt, color: Colors.grey),
      ),
      SizedBox(width: 4),
      Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          IconButton(
            icon: Icon(Icons.edit, size: 16, color: Colors.blue),
            onPressed: () => controller.pickImage(quality, category),
            padding: EdgeInsets.zero,
            constraints: BoxConstraints(),
          ),
          if (hasImage && imagePath != null)
            IconButton(
              icon: Icon(Icons.visibility, size: 16, color: Colors.green),
              onPressed: () {
                Get.dialog(
                  Dialog(
                    child: Container(
                      width: 300,
                      height: 300,
                      padding: EdgeInsets.all(8),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Expanded(
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(8),
                              child: kIsWeb
                                  ? Image.network(
                                      imagePath,
                                      fit: BoxFit.contain,
                                      errorBuilder:
                                          (context, error, stackTrace) {
                                        return Icon(Icons.error,
                                            color: Colors.red, size: 48);
                                      },
                                    )
                                  : Image.file(
                                      File(imagePath),
                                      fit: BoxFit.contain,
                                      errorBuilder:
                                          (context, error, stackTrace) {
                                        return Icon(Icons.error,
                                            color: Colors.red, size: 48);
                                      },
                                    ),
                            ),
                          ),
                          SizedBox(height: 8),
                          Text(
                            '$quality - $category',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                            ),
                          ),
                          SizedBox(height: 8),
                          TextButton(
                            onPressed: () => Get.back(),
                            child: Text('Close'),
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              },
              padding: EdgeInsets.zero,
              constraints: BoxConstraints(),
            ),
        ],
      ),
    ],
  );
}
