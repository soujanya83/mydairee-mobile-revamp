class SignupModel {
  final String? id;
  final String? name;
  final String? username;
  final String? email;
  final String? contact;
  final String? gender;
  final String? dob;
  final String? profileImageUrl;
  final String? password;
  final String? token;
  final String? successMessage;

  SignupModel({
    this.id,
    this.name,
    this.username,
    this.email,
    this.contact,
    this.gender,
    this.dob,
    this.profileImageUrl,
    this.password,
    this.token,
    this.successMessage,
  });

  factory SignupModel.fromJson(Map<String, dynamic> json) {
    return SignupModel(
      id: json['id'] as String?,
      name: json['name'] as String?,
      username: json['username'] as String?,
      email: json['email'] as String?,
      contact: json['contact'] as String?,
      gender: json['gender'] as String?,
      dob: json['dob'] as String?,
      profileImageUrl: json['profileImageUrl'] as String?,
      password: json['password'] as String?,
      token: json['token'] as String?,
      successMessage: json['successMessage'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'username': username,
      'email': email,
      'contact': contact,
      'gender': gender,
      'dob': dob,
      'profileImageUrl': profileImageUrl,
      'password': password,
      'token': token,
      'successMessage': successMessage,
    };
  }
}