// To parse this JSON data, do
//
//     final userAddProgramPlanModel = userAddProgramPlanModelFromJson(jsonString);

import 'dart:convert';

UserAddProgramPlanModel userAddProgramPlanModelFromJson(String str) => UserAddProgramPlanModel.fromJson(json.decode(str));

String userAddProgramPlanModelToJson(UserAddProgramPlanModel data) => json.encode(data.toJson());

class UserAddProgramPlanModel {
    bool? status;
    List<User>? users;

    UserAddProgramPlanModel({
        this.status,
        this.users,
    });

    factory UserAddProgramPlanModel.fromJson(Map<String, dynamic> json) => UserAddProgramPlanModel(
        status: json["status"],
        users: json["users"] == null ? [] : List<User>.from(json["users"]!.map((x) => User.fromJson(x))),
    );

    Map<String, dynamic> toJson() => {
        "status": status,
        "users": users == null ? [] : List<dynamic>.from(users!.map((x) => x.toJson())),
    };
}

class User {
    int? id;
    String? name;

    User({
        this.id,
        this.name,
    });

    factory User.fromJson(Map<String, dynamic> json) => User(
        id: json["id"],
        name: json["name"],
    );

    Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
    };
}
