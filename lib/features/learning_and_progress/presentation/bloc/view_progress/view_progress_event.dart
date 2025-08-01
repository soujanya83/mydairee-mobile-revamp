import 'package:mydiaree/features/learning_and_progress/data/model/assessment_model.dart';

abstract class ViewProgressEvent {}

class FetchAssessmentsEvent extends ViewProgressEvent {
  final String childId;
  FetchAssessmentsEvent({required this.childId});
}

class UpdateAssessmentStatusEvent extends ViewProgressEvent {
  final String assessmentId;
  final String childId;
  final AssessmentStatus newStatus;
  UpdateAssessmentStatusEvent({
    required this.assessmentId,
    required this.childId,
    required this.newStatus,
  });
}