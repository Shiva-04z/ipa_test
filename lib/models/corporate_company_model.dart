import 'package:equatable/equatable.dart';

class CorporateCompany extends Equatable {
  final String id;
  final String name;
  final String phoneNumber;
  final String address;
  final String companyType;
  final DateTime createdAt;
  final DateTime updatedAt;

  const CorporateCompany({
    required this.id,
    required this.name,
    required this.phoneNumber,
    required this.address,
    required this.companyType,
    required this.createdAt,
    required this.updatedAt,
  });

  factory CorporateCompany.fromJson(Map<String, dynamic> json) {
    return CorporateCompany(
      id: json['id'] as String,
      name: json['name'] as String,
      phoneNumber: json['phoneNumber'] as String,
      address: json['address'] as String,
      companyType: json['companyType'] as String,
      createdAt: DateTime.parse(json['createdAt'] as String),
      updatedAt: DateTime.parse(json['updatedAt'] as String),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'phoneNumber': phoneNumber,
      'address': address,
      'companyType': companyType,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
    };
  }

  CorporateCompany copyWith({
    String? id,
    String? name,
    String? phoneNumber,
    String? address,
    String? companyType,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return CorporateCompany(
      id: id ?? this.id,
      name: name ?? this.name,
      phoneNumber: phoneNumber ?? this.phoneNumber,
      address: address ?? this.address,
      companyType: companyType ?? this.companyType,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  @override
  List<Object?> get props => [
        id,
        name,
        phoneNumber,
        address,
        companyType,
        createdAt,
        updatedAt,
      ];
}
