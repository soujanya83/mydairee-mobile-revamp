class AccidentDetailResponseModel {
  final String status;
  final AccidentDetailData accident;
  final List<dynamic> children;
  final String roomId;
  final String centerId;

  AccidentDetailResponseModel({
    required this.status,
    required this.accident,
    required this.children,
    required this.roomId,
    required this.centerId,
  });

  factory AccidentDetailResponseModel.fromJson(Map<String, dynamic> json) {
    return AccidentDetailResponseModel(
      status: json['status'] ?? '',
      accident: AccidentDetailData.fromJson(json['accident'] ?? {}),
      children: json['children'] ?? [],
      roomId: json['roomid'] ?? '',
      centerId: json['centerid'] ?? '',
    );
  }
}

class AccidentDetailData {
  final int id;
  final int centerId;
  final int roomId;
  final String personName;
  final String personRole;
  final String date;
  final String time;
  final String personSign;
  final int childId;
  final String childName;
  final String childDob;
  final String childAge;
  final String childGender;
  final String incidentDate;
  final String incidentTime;
  final String incidentLocation;
  final String witnessName;
  final String witnessSign;
  final String witnessDate;
  final String injuryImage;
  final String genActyvt;
  final String cause;
  final String illnessSymptoms;
  final String missingUnaccounted;
  final String takenRemoved;
  final String actionTaken;
  final String emergServAttend;
  final String medAttention;
  final String medAttentionDetails;
  final String preventionStep1;
  final String preventionStep2;
  final String preventionStep3;
  final String parent1Name;
  final String contact1Method;
  final String contact1Date;
  final String contact1Time;
  final String contact1Made;
  final String contact1Msg;
  final String parent2Name;
  final String contact2Method;
  final String contact2Date;
  final String contact2Time;
  final String contact2Made;
  final String contact2Msg;
  final String responsiblePersonName;
  final String responsiblePersonSign;
  final String rpInternalNotifDate;
  final String rpInternalNotifTime;
  final String nominatedSupervisorName;
  final String nominatedSupervisorSign;
  final String nominatedSupervisorDate;
  final String nominatedSupervisorTime;
  final String extNotifOtherAgency;
  final String enorDate;
  final String enorTime;
  final String extNotifRegulatoryAuth;
  final String enraDate;
  final String enraTime;
  final String? ackParentName;
  final String? ackDate;
  final String? ackTime;
  final String addNotes;
  final int addedBy;
  final String addedAt;
  final int accidentId;
  final int abrasion;
  final int allergicReaction;
  final int amputation;
  final int anaphylaxis;
  final int asthma;
  final int biteWound;
  final int brokenBone;
  final int burn;
  final int choking;
  final int concussion;
  final int crush;
  final int cut;
  final int drowning;
  final int eyeInjury;
  final int electricShock;
  final int infectiousDisease;
  final int highTemperature;
  final int ingestion;
  final int internalInjury;
  final int poisoning;
  final int rash;
  final int respiratory;
  final int seizure;
  final int sprain;
  final int stabbing;
  final int tooth;
  final int venomousBite;
  final int other;
  final String remarks;
  final int illnessId;
  final ChildDetailModel child;
  final UserModel addedByUser;

  AccidentDetailData({
    required this.id,
    required this.centerId,
    required this.roomId,
    required this.personName,
    required this.personRole,
    required this.date,
    required this.time,
    required this.personSign,
    required this.childId,
    required this.childName,
    required this.childDob,
    required this.childAge,
    required this.childGender,
    required this.incidentDate,
    required this.incidentTime,
    required this.incidentLocation,
    required this.witnessName,
    required this.witnessSign,
    required this.witnessDate,
    required this.injuryImage,
    required this.genActyvt,
    required this.cause,
    required this.illnessSymptoms,
    required this.missingUnaccounted,
    required this.takenRemoved,
    required this.actionTaken,
    required this.emergServAttend,
    required this.medAttention,
    required this.medAttentionDetails,
    required this.preventionStep1,
    required this.preventionStep2,
    required this.preventionStep3,
    required this.parent1Name,
    required this.contact1Method,
    required this.contact1Date,
    required this.contact1Time,
    required this.contact1Made,
    required this.contact1Msg,
    required this.parent2Name,
    required this.contact2Method,
    required this.contact2Date,
    required this.contact2Time,
    required this.contact2Made,
    required this.contact2Msg,
    required this.responsiblePersonName,
    required this.responsiblePersonSign,
    required this.rpInternalNotifDate,
    required this.rpInternalNotifTime,
    required this.nominatedSupervisorName,
    required this.nominatedSupervisorSign,
    required this.nominatedSupervisorDate,
    required this.nominatedSupervisorTime,
    required this.extNotifOtherAgency,
    required this.enorDate,
    required this.enorTime,
    required this.extNotifRegulatoryAuth,
    required this.enraDate,
    required this.enraTime,
    this.ackParentName,
    this.ackDate,
    this.ackTime,
    required this.addNotes,
    required this.addedBy,
    required this.addedAt,
    required this.accidentId,
    required this.abrasion,
    required this.allergicReaction,
    required this.amputation,
    required this.anaphylaxis,
    required this.asthma,
    required this.biteWound,
    required this.brokenBone,
    required this.burn,
    required this.choking,
    required this.concussion,
    required this.crush,
    required this.cut,
    required this.drowning,
    required this.eyeInjury,
    required this.electricShock,
    required this.infectiousDisease,
    required this.highTemperature,
    required this.ingestion,
    required this.internalInjury,
    required this.poisoning,
    required this.rash,
    required this.respiratory,
    required this.seizure,
    required this.sprain,
    required this.stabbing,
    required this.tooth,
    required this.venomousBite,
    required this.other,
    required this.remarks,
    required this.illnessId,
    required this.child,
    required this.addedByUser,
  });

  factory AccidentDetailData.fromJson(Map<String, dynamic> json) {
    return AccidentDetailData(
      id: json['id'] ?? 0,
      centerId: json['centerid'] ?? 0,
      roomId: json['roomid'] ?? 0,
      personName: json['person_name'] ?? '',
      personRole: json['person_role'] ?? '',
      date: json['date'] ?? '',
      time: json['time'] ?? '',
      personSign: json['person_sign'] ?? '',
      childId: json['childid'] ?? 0,
      childName: json['child_name'] ?? '',
      childDob: json['child_dob'] ?? '',
      childAge: json['child_age'] ?? '',
      childGender: json['child_gender'] ?? '',
      incidentDate: json['incident_date'] ?? '',
      incidentTime: json['incident_time'] ?? '',
      incidentLocation: json['incident_location'] ?? '',
      witnessName: json['witness_name'] ?? '',
      witnessSign: json['witness_sign'] ?? '',
      witnessDate: json['witness_date'] ?? '',
      injuryImage: json['injury_image'] ?? '',
      genActyvt: json['gen_actyvt'] ?? '',
      cause: json['cause'] ?? '',
      illnessSymptoms: json['illness_symptoms'] ?? '',
      missingUnaccounted: json['missing_unaccounted'] ?? '',
      takenRemoved: json['taken_removed'] ?? '',
      actionTaken: json['action_taken'] ?? '',
      emergServAttend: json['emrg_serv_attend'] ?? '',
      medAttention: json['med_attention'] ?? '',
      medAttentionDetails: json['med_attention_details'] ?? '',
      preventionStep1: json['prevention_step_1'] ?? '',
      preventionStep2: json['prevention_step_2'] ?? '',
      preventionStep3: json['prevention_step_3'] ?? '',
      parent1Name: json['parent1_name'] ?? '',
      contact1Method: json['contact1_method'] ?? '',
      contact1Date: json['contact1_date'] ?? '',
      contact1Time: json['contact1_time'] ?? '',
      contact1Made: json['contact1_made'] ?? '',
      contact1Msg: json['contact1_msg'] ?? '',
      parent2Name: json['parent2_name'] ?? '',
      contact2Method: json['contact2_method'] ?? '',
      contact2Date: json['contact2_date'] ?? '',
      contact2Time: json['contact2_time'] ?? '',
      contact2Made: json['contact2_made'] ?? '',
      contact2Msg: json['contact2_msg'] ?? '',
      responsiblePersonName: json['responsible_person_name'] ?? '',
      responsiblePersonSign: json['responsible_person_sign'] ?? '',
      rpInternalNotifDate: json['rp_internal_notif_date'] ?? '',
      rpInternalNotifTime: json['rp_internal_notif_time'] ?? '',
      nominatedSupervisorName: json['nominated_supervisor_name'] ?? '',
      nominatedSupervisorSign: json['nominated_supervisor_sign'] ?? '',
      nominatedSupervisorDate: json['nominated_supervisor_date'] ?? '',
      nominatedSupervisorTime: json['nominated_supervisor_time'] ?? '',
      extNotifOtherAgency: json['ext_notif_other_agency'] ?? '',
      enorDate: json['enor_date'] ?? '',
      enorTime: json['enor_time'] ?? '',
      extNotifRegulatoryAuth: json['ext_notif_regulatory_auth'] ?? '',
      enraDate: json['enra_date'] ?? '',
      enraTime: json['enra_time'] ?? '',
      ackParentName: json['ack_parent_name'],
      ackDate: json['ack_date'],
      ackTime: json['ack_time'],
      addNotes: json['add_notes'] ?? '',
      addedBy: json['added_by'] ?? 0,
      addedAt: json['added_at'] ?? '',
      accidentId: json['accident_id'] ?? 0,
      abrasion: json['abrasion'] ?? 0,
      allergicReaction: json['allergic_reaction'] ?? 0,
      amputation: json['amputation'] ?? 0,
      anaphylaxis: json['anaphylaxis'] ?? 0,
      asthma: json['asthma'] ?? 0,
      biteWound: json['bite_wound'] ?? 0,
      brokenBone: json['broken_bone'] ?? 0,
      burn: json['burn'] ?? 0,
      choking: json['choking'] ?? 0,
      concussion: json['concussion'] ?? 0,
      crush: json['crush'] ?? 0,
      cut: json['cut'] ?? 0,
      drowning: json['drowning'] ?? 0,
      eyeInjury: json['eye_injury'] ?? 0,
      electricShock: json['electric_shock'] ?? 0,
      infectiousDisease: json['infectious_disease'] ?? 0,
      highTemperature: json['high_temperature'] ?? 0,
      ingestion: json['ingestion'] ?? 0,
      internalInjury: json['internal_injury'] ?? 0,
      poisoning: json['poisoning'] ?? 0,
      rash: json['rash'] ?? 0,
      respiratory: json['respiratory'] ?? 0,
      seizure: json['seizure'] ?? 0,
      sprain: json['sprain'] ?? 0,
      stabbing: json['stabbing'] ?? 0,
      tooth: json['tooth'] ?? 0,
      venomousBite: json['venomous_bite'] ?? 0,
      other: json['other'] ?? 0,
      remarks: json['remarks'] ?? '',
      illnessId: json['illness_id'] ?? 0,
      child: ChildDetailModel.fromJson(json['child'] ?? {}),
      addedByUser: UserModel.fromJson(json['added_by_user'] ?? {}),
    );
  }
}

class ChildDetailModel {
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

  ChildDetailModel({
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

  factory ChildDetailModel.fromJson(Map<String, dynamic> json) {
    return ChildDetailModel(
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

class UserModel {
  final int id;
  final int userId;
  final String username;
  final String emailId;
  final String email;
  final int centerStatus;
  final String contactNo;
  final String name;
  final String dob;
  final String gender;
  final String imageUrl;
  final String userType;
  final String title;
  final dynamic status;
  final String authToken;
  final String deviceId;
  final String deviceType;
  final dynamic companyLogo;
  final int theme;
  final String imagePosition;
  final int createdBy;
  final dynamic emailVerifiedAt;
  final String createdAt;
  final String updatedAt;

  UserModel({
    required this.id,
    required this.userId,
    required this.username,
    required this.emailId,
    required this.email,
    required this.centerStatus,
    required this.contactNo,
    required this.name,
    required this.dob,
    required this.gender,
    required this.imageUrl,
    required this.userType,
    required this.title,
    this.status,
    required this.authToken,
    required this.deviceId,
    required this.deviceType,
    this.companyLogo,
    required this.theme,
    required this.imagePosition,
    required this.createdBy,
    this.emailVerifiedAt,
    required this.createdAt,
    required this.updatedAt,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id'] ?? 0,
      userId: json['userid'] ?? 0,
      username: json['username'] ?? '',
      emailId: json['emailid'] ?? '',
      email: json['email'] ?? '',
      centerStatus: json['center_status'] ?? 0,
      contactNo: json['contactNo'] ?? '',
      name: json['name'] ?? '',
      dob: json['dob'] ?? '',
      gender: json['gender'] ?? '',
      imageUrl: json['imageUrl'] ?? '',
      userType: json['userType'] ?? '',
      title: json['title'] ?? '',
      status: json['status'],
      authToken: json['AuthToken'] ?? '',
      deviceId: json['deviceid'] ?? '',
      deviceType: json['devicetype'] ?? '',
      companyLogo: json['companyLogo'],
      theme: json['theme'] ?? 0,
      imagePosition: json['image_position'] ?? '',
      createdBy: json['created_by'] ?? 0,
      emailVerifiedAt: json['email_verified_at'],
      createdAt: json['created_at'] ?? '',
      updatedAt: json['updated_at'] ?? '',
    );
  }
}