import 'dart:convert';

import 'package:apple_grower/models/freightForwarder.dart';
import 'package:apple_grower/models/pack_house_model.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import '../../core/globalMethods.dart' as glbm;
import '../../core/globals.dart' as glb;
import '../../models/grower_model.dart';
import '../../models/ladani_model.dart';
import '../../models/driving_profile_model.dart';
import '../../models/consignment_model.dart';
import '../../models/transport_model.dart';
import '../../models/employee_model.dart';
import 'package:http/http.dart' as http;

class AadhatiController extends GetxController {
  // ==================== REACTIVE VARIABLES ====================
  final details = <String, String>{}.obs;
  final associatedGrowers = <Grower>[].obs;
  final associatedBuyers = <FreightForwarder>[].obs;
  final associatedLadanis = <Ladani>[].obs;
  final associatedDrivers = <DrivingProfile>[].obs;
  final consignments = <Consignment>[].obs;
  final galleryImages = <String>[].obs;
  final RxList<Transport> associatedTransportUnions = <Transport>[].obs;
  final RxList<PackHouse> associatedPackHouses = <PackHouse>[].obs;
  final RxMap<String, Employee> staff = <String, Employee>{}.obs;
  RxString key = "".obs;

  // Additional reactive variables for new fields
  final RxString aadhar = "".obs;
  final RxString apmc_ID = "".obs;
  final RxString address = "".obs;
  final RxString nameOfTradingFirm = "".obs;
  final RxInt tradingExperience = 0.obs;
  final RxString firmType = "".obs;
  final RxString licenceNumber = "".obs;
  final RxInt appleboxesT2 = 0.obs;
  final RxInt appleboxesT1 = 0.obs;
  final RxInt appleboxesT = 0.obs;
  final RxBool needTradeFinance = false.obs;
  final RxInt applegrowersServed = 0.obs;

  // ==================== LIFECYCLE METHODS ====================
  @override
  void onInit() {
    super.onInit();
    glb.roleType.value = "Aadhati";
    loadData();
  }

  Future<void> loadData() async {
    String apiurl = glb.url + "/api/agents/${glb.id.value}";
    final response = await http.get(Uri.parse(apiurl));
    if (response.statusCode == 200) {
      final Map<String, dynamic> data = jsonDecode(response.body);
      print(data.keys);

      // Basic information
      glb.personName.value = data['name'];
      glb.personPhone.value = "+91" + data['contact'];

      // Additional fields from mongoose schema
      details['aadhar'] = data['aadhar'] ?? '';
      details['apmc_ID'] = data['apmc_ID'] ?? '';
      details['address'] = data['address'] ?? '';
      details['nameOfTradingFirm'] = data['nameOfTradingFirm'] ?? '';
      details['tradingExperience'] =
          (data['tradingExperience'] ?? 0).toString();
      details['firmType'] = data['firmType'] ?? '';
      details['licenceNumber'] = data['licenceNumber'] ?? '';
      details['appleboxesT2'] = (data['appleboxesT2'] ?? 0).toString();
      details['appleboxesT1'] = (data['appleboxesT1'] ?? 0).toString();
      details['appleboxesT'] = (data['appleboxesT'] ?? 0).toString();
      details['needTradeFinance'] =
          (data['needTradeFinance'] ?? false).toString();
      details['applegrowersServed'] =
          (data['applegrowersServed'] ?? 0).toString();

      // Populate reactive variables
      aadhar.value = data['aadhar'] ?? '';
      apmc_ID.value = data['apmc_ID'] ?? '';
      address.value = data['address'] ?? '';
      nameOfTradingFirm.value = data['nameOfTradingFirm'] ?? '';
      tradingExperience.value = data['tradingExperience'] ?? 0;
      firmType.value = data['firmType'] ?? '';
      licenceNumber.value = data['licenceNumber'] ?? '';
      appleboxesT2.value = data['appleboxesT2'] ?? 0;
      appleboxesT1.value = data['appleboxesT1'] ?? 0;
      appleboxesT.value = data['appleboxesT'] ?? 0;
      needTradeFinance.value = data['needTradeFinance'] ?? false;
      applegrowersServed.value = data['applegrowersServed'] ?? 0;

      // Load associated entities
      associatedGrowers.value =
          glbm.createGrowerListFromApi(data['grower_IDs']);
      associatedBuyers.value =
          glbm.createFreightListFromApi(data['freightForwarder_IDs']);
      print(data['driver_IDs']);
      associatedDrivers.value =
          glbm.createDriverListFromApi(data['driver_IDs']);
      associatedLadanis.value = glbm.createLadaniListFromApi(data['buyer_IDs']);
      associatedTransportUnions.value =
          glbm.createTransportListFromApi(data['transportUnion_IDs']);
      associatedPackHouses.value =
          glbm.createPackhouseListFromApi(data['packhouse_IDs']);

      // Load consignments
      if (data['consignment_IDs'] != null) {
        // You might need to create a method to load consignments by IDs
        // consignments.value = glbm.createConsignmentListFromApi(data['consignment_IDs']);
      }

      // Load gallery images
      if (data['gallery'] != null) {
        final List<dynamic> galleryData = data['gallery'];
        galleryImages.value =
            galleryData.map((item) => item['url'] as String).toList();
      }

      // Load staff data
      if (data['staff'] != null) {
        final Map<String, dynamic> staffData = data['staff'];
        staff.value = staffData.map((key, value) {
          if (value is List && value.isNotEmpty) {
            // Handle the case where staff value is a list of employee IDs
            // You might need to fetch employee details separately
            return MapEntry(
                key, Employee(name: 'Unknown Employee')); // Placeholder
          } else {
            return MapEntry(
                key, Employee(name: 'Unknown Employee')); // Placeholder
          }
        });
      }
    }
  }

  // ==================== STAFF MANAGEMENT METHODS ====================
  void addStaff(Employee employee) {
    staff[key.value] = employee;
    print(
        'Added staff: ${key.value} - ${employee.name} - ${employee.phoneNumber}');
  }

  void removeStaff(String role) {
    staff.remove(role);
  }

  // ==================== GROWER MANAGEMENT METHODS ====================
  void addAssociatedGrower(Grower agent) {
    if (agent.id == null) {
      createGrower(agent);
    } else {
      associatedGrowers.add(agent);
      uploadGrower(agent.id!);
    }
  }

  void removeAssociatedGrower(String id) {
    associatedGrowers.removeWhere((grower) => grower.id == id);
  }

  Future<void> createGrower(Grower agent) async {
    String apiUrl = glb.url + '/api/growers';
    try {
      final Map<String, dynamic> body = {
        'name': agent.name,
        'phoneNumber': agent.phoneNumber,
      };

      final response = await http.post(
        Uri.parse(apiUrl),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(body),
      );
      if (response.statusCode == 201 || response.statusCode == 200) {
        final data = jsonDecode(response.body);
        associatedGrowers.add(agent);
        print(data["_id"]);
        await Future.delayed(Duration(seconds: 3));
        uploadGrower(data["_id"]);
        Get.snackbar('Success', 'Agent created successfully!',
            snackPosition: SnackPosition.BOTTOM);
      } else {
        Get.snackbar('Error', 'Failed to create agent: \n${response.body}',
            snackPosition: SnackPosition.BOTTOM);
      }
    } catch (e) {
      Get.snackbar('Error', 'Failed to create agent: $e',
          snackPosition: SnackPosition.BOTTOM);
    }
  }

  uploadGrower(String agentID) async {
    final String apiUrl = glb.url + '/api/agents/${glb.id.value}/add-grower';
    print(apiUrl);
    final Map<String, dynamic> updatePayload = {'growerId': agentID};
    try {
      final response = await http.patch(
        Uri.parse(apiUrl),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(updatePayload),
      );
      if (response.statusCode == 200) {
        print("Sucess");
        Get.snackbar('Success', 'Grower updated successfully!',
            snackPosition: SnackPosition.BOTTOM);
      } else {
        Get.snackbar('Error', 'Failed to update grower: ${response.statusCode}',
            snackPosition: SnackPosition.BOTTOM);
      }
    } catch (e) {
      Get.snackbar('Error', 'Failed to update grower: $e',
          snackPosition: SnackPosition.BOTTOM);
    }
  }
  // ==================== BUYER MANAGEMENT METHODS ====================

  void removeAssociatedBuyer(String id) {
    associatedBuyers.removeWhere((buyer) => buyer.id == id);
  }

  void addAssociatedBuyer(FreightForwarder forwarder) {
    if (forwarder.id == null) {
      createForwarder(forwarder);
    } else {
      uploadForwarder(forwarder.id!);
      associatedBuyers.add(forwarder);
    }
  }

  createForwarder(FreightForwarder forwarder) async {
    String apiUrl = glb.url + '/api/freightforwarders/create';
    try {
      final Map<String, dynamic> body = {
        'name': forwarder.name,
        'contact': forwarder.contact,
        'address': forwarder.address,
      };
      final response = await http.post(
        Uri.parse(apiUrl),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(body),
      );
      if (response.statusCode == 201 || response.statusCode == 200) {
        final data = jsonDecode(response.body);
        associatedBuyers.add(forwarder);
        print(data["_id"]);
        uploadForwarder(data["_id"]);
      } else {
        Get.snackbar('Error', 'Failed to create agent: \n${response.body}',
            snackPosition: SnackPosition.BOTTOM);
      }
    } catch (e) {
      Get.snackbar('Error', 'Failed to create agent: $e',
          snackPosition: SnackPosition.BOTTOM);
    }
  }

  uploadForwarder(String agentID) async {
    final String apiUrl =
        glb.url + '/api/agents/${glb.id.value}/add-freight-forwarder';
    print(apiUrl);

    final Map<String, dynamic> updatePayload = {'freightForwarderId': agentID};
    try {
      final response = await http.patch(
        Uri.parse(apiUrl),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(updatePayload),
      );
      if (response.statusCode == 200) {
        print("Sucess");
      } else {
        Get.snackbar('Error', 'Failed to update grower: ${response.statusCode}',
            snackPosition: SnackPosition.BOTTOM);
      }
    } catch (e) {
      Get.snackbar('Error', 'Failed to update grower: $e',
          snackPosition: SnackPosition.BOTTOM);
    }
  }

  // ==================== LADANI MANAGEMENT METHODS ====================
  void addAssociatedLadani(Ladani ladani) {
    if (ladani.id == null) {
      print(ladani);
      createLadani(ladani);
    } else {
      uploadLadani(ladani.id!);
      associatedLadanis.add(ladani);
    }
  }

  void removeAssociatedLadani(String id) {
    associatedLadanis.removeWhere((ladani) => ladani.id == id);
  }

  Future<void> createLadani(Ladani ladani) async {
    String apiUrl = glb.url + '/api/buyers';
    try {
      final response = await http.post(
        Uri.parse(apiUrl),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          "name": ladani.name,
          "contact": ladani.contact,
          "nameOfFirm": ladani.nameOfTradingFirm,
          "address": ladani.address
        }),
      );
      if (response.statusCode == 201 || response.statusCode == 200) {
        final data = jsonDecode(response.body);
        print(data);
        print(data['_id']);
        uploadLadani(data['_id']);
        associatedLadanis.add(ladani);
      } else {}
    } catch (e) {
      Get.snackbar('Error', 'Failed to create Driver: $e',
          snackPosition: SnackPosition.BOTTOM);
    }
  }

  void uploadLadani(String id) async {
    final String apiUrl = glb.url + '/api/agents/${glb.id.value}/add-ladani';
    print(apiUrl);
    final Map<String, dynamic> updatePayload = {'buyerID': id};
    try {
      final response = await http.patch(
        Uri.parse(apiUrl),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(updatePayload),
      );
      if (response.statusCode == 200) {
        print("Sucess");
        Get.snackbar('Success', 'Grower updated successfully!',
            snackPosition: SnackPosition.BOTTOM);
      } else {
        Get.snackbar('Error', 'Failed to update grower: ${response.statusCode}',
            snackPosition: SnackPosition.BOTTOM);
      }
    } catch (e) {
      Get.snackbar('Error', 'Failed to update grower: $e',
          snackPosition: SnackPosition.BOTTOM);
    }
  }

  // ==================== PACKHOUSE MANAGEMENT METHODS ====================

  void addAssociatedPackhouses(PackHouse house) {
    if (house.id != null) {
      associatedPackHouses.add(house);
      uploadPackHouse(house.id!);
    } else {
      createPackhouse(house);
    }
  }

  Future<void> createPackhouse(PackHouse packhouse) async {
    String apiUrl = glb.url + '/api/packhouse';
    try {
      final response = await http.post(
        Uri.parse(apiUrl),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(packhouse.toJson()),
      );
      if (response.statusCode == 201 || response.statusCode == 200) {
        final data = jsonDecode(response.body);
        Future.delayed(Duration(seconds: 3));
        uploadPackHouse(data['_id']);
        associatedPackHouses.add(packhouse);

        Get.snackbar('Success', 'Orchard created successfully!',
            snackPosition: SnackPosition.BOTTOM);
      } else {
        Get.snackbar('Error', 'Failed to create orchard: \n${response.body}',
            snackPosition: SnackPosition.BOTTOM);
      }
    } catch (e) {
      Get.snackbar('Error', 'Failed to create orchard: $e',
          snackPosition: SnackPosition.BOTTOM);
    }
  }

  uploadPackHouse(String houseId) async {
    final String apiUrl = glb.url + '/api/agents/${glb.id.value}/add-packhouse';
    print(apiUrl);
    final Map<String, dynamic> updatePayload = {'packhouseId': houseId};
    try {
      final response = await http.patch(
        Uri.parse(apiUrl),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(updatePayload),
      );
      if (response.statusCode == 200) {
        print("Sucess");
        Get.snackbar('Success', 'Grower updated successfully!',
            snackPosition: SnackPosition.BOTTOM);
      } else {
        Get.snackbar('Error', 'Failed to update grower: ${response.statusCode}',
            snackPosition: SnackPosition.BOTTOM);
      }
    } catch (e) {
      Get.snackbar('Error', 'Failed to update grower: $e',
          snackPosition: SnackPosition.BOTTOM);
    }
  }

  void removeAssociatedPackhouse(String id) {
    associatedPackHouses.removeWhere((ladani) => ladani.id == id);
  }

  // ==================== DRIVER MANAGEMENT METHODS ====================
  void addAssociatedDriver(DrivingProfile driver) {
    if (driver.id == null) {
      createDriver(driver);
    } else {
      uploadDriver(driver.id!);
      associatedDrivers.add(driver);
    }
  }

  void removeAssociatedDriver(String id) {
    associatedDrivers.removeWhere((driver) => driver.id == id);
  }

  Future<void> createDriver(DrivingProfile driver) async {
    String apiUrl = glb.url + '/api/drivers/create';
    try {
      final response = await http.post(
        Uri.parse(apiUrl),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({"name": driver.name, "contact": driver.contact}),
      );
      if (response.statusCode == 201 || response.statusCode == 200) {
        final data = jsonDecode(response.body)['data'];
        Future.delayed(Duration(seconds: 3));
        print(data['_id']);
        uploadDriver(data['_id']);
        associatedDrivers.add(driver);
      } else {}
    } catch (e) {
      Get.snackbar('Error', 'Failed to create Driver: $e',
          snackPosition: SnackPosition.BOTTOM);
    }
  }

  uploadDriver(String driverID) async {
    final String apiUrl = glb.url + '/api/agents/${glb.id.value}/add-driver';
    print(apiUrl);
    final Map<String, dynamic> updatePayload = {'driverId': driverID};
    try {
      final response = await http.patch(
        Uri.parse(apiUrl),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(updatePayload),
      );
      if (response.statusCode == 200) {
        print("Sucess");
        Get.snackbar('Success', 'Grower updated successfully!',
            snackPosition: SnackPosition.BOTTOM);
      } else {
        Get.snackbar('Error', 'Failed to update grower: ${response.statusCode}',
            snackPosition: SnackPosition.BOTTOM);
      }
    } catch (e) {
      Get.snackbar('Error', 'Failed to update grower: $e',
          snackPosition: SnackPosition.BOTTOM);
    }
  }

  // ==================== TRANSPORT UNION MANAGEMENT METHODS ====================
  void addAssociatedTransportUnion(Transport union) {
    if (union.id == null) {
      createTransportunion(union);
    } else {
      associatedTransportUnions.add(union);
      uploadTransport(union.id!);
    }
  }

  Future<void> createTransportunion(Transport union) async {
    String apiUrl = glb.url + '/api/transportunion/create';
    try {
      final Map<String, dynamic> body = {
        'name': union.name,
        'contact': union.contact,
        'address': union.address,
      };
      final response = await http.post(
        Uri.parse(apiUrl),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(body),
      );
      if (response.statusCode == 201 || response.statusCode == 200) {
        final data = jsonDecode(response.body);
        associatedTransportUnions.add(union);
        print(data["_id"]);
        uploadTransport(data["_id"]);
      } else {
        Get.snackbar('Error', 'Failed to create agent: \n${response.body}',
            snackPosition: SnackPosition.BOTTOM);
      }
    } catch (e) {
      Get.snackbar('Error', 'Failed to create agent: $e',
          snackPosition: SnackPosition.BOTTOM);
    }
  }

  uploadTransport(String agentID) async {
    final String apiUrl =
        glb.url + '/api/agents/${glb.id.value}/add-transport-union';
    print(apiUrl);

    final Map<String, dynamic> updatePayload = {'transportUnionId': agentID};
    try {
      final response = await http.patch(
        Uri.parse(apiUrl),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(updatePayload),
      );
      if (response.statusCode == 200) {
        print("Sucess");
      } else {
        Get.snackbar('Error', 'Failed to update grower: ${response.statusCode}',
            snackPosition: SnackPosition.BOTTOM);
      }
    } catch (e) {
      Get.snackbar('Error', 'Failed to update grower: $e',
          snackPosition: SnackPosition.BOTTOM);
    }
  }

  void removeAssociatedTransportUnion(String id) {
    associatedTransportUnions.removeWhere((tu) => tu.id == id);
  }

  // ==================== CONSIGNMENT MANAGEMENT METHODS ====================
  void addConsignment(Consignment consignment) {
    if (!consignments.any((c) => c.id == consignment.id)) {
      consignments.add(consignment);
    }
  }

  void addAssociatedConsignment(Consignment consignment) {
    if (!consignments.any((g) => g.id == consignment.id)) {
      consignments.add(consignment);
    }
  }

  void removeConsignment(String id) {
    consignments.removeWhere((consignment) => consignment.id == id);
  }

  // ==================== GALLERY MANAGEMENT METHODS ====================
  Future<void> pickAndUploadImage() async {
    final ImagePicker picker = ImagePicker();
    final XFile? image = await picker.pickImage(source: ImageSource.gallery);

    if (image != null) {
      // Here you would typically upload the image to your storage service
      // For now, we'll just add the local path to the gallery
      galleryImages.add(image.path);
    }
  }

  void removeGalleryImage(String imageUrl) {
    galleryImages.remove(imageUrl);
  }
}
