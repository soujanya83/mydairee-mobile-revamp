// To parse this JSON data, do
//
//     final childrensRoomModel = childrensRoomModelFromJson(jsonString);

import 'dart:convert';

ChildrensRoomModel childrensRoomModelFromJson(String str) => ChildrensRoomModel.fromJson(json.decode(str));

String childrensRoomModelToJson(ChildrensRoomModel data) => json.encode(data.toJson());

class ChildrensRoomModel {
    bool? status;
    String? message;
    String? roomId;
    RoomCapacity? roomCapacity;
    Attendance? attendance;
    int? totalAttendance;
    List<Pattern>? patterns;
    Breakdowns? breakdowns;
    int? activeChildren;
    int? enrolledChildren;
    int? maleChildren;
    int? femaleChildren;
    List<AllChild>? allChildren;
    List<RoomCapacity>? otherRooms;

    ChildrensRoomModel({
        this.status,
        this.message,
        this.roomId,
        this.roomCapacity,
        this.attendance,
        this.totalAttendance,
        this.patterns,
        this.breakdowns,
        this.activeChildren,
        this.enrolledChildren,
        this.maleChildren,
        this.femaleChildren,
        this.allChildren,
        this.otherRooms,
    });

    factory ChildrensRoomModel.fromJson(Map<String, dynamic> json) => ChildrensRoomModel(
        status: json["status"],
        message: json["message"],
        roomId: json["room_id"],
        roomCapacity: json["room_capacity"] == null ? null : RoomCapacity.fromJson(json["room_capacity"]),
        attendance: json["attendance"] == null ? null : Attendance.fromJson(json["attendance"]),
        totalAttendance: json["total_attendance"],
        patterns: json["patterns"] == null ? [] : List<Pattern>.from(json["patterns"]!.map((x) => Pattern.fromJson(x))),
        breakdowns: json["breakdowns"] == null ? null : Breakdowns.fromJson(json["breakdowns"]),
        activeChildren: json["active_children"],
        enrolledChildren: json["enrolled_children"],
        maleChildren: json["male_children"],
        femaleChildren: json["female_children"],
        allChildren: json["all_children"] == null ? [] : List<AllChild>.from(json["all_children"]!.map((x) => AllChild.fromJson(x))),
        otherRooms: json["other_rooms"] == null ? [] : List<RoomCapacity>.from(json["other_rooms"]!.map((x) => RoomCapacity.fromJson(x))),
    );

    Map<String, dynamic> toJson() => {
        "status": status,
        "message": message,
        "room_id": roomId,
        "room_capacity": roomCapacity?.toJson(),
        "attendance": attendance?.toJson(),
        "total_attendance": totalAttendance,
        "patterns": patterns == null ? [] : List<dynamic>.from(patterns!.map((x) => x.toJson())),
        "breakdowns": breakdowns?.toJson(),
        "active_children": activeChildren,
        "enrolled_children": enrolledChildren,
        "male_children": maleChildren,
        "female_children": femaleChildren,
        "all_children": allChildren == null ? [] : List<dynamic>.from(allChildren!.map((x) => x.toJson())),
        "other_rooms": otherRooms == null ? [] : List<dynamic>.from(otherRooms!.map((x) => x.toJson())),
    };
}

class AllChild {
    int? id;
    String? name;
    String? lastname;
    DateTime? dob;
    DateTime? startDate;
    int? room;
    String? imageUrl;
    String? gender;
    Status? status;
    String? daysAttending;
    int? createdBy;
    DateTime? createdAt;
    int? centerid;
    DateTime? allChildCreatedAt;
    dynamic updatedAt;

    AllChild({
        this.id,
        this.name,
        this.lastname,
        this.dob,
        this.startDate,
        this.room,
        this.imageUrl,
        this.gender,
        this.status,
        this.daysAttending,
        this.createdBy,
        this.createdAt,
        this.centerid,
        this.allChildCreatedAt,
        this.updatedAt,
    });

    factory AllChild.fromJson(Map<String, dynamic> json) => AllChild(
        id: json["id"],
        name: json["name"],
        lastname: json["lastname"],
        dob: json["dob"] == null ? null : DateTime.parse(json["dob"]),
        startDate: json["startDate"] == null ? null : DateTime.parse(json["startDate"]),
        room: json["room"],
        imageUrl: json["imageUrl"],
        gender: json["gender"],
        status: statusValues.map[json["status"]]!,
        daysAttending: json["daysAttending"],
        createdBy: json["createdBy"],
        createdAt: json["createdAt"] == null ? null : DateTime.parse(json["createdAt"]),
        centerid: json["centerid"],
        allChildCreatedAt: json["created_at"] == null ? null : DateTime.parse(json["created_at"]),
        updatedAt: json["updated_at"],
    );

    Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "lastname": lastname,
        "dob": "${dob!.year.toString().padLeft(4, '0')}-${dob!.month.toString().padLeft(2, '0')}-${dob!.day.toString().padLeft(2, '0')}",
        "startDate": "${startDate!.year.toString().padLeft(4, '0')}-${startDate!.month.toString().padLeft(2, '0')}-${startDate!.day.toString().padLeft(2, '0')}",
        "room": room,
        "imageUrl": imageUrl,
        "gender": gender,
        "status": statusValues.reverse[status],
        "daysAttending": daysAttending,
        "createdBy": createdBy,
        "createdAt": createdAt?.toIso8601String(),
        "centerid": centerid,
        "created_at": allChildCreatedAt?.toIso8601String(),
        "updated_at": updatedAt,
    };
}

enum Status {
    ACTIVE
}

final statusValues = EnumValues({
    "Active": Status.ACTIVE
});

class Attendance {
    int? mon;
    int? tue;
    int? wed;
    int? thu;
    int? fri;

    Attendance({
        this.mon,
        this.tue,
        this.wed,
        this.thu,
        this.fri,
    });

    factory Attendance.fromJson(Map<String, dynamic> json) => Attendance(
        mon: json["Mon"],
        tue: json["Tue"],
        wed: json["Wed"],
        thu: json["Thu"],
        fri: json["Fri"],
    );

    Map<String, dynamic> toJson() => {
        "Mon": mon,
        "Tue": tue,
        "Wed": wed,
        "Thu": thu,
        "Fri": fri,
    };
}

class Breakdowns {
    String? mon;
    String? tue;
    String? wed;
    String? thu;
    String? fri;

    Breakdowns({
        this.mon,
        this.tue,
        this.wed,
        this.thu,
        this.fri,
    });

    factory Breakdowns.fromJson(Map<String, dynamic> json) => Breakdowns(
        mon: json["Mon"],
        tue: json["Tue"],
        wed: json["Wed"],
        thu: json["Thu"],
        fri: json["Fri"],
    );

    Map<String, dynamic> toJson() => {
        "Mon": mon,
        "Tue": tue,
        "Wed": wed,
        "Thu": thu,
        "Fri": fri,
    };
}

class RoomCapacity {
    int? id;
    String? name;
    int? capacity;
    int? userId;
    String? color;
    int? ageFrom;
    int? ageTo;
    Status? status;
    int? centerid;
    int? createdBy;

    RoomCapacity({
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

    factory RoomCapacity.fromJson(Map<String, dynamic> json) => RoomCapacity(
        id: json["id"],
        name: json["name"],
        capacity: json["capacity"],
        userId: json["userId"],
        color: json["color"],
        ageFrom: json["ageFrom"],
        ageTo: json["ageTo"],
        status: statusValues.map[json["status"]]!,
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
        "status": statusValues.reverse[status],
        "centerid": centerid,
        "created_by": createdBy,
    };
}

class Pattern {
    String? pattern;
    Attendance? days;

    Pattern({
        this.pattern,
        this.days,
    });

    factory Pattern.fromJson(Map<String, dynamic> json) => Pattern(
        pattern: json["pattern"],
        days: json["days"] == null ? null : Attendance.fromJson(json["days"]),
    );

    Map<String, dynamic> toJson() => {
        "pattern": pattern,
        "days": days?.toJson(),
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
