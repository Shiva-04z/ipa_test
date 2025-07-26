import 'package:apple_grower/models/ladani_model.dart';

import 'aadhati.dart';

class AuthSignatoryPost {
  String? nameOfAuthorizedSignatory;
  String? designation;
  String? officeNo;
  List<Aadhati>? approvedTraders;
  List<Aadhati>? blacklistedTraders;
  List<Ladani>? approvedLadanis;
  List<Ladani>? blacklistedLadanis;

  AuthSignatoryPost({
    this.nameOfAuthorizedSignatory,
    this.designation,
    this.officeNo,
    this.approvedTraders,
    this.blacklistedTraders,
    this.approvedLadanis,
    this.blacklistedLadanis,
  });

  factory AuthSignatoryPost.fromJson(Map<String, dynamic> json) {
    return AuthSignatoryPost(
      nameOfAuthorizedSignatory: json['nameOfAuthorizedSignatory'] as String?,
      designation: json['designation'] as String?,
      officeNo: json['officeNo'] as String?,
      approvedTraders: (json['approvedTraders'] as List<dynamic>?)
          ?.map((e) => Aadhati.fromJson(e as Map<String, dynamic>))
          .toList(),
      blacklistedTraders: (json['blacklistedTraders'] as List<dynamic>?)
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
      'officeNo': officeNo,
      'approvedTraders': approvedTraders?.map((e) => e.toJson()).toList(),
      'blacklistedTraders': blacklistedTraders?.map((e) => e.toJson()).toList(),
      'approvedLadanis': approvedLadanis?.map((e) => e.toJson()).toList(),
      'blacklistedLadanis': blacklistedLadanis?.map((e) => e.toJson()).toList(),
    };
  }

  AuthSignatoryPost copyWith({
    String? nameOfAuthorizedSignatory,
    String? designation,
    String? officeNo,
    List<Aadhati>? approvedTraders,
    List<Aadhati>? blacklistedTraders,
    List<Ladani>? approvedLadanis,
    List<Ladani>? blacklistedLadanis,
  }) {
    return AuthSignatoryPost(
      nameOfAuthorizedSignatory:
          nameOfAuthorizedSignatory ?? this.nameOfAuthorizedSignatory,
      designation: designation ?? this.designation,
      officeNo: officeNo ?? this.officeNo,
      approvedTraders: approvedTraders ?? this.approvedTraders,
      blacklistedTraders: blacklistedTraders ?? this.blacklistedTraders,
      approvedLadanis: approvedLadanis ?? this.approvedLadanis,
      blacklistedLadanis: blacklistedLadanis ?? this.blacklistedLadanis,
    );
  }
}
