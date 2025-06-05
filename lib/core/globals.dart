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
final Rx<Grower> globalGrower =
    Grower(
      id: '1',
      aadharNumber: '123456789012',
      name: 'John Doe',
      phoneNumber: '9876543210',
      address: '123 Apple Valley Road, Shimla',
      pinCode: '171001',
      orchards: [
        Orchard(
          id: '1',
          name: 'Main Orchard',
          location: 'Shimla Hills',
          numberOfFruitingTrees: 500,
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
          name: 'Rajesh Kumar',
          phoneNumber: '9876543211',
          apmcMandi: 'Shimla APMC',
          address: 'APMC Market, Shimla',
          createdAt: DateTime.now().subtract(Duration(days: 30)),
          updatedAt: DateTime.now(),
        ),
        CommissionAgent(
          id: '2',
          name: 'Suresh Verma',
          phoneNumber: '9876543212',
          apmcMandi: 'Kullu APMC',
          address: 'APMC Market, Kullu',
          createdAt: DateTime.now().subtract(Duration(days: 25)),
          updatedAt: DateTime.now(),
        ),
      ],
      corporateCompanies: [
        CorporateCompany(
          id: '1',
          name: 'Apple Corp Ltd',
          phoneNumber: '9876543213',
          address: 'Corporate Office, Delhi',
          companyType: 'Processor',
          createdAt: DateTime.now().subtract(Duration(days: 30)),
          updatedAt: DateTime.now(),
        ),
        CorporateCompany(
          id: '2',
          name: 'Himalayan Fruits',
          phoneNumber: '9876543214',
          address: 'Corporate Office, Chandigarh',
          companyType: 'Exporter',
          createdAt: DateTime.now().subtract(Duration(days: 25)),
          updatedAt: DateTime.now(),
        ),
      ],
      packingHouses: [
        PackingHouse(
          id: '1',
          type: PackingHouseType.own,
          packingHouseName: 'Doe Packing House',
          packingHouseAddress: '123 Packing Street, Shimla',
          packingHousePhone: '9876543215',
          createdAt: DateTime.now().subtract(Duration(days: 30)),
          updatedAt: DateTime.now(),
        ),
      ],
      consignments: [],
      createdAt: DateTime.now().subtract(Duration(days: 30)),
      updatedAt: DateTime.now(),
    ).obs;

// Dummy Data for support services (for testing/requesting support)
final List<Map<String, String>> dummyDrivers =
    [
      {'name': 'Rajesh Kumar', 'contact': '9876543210'},
      {'name': 'Suresh Singh', 'contact': '8765432109'},
      {'name': 'Amit Sharma', 'contact': '7654321098'},
    ].obs;

final List<Map<String, String>> dummyAdhanis =
    [
      {'name': 'Adhani A', 'contact': '9988776655', 'apmc': 'Delhi Mandi'},
      {'name': 'Adhani B', 'contact': '8877665544', 'apmc': 'Mumbai Mandi'},
    ].obs;

final List<Map<String, String>> dummyLadhanis =
    [
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
final List<Map<String, dynamic>> consignmentTableData =
    [
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
