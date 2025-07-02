class User {
  String? id;
  String? name;
  String? contact;
  String? aadhar;
  String? email;
  String? role;
  String? roledocID;
  String? address;
  String? village;
  String? profileImage;
  DateTime? createdAt;
  DateTime? lastLogin;
  bool? isActive;

  User({
    this.id,
    this.name,
    this.aadhar,
    this.contact,
    this.email,
    this.role,
    this.roledocID,
    this.address,
    this.village,
    this.profileImage,
    this.createdAt,
    this.lastLogin,
    this.isActive,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'] as String?,
      name: json['name'] as String?,
      contact: json['contact'] as String?,
      aadhar: json['aadhar'] as String?,
      email: json['email'] as String?,
      role: json['role'] as String?,
      roledocID: json['roledocID'],
      address: json['address'] as String?,
      village: json['village'] as String?,
      profileImage: json['profileImage'] as String?,
      createdAt: json['createdAt'] != null
          ? DateTime.parse(json['createdAt'] as String)
          : null,
      lastLogin: json['lastLogin'] != null
          ? DateTime.parse(json['lastLogin'] as String)
          : null,
      isActive: json['isActive'] as bool?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'contact': contact,
      'aadhar': aadhar,
      'email': email,
      'role': role,
      'address': address,
      'village': village,
      'roledocID': roledocID,
      'profileImage': profileImage,
      'createdAt': createdAt?.toIso8601String(),
      'lastLogin': lastLogin?.toIso8601String(),
      'isActive': isActive,
    };
  }

  User copyWith({
    String? id,
    String? name,
    String? contact,
    String? aadhar,
    String? email,
    String? role,
    String? address,
    String? village,
    String? profileImage,
    DateTime? createdAt,
    DateTime? lastLogin,
    bool? isActive,
    String? roledocID
  }) {
    return User(
      id: id ?? this.id,
      name: name ?? this.name,
      contact: contact ?? this.contact,
      aadhar: aadhar ?? this.aadhar,
      email: email ?? this.email,
      role: role ?? this.role,
      address: address ?? this.address,
      village: village ?? this.village,
      profileImage: profileImage ?? this.profileImage,
      createdAt: createdAt ?? this.createdAt,
      lastLogin: lastLogin ?? this.lastLogin,
      isActive: isActive ?? this.isActive,
      roledocID: roledocID ?? this.roledocID,
    );
  }
}
