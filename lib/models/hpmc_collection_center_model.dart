import 'package:apple_grower/models/grower_model.dart';
import 'package:apple_grower/models/complaint_model.dart';

class HpmcCollectionCenter {
  String? id;
  String? contactName;
  String? operatorName;
  String? cellNo;
  String? adharNo;
  String? licenseNo;
  int? operatingSince;
  String? location;
  double? tonsTransported2023;
  double? tonsTransported2024;
  double? target2025;
  List<Grower>? associatedGrowers;
  final List<Complaint> myComplaints;

  HpmcCollectionCenter({
    this.id,
    this.contactName,
    this.operatorName,
    this.cellNo,
    this.adharNo,
    this.licenseNo,
    this.operatingSince,
    this.location,
    this.tonsTransported2023,
    this.tonsTransported2024,
    this.target2025,
    this.associatedGrowers,
    this.myComplaints = const [],
  });

  factory HpmcCollectionCenter.fromJson(Map<String, dynamic> json) {
    return HpmcCollectionCenter(
      id: json['id'] as String?,
      contactName: json['contactName'] as String?,
      operatorName: json['operatorName'] as String?,
      cellNo: json['cellNo'] as String?,
      adharNo: json['adharNo'] as String?,
      licenseNo: json['licenseNo'] as String?,
      operatingSince: json['operatingSince'] as int?,
      location: json['location'] as String?,
      tonsTransported2023: json['tonsTransported2023'] as double?,
      tonsTransported2024: json['tonsTransported2024'] as double?,
      target2025: json['target2025'] as double?,
      associatedGrowers: (json['associatedGrowers'] as List<dynamic>?)
          ?.map((e) => Grower.fromJson(e as Map<String, dynamic>))
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
      'contactName': contactName,
      'operatorName': operatorName,
      'cellNo': cellNo,
      'adharNo': adharNo,
      'licenseNo': licenseNo,
      'operatingSince': operatingSince,
      'location': location,
      'tonsTransported2023': tonsTransported2023,
      'tonsTransported2024': tonsTransported2024,
      'target2025': target2025,
      'associatedGrowers': associatedGrowers?.map((e) => e.toJson()).toList(),
      'myComplaints': myComplaints.map((e) => e.toJson()).toList(),
    };
  }

  HpmcCollectionCenter copyWith({
    String? id,
    String? contactName,
    String? operatorName,
    String? cellNo,
    String? adharNo,
    String? licenseNo,
    int? operatingSince,
    String? location,
    double? tonsTransported2023,
    double? tonsTransported2024,
    double? target2025,
    List<Grower>? associatedGrowers,
    List<Complaint>? myComplaints,
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
      tonsTransported2023: tonsTransported2023 ?? this.tonsTransported2023,
      tonsTransported2024: tonsTransported2024 ?? this.tonsTransported2024,
      target2025: target2025 ?? this.target2025,
      associatedGrowers: associatedGrowers ?? this.associatedGrowers,
      myComplaints: myComplaints ?? this.myComplaints,
    );
  }
}
