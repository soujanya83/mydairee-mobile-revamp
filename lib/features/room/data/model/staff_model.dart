// To parse this JSON data, do
//
//     final staffModel = staffModelFromJson(jsonString);

import 'dart:convert';

StaffListModel staffModelFromJson(String str) => StaffListModel.fromJson(json.decode(str));

String staffModelToJson(StaffListModel data) => json.encode(data.toJson());

class StaffListModel {
    bool? status;
    String? message;
    int? count;
    List<Staff>? data;

    StaffListModel({
        this.status,
        this.message,
        this.count,
        this.data,
    });

    factory StaffListModel.fromJson(Map<String, dynamic> json) => StaffListModel(
        status: json["status"],
        message: json["message"],
        count: json["count"],
        data: json["data"] == null ? [] : List<Staff>.from(json["data"]!.map((x) => Staff.fromJson(x))),
    );

    Map<String, dynamic> toJson() => {
        "status": status,
        "message": message,
        "count": count,
        "data": data == null ? [] : List<dynamic>.from(data!.map((x) => x.toJson())),
    };
}

class Staff {
    int? id;
    int? userid;
    String? username;
    String? emailid;
    String? email;
    int? centerStatus;
    String? contactNo;
    String? name;
    DateTime? dob;
    Gender? gender;
    String? imageUrl;
    UserType? userType;
    String? title;
    Status? status;
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

    Staff({
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

    factory Staff.fromJson(Map<String, dynamic> json) => Staff(
        id: json["id"],
        userid: json["userid"],
        username: json["username"],
        emailid: json["emailid"],
        email: json["email"],
        centerStatus: json["center_status"],
        contactNo: json["contactNo"],
        name: json["name"],
        dob: json["dob"] == null ? null : DateTime.parse(json["dob"]),
        gender: genderValues.map[json["gender"]]!,
        imageUrl: json["imageUrl"],
        userType: userTypeValues.map[json["userType"]]!,
        title: json["title"],
        status: statusValues.map[json["status"]]!,
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
        "gender": genderValues.reverse[gender],
        "imageUrl": imageUrl,
        "userType": userTypeValues.reverse[userType],
        "title": title,
        "status": statusValues.reverse[status],
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

enum Gender {
    FEMALE,
    MALE
}

final genderValues = EnumValues({
    "FEMALE": Gender.FEMALE,
    "MALE": Gender.MALE
});

enum Status {
    ACTIVE,
    IN_ACTIVE
}

final statusValues = EnumValues({
    "ACTIVE": Status.ACTIVE,
    "IN-ACTIVE": Status.IN_ACTIVE
});

enum UserType {
    STAFF
}

final userTypeValues = EnumValues({
    "Staff": UserType.STAFF
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
