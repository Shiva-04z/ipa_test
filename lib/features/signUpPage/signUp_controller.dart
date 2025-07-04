import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:apple_grower/core/globals.dart' as glb;
import 'package:http/http.dart' as http;

import 'package:apple_grower/navigation/routes_constant.dart';

class SignUpController extends GetxController{
  final phoneController = TextEditingController();
  final aadharController = TextEditingController();

  RxBool isLoading = false.obs;

  // Holds the currently selected role for sign-in
  RxString currentValue="Grower".obs;
  // List of available roles for the dropdown in the sign-in view
  List<DropdownMenuItem<String>> roles = [
    DropdownMenuItem(value: "Grower", child: Text("Grower")),
    DropdownMenuItem(value: "PackHouse", child: Text("PackHouse")),
    DropdownMenuItem(value: "Aadhati", child: Text("Aadhati")),
    DropdownMenuItem(value: "Ladani/Buyers", child: Text("Ladani/Buyers")),
    DropdownMenuItem(value: "Freight Forwarder", child: Text("Freight Forwarder")),
    DropdownMenuItem(value: "Driver", child: Text("Driver")),
    DropdownMenuItem(value: "Transport Union", child: Text("Transport Union")),
    DropdownMenuItem(value: "APMC Office", child: Text("APMC Office")),
    DropdownMenuItem(value: "HP Police", child: Text("HP Police")),
    DropdownMenuItem(value: "HPMC DEPOT", child: Text("HPMC DEPOT")),
  ];

  Future<void> signInWithApi() async {
    final String apiUrl = glb.url + "/api/user/fetch";
    final String phoneNo = phoneController.text.trim();
    final String aadharNo = aadharController.text.trim();
    final String role = currentValue.value;

    if (phoneNo.isEmpty || aadharNo.isEmpty) {
      Get.snackbar("Error", "Please enter both phone and Aadhaar number");
      return;
    }


    isLoading.value = true;
    try {
      final Map<String, dynamic> requestBody = {
        "aadharNo": aadharNo,
        "phoneNo": phoneNo,
        "role": role,
      };
      final response = await http.post(
        Uri.parse(apiUrl),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(requestBody),
      );
      if (response.statusCode == 200) {
        // Success: Parse user data and navigate
        final data = jsonDecode(response.body);

        glb.id.value = data['roledocID'];
        print("ID : ${glb.id.value}");
        glb.uploadIDData();
        print('Response Body : ${response.body}');
        // You can store user info in globals or session here
        Get.snackbar("Success", "Sign in successful!");
        // Navigate to the role's page
        navigateToRolePage();
      } else if (response.statusCode == 404) {
        Get.snackbar("Oops", "User not found!");
      } else {
        // Failure: Show error message
        final error = jsonDecode(response.body);
        Get.snackbar("Sign In Failed", error['message'] ?? "Unknown error");
      }
    } catch (e) {
      Get.snackbar("Error", "Network or server error: $e");
    } finally {
      isLoading.value = false;
    }
  }

  // Called when the user presses the Sign In button
  // This method sets the global role type and navigates to the corresponding role's main page
  void navigateToRolePage() {
    switch (currentValue.value) {
      case "Grower":
        glb.roleType.value = "Grower"; // Set global role type
        Get.toNamed(RoutesConstant.grower); // Navigate to Grower dashboard/page
        break;
      case "PackHouse":
        glb.roleType.value = "PackHouse";
        Get.toNamed(RoutesConstant.packHouse);
        break;
      case "Aadhati":
        glb.roleType.value = "Aadhati";
        Get.toNamed(RoutesConstant.aadhati);
        break;
      case "Ladani/Buyers":
        glb.roleType.value = "Ladani/Buyers";
        Get.toNamed(RoutesConstant.ladaniBuyers);
        break;
      case "Freight Forwarder":
        glb.roleType.value = "Freight Forwarder";
        Get.toNamed(RoutesConstant.freightForwarder);
        break;
      case "Driver":
        glb.roleType.value = "Driver";
        Get.toNamed(RoutesConstant.driver);
        break;
      case "Transport Union":
        glb.roleType.value = "Transport Union";
        Get.toNamed(RoutesConstant.transportUnion);
        break;
      case "APMC Office":
        glb.roleType.value = "APMC Office";
        Get.toNamed(RoutesConstant.apmcOffice);
        break;
      case "HP Police":
        glb.roleType.value = "HP Police";
        Get.toNamed(RoutesConstant.hpPolice);
        break;
      case "HPMC DEPOT":
        glb.roleType.value = "HPMC DEPOT";
        Get.toNamed(RoutesConstant.hpAgriBoard);
        break;
      default:
        // Show error if role is not recognized
        Get.snackbar("Error", "Invalid role selected");
    }
  }

}