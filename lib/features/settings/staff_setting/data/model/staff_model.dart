class StaffModel {
  final int id;
  final int? userid;
  final String? username;
  final String? emailid;
  final String email;
  final String contactNo;
  final String name;
  final int? centerStatus;
  final String? dob;
  final String gender;
  final String imageUrl;
  final String userType;
  final String? title;
  final String? status;
  final String? createdAt;
  final String? updatedAt;

  StaffModel({
    required this.id,
    this.userid,
    this.username,
    this.emailid,
    required this.email,
    required this.contactNo,
    required this.name,
    this.centerStatus,
    this.dob,
    required this.gender,
    required this.imageUrl,
    required this.userType,
    this.title,
    this.status,
    this.createdAt,
    this.updatedAt,
  });

  factory StaffModel.fromJson(Map<String, dynamic> json) {
    return StaffModel(
      id: json['id'] is int ? json['id'] : int.tryParse(json['id'].toString()) ?? 0,
      userid: json['userid'] is int ? json['userid'] : int.tryParse(json['userid']?.toString() ?? ''),
      username: json['username'],
      emailid: json['emailid'],
      email: json['email'] ?? '',
      contactNo: json['contactNo'] ?? '',
      name: json['name'] ?? '',
      centerStatus: json['center_status'] is int ? json['center_status'] : int.tryParse(json['center_status']?.toString() ?? ''),
      dob: json['dob'],
      gender: json['gender'] ?? '',
      imageUrl: json['imageUrl'] ?? '',
      userType: json['userType'] ?? '',
      title: json['title'],
      status: json['status'],
      createdAt: json['created_at'],
      updatedAt: json['updated_at'],
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'userid': userid,
        'username': username,
        'emailid': emailid,
        'email': email,
        'contactNo': contactNo,
        'name': name,
        'center_status': centerStatus,
        'dob': dob,
        'gender': gender,
        'imageUrl': imageUrl,
        'userType': userType,
        'title': title,
        'status': status,
        'created_at': createdAt,
        'updated_at': updatedAt,
      };
}