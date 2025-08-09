import 'package:mydiaree/core/utils/helper_functions.dart';

class AccidentListResponseModel {
  final bool success;
  final String message;
  final AccidentListData data;

  AccidentListResponseModel({
    required this.success,
    required this.message,
    required this.data,
  });

  factory AccidentListResponseModel.fromJson(Map<String, dynamic> json) {
    return AccidentListResponseModel(
      success: json['success'] ?? false,
      message: json['message'] ?? '',
      data: AccidentListData.fromJson(json['data'] ?? {}),
    );
  }
}

class AccidentListData {
  final String centerid;
  final String date;
  final String roomid;
  final String roomname;
  final String roomcolor;
  final List<RoomModel> rooms;
  final List<ChildModel> childs;
  final List<AccidentModel> accidents;
  final List<CenterModel> centers;
  final String selectedCenter;

  AccidentListData({
    required this.centerid,
    required this.date,
    required this.roomid,
    required this.roomname,
    required this.roomcolor,
    required this.rooms,
    required this.childs,
    required this.accidents,
    required this.centers,
    required this.selectedCenter,
  });

  factory AccidentListData.fromJson(Map<String, dynamic> json) {
    return AccidentListData(
      centerid: json['centerid'] ?? '',
      date: json['date'] ?? '',
      roomid: json['roomid'].toString(),
      roomname: json['roomname'] ?? '',
      roomcolor: json['roomcolor'] ?? '',
      rooms: List<RoomModel>.from(
          (json['rooms'] ?? []).map((x) => RoomModel.fromJson(x))),
      childs: List<ChildModel>.from(
          (json['childs'] ?? []).map((x) => ChildModel.fromJson(x))),
      accidents: List<AccidentModel>.from(
          (json['accidents'] ?? []).map((x) => AccidentModel.fromJson(x))),
      centers: List<CenterModel>.from(
          (json['centers'] ?? []).map((x) => CenterModel.fromJson(x))),
      selectedCenter: json['selectedCenter'] ?? '',
    );
  }
}

class RoomModel {
  final int id;
  final String name;
  final int capacity;
  final int userId;
  final String color;
  final int ageFrom;
  final int ageTo;
  final String status;
  final int centerid;
  final dynamic created_by;

  RoomModel({
    required this.id,
    required this.name,
    required this.capacity,
    required this.userId,
    required this.color,
    required this.ageFrom,
    required this.ageTo,
    required this.status,
    required this.centerid,
    required this.created_by,
  });

  factory RoomModel.fromJson(Map<String, dynamic> json) {
    return RoomModel(
      id: json['id'] ?? 0,
      name: json['name'] ?? '',
      capacity: json['capacity'] ?? 0,
      userId: json['userId'] ?? 0,
      color: json['color'] ?? '',
      ageFrom: json['ageFrom'] ?? 0,
      ageTo: json['ageTo'] ?? 0,
      status: json['status'] ?? '',
      centerid: json['centerid'] ?? 0,
      created_by: json['created_by'],
    );
  }
}

class ChildModel {
  final int id;
  final String name;
  final String lastname;
  final String dob;
  final String startDate;
  final int room;
  final String imageUrl;
  final String gender;
  final String status;
  final String daysAttending;
  final int centerid;
  final int createdBy;
  final String createdAt;
  final String? created_at;
  final String? updated_at;

  ChildModel({
    required this.id,
    required this.name,
    required this.lastname,
    required this.dob,
    required this.startDate,
    required this.room,
    required this.imageUrl,
    required this.gender,
    required this.status,
    required this.daysAttending,
    required this.centerid,
    required this.createdBy,
    required this.createdAt,
    this.created_at,
    this.updated_at,
  });

  factory ChildModel.fromJson(Map<String, dynamic> json) {
    return ChildModel(
      id: json['id'] ?? 0,
      name: json['name'] ?? '',
      lastname: json['lastname'] ?? '',
      dob: json['dob'] ?? '',
      startDate: json['startDate'] ?? '',
      room: json['room'] ?? 0,
      imageUrl: json['imageUrl'] ?? '',
      gender: json['gender'] ?? '',
      status: json['status'] ?? '',
      daysAttending: json['daysAttending'] ?? '',
      centerid: json['centerid'] ?? 0,
      createdBy: json['createdBy'] ?? 0,
      createdAt: json['createdAt'] ?? '',
      created_at: json['created_at'],
      updated_at: json['updated_at'],
    );
  }
}

class AccidentModel {
  final int id;
  final String child_name;
  final String child_gender;
  final int roomid;
  final String incident_date;
  final String? ack_parent_name;
  final int added_by;
  final String username;

  AccidentModel({
    required this.id,
    required this.child_name,
    required this.child_gender,
    required this.roomid,
    required this.incident_date,
    this.ack_parent_name,
    required this.added_by,
    required this.username,
  });

  factory AccidentModel.fromJson(Map<String, dynamic> json) {
    return AccidentModel(
      id: json['id'] ?? 0,
      child_name: json['child_name'] ?? '',
      child_gender: json['child_gender'] ?? '',
      roomid: json['roomid'] ?? 0,
      incident_date: json['incident_date'] ?? '',
      ack_parent_name: json['ack_parent_name'],
      added_by: json['added_by'] ?? 0,
      username: json['username'] ?? '',
    );
  }
}

class CenterModel {
  final int id;
  final dynamic user_id;
  final String centerName;
  final String adressStreet;
  final String addressCity;
  final String addressState;
  final String addressZip;
  final String created_at;
  final String updated_at;

  CenterModel({
    required this.id,
    this.user_id,
    required this.centerName,
    required this.adressStreet,
    required this.addressCity,
    required this.addressState,
    required this.addressZip,
    required this.created_at,
    required this.updated_at,
  });

  factory CenterModel.fromJson(Map<String, dynamic> json) {
    return CenterModel(
      id: json['id'] ?? 0,
      user_id: json['user_id'],
      centerName: json['centerName'] ?? '',
      adressStreet: json['adressStreet'] ?? '',
      addressCity: json['addressCity'] ?? '',
      addressState: json['addressState'] ?? '',
      addressZip: json['addressZip'] ?? '',
      created_at: json['created_at'] ?? '',
      updated_at: json['updated_at'] ?? '',
    );
  }
}