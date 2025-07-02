import 'package:apple_grower/models/employee_model.dart';
import 'package:apple_grower/models/freightForwarder.dart';
import 'package:get/get.dart';
import 'package:latlong2/latlong.dart';
import '../models/aadhati.dart';
import '../models/apmc_model.dart';
import '../models/auth_signatory_post_model.dart';
import '../models/driving_profile_model.dart';
import '../models/grower_model.dart';
import '../models/ladani_model.dart';
import '../models/orchard_model.dart';
import '../models/post_model.dart';
import '../models/transport_model.dart';
import 'dictionary.dart';
import '../models/hpmc_collection_center_model.dart';

import '../models/complaint_model.dart';

RxString roleType = "Grower".obs;
RxString personName = "Ram Singh".obs;
RxString personPhone = "+91 123567890".obs;
RxString personVillage = "Nangal Jarialan".obs;
RxString personPost = "247001".obs;
RxString personBank = "XXXX3312".obs;
RxString personIFSC = "CNRB0002452".obs;
RxBool isHindiLanguage = false.obs;
RxString userId = "".obs;
RxString url = "https://a6c2-2409-40d2-23-527b-61a1-3295-c78d-2399.ngrok-free.app".obs;
RxString id = "6864e07e9d6d2aa7e60be91d".obs;
RxString selectedOrchardAddress = "".obs;
RxString consignmentID = "".obs;
RxList<Complaint> myComplaint = <Complaint>[].obs;

RxList<Aadhati> availableAadhatis = [
  Aadhati(
    id: '685a3d04d4e21f9f6cb9979e',
    name: 'Abhishek Jain',
    contact: '9876543212',
    nameOfTradingFirm: 'Himachal Traders',
    tradingSinceYears: 15,
    firmType: 'Partnership',
    licenseNo: 'LIC123456',
    salesPurchaseLocationName: 'Kotkhai Market',
    locationOnGoogle: 'Kotkhai, Himachal Pradesh',
    appleBoxesPurchased2023: 5000,
    appleBoxesPurchased2024: 6000,
    estimatedTarget2025: 7000.0,
    needTradeFinance: true,
    noOfAppleGrowersServed: 25,
  ),
  Aadhati(
    id: '685a3d77d4e21f9f6cb997a0',
    name: 'Ram',
    contact: '9876543213',
    nameOfTradingFirm: 'Apple Valley Traders',
    tradingSinceYears: 10,
    firmType: 'Proprietorship',
    licenseNo: 'LIC789012',
    salesPurchaseLocationName: 'Shimla Market',
    locationOnGoogle: 'Shimla, Himachal Pradesh',
    appleBoxesPurchased2023: 3000,
    appleBoxesPurchased2024: 3500,
    estimatedTarget2025: 4000.0,
    needTradeFinance: false,
    noOfAppleGrowersServed: 15,
  ),
].obs;

RxList<Apmc> availableApmcs = [
  Apmc(
    id: 'APMC001',
    name: 'Kotkhai APMC',
    address: 'Kotkhai Market, Shimla, Himachal Pradesh',
    nameOfAuthorizedSignatory: 'Rajesh Kumar',
    designation: 'Market Inspector',
    officePhoneNo: '9876543215',
    totalNoOfCommissionAgents: 150,
    totalLadanisWithinJurisdiction: 50,
    totalNoOfTransporters: 30,
    noOfHomeGuardsOnDuty: 10,
    totalApmcStaff: 20,
    appleBoxesSold2023: 50000,
    appleBoxesSold2024: 60000,
    estimatedTarget2025: 75000.0,
    approvedAadhati: [],
    blacklistedAdhaties: [],
    approvedLadanis: [],
    blacklistedLadanis: [],
  ),
  Apmc(
    id: 'APMC002',
    name: 'Kullu APMC',
    address: 'Kullu Market, Kullu, Himachal Pradesh',
    nameOfAuthorizedSignatory: 'Suresh Singh',
    designation: 'Deputy Market Inspector',
    officePhoneNo: '9876543216',
    totalNoOfCommissionAgents: 100,
    totalLadanisWithinJurisdiction: 30,
    totalNoOfTransporters: 20,
    noOfHomeGuardsOnDuty: 8,
    totalApmcStaff: 15,
    appleBoxesSold2023: 30000,
    appleBoxesSold2024: 35000,
    estimatedTarget2025: 45000.0,
    approvedAadhati: [],
    blacklistedAdhaties: [],
    approvedLadanis: [],
    blacklistedLadanis: [],
  ),
].obs;

RxList<AuthSignatoryPost> availableAuthSignatoryPosts = [
  AuthSignatoryPost(
    nameOfAuthorizedSignatory: 'Rajesh Kumar',
    designation: 'Market Inspector',
    officeNo: 'OFFICE001',
    approvedTraders: [],
    blacklistedTraders: [],
    approvedLadanis: [],
    blacklistedLadanis: [],
  ),
  AuthSignatoryPost(
    nameOfAuthorizedSignatory: 'Suresh Singh',
    designation: 'Deputy Market Inspector',
    officeNo: 'OFFICE002',
    approvedTraders: [],
    blacklistedTraders: [],
    approvedLadanis: [],
    blacklistedLadanis: [],
  ),
].obs;

RxList<FreightForwarder> availableBuyers = [
  FreightForwarder(
    id: 'BUYER001',
    name: 'Delhi Fruits Market',
    contact: '9876543217',
    address: 'Azadpur Mandi, Delhi',
    createdAt: DateTime.now().subtract(Duration(days: 365)),
    updatedAt: DateTime.now(),
  ),
  FreightForwarder(
    id: 'BUYER002',
    name: 'Mumbai Fruits Corporation',
    contact: '9876543218',
    address: 'Vashi Market, Mumbai',
    createdAt: DateTime.now().subtract(Duration(days: 180)),
    updatedAt: DateTime.now(),
  ),
].obs;

RxList<DrivingProfile> availableDrivingProfiles = [
  DrivingProfile(
    id: 'DP001',
    name: 'Rajesh Kumar',
    contact: '+91 9876543210',
    drivingLicenseNo: 'DL-123456789',
    vehicleRegistrationNo: 'HR-01-AB-1234',
    chassiNoOfVehicle: 'CH123456789',
    payloadCapacityApprovedByRto: '10 tons',
    grossVehicleWeight: '15 tons',
    noOfTyres: 10,
    permitOfVehicleDriving: 'All India',
    vehicleOwnerAdharGst: 'ADH123456789',
    appleBoxesTransported2023: 5000,
    appleBoxesTransported2024: 6000,
    estimatedTarget2025: 7000.0,
    statesDrivenThrough: 'Himachal Pradesh, Delhi, Maharashtra',
    currentLocation: LatLng(31.1048, 77.1734),
  ),
  DrivingProfile(
    id: 'DP002',
    name: 'Suresh Singh',
    contact: '+91 9876543211',
    drivingLicenseNo: 'DL-987654321',
    vehicleRegistrationNo: 'HP-01-CD-5678',
    chassiNoOfVehicle: 'CH987654321',
    payloadCapacityApprovedByRto: '12 tons',
    grossVehicleWeight: '18 tons',
    noOfTyres: 12,
    permitOfVehicleDriving: 'All India',
    vehicleOwnerAdharGst: 'ADH987654321',
    appleBoxesTransported2023: 4500,
    appleBoxesTransported2024: 5500,
    estimatedTarget2025: 6500.0,
    statesDrivenThrough: 'Himachal Pradesh, Punjab, Haryana',
    currentLocation: LatLng(31.1148, 77.1834),
  ),
].obs;

RxList<Grower> availableGrowers = [
  Grower(
    id: 'GROWER001',
    name: 'Rajesh Kumar',
    phoneNumber: '9876543210',
    address:
        'Village Kotkhai, Tehsil Kotkhai, District Shimla, Himachal Pradesh',
    aadharNumber: '123456789012',
    pinCode: '171201',
    packingHouses: [],
    createdAt: DateTime.now().subtract(Duration(days: 365)),
    updatedAt: DateTime.now(),
  ),
  Grower(
    id: 'GROWER002',
    name: 'Suresh Singh',
    phoneNumber: '9876543211',
    address: 'Village Kullu, Tehsil Kullu, District Kullu, Himachal Pradesh',
    aadharNumber: '987654321098',
    pinCode: '175101',
    packingHouses: [],
    createdAt: DateTime.now().subtract(Duration(days: 180)),
    updatedAt: DateTime.now(),
  ),
].obs;

RxList<Ladani> availableLadanis = [
  Ladani(
    id: 'LADANI001',
    name: 'Himachal Apple Corporation',
    contact: '9876543214',
    address: 'Industrial Area, Shimla, Himachal Pradesh',
    nameOfTradingFirm: 'Himachal Apple Corp',
    tradingSinceYears: 20,
    firmType: 'Private Limited',
    licenseNo: 'CORP123456',
    purchaseLocationAddress: 'Industrial Area, Shimla',
    licensesIssuingAPMC: 'Shimla APMC',
    locationOnGoogle: 'Shimla Industrial Area',
    appleBoxesPurchased2023: 10000,
    appleBoxesPurchased2024: 12000,
    estimatedTarget2025: 15000.0,
    perBoxExpensesAfterBidding: 150.0,
  ),
  Ladani(
    id: 'LADANI002',
    name: 'Kullu Valley Traders',
    contact: '9876543215',
    address: 'Kullu Valley, Kullu, Himachal Pradesh',
    nameOfTradingFirm: 'Kullu Valley Corp',
    tradingSinceYears: 15,
    firmType: 'Private Limited',
    licenseNo: 'CORP789012',
    purchaseLocationAddress: 'Kullu Market',
    licensesIssuingAPMC: 'Kullu APMC',
    locationOnGoogle: 'Kullu Market Area',
    appleBoxesPurchased2023: 8000,
    appleBoxesPurchased2024: 9000,
    estimatedTarget2025: 12000.0,
    perBoxExpensesAfterBidding: 140.0,
  ),
].obs;

RxList<Orchard> availableOrchards = [
  Orchard(
    id: 'ORCH001',
    name: 'Main Orchard',
    location: 'Kotkhai Valley',
    numberOfFruitingTrees: 500,
    expectedHarvestDate: DateTime.now().add(Duration(days: 30)),
    boundaryPoints: [
      GPSPoint(latitude: 31.1234, longitude: 77.5678),
      GPSPoint(latitude: 31.1235, longitude: 77.5679),
      GPSPoint(latitude: 31.1236, longitude: 77.5680),
      GPSPoint(latitude: 31.1237, longitude: 77.5681),
    ],
    area: 5.2,
    boundaryImagePath: 'assets/orchards/main_orchard.png',
    cropStage: CropStage.colourInitiation,
    estimatedBoxes: 2000,
    createdAt: DateTime.now().subtract(Duration(days: 30)),
    updatedAt: DateTime.now(),
  ),
  Orchard(
    id: 'ORCH002',
    name: 'North Field',
    location: 'Kullu Valley',
    numberOfFruitingTrees: 300,
    expectedHarvestDate: DateTime.now().add(Duration(days: 45)),
    boundaryPoints: [
      GPSPoint(latitude: 31.2234, longitude: 77.6678),
      GPSPoint(latitude: 31.2235, longitude: 77.6679),
      GPSPoint(latitude: 31.2236, longitude: 77.6680),
      GPSPoint(latitude: 31.2237, longitude: 77.6681),
    ],
    area: 3.8,
    boundaryImagePath: 'assets/orchards/north_field.png',
    cropStage: CropStage.colourInitiation,
    estimatedBoxes: 1200,
    createdAt: DateTime.now().subtract(Duration(days: 20)),
    updatedAt: DateTime.now(),
  ),
].obs;

RxList<Employee> availablePackers = [
  Employee(
    id: 'PACKER001',
    name: 'Himalayan Packers',
    phoneNumber: '9876543213',
  ),
  Employee(
    id: 'PACKER002',
    name: 'Kullu Packers',
    phoneNumber: '9876543214',
  ),
].obs;

RxList<Post> availablePosts = [
  Post(
    nameOfDutyOfficer: 'Rajesh Kumar',
    designationRank: 'Market Inspector',
    placeOfAppleSeason2025Duty: 'Kotkhai Market',
    googleLocationOfDutyPlace: 'Kotkhai, Himachal Pradesh',
    vehicleRegistrationNo: 'HP01AB1234',
    noOfBoxesLoaded: 100,
    destinationMarketOfVehicle: 'Delhi',
  ),
  Post(
    nameOfDutyOfficer: 'Suresh Singh',
    designationRank: 'Deputy Market Inspector',
    placeOfAppleSeason2025Duty: 'Kullu Market',
    googleLocationOfDutyPlace: 'Kullu, Himachal Pradesh',
    vehicleRegistrationNo: 'HP02CD5678',
    noOfBoxesLoaded: 150,
    destinationMarketOfVehicle: 'Mumbai',
  ),
].obs;

RxList<Transport> availableTransports = [
  Transport(
    id: "TRS10",
    nameOfTheTransportUnion: 'Himachal Transport Union',
    transportUnionRegistrationNo: 'TU123456',
    noOfVehiclesRegistered: 50,
    transportUnionPresidentAdharId: '123456789012',
    transportUnionSecretaryAdhar: '987654321098',
    noOfLightCommercialVehicles: 20,
    noOfMediumCommercialVehicles: 20,
    noOfHeavyCommercialVehicles: 10,
    appleBoxesTransported2023: 50000,
    appleBoxesTransported2024: 60000,
    estimatedTarget2025: 75000.0,
    statesDrivenThrough: 'HP, HR, DL, MH',
    name: 'Transport Union A',
    contact: '878676756',
    address: 'Himachal',
  ),
  Transport(
    id: "TRS20",
    nameOfTheTransportUnion: 'Kullu Transport Union',
    transportUnionRegistrationNo: 'TU789012',
    noOfVehiclesRegistered: 30,
    transportUnionPresidentAdharId: '234567890123',
    transportUnionSecretaryAdhar: '876543210987',
    noOfLightCommercialVehicles: 15,
    noOfMediumCommercialVehicles: 10,
    noOfHeavyCommercialVehicles: 5,
    appleBoxesTransported2023: 30000,
    appleBoxesTransported2024: 35000,
    estimatedTarget2025: 45000.0,
    statesDrivenThrough: 'HP, HR, DL',
    name: 'Transport Union B',
    contact: '8786767567',
    address: 'Himachal',
  ),
].obs;

// Dummy data for the consignment quality/category table
final List<Map<String, dynamic>> consignmentTableData = [
  {
    'quality': 'AAA',
    'category': 'Extra Large',
    'size': '>80mm',
    'avgWeight': '250g',
    'piecesInBox': 80,
  },
  {
    'quality': 'AAA',
    'category': 'Large',
    'size': '>75mm-<80mm',
    'avgWeight': '200g',
    'piecesInBox': 100,
  },
  {
    'quality': 'AAA',
    'category': 'Medium',
    'size': '>70mm-<75mm',
    'avgWeight': '160g',
    'piecesInBox': 125,
  },
  {
    'quality': 'AAA',
    'category': 'Small',
    'size': '>65mm-<70mm',
    'avgWeight': '133g',
    'piecesInBox': 150,
  },
  {
    'quality': 'AAA',
    'category': 'Extra Small',
    'size': '>60mm-<65mm',
    'avgWeight': '116g',
    'piecesInBox': 175,
  },
  {
    'quality': 'AAA',
    'category': 'E Extra Small',
    'size': '>55mm-<60mm',
    'avgWeight': '98g',
    'piecesInBox': 200,
  },
  {
    'quality': 'AAA',
    'category': '240 Count',
    'size': '>50mm-<55mm',
    'avgWeight': '75g',
    'piecesInBox': 240,
  },
  {
    'quality': 'AAA',
    'category': 'Pittu',
    'size': '>45mm-<50mm',
    'avgWeight': '70g',
    'piecesInBox': 270,
  },
  {
    'quality': 'AAA',
    'category': 'Seprator',
    'size': '>40mm-<45mm',
    'avgWeight': '65g',
    'piecesInBox': 300,
  },
  {
    'quality': 'GP',
    'category': 'Large',
    'size': '>75mm-<80mm',
    'avgWeight': '200g',
    'piecesInBox': 40,
  },
  {
    'quality': 'GP',
    'category': 'Medium',
    'size': '>70mm-<75mm',
    'avgWeight': '160g',
    'piecesInBox': 50,
  },
  {
    'quality': 'GP',
    'category': 'Small',
    'size': '>65mm-<70mm',
    'avgWeight': '133g',
    'piecesInBox': 60,
  },
  {
    'quality': 'GP',
    'category': 'Extra Small',
    'size': '>60mm-<65mm',
    'avgWeight': '116g',
    'piecesInBox': 70,
  },
  {
    'quality': 'AA',
    'category': 'Extra Large',
    'size': '>80mm',
    'avgWeight': '250g',
    'piecesInBox': 80,
  },
  {
    'quality': 'AA',
    'category': 'Large',
    'size': '>75mm-<80mm',
    'avgWeight': '200g',
    'piecesInBox': 100,
  },
  {
    'quality': 'AA',
    'category': 'Medium',
    'size': '>70mm-<75mm',
    'avgWeight': '160g',
    'piecesInBox': 125,
  },
  {
    'quality': 'AA',
    'category': 'Small',
    'size': '>65mm-<70mm',
    'avgWeight': '133g',
    'piecesInBox': 150,
  },
  {
    'quality': 'AA',
    'category': 'Extra Small',
    'size': '>60mm-<65mm',
    'avgWeight': '116g',
    'piecesInBox': 175,
  },
].obs;

String getTranslatedText(String englishText) {
  String selectedLang = isHindiLanguage.value ? "hi" : "en";

  // Return original text for English
  if (selectedLang == "en") {
    return englishText;
  }

  // Check cache only
  if (translationCache[selectedLang]?.containsKey(englishText.trim()) ??
      false) {
    return translationCache[selectedLang]![englishText.trim()]!;
  }

  return englishText; // Return English if not in cache
}

// Asynchronous version - uses Google Translate for new translations
RxList<HpmcCollectionCenter> availableHpmcDepots = [
  HpmcCollectionCenter(
    id: 'HPMC001',
    HPMCname: 'Rajesh Kumar',
    operatorName: 'Himachal Collection Center',
    cellNo: '9876543210',
    aadharNo: '123456789012',
    licenseNo: 'HPMC123456',
    operatingSince: '2015',
    location: 'Kotkhai, Shimla, Himachal Pradesh',
    boxesTransported2023: 25000,
    boxesTransported2024: 30000,
    target2025: 35000.0,
    associatedGrowers: [],
    myComplaints: [],
    associatedPackHouses: [],
    associatedDrivers: [],
    associatedTransportUnions: [],
  ),
  HpmcCollectionCenter(
    id: 'HPMC002',
    HPMCname: 'Suresh Singh',
    operatorName: 'Kullu Valley Collection Center',
    cellNo: '9876543211',
    aadharNo: '987654321098',
    licenseNo: 'HPMC789012',
    operatingSince: '2018',
    location: 'Kullu, Himachal Pradesh',
    boxesTransported2023: 20000,
    boxesTransported2024: 25000,
    target2025: 30000.0,
    associatedGrowers: [],
    myComplaints: [],
    associatedPackHouses: [],
    associatedDrivers: [],
    associatedTransportUnions: [],
  ),
].obs;
