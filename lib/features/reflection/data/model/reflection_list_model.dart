import 'dart:convert';

ReflectionListModel reflectionListModelFromJson(String str) =>
    ReflectionListModel.fromJson(json.decode(str));

String reflectionListModelToJson(ReflectionListModel data) =>
    json.encode(data.toJson());

class ReflectionListModel {
  bool? status;
  String? message;
  Data? data;

  ReflectionListModel({
    this.status,
    this.message,
    this.data,
  });

  factory ReflectionListModel.fromJson(Map<String, dynamic> json) =>
      ReflectionListModel(
        status: json["status"] as bool?,
        message: json["message"] as String?,
        data: json["data"] == null ? null : Data.fromJson(json["data"]),
      );

  Map<String, dynamic> toJson() => {
        "status": status,
        "message": message,
        "data": data?.toJson(),
      };
}

class Data {
  List<Center>? centers;
  List<Reflection>? reflection;

  Data({
    this.centers,
    this.reflection,
  });

  factory Data.fromJson(Map<String, dynamic> json) => Data(
        centers: json["centers"] == null
            ? []
            : List<Center>.from(json["centers"]!.map((x) => Center.fromJson(x))),
        reflection: json["reflection"] == null
            ? []
            : List<Reflection>.from(json["reflection"].map((x) => Reflection.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "centers": centers == null ? [] : List<dynamic>.from(centers!.map((x) => x.toJson())),
        "reflection": reflection == null ? [] : List<dynamic>.from(reflection!.map((x) => x.toJson())),
      };
}

class Center {
  int? id;
  dynamic userId;
  CenterName? centerName;
  AdressStreet? adressStreet;
  AddressCity? addressCity;
  AddressState? addressState;
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
        id: json["id"] as int?,
        userId: json["user_id"],
        centerName: json["centerName"] == null ? null : centerNameValues.map[json["centerName"]],
        adressStreet: json["adressStreet"] == null ? null : adressStreetValues.map[json["adressStreet"]],
        addressCity: json["addressCity"] == null ? null : addressCityValues.map[json["addressCity"]],
        addressState: json["addressState"] == null ? null : addressStateValues.map[json["addressState"]],
        addressZip: json["addressZip"] as String?,
        createdAt: json["created_at"] == null ? null : DateTime.tryParse(json["created_at"].toString()),
        updatedAt: json["updated_at"] == null ? null : DateTime.tryParse(json["updated_at"].toString()),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "user_id": userId,
        "centerName": centerNameValues.reverse[centerName],
        "adressStreet": adressStreetValues.reverse[adressStreet],
        "addressCity": addressCityValues.reverse[addressCity],
        "addressState": addressStateValues.reverse[addressState],
        "addressZip": addressZip,
        "created_at": createdAt?.toIso8601String(),
        "updated_at": updatedAt?.toIso8601String(),
      };
}

enum AddressCity { BRISBANE, CARRAMAR, MELBOURNE }

final addressCityValues = EnumValues({
  "Brisbane": AddressCity.BRISBANE,
  "Carramar": AddressCity.CARRAMAR,
  "Melbourne": AddressCity.MELBOURNE,
});

enum AddressState { NSW, QUEENSLAND, QUEENSLAND2 }

final addressStateValues = EnumValues({
  "NSW": AddressState.NSW,
  "Queensland": AddressState.QUEENSLAND,
  "Queensland2": AddressState.QUEENSLAND2,
});

enum AdressStreet {
  BLOCK_1_NEAR_X_JUNCTION_AUSTRALIA,
  THE_126_THE_HORSLEY_DR,
  THE_5_BOUNDARY_ST_BRISBANE,
}

final adressStreetValues = EnumValues({
  "Block 1, Near X Junction, Australia": AdressStreet.BLOCK_1_NEAR_X_JUNCTION_AUSTRALIA,
  "126 The Horsley Dr": AdressStreet.THE_126_THE_HORSLEY_DR,
  "5 Boundary St, Brisbane": AdressStreet.THE_5_BOUNDARY_ST_BRISBANE,
});

enum CenterName { BRISBANE_CENTER, CARRAMAR_CENTER, MELBOURNE_CENTER }

final centerNameValues = EnumValues({
  "Brisbane Center": CenterName.BRISBANE_CENTER,
  "Carramar Center": CenterName.CARRAMAR_CENTER,
  "Melbourne Center": CenterName.MELBOURNE_CENTER,
});

class Reflection {
  int? id;
  String? title;
  String? about;
  int? centerid;
  ReflectionStatus? status;
  String? eylf;
  String? roomids;
  int? createdBy;
  DateTime? createdAt;
  DateTime? reflectionCreatedAt;
  dynamic updatedAt;
  Creator? creator;
  Center? center;
  List<ChildElement>? children;
  List<Media>? media;
  List<Staff>? staff;
  List<Seen>? seen;

  Reflection({
    this.id,
    this.title,
    this.about,
    this.centerid,
    this.status,
    this.eylf,
    this.roomids,
    this.createdBy,
    this.createdAt,
    this.reflectionCreatedAt,
    this.updatedAt,
    this.creator,
    this.center,
    this.children,
    this.media,
    this.staff,
    this.seen,
  });

  factory Reflection.fromJson(Map<String, dynamic> json) => Reflection(
        id: json["id"] as int?,
        title: json["title"] as String?,
        about: json["about"] as String?,
        centerid: json["centerid"] as int?,
        status: json["status"] == null ? null : reflectionStatusValues.map[json["status"]],
        eylf: json["eylf"] as String?,
        roomids: json["roomids"] as String?,
        createdBy: json["createdBy"] as int?,
        createdAt: json["createdAt"] == null ? null : DateTime.tryParse(json["createdAt"].toString()),
        reflectionCreatedAt: json["created_at"] == null ? null : DateTime.tryParse(json["created_at"].toString()),
        updatedAt: json["updated_at"],
        creator: json["creator"] == null ? null : Creator.fromJson(json["creator"]),
        center: json["center"] == null ? null : Center.fromJson(json["center"]),
        children: json["children"] == null
            ? []
            : List<ChildElement>.from(json["children"].map((x) => ChildElement.fromJson(x))),
        media: json["media"] == null
            ? []
            : List<Media>.from(json["media"].map((x) => Media.fromJson(x))),
        staff: json["staff"] == null
            ? []
            : List<Staff>.from(json["staff"].map((x) => Staff.fromJson(x))),
        seen: json["seen"] == null
            ? []
            : List<Seen>.from(json["seen"].map((x) => Seen.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "title": title,
        "about": about,
        "centerid": centerid,
        "status": reflectionStatusValues.reverse[status],
        "eylf": eylf,
        "roomids": roomids,
        "createdBy": createdBy,
        "createdAt": createdAt?.toIso8601String(),
        "created_at": reflectionCreatedAt?.toIso8601String(),
        "updated_at": updatedAt,
        "creator": creator?.toJson(),
        "center": center?.toJson(),
        "children": children == null ? [] : List<dynamic>.from(children!.map((x) => x.toJson())),
        "media": media == null ? [] : List<dynamic>.from(media!.map((x) => x.toJson())),
        "staff": staff == null ? [] : List<dynamic>.from(staff!.map((x) => x.toJson())),
        "seen": seen == null ? [] : List<dynamic>.from(seen!.map((x) => x.toJson())),
      };
}

class ChildElement {
  int? id;
  int? reflectionid;
  int? childid;
  ChildChild? child;

  ChildElement({
    this.id,
    this.reflectionid,
    this.childid,
    this.child,
  });

  factory ChildElement.fromJson(Map<String, dynamic> json) => ChildElement(
        id: json["id"] as int?,
        reflectionid: json["reflectionid"] as int?,
        childid: json["childid"] as int?,
        child: json["child"] == null ? null : ChildChild.fromJson(json["child"]),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "reflectionid": reflectionid,
        "childid": childid,
        "child": child?.toJson(),
      };
}

class ChildChild {
  int? id;
  String? name;
  String? lastname;
  String? dob;
  String? startDate;
  int? room;
  String? imageUrl;
  ChildGender? gender;
  ChildStatus? status;
  String? daysAttending;
  int? createdBy;
  DateTime? createdAt;
  int? centerid;
  DateTime? childCreatedAt;
  dynamic updatedAt;

  ChildChild({
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

  factory ChildChild.fromJson(Map<String, dynamic> json) => ChildChild(
        id: json["id"] as int?,
        name: json["name"] as String?,
        lastname: json["lastname"] as String?,
        dob: json["dob"] as String?,
        startDate: json["startDate"] as String?,
        room: json["room"] as int?,
        imageUrl: json["imageUrl"] as String?,
        gender: json["gender"] == null ? null : childGenderValues.map[json["gender"]],
        status: json["status"] == null ? null : childStatusValues.map[json["status"]],
        daysAttending: json["daysAttending"] as String?,
        createdBy: json["createdBy"] as int?,
        createdAt: json["createdAt"] == null ? null : DateTime.tryParse(json["createdAt"].toString()),
        centerid: json["centerid"] as int?,
        childCreatedAt: json["created_at"] == null ? null : DateTime.tryParse(json["created_at"].toString()),
        updatedAt: json["updated_at"],
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
        "status": childStatusValues.reverse[status],
        "daysAttending": daysAttending,
        "createdBy": createdBy,
        "createdAt": createdAt?.toIso8601String(),
        "centerid": centerid,
        "created_at": childCreatedAt?.toIso8601String(),
        "updated_at": updatedAt,
      };
}

enum ChildGender { FEMALE, MALE }

final childGenderValues = EnumValues({
  "Female": ChildGender.FEMALE,
  "Male": ChildGender.MALE,
});

enum ChildStatus { ACTIVE }

final childStatusValues = EnumValues({
  "Active": ChildStatus.ACTIVE,
});
class Creator {
  int? id;
  int? userid;
  String? username;
  String? emailid;
  String? email;
  int? centerStatus;
  String? contactNo;
  String? name;
  DateTime? dob;
  CreatorGender? gender;
  String? imageUrl;
  String? userType;
  String? title;
  String? status;
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
        id: json["id"] as int?,
        userid: json["userid"] as int?,
        username: json["username"] as String?,
        emailid: json["emailid"] as String?,
        email: json["email"] as String?,
        centerStatus: json["center_status"] as int?,
        contactNo: json["contactNo"] as String?,
        name: json["name"] as String?,
        dob: json["dob"] == null ? null : DateTime.tryParse(json["dob"].toString()),
        gender: json["gender"] == null ? null : creatorGenderValues.map[json["gender"]],
        imageUrl: json["imageUrl"] as String?,
        userType: json["userType"] as String?,
        title: json["title"] as String?,
        status: json["status"] as String?,
        authToken: json["AuthToken"] as String?,
        deviceid: json["deviceid"] as String?,
        devicetype: json["devicetype"] as String?,
        companyLogo: json["companyLogo"],
        theme: json["theme"] as int?,
        imagePosition: json["image_position"] as String?,
        createdBy: json["created_by"],
        emailVerifiedAt: json["email_verified_at"],
        createdAt: json["created_at"] == null ? null : DateTime.tryParse(json["created_at"].toString()),
        updatedAt: json["updated_at"] == null ? null : DateTime.tryParse(json["updated_at"].toString()),
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
        "gender": creatorGenderValues.reverse[gender],
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

enum Email {
  AMAN_GMAIL_COM,
  AYESHA_AKTER0_GMAIL_COM,
  INFO_MYDIAREE_COM,
  ISHITARAY0389_GMAIL_COM,
  JACOBMARSHA_MYDAIREE_COM,
  KAILASHSAHU_GMAIL_COM,
  RAJATJAIN5498_GMAIL_COM,
  SAGARSUTAAR_GMAIL_COM,
  SAGAR_TODQUEST_COM,
  UDAY_MYKRONICLE_COM,
}

final emailValues = EnumValues({
  "aman@gmail.com": Email.AMAN_GMAIL_COM,
  "ayesha.akter0@gmail.com": Email.AYESHA_AKTER0_GMAIL_COM,
  "info@mydiaree.com": Email.INFO_MYDIAREE_COM,
  "ishitaray0389@gmail.com": Email.ISHITARAY0389_GMAIL_COM,
  "jacobmarsha@mydairee.com": Email.JACOBMARSHA_MYDAIREE_COM,
  "kailashsahu@gmail.com": Email.KAILASHSAHU_GMAIL_COM,
  "rajatjain5498@gmail.com": Email.RAJATJAIN5498_GMAIL_COM,
  "sagarsutaar@gmail.com": Email.SAGARSUTAAR_GMAIL_COM,
  "sagar@todquest.com": Email.SAGAR_TODQUEST_COM,
  "uday@mykronicle.com": Email.UDAY_MYKRONICLE_COM,
});

enum CreatorGender { FEMALE, MALE }

final creatorGenderValues = EnumValues({
  "FEMALE": CreatorGender.FEMALE,
  "MALE": CreatorGender.MALE,
});

class Media {
  int? id;
  int? reflectionid;
  String? mediaUrl;
  MediaType? mediaType;

  Media({
    this.id,
    this.reflectionid,
    this.mediaUrl,
    this.mediaType,
  });

  factory Media.fromJson(Map<String, dynamic> json) => Media(
        id: json["id"] as int?,
        reflectionid: json["reflectionid"] as int?,
        mediaUrl: json["mediaUrl"] as String?,
        mediaType: json["mediaType"] == null ? null : mediaTypeValues.map[json["mediaType"]],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "reflectionid": reflectionid,
        "mediaUrl": mediaUrl,
        "mediaType": mediaTypeValues.reverse[mediaType],
      };
}

enum MediaType { IMAGE }

final mediaTypeValues = EnumValues({
  "Image": MediaType.IMAGE,
});

class Seen {
  int? id;
  int? userId;
  int? reflectionId;
  DateTime? createdAt;
  DateTime? updatedAt;
  Creator? user;

  Seen({
    this.id,
    this.userId,
    this.reflectionId,
    this.createdAt,
    this.updatedAt,
    this.user,
  });

  factory Seen.fromJson(Map<String, dynamic> json) => Seen(
        id: json["id"] as int?,
        userId: json["user_id"] as int?,
        reflectionId: json["reflection_id"] as int?,
        createdAt: json["created_at"] == null ? null : DateTime.tryParse(json["created_at"].toString()),
        updatedAt: json["updated_at"] == null ? null : DateTime.tryParse(json["updated_at"].toString()),
        user: json["user"] == null ? null : Creator.fromJson(json["user"]),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "user_id": userId,
        "reflection_id": reflectionId,
        "created_at": createdAt?.toIso8601String(),
        "updated_at": updatedAt?.toIso8601String(),
        "user": user?.toJson(),
      };
}

class Staff {
  int? id;
  int? reflectionid;
  int? staffid;
  Creator? staff;

  Staff({
    this.id,
    this.reflectionid,
    this.staffid,
    this.staff,
  });

  factory Staff.fromJson(Map<String, dynamic> json) => Staff(
        id: json["id"] as int?,
        reflectionid: json["reflectionid"] as int?,
        staffid: json["staffid"] as int?,
        staff: json["staff"] == null ? null : Creator.fromJson(json["staff"]),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "reflectionid": reflectionid,
        "staffid": staffid,
        "staff": staff?.toJson(),
      };
}

enum ReflectionStatus { DRAFT, PUBLISHED }

final reflectionStatusValues = EnumValues({
  "DRAFT": ReflectionStatus.DRAFT,
  "PUBLISHED": ReflectionStatus.PUBLISHED,
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