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
    return PackHouse(
      id: json['_id'],
      name: json['name'],
      phoneNumber: json['phoneNumber'],
      address: json["address"],
      gradingMachine: '',
      sortingMachine: '',
      numberOfCrates: 0,
      boxesPacked2023: 0,
      boxesPacked2024: 0,
      estimatedBoxes2025: 0,
    );
  }).toList();
}

List<Grower> createGrowerListFromApi(List<dynamic> apiData) {
  return apiData.map((json) {
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
    print(json);
    return Aadhati(
        id: json['_id']?.toString(),
        name: json['name'] ?? 'Unnamed',
        contact: json['contact'],
        apmc: json['apmc']);
  }).toList();

}

List<Employee> createEmployeeListFromApi(List<dynamic> apiData) {
  return apiData.map((json) {
    return Employee(
      id: json['_id']!.toString(),
      name: json['name'] ?? 'Unnamed',
      phoneNumber: json['phoneNumber'],
    );
  }).toList();
}

List<Ladani> createLadaniListFromApi(List<dynamic> apiData) {
  return apiData.map((json) {
    return Ladani(
        id: json['_id']?.toString(),
        name: json['name'] ?? 'Unnamed',
        contact: json['contact'],
        nameOfTradingFirm: json[' nameOfTradingFirm']);
  }).toList();
}

List<HpmcCollectionCenter> createHPMCListFromApi(List<dynamic> apiData) {
  return apiData.map((json) {
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
    return DrivingProfile(
      id: json['_id']?.toString(),
      name: json['name'] ?? 'Unnamed',
      contact: json['contact'],
        noOfTyres: json['noOfTyres']
    );
  }).toList();
}

List<Transport> createTransportListFromApi(List<dynamic> apiData) {
  return apiData.map((json) {
    return Transport(
      id: json['_id']?.toString(),
      name: json['name'] ?? 'Unnamed',
      contact: json['contact'],
      address: json['address'],
    );
  }).toList();
}
