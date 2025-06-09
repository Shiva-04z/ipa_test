import 'package:apple_grower/models/freightForwarder.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import '../../models/ladani_model.dart';
import '../../models/aadhati.dart';

import '../../models/driving_profile_model.dart';
import '../../models/consignment_model.dart';

class LadaniBuyersController extends GetxController {
  // Add ladaniBuyers-specific properties and methods here
  RxString companyName = ''.obs;
  RxString businessType = ''.obs;
  final galleryImages = <String>[].obs;

  final details = {}.obs;
  final associatedAadhatis = <Aadhati>[].obs;
  final associatedBuyers = <FreightForwarder>[].obs;
  final associatedDrivers = <DrivingProfile>[].obs;
  final consignments = <Consignment>[].obs;

  @override
  void onInit() {
    super.onInit();
    // Initialize with sample data
    details.value = {
      'name': 'Sample Ladani',
      'phoneNumber': '+1234567890',
      'address': 'Sample Address',
      'apmc': 'Sample APMC',
    };
  }

  void addAssociatedAadhatis(Aadhati aadhati) {
    if (!associatedAadhatis.any((g) => g.id == aadhati.id)) {
      associatedAadhatis.add(aadhati);
    }
  }

  void addAssociatedBuyers(FreightForwarder buyer) {
    if (!associatedBuyers.any((g) => g.id == buyer.id)) {
      associatedBuyers.add(buyer);
    }
  }

  void addAssociatedDrivers(DrivingProfile driver) {
    if (!associatedDrivers.any((g) => g.id == driver.id)) {
      associatedDrivers.add(driver);
    }
  }

  void addConsignments(Consignment consignment) {
    if (!consignments.any((g) => g.id == consignment.id)) {
      consignments.add(consignment);
    }
  }

  void removeAssociatedAadhati(String id) {
    associatedAadhatis.removeWhere((aadhati) => aadhati.id == id);
  }

  void removeAssociatedBuyer(String id) {
    associatedBuyers.removeWhere((buyer) => buyer.id == id);
  }

  void removeAssociatedDriver(String id) {
    associatedDrivers.removeWhere((driver) => driver.id == id);
  }

  void removeConsignment(String id) {
    consignments.removeWhere((consignment) => consignment.id == id);
  }

  Future<void> pickAndUploadImage() async {
    final ImagePicker picker = ImagePicker();
    final XFile? image = await picker.pickImage(source: ImageSource.gallery);

    if (image != null) {
      // In a real app, you would upload the image to a server and get back a URL
      // For now, we'll just use the local path
      galleryImages.add(image.path);
    }
  }

  void removeGalleryImage(String imageUrl) {
    galleryImages.remove(imageUrl);
  }
}
