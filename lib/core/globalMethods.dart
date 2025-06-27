import 'package:apple_grower/models/aadhati.dart';
import 'package:apple_grower/models/driving_profile_model.dart';
import 'package:apple_grower/models/employee_model.dart';
import 'package:apple_grower/models/freightForwarder.dart';
import 'package:apple_grower/models/grower_model.dart';
import 'package:apple_grower/models/hpmc_collection_center_model.dart';
import 'package:apple_grower/models/pack_house_model.dart';
import 'package:apple_grower/models/transport_model.dart';
import '../models/ladani_model.dart';
import '../models/orchard_model.dart';

List<Orchard> createOrchardListFromApi(List<dynamic> apiData) {
  return apiData.map((json) {
    return Orchard(
      id: json['_id']?.toString(),
      name: json['name'] ?? 'Unnamed',
      location: json['location'] ?? 'Unknown',
      numberOfFruitingTrees: json['numberOfFruitingTrees'] ?? 0,
      expectedHarvestDate: DateTime.parse(json['expectedHarvestDate']),
      boundaryPoints: (json['boundaryPoints'] as List)
          .map((point) => GPSPoint.fromJson(point))
          .toList(),
      area: (json['area'] as num).toDouble(),
      boundaryImagePath: '', // default placeholder
      cropStage: CropStage.values.firstWhere(
        (e) => e.toString() == 'CropStage.${json['cropstage']}',
        orElse: () => CropStage.walnutSize,
      ),
      quality: OrchardQuality(
        markers: {
          QualityMarker.antiHailNet: QualityStatus.good, // default
          QualityMarker.openFarm: QualityStatus.good,
          QualityMarker.hailingMarks: QualityStatus.good,
          QualityMarker.russetting: QualityStatus.good,
          QualityMarker.underSize: QualityStatus.good,
        },
      ),
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
    );
  }).toList();
}

List<PackHouse> createPackhouseListFromApi(List<dynamic> apiData) {
  return apiData.map((json) {
    print("Packhouse");
    return PackHouse(
        id: json['_id'],
        name: json['name'],
        phoneNumber: json['phoneNumber'],
        address: json["address"],
        gradingMachine: '',
        sortingMachine: '',
        numberOfCrates: json['numberOfCrates'] as int,
        boxesPackedT2: json['boxesPackedT2'] as int,
        boxesPackedT1: json['boxesPackedT1'] as int,
        boxesEstimatedT: json[' boxesEstimatedT'] as int);
  }).toList();
}

List<Grower> createGrowerListFromApi(List<dynamic> apiData) {
  return apiData.map((json) {
    print("Grower");
    return Grower(
      id: json['_id'],
      name: json['name'],
      phoneNumber: json['phoneNumber'],
      address: json["address"],
    );
  }).toList();
}

List<Aadhati> createAadhatiListFromApi(List<dynamic> apiData) {
  return apiData.map((json) {
    print("Aadhati");
    return Aadhati(
        id: json['_id']?.toString(),
        name: json['name'] ?? 'Unnamed',
        contact: json['contact'],
        apmc: json['apmc']);
  }).toList();
}

List<Employee> createEmployeeListFromApi(List<dynamic> apiData) {
  return apiData.map((json) {
    print("Employee");
    return Employee(
      id: json['_id']!.toString(),
      name: json['name'] ?? 'Unnamed',
      phoneNumber: json['phoneNumber'],
    );
  }).toList();
}

List<Ladani> createLadaniListFromApi(List<dynamic> apiData) {
  return apiData.map((json) {
    print("Ladani");
    return Ladani(
        id: json['_id']?.toString(),
        name: json['name'] ?? 'Unnamed',
        contact: json['contact'],
        nameOfTradingFirm: json[' nameOfTradingFirm']);
  }).toList();
}

List<HpmcCollectionCenter> createHPMCListFromApi(List<dynamic> apiData) {
  return apiData.map((item) {
    print("HPMC collection");
    final json = item as Map<String, dynamic>;
    return HpmcCollectionCenter(
      id: json['_id']?.toString(),
      HPMCname: json['hpmcName'] ?? 'Unnamed',
      operatorName: json['operatorName'],
      cellNo: json['cellNo'],
      location: json['location'] ?? 'Unknown',
    );
  }).toList();
}

List<FreightForwarder> createFreightListFromApi(List<dynamic> apiData) {
  return apiData.map((json) {
    print("Freight");
    return FreightForwarder(
      id: json['_id']?.toString(),
      name: json['name'] ?? 'Unnamed',
      contact: json['contact'],
      address: json['address'],
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
    );
  }).toList();
}

List<DrivingProfile> createDriverListFromApi(List<dynamic> apiData) {
  return apiData.map((json) {
    print("Driver");
    return DrivingProfile(
        id: json['_id']?.toString(),
        name: json['name'] ?? 'Unnamed',
        contact: json['contact'],
        noOfTyres: json['noOfTyres']);
  }).toList();
}

List<Transport> createTransportListFromApi(List<dynamic> apiData) {
  return apiData.map((json) {
    print("Transport");
    return Transport(
      id: json['_id']?.toString(),
      name: json['name'] ?? 'Unnamed',
      contact: json['contact'],
      address: json['address'],
    );
  }).toList();
}
