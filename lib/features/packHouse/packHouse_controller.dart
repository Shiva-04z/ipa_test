import 'dart:convert';

import 'package:apple_grower/models/employee_model.dart';
import 'package:apple_grower/models/freightForwarder.dart';
import 'package:apple_grower/models/transport_model.dart';
import 'package:get/get.dart';
import '../../core/globals.dart' as glb;
import '../../models/hpmc_collection_center_model.dart';
import '../../models/pack_house_model.dart';
import '../../models/grower_model.dart';
import '../../models/aadhati.dart';
import '../../models/ladani_model.dart';
import '../../models/driving_profile_model.dart';
import '../../models/consignment_model.dart';
import '../../core/global_role_loader.dart' as gld;
import 'package:image_picker/image_picker.dart';
import 'package:http/http.dart' as http;
import '../../core/globalMethods.dart' as glbm;

class PackHouseController extends GetxController {
  // ==================== REACTIVE VARIABLES ====================
  final RxList<Grower> associatedGrowers = <Grower>[].obs;
  final RxList<Aadhati> associatedAadhatis = <Aadhati>[].obs;
  final RxList<Ladani> associatedLadanis = <Ladani>[].obs;
  final RxList<Employee> associatedPackers = <Employee>[].obs;
  final RxList<DrivingProfile> associatedDrivers = <DrivingProfile>[].obs;
  final RxList<dynamic> associatedFreightForwarders = <dynamic>[].obs;
  final RxList<dynamic> associatedTransportUnions = <dynamic>[].obs;
  final RxList<Consignment> consignments = <Consignment>[].obs;
  final RxList<String> galleryImages = <String>[].obs;
  RxList<HpmcCollectionCenter> hpmcDepots = <HpmcCollectionCenter>[].obs;

  // ==================== STATIC DATA ====================
  String name = gld.packHouse.value.name;
  final Map details = {
    'Grading Machine': '${gld.packHouse.value.gradingMachineCapacity}',
    'Sorting Machine': '${gld.packHouse.value.sortingMachineCapacity}',
    'Daily Capacity': '${gld.packHouse.value.perDayCapacity}',
    'Crates': '${gld.packHouse.value.numberOfCrates}',
    'Boxes 2023': '${gld.packHouse.value.boxesPacked2023}',
    'Boxes 2024': '${gld.packHouse.value.boxesPacked2024}',
    'Boxes 2025': '${gld.packHouse.value.estimatedBoxes2025}',
  }.obs;

  // ==================== LIFECYCLE METHODS ====================
  @override
  void onInit() {
    super.onInit();
    glb.roleType.value = "PackHouse";
    loadData();
  }

  Future<void> loadData()   
  async{
    String apiurl = glb.url + "/api/packhouse/${glb.id.value}";
    final response = await http.get(Uri.parse(apiurl));
    if (response.statusCode == 200) {
      final Map<String, dynamic> data = jsonDecode(response.body);
      glb.personName.value = data['name'];
      glb.personPhone.value = "+91" + data['phoneNumber'];
      associatedGrowers.value = glbm.createGrowerListFromApi(data['grower_IDs']);
      associatedFreightForwarders.value =glbm.createFreightListFromApi(data['freightForwarder_IDs']);
      associatedDrivers.value =glbm.createDriverListFromApi(data['driver_IDs']);
      associatedAadhatis.value =glbm.createAadhatiListFromApi(data['aadhati_IDs']);
      associatedTransportUnions.value =glbm.createTransportListFromApi(data['transportUnion_IDs']);
      hpmcDepots.value=glbm.createHPMCListFromApi(data['hpmcDepot_IDs']);
      associatedPackers.value =glbm.createEmployeeListFromApi(data['packhouse_IDs']);
  }}


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
    final String apiUrl = glb.url + '/api/packhouse/${glb.id.value}/add-grower';
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

  // ==================== AADHATI MANAGEMENT METHODS ====================
  void addAssociatedAadhati(Aadhati agent) {
    if (agent.id == null) {
      createAgent(agent);
    } else {
      associatedAadhatis.add(agent);
      uploadAgent(agent.id!);
    }
  }


  Future<void> createAgent(Aadhati agent) async {
    String apiUrl = glb.url + '/api/agents';
    try {
      final Map<String, dynamic> body = {
        'name': agent.name,
        'contact': agent.contact,
        'apmc_ID': agent.apmc,
      };

      final response = await http.post(
        Uri.parse(apiUrl),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(body),
      );
      if (response.statusCode == 201 || response.statusCode == 200) {
        final data = jsonDecode(response.body);
        associatedAadhatis.add(agent);
        print(data["_id"]);
        await Future.delayed(Duration(seconds: 3));
        uploadAgent(data["_id"]);
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

  uploadAgent(String agentID) async {
    final String apiUrl =
        glb.url + '/api/packhouse/${glb.id.value}/add-commission-agent';
    print(apiUrl);
    final Map<String, dynamic> updatePayload = {'commissionAgentId': agentID};
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

  void removeAssociatedAadhati(String id) {
    associatedAadhatis.removeWhere((aadhati) => aadhati.id == id);
  }

  // ==================== LADANI MANAGEMENT METHODS ====================
  void addAssociatedLadani(Ladani ladani) {
    if (ladani.id == null) {
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
        body: jsonEncode({"name": ladani.name, "contact": ladani.contact}),
      );
      if (response.statusCode == 201 || response.statusCode == 200) {
        final data = jsonDecode(response.body)['data'];
        Future.delayed(Duration(seconds: 3));
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
    final String apiUrl = glb.url + '/api/packhouse/${glb.id.value}/add-ladani';
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

  // ==================== PACKER MANAGEMENT METHODS ====================
  void addAssociatedPacker(Employee packer) {
    if (!associatedPackers.any((p) => p.id == packer.id)) {
      associatedPackers.add(packer);
    }
  }

  Future<void> createPacker(Employee packer) async {
    String apiUrl = glb.url + '/api/employee';
    try {
      final response = await http.post(
        Uri.parse(apiUrl),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({"name": packer.name, "phoneNumber": packer.phoneNumber}),
      );
      if (response.statusCode == 201 || response.statusCode == 200) {
        final data = jsonDecode(response.body)['data'];
        Future.delayed(Duration(seconds: 3));
        print(data['_id']);
        uploadPacker(data['_id']);
        associatedPackers.add(packer);
      } else {}
    } catch (e) {
      Get.snackbar('Error', 'Failed to create Driver: $e',
          snackPosition: SnackPosition.BOTTOM);
    }
  }

  void uploadPacker(String id) async {
    final String apiUrl = glb.url + '/api/packhouse/${glb.id.value}/add-employee';
    print(apiUrl);
    final Map<String, dynamic> updatePayload = {'employeeID': id};
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

  void removeAssociatedPacker(String id) {
    associatedPackers.removeWhere((packer) => packer.id == id);
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
    final String apiUrl = glb.url + '/api/packhouse/${glb.id.value}/add-driver';
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

  // ==================== FREIGHT FORWARDER MANAGEMENT METHODS ====================
  void addAssociatedFreightForwarder(FreightForwarder forwarder) {
    if (forwarder.id == null) {
      createForwarder(forwarder);
    } else {
      uploadForwarder(forwarder.id!);
      associatedFreightForwarders.add(forwarder);
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
        associatedFreightForwarders.add(forwarder);
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
        glb.url + '/api/packhouse/${glb.id.value}/add-freight-forwarder';
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

  void removeAssociatedFreightForwarder(String id) {
    associatedFreightForwarders.removeWhere((ff) => ff.id == id);
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
        glb.url + '/api/packhouse/${glb.id.value}/add-transport-union';
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

  // ==================== HPMC DEPOT MANAGEMENT METHODS ====================
  void addHpmc(HpmcCollectionCenter hpmc) {
    if (hpmc.id == null) {
      createHpmc(hpmc);
    } else {
      hpmcDepots.add(hpmc);
      uploadHPMC(hpmc.id!);
    }
  }

  void removeHpmc(String id) {
    hpmcDepots.removeWhere((f) => f.id == id);
  }

  createHpmc(HpmcCollectionCenter hpmc) async {
    String apiUrl = glb.url + '/api/hpmcDepot/create';
    try {
      final Map<String, dynamic> body = {
        'hpmcname': hpmc.HPMCname,
        'operatorname': hpmc.operatorName,
        'cellNo': hpmc.cellNo,
        'location': hpmc.location,
      };
      final response = await http.post(
        Uri.parse(apiUrl),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(body),
      );
      if (response.statusCode == 201 || response.statusCode == 200) {
        final data = jsonDecode(response.body);
        hpmcDepots.add(hpmc);
        print(data["_id"]);
        uploadHPMC(data['_id']);

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

  uploadHPMC(String agentID) async {
    final String apiUrl =
        glb.url + '/api/packhouse/${glb.id.value}/add-hpmc-depot';
    print(apiUrl);

    final Map<String, dynamic> updatePayload = {'hpmcDepotId': agentID};
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

  // ==================== GALLERY MANAGEMENT METHODS ====================
  Future<void> pickAndUploadImage() async {
    final ImagePicker picker = ImagePicker();
    final XFile? image = await picker.pickImage(source: ImageSource.gallery);
    if (image != null) {
      // Here you would typically upload the image to your storage
      // For now, we'll just add the path to the list
      galleryImages.add(image.path);
    }
  }

  void removeGalleryImage(String imageUrl) {
    galleryImages.remove(imageUrl);
  }
}
