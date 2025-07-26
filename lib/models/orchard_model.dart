import 'package:equatable/equatable.dart';

enum CropStage {
  walnutSize,
  fruitDevelopment,
  colourInitiation,
  fiftyPercentColour,
  eightyPercentColour,
  harvest,
}

enum QualityMarker {
  antiHailNet,
  openFarm,
  hailingMarks,
  russetting,
  underSize
}

enum QualityStatus {
  good, // Green
  average, // Blue
  poor // Red
}

class OrchardQuality {
  final Map<QualityMarker, QualityStatus> markers;

  const OrchardQuality({
    this.markers = const {
      QualityMarker.antiHailNet: QualityStatus.good,
      QualityMarker.openFarm: QualityStatus.good,
      QualityMarker.hailingMarks: QualityStatus.good,
      QualityMarker.russetting: QualityStatus.good,
      QualityMarker.underSize: QualityStatus.good,
    },
  });

  factory OrchardQuality.fromJson(Map<String, dynamic> json) {
    final markers = <QualityMarker, QualityStatus>{};
    json.forEach((key, value) {
      markers[QualityMarker.values.firstWhere(
        (e) => e.toString() == 'QualityMarker.$key',
      )] = QualityStatus.values.firstWhere(
        (e) => e.toString() == 'QualityStatus.$value',
      );
    });
    return OrchardQuality(markers: markers);
  }

  Map<String, dynamic> toJson() {
    final map = <String, String>{};
    markers.forEach((key, value) {
      map[key.toString().split('.').last] = value.toString().split('.').last;
    });
    return map;
  }

  OrchardQuality copyWith({
    Map<QualityMarker, QualityStatus>? markers,
  }) {
    return OrchardQuality(
      markers: markers ?? this.markers,
    );
  }
}

class Orchard {
 final String? id;
  final String name;
  final String location;
  final int numberOfFruitingTrees;
  final DateTime? expectedHarvestDate;
  final List<GPSPoint> boundaryPoints;
  final double area; // in hectares
  final String boundaryImagePath;
  final CropStage cropStage;
  final OrchardQuality quality;
  final String? harvestDelayReason;
  final int? estimatedBoxes;
  final DateTime? actualHarvestDate;
  final DateTime createdAt;
  final DateTime updatedAt;

  const Orchard({
  this.id,
    required this.name,
    required this.location,
    required this.numberOfFruitingTrees,
    required this.expectedHarvestDate,
    required this.boundaryPoints,
    required this.area,
    required this.boundaryImagePath,
    this.cropStage = CropStage.walnutSize,
    this.quality = const OrchardQuality(),
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
      boundaryPoints: (json['boundaryPoints'] as List<dynamic>)
          .map((e) => GPSPoint.fromJson(e as Map<String, dynamic>))
          .toList(),
      area: json['area'] as double,
      boundaryImagePath: json['boundaryImagePath'] as String,
      cropStage: CropStage.values.firstWhere(
        (e) => e.toString() == 'CropStage.${json['cropStage']}',
        orElse: () => CropStage.walnutSize,
      ),
      quality: json['quality'] != null
          ? OrchardQuality.fromJson(json['quality'] as Map<String, dynamic>)
          : const OrchardQuality(),
      harvestDelayReason: json['harvestDelayReason'] as String?,
      estimatedBoxes: json['estimatedBoxes'] as int?,
      actualHarvestDate: json['actualHarvestDate'] != null
          ? DateTime.parse(json['actualHarvestDate'] as String)
          : null,
      createdAt: DateTime.parse(json['createdAt'] as String),
      updatedAt: DateTime.parse(json['updatedAt'] as String),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'location': location,
      'fruitingTrees': numberOfFruitingTrees,
      'expectedHarvestDate': expectedHarvestDate?.toIso8601String(),
      'boundaryPoints': boundaryPoints?.map((e) => e.toJson())?.toList(),
      'area': area,
      'boundaryImagePath': boundaryImagePath,
      'cropStage': cropStage?.toString()?.split('.')?.last,
      'harvestDelayReason': harvestDelayReason,
      'estimatedBoxes': estimatedBoxes,
      'actualHarvestDate': actualHarvestDate?.toIso8601String(),
      'createdAt': createdAt?.toIso8601String(),
      'updatedAt': updatedAt?.toIso8601String(),
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
    CropStage? cropStage,
    OrchardQuality? quality,
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
      cropStage: cropStage ?? this.cropStage,
      quality: quality ?? this.quality,
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
        cropStage,
        quality,
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

  GPSPoint copyWith({
    double? latitude,
    double? longitude,
  }) {
    return GPSPoint(
      latitude: latitude ?? this.latitude,
      longitude: longitude ?? this.longitude,
    );
  }

  @override
  List<Object?> get props => [latitude, longitude];
}
