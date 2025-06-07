import 'package:apple_grower/models/ladani_model.dart';

import 'aadhati.dart';

class Apmc {
  String? name;
  String? nameOfAuthorizedSignatory;
  String? designation;
  String? officePhoneNo;
  int? totalNoOfCommissionAgents;
  int? totalLadanisWithinJurisdiction;
  int? totalNoOfTransporters;
  int? noOfHomeGuardsOnDuty;
  int? totalApmcStaff;
  int? appleBoxesSold2023;
  int? appleBoxesSold2024;
  double? estimatedTarget2025;
  List<Aadhati>? approvedAadhati;
  List<Aadhati>? blacklistedAdhaties;
  List<Ladani>? approvedLadanis;
  List<Ladani>? blacklistedLadanis;

  Apmc({
    this.nameOfAuthorizedSignatory,
    this.designation,
    this.officePhoneNo,
    this.totalNoOfCommissionAgents,
    this.totalLadanisWithinJurisdiction,
    this.totalNoOfTransporters,
    this.noOfHomeGuardsOnDuty,
    this.totalApmcStaff,
    this.appleBoxesSold2023,
    this.appleBoxesSold2024,
    this.estimatedTarget2025,
    this.approvedAadhati,
    this.blacklistedAdhaties,
    this.approvedLadanis,
    this.blacklistedLadanis,
  });

  factory Apmc.fromJson(Map<String, dynamic> json) {
    return Apmc(
      nameOfAuthorizedSignatory: json['nameOfAuthorizedSignatory'] as String?,
      designation: json['designation'] as String?,
      officePhoneNo: json['officePhoneNo'] as String?,
      totalNoOfCommissionAgents: json['totalNoOfCommissionAgents'] as int?,
      totalLadanisWithinJurisdiction:
          json['totalLadanisWithinJurisdiction'] as int?,
      totalNoOfTransporters: json['totalNoOfTransporters'] as int?,
      noOfHomeGuardsOnDuty: json['noOfHomeGuardsOnDuty'] as int?,
      totalApmcStaff: json['totalApmcStaff'] as int?,
      appleBoxesSold2023: json['appleBoxesSold2023'] as int?,
      appleBoxesSold2024: json['appleBoxesSold2024'] as int?,
      estimatedTarget2025: json['estimatedTarget2025'] as double?,
      approvedAadhati: (json['approvedAadhati'] as List<dynamic>?)
          ?.map((e) => Aadhati.fromJson(e as Map<String, dynamic>))
          .toList(),
      blacklistedAdhaties: (json['blacklistedAdhaties'] as List<dynamic>?)
          ?.map((e) => Aadhati.fromJson(e as Map<String, dynamic>))
          .toList(),
      approvedLadanis: (json['approvedLadanis'] as List<dynamic>?)
          ?.map((e) => Ladani.fromJson(e as Map<String, dynamic>))
          .toList(),
      blacklistedLadanis: (json['blacklistedLadanis'] as List<dynamic>?)
          ?.map((e) => Ladani.fromJson(e as Map<String, dynamic>))
          .toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'nameOfAuthorizedSignatory': nameOfAuthorizedSignatory,
      'designation': designation,
      'officePhoneNo': officePhoneNo,
      'totalNoOfCommissionAgents': totalNoOfCommissionAgents,
      'totalLadanisWithinJurisdiction': totalLadanisWithinJurisdiction,
      'totalNoOfTransporters': totalNoOfTransporters,
      'noOfHomeGuardsOnDuty': noOfHomeGuardsOnDuty,
      'totalApmcStaff': totalApmcStaff,
      'appleBoxesSold2023': appleBoxesSold2023,
      'appleBoxesSold2024': appleBoxesSold2024,
      'estimatedTarget2025': estimatedTarget2025,
      'approvedAadhati': approvedAadhati?.map((e) => e.toJson()).toList(),
      'blacklistedAdhaties':
          blacklistedAdhaties?.map((e) => e.toJson()).toList(),
      'approvedLadanis': approvedLadanis?.map((e) => e.toJson()).toList(),
      'blacklistedLadanis': blacklistedLadanis?.map((e) => e.toJson()).toList(),
    };
  }
}
