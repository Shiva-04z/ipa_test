import 'package:apple_grower/models/employee_model.dart';
import 'package:apple_grower/models/complaint_model.dart';

import 'driving_profile_model.dart';
import 'freightForwarder.dart';
import 'grower_model.dart';
import 'ladani_model.dart';
import 'consignment_model.dart';

// Gallery Image model for the gallery structure
class GalleryImage {
  final String name;
  final String url;

  GalleryImage({
    required this.name,
    required this.url,
  });

  factory GalleryImage.fromJson(Map<String, dynamic> json) {
    return GalleryImage(
      name: json['name'] as String? ?? 'default_img',
      url: json['url'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'url': url,
    };
  }
}

// Placeholder for Buyer model. Replace with actual Buyer model if available.
class Aadhati {
  String? id;
  String? name;
  String? contact;
  String? aadhar;
  String? apmc;
  String? apmc_ID;
  String? address;
  String? nameOfTradingFirm;
  int? tradingSinceYears;
  int? tradingExperience;
  String? firmType; // e.g., Prop. / Partnership, HUF, PL, LLP, OPC
  String? licenseNo;
  String? licenceNumber;
  String? salesPurchaseLocationName;
  String? locationOnGoogle;
  int? appleBoxesPurchased2023;
  int? appleBoxesPurchased2024;
  int? appleboxesT2;
  int? appleboxesT1;
  int? appleboxesT;
  double? estimatedTarget2025;
  bool? needTradeFinance;
  int? noOfAppleGrowersServed;
  int? applegrowersServed;
  List<Grower>? farmers;
  List<FreightForwarder>? forwardBuyers;
  List<Ladani>? ladanis;
  List<DrivingProfile>? truckServiceProviders;
  Map<String, Employee>? staff;
  List<GalleryImage>? gallery;
  List<String>? consignment_IDs;
  List<Consignment>? consignments;
  final List<Complaint> myComplaints;

  Aadhati({
    this.id,
    this.name,
    this.contact,
    this.aadhar,
    this.apmc,
    this.apmc_ID,
    this.nameOfTradingFirm,
    this.tradingSinceYears,
    this.tradingExperience,
    this.firmType,
    this.licenseNo,
    this.licenceNumber,
    this.salesPurchaseLocationName,
    this.locationOnGoogle,
    this.appleBoxesPurchased2023,
    this.appleBoxesPurchased2024,
    this.appleboxesT2,
    this.appleboxesT1,
    this.appleboxesT,
    this.estimatedTarget2025,
    this.needTradeFinance,
    this.noOfAppleGrowersServed,
    this.applegrowersServed,
    this.farmers,
    this.forwardBuyers,
    this.ladanis,
    this.truckServiceProviders,
    this.address,
    this.staff,
    this.gallery,
    this.consignment_IDs,
    this.consignments,
    this.myComplaints = const [],
  });

  factory Aadhati.fromJson(Map<String, dynamic> json) {
    return Aadhati(
      id: json['id'] as String?,
      name: json['name'] as String?,
      contact: json['contact'] as String?,
      aadhar: json['aadhar'] as String?,
      apmc: json['apmc'] as String?,
      apmc_ID: json['apmc_ID'] as String?,
      address: json['address'] as String?,
      nameOfTradingFirm: json['nameOfTradingFirm'] as String?,
      tradingSinceYears: json['tradingSinceYears'] as int?,
      tradingExperience: json['tradingExperience'] as int?,
      firmType: json['firmType'] as String?,
      licenseNo: json['licenseNo'] as String?,
      licenceNumber: json['licenceNumber'] as String?,
      salesPurchaseLocationName: json['salesPurchaseLocationName'] as String?,
      locationOnGoogle: json['locationOnGoogle'] as String?,
      appleBoxesPurchased2023: json['appleBoxesPurchased2023'] as int?,
      appleBoxesPurchased2024: json['appleBoxesPurchased2024'] as int?,
      appleboxesT2: json['appleboxesT2'] as int?,
      appleboxesT1: json['appleboxesT1'] as int?,
      appleboxesT: json['appleboxesT'] as int?,
      estimatedTarget2025: json['estimatedTarget2025'] as double?,
      needTradeFinance: json['needTradeFinance'] as bool?,
      noOfAppleGrowersServed: json['noOfAppleGrowersServed'] as int?,
      applegrowersServed: json['applegrowersServed'] as int?,
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
      gallery: (json['gallery'] as List<dynamic>?)
          ?.map((e) => GalleryImage.fromJson(e as Map<String, dynamic>))
          .toList(),
      consignment_IDs: (json['consignment_IDs'] as List<dynamic>?)
          ?.map((e) => e.toString())
          .toList(),
      consignments: (json['consignments'] as List<dynamic>?)
          ?.map((e) => Consignment.fromJson(e as Map<String, dynamic>))
          .toList(),
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
      'aadhar': aadhar,
      'apmc': apmc,
      'apmc_ID': apmc_ID,
      'address': address,
      'nameOfTradingFirm': nameOfTradingFirm,
      'tradingSinceYears': tradingSinceYears,
      'tradingExperience': tradingExperience,
      'firmType': firmType,
      'licenseNo': licenseNo,
      'licenceNumber': licenceNumber,
      'salesPurchaseLocationName': salesPurchaseLocationName,
      'locationOnGoogle': locationOnGoogle,
      'appleBoxesPurchased2023': appleBoxesPurchased2023,
      'appleBoxesPurchased2024': appleBoxesPurchased2024,
      'appleboxesT2': appleboxesT2,
      'appleboxesT1': appleboxesT1,
      'appleboxesT': appleboxesT,
      'estimatedTarget2025': estimatedTarget2025,
      'needTradeFinance': needTradeFinance,
      'noOfAppleGrowersServed': noOfAppleGrowersServed,
      'applegrowersServed': applegrowersServed,
      'farmers': farmers?.map((e) => e.toJson()).toList(),
      'forwardBuyers': forwardBuyers?.map((e) => e.toJson()).toList(),
      'ladanis': ladanis?.map((e) => e.toJson()).toList(),
      'truckServiceProviders':
          truckServiceProviders?.map((e) => e.toJson()).toList(),
      'staff': staff?.map((key, value) => MapEntry(key, value.toJson())),
      'gallery': gallery?.map((e) => e.toJson()).toList(),
      'consignment_IDs': consignment_IDs,
      'consignments': consignments?.map((e) => e.toJson()).toList(),
      'myComplaints': myComplaints.map((e) => e.toJson()).toList(),
    };
  }

  Aadhati copyWith({
    String? id,
    String? name,
    String? contact,
    String? aadhar,
    String? apmc,
    String? apmc_ID,
    String? address,
    String? nameOfTradingFirm,
    int? tradingSinceYears,
    int? tradingExperience,
    String? firmType,
    String? licenseNo,
    String? licenceNumber,
    String? salesPurchaseLocationName,
    String? locationOnGoogle,
    int? appleBoxesPurchased2023,
    int? appleBoxesPurchased2024,
    int? appleboxesT2,
    int? appleboxesT1,
    int? appleboxesT,
    double? estimatedTarget2025,
    bool? needTradeFinance,
    int? noOfAppleGrowersServed,
    int? applegrowersServed,
    List<Grower>? farmers,
    List<FreightForwarder>? forwardBuyers,
    List<Ladani>? ladanis,
    List<DrivingProfile>? truckServiceProviders,
    Map<String, Employee>? staff,
    List<GalleryImage>? gallery,
    List<String>? consignment_IDs,
    List<Consignment>? consignments,
    List<Complaint>? myComplaints,
  }) {
    return Aadhati(
      id: id ?? this.id,
      name: name ?? this.name,
      contact: contact ?? this.contact,
      aadhar: aadhar ?? this.aadhar,
      apmc: apmc ?? this.apmc,
      apmc_ID: apmc_ID ?? this.apmc_ID,
      address: address ?? this.address,
      nameOfTradingFirm: nameOfTradingFirm ?? this.nameOfTradingFirm,
      tradingSinceYears: tradingSinceYears ?? this.tradingSinceYears,
      tradingExperience: tradingExperience ?? this.tradingExperience,
      firmType: firmType ?? this.firmType,
      licenseNo: licenseNo ?? this.licenseNo,
      licenceNumber: licenceNumber ?? this.licenceNumber,
      salesPurchaseLocationName:
          salesPurchaseLocationName ?? this.salesPurchaseLocationName,
      locationOnGoogle: locationOnGoogle ?? this.locationOnGoogle,
      appleBoxesPurchased2023:
          appleBoxesPurchased2023 ?? this.appleBoxesPurchased2023,
      appleBoxesPurchased2024:
          appleBoxesPurchased2024 ?? this.appleBoxesPurchased2024,
      appleboxesT2: appleboxesT2 ?? this.appleboxesT2,
      appleboxesT1: appleboxesT1 ?? this.appleboxesT1,
      appleboxesT: appleboxesT ?? this.appleboxesT,
      estimatedTarget2025: estimatedTarget2025 ?? this.estimatedTarget2025,
      needTradeFinance: needTradeFinance ?? this.needTradeFinance,
      noOfAppleGrowersServed:
          noOfAppleGrowersServed ?? this.noOfAppleGrowersServed,
      applegrowersServed: applegrowersServed ?? this.applegrowersServed,
      farmers: farmers ?? this.farmers,
      forwardBuyers: forwardBuyers ?? this.forwardBuyers,
      ladanis: ladanis ?? this.ladanis,
      truckServiceProviders:
          truckServiceProviders ?? this.truckServiceProviders,
      staff: staff ?? this.staff,
      gallery: gallery ?? this.gallery,
      consignment_IDs: consignment_IDs ?? this.consignment_IDs,
      consignments: consignments ?? this.consignments,
      myComplaints: myComplaints ?? this.myComplaints,
    );
  }
}
