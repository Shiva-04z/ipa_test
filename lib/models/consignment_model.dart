import 'package:apple_grower/models/bilty_model.dart';
import 'package:geocoding/geocoding.dart';

class Consignment {
  String? id;
  String? growerId;
  String? searchId;
  String? trip1Driverid;
  Location? startPointTrip1;
  String? startPointAddressTrip1;
  Location? endPointTrip1;
  String? endPointAddressTrip1;
  String? packhouseId;
  Location? startPointTrip2;
  String? startPointAddressTrip2;
  String? trip2Driverid;
  String? approval;
  Location? endPointTrip2;
  String? endPointAddressTrip2;
  String? currentStage;
  String? aadhatiId;
  double? totalWeight;
  Bilty? bilty;
  String? status;
  String? driverMode;
  String? packHouseMode;
  String?  aadhatiMode;

  Consignment(
      {required this.searchId,
      this.trip1Driverid,
      this.startPointAddressTrip1,
      this.endPointAddressTrip1,
      this.bilty,
      this.packhouseId,
      this.currentStage,
      this.endPointTrip1,
      this.startPointTrip1,
      this.totalWeight,
      this.aadhatiId,
      this.endPointAddressTrip2,
      this.endPointTrip2,
      this.startPointAddressTrip2,
      this.trip2Driverid,
      this.startPointTrip2,
      this.growerId,this.status,
      this.id,
      this.approval,
       this.aadhatiMode,
    this.driverMode,
   this.packHouseMode,});

  // Factory constructor to create a Consignment from JSON
  factory Consignment.fromJson(Map<String, dynamic> json) {
    Location? parseLocation(Map<String, dynamic>? loc) {
      if (loc == null) return null;
      return Location(
        latitude: (loc['latitude'] as num).toDouble(),
        longitude: (loc['longitude'] as num).toDouble(),
        timestamp: DateTime.now(), // No timestamp in JSON, use now
      );
    }

    return Consignment(
      id: json['_id'],
      growerId: json['growerId'],
      searchId: json['searchId'],
      trip1Driverid: json['trip1Driverid'],
      startPointTrip1: parseLocation(json['startPointTrip1']),
      startPointAddressTrip1: json['startPointAddressTrip1'],
      endPointTrip1: parseLocation(json['endPointTrip1']),
      endPointAddressTrip1: json['endPointAddressTrip1'],
      packhouseId: json['packhouseId'],
      startPointTrip2: parseLocation(json['startPointTrip2']),
      startPointAddressTrip2: json['startPointAddressTrip2'],
      trip2Driverid: json['trip2Driverid'],
      approval: json['approval'],
      endPointTrip2: parseLocation(json['endPointTrip2']),
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
  }

  // Convert Consignment to JSON
  Map<String, dynamic> toJson() {
    Map<String, dynamic>? locToJson(Location? loc) {
      if (loc == null) return null;
      return {
        'latitude': loc.latitude,
        'longitude': loc.longitude,
      };
    }

    return {
      'growerId': growerId,
      'searchId': searchId,
      'trip1Driverid': trip1Driverid,
      'startPointTrip1': locToJson(startPointTrip1),
      'startPointAddressTrip1': startPointAddressTrip1,
      'endPointTrip1': locToJson(endPointTrip1),
      'endPointAddressTrip1': endPointAddressTrip1,
      'packhouseId': packhouseId,
      'startPointTrip2': locToJson(startPointTrip2),
      'startPointAddressTrip2': startPointAddressTrip2,
      'trip2Driverid': trip2Driverid,
      'approval': approval,
      'endPointTrip2': locToJson(endPointTrip2),
      'endPointAddressTrip2': endPointAddressTrip2,
      'currentStage': currentStage,
      'aadhatiId': aadhatiId,
      'totalWeight': totalWeight,
      'bilty': bilty?.toJson(),
      'status': status,
      'aadhatiMode': aadhatiMode,
      'packHouseMode' : packHouseMode,
      'driverMode' : driverMode
    };
  }

  updateMongoId(String id) {
    this.id = id;
  }

  updateStage(String stage) {
    this.currentStage = stage;
  }
  updateStatus(String status)
  {
    this.status = status;
  }

}
