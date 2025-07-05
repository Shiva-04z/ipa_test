import 'package:apple_grower/models/bilty_model.dart';
import 'package:geocoding/geocoding.dart';

class Consignment {
  String? id;
  String? growerId;
  String? growerName;
  String? searchId;
  String? trip1Driverid;
  String? startPointTrip1;
  String? startPointAddressTrip1;
  String? endPointTrip1;
  String? endPointAddressTrip1;
  String? packhouseId;
  String? startPointTrip2;
  String? startPointAddressTrip2;
  String? trip2Driverid;
  String? approval1;//Associated
  String? approval;//Driver
  String? endPointTrip2;
  String? endPointAddressTrip2;
  String? currentStage;
  String? aadhatiId;
  double? totalWeight;
  Bilty? bilty;
  String? status;
  String? driverMode;
  String? packHouseMode;
  String?  aadhatiMode;
  String? startTime;
  String? date;

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
        this.growerName,
        this.approval1,
       this.aadhatiMode,
    this.driverMode,
   this.packHouseMode,
        this.date,
      this.startTime});

  // Factory constructor to create a Consignment from JSON
  factory Consignment.fromJson(Map<String, dynamic> json) {



    return Consignment(
      growerName: json['growerName'],
      id: json['_id'],
      growerId: json['growerId'],
      searchId: json['searchId'],
      trip1Driverid: json['trip1Driverid'],
      startPointTrip1: json['startPointTrip1'],
      startPointAddressTrip1: json['startPointAddressTrip1'],
      endPointTrip1: json['endPointTrip1'],
      endPointAddressTrip1: json['endPointAddressTrip1'],
      packhouseId: json['packhouseId'],
      startPointTrip2: json['startPointTrip2'],
      startPointAddressTrip2: json['startPointAddressTrip2'],
      trip2Driverid: json['trip2Driverid'],
      approval: json['approval'], approval1: json['approval1'],
      endPointTrip2: json['endPointTrip2'],
      endPointAddressTrip2: json['endPointAddressTrip2'],
      currentStage: json['currentStage'],
      aadhatiId: json['aadhatiId'],
      totalWeight: json['totalWeight']?.toDouble(),
      status: json['status'],
      bilty: json['bilty'] != null ? Bilty.fromJson(json['bilty']) : null,
      aadhatiMode: json['aadhatiMode'],
        driverMode: json['driverMode'],
      packHouseMode:  json ['packHouseMode'],
      startTime: json['startTime'],
      date: json['date'],
    );
  }

  // Convert Consignment to JSON
  Map<String, dynamic> toJson() {


    return {
      'growerId': growerId,
      'growerName':growerName,
      'searchId': searchId,
      'trip1Driverid': trip1Driverid,
      'startPointTrip1': startPointTrip1,
      'startPointAddressTrip1': startPointAddressTrip1,
      'endPointTrip1':endPointTrip1,
      'endPointAddressTrip1': endPointAddressTrip1,
      'packhouseId': packhouseId,
      'startPointTrip2': startPointTrip2,
      'startPointAddressTrip2': startPointAddressTrip2,
      'trip2Driverid': trip2Driverid,
      'approval': approval,
      'approval1': approval1,
      'endPointTrip2': endPointTrip2,
      'endPointAddressTrip2': endPointAddressTrip2,
      'currentStage': currentStage,
      'aadhatiId': aadhatiId,
      'totalWeight': totalWeight,
      'bilty': bilty?.toJson(),
      'status': status,
      'aadhatiMode': aadhatiMode,
      'packHouseMode' : packHouseMode,
      'driverMode' : driverMode,
      'date':date,
      'startTime':startTime
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
