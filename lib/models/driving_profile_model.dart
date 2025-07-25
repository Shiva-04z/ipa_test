import 'package:apple_grower/models/freightForwarder.dart';
import 'package:apple_grower/models/complaint_model.dart';
import 'package:geocoding/geocoding.dart';
import 'package:latlong2/latlong.dart';

import 'aadhati.dart';
import 'grower_model.dart';
// Assuming Aadhati model is in this path

class DrivingProfile {
  String? id;
  String? name;
  String? contact;
  LatLng? currentLocation;
  String? drivingLicenseNo;
  String? vehicleRegistrationNo;
  String? chassiNoOfVehicle;
  String? payloadCapacityApprovedByRto;
  String? grossVehicleWeight;
  int? noOfTyres;
  String? permitOfVehicleDriving;
  String? vehicleOwnerAdharGst;
  int? appleBoxesTransported2023;
  int? appleBoxesTransported2024;
  double? estimatedTarget2025;
  String? statesDrivenThrough;
  List<Grower>? appleGrowers;
  List<Aadhati>? aadhatis;
  List<FreightForwarder>? buyers;
  List<Complaint> myComplaints;

  DrivingProfile({
    this.id,
    this.name,
    this.contact,
    this.currentLocation,
    this.drivingLicenseNo,
    this.vehicleRegistrationNo,
    this.chassiNoOfVehicle,
    this.payloadCapacityApprovedByRto,
    this.grossVehicleWeight,
    this.noOfTyres,
    this.permitOfVehicleDriving,
    this.vehicleOwnerAdharGst,
    this.appleBoxesTransported2023,
    this.appleBoxesTransported2024,
    this.estimatedTarget2025,
    this.statesDrivenThrough,
    this.appleGrowers,
    this.aadhatis,
    this.buyers,
    this.myComplaints = const [],
  });

  factory DrivingProfile.fromJson(Map<String, dynamic> json) {
    LatLng? location;
    if (json['currentLocation'] != null) {
      final loc = json['currentLocation'] as Map<String, dynamic>;
      location = LatLng(
        loc['latitude'] as double,
        loc['longitude'] as double,
      );
    }

    return DrivingProfile(
      id: json['id'] as String?,
      name: json['name'] as String?,
      contact: json['contact'] as String?,
      currentLocation: location,
      drivingLicenseNo: json['drivingLicenseNo'] as String?,
      vehicleRegistrationNo: json['vehicleRegistrationNo'] as String?,
      chassiNoOfVehicle: json['chassiNoOfVehicle'] as String?,
      payloadCapacityApprovedByRto:
          json['payloadCapacityApprovedByRto'] as String?,
      grossVehicleWeight: json['grossVehicleWeight'] as String?,
      noOfTyres: json['noOfTyres'] as int?,
      permitOfVehicleDriving: json['permitOfVehicleDriving'] as String?,
      vehicleOwnerAdharGst: json['vehicleOwnerAdharGst'] as String?,
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
      'currentLocation': currentLocation != null
          ? {
              'latitude': currentLocation!.latitude,
              'longitude': currentLocation!.longitude,
            }
          : null,
      'drivingLicenseNo': drivingLicenseNo,
      'vehicleRegistrationNo': vehicleRegistrationNo,
      'chassiNoOfVehicle': chassiNoOfVehicle,
      'payloadCapacityApprovedByRto': payloadCapacityApprovedByRto,
      'grossVehicleWeight': grossVehicleWeight,
      'noOfTyres': noOfTyres,
      'permitOfVehicleDriving': permitOfVehicleDriving,
      'vehicleOwnerAdharGst': vehicleOwnerAdharGst,
      'appleBoxesTransported2023': appleBoxesTransported2023,
      'appleBoxesTransported2024': appleBoxesTransported2024,
      'estimatedTarget2025': estimatedTarget2025,
      'statesDrivenThrough': statesDrivenThrough,
      'appleGrowers': appleGrowers?.map((e) => e.toJson()).toList(),
      'aadhatis': aadhatis?.map((e) => e.toJson()).toList(),
      'buyers': buyers?.map((e) => e.toJson()).toList(),
      'myComplaints': myComplaints.map((e) => e.toJson()).toList(),
    };
  }

  Map<String, dynamic> toMap() {
    return {
      'Name': name,
      'Contact': contact,
      'Current Location': currentLocation != null
          ? '${currentLocation!.latitude.toStringAsFixed(6)}, ${currentLocation!.longitude.toStringAsFixed(6)}'
          : 'Not Available',
      'Driving License No': drivingLicenseNo,
      'Vehicle Reg. No': vehicleRegistrationNo,
      'Chassis No.': chassiNoOfVehicle,
      'Payload Capacity': payloadCapacityApprovedByRto,
      'Gross Vehicle Weight': grossVehicleWeight,
      'No. of Tyres': noOfTyres,
      'Permit': permitOfVehicleDriving,
      'Vehicle Owner Aadhaar/GST': vehicleOwnerAdharGst,
      'Apple Boxes Transported 2023': appleBoxesTransported2023,
      'Apple Boxes Transported 2024': appleBoxesTransported2024,
      'Estimated Target 2025': estimatedTarget2025,
      'States Driven Through': statesDrivenThrough,
    };
  }

  DrivingProfile copyWith({
    String? id,
    String? name,
    String? contact,
    LatLng? currentLocation,
    String? drivingLicenseNo,
    String? vehicleRegistrationNo,
    String? chassiNoOfVehicle,
    String? payloadCapacityApprovedByRto,
    String? grossVehicleWeight,
    int? noOfTyres,
    String? permitOfVehicleDriving,
    String? vehicleOwnerAdharGst,
    int? appleBoxesTransported2023,
    int? appleBoxesTransported2024,
    double? estimatedTarget2025,
    String? statesDrivenThrough,
    List<Grower>? appleGrowers,
    List<Aadhati>? aadhatis,
    List<FreightForwarder>? buyers,
    List<Complaint>? myComplaints,
  }) {
    return DrivingProfile(
      id: id ?? this.id,
      name: name ?? this.name,
      contact: contact ?? this.contact,
      currentLocation: currentLocation ?? this.currentLocation,
      drivingLicenseNo: drivingLicenseNo ?? this.drivingLicenseNo,
      vehicleRegistrationNo:
          vehicleRegistrationNo ?? this.vehicleRegistrationNo,
      chassiNoOfVehicle: chassiNoOfVehicle ?? this.chassiNoOfVehicle,
      payloadCapacityApprovedByRto:
          payloadCapacityApprovedByRto ?? this.payloadCapacityApprovedByRto,
      grossVehicleWeight: grossVehicleWeight ?? this.grossVehicleWeight,
      noOfTyres: noOfTyres ?? this.noOfTyres,
      permitOfVehicleDriving:
          permitOfVehicleDriving ?? this.permitOfVehicleDriving,
      vehicleOwnerAdharGst: vehicleOwnerAdharGst ?? this.vehicleOwnerAdharGst,
      appleBoxesTransported2023:
          appleBoxesTransported2023 ?? this.appleBoxesTransported2023,
      appleBoxesTransported2024:
          appleBoxesTransported2024 ?? this.appleBoxesTransported2024,
      estimatedTarget2025: estimatedTarget2025 ?? this.estimatedTarget2025,
      statesDrivenThrough: statesDrivenThrough ?? this.statesDrivenThrough,
      appleGrowers: appleGrowers ?? this.appleGrowers,
      aadhatis: aadhatis ?? this.aadhatis,
      buyers: buyers ?? this.buyers,
      myComplaints: myComplaints ?? this.myComplaints,
    );
  }
}
