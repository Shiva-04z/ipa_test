import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../core/global_role_loader.dart' as gld;
import '../../models/transport_model.dart';
import '../../models/grower_model.dart';
import '../../models/driving_profile_model.dart';
import '../../models/aadhati.dart';
import '../../models/freightForwarder.dart';
import '../../models/consignment_model.dart';

class TransportUnionController extends GetxController {
  // Add transportUnion-specific properties and methods here
  RxString unionName = ''.obs;
  RxString registrationNumber = ''.obs;

  final Map details = {
    'HCV': '${gld.globalTransport.value.noOfHeavyCommercialVehicles}',
    'MCV': '${gld.globalTransport.value.noOfMediumCommercialVehicles}',
    'LCV': '${gld.globalTransport.value.noOfLightCommercialVehicles}',
    'Vehicles': '${gld.globalTransport.value.noOfVehiclesRegistered}',
    'Boxes 2023': '${gld.globalTransport.value.appleBoxesTransported2023}',
    'Boxes 2024': '${gld.globalTransport.value.appleBoxesTransported2024}',
    'Drivers': '${gld.globalTransport.value.associatedDrivers?.length}',
  }.obs;

  final associatedDrivers = <DrivingProfile>[].obs;
  final associatedGrowers = <Grower>[].obs;
  final associatedAadhatis = <Aadhati>[].obs;
  final associatedFreightForwarders = <FreightForwarder>[].obs;
  final consignments = <Consignment>[].obs;



  void addAssociatedGrower(Grower grower) {
    if (!associatedGrowers.any((g) => g.id == grower.id)) {
      associatedGrowers.add(grower);
    }
  }

  void addAssociatedAadhatis(Aadhati aadhati) {
    if (!associatedAadhatis.any((g) => g.id == aadhati.id)) {
      associatedAadhatis.add(aadhati);
    }
  }
  void addAssociatedBuyers(FreightForwarder buyer) {
    if (!associatedFreightForwarders.any((g) => g.id == buyer.id)) {
      associatedFreightForwarders.add(buyer);
    }
  }
  void addAssociatedDrivers(DrivingProfile driver) {
    if (!associatedDrivers.any((g) => g.id == driver.id)) {
      associatedDrivers.add(driver);
    }
  }

  void addConsignments(Consignment consignment) {
    if (!consignments.any((g) => g.id == consignment.id)) {
      consignments.add(consignment);
    }
  }

  void removeAssociatedDriver(String id) {
    associatedDrivers.removeWhere((driver) => driver.id == id);
  }

  void removeAssociatedGrower(String id) {
    associatedGrowers.removeWhere((grower) => grower.id == id);
  }

  void removeAssociatedAadhati(String id) {
    associatedAadhatis.removeWhere((aadhati) => aadhati.id == id);
  }

  void removeAssociatedFreightForwarder(String id) {
    associatedFreightForwarders.removeWhere((ff) => ff.id == id);
  }







  @override
  void onInit() {
    super.onInit();
    // TODO: Load data from your data source
    loadData();
  }

  void loadData() {
    // TODO: Implement data loading logic
    // This is where you would typically fetch data from your backend or local storage
  }
}
