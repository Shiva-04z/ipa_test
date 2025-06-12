import 'package:equatable/equatable.dart';

class Employee extends Equatable {
  final String id;
  final String name;
  final String? phoneNumber;
  final String? designation;
  final String? address;
  final String? joiningDate;
  final String? salary;

  const Employee({
    required this.id,
    required this.name,
    this.phoneNumber,
    this.designation,
    this.address,
    this.joiningDate,
    this.salary,
  });

  factory Employee.fromJson(Map<String, dynamic> json) {
    return Employee(
      id: json['id'] as String,
      name: json['name'] as String,
      phoneNumber: json['phoneNumber'] as String?,
      designation: json['designation'] as String?,
      address: json['address'] as String?,
      joiningDate: json['joiningDate'] as String?,
      salary: json['salary'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'phoneNumber': phoneNumber,
      'designation': designation,
      'address': address,
      'joiningDate': joiningDate,
      'salary': salary,
    };
  }

  @override
  List<Object?> get props =>
      [id, name, phoneNumber, designation, address, joiningDate, salary];
}
