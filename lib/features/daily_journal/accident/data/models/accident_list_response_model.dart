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
  final String centerId;
  final String date;
  final String roomId;
  final String roomName;
  final String roomColor;
  final List<RoomModel> rooms;
  final List<ChildModel> children;
  final List<AccidentModel> accidents;
  final List<CenterModel> centers;
  final String selectedCenter;

  AccidentListData({
    required this.centerId,
    required this.date,
    required this.roomId,
    required this.roomName,
    required this.roomColor,
    required this.rooms,
    required this.children,
    required this.accidents,
    required this.centers,
    required this.selectedCenter,
  });

  factory AccidentListData.fromJson(Map<String, dynamic> json) {
    return AccidentListData(
      centerId: json['centerid'] ?? '',
      date: json['date'] ?? '',
      roomId: json['roomid'] ?? '',
      roomName: json['roomname'] ?? '',
      roomColor: json['roomcolor'] ?? '',
      rooms: List<RoomModel>.from(
          (json['rooms'] ?? []).map((x) => RoomModel.fromJson(x))),
      children: List<ChildModel>.from(
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
  final int centerId;
  final dynamic createdBy;

  RoomModel({
    required this.id,
    required this.name,
    required this.capacity,
    required this.userId,
    required this.color,
    required this.ageFrom,
    required this.ageTo,
    required this.status,
    required this.centerId,
    required this.createdBy,
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
      centerId: json['centerid'] ?? 0,
      createdBy: json['created_by'],
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
  final int centerId;
  final int createdBy;
  final String createdAt;

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
    required this.centerId,
    required this.createdBy,
    required this.createdAt,
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
      centerId: json['centerid'] ?? 0,
      createdBy: json['createdBy'] ?? 0,
      createdAt: json['createdAt'] ?? '',
    );
  }
}

class AccidentModel {
  final int id;
  final String childName;
  final String childGender;
  final int roomId;
  final String incidentDate;
  final String? ackParentName;
  final int addedBy;
  final String username;

  AccidentModel({
    required this.id,
    required this.childName,
    required this.childGender,
    required this.roomId,
    required this.incidentDate,
    this.ackParentName,
    required this.addedBy,
    required this.username,
  });

  factory AccidentModel.fromJson(Map<String, dynamic> json) {
    return AccidentModel(
      id: json['id'] ?? 0,
      childName: json['child_name'] ?? '',
      childGender: json['child_gender'] ?? '',
      roomId: json['roomid'] ?? 0,
      incidentDate: json['incident_date'] ?? '',
      ackParentName: json['ack_parent_name'],
      addedBy: json['added_by'] ?? 0,
      username: json['username'] ?? '',
    );
  }
}

class CenterModel {
  final int id;
  final dynamic userId;
  final String centerName;
  final String adressStreet;
  final String addressCity;
  final String addressState;
  final String addressZip;
  final String createdAt;
  final String updatedAt;

  CenterModel({
    required this.id,
    this.userId,
    required this.centerName,
    required this.adressStreet,
    required this.addressCity,
    required this.addressState,
    required this.addressZip,
    required this.createdAt,
    required this.updatedAt,
  });

  factory CenterModel.fromJson(Map<String, dynamic> json) {
    return CenterModel(
      id: json['id'] ?? 0,
      userId: json['user_id'],
      centerName: json['centerName'] ?? '',
      adressStreet: json['adressStreet'] ?? '',
      addressCity: json['addressCity'] ?? '',
      addressState: json['addressState'] ?? '',
      addressZip: json['addressZip'] ?? '',
      createdAt: json['created_at'] ?? '',
      updatedAt: json['updated_at'] ?? '',
    );
  }
}