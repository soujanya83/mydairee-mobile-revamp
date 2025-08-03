// To parse this JSON data, do
//
//     final announcementViewModel = announcementViewModelFromJson(jsonString);

import 'dart:convert';

AnnouncementViewModel announcementViewModelFromJson(String str) => AnnouncementViewModel.fromJson(json.decode(str));

String announcementViewModelToJson(AnnouncementViewModel data) => json.encode(data.toJson());

class AnnouncementViewModel {
    String? status;
    Data? data;

    AnnouncementViewModel({
        this.status,
        this.data,
    });

    factory AnnouncementViewModel.fromJson(Map<String, dynamic> json) => AnnouncementViewModel(
        status: json["status"],
        data: json["data"] == null ? null : Data.fromJson(json["data"]),
    );

    Map<String, dynamic> toJson() => {
        "status": status,
        "data": data?.toJson(),
    };
}

class Data {
    Info? info;
    dynamic permissions;
    int? centerid;

    Data({
        this.info,
        this.permissions,
        this.centerid,
    });

    factory Data.fromJson(Map<String, dynamic> json) => Data(
        info: json["info"] == null ? null : Info.fromJson(json["info"]),
        permissions: json["permissions"],
        centerid: json["centerid"],
    );

    Map<String, dynamic> toJson() => {
        "info": info?.toJson(),
        "permissions": permissions,
        "centerid": centerid,
    };
}

class Info {
    int? id;
    String? title;
    String? text;
    String? eventDate;
    String? status;
    dynamic announcementMedia;
    int? centerid;
    String? createdBy;
    String? createdAt;
    String? username;

    Info({
        this.id,
        this.title,
        this.text,
        this.eventDate,
        this.status,
        this.announcementMedia,
        this.centerid,
        this.createdBy,
        this.createdAt,
        this.username,
    });

    factory Info.fromJson(Map<String, dynamic> json) => Info(
        id: json["id"],
        title: json["title"],
        text: json["text"],
        eventDate: json["eventDate"],
        status: json["status"],
        announcementMedia: json["announcementMedia"],
        centerid: json["centerid"],
        createdBy: json["createdBy"],
        createdAt: json["createdAt"],
        username: json["username"],
    );

    Map<String, dynamic> toJson() => {
        "id": id,
        "title": title,
        "text": text,
        "eventDate": eventDate,
        "status": status,
        "announcementMedia": announcementMedia,
        "centerid": centerid,
        "createdBy": createdBy,
        "createdAt": createdAt,
        "username": username,
    };
}