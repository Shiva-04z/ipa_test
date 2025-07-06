import 'dart:io';

import 'package:apple_grower/navigation/routes_constant.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:latlong2/latlong.dart';
import 'dart:convert';
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

  // Freight Forwarder specific controllers
  final freightForwarderNameController = TextEditingController();
  final freightForwarderContactController = TextEditingController();
  final freightForwarderAddressController = TextEditingController();
  final freightForwarderLicenseNoController = TextEditingController();
  final forwardingSinceYearsController = TextEditingController();
  final licensesIssuingAuthorityController = TextEditingController();
  final locationOnGoogleFreightController = TextEditingController();
  final appleBoxesForwarded2023Controller = TextEditingController();
  final appleBoxesForwarded2024Controller = TextEditingController();
  final estimatedForwardingTarget2025Controller = TextEditingController();
  final tradeLicenseOfAadhatiAttachedController = TextEditingController();

  // Police Officer specific controllers
  final policeNameController = TextEditingController();
  final policeCellNoController = TextEditingController();
  final policeAdharIdController = TextEditingController();
  final policeBeltNoController = TextEditingController();
  final policeRankController = TextEditingController();
  final policeReportingOfficerController = TextEditingController();
  final policeDutyLocationController = TextEditingController();

  // AMPCO Office specific controllers
  final ampcNameController = TextEditingController();
  final ampcAddressController = TextEditingController();
  final ampcSignatoryController = TextEditingController();
  final ampcDesignationController = TextEditingController();
  final ampcOfficePhoneNoController = TextEditingController();
  final ampcTotalCommissionAgentsController = TextEditingController();
  final ampcTotalLadanisController = TextEditingController();
  final ampcTotalTransportersController = TextEditingController();
  final ampcNoOfHomeGuardsController = TextEditingController();
  final ampcTotalStaffController = TextEditingController();
  final ampcAppleBoxesSold2023Controller = TextEditingController();
  final ampcAppleBoxesSold2024Controller = TextEditingController();
  final ampcEstimatedTarget2025Controller = TextEditingController();

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
    "PackHouse",
    "Aadhati",
    "Ladani/Buyers",
    "Driver",
    "Transport Union",
    "Freight Forwarder",
    "HPMC DEPOT",
    "HP Police",
    "APMC Office",
  ];

  // Firm types for aadhati
  final List<String> firmTypes = [
    "Prop. / Partnership",
    "HUF",
    "PL",
    "LLP",
    "OPC"
  ];

  // location variable
  final currentPosition = Rxn<Position>();
  final mapController = MapController();
  final markers = <Marker>[].obs;
  final isSatelliteMode = false.obs;

  @override
  void onInit() {
    super.onInit();
    _getCurrentLocation();
  }

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
    freightForwarderNameController.dispose();
    freightForwarderContactController.dispose();
    freightForwarderAddressController.dispose();
    freightForwarderLicenseNoController.dispose();
    forwardingSinceYearsController.dispose();
    licensesIssuingAuthorityController.dispose();
    locationOnGoogleFreightController.dispose();
    appleBoxesForwarded2023Controller.dispose();
    appleBoxesForwarded2024Controller.dispose();
    estimatedForwardingTarget2025Controller.dispose();
    tradeLicenseOfAadhatiAttachedController.dispose();
    policeNameController.dispose();
    policeCellNoController.dispose();
    policeAdharIdController.dispose();
    policeBeltNoController.dispose();
    policeRankController.dispose();
    policeReportingOfficerController.dispose();
    policeDutyLocationController.dispose();
    ampcNameController.dispose();
    ampcAddressController.dispose();
    ampcSignatoryController.dispose();
    ampcDesignationController.dispose();
    ampcOfficePhoneNoController.dispose();
    ampcTotalCommissionAgentsController.dispose();
    ampcTotalLadanisController.dispose();
    ampcTotalTransportersController.dispose();
    ampcNoOfHomeGuardsController.dispose();
    ampcTotalStaffController.dispose();
    ampcAppleBoxesSold2023Controller.dispose();
    ampcAppleBoxesSold2024Controller.dispose();
    ampcEstimatedTarget2025Controller.dispose();
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
        if (selectedRole.value != "Aadhati") {
          if (villageController.text.trim().isEmpty) {
            errorMessage.value = "Please enter your village";
            return false;
          }
        }
        if (selectedRole.value == "Aadhati"){
          if (apmc_IDController.text.trim().isEmpty) {
            errorMessage.value = "Please enter APMC ID";
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
        } else if (selectedRole.value == "FreightForwarder") {
          if (freightForwarderLicenseNoController.text.trim().isEmpty) {
            errorMessage.value = "Please enter license number";
            return false;
          }
          if (forwardingSinceYearsController.text.trim().isEmpty) {
            errorMessage.value = "Please enter forwarding since years";
            return false;
          }
        } else if (selectedRole.value == "Police Officer") {
          if (policeCellNoController.text.trim().isEmpty) {
            errorMessage.value = "Please enter police cell number";
            return false;
          }
          if (policeAdharIdController.text.trim().isEmpty) {
            errorMessage.value = "Please enter police adhar ID";
            return false;
          }
          if (policeBeltNoController.text.trim().isEmpty) {
            errorMessage.value = "Please enter police belt number";
            return false;
          }
        } else if (selectedRole.value == "AMPCO Office") {
          if (ampcNameController.text.trim().isEmpty) {
            errorMessage.value = "Please enter AMPCO name";
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
      case "Ladani/Buyers":
        return 3;
      case "Driver":
        return 3;
      case "HPMC DEPOT":
        return 3;
      case "Freight Forwarder":
        return 3;
      case "HP Police":
        return 3;
      case "APMC Office":
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
            selectedRole.value == "Ladani/Buyers") {
          return "Ladani/Buyer Details";
        } else if (selectedRole.value == "Driver") {
          return "Driver Details";
        } else if (selectedRole.value == "HPMC DEPOT") {
          return "HPMC Depot Details";
        } else if (selectedRole.value == "Freight Forwarder") {
          return "Freight Forwarder Details";
        } else if (selectedRole.value == "HP Police") {
          return "Police Officer Details";
        } else if (selectedRole.value == "APMC Office") {
          return "APMC Office Details";
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
        case "Ladani/Buyers":
          await registerLadani();
          break;
        case "Driver":
          await registerDriver();
          break;
        case "HPMC DEPOT":
          await registerHpmcDepot();
          break;
        case "Freight Forwarder":
          await registerFreightForwarder();
          break;
        case "HP Police":
          await registerPoliceOfficer();
          break;
        case "APMC Office":
          await registerAmpcoOffice();
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
        createUser(glb.id.value);
        Get.snackbar(
          'Success',
          'Aadhati registered successfully!',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.green,
          colorText: Colors.white,
        );
        glb.roleType.value = selectedRole.value;
        await glb.uploadUserData();

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
        createUser(
          glb.id.value,

        );
        Get.snackbar(
          'Success',
          'Grower registered successfully!',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.green,
          colorText: Colors.white,
        );

        // Store the created grower data if needed
        // You might want to save the response data to local storage or global state

        glb.roleType.value = selectedRole.value;
        await glb.uploadUserData();
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
        "sortingMachine": "",
        "sortingMachineCapacity": "",
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
        createUser(glb.id.value, name: nameController.text.trim(),
    contact : phoneController.text.trim(),
    address : addressController.text.trim(),);
        Get.snackbar(
          'Success',
          'PackHouse registered successfully!',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.green,
          colorText: Colors.white,
        );
        glb.roleType.value = selectedRole.value;
        await glb.uploadUserData();
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
        "name": nameController.text.trim(),
        "contact": phoneController.text.trim(),
        "address": addressController.text.trim(),
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
        // "appleGrowers": [],
        // "aadhatis": [],
        // "buyers": [],
        // "associatedDrivers": [],
        // "myComplaints": [],
      };
      final String transportUnionApiUrl = glb.url + "/api/transportunion/create";
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
        createUser(glb.id.value, name : nameController.text.trim(), contact : phoneController.text.trim(), address : addressController.text.trim(), );
        Get.snackbar(
          'Success',
          'Transport Union registered successfully!',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.green,
          colorText: Colors.white,
        );
        glb.roleType.value = selectedRole.value;
        await glb.uploadUserData();
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
        "name": nameController.text.trim(),
        "contact": phoneController.text.trim(),
        "address": addressController.text.trim(),
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
      };
      final String ladaniApiUrl = glb.url + "/api/buyers/";
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
        createUser(glb.id.value, name : nameController.text.trim(),
        contact : phoneController.text.trim(),
        address : addressController.text.trim()
        );
        Get.snackbar(
          'Success',
          'Ladani/Buyer registered successfully!',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.green,
          colorText: Colors.white,
        );
        glb.roleType.value = selectedRole.value;
        await glb.uploadUserData();
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
        "name": nameController.text.trim(),
        "contact": phoneController.text.trim(),
        "licenseNo": drivingLicenseNoController.text.trim(),
        "vehicleRegistrationNo": vehicleRegistrationNoController.text.trim(),
        "vehicleType" : chassiNoOfVehicleController.text.trim(),
        "vehiclePayload":
            payloadCapacityApprovedByRtoController.text.trim(),
        "vehicleWeight": grossVehicleWeightController.text.trim(),
        "noOfTyres": int.tryParse(noOfTyresController.text.trim()) ?? 0,
        "vehiclePermit": permitOfVehicleDrivingController.text.trim(),
        "vehicleOwnerAdharGst": vehicleOwnerAdharGstController.text.trim(),
        "boxesTransportedT2": int.tryParse(
                appleBoxesTransported2023DriverController.text.trim()) ??
            0,
        "boxesTransportedT1": int.tryParse(
                appleBoxesTransported2024DriverController.text.trim()) ??
            0,
        "boxesTransportedT0":
            double.tryParse(estimatedTarget2025DriverController.text.trim()) ??
                0.0,
        "statesDrivenThrough": statesDrivenThroughDriverController.text.trim(),
      };
      final String driverApiUrl = glb.url + "/api/drivers/create";
      final response = await http.post(
        Uri.parse(driverApiUrl),
        headers: {
          'Content-Type': 'application/json',
        },
        body: jsonEncode(requestBody),
      );
      if (response.statusCode == 201 || response.statusCode == 200) {
        final responseData = jsonDecode(response.body)['data'];
        glb.id.value = responseData['_id'];
        createUser(glb.id.value, name : nameController.text.trim(), contact: phoneController.text.trim(),);
        Get.snackbar(
          'Success',
          'Driver registered successfully!',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.green,
          colorText: Colors.white,
        );
        glb.roleType.value = selectedRole.value;
        await glb.uploadUserData();
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
      final String hpmcDepotApiUrl = glb.url + "/api/hpmcDepot/create";
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
        createUser(
          glb.id.value,
          name: nameController.text.trim(),
          contact: cellNoController.text.trim(),
          aadhar: aadharNoController.text.trim(),
        );
        Get.snackbar(
          'Success',
          'HPMC Depot registered successfully!',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.green,
          colorText: Colors.white,
        );
        glb.roleType.value = selectedRole.value;
        await glb.uploadUserData();
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

  Future<void> registerFreightForwarder() async {
    try {
      final Map<String, dynamic> requestBody = {
        "name": freightForwarderNameController.text.trim(),
        "contact": freightForwarderContactController.text.trim(),
        "address": freightForwarderAddressController.text.trim(),
        "licenseNo": freightForwarderLicenseNoController.text.trim(),
        "forwardingSinceYears":
            int.tryParse(forwardingSinceYearsController.text.trim()) ?? 0,
        "licensesIssuingAuthority":
            licensesIssuingAuthorityController.text.trim(),
        "locationOnGoogle": locationOnGoogleFreightController.text.trim(),
        "appleBoxesForwarded2023":
            int.tryParse(appleBoxesForwarded2023Controller.text.trim()) ?? 0,
        "appleBoxesForwarded2024":
            int.tryParse(appleBoxesForwarded2024Controller.text.trim()) ?? 0,
        "estimatedForwardingTarget2025":
            int.tryParse(estimatedForwardingTarget2025Controller.text.trim()) ??
                0,
        "tradeLicenseOfAadhatiAttached":
            tradeLicenseOfAadhatiAttachedController.text.trim(),
        "associatedAadhatis": [],
        "associatedGrowers": [],
        "associatedPickupProviders": [],
        "associatedTruckServiceProviders": [],
        "createdAt": DateTime.now().toIso8601String(),
        "updatedAt": DateTime.now().toIso8601String(),
      };
      final String freightForwarderApiUrl = glb.url + "/api/freightforwarders/create";
      final response = await http.post(
        Uri.parse(freightForwarderApiUrl),
        headers: {
          'Content-Type': 'application/json',
        },
        body: jsonEncode(requestBody),
      );
      if (response.statusCode == 201 || response.statusCode == 200) {
        final responseData = jsonDecode(response.body);
        glb.id.value = responseData['_id'];
        createUser(
          glb.id.value,
          name: freightForwarderNameController.text.trim(),
          contact: freightForwarderContactController.text.trim(),
          address: freightForwarderAddressController.text.trim(),
        );
        Get.snackbar(
          'Success',
          'Freight Forwarder registered successfully!',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.green,
          colorText: Colors.white,
        );
        await glb.uploadIDData();
        Get.toNamed(RoutesConstant.freightForwarder);
      } else {
        final errorData = jsonDecode(response.body);
        String errorMsg = "Registration failed";
        if (errorData != null && errorData['message'] != null) {
          errorMsg = errorData['message'];
        } else if (response.statusCode == 409) {
          errorMsg = "Freight Forwarder already exists";
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

  Future<void> registerPoliceOfficer() async {
    try {
      final Map<String, dynamic> requestBody = {
        "name": policeNameController.text.trim(),
        "cellNo": policeCellNoController.text.trim(),
        "adharId": policeAdharIdController.text.trim(),
        "beltNo": policeBeltNoController.text.trim(),
        "rank": policeRankController.text.trim(),
        "reportingOfficer": policeReportingOfficerController.text.trim(),
        "dutyLocation": policeDutyLocationController.text.trim(),
        "location": {"latitude": 0.0, "longitude": 0.0},
        "isActive": true,
        "createdAt": DateTime.now().toIso8601String(),
        "updatedAt": DateTime.now().toIso8601String(),
      };
      final String policeApiUrl = glb.url + "/api/hppolice/";
      final response = await http.post(
        Uri.parse(policeApiUrl),
        headers: {
          'Content-Type': 'application/json',
        },
        body: jsonEncode(requestBody),
      );
      if (response.statusCode == 201 || response.statusCode == 200) {
        final responseData = jsonDecode(response.body);
        glb.id.value = responseData['_id'];
        createUser(
          glb.id.value,
          name: policeNameController.text.trim(),
          contact: policeCellNoController.text.trim(),
          aadhar: policeAdharIdController.text.trim(),
        );
        Get.snackbar(
          'Success',
          'Police Officer registered successfully!',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.green,
          colorText: Colors.white,
        );
        await glb.uploadIDData();
        Get.toNamed(RoutesConstant.hpPolice);
      } else {
        final errorData = jsonDecode(response.body);
        String errorMsg = "Registration failed";
        if (errorData != null && errorData['message'] != null) {
          errorMsg = errorData['message'];
        } else if (response.statusCode == 409) {
          errorMsg = "Police Officer already exists";
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

  Future<void> registerAmpcoOffice() async {
    try {
      final Map<String, dynamic> requestBody = {
        "name": ampcNameController.text.trim(),
        "address": ampcAddressController.text.trim(),
        "nameOfAuthorizedSignatory": ampcSignatoryController.text.trim(),
        "designation": ampcDesignationController.text.trim(),
        "officePhoneNo": ampcOfficePhoneNoController.text.trim(),
        "totalNoOfCommissionAgents":
            int.tryParse(ampcTotalCommissionAgentsController.text.trim()) ?? 0,
        "totalLadanisWithinJurisdiction":
            int.tryParse(ampcTotalLadanisController.text.trim()) ?? 0,
        "totalNoOfTransporters":
            int.tryParse(ampcTotalTransportersController.text.trim()) ?? 0,
        "noOfHomeGuardsOnDuty":
            int.tryParse(ampcNoOfHomeGuardsController.text.trim()) ?? 0,
        "totalApmcStaff":
            int.tryParse(ampcTotalStaffController.text.trim()) ?? 0,
        "appleBoxesSold2023":
            int.tryParse(ampcAppleBoxesSold2023Controller.text.trim()) ?? 0,
        "appleBoxesSold2024":
            int.tryParse(ampcAppleBoxesSold2024Controller.text.trim()) ?? 0,
        "estimatedTarget2025":
            double.tryParse(ampcEstimatedTarget2025Controller.text.trim()) ??
                0.0,
        "approvedAadhati": [],
        "blacklistedAdhaties": [],
        "approvedLadanis": [],
        "blacklistedLadanis": [],
        "lodgedComplaints": [],
      };
      final String ampcApiUrl = glb.url + "/api/ampc-office";
      final response = await http.post(
        Uri.parse(ampcApiUrl),
        headers: {
          'Content-Type': 'application/json',
        },
        body: jsonEncode(requestBody),
      );
      if (response.statusCode == 201 || response.statusCode == 200) {
        final responseData = jsonDecode(response.body);
        glb.id.value = responseData['_id'];
        createUser(glb.id.value,
            name: ampcNameController.text.trim(),
            address: ampcAddressController.text.trim(),
            contact: ampcOfficePhoneNoController.text.trim());
        Get.snackbar(
          'Success',
          'AMPCO Office registered successfully!',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.green,
          colorText: Colors.white,
        );
        await glb.uploadIDData();
        Get.toNamed(RoutesConstant.apmcOffice);
      } else {
        final errorData = jsonDecode(response.body);
        String errorMsg = "Registration failed";
        if (errorData != null && errorData['message'] != null) {
          errorMsg = errorData['message'];
        } else if (response.statusCode == 409) {
          errorMsg = "AMPCO Office already exists";
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
    freightForwarderNameController.clear();
    freightForwarderContactController.clear();
    freightForwarderAddressController.clear();
    freightForwarderLicenseNoController.clear();
    forwardingSinceYearsController.clear();
    licensesIssuingAuthorityController.clear();
    locationOnGoogleFreightController.clear();
    appleBoxesForwarded2023Controller.clear();
    appleBoxesForwarded2024Controller.clear();
    estimatedForwardingTarget2025Controller.clear();
    tradeLicenseOfAadhatiAttachedController.clear();
    policeNameController.clear();
    policeCellNoController.clear();
    policeAdharIdController.clear();
    policeBeltNoController.clear();
    policeRankController.clear();
    policeReportingOfficerController.clear();
    policeDutyLocationController.clear();
    ampcNameController.clear();
    ampcAddressController.clear();
    ampcSignatoryController.clear();
    ampcDesignationController.clear();
    ampcOfficePhoneNoController.clear();
    ampcTotalCommissionAgentsController.clear();
    ampcTotalLadanisController.clear();
    ampcTotalTransportersController.clear();
    ampcNoOfHomeGuardsController.clear();
    ampcTotalStaffController.clear();
    ampcAppleBoxesSold2023Controller.clear();
    ampcAppleBoxesSold2024Controller.clear();
    ampcEstimatedTarget2025Controller.clear();
    needTradeFinance.value = false;
    currentStep.value = 0;
    errorMessage.value = "";
  }

  Future<void> createUser(String id, {String? name, String? contact, String? aadhar, String? address}) async {
    glb.personName.value = name ?? nameController.text.trim();
    glb.personPhone.value = contact ?? phoneController.text.trim();
    glb.personVillage.value = address ?? villageController.text.trim();
    glb.roleType.value = selectedRole.value;

    try {
      final String userApiUrl = glb.url + "/api/user/register";
      final Map<String, dynamic> updatePayload = {
        'name': glb.personName.value,
        'contact': glb.personPhone.value,
        'aadhar': aadhar ?? aadharController.text.trim(),
        'role': glb.roleType.value,
        'address': glb.personVillage.value,
        'village' : villageController.text.trim(),
        'roledocID': glb.id.value,
        'profileImage': '',
        'createdAt': DateTime.now().toIso8601String(),
        'lastLogin': DateTime.now().toIso8601String(),
        'isActive': true,
      };

      final response = await http.post(
        Uri.parse(userApiUrl),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(updatePayload),
      );

      if (response.statusCode == 201 || response.statusCode == 200) {
        final responseData = jsonDecode(response.body);
        glb.userId.value = responseData['_id'];
        print("User data : $responseData");
        Get.snackbar(
          'Success',
          'User account created successfully!',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.green,
          colorText: Colors.white,
        );
      } else {
        final errorData = jsonDecode(response.body);
        String errorMsg = "User registration failed";
        if (errorData != null && errorData['message'] != null) {
          errorMsg = errorData['message'];
        }
        Get.snackbar(
          'Error',
          errorMsg,
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.red,
          colorText: Colors.white,
        );
      }
    } catch (e) {
      Get.snackbar(
        'Error',
        'User registration failed: $e',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    }
  }

  Future<void> _getCurrentLocation() async {
    try {
      if (kIsWeb) {
        await _handleWebLocation();
      } else if (Platform.isIOS) {
        await _handleIOSLocation();
      } else {
        await _handleAndroidLocation();
      }
    } catch (e) {
      debugPrint('Error getting location: $e');
      _setDefaultLocation();
    }
  }

  Future<String> getAddressFromLatLng(double lat, double lng) async {
    final url =
        'https://nominatim.openstreetmap.org/reverse?format=jsonv2&lat=$lat&lon=$lng&addressdetails=1';
    final response = await http.get(Uri.parse(url), headers: {
      'User-Agent': 'YourAppName/1.0 (your@email.com)' // REQUIRED by Nominatim
    });

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      return data['display_name'] ?? 'Unknown Location';
    } else {
      throw Exception('Failed to fetch address');
    }
  }

  Future<void> _handleWebLocation() async {
    bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      Get.snackbar(
        'Location Services Disabled',
        'Please enable location services in your browser settings.',
        backgroundColor: Colors.orange,
        colorText: Colors.white,
      );
      _setDefaultLocation();
      return;
    }

    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        Get.snackbar(
          'Location Permission Denied',
          'Please allow location access in your browser settings.',
          backgroundColor: Colors.orange,
          colorText: Colors.white,
        );
        _setDefaultLocation();
        return;
      }
    }

    if (permission == LocationPermission.deniedForever) {
      Get.snackbar(
        'Location Permission Denied',
        'Location permissions are permanently denied. Please enable them in your browser settings.',
        backgroundColor: Colors.orange,
        colorText: Colors.white,
      );
      _setDefaultLocation();
      return;
    }

    await _getCurrentPosition();
  }

  Future<void> _handleIOSLocation() async {
    bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      Get.snackbar(
        'Location Services Disabled',
        'Please enable location services in your iOS settings.',
        backgroundColor: Colors.orange,
        colorText: Colors.white,
      );
      _setDefaultLocation();
      return;
    }

    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        Get.snackbar(
          'Location Permission Denied',
          'Please allow location access in your iOS settings.',
          backgroundColor: Colors.orange,
          colorText: Colors.white,
        );
        _setDefaultLocation();
        return;
      }
    }

    if (permission == LocationPermission.deniedForever) {
      Get.snackbar(
        'Location Permission Denied',
        'Location permissions are permanently denied. Please enable them in your iOS settings.',
        backgroundColor: Colors.orange,
        colorText: Colors.white,
      );
      _setDefaultLocation();
      return;
    }

    await _getCurrentPosition();
  }

  Future<void> _handleAndroidLocation() async {
    bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      Get.snackbar(
        'Location Services Disabled',
        'Please enable location services in your Android settings.',
        backgroundColor: Colors.orange,
        colorText: Colors.white,
      );
      _setDefaultLocation();
      return;
    }

    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        Get.snackbar(
          'Location Permission Denied',
          'Please allow location access in your Android settings.',
          backgroundColor: Colors.orange,
          colorText: Colors.white,
        );
        _setDefaultLocation();
        return;
      }
    }

    if (permission == LocationPermission.deniedForever) {
      Get.snackbar(
        'Location Permission Denied',
        'Location permissions are permanently denied. Please enable them in your Android settings.',
        backgroundColor: Colors.orange,
        colorText: Colors.white,
      );
      _setDefaultLocation();
      return;
    }

    await _getCurrentPosition();
  }

  Future<void> _getCurrentPosition() async {
    try {
      currentPosition.value = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
        timeLimit: const Duration(seconds: 5),
      );

      if (currentPosition.value != null) {
        await _updateLocationFromCoordinates(
          currentPosition.value!.latitude,
          currentPosition.value!.longitude,
        );
      }
    } catch (e) {
      debugPrint('Error getting current position: $e');
      _setDefaultLocation();
    }
  }

  Future<void> _updateLocationFromCoordinates(double lat, double lng) async {
    try {
      String address;
      if(kIsWeb) {
        address = await getAddressFromLatLng(lat, lng);
      } else {
        List<Placemark> placemarks = await placemarkFromCoordinates(
          lat,
          lng,
          localeIdentifier: 'en_IN',
        );

        if (placemarks.isNotEmpty) {
          Placemark place = placemarks.first;
          address = '';

          if (place.name?.isNotEmpty ?? false) {
            address += '${place.name}, ';
          }
          if (place.locality?.isNotEmpty ?? false) {
            address += '${place.locality}, ';
          } else if (place.subLocality?.isNotEmpty ?? false) {
            address += '${place.subLocality}, ';
          }
          if (place.administrativeArea?.isNotEmpty ?? false) {
            address += '${place.administrativeArea}, ';
          }
          if (place.postalCode?.isNotEmpty ?? false) {
            address += place.postalCode!;
          }
          if (address.isEmpty) {
            address = 'Lat: ${lat.toStringAsFixed(6)}, Lng: ${lng.toStringAsFixed(6)}';
          }
          address = address.trim();
          if (address.endsWith(',')) {
            address = address.substring(0, address.length - 1);
          }
        } else {
          address = 'Lat: ${lat.toStringAsFixed(6)}, Lng: ${lng.toStringAsFixed(6)}';
        }
      }

      if(selectedRole.value == "PackHouse"){
        geoLocationController.text = address;
      } else if(selectedRole.value == "HP Police"){
        policeDutyLocationController.text = address;
      } else if(selectedRole.value == "HPMC DEPOT") {
        locationHpmcController.text = address;
      } else if(selectedRole.value == "Freight Forwarder") {
        locationOnGoogleFreightController.text = address;
      } else if(selectedRole.value == "Ladani/Buyers") {
        locationOnGoogleController.text = address;
      }

    } catch (e) {
      debugPrint('Error in geocoding: $e');
      _setFallbackLocation(lat, lng);
    }
  }

  void _setFallbackLocation(double lat, double lng) {
    geoLocationController.text =
    'Lat: ${lat.toStringAsFixed(6)}, Lng: ${lng.toStringAsFixed(6)}';
    Get.snackbar(
      'Location Error',
      'Could not get detailed address. Using coordinates instead.',
      backgroundColor: Colors.orange,
      colorText: Colors.white,
      duration: const Duration(seconds: 3),
    );
  }

  void _setDefaultLocation() {
    currentPosition.value = Position(
      latitude: 31.1048,
      longitude: 77.1734,
      timestamp: DateTime.now(),
      accuracy: 0,
      altitude: 0,
      heading: 0,
      speed: 0,
      speedAccuracy: 0,
      altitudeAccuracy: 0,
      headingAccuracy: 0,
    );
    _updateLocationFromCoordinates(31.1048, 77.1734);
  }

  void showLocationPicker() {
    Get.dialog(
      Dialog(
        child: Container(
          width: Get.width * 0.9,
          height: Get.height * 0.8,
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Select Location',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Color(0xff548235),
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.close),
                    onPressed: () => Get.back(),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              Expanded(
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: Obx(() {
                    if (currentPosition.value == null) {
                      return const Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            CircularProgressIndicator(
                              valueColor: AlwaysStoppedAnimation<Color>(
                                  Color(0xff548235)),
                            ),
                            SizedBox(height: 16),
                            Text(
                              'Loading map...',
                              style: TextStyle(color: Color(0xff548235)),
                            ),
                          ],
                        ),
                      );
                    }

                    return Stack(
                      children: [
                        FlutterMap(
                          mapController: mapController,
                          options: MapOptions(
                            initialCenter: LatLng(
                              currentPosition.value!.latitude,
                              currentPosition.value!.longitude,
                            ),
                            initialZoom: 14,
                            minZoom: 5.0,
                            maxZoom: 18.0,
                            onTap: (tapPosition, point) {
                              markers.clear();
                              markers.add(Marker(
                                point: point,
                                width: 40,
                                height: 40,
                                child: const Icon(
                                  Icons.location_on,
                                  color: Color(0xff548235),
                                  size: 40,
                                ),
                              ));
                              _updateLocationFromCoordinates(
                                point.latitude,
                                point.longitude,
                              );
                            },
                          ),
                          children: [
                            TileLayer(
                              urlTemplate: isSatelliteMode.value
                                  ? 'https://server.arcgisonline.com/ArcGIS/rest/services/World_Imagery/MapServer/tile/{z}/{y}/{x}'
                                  : 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                              userAgentPackageName: 'com.example.apple_grower',
                            ),
                            MarkerLayer(markers: markers.toList()),
                          ],
                        ),
                        Positioned(
                          top: 8,
                          right: 8,
                          child: Column(
                            children: [
                              FloatingActionButton(
                                heroTag: 'viewMode',
                                onPressed: () {
                                  isSatelliteMode.value =
                                  !isSatelliteMode.value;
                                },
                                backgroundColor: const Color(0xff548235),
                                child: Icon(
                                  isSatelliteMode.value
                                      ? Icons.map
                                      : Icons.satellite,
                                  color: Colors.white,
                                ),
                              ),
                              const SizedBox(height: 8),
                              FloatingActionButton(
                                heroTag: 'center_location',
                                onPressed: () {
                                  if (currentPosition.value != null) {
                                    mapController.move(
                                      LatLng(
                                        currentPosition.value!.latitude,
                                        currentPosition.value!.longitude,
                                      ),
                                      14,
                                    );
                                  }
                                },
                                backgroundColor: const Color(0xff548235),
                                child: const Icon(Icons.my_location,
                                    color: Colors.white),
                              ),
                            ],
                          ),
                        ),
                      ],
                    );
                  }),
                ),
              ),
              const SizedBox(height: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  TextButton(
                    onPressed: () => Get.back(),
                    child: const Text('Cancel'),
                  ),
                  const SizedBox(width: 8),
                  ElevatedButton(
                    onPressed: () {
                      if (markers.isNotEmpty) {
                        Get.back();
                      } else {
                        Get.snackbar(
                          'Error',
                          'Please select a location on the map',
                          backgroundColor: Colors.red,
                          colorText: Colors.white,
                        );
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xff548235),
                      foregroundColor: Colors.white,
                    ),
                    child: const Text('Confirm Location'),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

}
