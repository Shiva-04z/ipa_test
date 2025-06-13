import 'aadhati.dart';
import 'driving_profile_model.dart';
import 'grower_model.dart';
import 'employee_model.dart';
import 'package:apple_grower/models/complaint_model.dart';

enum TrayType {
  singleSide,
  bothSide,
}

class PackHouse {
  final String id;
  final String name;
  final String phoneNumber;
  final String address;
  final String gradingMachine;
  final String sortingMachine;
  final String? gradingMachineCapacity;
  final String? sortingMachineCapacity;
  final String? machineManufacturer;
  final TrayType? trayType;
  final String? perDayCapacity;
  final int numberOfCrates;
  final String? crateManufacture;
  final int boxesPacked2023;
  final int boxesPacked2024;
  final int estimatedBoxes2025;
  final String? geoLoaction;
  final int? numberOfGrowersServed;
  final List<Grower> associatedGrowers;
  final List<Aadhati> associatedCommissionAgents;
  final List<Employee> associatedPackers;
  final List<DrivingProfile> associatedPickers;
  final List<Complaint> myComplaints;

  PackHouse({
    required this.id,
    required this.name,
    required this.phoneNumber,
    required this.address,
    required this.gradingMachine,
    this.gradingMachineCapacity,
    required this.sortingMachine,
    this.sortingMachineCapacity,
    this.machineManufacturer,
    this.trayType,
    this.perDayCapacity,
    required this.numberOfCrates,
    this.crateManufacture,
    required this.boxesPacked2023,
    required this.boxesPacked2024,
    required this.estimatedBoxes2025,
    this.geoLoaction,
    this.numberOfGrowersServed,
    this.associatedGrowers = const [],
    this.associatedCommissionAgents = const [],
    this.associatedPackers = const [],
    this.associatedPickers = const [],
    this.myComplaints = const [],
  });

  factory PackHouse.fromJson(Map<String, dynamic> json) {
    return PackHouse(
      id: json['id'] as String,
      name: json['name'] as String,
      phoneNumber: json['phoneNumber'] as String,
      address: json['address'] as String,
      gradingMachine: json['gradingMachine'] as String,
      gradingMachineCapacity: json['gradingMachineCapacity'] as String?,
      sortingMachine: json['sortingMachine'] as String,
      sortingMachineCapacity: json['sortingMachineCapacity'] as String?,
      machineManufacturer: json['machineManufacturer'] as String?,
      trayType: json['trayType'] != null
          ? TrayType.values
              .firstWhere((e) => e.toString() == 'TrayType.${json['trayType']}')
          : null,
      perDayCapacity: json['perDayCapacity'] as String?,
      numberOfCrates: json['numberOfCrates'] as int,
      crateManufacture: json['crateManufacture'] as String?,
      boxesPacked2023: json['boxesPacked2023'] as int,
      boxesPacked2024: json['boxesPacked2024'] as int,
      estimatedBoxes2025: json['estimatedBoxes2025'] as int,
      geoLoaction: json['geoLoaction'] as String?,
      numberOfGrowersServed: json['numberOfGrowersServed'] as int?,
      associatedGrowers: (json['associatedGrowers'] as List<dynamic>?)
              ?.map((e) => Grower.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [],
      associatedCommissionAgents:
          (json['associatedCommissionAgents'] as List<dynamic>?)
                  ?.map((e) => Aadhati.fromJson(e as Map<String, dynamic>))
                  .toList() ??
              [],
      associatedPackers: (json['associatedPackers'] as List<dynamic>?)
              ?.map((e) => Employee.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [],
      associatedPickers: (json['associatedPickers'] as List<dynamic>?)
              ?.map((e) => DrivingProfile.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [],
      myComplaints: (json['myComplaints'] as List<dynamic>?)
              ?.map((e) => Complaint.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'phoneNumber': phoneNumber,
      'address': address,
      'gradingMachine': gradingMachine,
      'gradingMachineCapacity': gradingMachineCapacity,
      'sortingMachine': sortingMachine,
      'sortingMachineCapacity': sortingMachineCapacity,
      'machineManufacturer': machineManufacturer,
      'trayType': trayType?.toString().split('.').last,
      'perDayCapacity': perDayCapacity,
      'numberOfCrates': numberOfCrates,
      'crateManufacture': crateManufacture,
      'boxesPacked2023': boxesPacked2023,
      'boxesPacked2024': boxesPacked2024,
      'estimatedBoxes2025': estimatedBoxes2025,
      'geoLoaction': geoLoaction,
      'numberOfGrowersServed': numberOfGrowersServed,
      'associatedGrowers': associatedGrowers.map((e) => e.toJson()).toList(),
      'associatedCommissionAgents':
          associatedCommissionAgents.map((e) => e.toJson()).toList(),
      'associatedPackers': associatedPackers.map((e) => e.toJson()).toList(),
      'associatedPickers': associatedPickers.map((e) => e.toJson()).toList(),
      'myComplaints': myComplaints.map((e) => e.toJson()).toList(),
    };
  }

  PackHouse copyWith({
    String? id,
    String? name,
    String? phoneNumber,
    String? address,
    String? gradingMachine,
    String? sortingMachine,
    String? gradingMachineCapacity,
    String? sortingMachineCapacity,
    String? machineManufacturer,
    TrayType? trayType,
    String? perDayCapacity,
    int? numberOfCrates,
    String? crateManufacture,
    int? boxesPacked2023,
    int? boxesPacked2024,
    int? estimatedBoxes2025,
    String? geoLoaction,
    int? numberOfGrowersServed,
    List<Grower>? associatedGrowers,
    List<Aadhati>? associatedCommissionAgents,
    List<Employee>? associatedPackers,
    List<DrivingProfile>? associatedPickers,
    List<Complaint>? myComplaints,
  }) {
    return PackHouse(
      id: id ?? this.id,
      name: name ?? this.name,
      phoneNumber: phoneNumber ?? this.phoneNumber,
      address: address ?? this.address,
      gradingMachine: gradingMachine ?? this.gradingMachine,
      sortingMachine: sortingMachine ?? this.sortingMachine,
      gradingMachineCapacity:
          gradingMachineCapacity ?? this.gradingMachineCapacity,
      sortingMachineCapacity:
          sortingMachineCapacity ?? this.sortingMachineCapacity,
      machineManufacturer: machineManufacturer ?? this.machineManufacturer,
      trayType: trayType ?? this.trayType,
      perDayCapacity: perDayCapacity ?? this.perDayCapacity,
      numberOfCrates: numberOfCrates ?? this.numberOfCrates,
      crateManufacture: crateManufacture ?? this.crateManufacture,
      boxesPacked2023: boxesPacked2023 ?? this.boxesPacked2023,
      boxesPacked2024: boxesPacked2024 ?? this.boxesPacked2024,
      estimatedBoxes2025: estimatedBoxes2025 ?? this.estimatedBoxes2025,
      geoLoaction: geoLoaction ?? this.geoLoaction,
      numberOfGrowersServed:
          numberOfGrowersServed ?? this.numberOfGrowersServed,
      associatedGrowers: associatedGrowers ?? this.associatedGrowers,
      associatedCommissionAgents:
          associatedCommissionAgents ?? this.associatedCommissionAgents,
      associatedPackers: associatedPackers ?? this.associatedPackers,
      associatedPickers: associatedPickers ?? this.associatedPickers,
      myComplaints: myComplaints ?? this.myComplaints,
    );
  }
}
