import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../core/globals.dart' as glb;
import '../../models/driving_profile_model.dart';
import '../../models/consignment_model.dart';
import '../../models/transport_model.dart';
import '../../models/grower_model.dart';
import '../../models/pack_house_model.dart';
import '../../models/ladani_model.dart';

class DriverController extends GetxController {
  final details = Rx<DrivingProfile>(DrivingProfile(
    id: '',
    name: '',
    contact: '',
    drivingLicenseNo: '',
    vehicleRegistrationNo: '',
    noOfTyres: 0,
  ));
  final associatedTransportUnions = <Transport>[].obs;
  final myJobs = <Consignment>[].obs;
  final associatedGrowers = <Grower>[].obs;
  final associatedPackhouses = <PackHouse>[].obs;
  final associatedBuyers = <Ladani>[].obs;

  @override
  void onInit() {
    super.onInit();
    // Initialize with sample data
    glb.roleType.value="Driver";
    details.value = DrivingProfile(
      id: 'DRV1',
      name: 'Sample Driver',
      contact: '+91 9988776655',
      drivingLicenseNo: 'DL1234567890',
      vehicleRegistrationNo: 'HP99A9999',
      noOfTyres: 6,
    );

    associatedTransportUnions.add(Transport(
      id: 'TU1',
      name: 'Transport Union A',
      contact: '+91 1122334455',
      address: 'Union Office, Street 1',
    ));

    myJobs.add(Consignment(
      id: 'CON1',
      quality: 'A Grade',
      category: 'Category A',
      numberOfBoxes: 500,
      numberOfPiecesInBox: 100,
      pickupOption: 'Own',
      shippingFrom: 'Shimla',
      shippingTo: 'Delhi',
      commissionAgent: null,
      status: 'In Transit',
      driver: null,
      corporateCompany: null,
      packingHouse: null,
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
    ));
  }

  void addConsignment(Consignment consignment) {
    if (!myJobs.any((c) => c.id == consignment.id)) {
      myJobs.add(consignment);
    }
  }

  void addTransportUnion(Transport union) {
    if (!associatedTransportUnions.any((c) => c.id == union.id)) {
      associatedTransportUnions.add(union);
    }
  }

  void removeAssociatedTransportUnion(String id) {
    associatedTransportUnions.removeWhere((union) => union.id == id);
  }

  void removeMyJob(String id) {
    myJobs.removeWhere((job) => job.id == id);
  }

  void addAssociatedGrower(Grower grower) {
    if (!associatedGrowers.any((g) => g.id == grower.id)) {
      associatedGrowers.add(grower);
    }
  }

  void removeAssociatedGrower(String id) {
    associatedGrowers.removeWhere((grower) => grower.id == id);
  }

  void addAssociatedPackhouse(PackHouse packhouse) {
    if (!associatedPackhouses.any((p) => p.id == packhouse.id)) {
      associatedPackhouses.add(packhouse);
    }
  }

  void removeAssociatedPackhouse(String id) {
    associatedPackhouses.removeWhere((packhouse) => packhouse.id == id);
  }

  void addAssociatedBuyer(Ladani buyer) {
    if (!associatedBuyers.any((b) => b.id == buyer.id)) {
      associatedBuyers.add(buyer);
    }
  }

  void removeAssociatedBuyer(String id) {
    associatedBuyers.removeWhere((buyer) => buyer.id == id);
  }
}
