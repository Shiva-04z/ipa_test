import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import '../../core/globals.dart' as glb;
import '../../models/hpmc_collection_center_model.dart';
import '../../models/grower_model.dart';
import '../../models/consignment_model.dart';
import '../../models/pack_house_model.dart';
import '../../models/driving_profile_model.dart';
import '../../models/transport_model.dart';

class HPAgriBoardController extends GetxController {
  // Agriculture Board Info
  final details = <String, String>{}.obs;
  final associatedGrowers = <Grower>[].obs;
  final associatedDrivers = <DrivingProfile>[].obs;
  final consignments = <Consignment>[].obs;
  final galleryImages = <String>[].obs;

  // Transport Unions and Pack Houses
  final RxList<Transport> associatedTransportUnions = <Transport>[].obs;
  final RxList<PackHouse> associatedPackHouses = <PackHouse>[].obs;

  // Sample HPMC Collection Center data
 Rx<HpmcCollectionCenter> sampleCollectionCenter = HpmcCollectionCenter(
    id: 'HPMC001',
    contactName: 'Rajesh Kumar',
    operatorName: 'Vikram Singh',
    cellNo: '9876543210',
    adharNo: '123456789012',
    licenseNo: 'HPMC2024001',
    operatingSince: "2015",
    location: 'Kotkhai, Shimla',
    boxesTransported2023: 250,
    boxesTransported2024: 100,
    target2025: 300.0,
    associatedGrowers: [
      Grower(
        id: 'G001',
        name: 'Ramesh Chand',
        aadharNumber: '123456789013',
        phoneNumber: '9876543211',
        address: 'Kotkhai, Shimla',
        pinCode: '171201',
        orchards: [],
        commissionAgents: [],
        corporateCompanies: [],
        consignments: [],
        packingHouses: [],
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      ),
      Grower(
        id: 'G002',
        name: 'Suresh Kumar',
        aadharNumber: '123456789014',
        phoneNumber: '9876543212',
        address: 'Kotkhai, Shimla',
        pinCode: '171201',
        orchards: [],
        commissionAgents: [],
        corporateCompanies: [],
        consignments: [],
        packingHouses: [],
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      ),
    ],
  ).obs;

  @override
  void onInit() {
    super.onInit();
    glb.roleType.value= "HPMC DEPOT";
    loadData();
  }

  void loadData() {
    // Load sample data
    details['Name'] = 'Sample HPMC Center';
    details['Phone'] = '1234567890';
    details['Location'] = 'Sample Location';
    details['License'] = 'LIC123456';

    // Load sample associated growers
    associatedGrowers.value = [];

    // Load sample consignments

    // Load sample gallery images
    galleryImages.value = [
      'https://example.com/image1.jpg',
      'https://example.com/image2.jpg',
    ];
  }

  void addAssociatedGrower(Grower grower) {
    if (!associatedGrowers.any((g) => g.id == grower.id)) {
      associatedGrowers.add(grower);
    }
  }

  void removeAssociatedGrower(String id) {
    associatedGrowers.removeWhere((grower) => grower.id == id);
  }

  void addAssociatedPackHouse(PackHouse house) {
    if (!associatedPackHouses.any((g) => g.id == house.id)) {
      associatedPackHouses.add(house);
    }
  }

  void removeAssociatedPackHouse(String id) {
    associatedPackHouses.removeWhere((house) => house.id == id);
  }

  void addConsignment(Consignment consignment) {
    if (!consignments.any((c) => c.id == consignment.id)) {
      consignments.add(consignment);
    }
  }

  void removeConsignment(String id) {
    consignments.removeWhere((consignment) => consignment.id == id);
  }

  void addAssociatedDriver(DrivingProfile driver) {
    if (!associatedDrivers.any((g) => g.id == driver.id)) {
      associatedDrivers.add(driver);
    }
  }

  void removeAssociatedDriver(String id) {
    associatedDrivers.removeWhere((driver) => driver.id == id);
  }

  void addAssociatedTransportUnion(Transport union) {
    if (!associatedTransportUnions.any((g) => g.id == union.id)) {
      associatedTransportUnions.add(union);
    }
  }

  void removeAssociatedTransportUnion(String id) {
    associatedTransportUnions.removeWhere((union) => union.id == id);
  }

  void addGalleryImage(String imageUrl) {
    galleryImages.add(imageUrl);
  }

  void removeGalleryImage(String imageUrl) {
    galleryImages.remove(imageUrl);
  }

  Future<void> pickAndUploadImage() async {
    final ImagePicker picker = ImagePicker();
    final XFile? image = await picker.pickImage(source: ImageSource.gallery);

    if (image != null) {
      // Here you would typically upload the image to your storage service
      // For now, we'll just add the local path to the gallery
      galleryImages.add(image.path);
    }
  }
}
