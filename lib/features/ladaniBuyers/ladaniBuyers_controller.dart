import 'package:apple_grower/models/freightForwarder.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../models/ladani_model.dart';
import '../../models/aadhati.dart';

import '../../models/driving_profile_model.dart';
import '../../models/consignment_model.dart';

class LadaniBuyersController extends GetxController {
  // Add ladaniBuyers-specific properties and methods here
  RxString companyName = ''.obs;
  RxString businessType = ''.obs;

  final details = {}.obs;
  final associatedAadhatis = <Aadhati>[].obs;
  final associatedBuyers = <FreightForwarder>[].obs;
  final associatedDrivers = <DrivingProfile>[].obs;
  final consignments = <Consignment>[].obs;

  @override
  void onInit() {
    super.onInit();
    // Initialize with sample data
    details.value = {
      'name': 'Sample Ladani',
      'phoneNumber': '+1234567890',
      'address': 'Sample Address',
      'apmc': 'Sample APMC',
    };
  }

  void removeAssociatedAadhati(String id) {
    associatedAadhatis.removeWhere((aadhati) => aadhati.id == id);
  }

  void removeAssociatedBuyer(String id) {
    associatedBuyers.removeWhere((buyer) => buyer.id == id);
  }

  void removeAssociatedDriver(String id) {
    associatedDrivers.removeWhere((driver) => driver.id == id);
  }

  void removeConsignment(String id) {
    consignments.removeWhere((consignment) => consignment.id == id);
  }
}
