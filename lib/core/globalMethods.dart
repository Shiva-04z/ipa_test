import 'package:apple_grower/models/aadhati.dart';
import 'package:apple_grower/models/consignment_model.dart';
import 'package:apple_grower/models/driving_profile_model.dart';
import 'package:apple_grower/models/employee_model.dart';
import 'package:apple_grower/models/freightForwarder.dart';
import 'package:apple_grower/models/grower_model.dart';
import 'package:apple_grower/models/hpmc_collection_center_model.dart';
import 'package:apple_grower/models/pack_house_model.dart';
import 'package:apple_grower/models/transport_model.dart';
import '../models/bilty_model.dart';
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
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
    );
  }).toList();
}


List<Consignment> createConsignmentListFromApi(List<dynamic> apiData) {
  print("HQ");
  return apiData.map((json) {
    return Consignment(
        id: json['_id'],
        growerId: json['growerId'] ,
        growerName: json['growerName'],
        searchId: json['searchId'],
        trip1Driverid: json['trip1Driverid'],
        startPointAddressTrip1: json['startPointTrip1'],
        endPointAddressTrip1: json['endPointTrip1'],
        packhouseId: json['packhouseId'],
        startPointAddressTrip2: json['startPointAddressTrip2'],
        trip2Driverid: json['trip2Driverid'],
        approval: json['approval'], approval1: json['approval1'],
        endPointAddressTrip2: json['endPointAddressTrip2'],
        currentStage: json['currentStage'],
        aadhatiId: json['aadhatiId'],
        totalWeight: json['totalWeight']?.toDouble(),
        status: json['status'],
        bilty: json['bilty'] != null ? Bilty.fromJson(json['bilty']) : null,
        aadhatiMode: json['aadhatiMode'],
        driverMode: json['driverMode'],
        packHouseMode:  json ['packHouseMode']
    );
  }).toList();
}

List<PackHouse> createPackhouseListFromApi(List<dynamic> apiData) {
  return apiData.map((json) {
    print("PackHouse");
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
        boxesEstimatedT: json['boxesEstimatedT'] as int);
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
