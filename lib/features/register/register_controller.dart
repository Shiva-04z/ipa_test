import 'package:apple_grower/navigation/routes_constant.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import '../../models/grower_model.dart';
import '../../core/globals.dart' as glb;

class RegisterController extends GetxController {
  // Form controllers
  final nameController = TextEditingController();
  final villageController = TextEditingController();
  final aadharController = TextEditingController();
  final phoneController = TextEditingController();
  final addressController = TextEditingController();
  final pinCodeController = TextEditingController();

  // Observable variables
  RxString selectedRole = "Grower".obs;
  RxInt currentStep = 0.obs;
  RxBool isLoading = false.obs;
  RxString errorMessage = "".obs;

  // Form validation
  final formKey = GlobalKey<FormState>();

  // API endpoint
  final String apiUrl =
      "https://bml-m3ps.onrender.com/api/growers";

  // Available roles
  final List<String> availableRoles = [
    "Grower",
    "Driver",
    "PackHouse",
    "Commission Agent",
    "Transport Union",
    "Corporate Company",
    "FreightForwarder",
    "HPMC Depot",
    "Police Officer",
    "AMPCO Office",
    "HP Agri Board",
    "Ladani Buyers"
  ];

  @override
  void onClose() {
    nameController.dispose();
    villageController.dispose();
    aadharController.dispose();
    phoneController.dispose();
    addressController.dispose();
    pinCodeController.dispose();
    super.onClose();
  }

  void selectRole(String role) {
    selectedRole.value = role;
  }

  void nextStep() {
    if (validateCurrentStep()) {
      if (currentStep.value < getTotalSteps() - 1) {
        currentStep.value++;
        errorMessage.value = "";
      } else {
        registerUser();
      }
    }
  }

  void previousStep() {
    if (currentStep.value > 0) {
      currentStep.value--;
      errorMessage.value = "";
    }
  }

  bool validateCurrentStep() {
    switch (currentStep.value) {
      case 0: // Basic info
        if (nameController.text.trim().isEmpty) {
          errorMessage.value = "Please enter your name";
          return false;
        }
        if (villageController.text.trim().isEmpty) {
          errorMessage.value = "Please enter your village";
          return false;
        }
        if (aadharController.text.trim().isEmpty) {
          errorMessage.value = "Please enter your Aadhar number";
          return false;
        }
        if (aadharController.text.length != 12) {
          errorMessage.value = "Aadhar number must be 12 digits";
          return false;
        }
        break;
      case 1: // Contact info
        if (phoneController.text.trim().isEmpty) {
          errorMessage.value = "Please enter your phone number";
          return false;
        }
        if (phoneController.text.length != 10) {
          errorMessage.value = "Phone number must be 10 digits";
          return false;
        }
        if (addressController.text.trim().isEmpty) {
          errorMessage.value = "Please enter your address";
          return false;
        }
        if (pinCodeController.text.trim().isEmpty) {
          errorMessage.value = "Please enter your PIN code";
          return false;
        }
        if (pinCodeController.text.length != 6) {
          errorMessage.value = "PIN code must be 6 digits";
          return false;
        }
        break;
    }
    return true;
  }

  int getTotalSteps() {
    switch (selectedRole.value) {
      case "Grower":
        return 3; // Basic info, Contact info, Grower specific
      default:
        return 2; // Basic info, Contact info
    }
  }

  String getStepTitle(int step) {
    switch (step) {
      case 0:
        return "Basic Information";
      case 1:
        return "Contact Information";
      case 2:
        return "Grower Details";
      default:
        return "Step ${step + 1}";
    }
  }

  void registerUser() async {
    if (!validateCurrentStep()) return;

    isLoading.value = true;
    errorMessage.value = "";

    try {
      // Create user based on role
      switch (selectedRole.value) {
        case "Grower":
          await registerGrower();
          break;
        default:
          errorMessage.value =
              "Registration for ${selectedRole.value} is not implemented yet";
          break;
      }
    } catch (e) {
      errorMessage.value = "Registration failed: ${e.toString()}";
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> registerGrower() async {
    try {

      final Map<String, dynamic> requestBody = {
        "name": nameController.text.trim(),
        "aadhar": aadharController.text.trim(),
        "phoneNumber": phoneController.text.trim(),
        "address":
            "${villageController.text.trim()}, ${addressController.text.trim()}",
        "pinCode": pinCodeController.text.trim(),
        "orchard_IDs": [],
        "aadhati_IDs": [],
        "packhouse_IDs": [],
        "consignment_IDs": [],
        "freightForwarder_IDs": [],
        "driver_IDs": [],
        "transportUnion_IDs": [],
        "gallery":[]
      };

      final response = await http.post(
        Uri.parse(apiUrl),
        headers: {
          'Content-Type': 'application/json',
        },
        body: jsonEncode(requestBody),
      );

      if (response.statusCode == 201 || response.statusCode == 200) {
        // Success
        final responseData = jsonDecode(response.body);
        glb.id.value = responseData['_id'];
          print(glb.id.value);
        Get.snackbar(
          'Success',
          'Grower registered successfully!',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.green,
          colorText: Colors.white,
        );

        // Store the created grower data if needed
        // You might want to save the response data to local storage or global state

        Get.toNamed(RoutesConstant.grower);
      } else {
        // Handle different error status codes
        final errorData = jsonDecode(response.body);
        String errorMsg = "Registration failed";

        if (errorData != null && errorData['message'] != null) {
          errorMsg = errorData['message'];
        } else if (response.statusCode == 409) {
          errorMsg = "Aadhar number already exists";
        } else if (response.statusCode == 400) {
          errorMsg = "Invalid data provided";
        } else if (response.statusCode == 500) {
          errorMsg = "Server error. Please try again later";
        }

        errorMessage.value = errorMsg;
      }
    } catch (e) {
      if (e.toString().contains('SocketException') ||
          e.toString().contains('NetworkException')) {
        errorMessage.value =
            "Network error. Please check your internet connection";
      } else {
        errorMessage.value = "Registration failed: ${e.toString()}";
      }
    }
  }

  void clearForm() {
    nameController.clear();
    villageController.clear();
    aadharController.clear();
    phoneController.clear();
    addressController.clear();
    pinCodeController.clear();
    currentStep.value = 0;
    errorMessage.value = "";
  }
}
