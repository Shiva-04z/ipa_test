import 'package:equatable/equatable.dart';

class CommissionAgent  {
  final String id;
  final String name;
  final String phoneNumber;
  final String apmcMandi;
  final String address;
  final DateTime createdAt;
  final DateTime updatedAt;

  const CommissionAgent({
    required this.id,
    required this.name,
    required this.phoneNumber,
    required this.apmcMandi,
    required this.address,
    required this.createdAt,
    required this.updatedAt,
  });

  factory CommissionAgent.fromJson(Map<String, dynamic> json) {
    return CommissionAgent(
      id: json['id'] as String,
      name: json['name'] as String,
      phoneNumber: json['phoneNumber'] as String,
      apmcMandi: json['apmcMandi'] as String,
      address: json['address'] as String,
      createdAt: DateTime.parse(json['createdAt'] as String),
      updatedAt: DateTime.parse(json['updatedAt'] as String),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'phoneNumber': phoneNumber,
      'apmcMandi': apmcMandi,
      'address': address,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
    };
  }

  CommissionAgent copyWith({
    String? id,
    String? name,
    String? phoneNumber,
    String? apmcMandi,
    String? address,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return CommissionAgent(
      id: id ?? this.id,
      name: name ?? this.name,
      phoneNumber: phoneNumber ?? this.phoneNumber,
      apmcMandi: apmcMandi ?? this.apmcMandi,
      address: address ?? this.address,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  @override
  List<Object?> get props => [
    id,
    name,
    phoneNumber,
    apmcMandi,
    address,
    createdAt,
    updatedAt,
  ];
}
