// To parse this JSON data, do
//
//     final announcemenCreateModel = announcemenCreateModelFromJson(jsonString);

import 'dart:convert';

AnnouncemenCreateModel announcemenCreateModelFromJson(String str) => AnnouncemenCreateModel.fromJson(json.decode(str));

String announcemenCreateModelToJson(AnnouncemenCreateModel data) => json.encode(data.toJson());

class AnnouncemenCreateModel {
    bool? status;
    String? message;
    Data? data;

    AnnouncemenCreateModel({
        this.status,
        this.message,
        this.data,
    });

    factory AnnouncemenCreateModel.fromJson(Map<String, dynamic> json) => AnnouncemenCreateModel(
        status: json["status"],
        message: json["message"],
        data: json["data"] == null ? null : Data.fromJson(json["data"]),
    );

    Map<String, dynamic> toJson() => {
        "status": status,
        "message": message,
        "data": data?.toJson(),
    };
}

class Data {
    dynamic announcement;
    String? centerid;
    List<Children>? childrens;
    List<dynamic>? groups;
    List<Room>? rooms;
    dynamic permissions;

    Data({
        this.announcement,
        this.centerid,
        this.childrens,
        this.groups,
        this.rooms,
        this.permissions,
    });

    factory Data.fromJson(Map<String, dynamic> json) => Data(
        announcement: json["announcement"],
        centerid: json["centerid"],
        childrens: json["Childrens"] == null ? [] : List<Children>.from(json["Childrens"]!.map((x) => Children.fromJson(x))),
        groups: json["Groups"] == null ? [] : List<dynamic>.from(json["Groups"]!.map((x) => x)),
        rooms: json["Rooms"] == null ? [] : List<Room>.from(json["Rooms"]!.map((x) => Room.fromJson(x))),
        permissions: json["permissions"],
    );

    Map<String, dynamic> toJson() => {
        "announcement": announcement,
        "centerid": centerid,
        "Childrens": childrens == null ? [] : List<dynamic>.from(childrens!.map((x) => x.toJson())),
        "Groups": groups == null ? [] : List<dynamic>.from(groups!.map((x) => x)),
        "Rooms": rooms == null ? [] : List<dynamic>.from(rooms!.map((x) => x.toJson())),
        "permissions": permissions,
    };
}

class Children {
    int? childid;
    String? name;
    String? imageUrl;
    String? dob;
    String? age;
    Gender? gender;
    bool? checked;

    Children({
        this.childid,
        this.name,
        this.imageUrl,
        this.dob,
        this.age,
        this.gender,
        this.checked,
    });

    factory Children.fromJson(Map<String, dynamic> json) => Children(
        childid: json["childid"],
        name: json["name"],
        imageUrl: json["imageUrl"],
        dob: json["dob"],
        age: json["age"],
        gender: genderValues.map[json["gender"]]!,
        checked: json["checked"],
    );

    Map<String, dynamic> toJson() => {
        "childid": childid,
        "name": name,
        "imageUrl": imageUrl,
        "dob": dob,
        "age": age,
        "gender": genderValues.reverse[gender],
        "checked": checked,
    };
}

enum Gender {
    FEMALE,
    MALE
}

final genderValues = EnumValues({
    "Female": Gender.FEMALE,
    "Male": Gender.MALE
});

class Room {
    int? roomid;
    String? name;
    List<Children>? childrens;

    Room({
        this.roomid,
        this.name,
        this.childrens,
    });

    factory Room.fromJson(Map<String, dynamic> json) => Room(
        roomid: json["roomid"],
        name: json["name"],
        childrens: json["Childrens"] == null ? [] : List<Children>.from(json["Childrens"]!.map((x) => Children.fromJson(x))),
    );

    Map<String, dynamic> toJson() => {
        "roomid": roomid,
        "name": name,
        "Childrens": childrens == null ? [] : List<dynamic>.from(childrens!.map((x) => x.toJson())),
    };
}

class EnumValues<T> {
    Map<String, T> map;
    late Map<T, String> reverseMap;

    EnumValues(this.map);

    Map<T, String> get reverse {
            reverseMap = map.map((k, v) => MapEntry(v, k));
            return reverseMap;
    }
}
