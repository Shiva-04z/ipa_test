import 'aadhati.dart';
import 'driving_profile_model.dart';
import 'grower_model.dart';
import 'employee_model.dart';
import 'package:apple_grower/models/complaint_model.dart';
import 'consignment_model.dart';
import 'freightForwarder.dart';
import 'transport_model.dart';
import 'hpmc_collection_center_model.dart';
import 'ladani_model.dart';

// Gallery Image model for the gallery structure
class GalleryImage {
  final String name;
  final String url;

  GalleryImage({
    required this.name,
    required this.url,
  });

  factory GalleryImage.fromJson(Map<String, dynamic> json) {
    return GalleryImage(
      name: json['name'] as String? ?? 'default_img',
      url: json['url'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'url': url,
    };
  }
}

enum TrayType {
  singleSide,
  bothSide,
}

class PackHouse {
  final String? id;
  final String name;
  final String phoneNumber;
  final String address;
  final String gradingMachine;
  final String sortingMachine;
  final String? gradingMachineCapacity;
  final String? sortingMachineCapacity;
  final String? machineManufacture;
  final String? trayType;
  final String? perDayCapacity;
  final String? numberOfCrates;
  final String? crateManufacture;
  final int boxesPackedT2;
  final int boxesPackedT1;
  final int boxesEstimatedT;
  final String? geoLocation;
  final int? numberOfGrowersServed;
  final List<Grower> associatedGrowers;
  final List<Aadhati> associatedCommissionAgents;
  final List<Employee> associatedPackers;
  final List<DrivingProfile> associatedPickers;
  final List<GalleryImage>? gallery;
  final List<String>? grower_IDs;
  final List<String>? aadhati_IDs;
  final List<String>? employee_IDs;
  final List<String>? drivers_IDs;
  final List<String>? transportUnion_IDs;
  final List<String>? freightForwarder_IDs;
  final List<String>? consignment_IDs;
  final List<String>? hpmcDepot_IDs;
  final List<String>? buyer_IDs;
  final List<Consignment>? consignments;
  final List<FreightForwarder>? associatedFreightForwarders;
  final List<Transport>? associatedTransportUnions;
  final List<HpmcCollectionCenter>? associatedHpmcDepots;
  final List<Ladani>? associatedLadanis;
  final List<Complaint> myComplaints;

  PackHouse({
    this.id,
    required this.name,
    required this.phoneNumber,
    required this.address,
    required this.gradingMachine,
    this.gradingMachineCapacity,
    required this.sortingMachine,
    this.sortingMachineCapacity,
    this.machineManufacture,
    this.trayType,
    this.perDayCapacity,
    required this.numberOfCrates,
    this.crateManufacture,
    required this.boxesPackedT2,
    required this.boxesPackedT1,
    required this.boxesEstimatedT,
    this.geoLocation,
    this.numberOfGrowersServed,
    this.associatedGrowers = const [],
    this.associatedCommissionAgents = const [],
    this.associatedPackers = const [],
    this.associatedPickers = const [],
    this.gallery,
    this.grower_IDs,
    this.aadhati_IDs,
    this.employee_IDs,
    this.drivers_IDs,
    this.transportUnion_IDs,
    this.freightForwarder_IDs,
    this.consignment_IDs,
    this.hpmcDepot_IDs,
    this.buyer_IDs,
    this.consignments,
    this.associatedFreightForwarders,
    this.associatedTransportUnions,
    this.associatedHpmcDepots,
    this.associatedLadanis,
    this.myComplaints = const [],
  });

  factory PackHouse.fromJson(Map<String, dynamic> json) {
    return PackHouse(
      id: json['id'] as String?,
      name: json['name'] as String,
      phoneNumber: json['phoneNumber'] as String,
      address: json['address'] as String? ?? '',
      gradingMachine: json['gradingMachine'] as String? ?? '',
      gradingMachineCapacity: json['gradingMachineCapacity'] as String?,
      sortingMachine: json['sortingMachine'] as String? ?? '',
      sortingMachineCapacity: json['sortingMachineCapacity'] as String?,
      machineManufacture: json['machineManufacture'] as String?,
      trayType: json['trayType'] as String?,
      perDayCapacity: json['perDayCapacity'] as String?,
      numberOfCrates: json['numberOfCrates'] as String?,
      crateManufacture: json['crateManufacture'] as String?,
      boxesPackedT2: json['boxesPackedT2'] as int? ?? 0,
      boxesPackedT1: json['boxesPackedT1'] as int? ?? 0,
      boxesEstimatedT: json['boxesEstimatedT'] as int? ?? 0,
      geoLocation: json['geoLocation'] as String?,
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
      gallery: (json['gallery'] as List<dynamic>?)
          ?.map((e) => GalleryImage.fromJson(e as Map<String, dynamic>))
          .toList(),
      grower_IDs: (json['grower_IDs'] as List<dynamic>?)
          ?.map((e) => e.toString())
          .toList(),
      aadhati_IDs: (json['aadhati_IDs'] as List<dynamic>?)
          ?.map((e) => e.toString())
          .toList(),
      employee_IDs: (json['employee_IDs'] as List<dynamic>?)
          ?.map((e) => e.toString())
          .toList(),
      drivers_IDs: (json['drivers_IDs'] as List<dynamic>?)
          ?.map((e) => e.toString())
          .toList(),
      transportUnion_IDs: (json['transportUnion_IDs'] as List<dynamic>?)
          ?.map((e) => e.toString())
          .toList(),
      freightForwarder_IDs: (json['freightForwarder_IDs'] as List<dynamic>?)
          ?.map((e) => e.toString())
          .toList(),
      consignment_IDs: (json['consignment_IDs'] as List<dynamic>?)
          ?.map((e) => e.toString())
          .toList(),
      hpmcDepot_IDs: (json['hpmcDepot_IDs'] as List<dynamic>?)
          ?.map((e) => e.toString())
          .toList(),
      buyer_IDs: (json['buyer_IDs'] as List<dynamic>?)
          ?.map((e) => e.toString())
          .toList(),
      consignments: (json['consignments'] as List<dynamic>?)
          ?.map((e) => Consignment.fromJson(e as Map<String, dynamic>))
          .toList(),
      associatedFreightForwarders:
          (json['associatedFreightForwarders'] as List<dynamic>?)
              ?.map((e) => FreightForwarder.fromJson(e as Map<String, dynamic>))
              .toList(),
      associatedTransportUnions:
          (json['associatedTransportUnions'] as List<dynamic>?)
              ?.map((e) => Transport.fromJson(e as Map<String, dynamic>))
              .toList(),
      associatedHpmcDepots: (json['associatedHpmcDepots'] as List<dynamic>?)
          ?.map((e) => HpmcCollectionCenter.fromJson(e as Map<String, dynamic>))
          .toList(),
      associatedLadanis: (json['associatedLadanis'] as List<dynamic>?)
          ?.map((e) => Ladani.fromJson(e as Map<String, dynamic>))
          .toList(),
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
      'machineManufacture': machineManufacture,
      'trayType': trayType,
      'perDayCapacity': perDayCapacity,
      'numberOfCrates': numberOfCrates,
      'crateManufacture': crateManufacture,
      'boxesPackedT2': boxesPackedT2,
      'boxesPackedT1': boxesPackedT1,
      'boxesEstimatedT': boxesEstimatedT,
      'geoLocation': geoLocation,
      'numberOfGrowersServed': numberOfGrowersServed,
      'associatedGrowers': associatedGrowers.map((e) => e.toJson()).toList(),
      'associatedCommissionAgents':
          associatedCommissionAgents.map((e) => e.toJson()).toList(),
      'associatedPackers': associatedPackers.map((e) => e.toJson()).toList(),
      'associatedPickers': associatedPickers.map((e) => e.toJson()).toList(),
      'gallery': gallery?.map((e) => e.toJson()).toList(),
      'grower_IDs': grower_IDs,
      'aadhati_IDs': aadhati_IDs,
      'employee_IDs': employee_IDs,
      'drivers_IDs': drivers_IDs,
      'transportUnion_IDs': transportUnion_IDs,
      'freightForwarder_IDs': freightForwarder_IDs,
      'consignment_IDs': consignment_IDs,
      'hpmcDepot_IDs': hpmcDepot_IDs,
      'buyer_IDs': buyer_IDs,
      'consignments': consignments?.map((e) => e.toJson()).toList(),
      'associatedFreightForwarders':
          associatedFreightForwarders?.map((e) => e.toJson()).toList(),
      'associatedTransportUnions':
          associatedTransportUnions?.map((e) => e.toJson()).toList(),
      'associatedHpmcDepots':
          associatedHpmcDepots?.map((e) => e.toJson()).toList(),
      'associatedLadanis': associatedLadanis?.map((e) => e.toJson()).toList(),
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
    String? machineManufacture,
    String? trayType,
    String? perDayCapacity,
   String? numberOfCrates,
    String? crateManufacture,
    int? boxesPackedT2,
    int? boxesPackedT1,
    int? boxesEstimatedT,
    String? geoLocation,
    int? numberOfGrowersServed,
    List<Grower>? associatedGrowers,
    List<Aadhati>? associatedCommissionAgents,
    List<Employee>? associatedPackers,
    List<DrivingProfile>? associatedPickers,
    List<GalleryImage>? gallery,
    List<String>? grower_IDs,
    List<String>? aadhati_IDs,
    List<String>? employee_IDs,
    List<String>? drivers_IDs,
    List<String>? transportUnion_IDs,
    List<String>? freightForwarder_IDs,
    List<String>? consignment_IDs,
    List<String>? hpmcDepot_IDs,
    List<String>? buyer_IDs,
    List<Consignment>? consignments,
    List<FreightForwarder>? associatedFreightForwarders,
    List<Transport>? associatedTransportUnions,
    List<HpmcCollectionCenter>? associatedHpmcDepots,
    List<Ladani>? associatedLadanis,
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
      machineManufacture: machineManufacture ?? this.machineManufacture,
      trayType: trayType ?? this.trayType,
      perDayCapacity: perDayCapacity ?? this.perDayCapacity,
      numberOfCrates: numberOfCrates ?? this.numberOfCrates,
      crateManufacture: crateManufacture ?? this.crateManufacture,
      boxesPackedT2: boxesPackedT2 ?? this.boxesPackedT2,
      boxesPackedT1: boxesPackedT1 ?? this.boxesPackedT1,
      boxesEstimatedT: boxesEstimatedT ?? this.boxesEstimatedT,
      geoLocation: geoLocation ?? this.geoLocation,
      numberOfGrowersServed:
          numberOfGrowersServed ?? this.numberOfGrowersServed,
      associatedGrowers: associatedGrowers ?? this.associatedGrowers,
      associatedCommissionAgents:
          associatedCommissionAgents ?? this.associatedCommissionAgents,
      associatedPackers: associatedPackers ?? this.associatedPackers,
      associatedPickers: associatedPickers ?? this.associatedPickers,
      gallery: gallery ?? this.gallery,
      grower_IDs: grower_IDs ?? this.grower_IDs,
      aadhati_IDs: aadhati_IDs ?? this.aadhati_IDs,
      employee_IDs: employee_IDs ?? this.employee_IDs,
      drivers_IDs: drivers_IDs ?? this.drivers_IDs,
      transportUnion_IDs: transportUnion_IDs ?? this.transportUnion_IDs,
      freightForwarder_IDs: freightForwarder_IDs ?? this.freightForwarder_IDs,
      consignment_IDs: consignment_IDs ?? this.consignment_IDs,
      hpmcDepot_IDs: hpmcDepot_IDs ?? this.hpmcDepot_IDs,
      buyer_IDs: buyer_IDs ?? this.buyer_IDs,
      consignments: consignments ?? this.consignments,
      associatedFreightForwarders:
          associatedFreightForwarders ?? this.associatedFreightForwarders,
      associatedTransportUnions:
          associatedTransportUnions ?? this.associatedTransportUnions,
      associatedHpmcDepots: associatedHpmcDepots ?? this.associatedHpmcDepots,
      associatedLadanis: associatedLadanis ?? this.associatedLadanis,
      myComplaints: myComplaints ?? this.myComplaints,
    );
  }
}
