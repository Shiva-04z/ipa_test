import 'package:get/get.dart';
import '../models/aadhati.dart';
import '../models/apmc_model.dart';
import '../models/auth_signatory_post_model.dart';
import '../models/buyer_model.dart';
import '../models/consignment_model.dart';
import '../models/driving_profile_model.dart';
import '../models/grower_model.dart';
import '../models/ladani_model.dart';
import '../models/orchard_model.dart';
import '../models/pack_house_model.dart';
import '../models/packer_model.dart';
import '../models/post_model.dart';
import '../models/transport_model.dart';

RxString roleType = "Grower".obs;
RxString personName = "Ram Singh".obs;
RxString personPhone = "+91 123567890".obs;
RxString personVillage = "Nangal Jarialan".obs;
RxString personPost = "247001".obs;
RxString personBank = "XXXX3312".obs;
RxString personIFSC = "CNRB0002452".obs;

// Demo lists for all models
RxList<Aadhati> availableAadhatis = [
  Aadhati(
    id: 'AADHATI001',
    name: 'Himachal Traders Pvt Ltd',
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
    id: 'AADHATI002',
    name: 'Apple Valley Trading Co',
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

RxList<Buyer> availableBuyers = [
  Buyer(
    id: 'BUYER001',
    name: 'Delhi Fruits Market',
    phoneNumber: '9876543217',
    address: 'Azadpur Mandi, Delhi',
    gstNumber: 'GST123456789',
    businessType: 'Wholesale',
    createdAt: DateTime.now().subtract(Duration(days: 365)),
    updatedAt: DateTime.now(),
  ),
  Buyer(
    id: 'BUYER002',
    name: 'Mumbai Fruits Corporation',
    phoneNumber: '9876543218',
    address: 'Vashi Market, Mumbai',
    gstNumber: 'GST987654321',
    businessType: 'Retail Chain',
    createdAt: DateTime.now().subtract(Duration(days: 180)),
    updatedAt: DateTime.now(),
  ),
].obs;

RxList<Consignment> availableConsignments = [
  Consignment(
    id: 'CONS001',
    quality: 'Premium',
    category: 'A',
    numberOfBoxes: 100,
    numberOfPiecesInBox: 20,
    pickupOption: 'Own',
    shippingFrom: 'Kotkhai',
    shippingTo: 'Delhi',
    hasOwnCrates: true,
    status: 'In Transit',
    commissionAgent: availableAadhatis[0],
    driver: availableDrivingProfiles[0],
    corporateCompany: availableLadanis[0],
    packingHouse: availablePackHouses[0],
    createdAt: DateTime.now().subtract(Duration(days: 5)),
    updatedAt: DateTime.now(),
  ),
  Consignment(
    id: 'CONS002',
    quality: 'Standard',
    category: 'B',
    numberOfBoxes: 150,
    numberOfPiecesInBox: 18,
    pickupOption: 'Third Party',
    shippingFrom: 'Shimla',
    shippingTo: 'Mumbai',
    hasOwnCrates: false,
    status: 'Pending',
    commissionAgent: availableAadhatis[1],
    driver: availableDrivingProfiles[1],
    corporateCompany: availableLadanis[1],
    packingHouse: availablePackHouses[1],
    createdAt: DateTime.now().subtract(Duration(days: 2)),
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
    harvestStatus: HarvestStatus.planned,
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
    harvestStatus: HarvestStatus.planned,
    estimatedBoxes: 1200,
    createdAt: DateTime.now().subtract(Duration(days: 20)),
    updatedAt: DateTime.now(),
  ),
].obs;

RxList<PackHouse> availablePackHouses = [
  PackHouse(
    id: 'PACK001',
    name: 'Himalayan Packers',
    phoneNumber: '9876543211',
    address: 'Industrial Area, Shimla',
    gradingMachine: 'Automatic Grading System',
    sortingMachine: 'Color Sorting Machine',
    gradingMachineCapacity: '1000 boxes/hour',
    sortingMachineCapacity: '800 boxes/hour',
    machineManufacturer: 'AppleTech Industries',
    trayType: TrayType.bothSide,
    perDayCapacity: '5000 boxes',
    numberOfCrates: 2000,
    crateManufacture: 'Himalayan Crates',
    boxesPacked2023: 50000,
    boxesPacked2024: 60000,
    estimatedBoxes2025: 75000,
    geoLoaction: 'Shimla Industrial Area',
    numberOfGrowersServed: 50,
  ),
  PackHouse(
    id: 'PACK002',
    name: 'Kullu Packers',
    phoneNumber: '9876543212',
    address: 'Industrial Area, Kullu',
    gradingMachine: 'Semi-Automatic Grading System',
    sortingMachine: 'Weight Sorting Machine',
    gradingMachineCapacity: '800 boxes/hour',
    sortingMachineCapacity: '600 boxes/hour',
    machineManufacturer: 'FruitTech Solutions',
    trayType: TrayType.singleSide,
    perDayCapacity: '4000 boxes',
    numberOfCrates: 1500,
    crateManufacture: 'Kullu Crates',
    boxesPacked2023: 40000,
    boxesPacked2024: 45000,
    estimatedBoxes2025: 60000,
    geoLoaction: 'Kullu Industrial Area',
    numberOfGrowersServed: 35,
  ),
].obs;

RxList<Packer> availablePackers = [
  Packer(
    id: 'PACKER001',
    name: 'Himalayan Packers',
    phoneNumber: '9876543213',
  ),
  Packer(
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
  ),
  Transport(
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
