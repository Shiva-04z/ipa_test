import 'package:apple_grower/models/employee_model.dart';
import 'package:apple_grower/models/complaint_model.dart';

import 'driving_profile_model.dart';
import 'freightForwarder.dart';
import 'grower_model.dart';
import 'ladani_model.dart';

// Placeholder for Buyer model. Replace with actual Buyer model if available.
class Aadhati {
  String? id;
  String? name;
  String? contact;
  String? apmc;
  String? address;
  String? nameOfTradingFirm;
  int? tradingSinceYears;
  String? firmType; // e.g., Prop. / Partnership, HUF, PL, LLP, OPC
  String? licenseNo;
  String? salesPurchaseLocationName;
  String? locationOnGoogle;
  int? appleBoxesPurchased2023;
  int? appleBoxesPurchased2024;
  double? estimatedTarget2025;
  bool? needTradeFinance;
  int? noOfAppleGrowersServed;
  List<Grower>? farmers;
  List<FreightForwarder>? forwardBuyers;
  List<Ladani>? ladanis;
  List<DrivingProfile>? truckServiceProviders;
  Map<String, Employee>? staff;
  final List<Complaint> myComplaints;

  Aadhati({
    this.id,
    this.name,
    this.contact,
    this.apmc,
    this.nameOfTradingFirm,
    this.tradingSinceYears,
    this.firmType,
    this.licenseNo,
    this.salesPurchaseLocationName,
    this.locationOnGoogle,
    this.appleBoxesPurchased2023,
    this.appleBoxesPurchased2024,
    this.estimatedTarget2025,
    this.needTradeFinance,
    this.noOfAppleGrowersServed,
    this.farmers,
    this.forwardBuyers,
    this.ladanis,
    this.truckServiceProviders,
    this.address,
    this.staff,
    this.myComplaints = const [],
  });

  factory Aadhati.fromJson(Map<String, dynamic> json) {
    return Aadhati(
      id: json['id'] as String?,
      name: json['name'] as String?,
      contact: json['contact'] as String?,
      apmc: json['ampc'] as String?,
      address: json['address'] as String?,
      nameOfTradingFirm: json['nameOfTradingFirm'] as String?,
      tradingSinceYears: json['tradingSinceYears'] as int?,
      firmType: json['firmType'] as String?,
      licenseNo: json['licenseNo'] as String?,
      salesPurchaseLocationName: json['salesPurchaseLocationName'] as String?,
      locationOnGoogle: json['locationOnGoogle'] as String?,
      appleBoxesPurchased2023: json['appleBoxesPurchased2023'] as int?,
      appleBoxesPurchased2024: json['appleBoxesPurchased2024'] as int?,
      estimatedTarget2025: json['estimatedTarget2025'] as double?,
      needTradeFinance: json['needTradeFinance'] as bool?,
      noOfAppleGrowersServed: json['noOfAppleGrowersServed'] as int?,
      farmers: (json['farmers'] as List<dynamic>?)
          ?.map((e) => Grower.fromJson(e as Map<String, dynamic>))
          .toList(),
      forwardBuyers: (json['forwardBuyers'] as List<dynamic>?)
          ?.map((e) => FreightForwarder.fromJson(e as Map<String, dynamic>))
          .toList(),
      ladanis: (json['ladanis'] as List<dynamic>?)
          ?.map((e) => Ladani.fromJson(e as Map<String, dynamic>))
          .toList(),
      truckServiceProviders: (json['truckServiceProviders'] as List<dynamic>?)
          ?.map((e) => DrivingProfile.fromJson(e as Map<String, dynamic>))
          .toList(),
      staff: (json['staff'] as Map<String, dynamic>?)?.map(
        (key, value) =>
            MapEntry(key, Employee.fromJson(value as Map<String, dynamic>)),
      ),
      myComplaints: (json['myComplaints'] as List<dynamic>?)
              ?.map((e) => Complaint.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'contact': contact,
      'apmc': apmc,
      'address': address,
      'nameOfTradingFirm': nameOfTradingFirm,
      'tradingSinceYears': tradingSinceYears,
      'firmType': firmType,
      'licenseNo': licenseNo,
      'salesPurchaseLocationName': salesPurchaseLocationName,
      'locationOnGoogle': locationOnGoogle,
      'appleBoxesPurchased2023': appleBoxesPurchased2023,
      'appleBoxesPurchased2024': appleBoxesPurchased2024,
      'estimatedTarget2025': estimatedTarget2025,
      'needTradeFinance': needTradeFinance,
      'noOfAppleGrowersServed': noOfAppleGrowersServed,
      'farmers': farmers?.map((e) => e.toJson()).toList(),
      'forwardBuyers': forwardBuyers?.map((e) => e.toJson()).toList(),
      'ladanis': ladanis?.map((e) => e.toJson()).toList(),
      'truckServiceProviders':
          truckServiceProviders?.map((e) => e.toJson()).toList(),
      'staff': staff?.map((key, value) => MapEntry(key, value.toJson())),
      'myComplaints': myComplaints.map((e) => e.toJson()).toList(),
    };
  }

  Aadhati copyWith({
    String? id,
    String? name,
    String? contact,
    String? apmc,
    String? address,
    String? nameOfTradingFirm,
    int? tradingSinceYears,
    String? firmType,
    String? licenseNo,
    String? salesPurchaseLocationName,
    String? locationOnGoogle,
    int? appleBoxesPurchased2023,
    int? appleBoxesPurchased2024,
    double? estimatedTarget2025,
    bool? needTradeFinance,
    int? noOfAppleGrowersServed,
    List<Grower>? farmers,
    List<FreightForwarder>? forwardBuyers,
    List<Ladani>? ladanis,
    List<DrivingProfile>? truckServiceProviders,
    Map<String, Employee>? staff,
    List<Complaint>? myComplaints,
  }) {
    return Aadhati(
      id: id ?? this.id,
      name: name ?? this.name,
      contact: contact ?? this.contact,
      apmc: apmc ?? this.apmc,
      address: address ?? this.address,
      nameOfTradingFirm: nameOfTradingFirm ?? this.nameOfTradingFirm,
      tradingSinceYears: tradingSinceYears ?? this.tradingSinceYears,
      firmType: firmType ?? this.firmType,
      licenseNo: licenseNo ?? this.licenseNo,
      salesPurchaseLocationName:
          salesPurchaseLocationName ?? this.salesPurchaseLocationName,
      locationOnGoogle: locationOnGoogle ?? this.locationOnGoogle,
      appleBoxesPurchased2023:
          appleBoxesPurchased2023 ?? this.appleBoxesPurchased2023,
      appleBoxesPurchased2024:
          appleBoxesPurchased2024 ?? this.appleBoxesPurchased2024,
      estimatedTarget2025: estimatedTarget2025 ?? this.estimatedTarget2025,
      needTradeFinance: needTradeFinance ?? this.needTradeFinance,
      noOfAppleGrowersServed:
          noOfAppleGrowersServed ?? this.noOfAppleGrowersServed,
      farmers: farmers ?? this.farmers,
      forwardBuyers: forwardBuyers ?? this.forwardBuyers,
      ladanis: ladanis ?? this.ladanis,
      truckServiceProviders:
          truckServiceProviders ?? this.truckServiceProviders,
      staff: staff ?? this.staff,
      myComplaints: myComplaints ?? this.myComplaints,
    );
  }
}
