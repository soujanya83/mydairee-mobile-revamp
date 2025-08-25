import 'dart:convert';

ReflectionPrintResponse reflectionPrintResponseFromJson(String str) =>
    ReflectionPrintResponse.fromJson(json.decode(str) as Map<String, dynamic>?);

String reflectionPrintResponseToJson(ReflectionPrintResponse data) =>
    json.encode(data.toJson());

class ReflectionPrintResponse {
  final bool status;
  final String message;
  final ReflectionPrintData reflection;
  final String roomNames;
  final bool seen;

  ReflectionPrintResponse({
    required this.status,
    required this.message,
    required this.reflection,
    required this.roomNames,
    required this.seen,
  });

  factory ReflectionPrintResponse.fromJson(Map<String, dynamic>? json) {
    try {
      return ReflectionPrintResponse(
        status: json?['status'] ?? false,
        message: json?['message']?.toString() ?? '',
        reflection: ReflectionPrintData.fromJson(json?['reflection'] as Map<String, dynamic>? ?? {}),
        roomNames: json?['roomNames']?.toString() ?? '',
        seen: json?['seen'] ?? false,
      );
    } catch (_) {
      return ReflectionPrintResponse(
        status: false,
        message: '',
        reflection: ReflectionPrintData(),
        roomNames: '',
        seen: false,
      );
    }
  }

  Map<String, dynamic> toJson() => {
        "status": status,
        "message": message,
        "reflection": reflection.toJson(),
        "roomNames": roomNames,
        "seen": seen,
      };
}

class ReflectionPrintData {
  final int id;
  final String title;
  final String about;
  final int centerid;
  final String status;
  final String eylf;
  final String roomids;
  final int createdBy;
  final String createdAt;
  final String createdAtTimestamp;
  final String updatedAtTimestamp;
  final Creator creator;
  final Center center;
  final List<ReflectionChild> children;
  final List<ReflectionMedia> media;
  final List<ReflectionStaff> staff;

  ReflectionPrintData({
    this.id = 0,
    this.title = '',
    this.about = '',
    this.centerid = 0,
    this.status = '',
    this.eylf = '',
    this.roomids = '',
    this.createdBy = 0,
    this.createdAt = '',
    this.createdAtTimestamp = '',
    this.updatedAtTimestamp = '',
    Creator? creator,
    Center? center,
    List<ReflectionChild>? children,
    List<ReflectionMedia>? media,
    List<ReflectionStaff>? staff,
  })  : creator = creator ?? Creator(),
        center = center ?? Center(),
        children = children ?? [],
        media = media ?? [],
        staff = staff ?? [];

  factory ReflectionPrintData.fromJson(Map<String, dynamic>? json) {
    try {
      return ReflectionPrintData(
        id: int.tryParse(json?['id']?.toString() ?? '') ?? 0,
        title: json?['title']?.toString() ?? '',
        about: json?['about']?.toString() ?? '',
        centerid: int.tryParse(json?['centerid']?.toString() ?? '') ?? 0,
        status: json?['status']?.toString() ?? '',
        eylf: json?['eylf']?.toString() ?? '',
        roomids: json?['roomids']?.toString() ?? '',
        createdBy: int.tryParse(json?['createdBy']?.toString() ?? '') ?? 0,
        createdAt: json?['createdAt']?.toString() ?? '',
        createdAtTimestamp: json?['created_at']?.toString() ?? '',
        updatedAtTimestamp: json?['updated_at']?.toString() ?? '',
        creator: Creator.fromJson(json?['creator'] as Map<String, dynamic>? ?? {}),
        center: Center.fromJson(json?['center'] as Map<String, dynamic>? ?? {}),
        children: (json?['children'] as List?)?.map((e) => ReflectionChild.fromJson(e as Map<String, dynamic>)).toList() ?? [],
        media: (json?['media'] as List?)?.map((e) => ReflectionMedia.fromJson(e as Map<String, dynamic>)).toList() ?? [],
        staff: (json?['staff'] as List?)?.map((e) => ReflectionStaff.fromJson(e as Map<String, dynamic>)).toList() ?? [],
      );
    } catch (_) {
      return ReflectionPrintData();
    }
  }

  Map<String, dynamic> toJson() => {
        "id": id,
        "title": title,
        "about": about,
        "centerid": centerid,
        "status": status,
        "eylf": eylf,
        "roomids": roomids,
        "createdBy": createdBy,
        "createdAt": createdAt,
        "created_at": createdAtTimestamp,
        "updated_at": updatedAtTimestamp,
        "creator": creator.toJson(),
        "center": center.toJson(),
        "children": children.map((x) => x.toJson()).toList(),
        "media": media.map((x) => x.toJson()).toList(),
        "staff": staff.map((x) => x.toJson()).toList(),
      };
}

class Creator {
  final int id;
  final int userid;
  final String username;
  final String emailid;
  final String email;
  final String contactNo;
  final String name;
  final int centerStatus;
  final String dob;
  final String gender;
  final String imageUrl;
  final String userType;
  final String title;
  final String? status;
  final String authToken;
  final String deviceid;
  final String devicetype;
  final String? companyLogo;
  final int theme;
  final String imagePosition;
  final String? createdBy;
  final String? emailVerifiedAt;
  final int hasSeenLoginNotice;
  final String createdAt;
  final String updatedAt;

  Creator({
    this.id = 0,
    this.userid = 0,
    this.username = '',
    this.emailid = '',
    this.email = '',
    this.contactNo = '',
    this.name = '',
    this.centerStatus = 0,
    this.dob = '',
    this.gender = '',
    this.imageUrl = '',
    this.userType = '',
    this.title = '',
    this.status,
    this.authToken = '',
    this.deviceid = '',
    this.devicetype = '',
    this.companyLogo,
    this.theme = 0,
    this.imagePosition = '',
    this.createdBy,
    this.emailVerifiedAt,
    this.hasSeenLoginNotice = 0,
    this.createdAt = '',
    this.updatedAt = '',
  });

  factory Creator.fromJson(Map<String, dynamic>? json) {
    try {
      return Creator(
        id: int.tryParse(json?['id']?.toString() ?? '') ?? 0,
        userid: int.tryParse(json?['userid']?.toString() ?? '') ?? 0,
        username: json?['username']?.toString() ?? '',
        emailid: json?['emailid']?.toString() ?? '',
        email: json?['email']?.toString() ?? '',
        contactNo: json?['contactNo']?.toString() ?? '',
        name: json?['name']?.toString() ?? '',
        centerStatus: int.tryParse(json?['center_status']?.toString() ?? '') ?? 0,
        dob: json?['dob']?.toString() ?? '',
        gender: json?['gender']?.toString() ?? '',
        imageUrl: json?['imageUrl']?.toString() ?? '',
        userType: json?['userType']?.toString() ?? '',
        title: json?['title']?.toString() ?? '',
        status: json?['status']?.toString(),
        authToken: json?['AuthToken']?.toString() ?? '',
        deviceid: json?['deviceid']?.toString() ?? '',
        devicetype: json?['devicetype']?.toString() ?? '',
        companyLogo: json?['companyLogo']?.toString(),
        theme: int.tryParse(json?['theme']?.toString() ?? '') ?? 0,
        imagePosition: json?['image_position']?.toString() ?? '',
        createdBy: json?['created_by']?.toString(),
        emailVerifiedAt: json?['email_verified_at']?.toString(),
        hasSeenLoginNotice: int.tryParse(json?['has_seen_login_notice']?.toString() ?? '') ?? 0,
        createdAt: json?['created_at']?.toString() ?? '',
        updatedAt: json?['updated_at']?.toString() ?? '',
      );
    } catch (_) {
      return Creator();
    }
  }

  Map<String, dynamic> toJson() => {
        "id": id,
        "userid": userid,
        "username": username,
        "emailid": emailid,
        "email": email,
        "contactNo": contactNo,
        "name": name,
        "center_status": centerStatus,
        "dob": dob,
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
        "has_seen_login_notice": hasSeenLoginNotice,
        "created_at": createdAt,
        "updated_at": updatedAt,
      };
}

class Center {
  final int id;
  final String? userId;
  final String centerName;
  final String adressStreet;
  final String addressCity;
  final String addressState;
  final String addressZip;
  final String createdAt;
  final String updatedAt;

  Center({
    this.id = 0,
    this.userId,
    this.centerName = '',
    this.adressStreet = '',
    this.addressCity = '',
    this.addressState = '',
    this.addressZip = '',
    this.createdAt = '',
    this.updatedAt = '',
  });

  factory Center.fromJson(Map<String, dynamic>? json) {
    try {
      return Center(
        id: int.tryParse(json?['id']?.toString() ?? '') ?? 0,
        userId: json?['user_id']?.toString(),
        centerName: json?['centerName']?.toString() ?? '',
        adressStreet: json?['adressStreet']?.toString() ?? '',
        addressCity: json?['addressCity']?.toString() ?? '',
        addressState: json?['addressState']?.toString() ?? '',
        addressZip: json?['addressZip']?.toString() ?? '',
        createdAt: json?['created_at']?.toString() ?? '',
        updatedAt: json?['updated_at']?.toString() ?? '',
      );
    } catch (_) {
      return Center();
    }
  }

  Map<String, dynamic> toJson() => {
        "id": id,
        "user_id": userId,
        "centerName": centerName,
        "adressStreet": adressStreet,
        "addressCity": addressCity,
        "addressState": addressState,
        "addressZip": addressZip,
        "created_at": createdAt,
        "updated_at": updatedAt,
      };
}

class ReflectionChild {
  final int id;
  final int reflectionid;
  final int childid;
  final ChildDetails childDetails;

  ReflectionChild({
    this.id = 0,
    this.reflectionid = 0,
    this.childid = 0,
    ChildDetails? childDetails,
  }) : childDetails = childDetails ?? ChildDetails();

  factory ReflectionChild.fromJson(Map<String, dynamic>? json) {
    try {
      return ReflectionChild(
        id: int.tryParse(json?['id']?.toString() ?? '') ?? 0,
        reflectionid: int.tryParse(json?['reflectionid']?.toString() ?? '') ?? 0,
        childid: int.tryParse(json?['childid']?.toString() ?? '') ?? 0,
        childDetails: ChildDetails.fromJson(json?['child_details'] as Map<String, dynamic>? ?? {}),
      );
    } catch (_) {
      return ReflectionChild();
    }
  }

  Map<String, dynamic> toJson() => {
        "id": id,
        "reflectionid": reflectionid,
        "childid": childid,
        "child_details": childDetails.toJson(),
      };
}

class ChildDetails {
  final int id;
  final String name;
  final String lastname;
  final String imageUrl;

  ChildDetails({
    this.id = 0,
    this.name = '',
    this.lastname = '',
    this.imageUrl = '',
  });

  factory ChildDetails.fromJson(Map<String, dynamic>? json) {
    try {
      return ChildDetails(
        id: int.tryParse(json?['id']?.toString() ?? '') ?? 0,
        name: json?['name']?.toString() ?? '',
        lastname: json?['lastname']?.toString() ?? '',
        imageUrl: json?['imageUrl']?.toString() ?? '',
      );
    } catch (_) {
      return ChildDetails();
    }
  }

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "lastname": lastname,
        "imageUrl": imageUrl,
      };

  String getFullName() {
    return '$name $lastname'.trim();
  }
}

class ReflectionMedia {
  final int id;
  final int reflectionid;
  final String mediaUrl;
  final String mediaType;

  ReflectionMedia({
    this.id = 0,
    this.reflectionid = 0,
    this.mediaUrl = '',
    this.mediaType = '',
  });

  factory ReflectionMedia.fromJson(Map<String, dynamic>? json) {
    try {
      return ReflectionMedia(
        id: int.tryParse(json?['id']?.toString() ?? '') ?? 0,
        reflectionid: int.tryParse(json?['reflectionid']?.toString() ?? '') ?? 0,
        mediaUrl: json?['mediaUrl']?.toString() ?? '',
        mediaType: json?['mediaType']?.toString() ?? '',
      );
    } catch (_) {
      return ReflectionMedia();
    }
  }

  Map<String, dynamic> toJson() => {
        "id": id,
        "reflectionid": reflectionid,
        "mediaUrl": mediaUrl,
        "mediaType": mediaType,
      };

  String getFullMediaUrl() {
    return mediaUrl.isNotEmpty ? 'https://mydiaree.com.au/$mediaUrl' : '';
  }
}

class ReflectionStaff {
  final int id;
  final int reflectionid;
  final int staffid;
  final StaffDetails staffDetails;

  ReflectionStaff({
    this.id = 0,
    this.reflectionid = 0,
    this.staffid = 0,
    StaffDetails? staffDetails,
  }) : staffDetails = staffDetails ?? StaffDetails();

  factory ReflectionStaff.fromJson(Map<String, dynamic>? json) {
    try {
      return ReflectionStaff(
        id: int.tryParse(json?['id']?.toString() ?? '') ?? 0,
        reflectionid: int.tryParse(json?['reflectionid']?.toString() ?? '') ?? 0,
        staffid: int.tryParse(json?['staffid']?.toString() ?? '') ?? 0,
        staffDetails: StaffDetails.fromJson(json?['staff_details'] as Map<String, dynamic>? ?? {}),
      );
    } catch (_) {
      return ReflectionStaff();
    }
  }

  Map<String, dynamic> toJson() => {
        "id": id,
        "reflectionid": reflectionid,
        "staffid": staffid,
        "staff_details": staffDetails.toJson(),
      };
}

class StaffDetails {
  final int userid;
  final String name;
  final String imageUrl;

  StaffDetails({
    this.userid = 0,
    this.name = '',
    this.imageUrl = '',
  });

  factory StaffDetails.fromJson(Map<String, dynamic>? json) {
    try {
      return StaffDetails(
        userid: int.tryParse(json?['userid']?.toString() ?? '') ?? 0,
        name: json?['name']?.toString() ?? '',
        imageUrl: json?['imageUrl']?.toString() ?? '',
      );
    } catch (_) {
      return StaffDetails();
    }
  }

  Map<String, dynamic> toJson() => {
        "userid": userid,
        "name": name,
        "imageUrl": imageUrl,
      };
}
