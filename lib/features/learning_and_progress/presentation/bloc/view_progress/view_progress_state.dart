import 'package:mydiaree/features/learning_and_progress/data/model/assessment_model.dart';

abstract class ViewProgressState {}

class ViewProgressLoading extends ViewProgressState {}

class ViewProgressError extends ViewProgressState {
  final String message;
  ViewProgressError(this.message);
}

class ViewProgressLoaded extends ViewProgressState {
  final List<AssessmentModel> assessments;
  ViewProgressLoaded(this.assessments);
}

class ViewProgressStatusUpdated extends ViewProgressState {
  final String message;
  ViewProgressStatusUpdated(this.message);
}