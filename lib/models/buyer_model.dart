class Buyer {
  final String id;
  final String name;
  final String phoneNumber;
  final String address;
  final String? gstNumber;
  final String? businessType;
  final DateTime createdAt;
  final DateTime updatedAt;

  Buyer({
    required this.id,
    required this.name,
    required this.phoneNumber,
    required this.address,
    this.gstNumber,
    this.businessType,
    required this.createdAt,
    required this.updatedAt,
  });

  factory Buyer.fromJson(Map<String, dynamic> json) {
    return Buyer(
      id: json['id'] as String,
      name: json['name'] as String,
      phoneNumber: json['phoneNumber'] as String,
      address: json['address'] as String,
      gstNumber: json['gstNumber'] as String?,
      businessType: json['businessType'] as String?,
      createdAt: DateTime.parse(json['createdAt'] as String),
      updatedAt: DateTime.parse(json['updatedAt'] as String),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'phoneNumber': phoneNumber,
      'address': address,
      'gstNumber': gstNumber,
      'businessType': businessType,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
    };
  }

  Buyer copyWith({
    String? id,
    String? name,
    String? phoneNumber,
    String? address,
    String? gstNumber,
    String? businessType,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return Buyer(
      id: id ?? this.id,
      name: name ?? this.name,
      phoneNumber: phoneNumber ?? this.phoneNumber,
      address: address ?? this.address,
      gstNumber: gstNumber ?? this.gstNumber,
      businessType: businessType ?? this.businessType,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}
