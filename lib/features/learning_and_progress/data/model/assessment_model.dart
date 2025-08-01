enum AssessmentStatus { notStarted, introduced, practicing, completed }

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

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'subject': subject,
      'activityTitle': activityTitle,
      'subActivityTitle': subActivityTitle,
      'status': status.toString().split('.').last,
    };
  }

  factory AssessmentModel.fromMap(Map<String, dynamic> map) {
    return AssessmentModel(
      id: map['id'] as String,
      subject: map['subject'] as String,
      activityTitle: map['activityTitle'] as String,
      subActivityTitle: map['subActivityTitle'] as String,
      status: AssessmentStatus.values.firstWhere(
        (e) => e.toString().split('.').last == map['status'],
        orElse: () => AssessmentStatus.notStarted,
      ),
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
}