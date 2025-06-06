import 'package:apple_grower/models/driving_profile_model.dart';
import 'package:apple_grower/models/ladani_model.dart';
import 'package:apple_grower/models/pack_house_model.dart';

import 'aadhati.dart';

class Consignment {
  final String id;
  final String quality;
  final String category;
  final int numberOfBoxes;
  final int numberOfPiecesInBox;
  final String pickupOption; // 'Own', 'Request Driver Support'
  final String? shippingFrom;
  final String? shippingTo;
  final PackHouse? packingHouse;
  final Aadhati? commissionAgent;
  final Ladani? corporateCompany;
  final bool? hasOwnCrates; // Whether the grower has their own crates
  final String status; // 'Keep', 'Release for Bid'
  final DrivingProfile? driver;
  final DateTime createdAt;
  final DateTime updatedAt;

  Consignment({
    required this.id,
    required this.quality,
    required this.category,
    required this.numberOfBoxes,
    required this.numberOfPiecesInBox,
    required this.pickupOption,
    this.shippingFrom,
    this.shippingTo,
    required this.commissionAgent,
    this.hasOwnCrates,
    required this.status,
    required this.driver,
    required this.corporateCompany,
    required this.packingHouse,
    required this.createdAt,
    required this.updatedAt,
  });

  // Factory constructor for creating a new Consignment from a map
  factory Consignment.fromJson(Map<String, dynamic> json) {
    return Consignment(
      id: json['id'],
      quality: json['quality'],
      category: json['category'],
      numberOfBoxes: json['numberOfBoxes'],
      numberOfPiecesInBox: json['numberOfPiecesInBox'],
      pickupOption: json['pickupOption'],
      shippingFrom: json['shippingFrom'],
      shippingTo: json['shippingTo'],
      packingHouse: PackHouse.fromJson(json['packingHouse']),
      commissionAgent: Aadhati.fromJson(json['commissionAgent']),
      corporateCompany: Ladani.fromJson(json['corporateCompany']),
      hasOwnCrates: json['hasOwnCrates'],
      status: json['status'],
      createdAt: DateTime.parse(json['createdAt']),
      updatedAt: DateTime.parse(json['updatedAt']),
      driver: DrivingProfile.fromJson(json['driver']),
    );
  }

  // Method for converting a Consignment to a map
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'quality': quality,
      'category': category,
      'numberOfBoxes': numberOfBoxes,
      'numberOfPiecesInBox': numberOfPiecesInBox,
      'pickupOption': pickupOption,
      'shippingFrom': shippingFrom,
      'shippingTo': shippingTo,
      'packingHouse': packingHouse?.toJson(),
      'corporateCompany': corporateCompany?.toJson(),
      'commissionAgent': commissionAgent?.toJson(),
      'hasOwnCrates': hasOwnCrates,
      'status': status,
      'driver': driver?.toJson(),
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
    };
  }

  Consignment copyWith({
    String? id,
    String? quality,
    String? category,
    int? numberOfBoxes,
    int? numberOfPiecesInBox,
    String? pickupOption,
    String? shippingFrom,
    String? shippingTo,
    PackHouse? packingHouse,
    Aadhati? commissionAgent,
    Ladani? corporateCompany,
    bool? hasOwnCrates,
    String? status,
    DrivingProfile? driver,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return Consignment(
      id: id ?? this.id,
      quality: quality ?? this.quality,
      category: category ?? this.category,
      numberOfBoxes: numberOfBoxes ?? this.numberOfBoxes,
      numberOfPiecesInBox: numberOfPiecesInBox ?? this.numberOfPiecesInBox,
      pickupOption: pickupOption ?? this.pickupOption,
      shippingFrom: shippingFrom ?? this.shippingFrom,
      shippingTo: shippingTo ?? this.shippingTo,
      packingHouse: packingHouse ?? this.packingHouse,
      commissionAgent: commissionAgent ?? this.commissionAgent,
      corporateCompany: corporateCompany ?? this.corporateCompany,
      hasOwnCrates: hasOwnCrates ?? this.hasOwnCrates,
      status: status ?? this.status,
      driver: driver ?? this.driver,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}
