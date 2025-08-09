
class ObservationApiResponse {
  final bool success;
  final List<ObservationItem> observations;
  final List<CenterModel> centers;

  ObservationApiResponse({
    required this.success,
    required this.observations,
    required this.centers,
  });

  factory ObservationApiResponse.fromJson(Map<String, dynamic> json) {
    return ObservationApiResponse(
      success: json['success'] ?? false,
      observations: (json['observations'] as List?)
          ?.map((obsJson) => ObservationItem.fromJson(obsJson))
          .toList() ?? [],
      centers: (json['centers'] as List?)
          ?.map((centerJson) => CenterModel.fromJson(centerJson))
          .toList() ?? [],
    );
  }
}

class ObservationItem {
  final int id;
  final int userId;
  final String? obestitle;
  final String? title;
  final String? notes;
  final String? room;
  final String? reflection;
  final String? future_plan;
  final String? child_voice;
  final String status;
  final int? approver;
  final int centerid;
  final String date_added;
  final String date_modified;
  final String created_at;
  final String updated_at;
  final UserModel? user;
  final List<ChildObservation> child;
  final List<MediaItem> media;
  final List<dynamic> seen;

  ObservationItem({
    required this.id,
    required this.userId,
    this.obestitle,
    this.title,
    this.notes,
    this.room,
    this.reflection,
    this.future_plan,
    this.child_voice,
    required this.status,
    this.approver,
    required this.centerid,
    required this.date_added,
    required this.date_modified,
    required this.created_at,
    required this.updated_at,
    this.user,
    required this.child,
    required this.media,
    required this.seen,
  });

  factory ObservationItem.fromJson(Map<String, dynamic> json) {
    return ObservationItem(
      id: json['id'] ?? 0,
      userId: json['userId'] ?? 0,
      obestitle: json['obestitle'],
      title: json['title'],
      notes: json['notes'],
      room: json['room'],
      reflection: json['reflection'],
      future_plan: json['future_plan'],
      child_voice: json['child_voice'],
      status: json['status'] ?? '',
      approver: json['approver'],
      centerid: json['centerid'] ?? 0,
      date_added: json['date_added'] ?? '',
      date_modified: json['date_modified'] ?? '',
      created_at: json['created_at'] ?? '',
      updated_at: json['updated_at'] ?? '',
      user: json['user'] != null ? UserModel.fromJson(json['user']) : null,
      child: (json['child'] as List?)
          ?.map((childJson) => ChildObservation.fromJson(childJson))
          .toList() ?? [],
      media: (json['media'] as List?)
          ?.map((mediaJson) => MediaItem.fromJson(mediaJson))
          .toList() ?? [],
      seen: json['seen'] as List? ?? [],
    );
  }
}

class UserModel {
  final int id;
  final int userid;
  final String username;
  final String emailid;
  final String email;
  final int center_status;
  final String contactNo;
  final String name;
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
  final String image_position;
  final dynamic created_by;
  final dynamic email_verified_at;
  final String created_at;
  final String updated_at;

  UserModel({
    required this.id,
    required this.userid,
    required this.username,
    required this.emailid,
    required this.email,
    required this.center_status,
    required this.contactNo,
    required this.name,
    required this.dob,
    required this.gender,
    required this.imageUrl,
    required this.userType,
    required this.title,
    this.status,
    required this.authToken,
    required this.deviceid,
    required this.devicetype,
    this.companyLogo,
    required this.theme,
    required this.image_position,
    this.created_by,
    this.email_verified_at,
    required this.created_at,
    required this.updated_at,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id'] ?? 0,
      userid: json['userid'] ?? 0,
      username: json['username'] ?? '',
      emailid: json['emailid'] ?? '',
      email: json['email'] ?? '',
      center_status: json['center_status'] ?? 0,
      contactNo: json['contactNo'] ?? '',
      name: json['name'] ?? '',
      dob: json['dob'] ?? '',
      gender: json['gender'] ?? '',
      imageUrl: json['imageUrl'] ?? '',
      userType: json['userType'] ?? '',
      title: json['title'] ?? '',
      status: json['status'],
      authToken: json['AuthToken'] ?? '',
      deviceid: json['deviceid'] ?? '',
      devicetype: json['devicetype'] ?? '',
      companyLogo: json['companyLogo'],
      theme: json['theme'] ?? 0,
      image_position: json['image_position'] ?? '',
      created_by: json['created_by'],
      email_verified_at: json['email_verified_at'],
      created_at: json['created_at'] ?? '',
      updated_at: json['updated_at'] ?? '',
    );
  }
}

class ChildObservation {
  final int id;
  final int observationId;
  final int childId;
  final String created_at;
  final String updated_at;

  ChildObservation({
    required this.id,
    required this.observationId,
    required this.childId,
    required this.created_at,
    required this.updated_at,
  });

  factory ChildObservation.fromJson(Map<String, dynamic> json) {
    return ChildObservation(
      id: json['id'] ?? 0,
      observationId: json['observationId'] ?? 0,
      childId: json['childId'] ?? 0,
      created_at: json['created_at'] ?? '',
      updated_at: json['updated_at'] ?? '',
    );
  }
}

class MediaItem {
  final int id;
  final int observationId;
  final String mediaUrl;
  final String mediaType;
  final String? caption;
  final dynamic priority;

  MediaItem({
    required this.id,
    required this.observationId,
    required this.mediaUrl,
    required this.mediaType,
    this.caption,
    this.priority,
  });

  factory MediaItem.fromJson(Map<String, dynamic> json) {
    return MediaItem(
      id: json['id'] ?? 0,
      observationId: json['observationId'] ?? 0,
      mediaUrl: json['mediaUrl'] ?? '',
      mediaType: json['mediaType'] ?? '',
      caption: json['caption'],
      priority: json['priority'],
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