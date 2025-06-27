import 'package:apple_grower/navigation/routes_constant.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import '../../models/grower_model.dart';
import '../../core/globals.dart' as glb;

class RegisterController extends GetxController {
  // Form controllers for basic info
  final nameController = TextEditingController();
  final villageController = TextEditingController();
  final aadharController = TextEditingController();
  final phoneController = TextEditingController();
  final addressController = TextEditingController();
  final pinCodeController = TextEditingController();

  // Form controllers for aadhati specific fields
  final apmc_IDController = TextEditingController();
  final nameOfTradingFirmController = TextEditingController();
  final tradingExperienceController = TextEditingController();
  final firmTypeController = TextEditingController();
  final licenceNumberController = TextEditingController();
  final appleboxesT2Controller = TextEditingController();
  final appleboxesT1Controller = TextEditingController();
  final appleboxesTController = TextEditingController();
  final applegrowersServedController = TextEditingController();

  // PackHouse specific controllers
  final gradingMachineController = TextEditingController();
  final sortingMachineController = TextEditingController();
  final gradingMachineCapacityController = TextEditingController();
  final sortingMachineCapacityController = TextEditingController();
  final machineManufactureController = TextEditingController();
  final trayTypeController = TextEditingController();
  final perDayCapacityController = TextEditingController();
  final numberOfCratesController = TextEditingController();
  final crateManufactureController = TextEditingController();
  final boxesPackedT2Controller = TextEditingController();
  final boxesPackedT1Controller = TextEditingController();
  final boxesEstimatedTController = TextEditingController();
  final geoLocationController = TextEditingController();
  final numberOfGrowersServedController = TextEditingController();

  // Transport Union specific controllers
  final transportUnionNameController = TextEditingController();
  final transportUnionContactController = TextEditingController();
  final transportUnionAddressController = TextEditingController();
  final nameOfTheTransportUnionController = TextEditingController();
  final transportUnionRegistrationNoController = TextEditingController();
  final noOfVehiclesRegisteredController = TextEditingController();
  final transportUnionPresidentAdharIdController = TextEditingController();
  final transportUnionSecretaryAdharController = TextEditingController();
  final noOfLightCommercialVehiclesController = TextEditingController();
  final noOfMediumCommercialVehiclesController = TextEditingController();
  final noOfHeavyCommercialVehiclesController = TextEditingController();
  final appleBoxesTransported2023Controller = TextEditingController();
  final appleBoxesTransported2024Controller = TextEditingController();
  final estimatedTarget2025Controller = TextEditingController();
  final statesDrivenThroughController = TextEditingController();

  // Ladani (Corporate Company/Buyer) specific controllers
  final ladaniNameController = TextEditingController();
  final ladaniContactController = TextEditingController();
  final ladaniAddressController = TextEditingController();
  final nameOfTradingFirmLadaniController = TextEditingController();
  final tradingSinceYearsController = TextEditingController();
  final firmTypeLadaniController = TextEditingController();
  final licenseNoController = TextEditingController();
  final purchaseLocationAddressController = TextEditingController();
  final licensesIssuingAPMCController = TextEditingController();
  final locationOnGoogleController = TextEditingController();
  final appleBoxesPurchased2023Controller = TextEditingController();
  final appleBoxesPurchased2024Controller = TextEditingController();
  final estimatedTarget2025LadaniController = TextEditingController();
  final perBoxExpensesAfterBiddingController = TextEditingController();

  // Driver specific controllers
  final driverNameController = TextEditingController();
  final driverContactController = TextEditingController();
  final drivingLicenseNoController = TextEditingController();
  final vehicleRegistrationNoController = TextEditingController();
  final chassiNoOfVehicleController = TextEditingController();
  final payloadCapacityApprovedByRtoController = TextEditingController();
  final grossVehicleWeightController = TextEditingController();
  final noOfTyresController = TextEditingController();
  final permitOfVehicleDrivingController = TextEditingController();
  final vehicleOwnerAdharGstController = TextEditingController();
  final appleBoxesTransported2023DriverController = TextEditingController();
  final appleBoxesTransported2024DriverController = TextEditingController();
  final estimatedTarget2025DriverController = TextEditingController();
  final statesDrivenThroughDriverController = TextEditingController();

  // HPMC Depot specific controllers
  final hpmcNameController = TextEditingController();
  final operatorNameController = TextEditingController();
  final cellNoController = TextEditingController();
  final aadharNoController = TextEditingController();
  final licenseNoHpmcController = TextEditingController();
  final operatingSinceController = TextEditingController();
  final locationHpmcController = TextEditingController();
  final boxesTransported2023Controller = TextEditingController();
  final boxesTransported2024Controller = TextEditingController();
  final target2025Controller = TextEditingController();

  // Observable variables
  RxString selectedRole = "Grower".obs;
  RxInt currentStep = 0.obs;
  RxBool isLoading = false.obs;
  RxString errorMessage = "".obs;
  RxBool needTradeFinance = false.obs;

  // Form validation
  final formKey = GlobalKey<FormState>();

  // API endpoint
  final String apiUrl = glb.url + "/api/growers";
  final String aadhatiApiUrl = glb.url + "/api/agents";

  // Available roles
  final List<String> availableRoles = [
    "Grower",
    "Aadhati",
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

  // Firm types for aadhati
  final List<String> firmTypes = [
    "Prop. / Partnership",
    "HUF",
    "PL",
    "LLP",
    "OPC"
  ];

  @override
  void onClose() {
    nameController.dispose();
    villageController.dispose();
    aadharController.dispose();
    phoneController.dispose();
    addressController.dispose();
    pinCodeController.dispose();
    apmc_IDController.dispose();
    nameOfTradingFirmController.dispose();
    tradingExperienceController.dispose();
    firmTypeController.dispose();
    licenceNumberController.dispose();
    appleboxesT2Controller.dispose();
    appleboxesT1Controller.dispose();
    appleboxesTController.dispose();
    applegrowersServedController.dispose();
    gradingMachineController.dispose();
    sortingMachineController.dispose();
    gradingMachineCapacityController.dispose();
    sortingMachineCapacityController.dispose();
    machineManufactureController.dispose();
    trayTypeController.dispose();
    perDayCapacityController.dispose();
    numberOfCratesController.dispose();
    crateManufactureController.dispose();
    boxesPackedT2Controller.dispose();
    boxesPackedT1Controller.dispose();
    boxesEstimatedTController.dispose();
    geoLocationController.dispose();
    numberOfGrowersServedController.dispose();
    transportUnionNameController.dispose();
    transportUnionContactController.dispose();
    transportUnionAddressController.dispose();
    nameOfTheTransportUnionController.dispose();
    transportUnionRegistrationNoController.dispose();
    noOfVehiclesRegisteredController.dispose();
    transportUnionPresidentAdharIdController.dispose();
    transportUnionSecretaryAdharController.dispose();
    noOfLightCommercialVehiclesController.dispose();
    noOfMediumCommercialVehiclesController.dispose();
    noOfHeavyCommercialVehiclesController.dispose();
    appleBoxesTransported2023Controller.dispose();
    appleBoxesTransported2024Controller.dispose();
    estimatedTarget2025Controller.dispose();
    statesDrivenThroughController.dispose();
    ladaniNameController.dispose();
    ladaniContactController.dispose();
    ladaniAddressController.dispose();
    nameOfTradingFirmLadaniController.dispose();
    tradingSinceYearsController.dispose();
    firmTypeLadaniController.dispose();
    licenseNoController.dispose();
    purchaseLocationAddressController.dispose();
    licensesIssuingAPMCController.dispose();
    locationOnGoogleController.dispose();
    appleBoxesPurchased2023Controller.dispose();
    appleBoxesPurchased2024Controller.dispose();
    estimatedTarget2025LadaniController.dispose();
    perBoxExpensesAfterBiddingController.dispose();
    driverNameController.dispose();
    driverContactController.dispose();
    drivingLicenseNoController.dispose();
    vehicleRegistrationNoController.dispose();
    chassiNoOfVehicleController.dispose();
    payloadCapacityApprovedByRtoController.dispose();
    grossVehicleWeightController.dispose();
    noOfTyresController.dispose();
    permitOfVehicleDrivingController.dispose();
    vehicleOwnerAdharGstController.dispose();
    appleBoxesTransported2023DriverController.dispose();
    appleBoxesTransported2024DriverController.dispose();
    estimatedTarget2025DriverController.dispose();
    statesDrivenThroughDriverController.dispose();
    hpmcNameController.dispose();
    operatorNameController.dispose();
    cellNoController.dispose();
    aadharNoController.dispose();
    licenseNoHpmcController.dispose();
    operatingSinceController.dispose();
    locationHpmcController.dispose();
    boxesTransported2023Controller.dispose();
    boxesTransported2024Controller.dispose();
    target2025Controller.dispose();
    needTradeFinance.value = false;
    currentStep.value = 0;
    errorMessage.value = "";
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
      case 0:
        if (nameController.text.trim().isEmpty) {
          errorMessage.value = "Please enter your name";
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
        if (selectedRole.value == "Aadhati") {
          if (apmc_IDController.text.trim().isEmpty) {
            errorMessage.value = "Please enter APMC ID";
            return false;
          }
        } else if (selectedRole.value == "HPMC Depot") {
          if (hpmcNameController.text.trim().isEmpty) {
            errorMessage.value = "Please enter HPMC name";
            return false;
          }
        } else {
          if (villageController.text.trim().isEmpty) {
            errorMessage.value = "Please enter your village";
            return false;
          }
        }
        break;
      case 1:
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
        if (selectedRole.value != "Aadhati") {
          if (pinCodeController.text.trim().isEmpty) {
            errorMessage.value = "Please enter your PIN code";
            return false;
          }
          if (pinCodeController.text.length != 6) {
            errorMessage.value = "PIN code must be 6 digits";
            return false;
          }
        }
        break;
      case 2:
        if (selectedRole.value == "Aadhati") {
          if (nameOfTradingFirmController.text.trim().isEmpty) {
            errorMessage.value = "Please enter trading firm name";
            return false;
          }
          if (tradingExperienceController.text.trim().isEmpty) {
            errorMessage.value = "Please enter trading experience";
            return false;
          }
          if (firmTypeController.text.trim().isEmpty) {
            errorMessage.value = "Please select firm type";
            return false;
          }
          if (licenceNumberController.text.trim().isEmpty) {
            errorMessage.value = "Please enter licence number";
            return false;
          }
        } else if (selectedRole.value == "PackHouse") {
          if (gradingMachineController.text.trim().isEmpty) {
            errorMessage.value = "Please enter grading machine";
            return false;
          }
          if (sortingMachineController.text.trim().isEmpty) {
            errorMessage.value = "Please enter sorting machine";
            return false;
          }
          if (numberOfCratesController.text.trim().isEmpty) {
            errorMessage.value = "Please enter number of crates";
            return false;
          }
        } else if (selectedRole.value == "Transport Union") {
          if (nameOfTheTransportUnionController.text.trim().isEmpty) {
            errorMessage.value = "Please enter name of the transport union";
            return false;
          }
          if (transportUnionRegistrationNoController.text.trim().isEmpty) {
            errorMessage.value = "Please enter registration number";
            return false;
          }
          if (noOfVehiclesRegisteredController.text.trim().isEmpty) {
            errorMessage.value = "Please enter number of vehicles registered";
            return false;
          }
        } else if (selectedRole.value == "Corporate Company" ||
            selectedRole.value == "Buyer" ||
            selectedRole.value == "Ladani Buyers") {
          if (nameOfTradingFirmLadaniController.text.trim().isEmpty) {
            errorMessage.value = "Please enter trading firm name";
            return false;
          }
          if (tradingSinceYearsController.text.trim().isEmpty) {
            errorMessage.value = "Please enter trading since years";
            return false;
          }
          if (firmTypeLadaniController.text.trim().isEmpty) {
            errorMessage.value = "Please select firm type";
            return false;
          }
          if (licenseNoController.text.trim().isEmpty) {
            errorMessage.value = "Please enter license number";
            return false;
          }
        } else if (selectedRole.value == "Driver") {
          if (drivingLicenseNoController.text.trim().isEmpty) {
            errorMessage.value = "Please enter driving license number";
            return false;
          }
          if (vehicleRegistrationNoController.text.trim().isEmpty) {
            errorMessage.value = "Please enter vehicle registration number";
            return false;
          }
        } else if (selectedRole.value == "HPMC Depot") {
          if (operatorNameController.text.trim().isEmpty) {
            errorMessage.value = "Please enter operator name";
            return false;
          }
          if (cellNoController.text.trim().isEmpty) {
            errorMessage.value = "Please enter cell number";
            return false;
          }
          if (aadharNoController.text.trim().isEmpty) {
            errorMessage.value = "Please enter aadhar number";
            return false;
          }
          if (licenseNoHpmcController.text.trim().isEmpty) {
            errorMessage.value = "Please enter license number";
            return false;
          }
        }
        break;
    }
    return true;
  }

  int getTotalSteps() {
    switch (selectedRole.value) {
      case "Grower":
        return 3;
      case "Aadhati":
        return 3;
      case "PackHouse":
        return 3;
      case "Transport Union":
        return 3;
      case "Corporate Company":
      case "Buyer":
      case "Ladani Buyers":
        return 3;
      case "Driver":
        return 3;
      case "HPMC Depot":
        return 3;
      default:
        return 2;
    }
  }

  String getStepTitle(int step) {
    switch (step) {
      case 0:
        return "Basic Information";
      case 1:
        return "Contact Information";
      case 2:
        if (selectedRole.value == "Grower") {
          return "Grower Details";
        } else if (selectedRole.value == "Aadhati") {
          return "Aadhati Details";
        } else if (selectedRole.value == "PackHouse") {
          return "PackHouse Details";
        } else if (selectedRole.value == "Transport Union") {
          return "Transport Union Details";
        } else if (selectedRole.value == "Corporate Company" ||
            selectedRole.value == "Buyer" ||
            selectedRole.value == "Ladani Buyers") {
          return "Ladani/Buyer Details";
        } else if (selectedRole.value == "Driver") {
          return "Driver Details";
        } else if (selectedRole.value == "HPMC Depot") {
          return "HPMC Depot Details";
        }
        return "Additional Details";
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
        case "Aadhati":
          await registerAadhati();
          break;
        case "PackHouse":
          await registerPackHouse();
          break;
        case "Transport Union":
          await registerTransportUnion();
          break;
        case "Corporate Company":
        case "Buyer":
        case "Ladani Buyers":
          await registerLadani();
          break;
        case "Driver":
          await registerDriver();
          break;
        case "HPMC Depot":
          await registerHpmcDepot();
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

  Future<void> registerAadhati() async {
    try {
      final Map<String, dynamic> requestBody = {
        "name": nameController.text.trim(),
        "aadhar": aadharController.text.trim(),
        "contact": phoneController.text.trim(),
        "apmc_ID": apmc_IDController.text.trim(),
        "address": addressController.text.trim(),
        "nameOfTradingFirm": nameOfTradingFirmController.text.trim(),
        "tradingExperience":
            int.tryParse(tradingExperienceController.text.trim()) ?? 0,
        "firmType": firmTypeController.text.trim(),
        "licenceNumber": licenceNumberController.text.trim(),
        "appleboxesT2": int.tryParse(appleboxesT2Controller.text.trim()) ?? 0,
        "appleboxesT1": int.tryParse(appleboxesT1Controller.text.trim()) ?? 0,
        "appleboxesT": int.tryParse(appleboxesTController.text.trim()) ?? 0,
        "needTradeFinance": needTradeFinance.value,
        "applegrowersServed":
            int.tryParse(applegrowersServedController.text.trim()) ?? 0,
        "gallery": [],
        "grower_IDs": [],
        "freightForwarder_IDs": [],
        "transportUnion_IDs": [],
        "consignment_IDs": [],
        "driver_IDs": [],
        "packhouse_IDs": [],
        "buyer_IDs": [],
        "staff": {},
      };

      final response = await http.post(
        Uri.parse(aadhatiApiUrl),
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
          'Aadhati registered successfully!',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.green,
          colorText: Colors.white,
        );

        Get.toNamed(RoutesConstant.aadhati);
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
        "gallery": []
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

  Future<void> registerPackHouse() async {
    try {
      final Map<String, dynamic> requestBody = {
        "name": nameController.text.trim(),
        "phoneNumber": phoneController.text.trim(),
        "address": addressController.text.trim(),
        "gradingMachine": gradingMachineController.text.trim(),
        "gradingMachineCapacity": gradingMachineCapacityController.text.trim(),
        "sortingMachine": sortingMachineController.text.trim(),
        "sortingMachineCapacity": sortingMachineCapacityController.text.trim(),
        "machineManufacture": machineManufactureController.text.trim(),
        "trayType": trayTypeController.text.trim(),
        "perDayCapacity": perDayCapacityController.text.trim(),
        "numberOfCrates":
            int.tryParse(numberOfCratesController.text.trim()) ?? 0,
        "crateManufacture": crateManufactureController.text.trim(),
        "boxesPackedT2": int.tryParse(boxesPackedT2Controller.text.trim()) ?? 0,
        "boxesPackedT1": int.tryParse(boxesPackedT1Controller.text.trim()) ?? 0,
        "boxesEstimatedT":
            int.tryParse(boxesEstimatedTController.text.trim()) ?? 0,
        "geoLocation": geoLocationController.text.trim(),
        "numberOfGrowersServed":
            int.tryParse(numberOfGrowersServedController.text.trim()) ?? 0,
        "gallery": [],
        "grower_IDs": [],
        "aadhati_IDs": [],
        "employee_IDs": [],
        "drivers_IDs": [],
        "transportUnion_IDs": [],
        "freightForwarder_IDs": [],
        "consignment_IDs": [],
        "hpmcDepot_IDs": [],
        "buyer_IDs": [],
        "consignments": [],
        "associatedFreightForwarders": [],
        "associatedTransportUnions": [],
        "associatedHpmcDepots": [],
        "associatedLadanis": [],
        "myComplaints": [],
      };
      final String packHouseApiUrl = glb.url + "/api/packhouse";
      final response = await http.post(
        Uri.parse(packHouseApiUrl),
        headers: {
          'Content-Type': 'application/json',
        },
        body: jsonEncode(requestBody),
      );
      if (response.statusCode == 201 || response.statusCode == 200) {
        final responseData = jsonDecode(response.body);
        glb.id.value = responseData['_id'];
        Get.snackbar(
          'Success',
          'PackHouse registered successfully!',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.green,
          colorText: Colors.white,
        );
        Get.toNamed(RoutesConstant.packHouse);
      } else {
        final errorData = jsonDecode(response.body);
        String errorMsg = "Registration failed";
        if (errorData != null && errorData['message'] != null) {
          errorMsg = errorData['message'];
        } else if (response.statusCode == 409) {
          errorMsg = "PackHouse already exists";
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

  Future<void> registerTransportUnion() async {
    try {
      final Map<String, dynamic> requestBody = {
        "name": transportUnionNameController.text.trim(),
        "contact": transportUnionContactController.text.trim(),
        "address": transportUnionAddressController.text.trim(),
        "nameOfTheTransportUnion":
            nameOfTheTransportUnionController.text.trim(),
        "transportUnionRegistrationNo":
            transportUnionRegistrationNoController.text.trim(),
        "noOfVehiclesRegistered":
            int.tryParse(noOfVehiclesRegisteredController.text.trim()) ?? 0,
        "transportUnionPresidentAdharId":
            transportUnionPresidentAdharIdController.text.trim(),
        "transportUnionSecretaryAdhar":
            transportUnionSecretaryAdharController.text.trim(),
        "noOfLightCommercialVehicles":
            int.tryParse(noOfLightCommercialVehiclesController.text.trim()) ??
                0,
        "noOfMediumCommercialVehicles":
            int.tryParse(noOfMediumCommercialVehiclesController.text.trim()) ??
                0,
        "noOfHeavyCommercialVehicles":
            int.tryParse(noOfHeavyCommercialVehiclesController.text.trim()) ??
                0,
        "appleBoxesTransported2023":
            int.tryParse(appleBoxesTransported2023Controller.text.trim()) ?? 0,
        "appleBoxesTransported2024":
            int.tryParse(appleBoxesTransported2024Controller.text.trim()) ?? 0,
        "estimatedTarget2025":
            double.tryParse(estimatedTarget2025Controller.text.trim()) ?? 0.0,
        "statesDrivenThrough": statesDrivenThroughController.text.trim(),
        "appleGrowers": [],
        "aadhatis": [],
        "buyers": [],
        "associatedDrivers": [],
        "myComplaints": [],
      };
      final String transportUnionApiUrl = glb.url + "/api/transport-union";
      final response = await http.post(
        Uri.parse(transportUnionApiUrl),
        headers: {
          'Content-Type': 'application/json',
        },
        body: jsonEncode(requestBody),
      );
      if (response.statusCode == 201 || response.statusCode == 200) {
        final responseData = jsonDecode(response.body);
        glb.id.value = responseData['_id'];
        Get.snackbar(
          'Success',
          'Transport Union registered successfully!',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.green,
          colorText: Colors.white,
        );
        Get.toNamed(RoutesConstant.transportUnion);
      } else {
        final errorData = jsonDecode(response.body);
        String errorMsg = "Registration failed";
        if (errorData != null && errorData['message'] != null) {
          errorMsg = errorData['message'];
        } else if (response.statusCode == 409) {
          errorMsg = "Transport Union already exists";
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

  Future<void> registerLadani() async {
    try {
      final Map<String, dynamic> requestBody = {
        "name": ladaniNameController.text.trim(),
        "contact": ladaniContactController.text.trim(),
        "address": ladaniAddressController.text.trim(),
        "nameOfTradingFirm": nameOfTradingFirmLadaniController.text.trim(),
        "tradingSinceYears":
            int.tryParse(tradingSinceYearsController.text.trim()) ?? 0,
        "firmType": firmTypeLadaniController.text.trim(),
        "licenseNo": licenseNoController.text.trim(),
        "purchaseLocationAddress":
            purchaseLocationAddressController.text.trim(),
        "licensesIssuingAPMC": licensesIssuingAPMCController.text.trim(),
        "locationOnGoogle": locationOnGoogleController.text.trim(),
        "appleBoxesPurchased2023":
            int.tryParse(appleBoxesPurchased2023Controller.text.trim()) ?? 0,
        "appleBoxesPurchased2024":
            int.tryParse(appleBoxesPurchased2024Controller.text.trim()) ?? 0,
        "estimatedTarget2025":
            double.tryParse(estimatedTarget2025LadaniController.text.trim()) ??
                0.0,
        "perBoxExpensesAfterBidding":
            double.tryParse(perBoxExpensesAfterBiddingController.text.trim()) ??
                0.0,
        "associatedAaddhatis": [],
        "associatedBuyer": [],
        "truckServiceProviders": [],
        "myComplaints": [],
      };
      final String ladaniApiUrl = glb.url + "/api/ladani";
      final response = await http.post(
        Uri.parse(ladaniApiUrl),
        headers: {
          'Content-Type': 'application/json',
        },
        body: jsonEncode(requestBody),
      );
      if (response.statusCode == 201 || response.statusCode == 200) {
        final responseData = jsonDecode(response.body);
        glb.id.value = responseData['_id'];
        Get.snackbar(
          'Success',
          'Ladani/Buyer registered successfully!',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.green,
          colorText: Colors.white,
        );
        Get.toNamed(RoutesConstant.ladaniBuyers);
      } else {
        final errorData = jsonDecode(response.body);
        String errorMsg = "Registration failed";
        if (errorData != null && errorData['message'] != null) {
          errorMsg = errorData['message'];
        } else if (response.statusCode == 409) {
          errorMsg = "Ladani/Buyer already exists";
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

  Future<void> registerDriver() async {
    try {
      final Map<String, dynamic> requestBody = {
        "name": driverNameController.text.trim(),
        "contact": driverContactController.text.trim(),
        "drivingLicenseNo": drivingLicenseNoController.text.trim(),
        "vehicleRegistrationNo": vehicleRegistrationNoController.text.trim(),
        "chassiNoOfVehicle": chassiNoOfVehicleController.text.trim(),
        "payloadCapacityApprovedByRto":
            payloadCapacityApprovedByRtoController.text.trim(),
        "grossVehicleWeight": grossVehicleWeightController.text.trim(),
        "noOfTyres": int.tryParse(noOfTyresController.text.trim()) ?? 0,
        "permitOfVehicleDriving": permitOfVehicleDrivingController.text.trim(),
        "vehicleOwnerAdharGst": vehicleOwnerAdharGstController.text.trim(),
        "appleBoxesTransported2023": int.tryParse(
                appleBoxesTransported2023DriverController.text.trim()) ??
            0,
        "appleBoxesTransported2024": int.tryParse(
                appleBoxesTransported2024DriverController.text.trim()) ??
            0,
        "estimatedTarget2025":
            double.tryParse(estimatedTarget2025DriverController.text.trim()) ??
                0.0,
        "statesDrivenThrough": statesDrivenThroughDriverController.text.trim(),
        "appleGrowers": [],
        "aadhatis": [],
        "buyers": [],
        "myComplaints": [],
      };
      final String driverApiUrl = glb.url + "/api/driver";
      final response = await http.post(
        Uri.parse(driverApiUrl),
        headers: {
          'Content-Type': 'application/json',
        },
        body: jsonEncode(requestBody),
      );
      if (response.statusCode == 201 || response.statusCode == 200) {
        final responseData = jsonDecode(response.body);
        glb.id.value = responseData['_id'];
        Get.snackbar(
          'Success',
          'Driver registered successfully!',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.green,
          colorText: Colors.white,
        );
        Get.toNamed(RoutesConstant.driver);
      } else {
        final errorData = jsonDecode(response.body);
        String errorMsg = "Registration failed";
        if (errorData != null && errorData['message'] != null) {
          errorMsg = errorData['message'];
        } else if (response.statusCode == 409) {
          errorMsg = "Driver already exists";
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

  Future<void> registerHpmcDepot() async {
    try {
      final Map<String, dynamic> requestBody = {
        "HPMCname": hpmcNameController.text.trim(),
        "operatorName": operatorNameController.text.trim(),
        "cellNo": cellNoController.text.trim(),
        "aadharNo": aadharNoController.text.trim(),
        "licenseNo": licenseNoHpmcController.text.trim(),
        "operatingSince": operatingSinceController.text.trim(),
        "location": locationHpmcController.text.trim(),
        "boxesTransported2023":
            int.tryParse(boxesTransported2023Controller.text.trim()) ?? 0,
        "boxesTransported2024":
            int.tryParse(boxesTransported2024Controller.text.trim()) ?? 0,
        "target2025": double.tryParse(target2025Controller.text.trim()) ?? 0.0,
        "associatedGrowers": [],
        "myComplaints": [],
        "associatedPackHouses": [],
        "associatedDrivers": [],
        "associatedTransportUnions": [],
      };
      final String hpmcDepotApiUrl = glb.url + "/api/hpmc-depot";
      final response = await http.post(
        Uri.parse(hpmcDepotApiUrl),
        headers: {
          'Content-Type': 'application/json',
        },
        body: jsonEncode(requestBody),
      );
      if (response.statusCode == 201 || response.statusCode == 200) {
        final responseData = jsonDecode(response.body);
        glb.id.value = responseData['_id'];
        Get.snackbar(
          'Success',
          'HPMC Depot registered successfully!',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.green,
          colorText: Colors.white,
        );
        Get.toNamed(RoutesConstant.hpAgriBoard);
      } else {
        final errorData = jsonDecode(response.body);
        String errorMsg = "Registration failed";
        if (errorData != null && errorData['message'] != null) {
          errorMsg = errorData['message'];
        } else if (response.statusCode == 409) {
          errorMsg = "HPMC Depot already exists";
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
    apmc_IDController.clear();
    nameOfTradingFirmController.clear();
    tradingExperienceController.clear();
    firmTypeController.clear();
    licenceNumberController.clear();
    appleboxesT2Controller.clear();
    appleboxesT1Controller.clear();
    appleboxesTController.clear();
    applegrowersServedController.clear();
    gradingMachineController.clear();
    sortingMachineController.clear();
    gradingMachineCapacityController.clear();
    sortingMachineCapacityController.clear();
    machineManufactureController.clear();
    trayTypeController.clear();
    perDayCapacityController.clear();
    numberOfCratesController.clear();
    crateManufactureController.clear();
    boxesPackedT2Controller.clear();
    boxesPackedT1Controller.clear();
    boxesEstimatedTController.clear();
    geoLocationController.clear();
    numberOfGrowersServedController.clear();
    transportUnionNameController.clear();
    transportUnionContactController.clear();
    transportUnionAddressController.clear();
    nameOfTheTransportUnionController.clear();
    transportUnionRegistrationNoController.clear();
    noOfVehiclesRegisteredController.clear();
    transportUnionPresidentAdharIdController.clear();
    transportUnionSecretaryAdharController.clear();
    noOfLightCommercialVehiclesController.clear();
    noOfMediumCommercialVehiclesController.clear();
    noOfHeavyCommercialVehiclesController.clear();
    appleBoxesTransported2023Controller.clear();
    appleBoxesTransported2024Controller.clear();
    estimatedTarget2025Controller.clear();
    statesDrivenThroughController.clear();
    ladaniNameController.clear();
    ladaniContactController.clear();
    ladaniAddressController.clear();
    nameOfTradingFirmLadaniController.clear();
    tradingSinceYearsController.clear();
    firmTypeLadaniController.clear();
    licenseNoController.clear();
    purchaseLocationAddressController.clear();
    licensesIssuingAPMCController.clear();
    locationOnGoogleController.clear();
    appleBoxesPurchased2023Controller.clear();
    appleBoxesPurchased2024Controller.clear();
    estimatedTarget2025LadaniController.clear();
    perBoxExpensesAfterBiddingController.clear();
    driverNameController.clear();
    driverContactController.clear();
    drivingLicenseNoController.clear();
    vehicleRegistrationNoController.clear();
    chassiNoOfVehicleController.clear();
    payloadCapacityApprovedByRtoController.clear();
    grossVehicleWeightController.clear();
    noOfTyresController.clear();
    permitOfVehicleDrivingController.clear();
    vehicleOwnerAdharGstController.clear();
    appleBoxesTransported2023DriverController.clear();
    appleBoxesTransported2024DriverController.clear();
    estimatedTarget2025DriverController.clear();
    statesDrivenThroughDriverController.clear();
    hpmcNameController.clear();
    operatorNameController.clear();
    cellNoController.clear();
    aadharNoController.clear();
    licenseNoHpmcController.clear();
    operatingSinceController.clear();
    locationHpmcController.clear();
    boxesTransported2023Controller.clear();
    boxesTransported2024Controller.clear();
    target2025Controller.clear();
    needTradeFinance.value = false;
    currentStep.value = 0;
    errorMessage.value = "";
  }
}
