import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import '../../models/freightForwarder.dart';
import '../../models/grower_model.dart';
import '../../models/driving_profile_model.dart';
import '../../models/aadhati.dart';
import '../../models/consignment_model.dart';
import '../../models/ladani_model.dart';

class FreightForwarderController extends GetxController {
  // Add freightForwarder-specific properties and methods here
  RxString companyName = ''.obs;
  RxString licenseNumber = ''.obs;
  final galleryImages = <String>[].obs;
  final details = Rx<FreightForwarder>(FreightForwarder(
    id: '',
    name: '',
    contact: '',
    address: '',
    licenseNo: '',
    forwardingSinceYears: 0,
    licensesIssuingAuthority: '',
    appleBoxesForwarded2023: 0,
    appleBoxesForwarded2024: 0,
    estimatedForwardingTarget2025: 0,
    createdAt: DateTime.now(),
    updatedAt: DateTime.now(),
  ));
  final associatedGrowers = <Grower>[].obs;
  final associatedDrivers = <DrivingProfile>[].obs;
  final associatedAadhatis = <Aadhati>[].obs;
  final associatedLadanis = <Ladani>[].obs;
  final consignments = <Consignment>[].obs;

  @override
  void onInit() {
    super.onInit();
    // Initialize with sample data
    details.value = FreightForwarder(
      id: 'FF1',
      name: 'Sample Freight Forwarder Agency',
      contact: '+91 9876543210',
      address: '123 Main Street, City',
      licenseNo: 'FF123456',
      forwardingSinceYears: 5,
      licensesIssuingAuthority: 'Authority A',
      locationOnGoogle: 'Lat: 20.0, Lng: 70.0',
      appleBoxesForwarded2023: 1000,
      appleBoxesForwarded2024: 1200,
      estimatedForwardingTarget2025: 1500,
      tradeLicenseOfAadhatiAttached: 'TL123',
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
    );
  }

  void addAssociatedAadhatis(Aadhati aadhati) {
    if (!associatedAadhatis.any((g) => g.id == aadhati.id)) {
      associatedAadhatis.add(aadhati);
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

  void addAssociatedGrower(Grower grower) {
    if (!associatedGrowers.any((g) => g.id == grower.id)) {
      associatedGrowers.add(grower);
    }
  }

  void addAssociatedLadani(Ladani ladani) {
    if (!associatedLadanis.any((l) => l.id == ladani.id)) {
      associatedLadanis.add(ladani);
    }
  }

  void removeAssociatedGrower(String id) {
    associatedGrowers.removeWhere((grower) => grower.id == id);
  }

  void removeAssociatedDriver(String id) {
    associatedDrivers.removeWhere((driver) => driver.id == id);
  }

  void removeAssociatedAadhati(String id) {
    associatedAadhatis.removeWhere((aadhati) => aadhati.id == id);
  }

  void removeConsignment(String id) {
    consignments.removeWhere((consignment) => consignment.id == id);
  }

  void removeAssociatedLadani(String id) {
    associatedLadanis.removeWhere((ladani) => ladani.id == id);
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
