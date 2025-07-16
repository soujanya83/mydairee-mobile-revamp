class UserModel {
  final int id;
  final String name;
  final List<String> permissions;

  UserModel({required this.id, required this.name, required this.permissions});

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id'],
      name: json['name'],
      permissions: List<String>.from(json['permissions']),
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'permissions': permissions,
      };
}
