import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../models/aadhati.dart';
import '../../models/ladani_model.dart';

class AmpcOfficeController extends GetxController {
  // Filter state
  final RxString selectedFilter = 'Office Info'.obs;

  // AMPC Office Info
  final RxString officeName = 'Himachal Pradesh AMPC Office'.obs;
  final RxString officeAddress = 'Shimla, Himachal Pradesh'.obs;
  final RxString officeContact = '9876543210'.obs;
  final RxString officeEmail = 'ampc@himachal.gov.in'.obs;
  final RxString officeLicenseNo = 'AMPC123456'.obs;
  RxBool flag= false.obs;

  // Approved Aadhatis
  final RxList<Aadhati> approvedAadhatis = <Aadhati>[].obs;

  // Blacklisted Aadhatis
  final RxList<Aadhati> blacklistedAadhatis = <Aadhati>[].obs;

  // Approved Ladanis
  final RxList<Ladani> approvedLadanis = <Ladani>[].obs;

  // Blacklisted Ladanis
  final RxList<Ladani> blacklistedLadanis = <Ladani>[].obs;

  @override
  void onInit() {
    super.onInit();
    loadData();
  }

  void loadData() {}

    void addAdhati(Aadhati aadhati){
    if (flag.value) {
      if (!approvedAadhatis.any((g) => g.id == aadhati.id)) {
        approvedAadhatis.add(aadhati);
        removeBlacklistedAadhati(aadhati.id!);
      }}else{
      if (!blacklistedAadhatis.any((g) => g.id == aadhati.id)) {
        blacklistedAadhatis.add(aadhati);
        removeApprovedAadhati(aadhati.id!);
    }
    }}

  void addLadani(Ladani ladani){
    if (flag.value) {
      if (!approvedLadanis.any((g) => g.id == ladani.id)) {
        approvedLadanis.add(ladani);
        removeBlacklistedLadani(ladani.id!);
      }}else{
      if (!blacklistedLadanis.any((g) => g.id == ladani.id)) {
        blacklistedLadanis.add(ladani);
        removeApprovedLadani(ladani.id!);
      }
    }}




  void removeApprovedAadhati(String id) {
    approvedAadhatis.removeWhere((aadhati) => aadhati.id == id);
  }

  void removeBlacklistedAadhati(String id) {
    blacklistedAadhatis.removeWhere((aadhati) => aadhati.id == id);
  }

  void removeApprovedLadani(String id) {
    approvedLadanis.removeWhere((ladani) => ladani.id == id);
  }

  void removeBlacklistedLadani(String id) {
    blacklistedLadanis.removeWhere((ladani) => ladani.id == id);
  }

  void setFilter(String filter) {
    selectedFilter.value = filter;
  }
}
