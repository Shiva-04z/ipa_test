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
  final String adhaniOption; // 'Own', 'Request Adhani Support'
  final String ladhaniOption; // 'Own', 'Request Ladhani Support'
  final bool? hasOwnCrates; // Whether the grower has their own crates
  final String status; // 'Keep', 'Release for Bid'

  // Support details (filled if support is requested/resolved)
  final String? driverName;
  final String? driverContact;
  final String? adhaniName;
  final String? adhaniContact;
  final String? adhaniApmc;
  final String? ladhaniName;
  final String? ladhaniContact;
  final String? ladhaniCompany;
  final String?  packhouseName;
  final String? packhouseContact;

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
    required this.adhaniOption,
    required this.ladhaniOption,
    this.hasOwnCrates,
    required this.status,
    this.driverName,
    this.driverContact,
    this.adhaniName,
    this.adhaniContact,
    this.adhaniApmc,
    this.ladhaniName,
    this.ladhaniContact,
    this.ladhaniCompany,
    this.packhouseName,
    this.packhouseContact,
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
      adhaniOption: json['adhaniOption'],
      ladhaniOption: json['ladhaniOption'],
      hasOwnCrates: json['hasOwnCrates'],
      status: json['status'],
      driverName: json['driverName'],
      driverContact: json['driverContact'],
      adhaniName: json['adhaniName'],
      adhaniContact: json['adhaniContact'],
      adhaniApmc: json['adhaniApmc'],
      ladhaniName: json['ladhaniName'],
      ladhaniContact: json['ladhaniContact'],
      ladhaniCompany: json['ladhaniCompany'],
      packhouseContact: json['packhouseContact'],
      packhouseName: json['packhouseName'],
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
      'adhaniOption': adhaniOption,
      'ladhaniOption': ladhaniOption,
      'hasOwnCrates': hasOwnCrates,
      'status': status,
      'driverName': driverName,
      'driverContact': driverContact,
      'adhaniName': adhaniName,
      'adhaniContact': adhaniContact,
      'adhaniApmc': adhaniApmc,
      'ladhaniName': ladhaniName,
      'ladhaniContact': ladhaniContact,
      'ladhaniCompany': ladhaniCompany,
      'packhouseName': packhouseName,
      'packhouseContact' : packhouseContact,
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
    String? adhaniOption,
    String? ladhaniOption,
    bool? hasOwnCrates,
    String? status,
    String? driverName,
    String? driverContact,
    String? adhaniName,
    String? adhaniContact,
    String? adhaniApmc,
    String? ladhaniName,
    String? ladhaniContact,
    String? ladhaniCompany,
    String? packhouseName,
    String? packhouseContact,
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
      adhaniOption: adhaniOption ?? this.adhaniOption,
      ladhaniOption: ladhaniOption ?? this.ladhaniOption,
      hasOwnCrates: hasOwnCrates ?? this.hasOwnCrates,
      status: status ?? this.status,
      driverName: driverName ?? this.driverName,
      driverContact: driverContact ?? this.driverContact,
      adhaniName: adhaniName ?? this.adhaniName,
      adhaniContact: adhaniContact ?? this.adhaniContact,
      adhaniApmc: adhaniApmc ?? this.adhaniApmc,
      ladhaniName: ladhaniName ?? this.ladhaniName,
      ladhaniContact: ladhaniContact ?? this.ladhaniContact,
      ladhaniCompany: ladhaniCompany ?? this.ladhaniCompany,
      packhouseName: packhouseName?? this.packhouseName,
      packhouseContact: packhouseContact?? this.packhouseContact,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}
