// To parse this JSON data, do
//
//     final dailyDiareeModel = dailyDiareeModelFromJson(jsonString);

import 'dart:convert';

DailyDiareeModel dailyDiareeModelFromJson(String str) => DailyDiareeModel.fromJson(json.decode(str));

String dailyDiareeModelToJson(DailyDiareeModel data) => json.encode(data.toJson());

class DailyDiareeModel {
    bool? status;
    String? message;
    Data? data;

    DailyDiareeModel({
        this.status,
        this.message,
        this.data,
    });

    factory DailyDiareeModel.fromJson(Map<String, dynamic> json) => DailyDiareeModel(
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
    List<Center>? centers;
    List<Room>? rooms;
    Room? selectedRoom;
    DateTime? selectedDate;
    List<ChildElement>? children;

    Data({
        this.centers,
        this.rooms,
        this.selectedRoom,
        this.selectedDate,
        this.children,
    });

    factory Data.fromJson(Map<String, dynamic> json) => Data(
        centers: json["centers"] == null ? [] : List<Center>.from(json["centers"]!.map((x) => Center.fromJson(x))),
        rooms: json["rooms"] == null ? [] : List<Room>.from(json["rooms"]!.map((x) => Room.fromJson(x))),
        selectedRoom: json["selectedRoom"] == null ? null : Room.fromJson(json["selectedRoom"]),
        selectedDate: json["selectedDate"] == null ? null : DateTime.parse(json["selectedDate"]),
        children: json["children"] == null ? [] : List<ChildElement>.from(json["children"]!.map((x) => ChildElement.fromJson(x))),
    );

    Map<String, dynamic> toJson() => {
        "centers": centers == null ? [] : List<dynamic>.from(centers!.map((x) => x.toJson())),
        "rooms": rooms == null ? [] : List<dynamic>.from(rooms!.map((x) => x.toJson())),
        "selectedRoom": selectedRoom?.toJson(),
        "selectedDate": "${selectedDate!.year.toString().padLeft(4, '0')}-${selectedDate!.month.toString().padLeft(2, '0')}-${selectedDate!.day.toString().padLeft(2, '0')}",
        "children": children == null ? [] : List<dynamic>.from(children!.map((x) => x.toJson())),
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

class ChildElement {
    ChildChild? child;
    List<AfternoonTea>?    bottle;
    List<Toileting>?      toileting;
    List<AfternoonTea>?   sunscreen;
    AfternoonTea?    snacks;
    List<AfternoonTea>?     sleep;
    AfternoonTea?    lunch;
    AfternoonTea?    morningTea;
    AfternoonTea?    breakfast;
    AfternoonTea?    afternoonTea;

    ChildElement({
        this.child,
        this.bottle,
        this.toileting,
        this.sunscreen,
        this.snacks,
        this.afternoonTea,
        this.sleep,
        this.lunch,
        this.morningTea,
        this.breakfast,
    });

    factory ChildElement.fromJson(Map<String, dynamic> json) => ChildElement(
        child: json["child"] == null ? null : ChildChild.fromJson(json["child"]),
        bottle:     json["bottle"]     == null ? []   : List<AfternoonTea>.from(json["bottle"]!.map((x) => AfternoonTea.fromJson(x))),
        toileting:  json["toileting"]  == null ? []   : List<Toileting>.from(json["toileting"]!.map((x) => Toileting.fromJson(x))),
        sunscreen:  json["sunscreen"]  == null ? []   : List<AfternoonTea>.from(json["sunscreen"]!.map((x) => AfternoonTea.fromJson(x))),
        snacks:     json["snacks"]     == null ? null : AfternoonTea.fromJson(json["snacks"]),
        afternoonTea: json["afternoon_tea"] == null ? null : AfternoonTea.fromJson(json["afternoon_tea"]),
        sleep:      json["sleep"]      == null ? []   : List<AfternoonTea>.from(json["sleep"]!.map((x) => AfternoonTea.fromJson(x))),
        lunch:      json["lunch"]      == null ? null : AfternoonTea.fromJson(json["lunch"]),
        morningTea: json["morning_tea"]== null ? null : AfternoonTea.fromJson(json["morning_tea"]),
        breakfast:  json["breakfast"]  == null ? null : AfternoonTea.fromJson(json["breakfast"]),
    );

    Map<String, dynamic> toJson() => {
        "child": child?.toJson(),
        "bottle": bottle?.map((e) => e.toJson()).toList(),
        "toileting": toileting?.map((e) => e.toJson()).toList(),
        "sunscreen": sunscreen?.map((e) => e.toJson()).toList(),
        "snacks": snacks?.toJson(),
        "afternoon_tea": afternoonTea?.toJson(),
        "sleep": sleep?.map((e) => e.toJson()).toList(),
        "lunch": lunch?.toJson(),
        "morning_tea": morningTea?.toJson(),
        "breakfast": breakfast?.toJson(),
    };
}

class AfternoonTea {
    int? id;
    int? childid;
    DateTime? diarydate;
    String? startTime;
    String? item;
    String? comments;
    String? createdBy;
    DateTime? createdAt;
    DateTime? afternoonTeaCreatedAt;
    DateTime? updatedAt;
    String? endTime;
    String? signature;

    AfternoonTea({
        this.id,
        this.childid,
        this.diarydate,
        this.startTime,
        this.item,
        this.comments,
        this.createdBy,
        this.createdAt,
        this.afternoonTeaCreatedAt,
        this.updatedAt,
        this.endTime,
        this.signature,
    });

    factory AfternoonTea.fromJson(Map<String, dynamic> json) => AfternoonTea(
        id: json["id"],
        childid: json["childid"],
        diarydate: json["diarydate"] == null ? null : DateTime.parse(json["diarydate"]),
        startTime: json["startTime"],
        item: json["item"],
        comments: json["comments"],
        createdBy: json["createdBy"],
        createdAt: json["createdAt"] == null ? null : DateTime.parse(json["createdAt"]),
        afternoonTeaCreatedAt: json["created_at"] == null ? null : DateTime.parse(json["created_at"]),
        updatedAt: json["updated_at"] == null ? null : DateTime.parse(json["updated_at"]),
        endTime: json["endTime"],
        signature: json["signature"],
    );

    Map<String, dynamic> toJson() => {
        "id": id,
        "childid": childid,
        "diarydate": "${diarydate!.year.toString().padLeft(4, '0')}-${diarydate!.month.toString().padLeft(2, '0')}-${diarydate!.day.toString().padLeft(2, '0')}",
        "startTime": startTime,
        "item": item,
        "comments": comments,
        "createdBy": createdBy,
        "createdAt": createdAt?.toIso8601String(),
        "created_at": afternoonTeaCreatedAt?.toIso8601String(),
        "updated_at": updatedAt?.toIso8601String(),
        "endTime": endTime,
        "signature": signature,
    };
}

class ChildChild {
    int? id;
    String? name;
    String? lastname;
    DateTime? dob;
    DateTime? startDate;
    int? room;
    String? imageUrl;
    String? gender;
    String? status;
    String? daysAttending;
    int? centerid;
    int? createdBy;
    DateTime? createdAt;
    DateTime? childCreatedAt;
    DateTime? updatedAt;

    ChildChild({
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
        this.centerid,
        this.createdBy,
        this.createdAt,
        this.childCreatedAt,
        this.updatedAt,
    });

    factory ChildChild.fromJson(Map<String, dynamic> json) => ChildChild(
        id: json["id"],
        name: json["name"],
        lastname: json["lastname"],
        dob: json["dob"] == null ? null : DateTime.parse(json["dob"]),
        startDate: json["startDate"] == null ? null : DateTime.parse(json["startDate"]),
        room: json["room"],
        imageUrl: json["imageUrl"],
        gender: json["gender"],
        status: json["status"],
        daysAttending: json["daysAttending"],
        centerid: json["centerid"],
        createdBy: json["createdBy"],
        createdAt: json["createdAt"] == null ? null : DateTime.parse(json["createdAt"]),
        childCreatedAt: json["created_at"] == null ? null : DateTime.parse(json["created_at"]),
        updatedAt: json["updated_at"] == null ? null : DateTime.parse(json["updated_at"]),
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
        "status": status,
        "daysAttending": daysAttending,
        "centerid": centerid,
        "createdBy": createdBy,
        "createdAt": createdAt?.toIso8601String(),
        "created_at": childCreatedAt?.toIso8601String(),
        "updated_at": updatedAt?.toIso8601String(),
    };
}

class Toileting {
    int? id;
    int? childid;
    DateTime? diarydate;
    String? startTime;
    dynamic nappy;
    dynamic potty;
    dynamic toilet;
    String? signature;
    String? comments;
    String? status;
    String? createdBy;
    DateTime? createdAt;
    DateTime? toiletingCreatedAt;
    DateTime? updatedAt;

    Toileting({
        this.id,
        this.childid,
        this.diarydate,
        this.startTime,
        this.nappy,
        this.potty,
        this.toilet,
        this.signature,
        this.comments,
        this.status,
        this.createdBy,
        this.createdAt,
        this.toiletingCreatedAt,
        this.updatedAt,
    });

    factory Toileting.fromJson(Map<String, dynamic> json) => Toileting(
        id: json["id"],
        childid: json["childid"],
        diarydate: json["diarydate"] == null ? null : DateTime.parse(json["diarydate"]),
        startTime: json["startTime"],
        nappy: json["nappy"],
        potty: json["potty"],
        toilet: json["toilet"],
        signature: json["signature"],
        comments: json["comments"],
        status: json["status"],
        createdBy: json["createdBy"],
        createdAt: json["createdAt"] == null ? null : DateTime.parse(json["createdAt"]),
        toiletingCreatedAt: json["created_at"] == null ? null : DateTime.parse(json["created_at"]),
        updatedAt: json["updated_at"] == null ? null : DateTime.parse(json["updated_at"]),
    );

    Map<String, dynamic> toJson() => {
        "id": id,
        "childid": childid,
        "diarydate": "${diarydate!.year.toString().padLeft(4, '0')}-${diarydate!.month.toString().padLeft(2, '0')}-${diarydate!.day.toString().padLeft(2, '0')}",
        "startTime": startTime,
        "nappy": nappy,
        "potty": potty,
        "toilet": toilet,
        "signature": signature,
        "comments": comments,
        "status": status,
        "createdBy": createdBy,
        "createdAt": createdAt?.toIso8601String(),
        "created_at": toiletingCreatedAt?.toIso8601String(),
        "updated_at": updatedAt?.toIso8601String(),
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
