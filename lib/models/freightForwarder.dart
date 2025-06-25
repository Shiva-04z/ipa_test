import 'package:apple_grower/models/driving_profile_model.dart';
import 'package:apple_grower/models/grower_model.dart';
import 'package:apple_grower/models/aadhati.dart';

class FreightForwarder {
  final String? id;
  final String name;
  final String contact;
  final String address;
  final String? licenseNo;
  final int? forwardingSinceYears;
  final String? licensesIssuingAuthority;
  final String? locationOnGoogle;
  final int? appleBoxesForwarded2023;
  final int? appleBoxesForwarded2024;
  final int? estimatedForwardingTarget2025;
  final String? tradeLicenseOfAadhatiAttached;
  final List<Aadhati>? associatedAadhatis;
  final List<Grower>? associatedGrowers;
  final List<DrivingProfile>?
      associatedPickupProviders; // Using DrivingProfile for simplicity
  final List<DrivingProfile>?
      associatedTruckServiceProviders; // Using DrivingProfile for simplicity
  final DateTime? createdAt;
  final DateTime? updatedAt;

  FreightForwarder({
    this.id,
    required this.name,
    required this.contact,
    required this.address,
    this.licenseNo,
    this.forwardingSinceYears,
    this.licensesIssuingAuthority,
    this.locationOnGoogle,
    this.appleBoxesForwarded2023,
    this.appleBoxesForwarded2024,
    this.estimatedForwardingTarget2025,
    this.tradeLicenseOfAadhatiAttached,
    this.associatedAadhatis = const [],
    this.associatedGrowers = const [],
    this.associatedPickupProviders = const [],
    this.associatedTruckServiceProviders = const [],
    required this.createdAt,
    required this.updatedAt,
  });

  factory FreightForwarder.fromJson(Map<String, dynamic> json) {
    return FreightForwarder(
      id: json['id'] as String,
      name: json['name'] as String,
      contact: json['contact'] as String,
      address: json['address'] as String,
      licenseNo: json['licenseNo'] as String,
      forwardingSinceYears: json['forwardingSinceYears'] as int,
      licensesIssuingAuthority: json['licensesIssuingAuthority'] as String,
      locationOnGoogle: json['locationOnGoogle'] as String?,
      appleBoxesForwarded2023: json['appleBoxesForwarded2023'] as int,
      appleBoxesForwarded2024: json['appleBoxesForwarded2024'] as int,
      estimatedForwardingTarget2025:
          json['estimatedForwardingTarget2025'] as int,
      tradeLicenseOfAadhatiAttached:
          json['tradeLicenseOfAadhatiAttached'] as String?,
      associatedAadhatis: (json['associatedAadhatis'] as List<dynamic>?)
              ?.map((e) => Aadhati.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const [],
      associatedGrowers: (json['associatedGrowers'] as List<dynamic>?)
              ?.map((e) => Grower.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const [],
      associatedPickupProviders: (json['associatedPickupProviders']
                  as List<dynamic>?)
              ?.map((e) => DrivingProfile.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const [],
      associatedTruckServiceProviders: (json['associatedTruckServiceProviders']
                  as List<dynamic>?)
              ?.map((e) => DrivingProfile.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const [],
      createdAt: DateTime.parse(json['createdAt'] as String),
      updatedAt: DateTime.parse(json['updatedAt'] as String),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'contact': contact,
      'address': address,
      'licenseNo': licenseNo,
      'forwardingSinceYears': forwardingSinceYears,
      'licensesIssuingAuthority': licensesIssuingAuthority,
      'locationOnGoogle': locationOnGoogle,
      'appleBoxesForwarded2023': appleBoxesForwarded2023,
      'appleBoxesForwarded2024': appleBoxesForwarded2024,
      'estimatedForwardingTarget2025': estimatedForwardingTarget2025,
      'tradeLicenseOfAadhatiAttached': tradeLicenseOfAadhatiAttached,
      'associatedAadhatis': associatedAadhatis?.map((e) => e.toJson()).toList(),
      'associatedGrowers': associatedGrowers?.map((e) => e.toJson()).toList(),
      'associatedPickupProviders':
          associatedPickupProviders?.map((e) => e.toJson()).toList(),
      'associatedTruckServiceProviders':
          associatedTruckServiceProviders?.map((e) => e.toJson()).toList(),
      'createdAt': createdAt?.toIso8601String(),
      'updatedAt': updatedAt?.toIso8601String(),
    };
  }

  FreightForwarder copyWith({
    String? id,
    String? name,
    String? contact,
    String? address,
    String? licenseNo,
    int? forwardingSinceYears,
    String? licensesIssuingAuthority,
    String? locationOnGoogle,
    int? appleBoxesForwarded2023,
    int? appleBoxesForwarded2024,
    int? estimatedForwardingTarget2025,
    String? tradeLicenseOfAadhatiAttached,
    List<Aadhati>? associatedAadhatis,
    List<Grower>? associatedGrowers,
    List<DrivingProfile>? associatedPickupProviders,
    List<DrivingProfile>? associatedTruckServiceProviders,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return FreightForwarder(
      id: id ?? this.id,
      name: name ?? this.name,
      contact: contact ?? this.contact,
      address: address ?? this.address,
      licenseNo: licenseNo ?? this.licenseNo,
      forwardingSinceYears: forwardingSinceYears ?? this.forwardingSinceYears,
      licensesIssuingAuthority:
          licensesIssuingAuthority ?? this.licensesIssuingAuthority,
      locationOnGoogle: locationOnGoogle ?? this.locationOnGoogle,
      appleBoxesForwarded2023:
          appleBoxesForwarded2023 ?? this.appleBoxesForwarded2023,
      appleBoxesForwarded2024:
          appleBoxesForwarded2024 ?? this.appleBoxesForwarded2024,
      estimatedForwardingTarget2025:
          estimatedForwardingTarget2025 ?? this.estimatedForwardingTarget2025,
      tradeLicenseOfAadhatiAttached:
          tradeLicenseOfAadhatiAttached ?? this.tradeLicenseOfAadhatiAttached,
      associatedAadhatis: associatedAadhatis ?? this.associatedAadhatis,
      associatedGrowers: associatedGrowers ?? this.associatedGrowers,
      associatedPickupProviders:
          associatedPickupProviders ?? this.associatedPickupProviders,
      associatedTruckServiceProviders: associatedTruckServiceProviders ??
          this.associatedTruckServiceProviders,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'Name': name,
      'Contact': contact,
      'Address': address,
      'License No': licenseNo,
      'Forwarding Since Years': forwardingSinceYears,
      'Licenses Issuing Authority': licensesIssuingAuthority,
      'Location on Google': locationOnGoogle,
      'Apple boxes forwarded in 2023': appleBoxesForwarded2023,
      'Apple boxes forwarded in 2024': appleBoxesForwarded2024,
      'Estimated Forwarding Target in 2025': estimatedForwardingTarget2025,
      'Trade License of Aadhati attached': tradeLicenseOfAadhatiAttached,
    };
  }
}
