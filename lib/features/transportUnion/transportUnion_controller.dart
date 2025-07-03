import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../core/globalMethods.dart' as glbm;
import '../../core/global_role_loader.dart' as gld;
import '../../core/globals.dart' as glb;
import '../../models/transport_model.dart';
import '../../models/grower_model.dart';
import '../../models/driving_profile_model.dart';
import '../../models/aadhati.dart';
import '../../models/freightForwarder.dart';
import '../../models/consignment_model.dart';

class TransportUnionController extends GetxController {
  // ==================== REACTIVE VARIABLES ====================
  RxString unionName = ''.obs;
  RxString registrationNumber = ''.obs;
  final Map details = {
    'HCV': '',
    'MCV': '',
    'LCV': '',
    'Vehicles': '',
    'Boxes 2023': '',
    'Boxes 2024': '',
    'Drivers': '',
  }.obs;
  final associatedDrivers = <DrivingProfile>[].obs;
  final associatedGrowers = <Grower>[].obs;
  final associatedAadhatis = <Aadhati>[].obs;
  final associatedFreightForwarders = <FreightForwarder>[].obs;
  final consignments = <Consignment>[].obs;

  // ==================== LIFECYCLE METHODS ====================
  @override
  void onInit() {
    super.onInit();
    glb.loadIDData();
    glb.roleType.value = "Transport Union";
    loadData();
  }

  // ==================== DATA LOADING METHODS ====================
  Future<void> loadData() async {
    String apiurl = glb.url + "/api/transportunion/${glb.id.value}";
    final response = await http.get(Uri.parse(apiurl));
    if (response.statusCode == 200) {
      final Map<String, dynamic> data = jsonDecode(response.body)['data'];
      glb.personName.value = data['operatorName'];
      glb.personPhone.value = "+91" + data['contact'];
      associatedGrowers.value = glbm.createGrowerListFromApi(data['grower_IDs']);
      associatedDrivers.value = glbm.createDriverListFromApi(data['drivers_IDs']);
      associatedAadhatis.value = glbm.createAadhatiListFromApi(data['aadhati_IDs']);
      associatedFreightForwarders.value = glbm.createFreightListFromApi(data['freightForwarder_IDs']);
      unionName.value = data['name'] ?? '';
      registrationNumber.value = data['transportUnionRegistrationNo'].toString() ?? '';
      details['Name'] = unionName.value;
      details['Contact'] = glb.personPhone.value;
      details['Address'] = data['address'] ?? '';
      details['Vehicle Registered'] = data['noOfVehiclesRegistered'].toString() ?? '';
      // details['Vehicle Type'] = data['vehicleType'] ?? '';
      details['HCVs'] = data['noOfHeavyCommercialVehicles']?.toString() ?? '';
      details['LCVs'] = data['noOfLightCommercialVehicles']?.toString() ?? '';
      details['MCVs'] = data['noOfMediumCommercialVehicles']?.toString() ?? '';
      // details['State Permit'] = data['statePermit'] ?? '';
      details['Boxes Transported T-2'] = data['appleBoxesTransported2023']?.toString() ?? '';
      details['Boxes Transported T-1'] = data['appleBoxesTransported2024']?.toString() ?? '';
      details['Boxes Transported T'] = data['estimatedTarget2025']?.toString() ?? '';
      details['States Driven Through'] = data['statesDrivenThrough'] ?? '';
    }
  }

  // ==================== DRIVER MANAGEMENT METHODS ====================
  void addAssociatedDrivers(DrivingProfile driver) {
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
    final String apiUrl =
        glb.url + '/api/transportunion/${glb.id.value}/add-driver';
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
    final String apiUrl =
        glb.url + '/api/transportunion/${glb.id.value}/add-grower';
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
  void addAssociatedAadhatis(Aadhati agent) {
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
        glb.url + '/api/transportunion/${glb.id.value}/add-commission-agent';
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

  // ==================== FREIGHT FORWARDER MANAGEMENT METHODS ====================
  void addAssociatedBuyers(FreightForwarder forwarder) {
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
        glb.url + '/api/transportunion/${glb.id.value}/add-freight-forwarder';
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

  // ==================== CONSIGNMENT MANAGEMENT METHODS ====================
  void addConsignments(Consignment consignment) {
    if (!consignments.any((g) => g.id == consignment.id)) {
      consignments.add(consignment);
    }
  }
}
