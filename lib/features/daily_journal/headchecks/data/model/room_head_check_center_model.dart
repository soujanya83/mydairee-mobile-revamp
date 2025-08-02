// To parse this JSON data, do
//
//     final roomHeadChecksCenterModel = roomHeadChecksCenterModelFromJson(jsonString);

import 'dart:convert';

RoomHeadChecksCenterModel roomHeadChecksCenterModelFromJson(String str) => RoomHeadChecksCenterModel.fromJson(json.decode(str));

String roomHeadChecksCenterModelToJson(RoomHeadChecksCenterModel data) => json.encode(data.toJson());

class RoomHeadChecksCenterModel {
    String? status;
    List<Room>? rooms;

    RoomHeadChecksCenterModel({
        this.status,
        this.rooms,
    });

    factory RoomHeadChecksCenterModel.fromJson(Map<String, dynamic> json) => RoomHeadChecksCenterModel(
        status: json["Status"],
        rooms: json["Rooms"] == null ? [] : List<Room>.from(json["Rooms"]!.map((x) => Room.fromJson(x))),
    );

    Map<String, dynamic> toJson() => {
        "Status": status,
        "Rooms": rooms == null ? [] : List<dynamic>.from(rooms!.map((x) => x.toJson())),
    };
}

class Room {
    int? id;
    String? name;
    int? capacity;
    int? userId;
    String? color;
    int? ageFrom;
    int? ageTo;
    String? status;
    int? centerid;
    int? createdBy;

    Room({
        this.id,
        this.name,
        this.capacity,
        this.userId,
        this.color,
        this.ageFrom,
        this.ageTo,
        this.status,
        this.centerid,
        this.createdBy,
    });

    factory Room.fromJson(Map<String, dynamic> json) => Room(
        id: json["id"],
        name: json["name"],
        capacity: json["capacity"],
        userId: json["userId"],
        color: json["color"],
        ageFrom: json["ageFrom"],
        ageTo: json["ageTo"],
        status: json["status"],
        centerid: json["centerid"],
        createdBy: json["created_by"],
    );

    Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "capacity": capacity,
        "userId": userId,
        "color": color,
        "ageFrom": ageFrom,
        "ageTo": ageTo,
        "status": status,
        "centerid": centerid,
        "created_by": createdBy,
    };
}
