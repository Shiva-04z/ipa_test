class Post {
  String? nameOfDutyOfficer;
  String? designationRank;
  String? placeOfAppleSeason2025Duty;
  String? googleLocationOfDutyPlace;
  String? vehicleRegistrationNo;
  int? noOfBoxesLoaded;
  String? destinationMarketOfVehicle;

  Post({
    this.nameOfDutyOfficer,
    this.designationRank,
    this.placeOfAppleSeason2025Duty,
    this.googleLocationOfDutyPlace,
    this.vehicleRegistrationNo,
    this.noOfBoxesLoaded,
    this.destinationMarketOfVehicle,
  });

  factory Post.fromJson(Map<String, dynamic> json) {
    return Post(
      nameOfDutyOfficer: json['nameOfDutyOfficer'] as String?,
      designationRank: json['designationRank'] as String?,
      placeOfAppleSeason2025Duty: json['placeOfAppleSeason2025Duty'] as String?,
      googleLocationOfDutyPlace: json['googleLocationOfDutyPlace'] as String?,
      vehicleRegistrationNo: json['vehicleRegistrationNo'] as String?,
      noOfBoxesLoaded: json['noOfBoxesLoaded'] as int?,
      destinationMarketOfVehicle: json['destinationMarketOfVehicle'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'nameOfDutyOfficer': nameOfDutyOfficer,
      'designationRank': designationRank,
      'placeOfAppleSeason2025Duty': placeOfAppleSeason2025Duty,
      'googleLocationOfDutyPlace': googleLocationOfDutyPlace,
      'vehicleRegistrationNo': vehicleRegistrationNo,
      'noOfBoxesLoaded': noOfBoxesLoaded,
      'destinationMarketOfVehicle': destinationMarketOfVehicle,
    };
  }

  Post copyWith({
    String? nameOfDutyOfficer,
    String? designationRank,
    String? placeOfAppleSeason2025Duty,
    String? googleLocationOfDutyPlace,
    String? vehicleRegistrationNo,
    int? noOfBoxesLoaded,
    String? destinationMarketOfVehicle,
  }) {
    return Post(
      nameOfDutyOfficer: nameOfDutyOfficer ?? this.nameOfDutyOfficer,
      designationRank: designationRank ?? this.designationRank,
      placeOfAppleSeason2025Duty:
          placeOfAppleSeason2025Duty ?? this.placeOfAppleSeason2025Duty,
      googleLocationOfDutyPlace:
          googleLocationOfDutyPlace ?? this.googleLocationOfDutyPlace,
      vehicleRegistrationNo:
          vehicleRegistrationNo ?? this.vehicleRegistrationNo,
      noOfBoxesLoaded: noOfBoxesLoaded ?? this.noOfBoxesLoaded,
      destinationMarketOfVehicle:
          destinationMarketOfVehicle ?? this.destinationMarketOfVehicle,
    );
  }
}
