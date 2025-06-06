import 'package:get/get.dart';
import '../models/commission_agent_model.dart';
import '../models/corporate_company_model.dart';
import '../models/grower_model.dart';
import '../models/orchard_model.dart';
import '../models/packing_house_status_model.dart';
import '../models/consignment_model.dart';

RxString roleType = "Grower".obs;
RxString personName = "Ram Singh".obs;
RxString personPhone = "+91 123567890".obs;
RxString personVillage = "Nangal Jarialan".obs;
RxString personPost = "247001".obs;
RxString personBank = "XXXX3312".obs;
RxString personIFSC = "CNRB0002452".obs;

// Global Grower instance
final Rx<Grower> globalGrower = Grower(
  id: '1',
  name: 'Demo Grower',
  phoneNumber: '1234567890',
  address: 'Demo Address',
  aadharNumber: '123456789012',
  pinCode: '171001',
  orchards: [
    Orchard(
      id: '1',
      name: 'Demo Orchard 1',
      location: 'Location 1',
      numberOfFruitingTrees: 100,
      expectedHarvestDate: DateTime.now().add(Duration(days: 30)),
      boundaryPoints: [],
      area: 5.2,
      boundaryImagePath: 'assets/orchards/main_orchard.png',
      harvestStatus: HarvestStatus.planned,
      estimatedBoxes: 2000,
      createdAt: DateTime.now().subtract(Duration(days: 30)),
      updatedAt: DateTime.now(),
    ),
    Orchard(
      id: '2',
      name: 'North Field',
      location: 'Kullu Valley',
      numberOfFruitingTrees: 300,
      expectedHarvestDate: DateTime.now().add(Duration(days: 45)),
      boundaryPoints: [],
      area: 3.8,
      boundaryImagePath: 'assets/orchards/north_field.png',
      harvestStatus: HarvestStatus.planned,
      estimatedBoxes: 1200,
      createdAt: DateTime.now().subtract(Duration(days: 20)),
      updatedAt: DateTime.now(),
    ),
  ],
  commissionAgents: [
    CommissionAgent(
      id: '1',
      name: 'Demo Adhani 1',
      phoneNumber: '9876543210',
      apmcMandi: 'APMC 1',
      address: 'Adhani Address 1',
      createdAt: DateTime.now().subtract(Duration(days: 30)),
      updatedAt: DateTime.now(),
    ),
    CommissionAgent(
      id: '2',
      name: 'Demo Adhani 2',
      phoneNumber: '9876543211',
      apmcMandi: 'APMC 2',
      address: 'Adhani Address 2',
      createdAt: DateTime.now().subtract(Duration(days: 25)),
      updatedAt: DateTime.now(),
    ),
  ],
  corporateCompanies: [
    CorporateCompany(
      id: '1',
      name: 'Demo Ladhani 1',
      phoneNumber: '9876543220',
      companyType: 'Private Limited',
      address: 'Ladhani Address 1',
      createdAt: DateTime.now().subtract(Duration(days: 30)),
      updatedAt: DateTime.now(),
    ),
    CorporateCompany(
      id: '2',
      name: 'Demo Ladhani 2',
      phoneNumber: '9876543221',
      companyType: 'Public Limited',
      address: 'Ladhani Address 2',
      createdAt: DateTime.now().subtract(Duration(days: 25)),
      updatedAt: DateTime.now(),
    ),
  ],
  packingHouses: [
    PackingHouse(
      id: '1',
      packingHouseName: 'Demo Packhouse 1',
      packingHousePhone: '9876543230',
      packingHouseAddress: 'Packhouse Address 1',
      type: PackingHouseType.own,
      createdAt: DateTime.now().subtract(Duration(days: 30)),
      updatedAt: DateTime.now(),
    ),
    PackingHouse(
      id: '2',
      packingHouseName: 'Demo Packhouse 2',
      packingHousePhone: '9876543231',
      packingHouseAddress: 'Packhouse Address 2',
      type: PackingHouseType.thirdParty,
      createdAt: DateTime.now().subtract(Duration(days: 30)),
      updatedAt: DateTime.now(),
    ),
  ],
  consignments: [],
  createdAt: DateTime.now().subtract(Duration(days: 30)),
  updatedAt: DateTime.now(),
).obs;

RxList<PackingHouse> availiablePackingHouse = [
  PackingHouse(
    id: '1',
    packingHouseName: 'Demo Packhouse 1',
    packingHousePhone: '9876543230',
    packingHouseAddress: 'Packhouse Address 1',
    type: PackingHouseType.own,
    createdAt: DateTime.now().subtract(Duration(days: 30)),
    updatedAt: DateTime.now(),
  ),
  PackingHouse(
    id: '2',
    packingHouseName: 'Demo Packhouse 2',
    packingHousePhone: '9876543231',
    packingHouseAddress: 'Packhouse Address 2',
    type: PackingHouseType.thirdParty,
    createdAt: DateTime.now().subtract(Duration(days: 30)),
    updatedAt: DateTime.now(),
  ),
  PackingHouse(
    id: '3',
    packingHouseName: 'Demo Packhouse 3',
    packingHousePhone: '9876543230',
    packingHouseAddress: 'Packhouse Address 3',
    type: PackingHouseType.own,
    createdAt: DateTime.now().subtract(Duration(days: 30)),
    updatedAt: DateTime.now(),
  ),
  PackingHouse(
    id: '4',
    packingHouseName: 'Demo Packhouse 4',
    packingHousePhone: '9876543231',
    packingHouseAddress: 'Packhouse Address 4',
    type: PackingHouseType.thirdParty,
    createdAt: DateTime.now().subtract(Duration(days: 30)),
    updatedAt: DateTime.now(),
  ),


].obs;



RxList <CorporateCompany> availiableLadhanis = [ CorporateCompany(
  id: '1',
  name: 'Demo Ladhani 1',
  phoneNumber: '9876543220',
  companyType: 'Private Limited',
  address: 'Ladhani Address 1',
  createdAt: DateTime.now().subtract(Duration(days: 30)),
  updatedAt: DateTime.now(),
),
  CorporateCompany(
    id: '2',
    name: 'Demo Ladhani 2',
    phoneNumber: '9876543221',
    companyType: 'Public Limited',
    address: 'Ladhani Address 2',
    createdAt: DateTime.now().subtract(Duration(days: 25)),
    updatedAt: DateTime.now(),
  ),
  CorporateCompany(
    id: '3',
    name: 'Demo Ladhani 3',
    phoneNumber: '9876543221',
    companyType: 'Public Limited',
    address: 'Ladhani Address 3',
    createdAt: DateTime.now().subtract(Duration(days: 25)),
    updatedAt: DateTime.now(),
  ),
  CorporateCompany(
    id: '4',
    name: 'Demo Ladhani 4',
    phoneNumber: '9876543221',
    companyType: 'Public Limited',
    address: 'Ladhani Address 4',
    createdAt: DateTime.now().subtract(Duration(days: 25)),
    updatedAt: DateTime.now(),
  ),

].obs;




RxList<CommissionAgent> aviliableAdhanis = [
  CommissionAgent(
    id: '1',
    name: 'Demo Adhani 1',
    phoneNumber: '9876543210',
    apmcMandi: 'APMC 1',
    address: 'Adhani Address 1',
    createdAt: DateTime.now().subtract(Duration(days: 30)),
    updatedAt: DateTime.now(),
  ),
  CommissionAgent(
    id: '2',
    name: 'Demo Adhani 2',
    phoneNumber: '9876543211',
    apmcMandi: 'APMC 2',
    address: 'Adhani Address 2',
    createdAt: DateTime.now().subtract(Duration(days: 25)),
    updatedAt: DateTime.now(),
  ),
  CommissionAgent(
    id: '3',
    name: 'Demo Adhani 3',
    phoneNumber: '9876543211',
    apmcMandi: 'APMC 3',
    address: 'Adhani Address 3',
    createdAt: DateTime.now().subtract(Duration(days: 25)),
    updatedAt: DateTime.now(),
  ),
  CommissionAgent(
    id: '4',
    name: 'Demo Adhani 4',
    phoneNumber: '9876543211',
    apmcMandi: 'APMC 4',
    address: 'Adhani Address 4',
    createdAt: DateTime.now().subtract(Duration(days: 25)),
    updatedAt: DateTime.now(),
  ),




].obs;

final List<Map<String, String>> dummyDrivers = [
  {'name': 'Rajesh Kumar', 'contact': '9876543210'},
  {'name': 'Suresh Singh', 'contact': '8765432109'},
  {'name': 'Amit Sharma', 'contact': '7654321098'},
].obs;

final List<Map<String, String>> dummyAdhanis = [
  {'name': 'Adhani A', 'contact': '9988776655', 'apmc': 'Delhi Mandi'},
  {'name': 'Adhani B', 'contact': '8877665544', 'apmc': 'Mumbai Mandi'},
].obs;

final List<Map<String, String>> dummyLadhanis = [
  {
    'name': 'Ladhani X',
    'contact': '7766554433',
    'company': 'Ladhani Logistics',
  },
  {
    'name': 'Ladhani Y',
    'contact': '6655443322',
    'company': 'Ladhani Transport',
  },
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
