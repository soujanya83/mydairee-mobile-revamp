// To parse this JSON data, do
//
//     final programPlanData = programPlanDataFromJson(jsonString);

import 'dart:convert';

ProgramPlanData programPlanDataFromJson(String str) => ProgramPlanData.fromJson(json.decode(str));

String programPlanDataToJson(ProgramPlanData data) => json.encode(data.toJson());

class ProgramPlanData {
    List<Room>? rooms;
    List<User>? users;
    String? centerId;
    int? userId;
    List<EylfOutcome>? eylfOutcomes;
    List<MontessoriSubject>? montessoriSubjects;
    dynamic planData;
    List<dynamic>? selectedEducators;
    List<dynamic>? selectedChildren;

    ProgramPlanData({
        this.rooms,
        this.users,
        this.centerId,
        this.userId,
        this.eylfOutcomes,
        this.montessoriSubjects,
        this.planData,
        this.selectedEducators,
        this.selectedChildren,
    });

    factory ProgramPlanData.fromJson(Map<String, dynamic> json) => ProgramPlanData(
        rooms: json["rooms"] == null ? [] : List<Room>.from(json["rooms"]!.map((x) => Room.fromJson(x))),
        users: json["users"] == null ? [] : List<User>.from(json["users"]!.map((x) => User.fromJson(x))),
        centerId: json["centerId"],
        userId: json["userId"],
        eylfOutcomes: json["eylf_outcomes"] == null ? [] : List<EylfOutcome>.from(json["eylf_outcomes"]!.map((x) => EylfOutcome.fromJson(x))),
        montessoriSubjects: json["montessori_subjects"] == null ? [] : List<MontessoriSubject>.from(json["montessori_subjects"]!.map((x) => MontessoriSubject.fromJson(x))),
        planData: json["plan_data"],
        selectedEducators: json["selected_educators"] == null ? [] : List<dynamic>.from(json["selected_educators"]!.map((x) => x)),
        selectedChildren: json["selected_children"] == null ? [] : List<dynamic>.from(json["selected_children"]!.map((x) => x)),
    );

    Map<String, dynamic> toJson() => {
        "rooms": rooms == null ? [] : List<dynamic>.from(rooms!.map((x) => x.toJson())),
        "users": users == null ? [] : List<dynamic>.from(users!.map((x) => x.toJson())),
        "centerId": centerId,
        "userId": userId,
        "eylf_outcomes": eylfOutcomes == null ? [] : List<dynamic>.from(eylfOutcomes!.map((x) => x.toJson())),
        "montessori_subjects": montessoriSubjects == null ? [] : List<dynamic>.from(montessoriSubjects!.map((x) => x.toJson())),
        "plan_data": planData,
        "selected_educators": selectedEducators == null ? [] : List<dynamic>.from(selectedEducators!.map((x) => x)),
        "selected_children": selectedChildren == null ? [] : List<dynamic>.from(selectedChildren!.map((x) => x)),
    };
}

class EylfOutcome {
    int? id;
    String? title;
    String? name;
    dynamic addedBy;
    DateTime? addedAt;
    List<EylfOutcomeActivity>? activities;

    EylfOutcome({
        this.id,
        this.title,
        this.name,
        this.addedBy,
        this.addedAt,
        this.activities,
    });

    factory EylfOutcome.fromJson(Map<String, dynamic> json) => EylfOutcome(
        id: json["id"],
        title: json["title"],
        name: json["name"],
        addedBy: json["added_by"],
        addedAt: json["added_at"] == null ? null : DateTime.parse(json["added_at"]),
        activities: json["activities"] == null ? [] : List<EylfOutcomeActivity>.from(json["activities"]!.map((x) => EylfOutcomeActivity.fromJson(x))),
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

class EylfOutcomeActivity {
  int? id;
  int? outcomeId;
  String? title;
  dynamic addedBy;
  AddedAt? addedAt;
  bool choosen;  

  EylfOutcomeActivity({
    this.id,
    this.outcomeId,
    this.title,
    this.addedBy,
    this.addedAt,
    this.choosen = false, // Default value
  });

  factory EylfOutcomeActivity.fromJson(Map<String, dynamic> json) => EylfOutcomeActivity(
    id: json["id"],
    outcomeId: json["outcomeId"],
    title: json["title"],
    addedBy: json["added_by"],
    addedAt: json["added_at"] == null ? null : addedAtValues.map[json["added_at"]],
    choosen: json["choosen"] ?? false,
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "outcomeId": outcomeId,
    "title": title,
    "added_by": addedBy,
    "added_at": addedAtValues.reverse[addedAt],
    "choosen": choosen,
  };
}
enum AddedAt {
    the00000000000000
}

final addedAtValues = EnumValues({
    "0000-00-00 00:00:00": AddedAt.the00000000000000
});

class MontessoriSubject {
    int? idSubject;
    String? name;
    List<MontessoriSubjectActivity>? activities;

    MontessoriSubject({
        this.idSubject,
        this.name,
        this.activities,
    });

    factory MontessoriSubject.fromJson(Map<String, dynamic> json) => MontessoriSubject(
        idSubject: json["idSubject"],
        name: json["name"],
        activities: json["activities"] == null ? [] : List<MontessoriSubjectActivity>.from(json["activities"]!.map((x) => MontessoriSubjectActivity.fromJson(x))),
    );

    Map<String, dynamic> toJson() => {
        "idSubject": idSubject,
        "name": name,
        "activities": activities == null ? [] : List<dynamic>.from(activities!.map((x) => x.toJson())),
    };
}

class MontessoriSubjectActivity {
    int? idActivity;
    int? idSubject;
    String? title;
    dynamic addedBy;
    DateTime? addedAt;
    List<SubActivity>? subActivities;

    MontessoriSubjectActivity({
        this.idActivity,
        this.idSubject,
        this.title,
        this.addedBy,
        this.addedAt,
        this.subActivities,
    });

    factory MontessoriSubjectActivity.fromJson(Map<String, dynamic> json) => MontessoriSubjectActivity(
        idActivity: json["idActivity"],
        idSubject: json["idSubject"],
        title: json["title"],
        addedBy: json["added_by"],
        addedAt: json["added_at"] == null ? null : DateTime.parse(json["added_at"]),
        subActivities: json["sub_activities"] == null ? [] : List<SubActivity>.from(json["sub_activities"]!.map((x) => SubActivity.fromJson(x))),
    );

    Map<String, dynamic> toJson() => {
        "idActivity": idActivity,
        "idSubject": idSubject,
        "title": title,
        "added_by": addedBy,
        "added_at": addedAt?.toIso8601String(),
        "sub_activities": subActivities == null ? [] : List<dynamic>.from(subActivities!.map((x) => x.toJson())),
    };
}
class SubActivity {
  int? idSubActivity;
  int? idActivity;
  String? title;
  String? subject;
  String? imageUrl;
  dynamic addedBy;
  DateTime? addedAt;
  bool choosen;

  SubActivity({
    this.idSubActivity,
    this.idActivity,
    this.title,
    this.subject,
    this.imageUrl,
    this.addedBy,
    this.addedAt,
    this.choosen = false, // Default value
  });

  factory SubActivity.fromJson(Map<String, dynamic> json) => SubActivity(
        idSubActivity: json["idSubActivity"],
        idActivity: json["idActivity"],
        title: json["title"],
        subject: json["subject"],
        imageUrl: json["imageUrl"],
        addedBy: json["added_by"],
        addedAt: json["added_at"] == null ? null : DateTime.parse(json["added_at"]),
        choosen: json["choosen"] ?? false,
      );

  Map<String, dynamic> toJson() => {
        "idSubActivity": idSubActivity,
        "idActivity": idActivity,
        "title": title,
        "subject": subject,
        "imageUrl": imageUrl,
        "added_by": addedBy,
        "added_at": addedAt?.toIso8601String(),
        "choosen": choosen,
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
        gender: json["gender"] == null ? null : genderValues.map[json["gender"]],
        imageUrl: json["imageUrl"],
        userType: json["userType"] == null ? null : userTypeValues.map[json["userType"]],
        title: json["title"],
        status: json["status"] == null ? null : statusValues.map[json["status"]] ?? Status.inActive,
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
    female,
    male
}

final genderValues = EnumValues({
    "FEMALE": Gender.female,
    "MALE": Gender.male
});

enum Status {
    active,
    inActive
}

final statusValues = EnumValues({
    "ACTIVE": Status.active,
    "IN-ACTIVE": Status.inActive
});

enum UserType {
    staff,
    superadmin
}

final userTypeValues = EnumValues({
    "Staff": UserType.staff,
    "Superadmin": UserType.superadmin
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
