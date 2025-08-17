import 'package:mydiaree/features/settings/manage_permissions/data/model/permission_model.dart';

class UserModel {
  final int id;
  final String name;
  final String colorClass;

  UserModel({
    required this.id,
    required this.name,
    required this.colorClass,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id'] is int ? json['id'] : int.tryParse(json['id'].toString()) ?? 0,
      name: json['name'] ?? '',
      colorClass: json['colorClass'] ?? '',
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'colorClass': colorClass,
      };
}