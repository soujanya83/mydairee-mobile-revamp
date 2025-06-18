class ProgramPlanListModel {
  final List<ProgPlanModel> plans;

  ProgramPlanListModel({required this.plans});

  factory ProgramPlanListModel.fromJson(Map<String, dynamic> json) {
    return ProgramPlanListModel(
      plans: (json['plans'] as List)
          .map((plan) => ProgPlanModel.fromJson(plan))
          .toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'plans': plans.map((plan) => plan.toJson()).toList(),
    };
  }
}

class ProgPlanModel {
  final String id;
  final String roomid;
  final String name;
  final String startDate;
  final String endDate;
  final String inqTopicTitle;
  final String susTopicTitle;
  final String inqTopicDetails;
  final String susTopicDetails;
  final String artExperiments;
  final String activityDetails;
  final String outdoorActivityDetails;
  final String otherExperience;
  final String specialActivity;
  final String createdAt;
  final String createdBy;
  final String checked;
  final bool boolCheck;

  ProgPlanModel({
    required this.id,
    required this.roomid,
    required this.name,
    required this.startDate,
    required this.endDate,
    required this.inqTopicTitle,
    required this.susTopicTitle,
    required this.inqTopicDetails,
    required this.susTopicDetails,
    required this.artExperiments,
    required this.activityDetails,
    required this.outdoorActivityDetails,
    required this.otherExperience,
    required this.specialActivity,
    required this.createdAt,
    required this.createdBy,
    required this.checked,
    required this.boolCheck,
  });

  factory ProgPlanModel.fromJson(Map<String, dynamic> json) {
    return ProgPlanModel(
      id: json['id'] ?? '',
      roomid: json['roomid'] ?? '',
      name: json['name'] ?? '',
      startDate: json['startDate'] ?? '',
      endDate: json['endDate'] ?? '',
      inqTopicTitle: json['inqTopicTitle'] ?? '',
      susTopicTitle: json['susTopicTitle'] ?? '',
      inqTopicDetails: json['inqTopicDetails'] ?? '',
      susTopicDetails: json['susTopicDetails'] ?? '',
      artExperiments: json['artExperiments'] ?? '',
      activityDetails: json['activityDetails'] ?? '',
      outdoorActivityDetails: json['outdoorActivityDetails'] ?? '',
      otherExperience: json['otherExperience'] ?? '',
      specialActivity: json['specialActivity'] ?? '',
      createdAt: json['createdAt'] ?? '',
      createdBy: json['createdBy'] ?? '',
      checked: json['checked'] ?? '',
      boolCheck: json['checked'] != null && json['checked'] != 'null',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'roomid': roomid,
      'name': name,
      'startDate': startDate,
      'endDate': endDate,
      'inqTopicTitle': inqTopicTitle,
      'susTopicTitle': susTopicTitle,
      'inqTopicDetails': inqTopicDetails,
      'susTopicDetails': susTopicDetails,
      'artExperiments': artExperiments,
      'activityDetails': activityDetails,
      'outdoorActivityDetails': outdoorActivityDetails,
      'otherExperience': otherExperience,
      'specialActivity': specialActivity,
      'createdAt': createdAt,
      'createdBy': createdBy,
      'checked': checked,
      'boolCheck': boolCheck,
    };
  }
}
