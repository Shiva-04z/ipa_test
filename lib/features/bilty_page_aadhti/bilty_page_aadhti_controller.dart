import 'dart:convert';
import 'dart:io';

import 'package:apple_grower/models/consignment_model.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;

import '../../core/globals.dart' as glb;
import '../../models/bilty_model.dart';

class BiltyPageAadhtiController extends GetxController {
  Rx<Bilty?> bilty = Rx<Bilty?>(null);
  RxBool biltyValue = false.obs;
  Rx<Consignment?> consignment = Rx<Consignment?>(null);
  RxInt editingBoxIndex = (-1).obs;
  RxInt editingPriceIndex = (-1).obs;

  @override
  void onInit() {
    super.onInit();
    glb.loadIDData();
    loadConsignment();
  }

  void setEditingBoxIndex(int index) {
    editingBoxIndex.value = index;
  }

  void setEditingPriceIndex(int index) {
    editingPriceIndex.value = index;
  }

  loadConsignment() async {
    String api = glb.url.value + "/api/consignment/${glb.consignmentID.value}";
    final respone = await http.get(Uri.parse(api));
    if (respone.statusCode == 200) {
      final json = jsonDecode(respone.body);
      consignment.value = Consignment(
          id: json['_id'],
          growerId: json['growerId'],
          searchId: json['searchId'],
          growerName: json['growerName'],
          trip1Driverid: json['trip1Driverid'],
          startPointAddressTrip1: json['startPointAddressTrip1'],
          endPointAddressTrip1: json['endPointAddressTrip1'],
          packhouseId: json['packhouseId'],
          startPointAddressTrip2: json['startPointAddressTrip2'],
          trip2Driverid: json['trip2Driverid'],
          approval: json['approval'],
          approval1: json['approval1'],
          endPointAddressTrip2: json['endPointAddressTrip2'],
          currentStage: json['currentStage'],
          aadhatiId: json['aadhatiId'],
          totalWeight: json['totalWeight']?.toDouble(),
          status: json['status'],
          bilty: json['bilty'] != null ? Bilty.fromJson(json['bilty']) : null,
          aadhatiMode: json['aadhatiMode'],
          driverMode: json['driverMode'],
          packHouseMode: json['packHouseMode']);
      bilty.value = consignment.value!.bilty;

    }
  }

  updateBilty() async {

    print("here it is ${bilty.value?.categories.first.totalPrice}");
    print(bilty.value!);
    String api = glb.url.value + "/api/bilty/${consignment.value!.bilty?.id}";
    Map<String, dynamic> data = bilty.value!.toJson();
    print(data);
    final respone = await http.put(Uri.parse(api),
        body: jsonEncode(data), headers: {"Content-Type": "application/json"});
  }

  Future<dynamic> uploadBilty() async {
    print("Here");
    await updateBilty();
    print(glb.consignmentID.value);
    String api = glb.url.value +
        "/api/consignment/${glb.consignmentID.value}/add-bilty-aadhati";
    Map<String, dynamic> data = {
      "aadhatiId": glb.personName.value,
      "currentStage": "Bilty Ready"
    };
    final respone = await http.patch(Uri.parse(api),
        body: jsonEncode(data), headers: {"Content-Type": "application/json"});
  }

  Future<void> uploadImage(File image, int index) async {
    // Implement upload logic here if needed
  }

  Future<void> uploadVideo(File video) async {
    // Implement upload logic here if needed
  }
}
