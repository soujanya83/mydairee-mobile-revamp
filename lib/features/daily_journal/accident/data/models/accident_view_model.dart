class AccidentViewResponse {
  final bool status;
  final String message;
  final AccidentViewData data;

  AccidentViewResponse({
    required this.status,
    required this.message,
    required this.data,
  });

  factory AccidentViewResponse.fromJson(Map<String, dynamic> json) {
    return AccidentViewResponse(
      status: json['status'] ?? false,
      message: json['message'] ?? '',
      data: AccidentViewData.fromJson(json['data'] ?? {}),
    );
  }
}

class AccidentViewData {
  final int id;
  final int centerid;
  final int roomid;
  final String personName;
  final String personRole;
  final String date;
  final String time;
  final String? personSign;
  final int childid;
  final String childName;
  final String childDob;
  final String childAge;
  final String childGender;
  final String incidentDate;
  final String incidentTime;
  final String incidentLocation;
  final String witnessName;
  final String? witnessSign;
  final String witnessDate;
  final String? injuryImage;
  final String genActyvt;
  final String cause;
  final String illnessSymptoms;
  final String missingUnaccounted;
  final String takenRemoved;
  final String actionTaken;
  final String emrgServAttend;
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
  final String? responsiblePersonSign;
  final String rpInternalNotifDate;
  final String rpInternalNotifTime;
  final String nominatedSupervisorName;
  final String? nominatedSupervisorSign;
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
  final AccidentChild child;
  final AccidentUser addedByUser;

  AccidentViewData({
    required this.id,
    required this.centerid,
    required this.roomid,
    required this.personName,
    required this.personRole,
    required this.date,
    required this.time,
    this.personSign,
    required this.childid,
    required this.childName,
    required this.childDob,
    required this.childAge,
    required this.childGender,
    required this.incidentDate,
    required this.incidentTime,
    required this.incidentLocation,
    required this.witnessName,
    this.witnessSign,
    required this.witnessDate,
    this.injuryImage,
    required this.genActyvt,
    required this.cause,
    required this.illnessSymptoms,
    required this.missingUnaccounted,
    required this.takenRemoved,
    required this.actionTaken,
    required this.emrgServAttend,
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
    this.responsiblePersonSign,
    required this.rpInternalNotifDate,
    required this.rpInternalNotifTime,
    required this.nominatedSupervisorName,
    this.nominatedSupervisorSign,
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

  factory AccidentViewData.fromJson(Map<String, dynamic> json) {
    return AccidentViewData(
      id: json['id'] ?? 0,
      centerid: json['centerid'] ?? 0,
      roomid: json['roomid'] ?? 0,
      personName: json['person_name'] ?? '',
      personRole: json['person_role'] ?? '',
      date: json['date'] ?? '',
      time: json['time'] ?? '',
      personSign: json['person_sign'],
      childid: json['childid'] ?? 0,
      childName: json['child_name'] ?? '',
      childDob: json['child_dob'] ?? '',
      childAge: json['child_age'] ?? '',
      childGender: json['child_gender'] ?? '',
      incidentDate: json['incident_date'] ?? '',
      incidentTime: json['incident_time'] ?? '',
      incidentLocation: json['incident_location'] ?? '',
      witnessName: json['witness_name'] ?? '',
      witnessSign: json['witness_sign'],
      witnessDate: json['witness_date'] ?? '',
      injuryImage: json['injury_image'],
      genActyvt: json['gen_actyvt'] ?? '',
      cause: json['cause'] ?? '',
      illnessSymptoms: json['illness_symptoms'] ?? '',
      missingUnaccounted: json['missing_unaccounted'] ?? '',
      takenRemoved: json['taken_removed'] ?? '',
      actionTaken: json['action_taken'] ?? '',
      emrgServAttend: json['emrg_serv_attend'] ?? '',
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
      responsiblePersonSign: json['responsible_person_sign'],
      rpInternalNotifDate: json['rp_internal_notif_date'] ?? '',
      rpInternalNotifTime: json['rp_internal_notif_time'] ?? '',
      nominatedSupervisorName: json['nominated_supervisor_name'] ?? '',
      nominatedSupervisorSign: json['nominated_supervisor_sign'],
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
      child: AccidentChild.fromJson(json['child'] ?? {}),
      addedByUser: AccidentUser.fromJson(json['added_by_user'] ?? {}),
    );
  }

  List<String> getSelectedInjuryTypes() {
    List<String> types = [];
    if (abrasion == 1) types.add('Abrasion/Scrape');
    if (allergicReaction == 1) types.add('Allergic Reaction');
    if (amputation == 1) types.add('Amputation');
    if (anaphylaxis == 1) types.add('Anaphylaxis');
    if (asthma == 1) types.add('Asthma');
    if (biteWound == 1) types.add('Bite Wound');
    if (brokenBone == 1) types.add('Broken Bone');
    if (burn == 1) types.add('Burn');
    if (choking == 1) types.add('Choking');
    if (concussion == 1) types.add('Concussion');
    if (crush == 1) types.add('Crush');
    if (cut == 1) types.add('Cut');
    if (drowning == 1) types.add('Drowning');
    if (eyeInjury == 1) types.add('Eye Injury');
    if (electricShock == 1) types.add('Electric Shock');
    if (infectiousDisease == 1) types.add('Infectious Disease');
    if (highTemperature == 1) types.add('High Temperature');
    if (ingestion == 1) types.add('Ingestion');
    if (internalInjury == 1) types.add('Internal Injury');
    if (poisoning == 1) types.add('Poisoning');
    if (rash == 1) types.add('Rash');
    if (respiratory == 1) types.add('Respiratory');
    if (seizure == 1) types.add('Seizure');
    if (sprain == 1) types.add('Sprain');
    if (stabbing == 1) types.add('Stabbing');
    if (tooth == 1) types.add('Tooth');
    if (venomousBite == 1) types.add('Venomous Bite');
    if (other == 1) types.add('Other');
    return types;
  }
}

class AccidentChild {
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
  final String createdAtTimestamp;
  final String updatedAtTimestamp;

  AccidentChild({
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
    required this.createdAtTimestamp,
    required this.updatedAtTimestamp,
  });

  factory AccidentChild.fromJson(Map<String, dynamic> json) {
    return AccidentChild(
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
      createdAtTimestamp: json['created_at'] ?? '',
      updatedAtTimestamp: json['updated_at'] ?? '',
    );
  }

  String getFullName() {
    return '$name $lastname'.trim();
  }
}

class AccidentUser {
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

  AccidentUser({
    required this.id,
    required this.userid,
    required this.username,
    required this.emailid,
    required this.email,
    required this.contactNo,
    required this.name,
    required this.centerStatus,
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
    required this.imagePosition,
    this.createdBy,
    this.emailVerifiedAt,
    required this.hasSeenLoginNotice,
    required this.createdAt,
    required this.updatedAt,
  });

  factory AccidentUser.fromJson(Map<String, dynamic> json) {
    return AccidentUser(
      id: json['id'] ?? 0,
      userid: json['userid'] ?? 0,
      username: json['username'] ?? '',
      emailid: json['emailid'] ?? '',
      email: json['email'] ?? '',
      contactNo: json['contactNo'] ?? '',
      name: json['name'] ?? '',
      centerStatus: json['center_status'] ?? 0,
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
      imagePosition: json['image_position'] ?? '',
      createdBy: json['created_by'],
      emailVerifiedAt: json['email_verified_at'],
      hasSeenLoginNotice: json['has_seen_login_notice'] ?? 0,
      createdAt: json['created_at'] ?? '',
      updatedAt: json['updated_at'] ?? '',
    );
  }
}
