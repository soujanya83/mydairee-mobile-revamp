class SuperAdminModel {
  final String id;
  final String name;
  final String email;
  final String password;
  final String contactNo;
  final String gender;
  final String avatarUrl;
  final String centerName;
  final String streetAddress;
  final String city;
  final String state;
  final String zip;

  SuperAdminModel({
    required this.id,
    required this.name,
    required this.email,
    required this.password,
    required this.contactNo,
    required this.gender,
    required this.avatarUrl,
    required this.centerName,
    required this.streetAddress,
    required this.city,
    required this.state,
    required this.zip,
  });

  factory SuperAdminModel.fromJson(Map<String, dynamic> json) {
    return SuperAdminModel(
      id: json['id'] ?? '',
      name: json['name'] ?? '',
      email: json['email'] ?? '',
      password: json['password'] ?? '',
      contactNo: json['contactNo'] ?? '',
      gender: json['gender'] ?? '',
      avatarUrl: json['avatarUrl'] ?? '',
      centerName: json['centerName'] ?? '',
      streetAddress: json['streetAddress'] ?? '',
      city: json['city'] ?? '',
      state: json['state'] ?? '',
      zip: json['zip'] ?? '',
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
        'centerName': centerName,
        'streetAddress': streetAddress,
        'city': city,
        'state': state,
        'zip': zip,
      };
}
