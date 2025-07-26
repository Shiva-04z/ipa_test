import 'dart:convert';
import 'dart:io';

import 'package:apple_grower/models/consignment_model.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;

import '../../core/globals.dart' as glb;
import '../../models/bilty_model.dart';

class BiltyPageController extends GetxController {
  Rx<Bilty?> bilty = Rx<Bilty?>(null);
  RxBool biltyValue = false.obs;
  Rx<Consignment?> consignment = Rx<Consignment?>(null);

  @override
  void onInit() {
    // TODO: implement onInit
    glb.loadIDData();

    super.onInit();
  }

  Future<dynamic> uploadBilty() async {
    String api = glb.url.value + "/api/bilty";
    Map<String, dynamic> data = bilty.value!.toJson();
    final respone = await http.post(Uri.parse(api),
        body: jsonEncode(data), headers: {"Content-Type": "application/json"});
    Map<String, dynamic> data1 = jsonDecode(respone.body);
    print(glb.consignmentID.value);
    String api1 = glb.url.value +
        "/api/consignment/${glb.consignmentID.value}/add-bilty-packhouse";
    Map<String, dynamic> data2 = {
      "packhouseId": glb.id.value,
      "bilty": data1["_id"],
      "currentStage": "Packing Complete"
    };
    print("Added Bilty");
    final respone1 = await http.patch(Uri.parse(api1),
        headers: {"Content-Type": "application/json"}, body: jsonEncode(data2));

    if (respone.statusCode == 201) {
      print("Sucess");
    }
  }

  Future<void> uploadImage(File image, int index) async {
    // TODO: Implement upload logic here
  }

  // Placeholder for video upload
  Future<void> uploadVideo(File video) async {
    // TODO: Implement upload logic here
  }

  void updateBiltyTotals() {
    if (bilty.value == null) return;
    final categories = bilty.value!.categories;
    final totalBoxes = categories.fold<int>(0, (sum, c) => sum + c.boxCount);
    final totalWeight =
        categories.fold<double>(0, (sum, c) => sum + c.totalWeight);
    final totalValue =
        categories.fold<double>(0, (sum, c) => sum + c.totalPrice);
    bilty.value = bilty.value!.copyWith(
      totalBoxes: totalBoxes.toDouble(),
      totalWeight: totalWeight,
      totalValue: totalValue,
    );
  }
}
