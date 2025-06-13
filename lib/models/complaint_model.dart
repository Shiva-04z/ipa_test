class Complaint {
  String? id;
  String? complainantName;
  String? complainantRole;
  String? complainantContact;
  String? complaintAgainstName;
  String? complaintAgainstRole;
  String? complaintAgainstContact;
  String? apmcName;
  String? apmcContact;
  String? complaintDescription;
  DateTime? complaintDate;
  String? status; // Pending, Under Review, Resolved, Rejected
  String? resolution;
  DateTime? resolutionDate;

  Complaint({
    this.id,
    this.complainantName,
    this.complainantRole,
    this.complainantContact,
    this.complaintAgainstName,
    this.complaintAgainstRole,
    this.complaintAgainstContact,
    this.apmcName,
    this.apmcContact,
    this.complaintDescription,
    this.complaintDate,
    this.status,
    this.resolution,
    this.resolutionDate,
  });

  factory Complaint.fromJson(Map<String, dynamic> json) {
    return Complaint(
      id: json['id'] as String?,
      complainantName: json['complainantName'] as String?,
      complainantRole: json['complainantRole'] as String?,
      complainantContact: json['complainantContact'] as String?,
      complaintAgainstName: json['complaintAgainstName'] as String?,
      complaintAgainstRole: json['complaintAgainstRole'] as String?,
      complaintAgainstContact: json['complaintAgainstContact'] as String?,
      apmcName: json['apmcName'] as String?,
      apmcContact: json['apmcContact'] as String?,
      complaintDescription: json['complaintDescription'] as String?,
      complaintDate: json['complaintDate'] != null
          ? DateTime.parse(json['complaintDate'] as String)
          : null,
      status: json['status'] as String?,
      resolution: json['resolution'] as String?,
      resolutionDate: json['resolutionDate'] != null
          ? DateTime.parse(json['resolutionDate'] as String)
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'complainantName': complainantName,
      'complainantRole': complainantRole,
      'complainantContact': complainantContact,
      'complaintAgainstName': complaintAgainstName,
      'complaintAgainstRole': complaintAgainstRole,
      'complaintAgainstContact': complaintAgainstContact,
      'apmcName': apmcName,
      'apmcContact': apmcContact,
      'complaintDescription': complaintDescription,
      'complaintDate': complaintDate?.toIso8601String(),
      'status': status,
      'resolution': resolution,
      'resolutionDate': resolutionDate?.toIso8601String(),
    };
  }

  Complaint copyWith({
    String? id,
    String? complainantName,
    String? complainantRole,
    String? complainantContact,
    String? complaintAgainstName,
    String? complaintAgainstRole,
    String? complaintAgainstContact,
    String? apmcName,
    String? apmcContact,
    String? complaintDescription,
    DateTime? complaintDate,
    String? status,
    String? resolution,
    DateTime? resolutionDate,
  }) {
    return Complaint(
      id: id ?? this.id,
      complainantName: complainantName ?? this.complainantName,
      complainantRole: complainantRole ?? this.complainantRole,
      complainantContact: complainantContact ?? this.complainantContact,
      complaintAgainstName: complaintAgainstName ?? this.complaintAgainstName,
      complaintAgainstRole: complaintAgainstRole ?? this.complaintAgainstRole,
      complaintAgainstContact:
          complaintAgainstContact ?? this.complaintAgainstContact,
      apmcName: apmcName ?? this.apmcName,
      apmcContact: apmcContact ?? this.apmcContact,
      complaintDescription: complaintDescription ?? this.complaintDescription,
      complaintDate: complaintDate ?? this.complaintDate,
      status: status ?? this.status,
      resolution: resolution ?? this.resolution,
      resolutionDate: resolutionDate ?? this.resolutionDate,
    );
  }
}
