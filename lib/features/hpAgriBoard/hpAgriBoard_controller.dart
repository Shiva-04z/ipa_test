import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../models/aadhati.dart';
import '../../models/ladani_model.dart';
import '../../models/hpmc_collection_center_model.dart';
import '../../models/grower_model.dart';
import '../../models/consignment_model.dart';
import '../../models/pack_house_model.dart';
import '../../models/driving_profile_model.dart';

class HPAgriBoardController extends GetxController {
  // Agriculture Board Info
  final RxString boardName = 'Himachal Pradesh Agriculture Board'.obs;
  final RxString boardAddress = 'Shimla, Himachal Pradesh'.obs;
  final RxString boardContact = '9876543210'.obs;
  final RxString boardEmail = 'agriboard@hp.gov.in'.obs;
  final RxString boardLicenseNo = 'AGB123456'.obs;
  final RxBool flag = false.obs;

  // Approved Aadhatis
  final RxList<Aadhati> approvedAadhatis = <Aadhati>[].obs;

  // Blacklisted Aadhatis
  final RxList<Aadhati> blacklistedAadhatis = <Aadhati>[].obs;

  // Approved Ladanis
  final RxList<Ladani> approvedLadanis = <Ladani>[].obs;

  // Blacklisted Ladanis
  final RxList<Ladani> blacklistedLadanis = <Ladani>[].obs;

  final Rx<HpmcCollectionCenter> details = HpmcCollectionCenter().obs;
  final RxList<Grower> associatedGrowers = <Grower>[].obs;
  final RxList<Consignment> consignments = <Consignment>[].obs;
  final RxList<String> galleryImages = <String>[].obs;
  final RxString key = ''.obs;

  // Sample HPMC Collection Center data
  final HpmcCollectionCenter sampleCollectionCenter = HpmcCollectionCenter(
    id: 'HPMC001',
    contactName: 'Rajesh Kumar',
    operatorName: 'Vikram Singh',
    cellNo: '9876543210',
    adharNo: '123456789012',
    licenseNo: 'HPMC2024001',
    operatingSince: 2015,
    location: 'Kotkhai, Shimla',
    tonsTransported2023: 250.5,
    tonsTransported2024: 180.75,
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
  );

  @override
  void onInit() {
    super.onInit();
    loadData();
  }

  void loadData() {
    // Load sample collection center data
    details.value = sampleCollectionCenter;

    // Load associated growers
    if (sampleCollectionCenter.associatedGrowers != null) {
      associatedGrowers.value = sampleCollectionCenter.associatedGrowers!;
    }

    // Load sample consignments
    consignments.value = [
      Consignment(
        id: 'C001',
        quality: 'Premium',
        category: 'Grade A',
        numberOfBoxes: 500,
        numberOfPiecesInBox: 100,
        pickupOption: 'Own',
        shippingFrom: 'Kotkhai',
        shippingTo: 'Shimla',
        packingHouse: PackHouse(
          id: 'PH001',
          name: 'Kotkhai Pack House',
          phoneNumber: '9876543213',
          address: 'Kotkhai, Shimla',
          gradingMachine: 'Automatic Grading System',
          sortingMachine: 'Color Sorting Machine',
          numberOfCrates: 1000,
          boxesPacked2023: 50000,
          boxesPacked2024: 60000,
          estimatedBoxes2025: 75000,
        ),
        commissionAgent: null,
        corporateCompany: null,
        hasOwnCrates: true,
        status: 'Delivered',
        driver: DrivingProfile(
          id: 'DRV001',
          name: 'Amit Kumar',
          contact: '9876543214',
          drivingLicenseNo: 'DL123456',
          vehicleRegistrationNo: 'HP01A1234',
          noOfTyres: 6,
        ),
        createdAt: DateTime.now().subtract(Duration(days: 5)),
        updatedAt: DateTime.now().subtract(Duration(days: 5)),
      ),
      Consignment(
        id: 'C002',
        quality: 'Standard',
        category: 'Grade B',
        numberOfBoxes: 750,
        numberOfPiecesInBox: 80,
        pickupOption: 'Request Driver Support',
        shippingFrom: 'Kotkhai',
        shippingTo: 'Delhi',
        packingHouse: PackHouse(
          id: 'PH002',
          name: 'Delhi Pack House',
          phoneNumber: '9876543215',
          address: 'Delhi',
          gradingMachine: 'Semi-Automatic Grading System',
          sortingMachine: 'Weight Sorting Machine',
          numberOfCrates: 1500,
          boxesPacked2023: 40000,
          boxesPacked2024: 45000,
          estimatedBoxes2025: 60000,
        ),
        commissionAgent: null,
        corporateCompany: null,
        hasOwnCrates: false,
        status: 'In Transit',
        driver: DrivingProfile(
          id: 'DRV002',
          name: 'Rajesh Singh',
          contact: '9876543216',
          drivingLicenseNo: 'DL789012',
          vehicleRegistrationNo: 'HP02B5678',
          noOfTyres: 8,
        ),
        createdAt: DateTime.now().subtract(Duration(days: 3)),
        updatedAt: DateTime.now().subtract(Duration(days: 3)),
      ),
    ];

    // Load sample gallery images
    galleryImages.value = [
      'https://example.com/image1.jpg',
      'https://example.com/image2.jpg',
      'https://example.com/image3.jpg',
    ];
  }

  void addAdhati(Aadhati aadhati) {
    if (flag.value) {
      if (!approvedAadhatis.any((g) => g.id == aadhati.id)) {
        approvedAadhatis.add(aadhati);
        removeBlacklistedAadhati(aadhati.id!);
      }
    } else {
      if (!blacklistedAadhatis.any((g) => g.id == aadhati.id)) {
        blacklistedAadhatis.add(aadhati);
        removeApprovedAadhati(aadhati.id!);
      }
    }
  }

  void addLadani(Ladani ladani) {
    if (flag.value) {
      if (!approvedLadanis.any((g) => g.id == ladani.id)) {
        approvedLadanis.add(ladani);
        removeBlacklistedLadani(ladani.id!);
      }
    } else {
      if (!blacklistedLadanis.any((g) => g.id == ladani.id)) {
        blacklistedLadanis.add(ladani);
        removeApprovedLadani(ladani.id!);
      }
    }
  }

  void removeApprovedAadhati(String id) {
    approvedAadhatis.removeWhere((aadhati) => aadhati.id == id);
  }

  void removeBlacklistedAadhati(String id) {
    blacklistedAadhatis.removeWhere((aadhati) => aadhati.id == id);
  }

  void removeApprovedLadani(String id) {
    approvedLadanis.removeWhere((ladani) => ladani.id == id);
  }

  void removeBlacklistedLadani(String id) {
    blacklistedLadanis.removeWhere((ladani) => ladani.id == id);
  }

  void addAssociatedGrower(Grower grower) {
    associatedGrowers.add(grower);
  }

  void removeAssociatedGrower(String? id) {
    if (id != null) {
      associatedGrowers.removeWhere((grower) => grower.id == id);
    }
  }

  void addConsignment(Consignment consignment) {
    consignments.add(consignment);
  }

  void removeConsignment(String id) {
    consignments.removeWhere((consignment) => consignment.id == id);
  }

  void addGalleryImage(String imageUrl) {
    galleryImages.add(imageUrl);
  }

  void removeGalleryImage(String imageUrl) {
    galleryImages.remove(imageUrl);
  }

  Future<void> pickAndUploadImage() async {
    // TODO: Implement image picking and uploading logic
  }
}
