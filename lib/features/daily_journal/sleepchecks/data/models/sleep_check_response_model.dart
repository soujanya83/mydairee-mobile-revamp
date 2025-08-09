import 'package:mydiaree/features/daily_journal/accident/data/models/accident_list_response_model.dart';

class SleepCheckResponseModel {
  final bool status;
  final String message;
  final String centerid;
  final String date;
  final String roomid;
  final String roomname;
  final String roomcolor;
  final List<ChildWithSleepChecks> children;
  final List<RoomModel> rooms;
  final dynamic permissions;
  final List<CenterModel> centers;

  SleepCheckResponseModel({
    required this.status,
    required this.message,
    required this.centerid,
    required this.date,
    required this.roomid,
    required this.roomname,
    required this.roomcolor,
    required this.children,
    required this.rooms,
    this.permissions,
    required this.centers,
  });

  factory SleepCheckResponseModel.fromJson(Map<String, dynamic> json) {
    return SleepCheckResponseModel(
      status: json['status'] ?? false,
      message: json['message'] ?? '',
      centerid: json['centerid']?.toString() ?? '',
      date: json['date'] ?? '',
      roomid: json['roomid']?.toString() ?? '',
      roomname: json['roomname'] ?? '',
      roomcolor: json['roomcolor'] ?? '',
      children: List<ChildWithSleepChecks>.from(
          (json['children'] ?? []).map((x) => ChildWithSleepChecks.fromJson(x))),
      rooms: List<RoomModel>.from(
          (json['rooms'] ?? []).map((x) => RoomModel.fromJson(x))),
      permissions: json['permissions'],
      centers: List<CenterModel>.from(
          (json['centers'] ?? []).map((x) => CenterModel.fromJson(x))),
    );
  }
}

class ChildWithSleepChecks {
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
  final List<SleepCheck> sleepchecks;

  ChildWithSleepChecks({
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
    required this.sleepchecks,
  });

  factory ChildWithSleepChecks.fromJson(Map<String, dynamic> json) {
    return ChildWithSleepChecks(
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
      sleepchecks: List<SleepCheck>.from(
          (json['sleepchecks'] ?? []).map((x) => SleepCheck.fromJson(x))),
    );
  }
}

class SleepCheck {
  final int id;
  final int childid;
  final int roomid;
  final String diarydate;
  final String time;
  final String breathing;
  final String body_temperature;
  final String notes;
  final String createdBy;
  final String created_at;

  SleepCheck({
    required this.id,
    required this.childid,
    required this.roomid,
    required this.diarydate,
    required this.time,
    required this.breathing,
    required this.body_temperature,
    required this.notes,
    required this.createdBy,
    required this.created_at,
  });

  factory SleepCheck.fromJson(Map<String, dynamic> json) {
    return SleepCheck(
      id: json['id'] ?? 0,
      childid: json['childid'] ?? 0,
      roomid: json['roomid'] ?? 0,
      diarydate: json['diarydate'] ?? '',
      time: json['time'] ?? '',
      breathing: json['breathing'] ?? '',
      body_temperature: json['body_temperature'] ?? '',
      notes: json['notes'] ?? '',
      createdBy: json['createdBy']?.toString() ?? '',
      created_at: json['created_at'] ?? '',
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
    this.created_by,
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