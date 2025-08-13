enum AssessmentStatus { notStarted, introduced, practicing, completed , working}

class AssessmentModel {
  final String id;
  final String subject;
  final String activityTitle;
  final String subActivityTitle;
  final AssessmentStatus status;

  AssessmentModel({
    required this.id,
    required this.subject,
    required this.activityTitle,
    required this.subActivityTitle,
    required this.status,
  });

  factory AssessmentModel.fromJson(Map<String, dynamic> json) {
    final sub = (json['sub_activity'] ?? {}) as Map<String, dynamic>;
    final activity = (sub['activity'] ?? {}) as Map<String, dynamic>;
    final subject = (activity['subject'] ?? {}) as Map<String, dynamic>;

    // treat "working" same as "practicing"
    var statusStr = (json['status'] as String? ?? '').toLowerCase();
    if (statusStr == 'working') statusStr = 'practicing';
    final statusEnum = AssessmentStatus.values.firstWhere(
      (e) => e.toString().split('.').last.toLowerCase() == statusStr,
      orElse: () => AssessmentStatus.notStarted,
    );

    return AssessmentModel(
      id: json['id'].toString(),
      subject: subject['name'] as String? ?? '',
      activityTitle: activity['title'] as String? ?? '',
      subActivityTitle: sub['title'] as String? ?? '',
      status: statusEnum,
    );
  }

  AssessmentModel copyWith({AssessmentStatus? status}) {
    return AssessmentModel(
      id: id,
      subject: subject,
      activityTitle: activityTitle,
      subActivityTitle: subActivityTitle,
      status: status ?? this.status,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'subject': subject,
      'activityTitle': activityTitle,
      'subActivityTitle': subActivityTitle,
      'status': status.toString().split('.').last,
    };
  }
}