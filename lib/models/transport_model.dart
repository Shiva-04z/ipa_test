import 'package:apple_grower/models/freightForwarder.dart';
import 'aadhati.dart';
import 'driving_profile_model.dart';
import 'grower_model.dart';
import 'package:apple_grower/models/complaint_model.dart';

class Transport {
  String? id;
  final String name;
  final String contact;
  final String address;
  String? nameOfTheTransportUnion;
  String? transportUnionRegistrationNo;
  int? noOfVehiclesRegistered;
  String? transportUnionPresidentAdharId;
  String? transportUnionSecretaryAdhar;
  int? noOfLightCommercialVehicles;
  int? noOfMediumCommercialVehicles;
  int? noOfHeavyCommercialVehicles;
  int? appleBoxesTransported2023;
  int? appleBoxesTransported2024;
  double? estimatedTarget2025;
  String? statesDrivenThrough;
  List<Grower>? appleGrowers;
  List<Aadhati>? aadhatis;
  List<FreightForwarder>? buyers;
  List<DrivingProfile>? associatedDrivers;
  final List<Complaint> myComplaints;

  Transport({
    required this.name,
    required this.contact,
    required this.address,
    this.id,
    this.nameOfTheTransportUnion,
    this.transportUnionRegistrationNo,
    this.noOfVehiclesRegistered,
    this.transportUnionPresidentAdharId,
    this.transportUnionSecretaryAdhar,
    this.noOfLightCommercialVehicles,
    this.noOfMediumCommercialVehicles,
    this.noOfHeavyCommercialVehicles,
    this.appleBoxesTransported2023,
    this.appleBoxesTransported2024,
    this.estimatedTarget2025,
    this.statesDrivenThrough,
    this.appleGrowers,
    this.aadhatis,
    this.buyers,
    this.associatedDrivers,
    this.myComplaints = const [],
  });

  factory Transport.fromJson(Map<String, dynamic> json) {
    return Transport(
      id: json['id'] as String?,
      name: json['name'] as String,
      contact: json['contact'] as String,
      address: json['address'] as String,
      nameOfTheTransportUnion: json['nameOfTheTransportUnion'] as String?,
      transportUnionRegistrationNo:
          json['transportUnionRegistrationNo'] as String?,
      noOfVehiclesRegistered: json['noOfVehiclesRegistered'] as int?,
      transportUnionPresidentAdharId:
          json['transportUnionPresidentAdharId'] as String?,
      transportUnionSecretaryAdhar:
          json['transportUnionSecretaryAdhar'] as String?,
      noOfLightCommercialVehicles: json['noOfLightCommercialVehicles'] as int?,
      noOfMediumCommercialVehicles:
          json['noOfMediumCommercialVehicles'] as int?,
      noOfHeavyCommercialVehicles: json['noOfHeavyCommercialVehicles'] as int?,
      appleBoxesTransported2023: json['appleBoxesTransported2023'] as int?,
      appleBoxesTransported2024: json['appleBoxesTransported2024'] as int?,
      estimatedTarget2025: json['estimatedTarget2025'] as double?,
      statesDrivenThrough: json['statesDrivenThrough'] as String?,
      appleGrowers: (json['appleGrowers'] as List<dynamic>?)
          ?.map((e) => Grower.fromJson(e as Map<String, dynamic>))
          .toList(),
      aadhatis: (json['aadhatis'] as List<dynamic>?)
          ?.map((e) => Aadhati.fromJson(e as Map<String, dynamic>))
          .toList(),
      buyers: (json['buyers'] as List<dynamic>?)
          ?.map((e) => FreightForwarder.fromJson(e as Map<String, dynamic>))
          .toList(),
      associatedDrivers: (json['associatedDrivers'] as List<dynamic>?)
          ?.map((e) => DrivingProfile.fromJson(e as Map<String, dynamic>))
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
      'address': address,
      'nameOfTheTransportUnion': nameOfTheTransportUnion,
      'transportUnionRegistrationNo': transportUnionRegistrationNo,
      'noOfVehiclesRegistered': noOfVehiclesRegistered,
      'transportUnionPresidentAdharId': transportUnionPresidentAdharId,
      'transportUnionSecretaryAdhar': transportUnionSecretaryAdhar,
      'noOfLightCommercialVehicles': noOfLightCommercialVehicles,
      'noOfMediumCommercialVehicles': noOfMediumCommercialVehicles,
      'noOfHeavyCommercialVehicles': noOfHeavyCommercialVehicles,
      'appleBoxesTransported2023': appleBoxesTransported2023,
      'appleBoxesTransported2024': appleBoxesTransported2024,
      'estimatedTarget2025': estimatedTarget2025,
      'statesDrivenThrough': statesDrivenThrough,
      'appleGrowers': appleGrowers?.map((e) => e.toJson()).toList(),
      'aadhatis': aadhatis?.map((e) => e.toJson()).toList(),
      'buyers': buyers?.map((e) => e.toJson()).toList(),
      'associatedDrivers': associatedDrivers?.map((e) => e.toJson()).toList(),
      'myComplaints': myComplaints.map((e) => e.toJson()).toList(),
    };
  }

  Transport copyWith({
    String? id,
    String? name,
    String? contact,
    String? address,
    String? nameOfTheTransportUnion,
    String? transportUnionRegistrationNo,
    int? noOfVehiclesRegistered,
    String? transportUnionPresidentAdharId,
    String? transportUnionSecretaryAdhar,
    int? noOfLightCommercialVehicles,
    int? noOfMediumCommercialVehicles,
    int? noOfHeavyCommercialVehicles,
    int? appleBoxesTransported2023,
    int? appleBoxesTransported2024,
    double? estimatedTarget2025,
    String? statesDrivenThrough,
    List<Grower>? appleGrowers,
    List<Aadhati>? aadhatis,
    List<FreightForwarder>? buyers,
    List<DrivingProfile>? associatedDrivers,
    List<Complaint>? myComplaints,
  }) {
    return Transport(
      id: id ?? this.id,
      name: name ?? this.name,
      contact: contact ?? this.contact,
      address: address ?? this.address,
      nameOfTheTransportUnion:
          nameOfTheTransportUnion ?? this.nameOfTheTransportUnion,
      transportUnionRegistrationNo:
          transportUnionRegistrationNo ?? this.transportUnionRegistrationNo,
      noOfVehiclesRegistered:
          noOfVehiclesRegistered ?? this.noOfVehiclesRegistered,
      transportUnionPresidentAdharId:
          transportUnionPresidentAdharId ?? this.transportUnionPresidentAdharId,
      transportUnionSecretaryAdhar:
          transportUnionSecretaryAdhar ?? this.transportUnionSecretaryAdhar,
      noOfLightCommercialVehicles:
          noOfLightCommercialVehicles ?? this.noOfLightCommercialVehicles,
      noOfMediumCommercialVehicles:
          noOfMediumCommercialVehicles ?? this.noOfMediumCommercialVehicles,
      noOfHeavyCommercialVehicles:
          noOfHeavyCommercialVehicles ?? this.noOfHeavyCommercialVehicles,
      appleBoxesTransported2023:
          appleBoxesTransported2023 ?? this.appleBoxesTransported2023,
      appleBoxesTransported2024:
          appleBoxesTransported2024 ?? this.appleBoxesTransported2024,
      estimatedTarget2025: estimatedTarget2025 ?? this.estimatedTarget2025,
      statesDrivenThrough: statesDrivenThrough ?? this.statesDrivenThrough,
      appleGrowers: appleGrowers ?? this.appleGrowers,
      aadhatis: aadhatis ?? this.aadhatis,
      buyers: buyers ?? this.buyers,
      associatedDrivers: associatedDrivers ?? this.associatedDrivers,
      myComplaints: myComplaints ?? this.myComplaints,
    );
  }
}
