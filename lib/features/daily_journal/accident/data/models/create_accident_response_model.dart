class CreateAccidentResponseModel {
  final bool status;
  final String message;
  final CreateAccidentData data;

  CreateAccidentResponseModel({
    required this.status,
    required this.message,
    required this.data,
  });

  factory CreateAccidentResponseModel.fromJson(Map<String, dynamic> json) {
    return CreateAccidentResponseModel(
      status: json['status'] ?? false,
      message: json['message'] ?? '',
      data: CreateAccidentData.fromJson(json['data'] ?? {}),
    );
  }
}

class CreateAccidentData {
  final List<ChildrenData> children;
  final String centerId;
  final String roomId;

  CreateAccidentData({
    required this.children,
    required this.centerId,
    required this.roomId,
  });

  factory CreateAccidentData.fromJson(Map<String, dynamic> json) {
    return CreateAccidentData(
      children: List<ChildrenData>.from(
          (json['Childrens'] ?? []).map((x) => ChildrenData.fromJson(x))),
      centerId: json['centerid'] ?? '',
      roomId: json['roomid'] ?? '',
    );
  }
}

class ChildrenData {
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
  final String details;

  ChildrenData({
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
    required this.details,
  });

  factory ChildrenData.fromJson(Map<String, dynamic> json) {
    return ChildrenData(
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
      details: json['details'] ?? '',
    );
  }
}