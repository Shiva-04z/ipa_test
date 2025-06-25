import 'package:apple_grower/models/grower_model.dart';
import 'package:apple_grower/models/complaint_model.dart';
import 'package:apple_grower/models/pack_house_model.dart';
import 'package:apple_grower/models/driving_profile_model.dart';
import 'package:apple_grower/models/transport_model.dart';

class HpmcCollectionCenter {
  final String? id;
  final String? HPMCname;
  final String? operatorName;
  final String? cellNo;
  final String? aadharNo;
  final String? licenseNo;
  final String? operatingSince;
  final String?  location;
  final int? boxesTransported2023;
  final int?  boxesTransported2024;
  final double? target2025;
  final List<Grower> associatedGrowers;
  final List<Complaint> myComplaints;
  final List<PackHouse> associatedPackHouses;
  final List<DrivingProfile> associatedDrivers;
  final List<Transport> associatedTransportUnions;

  HpmcCollectionCenter({
  this.id,
 this.HPMCname,
 this.operatorName,
 this.cellNo,
 this.aadharNo,
   this.licenseNo,
  this.operatingSince,
  this.location,
 this.boxesTransported2023,
 this.boxesTransported2024,
 this.target2025,
    this.associatedGrowers = const [],
    this.myComplaints = const [],
    this.associatedPackHouses = const [],
    this.associatedDrivers = const [],
    this.associatedTransportUnions = const [],
  });

  factory HpmcCollectionCenter.fromJson(Map<String, dynamic> json) {
    return HpmcCollectionCenter(
      id: json['id'] as String,
      HPMCname: json['HPMCname'] as String,
      operatorName: json['operatorName'] as String,
      cellNo: json['cellNo'] as String,
      aadharNo: json['adharNo'] as String,
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
      'HPMCname': HPMCname,
      'operatorName': operatorName,
      'cellNo': cellNo,
      'adharNo': aadharNo,
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
    String? HPMCname,
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
      HPMCname: HPMCname ?? this.HPMCname,
      operatorName: operatorName ?? this.operatorName,
      cellNo: cellNo ?? this.cellNo,
      aadharNo: adharNo ?? this.aadharNo,
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
