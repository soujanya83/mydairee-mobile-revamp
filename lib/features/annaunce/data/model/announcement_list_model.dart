// To parse this JSON data, do
//
//     final announcementsListModel = announcementsListModelFromJson(jsonString);

import 'dart:convert';

AnnouncementsListModel announcementsListModelFromJson(String str) => AnnouncementsListModel.fromJson(json.decode(str));

String announcementsListModelToJson(AnnouncementsListModel data) => json.encode(data.toJson());

class AnnouncementsListModel {
    bool? status;
    Data? data;

    AnnouncementsListModel({
        this.status,
        this.data,
    });

    factory AnnouncementsListModel.fromJson(Map<String, dynamic> json) => AnnouncementsListModel(
        status: json["status"],
        data: json["data"] == null ? null : Data.fromJson(json["data"]),
    );

    Map<String, dynamic> toJson() => {
        "status": status,
        "data": data?.toJson(),
    };
}

class Data {
    List<Record>? records;
    Permissions? permissions;
    List<Center>? centers;
    String? centerId;
    UserType? userType;

    Data({
        this.records,
        this.permissions,
        this.centers,
        this.centerId,
        this.userType,
    });

    factory Data.fromJson(Map<String, dynamic> json) => Data(
        records: json["records"] == null ? [] : List<Record>.from(json["records"]!.map((x) => Record.fromJson(x))),
        permissions: json["permissions"] == null ? null : Permissions.fromJson(json["permissions"]),
        centers: json["centers"] == null ? [] : List<Center>.from(json["centers"]!.map((x) => Center.fromJson(x))),
        centerId: json["centerId"],
        userType: userTypeValues.map[json["userType"]]!,
    );

    Map<String, dynamic> toJson() => {
        "records": records == null ? [] : List<dynamic>.from(records!.map((x) => x.toJson())),
        "permissions": permissions?.toJson(),
        "centers": centers == null ? [] : List<dynamic>.from(centers!.map((x) => x.toJson())),
        "centerId": centerId,
        "userType": userTypeValues.reverse[userType],
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

class Permissions {
    int? id;
    String? userid;
    int? centerid;
    int? addObservation;
    int? approveObservation;
    int? deleteObservation;
    int? updateObservation;
    int? viewAllObservation;
    int? addReflection;
    int? approveReflection;
    int? updatereflection;
    int? deletereflection;
    int? viewAllReflection;
    int? addQip;
    int? editQip;
    int? deleteQip;
    int? downloadQip;
    int? printQip;
    int? mailQip;
    int? viewQip;
    int? viewRoom;
    int? addRoom;
    int? editRoom;
    int? deleteRoom;
    int? addProgramPlan;
    int? editProgramPlan;
    int? viewProgramPlan;
    int? deleteProgramPlan;
    int? addAnnouncement;
    int? approveAnnouncement;
    int? deleteAnnouncement;
    int? updateAnnouncement;
    int? viewAllAnnouncement;
    int? addSurvey;
    int? approveSurvey;
    int? deleteSurvey;
    int? updateSurvey;
    int? viewAllSurvey;
    int? addRecipe;
    int? approveRecipe;
    int? deleteRecipe;
    int? updateRecipe;
    int? addMenu;
    int? approveMenu;
    int? deleteMenu;
    int? updateMenu;
    int? viewDailyDiary;
    int? updateDailyDiary;
    int? updateHeadChecks;
    int? updateAccidents;
    int? updateModules;
    int? addUsers;
    int? viewUsers;
    int? updateUsers;
    int? addCenters;
    int? viewCenters;
    int? updateCenters;
    int? addParent;
    int? viewParent;
    int? updateParent;
    int? addChildGroup;
    int? viewChildGroup;
    int? updateChildGroup;
    int? updatePermission;
    int? addprogress;
    int? editprogress;
    int? viewprogress;
    int? editlesson;
    int? viewlesson;
    int? printpdflesson;
    int? assessment;
    int? addSelfAssessment;
    int? editSelfAssessment;
    int? deleteSelfAssessment;
    int? viewSelfAssessment;

    Permissions({
        this.id,
        this.userid,
        this.centerid,
        this.addObservation,
        this.approveObservation,
        this.deleteObservation,
        this.updateObservation,
        this.viewAllObservation,
        this.addReflection,
        this.approveReflection,
        this.updatereflection,
        this.deletereflection,
        this.viewAllReflection,
        this.addQip,
        this.editQip,
        this.deleteQip,
        this.downloadQip,
        this.printQip,
        this.mailQip,
        this.viewQip,
        this.viewRoom,
        this.addRoom,
        this.editRoom,
        this.deleteRoom,
        this.addProgramPlan,
        this.editProgramPlan,
        this.viewProgramPlan,
        this.deleteProgramPlan,
        this.addAnnouncement,
        this.approveAnnouncement,
        this.deleteAnnouncement,
        this.updateAnnouncement,
        this.viewAllAnnouncement,
        this.addSurvey,
        this.approveSurvey,
        this.deleteSurvey,
        this.updateSurvey,
        this.viewAllSurvey,
        this.addRecipe,
        this.approveRecipe,
        this.deleteRecipe,
        this.updateRecipe,
        this.addMenu,
        this.approveMenu,
        this.deleteMenu,
        this.updateMenu,
        this.viewDailyDiary,
        this.updateDailyDiary,
        this.updateHeadChecks,
        this.updateAccidents,
        this.updateModules,
        this.addUsers,
        this.viewUsers,
        this.updateUsers,
        this.addCenters,
        this.viewCenters,
        this.updateCenters,
        this.addParent,
        this.viewParent,
        this.updateParent,
        this.addChildGroup,
        this.viewChildGroup,
        this.updateChildGroup,
        this.updatePermission,
        this.addprogress,
        this.editprogress,
        this.viewprogress,
        this.editlesson,
        this.viewlesson,
        this.printpdflesson,
        this.assessment,
        this.addSelfAssessment,
        this.editSelfAssessment,
        this.deleteSelfAssessment,
        this.viewSelfAssessment,
    });

    factory Permissions.fromJson(Map<String, dynamic> json) => Permissions(
        id: json["id"],
        userid: json["userid"],
        centerid: json["centerid"],
        addObservation: json["addObservation"],
        approveObservation: json["approveObservation"],
        deleteObservation: json["deleteObservation"],
        updateObservation: json["updateObservation"],
        viewAllObservation: json["viewAllObservation"],
        addReflection: json["addReflection"],
        approveReflection: json["approveReflection"],
        updatereflection: json["updatereflection"],
        deletereflection: json["deletereflection"],
        viewAllReflection: json["viewAllReflection"],
        addQip: json["addQIP"],
        editQip: json["editQIP"],
        deleteQip: json["deleteQIP"],
        downloadQip: json["downloadQIP"],
        printQip: json["printQIP"],
        mailQip: json["mailQIP"],
        viewQip: json["viewQip"],
        viewRoom: json["viewRoom"],
        addRoom: json["addRoom"],
        editRoom: json["editRoom"],
        deleteRoom: json["deleteRoom"],
        addProgramPlan: json["addProgramPlan"],
        editProgramPlan: json["editProgramPlan"],
        viewProgramPlan: json["viewProgramPlan"],
        deleteProgramPlan: json["deleteProgramPlan"],
        addAnnouncement: json["addAnnouncement"],
        approveAnnouncement: json["approveAnnouncement"],
        deleteAnnouncement: json["deleteAnnouncement"],
        updateAnnouncement: json["updateAnnouncement"],
        viewAllAnnouncement: json["viewAllAnnouncement"],
        addSurvey: json["addSurvey"],
        approveSurvey: json["approveSurvey"],
        deleteSurvey: json["deleteSurvey"],
        updateSurvey: json["updateSurvey"],
        viewAllSurvey: json["viewAllSurvey"],
        addRecipe: json["addRecipe"],
        approveRecipe: json["approveRecipe"],
        deleteRecipe: json["deleteRecipe"],
        updateRecipe: json["updateRecipe"],
        addMenu: json["addMenu"],
        approveMenu: json["approveMenu"],
        deleteMenu: json["deleteMenu"],
        updateMenu: json["updateMenu"],
        viewDailyDiary: json["viewDailyDiary"],
        updateDailyDiary: json["updateDailyDiary"],
        updateHeadChecks: json["updateHeadChecks"],
        updateAccidents: json["updateAccidents"],
        updateModules: json["updateModules"],
        addUsers: json["addUsers"],
        viewUsers: json["viewUsers"],
        updateUsers: json["updateUsers"],
        addCenters: json["addCenters"],
        viewCenters: json["viewCenters"],
        updateCenters: json["updateCenters"],
        addParent: json["addParent"],
        viewParent: json["viewParent"],
        updateParent: json["updateParent"],
        addChildGroup: json["addChildGroup"],
        viewChildGroup: json["viewChildGroup"],
        updateChildGroup: json["updateChildGroup"],
        updatePermission: json["updatePermission"],
        addprogress: json["addprogress"],
        editprogress: json["editprogress"],
        viewprogress: json["viewprogress"],
        editlesson: json["editlesson"],
        viewlesson: json["viewlesson"],
        printpdflesson: json["printpdflesson"],
        assessment: json["assessment"],
        addSelfAssessment: json["addSelfAssessment"],
        editSelfAssessment: json["editSelfAssessment"],
        deleteSelfAssessment: json["deleteSelfAssessment"],
        viewSelfAssessment: json["viewSelfAssessment"],
    );

    Map<String, dynamic> toJson() => {
        "id": id,
        "userid": userid,
        "centerid": centerid,
        "addObservation": addObservation,
        "approveObservation": approveObservation,
        "deleteObservation": deleteObservation,
        "updateObservation": updateObservation,
        "viewAllObservation": viewAllObservation,
        "addReflection": addReflection,
        "approveReflection": approveReflection,
        "updatereflection": updatereflection,
        "deletereflection": deletereflection,
        "viewAllReflection": viewAllReflection,
        "addQIP": addQip,
        "editQIP": editQip,
        "deleteQIP": deleteQip,
        "downloadQIP": downloadQip,
        "printQIP": printQip,
        "mailQIP": mailQip,
        "viewQip": viewQip,
        "viewRoom": viewRoom,
        "addRoom": addRoom,
        "editRoom": editRoom,
        "deleteRoom": deleteRoom,
        "addProgramPlan": addProgramPlan,
        "editProgramPlan": editProgramPlan,
        "viewProgramPlan": viewProgramPlan,
        "deleteProgramPlan": deleteProgramPlan,
        "addAnnouncement": addAnnouncement,
        "approveAnnouncement": approveAnnouncement,
        "deleteAnnouncement": deleteAnnouncement,
        "updateAnnouncement": updateAnnouncement,
        "viewAllAnnouncement": viewAllAnnouncement,
        "addSurvey": addSurvey,
        "approveSurvey": approveSurvey,
        "deleteSurvey": deleteSurvey,
        "updateSurvey": updateSurvey,
        "viewAllSurvey": viewAllSurvey,
        "addRecipe": addRecipe,
        "approveRecipe": approveRecipe,
        "deleteRecipe": deleteRecipe,
        "updateRecipe": updateRecipe,
        "addMenu": addMenu,
        "approveMenu": approveMenu,
        "deleteMenu": deleteMenu,
        "updateMenu": updateMenu,
        "viewDailyDiary": viewDailyDiary,
        "updateDailyDiary": updateDailyDiary,
        "updateHeadChecks": updateHeadChecks,
        "updateAccidents": updateAccidents,
        "updateModules": updateModules,
        "addUsers": addUsers,
        "viewUsers": viewUsers,
        "updateUsers": updateUsers,
        "addCenters": addCenters,
        "viewCenters": viewCenters,
        "updateCenters": updateCenters,
        "addParent": addParent,
        "viewParent": viewParent,
        "updateParent": updateParent,
        "addChildGroup": addChildGroup,
        "viewChildGroup": viewChildGroup,
        "updateChildGroup": updateChildGroup,
        "updatePermission": updatePermission,
        "addprogress": addprogress,
        "editprogress": editprogress,
        "viewprogress": viewprogress,
        "editlesson": editlesson,
        "viewlesson": viewlesson,
        "printpdflesson": printpdflesson,
        "assessment": assessment,
        "addSelfAssessment": addSelfAssessment,
        "editSelfAssessment": editSelfAssessment,
        "deleteSelfAssessment": deleteSelfAssessment,
        "viewSelfAssessment": viewSelfAssessment,
    };
}

class Record {
    int? id;
    String? title;
    String? text;
    String? eventDate;
    Status? status;
    dynamic announcementMedia;
    int? centerid;
    CreatedBy? createdBy;
    DateTime? createdAt;
    Creator? creator;

    Record({
        this.id,
        this.title,
        this.text,
        this.eventDate,
        this.status,
        this.announcementMedia,
        this.centerid,
        this.createdBy,
        this.createdAt,
        this.creator,
    });

    factory Record.fromJson(Map<String, dynamic> json) => Record(
        id: json["id"],
        title: json["title"],
        text: json["text"],
        eventDate: json["eventDate"],
        status: statusValues.map[json["status"]]!,
        announcementMedia: json["announcementMedia"],
        centerid: json["centerid"],
        createdBy: createdByValues.map[json["createdBy"]]!,
        createdAt: json["createdAt"] == null ? null : DateTime.parse(json["createdAt"]),
        creator: json["creator"] == null ? null : Creator.fromJson(json["creator"]),
    );

    Map<String, dynamic> toJson() => {
        "id": id,
        "title": title,
        "text": text,
        "eventDate": eventDate,
        "status": statusValues.reverse[status],
        "announcementMedia": announcementMedia,
        "centerid": centerid,
        "createdBy": createdByValues.reverse[createdBy],
        "createdAt": createdAt?.toIso8601String(),
        "creator": creator?.toJson(),
    };
}

enum CreatedBy {
    DEEPTI
}

final createdByValues = EnumValues({
    "Deepti": CreatedBy.DEEPTI
});

class Creator {
    int? id;
    int? userid;
    Email? username;
    Email? emailid;
    Email? email;
    int? centerStatus;
    String? contactNo;
    CreatedBy? name;
    DateTime? dob;
    Gender? gender;
    ImageUrl? imageUrl;
    UserType? userType;
    Title? title;
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

    Creator({
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

    factory Creator.fromJson(Map<String, dynamic> json) => Creator(
        id: json["id"],
        userid: json["userid"],
        username: emailValues.map[json["username"]]!,
        emailid: emailValues.map[json["emailid"]]!,
        email: emailValues.map[json["email"]]!,
        centerStatus: json["center_status"],
        contactNo: json["contactNo"],
        name: createdByValues.map[json["name"]]!,
        dob: json["dob"] == null ? null : DateTime.parse(json["dob"]),
        gender: genderValues.map[json["gender"]]!,
        imageUrl: imageUrlValues.map[json["imageUrl"]]!,
        userType: userTypeValues.map[json["userType"]]!,
        title: titleValues.map[json["title"]]!,
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
        "username": emailValues.reverse[username],
        "emailid": emailValues.reverse[emailid],
        "email": emailValues.reverse[email],
        "center_status": centerStatus,
        "contactNo": contactNo,
        "name": createdByValues.reverse[name],
        "dob": dob?.toIso8601String(),
        "gender": genderValues.reverse[gender],
        "imageUrl": imageUrlValues.reverse[imageUrl],
        "userType": userTypeValues.reverse[userType],
        "title": titleValues.reverse[title],
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

enum Email {
    INFO_MYDIAREE_COM
}

final emailValues = EnumValues({
    "info@mydiaree.com": Email.INFO_MYDIAREE_COM
});

enum Gender {
    FEMALE
}

final genderValues = EnumValues({
    "FEMALE": Gender.FEMALE
});

enum ImageUrl {
    UPLOADS_OLDDATA_PROFILE_1741777755_JPG
}

final imageUrlValues = EnumValues({
    "uploads/olddata/profile_1741777755.jpg": ImageUrl.UPLOADS_OLDDATA_PROFILE_1741777755_JPG
});

enum Title {
    MISS
}

final titleValues = EnumValues({
    "Miss": Title.MISS
});

enum UserType {
    SUPERADMIN
}

final userTypeValues = EnumValues({
    "Superadmin": UserType.SUPERADMIN
});

enum Status {
    SENT
}

final statusValues = EnumValues({
    "Sent": Status.SENT
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
