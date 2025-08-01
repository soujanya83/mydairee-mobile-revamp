// To parse this JSON data, do
//
//     final loginModel = loginModelFromJson(jsonString);

import 'dart:convert';

LoginModel loginModelFromJson(String str) => LoginModel.fromJson(json.decode(str));

String loginModelToJson(LoginModel data) => json.encode(data.toJson());

class LoginModel {
    String? status;
    String? message;
    String? token;
    User? user;

    LoginModel({
        this.status,
        this.message,
        this.token,
        this.user,
    });

    factory LoginModel.fromJson(Map<String, dynamic> json) => LoginModel(
        status: json["status"],
        message: json["message"],
        token: json["token"],
        user: json["user"] == null ? null : User.fromJson(json["user"]),
    );

    Map<String, dynamic> toJson() => {
        "status": status,
        "message": message,
        "token": token,
        "user": user?.toJson(),
    };
}

class User {
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
    dynamic status;
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

    User({
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

    factory User.fromJson(Map<String, dynamic> json) => User(
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
