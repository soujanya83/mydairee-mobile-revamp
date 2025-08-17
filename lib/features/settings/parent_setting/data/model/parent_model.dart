class ParentModel {
  final int id;
  final int? userid;
  final String username;
  final String emailid;
  final String email;
  final String contactNo;
  final String name;
  final int? centerStatus;
  final String? dob;
  final String gender;
  final String? imageUrl;
  final String? avatarUrl; // <-- Add this line
  final String userType;
  final String? title;
  final String? status;
  final String? createdAt;
  final String? updatedAt;
  final List<ParentChild> children;

  ParentModel({
    required this.id,
    this.userid,
    required this.username,
    required this.emailid,
    required this.email,
    required this.contactNo,
    required this.name,
    this.centerStatus,
    this.dob,
    required this.gender,
    this.imageUrl,
    this.avatarUrl, // <-- Add this line
    required this.userType,
    this.title,
    this.status,
    this.createdAt,
    this.updatedAt,
    required this.children,
  });

  factory ParentModel.fromJson(Map<String, dynamic> json) {
    return ParentModel(
      id: json['id'] is int ? json['id'] : int.tryParse(json['id'].toString()) ?? 0,
      userid: json['userid'] is int ? json['userid'] : int.tryParse(json['userid']?.toString() ?? ''),
      username: json['username'] ?? '',
      emailid: json['emailid'] ?? '',
      email: json['email'] ?? '',
      contactNo: json['contactNo'] ?? '',
      name: json['name'] ?? '',
      centerStatus: json['center_status'] is int ? json['center_status'] : int.tryParse(json['center_status']?.toString() ?? ''),
      dob: json['dob'],
      gender: json['gender'] ?? '',
      imageUrl: json['imageUrl'],
      avatarUrl: json['avatarUrl'], // <-- Add this line
      userType: json['userType'] ?? '',
      title: json['title'],
      status: json['status'],
      createdAt: json['created_at'],
      updatedAt: json['updated_at'],
      children: (json['children'] as List<dynamic>? ?? [])
          .map((child) => ParentChild.fromJson(child))
          .toList(),
    );
  }
}

class ParentChild {
  final int id;
  final String name;
  final String lastname;
  final String relation;

  ParentChild({
    required this.id,
    required this.name,
    required this.lastname,
    required this.relation,
  });

  factory ParentChild.fromJson(Map<String, dynamic> json) {
    return ParentChild(
      id: json['id'] is int ? json['id'] : int.tryParse(json['id'].toString()) ?? 0,
      name: json['name'] ?? '',
      lastname: json['lastname'] ?? '',
      relation: json['pivot']?['relation'] ?? '',
    );
  }
}