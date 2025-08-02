// To parse this JSON data, do
//
//     final childrenAddProgramPlanModel = childrenAddProgramPlanModelFromJson(jsonString);

import 'dart:convert';

ChildrenAddProgramPlanModel childrenAddProgramPlanModelFromJson(String str) => ChildrenAddProgramPlanModel.fromJson(json.decode(str));

String childrenAddProgramPlanModelToJson(ChildrenAddProgramPlanModel data) => json.encode(data.toJson());

class ChildrenAddProgramPlanModel {
    bool? status;
    List<Child>? children;

    ChildrenAddProgramPlanModel({
        this.status,
        this.children,
    });

    factory ChildrenAddProgramPlanModel.fromJson(Map<String, dynamic> json) => ChildrenAddProgramPlanModel(
        status: json["status"],
        children: json["children"] == null ? [] : List<Child>.from(json["children"]!.map((x) => Child.fromJson(x))),
    );

    Map<String, dynamic> toJson() => {
        "status": status,
        "children": children == null ? [] : List<dynamic>.from(children!.map((x) => x.toJson())),
    };
}

class Child {
    int? id;
    String? name;

    Child({
        this.id,
        this.name,
    });

    factory Child.fromJson(Map<String, dynamic> json) => Child(
        id: json["id"],
        name: json["name"],
    );

    Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
    };
}
