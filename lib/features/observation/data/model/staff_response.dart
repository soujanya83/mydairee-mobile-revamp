class StaffResponse {
  final List<StaffModel> staff;
  final String status;
  final String message;

  StaffResponse({
    required this.staff,
    required this.status,
    required this.message,
  });

  factory StaffResponse.fromJson(Map<String, dynamic> json) {
    return StaffResponse(
      staff: (json['staff'] as List?)
          ?.map((staff) => StaffModel.fromJson(staff))
          .toList() ?? [],
      status: json['status'] ?? '',
      message: json['message'] ?? '',
    );
  }
}

class StaffModel {
  final int id;
  final int userid;
  final String username;
  final String email;
  final String name;
  final String userType;
  final String title;
  final String status;
  final String imageUrl;

  StaffModel({
    required this.id,
    required this.userid,
    required this.username,
    required this.email,
    required this.name,
    required this.userType,
    required this.title,
    required this.status,
    required this.imageUrl,
  });

  factory StaffModel.fromJson(Map<String, dynamic> json) {
    return StaffModel(
      id: json['id'] ?? 0,
      userid: json['userid'] ?? 0,
      username: json['username'] ?? '',
      email: json['email'] ?? '',
      name: json['name'] ?? '',
      userType: json['userType'] ?? '',
      title: json['title'] ?? '',
      status: json['status'] ?? '',
      imageUrl: json['imageUrl'] ?? '',
    );
  }
}