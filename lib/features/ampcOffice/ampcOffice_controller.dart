import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../models/aadhati.dart';
import '../../models/ladani_model.dart';

class AmpcOfficeController extends GetxController {
  // AMPC Office Info
  final RxString officeName = 'Himachal Pradesh AMPC Office'.obs;
  final RxString officeAddress = 'Shimla, Himachal Pradesh'.obs;
  final RxString officeContact = '9876543210'.obs;
  final RxString officeEmail = 'ampc@himachal.gov.in'.obs;
  final RxString officeLicenseNo = 'AMPC123456'.obs;

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

  void loadData() {
    // TODO: Load data from API
    // For now, using sample data
    approvedAadhatis.addAll([
      Aadhati(
        id: 'Aadhati1',
        name: 'Himachal Traders Pvt Ltd',
        contact: '9876543212',
        nameOfTradingFirm: 'Himachal Traders',
        tradingSinceYears: 15,
        firmType: 'Partnership',
        licenseNo: 'LIC123456',
        salesPurchaseLocationName: 'Kotkhai Market',
        locationOnGoogle: 'Kotkhai, Himachal Pradesh',
        appleBoxesPurchased2023: 5000,
        appleBoxesPurchased2024: 6000,
        estimatedTarget2025: 7000.0,
        needTradeFinance: true,
        noOfAppleGrowersServed: 25,
      ),
    ]);

    blacklistedAadhatis.addAll([
      Aadhati(
        id: 'Aadhati2',
        name: 'Blacklisted Traders',
        contact: '9876543213',
        nameOfTradingFirm: 'Blacklisted Firm',
        tradingSinceYears: 5,
        firmType: 'Proprietorship',
        licenseNo: 'LIC789012',
        salesPurchaseLocationName: 'Shimla Market',
        locationOnGoogle: 'Shimla, Himachal Pradesh',
        appleBoxesPurchased2023: 1000,
        appleBoxesPurchased2024: 0,
        estimatedTarget2025: 0.0,
        needTradeFinance: false,
        noOfAppleGrowersServed: 5,
      ),
    ]);

    approvedLadanis.addAll([
      Ladani(
        id: 'LADANI001',
        name: 'Himachal Apple Corporation',
        contact: '9876543214',
        address: 'Industrial Area, Shimla, Himachal Pradesh',
        nameOfTradingFirm: 'Himachal Apple Corp',
        tradingSinceYears: 20,
        firmType: 'Private Limited',
        licenseNo: 'CORP123456',
        purchaseLocationAddress: 'Industrial Area, Shimla',
        licensesIssuingAPMC: 'Shimla APMC',
        locationOnGoogle: 'Shimla Industrial Area',
        appleBoxesPurchased2023: 10000,
        appleBoxesPurchased2024: 12000,
        estimatedTarget2025: 15000.0,
        perBoxExpensesAfterBidding: 150.0,
      ),
    ]);

    blacklistedLadanis.addAll([
      Ladani(
        id: 'LADANI002',
        name: 'Blacklisted Corporation',
        contact: '9876543215',
        address: 'Industrial Area, Delhi',
        nameOfTradingFirm: 'Blacklisted Corp',
        tradingSinceYears: 10,
        firmType: 'Private Limited',
        licenseNo: 'CORP789012',
        purchaseLocationAddress: 'Industrial Area, Delhi',
        licensesIssuingAPMC: 'Delhi APMC',
        locationOnGoogle: 'Delhi Industrial Area',
        appleBoxesPurchased2023: 5000,
        appleBoxesPurchased2024: 0,
        estimatedTarget2025: 0.0,
        perBoxExpensesAfterBidding: 0.0,
      ),
    ]);
  }

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
}
