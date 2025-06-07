import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../models/consignment_model.dart';

class HPPoliceController extends GetxController {
  // Police Station Info
  final RxString stationName = 'Shimla Police Station'.obs;
  final RxString stationAddress = 'Shimla, Himachal Pradesh'.obs;
  final RxString stationContact = '9876543210'.obs;
  final RxString stationEmail = 'shimla.police@hp.gov.in'.obs;
  final RxString stationCode = 'PS123456'.obs;

  // Posts
  final RxList<Map<String, dynamic>> posts = <Map<String, dynamic>>[].obs;

  // Consignments
  final RxList<Consignment> consignments = <Consignment>[].obs;

  @override
  void onInit() {
    super.onInit();
    loadData();
  }

  void loadData() {
    // TODO: Load data from API
    // For now, using sample data
    posts.addAll([
      {
        'id': 'POST001',
        'title': 'Check Post - Shimla',
        'location': 'Shimla Bypass',
        'officerInCharge': 'Inspector Rajesh Kumar',
        'contact': '9876543211',
        'status': 'Active',
        'createdAt': DateTime.now().subtract(Duration(days: 5)),
      },
      {
        'id': 'POST002',
        'title': 'Check Post - Kullu',
        'location': 'Kullu Valley Road',
        'officerInCharge': 'Inspector Suresh Kumar',
        'contact': '9876543212',
        'status': 'Active',
        'createdAt': DateTime.now().subtract(Duration(days: 3)),
      },
    ]);

    consignments.addAll([
      Consignment(
        id: 'CONS001',
        quality: 'Premium',
        category: 'A',
        numberOfBoxes: 100,
        numberOfPiecesInBox: 20,
        pickupOption: 'Own',
        shippingFrom: 'Kotkhai',
        shippingTo: 'Delhi',
        commissionAgent: null,
        corporateCompany: null,
        packingHouse: null,
        hasOwnCrates: true,
        status: 'In Transit',
        driver: null,
        createdAt: DateTime.now().subtract(Duration(days: 2)),
        updatedAt: DateTime.now(),
      ),
    ]);
  }

  void addPost(Map<String, dynamic> post) {
    posts.add(post);
  }

  void removePost(String id) {
    posts.removeWhere((post) => post['id'] == id);
  }

  void addConsignment(Consignment consignment) {
    consignments.add(consignment);
  }

  void removeConsignment(String id) {
    consignments.removeWhere((consignment) => consignment.id == id);
  }
}
