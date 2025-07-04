import 'dart:async';
import 'dart:convert';
import 'package:apple_grower/features/grower/grower_controller.dart';
import 'package:apple_grower/models/consignment_model.dart';
import 'package:apple_grower/models/transport_model.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../models/aadhati.dart';
import '../../../models/driving_profile_model.dart';
import '../../../models/pack_house_model.dart';
import '../../../models/bilty_model.dart';
import 'package:http/http.dart' as http;
import '../../../core/globals.dart' as glb;
import 'package:flutter/foundation.dart' show kIsWeb;

class ConsignmentFormController extends GetxController {
  Rx<Consignment?> consignment = Rx<Consignment?>(null);
  RxString driverMode = "Self".obs;
  RxString packHouseMode = "Self".obs;
  RxBool biltyValue = false.obs;
  RxString aadhatiMode = "Associated".obs;
  TextEditingController trip1AddressController = TextEditingController();
  TextEditingController trip2AddressController = TextEditingController();

  RxInt step = 0.obs;
  Rx<DrivingProfile?> drivingProfile = Rx<DrivingProfile?>(null);
  Rx<Transport?> transportUnion = Rx<Transport?>(null);
  Rx<Aadhati?> aadhati = Rx<Aadhati?>(null);
  Rx<PackHouse?> packhouse = Rx<PackHouse?>(null);
  Rx<Bilty?> bilty = Rx<Bilty?>(null);

  addStep() {
    step.value += 1;
  }

  groundState() {
    if (glb.roleType == "PackHouse") step.value == 1;
  }

  @override
  void onInit() {
    // TODO: implement onInit

    super.onInit();
    glb.loadIDData();
    loadConsignment();
  }

  loadConsignment() async {
    if (glb.consignmentID.value == "") {
      createConsignment();
    } else {
      String api =
          glb.url.value + "/api/consignment/${glb.consignmentID.value}";
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
            approval: json['approval'], approval1: json['approval1'],
            endPointAddressTrip2: json['endPointAddressTrip2'],
            currentStage: json['currentStage'],
            aadhatiId: json['aadhatiId'],
            totalWeight: json['totalWeight']?.toDouble(),
            status: json['status'],
            bilty: json['bilty'] != null ? Bilty.fromJson(json['bilty']) : null,
            aadhatiMode: json['aadhatiMode'],
            driverMode: json['driverMode'],
            packHouseMode:  json ['packHouseMode'],
            startTime: json['startTime'],
            date: json['date']
        );

        driverMode.value =consignment.value!.driverMode!;
        packHouseMode.value = consignment.value!.packHouseMode!;

        print(consignment.value?.currentStage);
        if(consignment.value?.currentStage=="Packing Requested"||consignment.value?.currentStage=="Packing Complete")
          {
            step.value = 1;
          }
        else if (consignment.value?.currentStage=="Bilty Ready"||consignment.value?.currentStage=="Aadhati Selection")
          {
            step.value = 3;
          }


        print(consignment.value!.bilty?.id);
      bilty.value = consignment.value!.bilty;
      }
    }
  }

  createConsignment() async {
    final personInitials = glb.personName.substring(0, 3).toUpperCase();
    final timeStamp = DateTime.now()
        .millisecondsSinceEpoch
        .toString()
        .substring(9, 13); // 4-digit slice of time
    final consignmentCount = Get.find<GrowerController>()
        .consignments
        .length
        .toString()
        .padLeft(2, '0');
    final aadharSuffix = glb.personPhone.substring(6, 10);
    final searchId =
        '$personInitials-$timeStamp-$consignmentCount-$aadharSuffix';
    print(searchId);

    print("Here goes Consignment");
    String api = glb.url.value + "/api/consignment";
    Map<String, dynamic> uploadData = {"searchId": searchId,"growerName": glb.personName.value};
    consignment.value = Consignment(searchId: searchId,growerName: glb.personName.value);

    final response = await http.post(Uri.parse(api),
        body: jsonEncode(uploadData),
        headers: {"Content-Type": "application/json"});

    if (response.statusCode == 200 || response.statusCode == 201) {
      Map<String, dynamic> data = jsonDecode(response.body);
      consignment.value?.id = data['_id'];
    }
    Get.find<GrowerController>().addConsignment(consignment.value!);
    print(consignment.value?.currentStage);
  }

  Future<dynamic> Step1() async {
    print(consignment.value!.id);
    String api = glb.url.value + "/api/consignment/${consignment.value!.id}";
    print("Hit ${packhouse.value?.id}");
    Map<String, dynamic> uploadData = {
      'startPointTrip1': glb.selectedOrchardAddress.value,
      'endPointTrip1': trip1AddressController.text,
      'trip1Driverid': (driverMode.value == "Associated")
          ? drivingProfile.value?.id
          : transportUnion.value?.id,
      'packhouseId': packhouse.value?.id,
      'packHouseMode': packHouseMode.value,
      'driverMode': driverMode.value
    };
    final respone = await http.patch(Uri.parse(api),
        body: jsonEncode(uploadData),
        headers: {"Content-Type": "application/json"});

    if (respone.statusCode == 201) {
      print("Sucess");
    }
  }


  updateBilty()
  async {
    String api = glb.url.value + "/api/bilty/${consignment.value!.bilty?.id}";
    Map<String, dynamic> data = bilty.value!.toJson();
    final respone = await http.put(Uri.parse(api),
        body: jsonEncode(data),
        headers: {"Content-Type": "application/json"});
  }



  Future<dynamic> Step3() async {

    print(consignment.value!.id);
    String api = glb.url.value +
        "/api/consignment/${consignment.value!.id}/add-bilty/step-3";
    print("Hit");
    Map<String, dynamic> uploadData = {
      'endPointTrip2': trip2AddressController.text,
      'trip2DriverId': (driverMode.value == "Associated")
          ? drivingProfile.value?.id
          : transportUnion.value?.id,
      'aadhatiId': aadhati.value?.id,
      'aadhatiMode': aadhatiMode.value,
      'driverMode': driverMode.value,
    };
    final respone = await http.patch(Uri.parse(api),
        body: jsonEncode(uploadData),
        headers: {"Content-Type": "application/json"});

    if (respone.statusCode == 201) {
      print("Sucess");
    }
  }

  Future<dynamic> Step2() async {
      print("Here");
      if(biltyValue.value){
      String api = glb.url.value + "/api/bilty";
      Map<String, dynamic> data = bilty.value!.toJson();
      final respone = await http.post(Uri.parse(api),
          body: jsonEncode(data),
          headers: {"Content-Type": "application/json"});
      Map<String, dynamic> data1 = jsonDecode(respone.body);
      print(data1);
      String api1 = glb.url.value +
          "/api/consignment/${consignment.value!.id}/add-bilty/step-2";
      Map<String, dynamic> data2 = {
        "bilty": data1["_id"],
        "currentStage": "Packing Complete"
      };
      final respone1 = await http.patch(Uri.parse(api1),
          headers: {"Content-Type": "application/json"},
          body: jsonEncode(data2));

      if (respone.statusCode == 201) {
        print("Sucess");

      }
biltyValue.value=false;    }else
  {
    updateBilty();
  }
  }

}
