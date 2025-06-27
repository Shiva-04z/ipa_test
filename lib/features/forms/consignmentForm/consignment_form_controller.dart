import 'dart:async';
import 'dart:convert';
import 'package:apple_grower/features/grower/grower_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:camera/camera.dart';
import 'package:video_player/video_player.dart';
import 'dart:io';
import '../../../models/aadhati.dart';
import '../../../models/driving_profile_model.dart';
import '../../../models/pack_house_model.dart';
import '../../../models/bilty_model.dart';

import '../../../core/globals.dart' as glb;
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:path_provider/path_provider.dart';

class ConsignmentFormController extends GetxController {
  final picker = ImagePicker();
  List<CameraDescription>? cameras;

  // Step tracking
  final RxInt _currentStep = 0.obs;
  final RxDouble avgWeightpp = 0.0.obs;

  // Track which field is being edited
  final editingField = Rx<Map<String, String>>({});
  final editingQuality = ''.obs;
  final editingCategory = ''.obs;
  final avgWeightControllers = <String, TextEditingController>{}.obs;
  final boxCountControllers = <String, TextEditingController>{}.obs;
  final piecesPerBoxControllers = <String, TextEditingController>{}.obs;
  final avgBoxWeights = <String, RxDouble>{}.obs;
  final totalWeights = <String, RxDouble>{}.obs;
  final totalTableBoxes = 0.obs;
  final totalTableWeight = 0.0.obs;

  // Bilty instance
  final bilty = Rx<Bilty?>(null);

  int get currentStep => _currentStep.value;
  set currentStep(int value) => _currentStep.value = value;

  // Driver Selection
  RxString selectedDriverOption = "Self".obs;
  final selectedDriver = Rx<DrivingProfile?>(null);
  final isDriverSupportRequested = false.obs;
  final resolvedDriverDetails = Rx<DrivingProfile?>(null);

  // Packhouse Selection
  final selectedPackhouseOption = Rx<String?>(null);
  final selectedPackhouse = Rx<PackHouse?>(null);
  final isPackhouseSupportRequested = false.obs;
  final resolvedPackhouseDetails = Rx<PackHouse?>(null);

  // Bilty Creation
  final selectedPackingType = Rx<String?>(null);
  final selectedHpmcDepot = Rx<String?>(null);
  final boxesController = TextEditingController();
  final priceController = TextEditingController();

  // Aadhati Selection
  final selectedAadhatiOption = Rx<String?>(null);
  final selectedAadhati = Rx<Aadhati?>(null);
  final isAadhatiSupportRequested = false.obs;
  final resolvedAadhatiDetails = Rx<Aadhati?>(null);

  // Bilty Data
  final selectedQuality = Rx<String?>(null);
  final selectedCategory = Rx<String?>(null);
  final boxCountController = TextEditingController();
  final biltyItems = <Map<String, dynamic>>[].obs;
  final dummyBiltyItems = <Map<String, dynamic>>[].obs;

  // Aadhati Pricing
  final isPerKgMode = true.obs;
  final pricedBiltyItems = <Map<String, dynamic>>[].obs;
  final isAadhatiSubmitted = false.obs;
  final lastEditedField = <int, String>{}.obs;

  // Bilty Dialog
  final isBiltyDialogOpen = false.obs;

  // Media Capture
  final biltyVideo = Rx<String?>(null);
  final videoController = Rx<VideoPlayerController?>(null);
  final isVideoPlaying = false.obs;

  final formKey = GlobalKey<FormState>();

  final isDownloading = false.obs;

  final imagePaths = <String, String>{}.obs;

  String getUniqueKey(String quality, String category) => '$quality-$category';

  // Helper method to check if a field is being edited
  bool isFieldEditing(String quality, String category, String fieldType) {
    return editingField.value['quality'] == quality &&
        editingField.value['category'] == category &&
        editingField.value['fieldType'] == fieldType;
  }

  // Helper method to set editing state
  void setEditingField(String quality, String category, String fieldType) {
    editingField.value = {
      'quality': quality,
      'category': category,
      'fieldType': fieldType
    };
    update();
  }

  // Helper method to clear editing state
  void clearEditingField() {
    editingField.value = {};
    update();
  }

  void updateAvgWeight(String quality, String category, String value) {
    final key = getUniqueKey(quality, category);
    if (!avgWeightControllers.containsKey(key)) {
      avgWeightControllers[key] = TextEditingController();
    }
    avgWeightControllers[key]!.text = value;

    if (bilty.value != null) {
      final biltyCategory = bilty.value!.getCategory(quality, category);
      if (biltyCategory != null) {
        final avgWeight = double.tryParse(value) ?? 0;
        final boxCount =
            int.tryParse(boxCountControllers[key]?.text ?? '0') ?? 0;

        // Calculate avg box weight in kg
        final avgBoxWeight = (avgWeight * biltyCategory.piecesPerBox) / 1000;
        avgBoxWeights[key] = RxDouble(avgBoxWeight);

        // Calculate total weight including gross weight
        final totalWeight =
            (avgBoxWeight + biltyCategory.avgBoxWeight) * boxCount;
        totalWeights[key] = RxDouble(totalWeight);

        // Update the category in bilty
        final updatedCategory = biltyCategory.copyWith(
          avgWeight: avgWeight,
          avgBoxWeight: avgBoxWeight,
          boxCount: boxCount,
          totalWeight: totalWeight,
        );
        bilty.value =
            bilty.value!.updateCategory(quality, category, updatedCategory);

        updateTotals();
        update();
      }
    }
  }

  void updateBoxCount(String quality, String category, String value) {
    final key = getUniqueKey(quality, category);
    if (!boxCountControllers.containsKey(key)) {
      boxCountControllers[key] = TextEditingController();
    }
    boxCountControllers[key]!.text = value;

    if (bilty.value != null) {
      final biltyCategory = bilty.value!.getCategory(quality, category);
      if (biltyCategory != null) {
        final avgBoxWeight = avgBoxWeights[key]?.value ?? 0;
        final boxCount = int.tryParse(value) ?? 0;

        // Calculate total weight including gross weight
        final totalWeight =
            (avgBoxWeight + biltyCategory.avgBoxWeight) * boxCount;
        totalWeights[key] = RxDouble(totalWeight);

        // Update the category in bilty
        final updatedCategory = biltyCategory.copyWith(
          boxCount: boxCount,
          totalWeight: totalWeight,
        );
        bilty.value =
            bilty.value!.updateCategory(quality, category, updatedCategory);

        updateTotals();
        update();
      }
    }
  }

  void updatePiecesPerBox(String quality, String category, String value) {
    final key = getUniqueKey(quality, category);
    if (!piecesPerBoxControllers.containsKey(key)) {
      piecesPerBoxControllers[key] = TextEditingController();
    }
    piecesPerBoxControllers[key]!.text = value;

    if (bilty.value != null) {
      final biltyCategory = bilty.value!.getCategory(quality, category);
      if (biltyCategory != null) {
        final piecesPerBox = int.tryParse(value) ?? 0;
        final avgWeight =
            double.tryParse(avgWeightControllers[key]?.text ?? '0') ?? 0;
        final boxCount =
            int.tryParse(boxCountControllers[key]?.text ?? '0') ?? 0;

        // Calculate avg box weight in kg
        final avgBoxWeight = (avgWeight * piecesPerBox) / 1000;
        avgBoxWeights[key] = RxDouble(avgBoxWeight);

        // Calculate total weight including gross weight
        final totalWeight =
            (avgBoxWeight + biltyCategory.avgBoxWeight) * boxCount;
        totalWeights[key] = RxDouble(totalWeight);

        // Update the category in bilty
        final updatedCategory = biltyCategory.copyWith(
          piecesPerBox: piecesPerBox,
          avgBoxWeight: avgBoxWeight,
          boxCount: boxCount,
          totalWeight: totalWeight,
        );
        bilty.value =
            bilty.value!.updateCategory(quality, category, updatedCategory);

        updateTotals();
        update();
      }
    }
  }

  @override
  void onInit() {
    super.onInit();
    initializeControllers();
    initializeCameras();
    // Create a new bilty with default categories
    bilty.value = Bilty.createDefault(
        'new_bilty_${DateTime.now().millisecondsSinceEpoch}');

    // Initialize controllers for each category
    for (var category in bilty.value!.categories) {
      final key = getUniqueKey(category.quality, category.category);

      // Set default avg weight
      if (!avgWeightControllers.containsKey(key)) {
        avgWeightControllers[key] =
            TextEditingController(text: category.avgWeight.toString());
      }

      // Set default box count
      if (!boxCountControllers.containsKey(key)) {
        boxCountControllers[key] = TextEditingController(text: '0');
      }

      // Set default pieces per box
      if (!piecesPerBoxControllers.containsKey(key)) {
        piecesPerBoxControllers[key] =
            TextEditingController(text: category.piecesPerBox.toString());
      }

      // Calculate initial box weight
      final avgBoxWeight = (category.avgWeight * category.piecesPerBox) / 1000;
      avgBoxWeights[key] = RxDouble(avgBoxWeight);

      // Calculate initial total weight
      final totalWeight =
          (avgBoxWeight + category.avgBoxWeight) * category.boxCount;
      totalWeights[key] = RxDouble(totalWeight);
    }
    updateTotals();
  }

  Future<void> initializeCameras() async {
    try {
      cameras = await availableCameras();
    } catch (e) {
      print('Error initializing cameras: $e');
    }
  }

  @override
  void onClose() {
    disposeControllers();
    super.onClose();
  }

  void initializeControllers() {
    TextEditingController boxesController = TextEditingController();
    TextEditingController priceController = TextEditingController();
    TextEditingController boxCountController = TextEditingController();
  }

  void disposeControllers() {
    boxesController.dispose();
    priceController.dispose();
    boxCountController.dispose();
    boxCountControllers.values.forEach((controller) => controller.dispose());
    avgWeightControllers.values.forEach((controller) => controller.dispose());
    piecesPerBoxControllers.values
        .forEach((controller) => controller.dispose());
    videoController.value?.dispose();
  }

  // Getters for available options
  List<String> get availableQualities {
    if (bilty.value == null) return [];
    return bilty.value!.categories.map((e) => e.quality).toSet().toList();
  }

  List<String> get availableCategories {
    if (selectedQuality.value == null || bilty.value == null) return [];
    return bilty.value!.categories
        .where((e) => e.quality == selectedQuality.value)
        .map((e) => e.category)
        .toSet()
        .toList();
  }

  BiltyCategory? getBiltyDetails(String quality, String category) {
    if (bilty.value == null) return null;
    return bilty.value!.getCategory(quality, category);
  }

  // Add method to capture image
  Future<void> pickImage(String quality, String category) async {
    try {
      // Get available cameras
      final cameras = await availableCameras();
      if (cameras.isEmpty) {
        throw Exception('No cameras available');
      }

      // Find back camera
      final backCamera = cameras.firstWhere(
        (camera) => camera.lensDirection == CameraLensDirection.back,
        orElse: () => cameras.first,
      );

      // Launch camera with back camera
      final ImagePicker picker = ImagePicker();
      final XFile? image = await picker.pickImage(
        source: ImageSource.camera,
        preferredCameraDevice: CameraDevice.rear,
        imageQuality: 80,
      );

      if (image != null) {
        final key = getUniqueKey(quality, category);

        if (kIsWeb) {
          // For web, convert to base64 and store as data URL
          final bytes = await image.readAsBytes();
          final base64Image = base64Encode(bytes);
          imagePaths[key] = 'data:image/jpeg;base64,$base64Image';
        } else {
          // For mobile, upload to server and store URL
          // TODO: Implement actual server upload
          // For now, we'll use a mock URL
          imagePaths[key] =
              'https://example.com/bilty_images/${DateTime.now().millisecondsSinceEpoch}.jpg';

          // Show success message
          Get.snackbar(
            'Success',
            'Image captured successfully',
            snackPosition: SnackPosition.BOTTOM,
            backgroundColor: Colors.green,
            colorText: Colors.white,
          );
        }
        update();
      }
    } catch (e) {
      Get.snackbar(
        'Error',
        'Failed to capture image: $e',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    }
  }

  // Add method to get image path
  String? getImagePath(String quality, String category) {
    if (bilty.value == null) return null;
    final biltyCategory = bilty.value!.getCategory(quality, category);
    return biltyCategory?.imagePath;
  }

  // Add method to check if image exists
  bool hasImage(String quality, String category) {
    if (bilty.value == null) return false;
    final biltyCategory = bilty.value!.getCategory(quality, category);
    return biltyCategory?.imagePath != null;
  }

  void updateTotals() {
    if (bilty.value == null) return;

    // Calculate total boxes
    totalTableBoxes.value = bilty.value!.categories.fold<int>(
      0,
      (sum, category) => sum + category.boxCount,
    );

    // Calculate total weight
    totalTableWeight.value = bilty.value!.categories.fold<double>(
      0,
      (sum, category) => sum + category.totalWeight,
    );

    update();
  }

  // Methods for driver support
  Future<void> requestDriverSupport() async {
    isDriverSupportRequested.value = true;
    await Future.delayed(Duration(seconds: 2));
    final randomDriver =
        (glb.availableDrivingProfiles.toList()..shuffle()).first;
    resolvedDriverDetails.value = randomDriver;
    isDriverSupportRequested.value = false;
    Get.snackbar(
      'Success',
      'Driver support requested successfully',
      backgroundColor: Colors.green,
      colorText: Colors.white,
    );
  }

  // Methods for packhouse support
  Future<void> requestPackhouseSupport() async {
    isPackhouseSupportRequested.value = true;
    await Future.delayed(Duration(seconds: 2));
    final randomPackhouse = (Get.find<GrowerController>().packingHouses.toList()..shuffle()).first;
    resolvedPackhouseDetails.value = randomPackhouse;
    isPackhouseSupportRequested.value = false;
    Get.snackbar(
      'Success',
      'Packhouse support requested successfully',
      backgroundColor: Colors.green,
      colorText: Colors.white,
    );
  }

  // Methods for aadhati support
  Future<void> requestAadhatiSupport() async {
    isAadhatiSupportRequested.value = true;
    await Future.delayed(Duration(seconds: 2));
    final randomAadhati = (glb.availableAadhatis.toList()..shuffle()).first;
    resolvedAadhatiDetails.value = randomAadhati;
    isAadhatiSupportRequested.value = false;
    Get.snackbar(
      'Success',
      'Aadhati support requested successfully',
      backgroundColor: Colors.green,
      colorText: Colors.white,
    );
  }

  // Methods for media capture
  Future<void> captureVideo() async {
    try {
      final XFile? video = await picker.pickVideo(
        source: ImageSource.camera,
        maxDuration: Duration(seconds: 30),
      );

      if (video != null) {
        biltyVideo.value = video.path;
        videoController.value?.dispose();
        videoController.value = VideoPlayerController.file(File(video.path))
          ..initialize().then(() {
            update();
          } as FutureOr Function(void value));
      }
    } catch (e) {
      Get.snackbar(
        'Error',
        'Failed to capture video: $e',
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    }
  }

  // Methods for price calculations
  void updatePrices(
      Map<String, dynamic> item, int index, String field, String value) {
    final double? newValue = double.tryParse(value);
    if (newValue == null) return;

    lastEditedField[index] = field;

    if (field == 'pricePerKg') {
      item['pricePerKg'] = newValue;
      final totalWeight = item['totalWeight'] as double;
      final boxCount = item['boxCount'] as int;
      if (totalWeight > 0 && boxCount > 0) {
        item['pricePerBox'] = (totalWeight * newValue) / boxCount;
      }
    } else if (field == 'pricePerBox') {
      item['pricePerBox'] = newValue;
      final totalWeight = item['totalWeight'] as double;
      final boxCount = item['boxCount'] as int;
      if (totalWeight > 0 && boxCount > 0) {
        item['pricePerKg'] = (boxCount * newValue) / totalWeight;
      }
    }
    update();
  }

  double calculateRowTotal(Map<String, dynamic> item, int index) {
    final lastEdited = lastEditedField[index];
    if (lastEdited == 'pricePerKg') {
      return item['totalWeight'] * (item['pricePerKg'] as double? ?? 0.0);
    } else {
      return item['boxCount'] * (item['pricePerBox'] as double? ?? 0.0);
    }
  }

  double calculateGrandTotal() {
    return pricedBiltyItems.asMap().entries.fold(
          0.0,
          (sum, entry) => sum + calculateRowTotal(entry.value, entry.key),
        );
  }

  saveForLater() {}

  releaseForBid() {}

  // Step navigation methods
  void onStepContinue() {
    if (currentStep < 2) {
      currentStep++;
    } else {
      // Handle form submission
      saveForLater();
    }
  }

  void onStepCancel() {
    if (currentStep > 0) {
      currentStep--;
    }
  }

  void onStepTapped(int step) {
    currentStep = step;
  }

  void removeImage(String quality, String category) {
    final key = getUniqueKey(quality, category);
    imagePaths.remove(key);
    update();
  }
}
