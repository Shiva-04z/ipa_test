import 'package:apple_grower/models/commission_agent_model.dart';
import 'package:apple_grower/models/corporate_company_model.dart';
import 'package:apple_grower/models/packing_house_status_model.dart';
import 'package:get/get.dart';

class Consignment {
  final String id;
  final String quality;
  final String category;
  final int numberOfBoxes;
  final int numberOfPiecesInBox;
  final String pickupOption; // 'Own', 'Request Driver Support'
  final String? shippingFrom;
  final String? shippingTo;
 final PackingHouse? packingHouse;
 final CommissionAgent? commissionAgent;
 final CorporateCompany? corporateCompany;
  final bool? hasOwnCrates; // Whether the grower has their own crates
  final String status; // 'Keep', 'Release for Bid'

  // Support details (filled if support is requested/resolved)
  final String? driverName;
  final String? driverContact;
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
    this.driverName,
    this.driverContact,
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
      packingHouse: PackingHouse.fromJson(json['packingHouse']),
      commissionAgent: CommissionAgent.fromJson(json['commissionAgent']),
      corporateCompany: CorporateCompany.fromJson(json['corporateCompany']),
      hasOwnCrates: json['hasOwnCrates'],
      status: json['status'],
      driverName: json['driverName'],
      driverContact: json['driverContact'],
      createdAt: DateTime.parse(json['createdAt']),
      updatedAt: DateTime.parse(json['updatedAt']),
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
      'corporateCompany':corporateCompany?.toJson(),
      'commissionAgent': commissionAgent?.toJson(),
      'hasOwnCrates': hasOwnCrates,
      'status': status,
      'driverName': driverName,
      'driverContact': driverContact,

      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
    };
  }

  // Method for creating a copy with modified fields
  Consignment copyWith({
    String? id,
    String? quality,
    String? category,
    int? numberOfBoxes,
    int? numberOfPiecesInBox,
    String? pickupOption,
    String? shippingFrom,
    String? shippingTo,
    bool? hasOwnCrates,
    String? status,
    String? driverName,
    String? driverContact,
   CorporateCompany? corporateCompany,
    CommissionAgent?  commissionAgent,
    PackingHouse? packingHouse,
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
      hasOwnCrates: hasOwnCrates ?? this.hasOwnCrates,
      status: status ?? this.status,
      driverName: driverName ?? this.driverName,
      driverContact: driverContact ?? this.driverContact,
      packingHouse:  packingHouse ??this.packingHouse,
      commissionAgent:  commissionAgent ??this.commissionAgent,
      corporateCompany: corporateCompany ??this.corporateCompany,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}
