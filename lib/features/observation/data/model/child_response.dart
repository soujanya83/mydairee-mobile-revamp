class ChildrenResponse {
  final List<ChildObservationModel> children;
  final bool success;
  final String status;

  ChildrenResponse({
    required this.children,
    required this.success,
    required this.status,
  });

  factory ChildrenResponse.fromJson(Map<String, dynamic> json) {
    return ChildrenResponse(
      children: (json['children'] as List?)
          ?.map((child) => ChildObservationModel.fromJson(child))
          .toList() ?? [],
      success: json['success'] ?? false,
      status: json['status'] ?? '',
    );
  }
}

class ChildObservationModel {
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
  final int centerid;

  ChildObservationModel({
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
    required this.centerid,
  });

  factory ChildObservationModel.fromJson(Map<String, dynamic> json) {
    return ChildObservationModel(
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
      centerid: json['centerid'] ?? 0,
    );
  }
}