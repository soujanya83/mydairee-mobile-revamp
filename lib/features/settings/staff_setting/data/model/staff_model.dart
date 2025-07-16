class StaffModel {
  final String id;
  final String name;
  final String email;
  final String password;
  final String contactNo;
  final String gender;
  final String avatarUrl;
  final String userType;

  StaffModel({
    required this.id,
    required this.name,
    required this.email,
    required this.password,
    required this.contactNo,
    required this.gender,
    required this.avatarUrl,
    required this.userType,
  });

  factory StaffModel.fromJson(Map<String, dynamic> json) {
    return StaffModel(
      id: json['id']?.toString() ?? '',
      name: json['name'] ?? '',
      email: json['email'] ?? '',
      password: json['password'] ?? '',
      contactNo: json['contactNo'] ?? '',
      gender: json['gender'] ?? '',
      avatarUrl: json['avatarUrl'] ?? '',
      userType: json['userType'] ?? 'Staff',
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'email': email,
        'password': password,
        'contactNo': contactNo,
        'gender': gender,
        'avatarUrl': avatarUrl,
        'userType': userType,
      };
}