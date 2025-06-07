import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../models/driving_profile_model.dart';
import '../../models/consignment_model.dart';
import '../../models/transport_model.dart';

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

  @override
  void onInit() {
    super.onInit();
    // Initialize with sample data
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

  void removeAssociatedTransportUnion(String id) {
    associatedTransportUnions.removeWhere((union) => union.id == id);
  }

  void removeMyJob(String id) {
    myJobs.removeWhere((job) => job.id == id);
  }
}
