// To parse this JSON data, do
//
//     final reflectionNewModel = reflectionNewModelFromJson(jsonString);

import 'dart:convert';

ReflectionNewModel reflectionNewModelFromJson(String str) => ReflectionNewModel.fromJson(json.decode(str));

String reflectionNewModelToJson(ReflectionNewModel data) => json.encode(data.toJson());

class ReflectionNewModel {
    bool? status;
    String? message;
    Data? data;

    ReflectionNewModel({
        this.status,
        this.message,
        this.data,
    });

    factory ReflectionNewModel.fromJson(Map<String, dynamic> json) => ReflectionNewModel(
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
    Reflection? reflection;
    List<ChildrenElement>? childrens;
    List<Room>? rooms;
    List<CreatorElement>? staffs;
    List<Outcome>? outcomes;

    Data({
        this.reflection,
        this.childrens,
        this.rooms,
        this.staffs,
        this.outcomes,
    });

    factory Data.fromJson(Map<String, dynamic> json) => Data(
        reflection: json["reflection"] == null ? null : Reflection.fromJson(json["reflection"]),
        childrens: json["childrens"] == null ? [] : List<ChildrenElement>.from(json["childrens"]!.map((x) => ChildrenElement.fromJson(x))),
        rooms: json["rooms"] == null ? [] : List<Room>.from(json["rooms"]!.map((x) => Room.fromJson(x))),
        staffs: json["staffs"] == null ? [] : List<CreatorElement>.from(json["staffs"]!.map((x) => CreatorElement.fromJson(x))),
        outcomes: json["outcomes"] == null ? [] : List<Outcome>.from(json["outcomes"]!.map((x) => Outcome.fromJson(x))),
    );

    Map<String, dynamic> toJson() => {
        "reflection": reflection?.toJson(),
        "childrens": childrens == null ? [] : List<dynamic>.from(childrens!.map((x) => x.toJson())),
        "rooms": rooms == null ? [] : List<dynamic>.from(rooms!.map((x) => x.toJson())),
        "staffs": staffs == null ? [] : List<dynamic>.from(staffs!.map((x) => x.toJson())),
        "outcomes": outcomes == null ? [] : List<dynamic>.from(outcomes!.map((x) => x.toJson())),
    };
}

class ChildrenElement {
    int? id;
    String? name;
    String? lastname;
    String? dob;
    String? startDate;
    int? room;
    String? imageUrl;
    String? gender;
    String? status;
    String? daysAttending;
    int? createdBy;
    DateTime? createdAt;
    int? centerid;
    DateTime? childCreatedAt;
    dynamic updatedAt;

    ChildrenElement({
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
        this.childCreatedAt,
        this.updatedAt,
    });

    factory ChildrenElement.fromJson(Map<String, dynamic> json) => ChildrenElement(
        id: json["id"],
        name: json["name"],
        lastname: json["lastname"],
        dob: json["dob"],
        startDate: json["startDate"],
        room: json["room"],
        imageUrl: json["imageUrl"],
        gender: json["gender"],
        status: json["status"],
        daysAttending: json["daysAttending"],
        createdBy: json["createdBy"],
        createdAt: json["createdAt"] == null ? null : DateTime.parse(json["createdAt"]),
        centerid: json["centerid"],
        childCreatedAt: json["created_at"] == null ? null : DateTime.parse(json["created_at"]),
        updatedAt: json["updated_at"],
    );

    Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "lastname": lastname,
        "dob": dob,
        "startDate": startDate,
        "room": room,
        "imageUrl": imageUrl,
        "gender": gender,
        "status": status,
        "daysAttending": daysAttending,
        "createdBy": createdBy,
        "createdAt": createdAt?.toIso8601String(),
        "centerid": centerid,
        "created_at": childCreatedAt?.toIso8601String(),
        "updated_at": updatedAt,
    };
}

class Outcome {
    int? id;
    String? title;
    String? name;
    dynamic addedBy;
    DateTime? addedAt;
    List<Activity>? activities;

    Outcome({
        this.id,
        this.title,
        this.name,
        this.addedBy,
        this.addedAt,
        this.activities,
    });

    factory Outcome.fromJson(Map<String, dynamic> json) => Outcome(
        id: json["id"],
        title: json["title"],
        name: json["name"],
        addedBy: json["added_by"],
        addedAt: json["added_at"] == null ? null : DateTime.parse(json["added_at"]),
        activities: json["activities"] == null ? [] : List<Activity>.from(json["activities"]!.map((x) => Activity.fromJson(x))),
    );

    Map<String, dynamic> toJson() => {
        "id": id,
        "title": title,
        "name": name,
        "added_by": addedBy,
        "added_at": addedAt?.toIso8601String(),
        "activities": activities == null ? [] : List<dynamic>.from(activities!.map((x) => x.toJson())),
    };
}

class Activity {
    int? id;
    int? outcomeId;
    String? title;
    dynamic addedBy;
    AddedAtEnum? addedAt;
    List<SubActivity>? subActivities;

    Activity({
        this.id,
        this.outcomeId,
        this.title,
        this.addedBy,
        this.addedAt,
        this.subActivities,
    });

    factory Activity.fromJson(Map<String, dynamic> json) => Activity(
        id: json["id"],
        outcomeId: json["outcomeId"],
        title: json["title"],
        addedBy: json["added_by"],
        addedAt: addedAtEnumValues.map[json["added_at"]]!,
        subActivities: json["sub_activities"] == null ? [] : List<SubActivity>.from(json["sub_activities"]!.map((x) => SubActivity.fromJson(x))),
    );

    Map<String, dynamic> toJson() => {
        "id": id,
        "outcomeId": outcomeId,
        "title": title,
        "added_by": addedBy,
        "added_at": addedAtEnumValues.reverse[addedAt],
        "sub_activities": subActivities == null ? [] : List<dynamic>.from(subActivities!.map((x) => x.toJson())),
    };
}

enum AddedAtEnum {
    THE_00000000000000
}

final addedAtEnumValues = EnumValues({
    "0000-00-00 00:00:00": AddedAtEnum.THE_00000000000000
});

class SubActivity {
    int? id;
    int? activityid;
    String? title;
    String? imageUrl;
    dynamic addedBy;
    dynamic addedAt;

    SubActivity({
        this.id,
        this.activityid,
        this.title,
        this.imageUrl,
        this.addedBy,
        this.addedAt,
    });

    factory SubActivity.fromJson(Map<String, dynamic> json) => SubActivity(
        id: json["id"],
        activityid: json["activityid"],
        title: json["title"],
        imageUrl: json["imageUrl"],
        addedBy: json["added_by"],
        addedAt: json["added_at"],
    );

    Map<String, dynamic> toJson() => {
        "id": id,
        "activityid": activityid,
        "title": title,
        "imageUrl": imageUrl,
        "added_by": addedBy,
        "added_at": addedAt,
    };
}

class Reflection {
    int? id;
    String? title;
    String? about;
    int? centerid;
    String? status;
    String? eylf;
    String? roomids;
    int? createdBy;
    DateTime? createdAt;
    DateTime? reflectionCreatedAt;
    DateTime? updatedAt;
    CreatorElement? creator;
    Center? center;
    List<ReflectionChild>? children;
    List<Media>? media;
    List<PurpleStaff>? staff;

    Reflection({
        this.id,
        this.title,
        this.about,
        this.centerid,
        this.status,
        this.eylf,
        this.roomids,
        this.createdBy,
        this.createdAt,
        this.reflectionCreatedAt,
        this.updatedAt,
        this.creator,
        this.center,
        this.children,
        this.media,
        this.staff,
    });

    factory Reflection.fromJson(Map<String, dynamic> json) => Reflection(
        id: json["id"],
        title: json["title"],
        about: json["about"],
        centerid: json["centerid"],
        status: json["status"],
        eylf: json["eylf"],
        roomids: json["roomids"],
        createdBy: json["createdBy"],
        createdAt: json["createdAt"] == null ? null : DateTime.parse(json["createdAt"]),
        reflectionCreatedAt: json["created_at"] == null ? null : DateTime.parse(json["created_at"]),
        updatedAt: json["updated_at"] == null ? null : DateTime.parse(json["updated_at"]),
        creator: json["creator"] == null ? null : CreatorElement.fromJson(json["creator"]),
        center: json["center"] == null ? null : Center.fromJson(json["center"]),
        children: json["children"] == null ? [] : List<ReflectionChild>.from(json["children"]!.map((x) => ReflectionChild.fromJson(x))),
        media: json["media"] == null ? [] : List<Media>.from(json["media"]!.map((x) => Media.fromJson(x))),
        staff: json["staff"] == null ? [] : List<PurpleStaff>.from(json["staff"]!.map((x) => PurpleStaff.fromJson(x))),
    );

    Map<String, dynamic> toJson() => {
        "id": id,
        "title": title,
        "about": about,
        "centerid": centerid,
        "status": status,
        "eylf": eylf,
        "roomids": roomids,
        "createdBy": createdBy,
        "createdAt": createdAt?.toIso8601String(),
        "created_at": reflectionCreatedAt?.toIso8601String(),
        "updated_at": updatedAt?.toIso8601String(),
        "creator": creator?.toJson(),
        "center": center?.toJson(),
        "children": children == null ? [] : List<dynamic>.from(children!.map((x) => x.toJson())),
        "media": media == null ? [] : List<dynamic>.from(media!.map((x) => x.toJson())),
        "staff": staff == null ? [] : List<dynamic>.from(staff!.map((x) => x.toJson())),
    };
}

class Center {
    int? id;
    dynamic userId;
    String? centerName;
    String? adressStreet;
    String? addressCity;
    String? addressState;
    String? addressZip;
    DateTime? createdAt;
    DateTime? updatedAt;

    Center({
        this.id,
        this.userId,
        this.centerName,
        this.adressStreet,
        this.addressCity,
        this.addressState,
        this.addressZip,
        this.createdAt,
        this.updatedAt,
    });

    factory Center.fromJson(Map<String, dynamic> json) => Center(
        id: json["id"],
        userId: json["user_id"],
        centerName: json["centerName"],
        adressStreet: json["adressStreet"],
        addressCity: json["addressCity"],
        addressState: json["addressState"],
        addressZip: json["addressZip"],
        createdAt: json["created_at"] == null ? null : DateTime.parse(json["created_at"]),
        updatedAt: json["updated_at"] == null ? null : DateTime.parse(json["updated_at"]),
    );

    Map<String, dynamic> toJson() => {
        "id": id,
        "user_id": userId,
        "centerName": centerName,
        "adressStreet": adressStreet,
        "addressCity": addressCity,
        "addressState": addressState,
        "addressZip": addressZip,
        "created_at": createdAt?.toIso8601String(),
        "updated_at": updatedAt?.toIso8601String(),
    };
}

class ReflectionChild {
    int? id;
    int? reflectionid;
    int? childid;
    ChildrenElement? child;

    ReflectionChild({
        this.id,
        this.reflectionid,
        this.childid,
        this.child,
    });

    factory ReflectionChild.fromJson(Map<String, dynamic> json) => ReflectionChild(
        id: json["id"],
        reflectionid: json["reflectionid"],
        childid: json["childid"],
        child: json["child"] == null ? null : ChildrenElement.fromJson(json["child"]),
    );

    Map<String, dynamic> toJson() => {
        "id": id,
        "reflectionid": reflectionid,
        "childid": childid,
        "child": child?.toJson(),
    };
}

class CreatorElement {
    int? id;
    int? userid;
    String? username;
    String? emailid;
    String? email;
    int? centerStatus;
    String? contactNo;
    String? name;
    DateTime? dob;
    String? gender;
    String? imageUrl;
    String? userType;
    String? title;
    String? status;
    String? authToken;
    String? deviceid;
    String? devicetype;
    dynamic companyLogo;
    int? theme;
    String? imagePosition;
    dynamic createdBy;
    dynamic emailVerifiedAt;
    DateTime? createdAt;
    DateTime? updatedAt;

    CreatorElement({
        this.id,
        this.userid,
        this.username,
        this.emailid,
        this.email,
        this.centerStatus,
        this.contactNo,
        this.name,
        this.dob,
        this.gender,
        this.imageUrl,
        this.userType,
        this.title,
        this.status,
        this.authToken,
        this.deviceid,
        this.devicetype,
        this.companyLogo,
        this.theme,
        this.imagePosition,
        this.createdBy,
        this.emailVerifiedAt,
        this.createdAt,
        this.updatedAt,
    });

    factory CreatorElement.fromJson(Map<String, dynamic> json) => CreatorElement(
        id: json["id"],
        userid: json["userid"],
        username: json["username"],
        emailid: json["emailid"],
        email: json["email"],
        centerStatus: json["center_status"],
        contactNo: json["contactNo"],
        name: json["name"],
        dob: json["dob"] == null ? null : DateTime.parse(json["dob"]),
        gender: json["gender"],
        imageUrl: json["imageUrl"],
        userType: json["userType"],
        title: json["title"],
        status: json["status"],
        authToken: json["AuthToken"],
        deviceid: json["deviceid"],
        devicetype: json["devicetype"],
        companyLogo: json["companyLogo"],
        theme: json["theme"],
        imagePosition: json["image_position"],
        createdBy: json["created_by"],
        emailVerifiedAt: json["email_verified_at"],
        createdAt: json["created_at"] == null ? null : DateTime.parse(json["created_at"]),
        updatedAt: json["updated_at"] == null ? null : DateTime.parse(json["updated_at"]),
    );

    Map<String, dynamic> toJson() => {
        "id": id,
        "userid": userid,
        "username": username,
        "emailid": emailid,
        "email": email,
        "center_status": centerStatus,
        "contactNo": contactNo,
        "name": name,
        "dob": dob?.toIso8601String(),
        "gender": gender,
        "imageUrl": imageUrl,
        "userType": userType,
        "title": title,
        "status": status,
        "AuthToken": authToken,
        "deviceid": deviceid,
        "devicetype": devicetype,
        "companyLogo": companyLogo,
        "theme": theme,
        "image_position": imagePosition,
        "created_by": createdBy,
        "email_verified_at": emailVerifiedAt,
        "created_at": createdAt?.toIso8601String(),
        "updated_at": updatedAt?.toIso8601String(),
    };
}

class Media {
    int? id;
    int? reflectionid;
    String? mediaUrl;
    String? mediaType;

    Media({
        this.id,
        this.reflectionid,
        this.mediaUrl,
        this.mediaType,
    });

    factory Media.fromJson(Map<String, dynamic> json) => Media(
        id: json["id"],
        reflectionid: json["reflectionid"],
        mediaUrl: json["mediaUrl"],
        mediaType: json["mediaType"],
    );

    Map<String, dynamic> toJson() => {
        "id": id,
        "reflectionid": reflectionid,
        "mediaUrl": mediaUrl,
        "mediaType": mediaType,
    };
}

class PurpleStaff {
    int? id;
    int? reflectionid;
    int? staffid;
    CreatorElement? staff;

    PurpleStaff({
        this.id,
        this.reflectionid,
        this.staffid,
        this.staff,
    });

    factory PurpleStaff.fromJson(Map<String, dynamic> json) => PurpleStaff(
        id: json["id"],
        reflectionid: json["reflectionid"],
        staffid: json["staffid"],
        staff: json["staff"] == null ? null : CreatorElement.fromJson(json["staff"]),
    );

    Map<String, dynamic> toJson() => {
        "id": id,
        "reflectionid": reflectionid,
        "staffid": staffid,
        "staff": staff?.toJson(),
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
    dynamic createdBy;

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

class EnumValues<T> {
    Map<String, T> map;
    late Map<T, String> reverseMap;

    EnumValues(this.map);

    Map<T, String> get reverse {
            reverseMap = map.map((k, v) => MapEntry(v, k));
            return reverseMap;
    }
}
