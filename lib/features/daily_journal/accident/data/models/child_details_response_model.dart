class ChildDetailsResponseModel {
  final String status;
  final ChildDetailModel child;

  ChildDetailsResponseModel({
    required this.status,
    required this.child,
  });

  factory ChildDetailsResponseModel.fromJson(Map<String, dynamic> json) {
    return ChildDetailsResponseModel(
      status: json['Status'] ?? '',
      child: ChildDetailModel.fromJson(json['Child'] ?? {}),
    );
  }
}

class ChildDetailModel {
  final int id;
  final String name;
  final String lastname;
  final String dob;
  final String startDate;
  final int room;
  final String imageUrl;
  final String gender;
  final String status;
  final String daysAttending;
  final int centerId;
  final int createdBy;
  final String createdAt;

  ChildDetailModel({
    required this.id,
    required this.name,
    required this.lastname,
    required this.dob,
    required this.startDate,
    required this.room,
    required this.imageUrl,
    required this.gender,
    required this.status,
    required this.daysAttending,
    required this.centerId,
    required this.createdBy,
    required this.createdAt,
  });

  factory ChildDetailModel.fromJson(Map<String, dynamic> json) {
    return ChildDetailModel(
      id: json['id'] ?? 0,
      name: json['name'] ?? '',
      lastname: json['lastname'] ?? '',
      dob: json['dob'] ?? '',
      startDate: json['startDate'] ?? '',
      room: json['room'] ?? 0,
      imageUrl: json['imageUrl'] ?? '',
      gender: json['gender'] ?? '',
      status: json['status'] ?? '',
      daysAttending: json['daysAttending'] ?? '',
      centerId: json['centerid'] ?? 0,
      createdBy: json['createdBy'] ?? 0,
      createdAt: json['createdAt'] ?? '',
    );
  }
}