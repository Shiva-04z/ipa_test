import 'dart:async';
import 'dart:convert';
import 'package:apple_grower/features/grower/grower_controller.dart';
import 'package:apple_grower/models/consignment_model.dart';
import 'package:apple_grower/models/transport_model.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:camera/camera.dart';
import 'package:video_player/video_player.dart';
import 'dart:io';
import '../../../models/aadhati.dart';
import '../../../models/driving_profile_model.dart';
import '../../../models/pack_house_model.dart';
import '../../../models/bilty_model.dart';
import 'package:http/http.dart' as http;
import '../../../core/globals.dart' as glb;
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:path_provider/path_provider.dart';

class ConsignmentFormController extends GetxController {

  Rx<Consignment?> consignment  =Rx<Consignment?>(null);
  RxString driverMode = "Self".obs;
  RxString  packHouseMode = "Self".obs;
  RxString aadhatiMode= "Associated".obs;
  TextEditingController trip1AddressController= TextEditingController();

  RxInt step = 0.obs;
  Rx<DrivingProfile?> drivingProfile = Rx<DrivingProfile?>(null);
  Rx<Transport?> transportUnion = Rx<Transport?>(null);
  Rx<Aadhati?> aadhati = Rx<Aadhati?>(null);
  Rx<PackHouse?> packhouse = Rx<PackHouse?>(null);
  Rx<Bilty?> bilty = Rx<Bilty?>(null);

  addStep()
  {
    step.value +=1;
  }

  groundState()
  {
    if(glb.roleType == "PackHouse")
      step.value==1;
  }



  @override
  void onInit() {
    // TODO: implement onInit
    final personInitials = glb.personName.substring(0, 3).toUpperCase();
    final timeStamp = DateTime.now().millisecondsSinceEpoch.toString().substring(9, 13); // 4-digit slice of time
    final consignmentCount = Get.find<GrowerController>().consignments.length.toString().padLeft(2, '0');
    final aadharSuffix = glb.personPhone.substring(5);
    final searchId = '$personInitials-$timeStamp-$consignmentCount-$aadharSuffix';
    super.onInit();
    loadConsignment();
    consignment.value =Consignment(searchId: searchId,);
  }
  loadConsignment()
  async {
    if(glb.consignmentID.value =="")
      {
        createConsignment();
      }
    else
      {
        String api = glb.url.value + "/api/consignmet/${glb.consignmentID.value}";
        final respone = await http.get(Uri.parse(api)
            );

        if(respone.statusCode ==200){
          Consignment.fromJson(jsonDecode(respone.body));

        }
  }}


 createConsignment() async {
    print("Here goes Consignment");
   String api = glb.url.value + "/api/consignmet";
   Map<String,dynamic> uploadData = {
     "searchId": consignment.value?.searchId
   };
   final response = await http.post(Uri.parse(api)
   ,body: jsonEncode(uploadData),headers: {"Content-Type": "application/json"});

   if(response.statusCode ==200||response.statusCode==201){
     Map<String,dynamic> data =  jsonDecode(response.body);
      consignment.value?.id = data['_id'];

   }
   Get.find<GrowerController>().addConsignment(consignment.value!);

  }



  Future<dynamic> Step1()
  async {
    String api = glb.url.value + "/api/consignmet/${consignment.value!.id!}";
    Map<String,dynamic> uploadData = {
      'startPointTrip1': glb.selectedOrchardAddress.value,
      'trip1Driverid': (driverMode.value=="Associated")?drivingProfile.value!.id:transportUnion.value!.id,
      'packhouseId': packhouse.value!.id,
      'packHouseMode' : packHouseMode.value,
      'driverMode' : driverMode.value
    };
    final respone = await http.patch(Uri.parse(api)
        ,body: uploadData,headers: {"Content-Type": "application-json"});

    if(respone.statusCode ==201){
      print("Sucess");

    }
  }

  Future<dynamic> Step2()
  async {
    String api = glb.url.value + "/api/bilty";
    Map<String,dynamic> data =bilty.value!.toJson();
    final respone = await http.post(Uri.parse(api)
        ,body: data,headers: {"Content-Type": "application-json"});
    Map<String,dynamic> data1 = jsonDecode(respone.body);
    String api1 = glb.url.value + "/api/consignment/${glb.consignmentID.value}";
    Map<String,dynamic> data2 = {
      "bilty": data1["_id"],
    };
    final respone1 = await http.patch(Uri.parse(api));


    if(respone.statusCode ==201){
      print("Sucess");

    }
  }


}
