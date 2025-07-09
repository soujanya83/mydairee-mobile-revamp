import 'package:equatable/equatable.dart';
import 'package:mydiaree/features/daily_journal/daily_diaree/data/model/child_model.dart';

abstract class DailyTrackingState extends Equatable {
  @override
  List<Object> get props => [];
}

class DailyTrackingLoading extends DailyTrackingState {}

class DailyTrackingLoaded extends DailyTrackingState {
  final List<ChildModel> children;
  final bool isActivitySaved;

  DailyTrackingLoaded({required this.children, this.isActivitySaved = false});

  @override
  List<Object> get props => [children, isActivitySaved];
}

class DailyTrackingError extends DailyTrackingState {
  final String message;

  DailyTrackingError({required this.message});

  @override
  List<Object> get props => [message];
}