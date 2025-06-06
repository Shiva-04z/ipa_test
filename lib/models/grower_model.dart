import 'package:apple_grower/models/consignment_model.dart';
import 'package:apple_grower/models/ladani_model.dart';
import 'aadhati.dart';
import 'orchard_model.dart';
import 'pack_house_model.dart';

class Grower {
  final String id;
  final String name;
  final String aadharNumber;
  final String phoneNumber;
  final String address;
  final String pinCode;
  final List<Orchard> orchards;
  final List<Aadhati> commissionAgents;
  final List<Ladani> corporateCompanies;
  final List<Consignment> consignments;
  final List<PackHouse> packingHouses;
  final DateTime createdAt;
  final DateTime updatedAt;

  const Grower({
    required this.id,
    required this.aadharNumber,
    required this.name,
    required this.phoneNumber,
    required this.address,
    required this.pinCode,
    this.orchards = const [],
    this.commissionAgents = const [],
    this.corporateCompanies = const [],
    this.consignments = const [],
    required this.packingHouses,
    required this.createdAt,
    required this.updatedAt,
  });

  factory Grower.fromJson(Map<String, dynamic> json) {
    return Grower(
      id: json['id'] as String,
      aadharNumber: json['aadharNumber'] as String,
      name: json['name'] as String,
      phoneNumber: json['phoneNumber'] as String,
      address: json['address'] as String,
      pinCode: json['pinCode'] as String,
      orchards: (json['orchards'] as List<dynamic>?)
              ?.map((e) => Orchard.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [],
      commissionAgents: (json['commissionAgents'] as List<dynamic>?)
              ?.map((e) => Aadhati.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [],
      corporateCompanies: (json['corporateCompanies'] as List<dynamic>?)
              ?.map((e) => Ladani.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [],
      packingHouses: (json['packingHouses'] as List<dynamic>?)
              ?.map((e) => PackHouse.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [],
      consignments: (json['consignments'] as List<dynamic>?)
              ?.map((e) => Consignment.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [],
      createdAt: json['createdAt'] ?? DateTime.now().toIso8601String(),
      updatedAt: json['updatedAt'] ?? DateTime.now().toIso8601String(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'aadharNumber': aadharNumber,
      'name': name,
      'phoneNumber': phoneNumber,
      'address': address,
      'pinCode': pinCode,
      'orchards': orchards.map((e) => e.toJson()).toList(),
      'commissionAgents': commissionAgents.map((e) => e.toJson()).toList(),
      'corporateCompanies': corporateCompanies.map((e) => e.toJson()).toList(),
      'packingHouses': packingHouses.map((e) => e.toJson()).toList(),
      'consignments': consignments.map((e) => e.toJson()).toList(),
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
    };
  }

  Grower copyWith({
    String? id,
    String? aadharNumber,
    String? name,
    String? phoneNumber,
    String? address,
    String? pinCode,
    List<Orchard>? orchards,
    List<Aadhati>? commissionAgents,
    List<Ladani>? corporateCompanies,
    List<Consignment>? consignments,
    List<PackHouse>? packingHouses,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return Grower(
      id: id ?? this.id,
      aadharNumber: aadharNumber ?? this.aadharNumber,
      name: name ?? this.name,
      phoneNumber: phoneNumber ?? this.phoneNumber,
      address: address ?? this.address,
      pinCode: pinCode ?? this.pinCode,
      orchards: orchards ?? this.orchards,
      commissionAgents: commissionAgents ?? this.commissionAgents,
      corporateCompanies: corporateCompanies ?? this.corporateCompanies,
      consignments: consignments ?? this.consignments,
      packingHouses: packingHouses ?? this.packingHouses,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}
