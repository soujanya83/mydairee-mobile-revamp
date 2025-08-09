class ObservationDetailResponse {
  final bool status;
  final String message;
  final ObservationDetailData data;

  ObservationDetailResponse({
    required this.status,
    required this.message,
    required this.data,
  });

  factory ObservationDetailResponse.fromJson(Map<String, dynamic> json) {
    return ObservationDetailResponse(
      status: json['status'] ?? false,
      message: json['message'] ?? '',
      data: ObservationDetailData.fromJson(json['data'] ?? {}),
    );
  }
}

class ObservationDetailData {
  final int id;
  final int userId;
  final String? obestitle;
  final String? title;
  final String? notes;
  final dynamic room; // Can be null or string
  final String? reflection;
  final dynamic futurePlan; // Can be null or string
  final dynamic childVoice; // Can be null or string
  final String status;
  final int? approver;
  final int centerid;
  final String dateAdded;
  final String dateModified;
  final String createdAt;
  final String updatedAt;
  final List<MediaItem> media;
  final List<ChildObservation> child;
  final List<MontessoriLink> montessoriLinks;
  final List<EylfLink> eylfLinks;
  final List<DevMilestoneSub> devMilestoneSubs;

  ObservationDetailData({
    required this.id,
    required this.userId,
    this.obestitle,
    this.title,
    this.notes,
    this.room,
    this.reflection,
    this.futurePlan,
    this.childVoice,
    required this.status,
    this.approver,
    required this.centerid,
    required this.dateAdded,
    required this.dateModified,
    required this.createdAt,
    required this.updatedAt,
    required this.media,
    required this.child,
    required this.montessoriLinks,
    required this.eylfLinks,
    required this.devMilestoneSubs,
  });

  factory ObservationDetailData.fromJson(Map<String, dynamic> json) {
    return ObservationDetailData(
      id: json['id'] ?? 0,
      userId: json['userId'] ?? 0,
      obestitle: json['obestitle'],
      title: json['title'],
      notes: json['notes'],
      room: json['room'],
      reflection: json['reflection'],
      futurePlan: json['future_plan'],
      childVoice: json['child_voice'],
      status: json['status'] ?? '',
      approver: json['approver'],
      centerid: json['centerid'] ?? 0,
      dateAdded: json['date_added'] ?? '',
      dateModified: json['date_modified'] ?? '',
      createdAt: json['created_at'] ?? '',
      updatedAt: json['updated_at'] ?? '',
      media: (json['media'] as List?)?.map((e) => MediaItem.fromJson(e)).toList() ?? [],
      child: (json['child'] as List?)?.map((e) => ChildObservation.fromJson(e)).toList() ?? [],
      montessoriLinks: (json['montessori_links'] as List?)?.map((e) => MontessoriLink.fromJson(e)).toList() ?? [],
      eylfLinks: (json['eylf_links'] as List?)?.map((e) => EylfLink.fromJson(e)).toList() ?? [],
      devMilestoneSubs: (json['dev_milestone_subs'] as List?)?.map((e) => DevMilestoneSub.fromJson(e)).toList() ?? [],
    );
  }
  
  // Get clean HTML title
  String getCleanTitle() {
    return title?.replaceAll(RegExp(r'<[^>]*>'), '').trim() ?? '';
  }
  
  // Get clean HTML notes
  String getCleanNotes() {
    return notes?.replaceAll(RegExp(r'<[^>]*>'), '').trim() ?? '';
  }
}

class MediaItem {
  final int id;
  final int observationId;
  final String mediaUrl;
  final String mediaType;
  final String? caption;
  final int? priority;

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
  
  // Get the complete image URL
  String getFullImageUrl() {
    return mediaUrl.isNotEmpty 
        ? '$mediaUrl' 
        : '';
  }
}

class ChildObservation {
  final int id;
  final int observationId;
  final int childId;
  final String createdAt;
  final String updatedAt;
  final ChildData child;

  ChildObservation({
    required this.id,
    required this.observationId,
    required this.childId,
    required this.createdAt,
    required this.updatedAt,
    required this.child,
  });

  factory ChildObservation.fromJson(Map<String, dynamic> json) {
    return ChildObservation(
      id: json['id'] ?? 0,
      observationId: json['observationId'] ?? 0,
      childId: json['childId'] ?? 0,
      createdAt: json['created_at'] ?? '',
      updatedAt: json['updated_at'] ?? '',
      child: ChildData.fromJson(json['child'] ?? {}),
    );
  }
}

class ChildData {
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
  final int? createdBy;
  final String? createdAt;
  final String createdAtTimestamp;
  final String updatedAtTimestamp;

  ChildData({
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
    this.createdBy,
    this.createdAt,
    required this.createdAtTimestamp,
    required this.updatedAtTimestamp,
  });

  factory ChildData.fromJson(Map<String, dynamic> json) {
    return ChildData(
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
      createdBy: json['createdBy'],
      createdAt: json['createdAt'],
      createdAtTimestamp: json['created_at'] ?? '',
      updatedAtTimestamp: json['updated_at'] ?? '',
    );
  }
  
  // Get the complete image URL
  String getFullImageUrl() {
    if (imageUrl.isEmpty) return '';
    return 'https://mydiaree.com.au/$imageUrl';
  }
  
  // Get full name
  String getFullName() {
    return '$name ${lastname ?? ""}'.trim();
  }
}

class MontessoriLink {
  final int id;
  final int observationId;
  final int idSubActivity;
  final int idExtra;
  final String assessment;
  final SubActivity subActivity;

  MontessoriLink({
    required this.id,
    required this.observationId,
    required this.idSubActivity,
    required this.idExtra,
    required this.assessment,
    required this.subActivity,
  });

  factory MontessoriLink.fromJson(Map<String, dynamic> json) {
    return MontessoriLink(
      id: json['id'] ?? 0,
      observationId: json['observationId'] ?? 0,
      idSubActivity: json['idSubActivity'] ?? 0,
      idExtra: json['idExtra'] ?? 0,
      assessment: json['assesment'] ?? '', // Note: it's "assesment" in the API, not "assessment"
      subActivity: SubActivity.fromJson(json['sub_activity'] ?? {}),
    );
  }
}

class SubActivity {
  final int idSubActivity;
  final int idActivity;
  final String title;
  final String? subject;
  final String? imageUrl;
  final dynamic addedBy;
  final String? addedAt;
  final Activity activity;

  SubActivity({
    required this.idSubActivity,
    required this.idActivity,
    required this.title,
    this.subject,
    this.imageUrl,
    this.addedBy,
    this.addedAt,
    required this.activity,
  });

  factory SubActivity.fromJson(Map<String, dynamic> json) {
    return SubActivity(
      idSubActivity: json['idSubActivity'] ?? 0,
      idActivity: json['idActivity'] ?? 0,
      title: json['title'] ?? '',
      subject: json['subject'],
      imageUrl: json['imageUrl'],
      addedBy: json['added_by'],
      addedAt: json['added_at'],
      activity: Activity.fromJson(json['activity'] ?? {}),
    );
  }
}

class Activity {
  final int idActivity;
  final int idSubject;
  final String title;
  final dynamic addedBy;
  final String? addedAt;
  final Subject subject;

  Activity({
    required this.idActivity,
    required this.idSubject,
    required this.title,
    this.addedBy,
    this.addedAt,
    required this.subject,
  });

  factory Activity.fromJson(Map<String, dynamic> json) {
    return Activity(
      idActivity: json['idActivity'] ?? 0,
      idSubject: json['idSubject'] ?? 0,
      title: json['title'] ?? '',
      addedBy: json['added_by'],
      addedAt: json['added_at'],
      subject: Subject.fromJson(json['subject'] ?? {}),
    );
  }
}

class Subject {
  final int idSubject;
  final String name;

  Subject({
    required this.idSubject,
    required this.name,
  });

  factory Subject.fromJson(Map<String, dynamic> json) {
    return Subject(
      idSubject: json['idSubject'] ?? 0,
      name: json['name'] ?? '',
    );
  }
}

class EylfLink {
  final int id;
  final int observationId;
  final int eylfActivityId;
  final int eylfSubactivityId;
  final EylfSubActivity subActivity;

  EylfLink({
    required this.id,
    required this.observationId,
    required this.eylfActivityId,
    required this.eylfSubactivityId,
    required this.subActivity,
  });

  factory EylfLink.fromJson(Map<String, dynamic> json) {
    return EylfLink(
      id: json['id'] ?? 0,
      observationId: json['observationId'] ?? 0,
      eylfActivityId: json['eylfActivityId'] ?? 0,
      eylfSubactivityId: json['eylfSubactivityId'] ?? 0,
      subActivity: EylfSubActivity.fromJson(json['sub_activity'] ?? {}),
    );
  }
}

class EylfSubActivity {
  final int id;
  final int activityId;
  final String title;
  final String? imageUrl;
  final dynamic addedBy;
  final String? addedAt;
  final EylfActivity activity;

  EylfSubActivity({
    required this.id,
    required this.activityId,
    required this.title,
    this.imageUrl,
    this.addedBy,
    this.addedAt,
    required this.activity,
  });

  factory EylfSubActivity.fromJson(Map<String, dynamic> json) {
    return EylfSubActivity(
      id: json['id'] ?? 0,
      activityId: json['activityid'] ?? 0,
      title: json['title'] ?? '',
      imageUrl: json['imageUrl'],
      addedBy: json['added_by'],
      addedAt: json['added_at'],
      activity: EylfActivity.fromJson(json['activity'] ?? {}),
    );
  }
}

class EylfActivity {
  final int id;
  final int outcomeId;
  final String title;
  final dynamic addedBy;
  final String? addedAt;
  final EylfOutcome outcome;

  EylfActivity({
    required this.id,
    required this.outcomeId,
    required this.title,
    this.addedBy,
    this.addedAt,
    required this.outcome,
  });

  factory EylfActivity.fromJson(Map<String, dynamic> json) {
    return EylfActivity(
      id: json['id'] ?? 0,
      outcomeId: json['outcomeId'] ?? 0,
      title: json['title'] ?? '',
      addedBy: json['added_by'],
      addedAt: json['added_at'],
      outcome: EylfOutcome.fromJson(json['outcome'] ?? {}),
    );
  }
}

class EylfOutcome {
  final int id;
  final String title;
  final String name;
  final dynamic addedBy;
  final String? addedAt;

  EylfOutcome({
    required this.id,
    required this.title,
    required this.name,
    this.addedBy,
    this.addedAt,
  });

  factory EylfOutcome.fromJson(Map<String, dynamic> json) {
    return EylfOutcome(
      id: json['id'] ?? 0,
      title: json['title'] ?? '',
      name: json['name'] ?? '',
      addedBy: json['added_by'],
      addedAt: json['added_at'],
    );
  }
}

// New classes for dev_milestone_subs
class DevMilestoneSub {
  final int id;
  final int observationId;
  final int devMilestoneId;
  final int idExtra;
  final String assessment;
  final DevMilestone devMilestone;

  DevMilestoneSub({
    required this.id,
    required this.observationId,
    required this.devMilestoneId,
    required this.idExtra,
    required this.assessment,
    required this.devMilestone,
  });

  factory DevMilestoneSub.fromJson(Map<String, dynamic> json) {
    return DevMilestoneSub(
      id: json['id'] ?? 0,
      observationId: json['observationId'] ?? 0,
      devMilestoneId: json['devMilestoneId'] ?? 0,
      idExtra: json['idExtra'] ?? 0,
      assessment: json['assessment'] ?? '',
      devMilestone: DevMilestone.fromJson(json['dev_milestone'] ?? {}),
    );
  }
}

class DevMilestone {
  final int id;
  final int milestoneId;
  final String name;
  final String subject;
  final String imageUrl;
  final dynamic addedBy;
  final String? addedAt;
  final MilestoneMain main;
  final Milestone milestone;

  DevMilestone({
    required this.id,
    required this.milestoneId,
    required this.name,
    required this.subject,
    required this.imageUrl,
    this.addedBy,
    this.addedAt,
    required this.main,
    required this.milestone,
  });

  factory DevMilestone.fromJson(Map<String, dynamic> json) {
    return DevMilestone(
      id: json['id'] ?? 0,
      milestoneId: json['milestoneid'] ?? 0,
      name: json['name'] ?? '',
      subject: json['subject'] ?? '',
      imageUrl: json['imageUrl'] ?? '',
      addedBy: json['added_by'],
      addedAt: json['added_at'],
      main: MilestoneMain.fromJson(json['main'] ?? {}),
      milestone: Milestone.fromJson(json['milestone'] ?? {}),
    );
  }
}

class MilestoneMain {
  final int id;
  final int ageId;
  final String name;
  final dynamic addedBy;
  final String? addedAt;

  MilestoneMain({
    required this.id,
    required this.ageId,
    required this.name,
    this.addedBy,
    this.addedAt,
  });

  factory MilestoneMain.fromJson(Map<String, dynamic> json) {
    return MilestoneMain(
      id: json['id'] ?? 0,
      ageId: json['ageId'] ?? 0,
      name: json['name'] ?? '',
      addedBy: json['added_by'],
      addedAt: json['added_at'],
    );
  }
}

class Milestone {
  final int id;
  final String ageGroup;
  final int laravelThroughKey;

  Milestone({
    required this.id,
    required this.ageGroup,
    required this.laravelThroughKey,
  });

  factory Milestone.fromJson(Map<String, dynamic> json) {
    return Milestone(
      id: json['id'] ?? 0,
      ageGroup: json['ageGroup'] ?? '',
      laravelThroughKey: json['laravel_through_key'] ?? 0,
    );
  }
}