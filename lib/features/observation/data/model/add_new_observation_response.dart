class AddNewObservationResponse {
  final bool status;
  final String message;
  final AddNewObservationData data;

  AddNewObservationResponse({
    required this.status, 
    required this.message, 
    required this.data
  });

  factory AddNewObservationResponse.fromJson(Map<String, dynamic> json) {
    return AddNewObservationResponse(
      status: json['status'] ?? false,
      message: json['message'] ?? '',
      data: AddNewObservationData.fromJson(json['data'] ?? {}),
    );
  }
}

class AddNewObservationData {
  final List<Center> centers;
  final Observation observation;
  final List<Child> children;
  final List<Room> rooms;
  final String activeTab;
  final String activesubTab;
  final List<Subject> subjects;
  final List<Outcome> outcomes;
  final List<MilestoneAgeGroup> milestones;

  AddNewObservationData({
    required this.centers,
    required this.observation,
    required this.children,
    required this.rooms,
    required this.activeTab,
    required this.activesubTab,
    required this.subjects,
    required this.outcomes,
    required this.milestones,
  });

  factory AddNewObservationData.fromJson(Map<String, dynamic> json) {
    return AddNewObservationData(
      centers: (json['centers'] as List?)?.map((e) => Center.fromJson(e)).toList() ?? [],
      observation: Observation.fromJson(json['observation'] ?? {}),
      children: (json['childrens'] as List?)?.map((e) => Child.fromJson(e)).toList() ?? [],
      rooms: (json['rooms'] as List?)?.map((e) => Room.fromJson(e)).toList() ?? [],
      activeTab: json['activeTab'] ?? '',
      activesubTab: json['activesubTab'] ?? '',
      subjects: (json['subjects'] as List?)?.map((e) => Subject.fromJson(e)).toList() ?? [],
      outcomes: (json['outcomes'] as List?)?.map((e) => Outcome.fromJson(e)).toList() ?? [],
      milestones: (json['milestones'] as List?)?.map((e) => MilestoneAgeGroup.fromJson(e)).toList() ?? [],
    );
  }
}

class Center {
  final int id;
  final String centerName;
  final String adressStreet;
  final String addressCity;
  final String addressState;
  final String addressZip;
  final String createdAt;
  final String updatedAt;

  Center({
    required this.id,
    required this.centerName,
    required this.adressStreet,
    required this.addressCity,
    required this.addressState,
    required this.addressZip,
    required this.createdAt,
    required this.updatedAt,
  });

  factory Center.fromJson(Map<String, dynamic> json) {
    return Center(
      id: json['id'] ?? 0,
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

class Observation {
  final int id;
  final int userId;
  final String obestitle;
  final String title;
  final String notes;
  final String room;
  final String reflection;
  final String futurePlan;
  final String childVoice;
  final String status;
  final int? approver;
  final int centerId;
  final String dateAdded;
  final String? dateModified;
  final String createdAt;
  final String updatedAt;
  final List<Media> media;
  final List<ChildObservation> child;
  final List<MontessoriLink> montessoriLinks;
  final List<EylfLink> eylfLinks;
  final List<DevMilestoneSub> devMilestoneSubs;
  final List<Link> links;

  Observation({
    required this.id,
    required this.userId,
    required this.obestitle,
    required this.title,
    required this.notes,
    required this.room,
    required this.reflection,
    required this.futurePlan,
    required this.childVoice,
    required this.status,
    this.approver,
    required this.centerId,
    required this.dateAdded,
    this.dateModified,
    required this.createdAt,
    required this.updatedAt,
    required this.media,
    required this.child,
    required this.montessoriLinks,
    required this.eylfLinks,
    required this.devMilestoneSubs,
    required this.links,
  });

  factory Observation.fromJson(Map<String, dynamic> json) {
    return Observation(
      id: json['id'] ?? 0,
      userId: json['userId'] ?? 0,
      obestitle: json['obestitle'] ?? '',
      title: json['title'] ?? '',
      notes: json['notes'] ?? '',
      room: json['room'] ?? '',
      reflection: json['reflection'] ?? '',
      futurePlan: json['future_plan'] ?? '',
      childVoice: json['child_voice'] ?? '',
      status: json['status'] ?? '',
      approver: json['approver'],
      centerId: json['centerid'] ?? 0,
      dateAdded: json['date_added'] ?? '',
      dateModified: json['date_modified'],
      createdAt: json['created_at'] ?? '',
      updatedAt: json['updated_at'] ?? '',
      media: (json['media'] as List?)
              ?.where((e) => e is Map<String, dynamic>)
              .map((e) => Media.fromJson(e as Map<String, dynamic>))
              .toList() ?? [],
      child: (json['child'] as List?)?.map((e) => ChildObservation.fromJson(e)).toList() ?? [],
      montessoriLinks: (json['montessori_links'] as List?)?.map((e) => MontessoriLink.fromJson(e)).toList() ?? [],
      eylfLinks: (json['eylf_links'] as List?)?.map((e) => EylfLink.fromJson(e)).toList() ?? [],
      devMilestoneSubs: (json['dev_milestone_subs'] as List?)?.map((e) => DevMilestoneSub.fromJson(e)).toList() ?? [],
      links: (json['links'] as List?)?.map((e) => Link.fromJson(e)).toList() ?? [],
    );
  }
}

// Other model classes for nested data
class Media {
  final int id;
  final int observationId;
  final String mediaUrl;
  final String mediaType;
  final String? caption;
  final String? priority;

  Media({
    required this.id,
    required this.observationId,
    required this.mediaUrl,
    required this.mediaType,
    this.caption,
    this.priority,
  });

  factory Media.fromJson(Map<String, dynamic> json) {
    return Media(
      id: json['id'] ?? 0,
      observationId: json['observationId'] ?? 0,
      mediaUrl: json['mediaUrl'] ?? '',
      mediaType: json['mediaType'] ?? '',
      caption: json['caption'],
      priority: json['priority'].toString(),
    );
  }
}

class ChildObservation {
  final int id;
  final int observationId;
  final int childId;
  final String createdAt;
  final String updatedAt;
  final Child child;

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
      child: Child.fromJson(json['child'] ?? {}),
    );
  }
}

class Child {
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
  final String updatedAt;

  Child({
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
    required this.updatedAt,
  });

  factory Child.fromJson(Map<String, dynamic> json) {
    return Child(
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
      createdAt: json['created_at'] ?? '',
      updatedAt: json['updated_at'] ?? '',
    );
  }
}

// Add all the other model classes (MontessoriLink, EylfLink, etc.)
class MontessoriLink {
  final int id;
  final int observationId;
  final int idSubActivity;
  final int idExtra;
  final String assesment;

  MontessoriLink({
    required this.id,
    required this.observationId,
    required this.idSubActivity,
    required this.idExtra,
    required this.assesment,
  });

  factory MontessoriLink.fromJson(Map<String, dynamic> json) {
    return MontessoriLink(
      id: json['id'] ?? 0,
      observationId: json['observationId'] ?? 0,
      idSubActivity: json['idSubActivity'] ?? 0,
      idExtra: json['idExtra'] ?? 0,
      assesment: json['assesment'] ?? '',
    );
  }
}

class EylfLink {
  final int id;
  final int observationId;
  final int eylfActivityId;
  final int eylfSubactivityId;

  EylfLink({
    required this.id,
    required this.observationId,
    required this.eylfActivityId,
    required this.eylfSubactivityId,
  });

  factory EylfLink.fromJson(Map<String, dynamic> json) {
    return EylfLink(
      id: json['id'] ?? 0,
      observationId: json['observationId'] ?? 0,
      eylfActivityId: json['eylfActivityId'] ?? 0,
      eylfSubactivityId: json['eylfSubactivityId'] ?? 0,
    );
  }
}

class DevMilestoneSub {
  final int id;
  final int observationId;
  final int devMilestoneId;
  final int idExtra;
  final String assessment;

  DevMilestoneSub({
    required this.id,
    required this.observationId,
    required this.devMilestoneId,
    required this.idExtra,
    required this.assessment,
  });

  factory DevMilestoneSub.fromJson(Map<String, dynamic> json) {
    return DevMilestoneSub(
      id: json['id'] ?? 0,
      observationId: json['observationId'] ?? 0,
      devMilestoneId: json['devMilestoneId'] ?? 0,
      idExtra: json['idExtra'] ?? 0,
      assessment: json['assessment'] ?? '',
    );
  }
}

class Link {
  final int id;
  final int observationId;
  final int linkid;
  final String linktype;

  Link({
    required this.id,
    required this.observationId,
    required this.linkid,
    required this.linktype,
  });

  factory Link.fromJson(Map<String, dynamic> json) {
    return Link(
      id: json['id'] ?? 0,
      observationId: json['observationId'] ?? 0,
      linkid: json['linkid'] ?? 0,
      linktype: json['linktype'] ?? '',
    );
  }
}

class Room {
  final int id;
  final String name;
  final int capacity;
  final int userId;
  final String color;
  final int ageFrom;
  final int ageTo;
  final String status;
  final int centerId;
  final int? createdBy;

  Room({
    required this.id,
    required this.name,
    required this.capacity,
    required this.userId,
    required this.color,
    required this.ageFrom,
    required this.ageTo,
    required this.status,
    required this.centerId,
    this.createdBy,
  });

  factory Room.fromJson(Map<String, dynamic> json) {
    return Room(
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

// Subject and activities models
class Subject {
  final int idSubject;
  final String name;
  final List<Activity> activities;

  Subject({
    required this.idSubject,
    required this.name,
    required this.activities,
  });

  factory Subject.fromJson(Map<String, dynamic> json) {
    return Subject(
      idSubject: json['idSubject'] ?? 0,
      name: json['name'] ?? '',
      activities: (json['activities'] as List?)?.map((e) => Activity.fromJson(e)).toList() ?? [],
    );
  }
}

class Activity {
  final int idActivity;
  final int idSubject;
  final String title;
  final dynamic addedBy;
  final String addedAt;
  final List<SubActivity> subActivities;

  Activity({
    required this.idActivity,
    required this.idSubject,
    required this.title,
    required this.addedBy,
    required this.addedAt,
    required this.subActivities,
  });

  factory Activity.fromJson(Map<String, dynamic> json) {
    return Activity(
      idActivity: json['idActivity'] ?? 0,
      idSubject: json['idSubject'] ?? 0,
      title: json['title'] ?? '',
      addedBy: json['added_by'],
      addedAt: json['added_at'] ?? '',
      subActivities: (json['sub_activities'] as List?)?.map((e) => SubActivity.fromJson(e)).toList() ?? [],
    );
  }
}

class SubActivity {
  final int idSubActivity;
  final int idActivity;
  final String title;
  final String subject;
  final String imageUrl;
  final dynamic addedBy;
  final String addedAt;

  SubActivity({
    required this.idSubActivity,
    required this.idActivity,
    required this.title,
    required this.subject,
    required this.imageUrl,
    required this.addedBy,
    required this.addedAt,
  });

  factory SubActivity.fromJson(Map<String, dynamic> json) {
    return SubActivity(
      idSubActivity: json['idSubActivity'] ?? 0,
      idActivity: json['idActivity'] ?? 0,
      title: json['title'] ?? '',
      subject: json['subject'] ?? '',
      imageUrl: json['imageUrl'] ?? '',
      addedBy: json['added_by'],
      addedAt: json['added_at'] ?? '',
    );
  }
}

// EYLF outcome models
class Outcome {
  final int id;
  final String title;
  final String name;
  final dynamic addedBy;
  final String addedAt;
  final List<OutcomeActivity> activities;

  Outcome({
    required this.id,
    required this.title,
    required this.name,
    required this.addedBy,
    required this.addedAt,
    required this.activities,
  });

  factory Outcome.fromJson(Map<String, dynamic> json) {
    return Outcome(
      id: json['id'] ?? 0,
      title: json['title'] ?? '',
      name: json['name'] ?? '',
      addedBy: json['added_by'],
      addedAt: json['added_at'] ?? '',
      activities: (json['activities'] as List?)?.map((e) => OutcomeActivity.fromJson(e)).toList() ?? [],
    );
  }
}

class OutcomeActivity {
  final int id;
  final int outcomeId;
  final String title;
  final dynamic addedBy;
  final String addedAt;
  final List<OutcomeSubActivity> subActivities;

  OutcomeActivity({
    required this.id,
    required this.outcomeId,
    required this.title,
    required this.addedBy,
    required this.addedAt,
    required this.subActivities,
  });

  factory OutcomeActivity.fromJson(Map<String, dynamic> json) {
    return OutcomeActivity(
      id: json['id'] ?? 0,
      outcomeId: json['outcomeId'] ?? 0,
      title: json['title'] ?? '',
      addedBy: json['added_by'],
      addedAt: json['added_at'] ?? '',
      subActivities: (json['sub_activities'] as List?)?.map((e) => OutcomeSubActivity.fromJson(e)).toList() ?? [],
    );
  }
}

class OutcomeSubActivity {
  final int id;
  final int activityid;
  final String title;
  final String imageUrl;
  final dynamic addedBy;
  final String addedAt;

  OutcomeSubActivity({
    required this.id,
    required this.activityid,
    required this.title,
    required this.imageUrl,
    required this.addedBy,
    required this.addedAt,
  });

  factory OutcomeSubActivity.fromJson(Map<String, dynamic> json) {
    return OutcomeSubActivity(
      id: json['id'] ?? 0,
      activityid: json['activityid'] ?? 0,
      title: json['title'] ?? '',
      imageUrl: json['imageUrl'] ?? '',
      addedBy: json['added_by'],
      addedAt: json['added_at'] ?? '',
    );
  }
}

// Milestone models
class MilestoneAgeGroup {
  final int id;
  final String ageGroup;
  final List<MilestoneMain> mains;

  MilestoneAgeGroup({
    required this.id,
    required this.ageGroup,
    required this.mains,
  });

  factory MilestoneAgeGroup.fromJson(Map<String, dynamic> json) {
    return MilestoneAgeGroup(
      id: json['id'] ?? 0,
      ageGroup: json['ageGroup'] ?? '',
      mains: (json['mains'] as List?)?.map((e) => MilestoneMain.fromJson(e)).toList() ?? [],
    );
  }
}

class MilestoneMain {
  final int id;
  final int ageId;
  final String name;
  final dynamic addedBy;
  final String addedAt;
  final List<MilestoneSub> subs;

  MilestoneMain({
    required this.id,
    required this.ageId,
    required this.name,
    required this.addedBy,
    required this.addedAt,
    required this.subs,
  });

  factory MilestoneMain.fromJson(Map<String, dynamic> json) {
    return MilestoneMain(
      id: json['id'] ?? 0,
      ageId: json['ageId'] ?? 0,
      name: json['name'] ?? '',
      addedBy: json['added_by'],
      addedAt: json['added_at'] ?? '',
      subs: (json['subs'] as List?)?.map((e) => MilestoneSub.fromJson(e)).toList() ?? [],
    );
  }
}

class MilestoneSub {
  final int id;
  final int milestoneid;
  final String name;
  final String subject;
  final String imageUrl;
  final dynamic addedBy;
  final String addedAt;

  MilestoneSub({
    required this.id,
    required this.milestoneid,
    required this.name,
    required this.subject,
    required this.imageUrl,
    required this.addedBy,
    required this.addedAt,
  });

  factory MilestoneSub.fromJson(Map<String, dynamic> json) {
    return MilestoneSub(
      id: json['id'] ?? 0,
      milestoneid: json['milestoneid'] ?? 0,
      name: json['name'] ?? '',
      subject: json['subject'] ?? '',
      imageUrl: json['imageUrl'] ?? '',
      addedBy: json['added_by'],
      addedAt: json['added_at'] ?? '',
    );
  }
}