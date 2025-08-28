import 'dart:convert';
import 'dart:io';
import 'package:path/path.dart'; // for extension()
import 'package:apple_grower/models/consignment_model.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart';
import '../../core/globals.dart' as glb;
import '../../models/bilty_model.dart';


class BiltyPageController extends GetxController {
  Rx<Bilty?> bilty = Rx<Bilty?>(null);
  RxBool biltyValue = false.obs;
  Rx<Consignment?> consignment = Rx<Consignment?>(null);
  RxString imgUrl= "".obs;
  TextEditingController varietyController =TextEditingController();

  @override
  void onInit() {
    // TODO: implement onInit
    glb.loadIDData();
    super.onInit();
  }


  Bilty changeVariety(Bilty bilty, String text) {
    final updatedCategories = bilty.categories.map((category) {
      return category.copyWith(variety: text);
    }).toList();

    return bilty.copyWith(
      categories: updatedCategories,
      updatedAt: DateTime.now(),
    );
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
      "packhouseId": glb.packHouseName.value,
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

  Future<String> uploadImage(File image, int index) async {
    print("Uploading image...");

    final uri = Uri.parse('${glb.url.value}/api/bilty/upload'); // 👈 your backend endpoint

    final request = http.MultipartRequest('POST', uri);

    // Attach the image file
    request.files.add(
      await http.MultipartFile.fromPath(
        'file', // 👈 must match the field name in multer
        image.path,
        contentType: MediaType('image', extension(image.path).replaceFirst('.', '')),
      ),
    );

    try {
      final streamedResponse = await request.send();
      final response = await http.Response.fromStream(streamedResponse);

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        final imageUrl = data['url'];

        print('Image uploaded at index $index: $imageUrl');

        // Update the imagePath in your category
        final category = bilty.value!.categories[index];
     bilty.value!.categories[index] = category.copyWith(
          imagePath: imageUrl,
        );

    bilty.refresh();
        return imageUrl;
      } else {
        print('Failed to upload image: ${response.statusCode}');
        print('Response: ${response.body}');
      }
    } catch (e) {
      print('Error uploading image: $e');
    }

    return image.path; // fallback
  }

  // Placeholder for video upload

    Future<String> uploadVideo(File video) async {
      print("Uploading video...");

      final uri = Uri.parse('${glb.url.value}/api/bilty/upload'); // same backend endpoint

      final request = http.MultipartRequest('POST', uri);

      // Attach the video file
      request.files.add(
        await http.MultipartFile.fromPath(
          'file', // must match multer field name
          video.path,
          contentType: MediaType('video', extension(video.path).replaceFirst('.', '')),
        ),
      );

      try {
        final streamedResponse = await request.send();
        final response = await http.Response.fromStream(streamedResponse);

        if (response.statusCode == 200) {
          final data = json.decode(response.body);
          final videoUrl = data['url'];
         bilty.value = bilty.value?.copyWith(videoPath:videoUrl );
       bilty.refresh();
          return videoUrl;
        } else {
          print('Failed to upload video: ${response.statusCode}');
          print('Response: ${response.body}');
        }
      } catch (e) {
        print('Error uploading video: $e');
      }
      return video.path; // fallback
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
