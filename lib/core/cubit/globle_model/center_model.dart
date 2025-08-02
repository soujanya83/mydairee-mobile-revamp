// To parse this JSON data, do
//
//     final centerModel = centerModelFromJson(jsonString);

import 'dart:convert';

CenterModel centerModelFromJson(String str) => CenterModel.fromJson(json.decode(str));

String centerModelToJson(CenterModel data) => json.encode(data.toJson());

class CenterModel {
    bool? status;
    List<Datum>? data;

    CenterModel({
        this.status,
        this.data,
    });

    factory CenterModel.fromJson(Map<String, dynamic> json) => CenterModel(
        status: json["status"],
        data: json["data"] == null ? [] : List<Datum>.from(json["data"]!.map((x) => Datum.fromJson(x))),
    );

    Map<String, dynamic> toJson() => {
        "status": status,
        "data": data == null ? [] : List<dynamic>.from(data!.map((x) => x.toJson())),
    };
}

class Datum {
    String id;
    dynamic userId;
    String? centerName;
    String? adressStreet;
    String? addressCity;
    String? addressState;
    String? addressZip;
    DateTime? createdAt;
    DateTime? updatedAt;

    Datum({
        required this.id,
        this.userId,
        this.centerName,
        this.adressStreet,
        this.addressCity,
        this.addressState,
        this.addressZip,
        this.createdAt,
        this.updatedAt,
    });

    factory Datum.fromJson(Map<String, dynamic> json) => Datum(
         id: (json["id"] != null ? json["id"].toString() : null).toString(),
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
