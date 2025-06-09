class LoginModel {
  final String? token;
  final String? userId;
  final String? email;
  final String? name;

  LoginModel({
    this.token,
    this.userId,
    this.email,
    this.name,
  });

  factory LoginModel.fromJson(Map<String, dynamic>? json) {
    if (json == null) return LoginModel();
    return LoginModel(
      token: json['token'] as String?,
      userId: json['user_id'] as String?,
      email: json['email'] as String?,
      name: json['name'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'token': token,
      'user_id': userId,
      'email': email,
      'name': name,
    };
  }
}