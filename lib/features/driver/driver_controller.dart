import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../core/globalMethods.dart' as glbm;
import '../../core/globals.dart' as glb;
import '../../models/driving_profile_model.dart';
import '../../models/consignment_model.dart';
import '../../models/transport_model.dart';
import '../../models/grower_model.dart';
import '../../models/pack_house_model.dart';
import '../../models/ladani_model.dart';
import 'package:http/http.dart' as http;

class DriverController extends GetxController {
  // ==================== REACTIVE VARIABLES ====================
  final details = Rx<DrivingProfile>(DrivingProfile(
    id: '',
    name: '',
    contact: '',
    drivingLicenseNo: '',
    vehicleRegistrationNo: '',
    noOfTyres: 0,
  ));
  final associatedTransportUnions = <Transport>[].obs;
  final myJobs = <Consignment>[].obs;
  final associatedGrowers = <Grower>[].obs;
  final associatedPackhouses = <PackHouse>[].obs;
  final associatedBuyers = <Ladani>[].obs;

  // ==================== LIFECYCLE METHODS ====================
  @override
  void onInit() {
    super.onInit();
    loadData();
  }

  Future<void> loadData()
  async{
    String apiurl = glb.url + "/api/drivers/${glb.id.value}";
    final response = await http.get(Uri.parse(apiurl));
    if (response.statusCode == 200) {
      final Map<String, dynamic> data = jsonDecode(response.body);
      glb.personName.value = data['name'];
      glb.personPhone.value = "+91" + data['contact'];
      associatedGrowers.value = glbm.createGrowerListFromApi(data['grower_IDs']);
      associatedTransportUnions.value =glbm.createTransportListFromApi(data['transportUnion_IDs']);

    }}
  // ==================== JOB MANAGEMENT METHODS ====================
  void addConsignment(Consignment consignment) {
    if (!myJobs.any((c) => c.id == consignment.id)) {
      myJobs.add(consignment);
    }
  }

  void removeMyJob(String id) {
    myJobs.removeWhere((job) => job.id == id);
  }

  // ==================== TRANSPORT UNION MANAGEMENT METHODS ====================
  void addTransportUnion(Transport union) {
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
        glb.url + '/api/drivers/${glb.id.value}/add-transport-union';
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


  // ==================== GROWER MANAGEMENT METHODS ====================
  void addAssociatedGrower(Grower grower) {
    if (!associatedGrowers.any((g) => g.id == grower.id)) {
      associatedGrowers.add(grower);
    }
  }

  void removeAssociatedGrower(String id) {
    associatedGrowers.removeWhere((grower) => grower.id == id);
  }

  // ==================== PACKHOUSE MANAGEMENT METHODS ====================
  void addAssociatedPackhouse(PackHouse packhouse) {
    if (!associatedPackhouses.any((p) => p.id == packhouse.id)) {
      associatedPackhouses.add(packhouse);
    }
  }

  void removeAssociatedPackhouse(String id) {
    associatedPackhouses.removeWhere((packhouse) => packhouse.id == id);
  }

  // ==================== BUYER MANAGEMENT METHODS ====================
  void addAssociatedBuyer(Ladani buyer) {
    if (!associatedBuyers.any((b) => b.id == buyer.id)) {
      associatedBuyers.add(buyer);
    }
  }


  void removeAssociatedBuyer(String id) {
    associatedBuyers.removeWhere((buyer) => buyer.id == id);
  }
}
