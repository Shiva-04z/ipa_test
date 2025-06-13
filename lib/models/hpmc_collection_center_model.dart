import 'package:apple_grower/models/grower_model.dart';
import 'package:apple_grower/models/complaint_model.dart';
import 'package:apple_grower/models/pack_house_model.dart';
import 'package:apple_grower/models/driving_profile_model.dart';
import 'package:apple_grower/models/transport_model.dart';

class HpmcCollectionCenter {
  final String id;
  final String contactName;
  final String operatorName;
  final String cellNo;
  final String adharNo;
  final String licenseNo;
  final String operatingSince;
  final String location;
  final int boxesTransported2023;
  final int boxesTransported2024;
  final double target2025;
  final List<Grower> associatedGrowers;
  final List<Complaint> myComplaints;
  final List<PackHouse> associatedPackHouses;
  final List<DrivingProfile> associatedDrivers;
  final List<Transport> associatedTransportUnions;

  HpmcCollectionCenter({
    required this.id,
    required this.contactName,
    required this.operatorName,
    required this.cellNo,
    required this.adharNo,
    required this.licenseNo,
    required this.operatingSince,
    required this.location,
    required this.boxesTransported2023,
    required this.boxesTransported2024,
    required this.target2025,
    this.associatedGrowers = const [],
    this.myComplaints = const [],
    this.associatedPackHouses = const [],
    this.associatedDrivers = const [],
    this.associatedTransportUnions = const [],
  });

  factory HpmcCollectionCenter.fromJson(Map<String, dynamic> json) {
    return HpmcCollectionCenter(
      id: json['id'] as String,
      contactName: json['contactName'] as String,
      operatorName: json['operatorName'] as String,
      cellNo: json['cellNo'] as String,
      adharNo: json['adharNo'] as String,
      licenseNo: json['licenseNo'] as String,
      operatingSince: json['operatingSince'] as String,
      location: json['location'] as String,
      boxesTransported2023: json['boxesTransported2023'] as int,
      boxesTransported2024: json['boxesTransported2024'] as int,
      target2025: json['target2025'] as double,
      associatedGrowers: (json['associatedGrowers'] as List<dynamic>?)
              ?.map((e) => Grower.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [],
      myComplaints: (json['myComplaints'] as List<dynamic>?)
              ?.map((e) => Complaint.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [],
      associatedPackHouses: (json['associatedPackHouses'] as List<dynamic>?)
              ?.map((e) => PackHouse.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [],
      associatedDrivers: (json['associatedDrivers'] as List<dynamic>?)
              ?.map((e) => DrivingProfile.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [],
      associatedTransportUnions:
          (json['associatedTransportUnions'] as List<dynamic>?)
                  ?.map((e) => Transport.fromJson(e as Map<String, dynamic>))
                  .toList() ??
              [],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'contactName': contactName,
      'operatorName': operatorName,
      'cellNo': cellNo,
      'adharNo': adharNo,
      'licenseNo': licenseNo,
      'operatingSince': operatingSince,
      'location': location,
      'boxesTransported2023': boxesTransported2023,
      'boxesTransported2024': boxesTransported2024,
      'target2025': target2025,
      'associatedGrowers': associatedGrowers.map((e) => e.toJson()).toList(),
      'myComplaints': myComplaints.map((e) => e.toJson()).toList(),
      'associatedPackHouses':
          associatedPackHouses.map((e) => e.toJson()).toList(),
      'associatedDrivers': associatedDrivers.map((e) => e.toJson()).toList(),
      'associatedTransportUnions':
          associatedTransportUnions.map((e) => e.toJson()).toList(),
    };
  }

  HpmcCollectionCenter copyWith({
    String? id,
    String? contactName,
    String? operatorName,
    String? cellNo,
    String? adharNo,
    String? licenseNo,
    String? operatingSince,
    String? location,
    int? boxesTransported2023,
    int? boxesTransported2024,
    double? target2025,
    List<Grower>? associatedGrowers,
    List<Complaint>? myComplaints,
    List<PackHouse>? associatedPackHouses,
    List<DrivingProfile>? associatedDrivers,
    List<Transport>? associatedTransportUnions,
  }) {
    return HpmcCollectionCenter(
      id: id ?? this.id,
      contactName: contactName ?? this.contactName,
      operatorName: operatorName ?? this.operatorName,
      cellNo: cellNo ?? this.cellNo,
      adharNo: adharNo ?? this.adharNo,
      licenseNo: licenseNo ?? this.licenseNo,
      operatingSince: operatingSince ?? this.operatingSince,
      location: location ?? this.location,
      boxesTransported2023: boxesTransported2023 ?? this.boxesTransported2023,
      boxesTransported2024: boxesTransported2024 ?? this.boxesTransported2024,
      target2025: target2025 ?? this.target2025,
      associatedGrowers: associatedGrowers ?? this.associatedGrowers,
      myComplaints: myComplaints ?? this.myComplaints,
      associatedPackHouses: associatedPackHouses ?? this.associatedPackHouses,
      associatedDrivers: associatedDrivers ?? this.associatedDrivers,
      associatedTransportUnions:
          associatedTransportUnions ?? this.associatedTransportUnions,
    );
  }
}
