import 'package:equatable/equatable.dart';

class Packer extends Equatable {
  final String id;
  final String name;
  final String? phoneNumber;
  // Add other relevant fields for a packer

  const Packer({
    required this.id,
    required this.name,
    this.phoneNumber,
  });

  factory Packer.fromJson(Map<String, dynamic> json) {
    return Packer(
      id: json['id'] as String,
      name: json['name'] as String,
      phoneNumber: json['phoneNumber'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'phoneNumber': phoneNumber,
    };
  }

  @override
  List<Object?> get props => [id, name, phoneNumber];
}
