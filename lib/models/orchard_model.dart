import 'package:equatable/equatable.dart';

enum HarvestStatus { planned, inProgress, completed, delayed }

class Orchard  {
  final String id;
  final String name;
  final String location;
  final int numberOfFruitingTrees;
  final DateTime expectedHarvestDate;
  final List<GPSPoint> boundaryPoints;
  final double area; // in hectares
  final String boundaryImagePath;
  final HarvestStatus harvestStatus;
  final String? harvestDelayReason;
  final int? estimatedBoxes;
  final DateTime? actualHarvestDate;
  final DateTime createdAt;
  final DateTime updatedAt;

  const Orchard({
    required this.id,
    required this.name,
    required this.location,
    required this.numberOfFruitingTrees,
    required this.expectedHarvestDate,
    required this.boundaryPoints,
    required this.area,
    required this.boundaryImagePath,
    this.harvestStatus = HarvestStatus.planned,
    this.harvestDelayReason,
    this.estimatedBoxes,
    this.actualHarvestDate,
    required this.createdAt,
    required this.updatedAt,
  });

  factory Orchard.fromJson(Map<String, dynamic> json) {
    return Orchard(
      id: json['id'] as String,
      name: json['name'] as String,
      location: json['location'] as String,
      numberOfFruitingTrees: json['numberOfFruitingTrees'] as int,
      expectedHarvestDate: DateTime.parse(
        json['expectedHarvestDate'] as String,
      ),
      boundaryPoints:
          (json['boundaryPoints'] as List<dynamic>)
              .map((e) => GPSPoint.fromJson(e as Map<String, dynamic>))
              .toList(),
      area: json['area'] as double,
      boundaryImagePath: json['boundaryImagePath'] as String,
      harvestStatus: HarvestStatus.values.firstWhere(
        (e) => e.toString() == 'HarvestStatus.${json['harvestStatus']}',
        orElse: () => HarvestStatus.planned,
      ),
      harvestDelayReason: json['harvestDelayReason'] as String?,
      estimatedBoxes: json['estimatedBoxes'] as int?,
      actualHarvestDate:
          json['actualHarvestDate'] != null
              ? DateTime.parse(json['actualHarvestDate'] as String)
              : null,
      createdAt: DateTime.parse(json['createdAt'] as String),
      updatedAt: DateTime.parse(json['updatedAt'] as String),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'location': location,
      'numberOfFruitingTrees': numberOfFruitingTrees,
      'expectedHarvestDate': expectedHarvestDate.toIso8601String(),
      'boundaryPoints': boundaryPoints.map((e) => e.toJson()).toList(),
      'area': area,
      'boundaryImagePath': boundaryImagePath,
      'harvestStatus': harvestStatus.toString().split('.').last,
      'harvestDelayReason': harvestDelayReason,
      'estimatedBoxes': estimatedBoxes,
      'actualHarvestDate': actualHarvestDate?.toIso8601String(),
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
    };
  }

  Orchard copyWith({
    String? id,
    String? name,
    String? location,
    int? numberOfFruitingTrees,
    DateTime? expectedHarvestDate,
    List<GPSPoint>? boundaryPoints,
    double? area,
    String? boundaryImagePath,
    HarvestStatus? harvestStatus,
    String? harvestDelayReason,
    int? estimatedBoxes,
    DateTime? actualHarvestDate,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return Orchard(
      id: id ?? this.id,
      name: name ?? this.name,
      location: location ?? this.location,
      numberOfFruitingTrees:
          numberOfFruitingTrees ?? this.numberOfFruitingTrees,
      expectedHarvestDate: expectedHarvestDate ?? this.expectedHarvestDate,
      boundaryPoints: boundaryPoints ?? this.boundaryPoints,
      area: area ?? this.area,
      boundaryImagePath: boundaryImagePath ?? this.boundaryImagePath,
      harvestStatus: harvestStatus ?? this.harvestStatus,
      harvestDelayReason: harvestDelayReason ?? this.harvestDelayReason,
      estimatedBoxes: estimatedBoxes ?? this.estimatedBoxes,
      actualHarvestDate: actualHarvestDate ?? this.actualHarvestDate,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  @override
  List<Object?> get props => [
    id,
    name,
    location,
    numberOfFruitingTrees,
    expectedHarvestDate,
    boundaryPoints,
    area,
    boundaryImagePath,
    harvestStatus,
    harvestDelayReason,
    estimatedBoxes,
    actualHarvestDate,
    createdAt,
    updatedAt,
  ];
}

class GPSPoint extends Equatable {
  final double latitude;
  final double longitude;

  const GPSPoint({required this.latitude, required this.longitude});

  factory GPSPoint.fromJson(Map<String, dynamic> json) {
    return GPSPoint(
      latitude: json['latitude'] as double,
      longitude: json['longitude'] as double,
    );
  }

  Map<String, dynamic> toJson() {
    return {'latitude': latitude, 'longitude': longitude};
  }

  @override
  List<Object?> get props => [latitude, longitude];
}
