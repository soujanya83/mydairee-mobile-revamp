import 'package:mydiaree/features/settings/manage_permissions/data/model/permission_model.dart';

class UserModel {
  final int id;
  final String name;
  final List<PermissionModel> permissions;

  UserModel({required this.id, required this.name, required this.permissions});

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id'],
      name: json['name'],
      permissions: (json['permissions'] as List<dynamic>)
          .map((e) => PermissionModel.fromJson(e as Map<String, dynamic>))
          .toList(),
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'permissions': permissions.map((e) => e.toJson()).toList(),
      };
}