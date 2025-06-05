enum PackingHouseType { own, thirdParty, none }

class PackingHouse {
  final String id;
  final PackingHouseType type;
  final String? packingHouseName;
  final String? packingHouseAddress;
  final String? packingHousePhone;
  final DateTime createdAt;
  final DateTime updatedAt;

  const PackingHouse({
    required this.id,
    required this.type,
    this.packingHouseName,
    this.packingHouseAddress,
    this.packingHousePhone,
    required this.createdAt,
    required this.updatedAt,
  });

  factory PackingHouse.fromJson(Map<String, dynamic> json) {
    return PackingHouse(
      id: json['id'] as String,
      type: PackingHouseType.values.firstWhere(
        (e) => e.toString() == 'PackingHouseType.${json['type']}',
      ),
      packingHouseName: json['packingHouseName'] as String?,
      packingHouseAddress: json['packingHouseAddress'] as String?,
      packingHousePhone: json['packingHousePhone'] as String?,
      createdAt: DateTime.parse(json['createdAt'] as String),
      updatedAt: DateTime.parse(json['updatedAt'] as String),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'type': type.toString().split('.').last,
      'packingHouseName': packingHouseName,
      'packingHouseAddress': packingHouseAddress,
      'packingHousePhone': packingHousePhone,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
    };
  }

  PackingHouse copyWith({
    String? id,
    PackingHouseType? type,
    String? packingHouseName,
    String? packingHouseAddress,
    String? packingHousePhone,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return PackingHouse(
      id: id ?? this.id,
      type: type ?? this.type,
      packingHouseName: packingHouseName ?? this.packingHouseName,
      packingHouseAddress: packingHouseAddress ?? this.packingHouseAddress,
      packingHousePhone: packingHousePhone ?? this.packingHousePhone,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  @override
  List<Object?> get props => [
    id,
    type,
    packingHouseName,
    packingHouseAddress,
    packingHousePhone,
    createdAt,
    updatedAt,
  ];
}
