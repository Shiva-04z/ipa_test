import 'package:apple_grower/models/freightForwarder.dart';

import 'aadhati.dart';

import 'driving_profile_model.dart';

class Ladani {
  String? id;
  String? name;
  String? contact;
  String? address;
  String? nameOfTradingFirm;
  int? tradingSinceYears;
  String? firmType; // e.g., Prop. / Partnership, HUF, PL, LLP, OPC
  String? licenseNo;
  String? purchaseLocationAddress;
  String? licensesIssuingAPMC;
  String? locationOnGoogle;
  int? appleBoxesPurchased2023;
  int? appleBoxesPurchased2024;
  double? estimatedTarget2025;
  List<Aadhati>? associatedAaddhatis;
  List<FreightForwarder>? associatedBuyer;
  List<DrivingProfile>? truckServiceProviders;
  double? perBoxExpensesAfterBidding;

  Ladani({
    this.id,
    this.name,
    this.contact,
    this.address,
    this.nameOfTradingFirm,
    this.tradingSinceYears,
    this.firmType,
    this.licenseNo,
    this.purchaseLocationAddress,
    this.licensesIssuingAPMC,
    this.locationOnGoogle,
    this.appleBoxesPurchased2023,
    this.appleBoxesPurchased2024,
    this.estimatedTarget2025,
    this.associatedAaddhatis,
    this.associatedBuyer,
    this.truckServiceProviders,
    this.perBoxExpensesAfterBidding,
  });

  factory Ladani.fromJson(Map<String, dynamic> json) {
    return Ladani(
      id: json['id'] as String?,
      name: json['name'] as String?,
      contact: json['contact'] as String?,
      address: json['address'] as String?,
      nameOfTradingFirm: json['nameOfTradingFirm'] as String?,
      tradingSinceYears: json['tradingSinceYears'] as int?,
      firmType: json['firmType'] as String?,
      licenseNo: json['licenseNo'] as String?,
      purchaseLocationAddress: json['purchaseLocationAddress'] as String?,
      licensesIssuingAPMC: json['licensesIssuingAPMC'] as String?,
      locationOnGoogle: json['locationOnGoogle'] as String?,
      appleBoxesPurchased2023: json['appleBoxesPurchased2023'] as int?,
      appleBoxesPurchased2024: json['appleBoxesPurchased2024'] as int?,
      estimatedTarget2025: json['estimatedTarget2025'] as double?,
      associatedAaddhatis: (json['associatedAaddhatis'] as List<dynamic>?)
          ?.map((e) => Aadhati.fromJson(e as Map<String, dynamic>))
          .toList(),
      associatedBuyer: (json['associatedBuyer'] as List<dynamic>?)
          ?.map((e) => FreightForwarder.fromJson(e as Map<String, dynamic>))
          .toList(),
      truckServiceProviders: (json['truckServiceProviders'] as List<dynamic>?)
          ?.map((e) => DrivingProfile.fromJson(e as Map<String, dynamic>))
          .toList(),
      perBoxExpensesAfterBidding: json['perBoxExpensesAfterBidding'] as double?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'contact': contact,
      'address': address,
      'nameOfTradingFirm': nameOfTradingFirm,
      'tradingSinceYears': tradingSinceYears,
      'firmType': firmType,
      'licenseNo': licenseNo,
      'purchaseLocationAddress': purchaseLocationAddress,
      'licensesIssuingAPMC': licensesIssuingAPMC,
      'locationOnGoogle': locationOnGoogle,
      'appleBoxesPurchased2023': appleBoxesPurchased2023,
      'appleBoxesPurchased2024': appleBoxesPurchased2024,
      'estimatedTarget2025': estimatedTarget2025,
      'associatedAaddhatis':
          associatedAaddhatis?.map((e) => e.toJson()).toList(),
      'associatedBuyer': associatedBuyer?.map((e) => e.toJson()).toList(),
      'truckServiceProviders':
          truckServiceProviders?.map((e) => e.toJson()).toList(),
      'perBoxExpensesAfterBidding': perBoxExpensesAfterBidding,
    };
  }

  Ladani copyWith({
    String? id,
    String? name,
    String? contact,
    String? address,
    String? nameOfTradingFirm,
    int? tradingSinceYears,
    String? firmType,
    String? licenseNo,
    String? purchaseLocationAddress,
    String? licensesIssuingAPMC,
    String? locationOnGoogle,
    int? appleBoxesPurchased2023,
    int? appleBoxesPurchased2024,
    double? estimatedTarget2025,
    List<Aadhati>? associatedAaddhatis,
    List<FreightForwarder>? associatedBuyer,
    List<DrivingProfile>? truckServiceProviders,
    double? perBoxExpensesAfterBidding,
  }) {
    return Ladani(
      id: id ?? this.id,
      name: name ?? this.name,
      contact: contact ?? this.contact,
      address: address ?? this.address,
      nameOfTradingFirm: nameOfTradingFirm ?? this.nameOfTradingFirm,
      tradingSinceYears: tradingSinceYears ?? this.tradingSinceYears,
      firmType: firmType ?? this.firmType,
      licenseNo: licenseNo ?? this.licenseNo,
      purchaseLocationAddress:
          purchaseLocationAddress ?? this.purchaseLocationAddress,
      licensesIssuingAPMC: licensesIssuingAPMC ?? this.licensesIssuingAPMC,
      locationOnGoogle: locationOnGoogle ?? this.locationOnGoogle,
      appleBoxesPurchased2023:
          appleBoxesPurchased2023 ?? this.appleBoxesPurchased2023,
      appleBoxesPurchased2024:
          appleBoxesPurchased2024 ?? this.appleBoxesPurchased2024,
      estimatedTarget2025: estimatedTarget2025 ?? this.estimatedTarget2025,
      associatedAaddhatis: associatedAaddhatis ?? this.associatedAaddhatis,
      associatedBuyer: associatedBuyer ?? this.associatedBuyer,
      truckServiceProviders:
          truckServiceProviders ?? this.truckServiceProviders,
      perBoxExpensesAfterBidding:
          perBoxExpensesAfterBidding ?? this.perBoxExpensesAfterBidding,
    );
  }
}
