import 'package:latlong2/latlong.dart';

class HpPolice {
  final String id;
  final String name;
  final String cellNo;
  final String adharId;
  final String beltNo;
  final String rank;
  final String reportingOfficer;
  final String dutyLocation;
  final LatLng location;
  final bool isActive;
  final DateTime createdAt;
  final DateTime updatedAt;

  HpPolice({
    required this.id,
    required this.name,
    required this.cellNo,
    required this.adharId,
    required this.beltNo,
    required this.rank,
    required this.reportingOfficer,
    required this.dutyLocation,
    required this.location,
    this.isActive = true,
    required this.createdAt,
    required this.updatedAt,
  });

  factory HpPolice.fromJson(Map<String, dynamic> json) {
    return HpPolice(
      id: json['id'] as String,
      name: json['name'] as String,
      cellNo: json['cellNo'] as String,
      adharId: json['adharId'] as String,
      beltNo: json['beltNo'] as String,
      rank: json['rank'] as String,
      reportingOfficer: json['reportingOfficer'] as String,
      dutyLocation: json['dutyLocation'] as String,
      location: LatLng(
        json['location']['latitude'] as double,
        json['location']['longitude'] as double,
      ),
      isActive: json['isActive'] as bool,
      createdAt: DateTime.parse(json['createdAt'] as String),
      updatedAt: DateTime.parse(json['updatedAt'] as String),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'cellNo': cellNo,
      'adharId': adharId,
      'beltNo': beltNo,
      'rank': rank,
      'reportingOfficer': reportingOfficer,
      'dutyLocation': dutyLocation,
      'location': {
        'latitude': location.latitude,
        'longitude': location.longitude,
      },
      'isActive': isActive,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
    };
  }

  HpPolice copyWith({
    String? id,
    String? name,
    String? cellNo,
    String? adharId,
    String? beltNo,
    String? rank,
    String? reportingOfficer,
    String? dutyLocation,
    LatLng? location,
    bool? isActive,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return HpPolice(
      id: id ?? this.id,
      name: name ?? this.name,
      cellNo: cellNo ?? this.cellNo,
      adharId: adharId ?? this.adharId,
      beltNo: beltNo ?? this.beltNo,
      rank: rank ?? this.rank,
      reportingOfficer: reportingOfficer ?? this.reportingOfficer,
      dutyLocation: dutyLocation ?? this.dutyLocation,
      location: location ?? this.location,
      isActive: isActive ?? this.isActive,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}

class RestrictedArea {
  final String id;
  final String name;
  final String type; // 'restricted', 'diversion', 'landslide'
  final List<LatLng> coordinates;
  final String description;
  final DateTime startTime;
  final DateTime? endTime;
  final bool isActive;
  final DateTime createdAt;
  final DateTime updatedAt;

  RestrictedArea({
    required this.id,
    required this.name,
    required this.type,
    required this.coordinates,
    required this.description,
    required this.startTime,
    this.endTime,
    this.isActive = true,
    required this.createdAt,
    required this.updatedAt,
  });

  factory RestrictedArea.fromJson(Map<String, dynamic> json) {
    return RestrictedArea(
      id: json['id'] as String,
      name: json['name'] as String,
      type: json['type'] as String,
      coordinates: (json['coordinates'] as List)
          .map((coord) => LatLng(
                coord['latitude'] as double,
                coord['longitude'] as double,
              ))
          .toList(),
      description: json['description'] as String,
      startTime: DateTime.parse(json['startTime'] as String),
      endTime: json['endTime'] != null
          ? DateTime.parse(json['endTime'] as String)
          : null,
      isActive: json['isActive'] as bool,
      createdAt: DateTime.parse(json['createdAt'] as String),
      updatedAt: DateTime.parse(json['updatedAt'] as String),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'type': type,
      'coordinates': coordinates
          .map((coord) => {
                'latitude': coord.latitude,
                'longitude': coord.longitude,
              })
          .toList(),
      'description': description,
      'startTime': startTime.toIso8601String(),
      'endTime': endTime?.toIso8601String(),
      'isActive': isActive,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
    };
  }
}

class TrackedVehicle {
  final String id;
  final String vehicleNumber;
  final String driverName;
  final String driverPhone;
  final LatLng currentLocation;
  final String status; // 'in_apmc', 'waiting', 'loading', 'in_transit'
  final DateTime lastUpdated;
  final DateTime createdAt;

  TrackedVehicle({
    required this.id,
    required this.vehicleNumber,
    required this.driverName,
    required this.driverPhone,
    required this.currentLocation,
    required this.status,
    required this.lastUpdated,
    required this.createdAt,
  });

  factory TrackedVehicle.fromJson(Map<String, dynamic> json) {
    return TrackedVehicle(
      id: json['id'] as String,
      vehicleNumber: json['vehicleNumber'] as String,
      driverName: json['driverName'] as String,
      driverPhone: json['driverPhone'] as String,
      currentLocation: LatLng(
        json['currentLocation']['latitude'] as double,
        json['currentLocation']['longitude'] as double,
      ),
      status: json['status'] as String,
      lastUpdated: DateTime.parse(json['lastUpdated'] as String),
      createdAt: DateTime.parse(json['createdAt'] as String),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'vehicleNumber': vehicleNumber,
      'driverName': driverName,
      'driverPhone': driverPhone,
      'currentLocation': {
        'latitude': currentLocation.latitude,
        'longitude': currentLocation.longitude,
      },
      'status': status,
      'lastUpdated': lastUpdated.toIso8601String(),
      'createdAt': createdAt.toIso8601String(),
    };
  }
}
