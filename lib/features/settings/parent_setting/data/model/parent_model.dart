class ParentModel {
  final String id;
  final String name;
  final String email;
  final String password;
  final String contactNo;
  final String gender;
  final String avatarUrl;
  final List<Map<String, String>> children;

  ParentModel({
    required this.id,
    required this.name,
    required this.email,
    required this.password,
    required this.contactNo,
    required this.gender,
    required this.avatarUrl,
    required this.children,
  });

  factory ParentModel.fromJson(Map<String, dynamic> json) {
    return ParentModel(
      id: json['id']?.toString() ?? '',
      name: json['name'] ?? '',
      email: json['email'] ?? '',
      password: json['password'] ?? '',
      contactNo: json['contactNo'] ?? '',
      gender: json['gender'] ?? '',
      avatarUrl: json['avatarUrl'] ?? '',
      children: (json['children'] as List<dynamic>?)?.map((child) => {
            'name': child['name']?.toString() ?? '',
            'role': child['role']?.toString() ?? '',
          }).toList() ?? [],
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
        'children': children,
      };
}