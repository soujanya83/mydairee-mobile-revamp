// To parse this JSON data, do
//
//     final roomListModel = roomListModelFromJson(jsonString);

import 'dart:convert';

RoomListModel roomListModelFromJson(String str) => RoomListModel.fromJson(json.decode(str));

String roomListModelToJson(RoomListModel data) => json.encode(data.toJson());

class RoomListModel {
    bool? status;
    String? message;
    List<Room>? rooms;
    List<CenterData>? centers;
    String? centerid;
    List<RoomStaff>? roomStaffs;

    RoomListModel({
        this.status,
        this.message,
        this.rooms,
        this.centers,
        this.centerid,
        this.roomStaffs,
    });

    factory RoomListModel.fromJson(Map<String, dynamic>? json) {
      try {
        final rawStatus = json?['status'];
        bool status = false;
        if (rawStatus is bool) status = rawStatus;
        else if (rawStatus is num) status = rawStatus.toInt() == 1;
        else if (rawStatus is String) status = rawStatus.toLowerCase() == 'true' || rawStatus == '1';
        final message = json?['message']?.toString() ?? '';
        final roomsJson = json?['rooms'] as List? ?? [];
    final rooms = roomsJson.map((e) => Room.fromJson(e is Map<String, dynamic> ? e : <String, dynamic>{})).toList();
        final centersJson = json?['centers'] as List? ?? [];
    final centers = centersJson.map((e) => CenterData.fromJson(e is Map<String, dynamic> ? e : <String, dynamic>{})).toList();
        final centerid = json?['centerid']?.toString() ?? '';
        final staffsJson = json?['roomStaffs'] as List? ?? [];
    final roomStaffs = staffsJson.map((e) => RoomStaff.fromJson(e is Map<String, dynamic> ? e : <String, dynamic>{})).toList();
        return RoomListModel(
          status: status,
          message: message,
          rooms: rooms,
          centers: centers,
          centerid: centerid,
          roomStaffs: roomStaffs,
        );
      } catch (e,s) {
        print('Error occurred while parsing RoomListModel: $e');
        print('Stack trace: $s');
        return RoomListModel(
          status: false,
          message: '',
          rooms: [],
          centers: [],
          centerid: '',
          roomStaffs: [],
        );
      }
    }

    Map<String, dynamic> toJson() => {
        "status": status,
        "message": message,
        "rooms": rooms == null ? [] : List<dynamic>.from(rooms!.map((x) => x.toJson())),
        "centers": centers == null ? [] : List<dynamic>.from(centers!.map((x) => x.toJson())),
        "centerid": centerid,
        "roomStaffs": roomStaffs == null ? [] : List<dynamic>.from(roomStaffs!.map((x) => x.toJson())),
    };
}

class CenterData {
    int? id;
    dynamic userId;
    String? centerName;
    String? adressStreet;
    String? addressCity;
    String? addressState;
    String? addressZip;
    DateTime? createdAt;
    DateTime? updatedAt;

    CenterData({
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

    factory CenterData.fromJson(Map<String, dynamic> json) => CenterData(
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

class RoomStaff {
    String? staffid;
    String? name;

    RoomStaff({
        this.staffid,
        this.name,
    });

    factory RoomStaff.fromJson(Map<String, dynamic> json) => RoomStaff(
        staffid: json["staffid"],
        name: json["name"],
    );

    Map<String, dynamic> toJson() => {
        "staffid": staffid,
        "name": name,
    };
}

class Room {
    int? roomid;
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
    List<Child>? children;
    List<Educator>? educators;

    Room({
        this.roomid,
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
        this.children,
        this.educators,
    });

    factory Room.fromJson(Map<String, dynamic> json) => Room(
        roomid: json["roomid"],
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
        children: json["children"] == null ? [] : List<Child>.from(json["children"]!.map((x) => Child.fromJson(x))),
        educators: json["educators"] == null ? [] : List<Educator>.from(json["educators"]!.map((x) => Educator.fromJson(x))),
    );

    Map<String, dynamic> toJson() => {
        "roomid": roomid,
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
        "children": children == null ? [] : List<dynamic>.from(children!.map((x) => x.toJson())),
        "educators": educators == null ? [] : List<dynamic>.from(educators!.map((x) => x.toJson())),
    };
}

class Child {
    int? id;
    String? name;
    String? lastname;
    String? dob;
    String? startDate;
    int? room;
    String? imageUrl;
    ChildGender? gender;
    Status? status;
    String? daysAttending;
    int? createdBy;
    DateTime? createdAt;
    int? centerid;
    DateTime? childCreatedAt;
    DateTime? updatedAt;

    Child({
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

    factory Child.fromJson(Map<String, dynamic> json) => Child(
        id: json["id"],
        name: json["name"],
        lastname: json["lastname"],
        dob: json["dob"],
        startDate: json["startDate"],
        room: json["room"],
        imageUrl: json["imageUrl"],
        gender: childGenderValues.map[json["gender"]]??ChildGender.MALE,
        status: statusValues.map[json["status"]]??Status.ACTIVE,
        daysAttending: json["daysAttending"],
        createdBy: json["createdBy"],
        createdAt: json["createdAt"] == null ? null : DateTime.parse(json["createdAt"]),
        centerid: json["centerid"],
    childCreatedAt: json["created_at"] == null ? null : DateTime.parse(json["created_at"]),
    updatedAt: json["updated_at"] == null ? null : DateTime.parse(json["updated_at"]),
    );

    Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "lastname": lastname,
        "dob": dob,
        "startDate": startDate,
        "room": room,
        "imageUrl": imageUrl,
        "gender": childGenderValues.reverse[gender],
        "status": statusValues.reverse[status],
        "daysAttending": daysAttending,
        "createdBy": createdBy,
        "createdAt": createdAt?.toIso8601String(),
        "centerid": centerid,
        "created_at": childCreatedAt?.toIso8601String(),
        "updated_at": updatedAt,
    };
}

enum ChildGender {
    FEMALE,
    MALE
}

final childGenderValues = EnumValues({
    "Female": ChildGender.FEMALE,
    "Male": ChildGender.MALE
});

enum Status {
    ACTIVE
}

final statusValues = EnumValues({
    "Active": Status.ACTIVE
});

class Educator {
    int? userid;
    String? name;
    EducatorGender? gender;
    String? imageUrl;

    Educator({
        this.userid,
        this.name,
        this.gender,
        this.imageUrl,
    });

    factory Educator.fromJson(Map<String, dynamic> json) => Educator(
        userid: json["userid"],
        name: json["name"],
        gender: educatorGenderValues.map[json["gender"]]!,
        imageUrl: json["imageUrl"],
    );

    Map<String, dynamic> toJson() => {
        "userid": userid,
        "name": name,
        "gender": educatorGenderValues.reverse[gender],
        "imageUrl": imageUrl,
    };
}

enum EducatorGender {
    FEMALE,
    MALE
}

final educatorGenderValues = EnumValues({
    "FEMALE": EducatorGender.FEMALE,
    "MALE": EducatorGender.MALE
});

class EnumValues<T> {
    Map<String, T> map;
    late Map<T, String> reverseMap;

    EnumValues(this.map);

    Map<T, String> get reverse {
            reverseMap = map.map((k, v) => MapEntry(v, k));
            return reverseMap;
    }
}
