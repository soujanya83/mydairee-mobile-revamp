// To parse this JSON data, do
//
//     final permissionListModel = permissionListModelFromJson(jsonString);

import 'dart:convert';

PermissionListModel permissionListModelFromJson(String str) => PermissionListModel.fromJson(json.decode(str));

String permissionListModelToJson(PermissionListModel data) => json.encode(data.toJson());

class PermissionListModel {
    bool? success;
    List<PermissionModel>? data;

    PermissionListModel({
        this.success,
        this.data,
    });

    factory PermissionListModel.fromJson(Map<String, dynamic> json) => PermissionListModel(
        success: json["success"],
        data: json["data"] == null ? [] : List<PermissionModel>.from(json["data"]!.map((x) => PermissionModel.fromJson(x))),
    );

    Map<String, dynamic> toJson() => {
        "success": success,
        "data": data == null ? [] : List<dynamic>.from(data!.map((x) => x.toJson())),
    };
}

class PermissionModel {
  final String name;
  final String label;

  PermissionModel({
    required this.name,
    required this.label,
  });

  factory PermissionModel.fromJson(Map<String, dynamic> json) {
    return PermissionModel(
      name: json['name'] ?? '',
      label: json['label'] ?? '',
    );
  }

  Map<String, dynamic> toJson() => {
        'name': name,
        'label': label,
      };
}