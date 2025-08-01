import 'package:mydiaree/features/learning_and_progress/data/model/child_model.dart';

abstract class LearningAndProgressState {}

class LearningAndProgressLoading extends LearningAndProgressState {}

class LearningAndProgressError extends LearningAndProgressState {
  final String message;
  LearningAndProgressError(this.message);
}

class LearningAndProgressLoaded extends LearningAndProgressState {
  final List<ChildModel> children;
  LearningAndProgressLoaded(this.children);
}

class LearningAndProgressDeleted extends LearningAndProgressState {
  final String message;
  LearningAndProgressDeleted(this.message);
}