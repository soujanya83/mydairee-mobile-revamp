import 'package:equatable/equatable.dart';
import 'package:mydiaree/features/daily_journal/daily_diaree/data/model/child_model.dart';
import 'package:mydiaree/features/daily_journal/daily_diaree/data/model/daily_diaree_model.dart';

abstract class DailyTrackingState extends Equatable {
  @override
  List<Object> get props => [];
}

class DailyTrackingLoading extends DailyTrackingState {}

class DailyTrackingLoaded extends DailyTrackingState {
  final DailyDiareeModel? diareeData;
  final bool isActivitySaved;

  DailyTrackingLoaded({  this.diareeData, this.isActivitySaved = false});

}

class DailyTrackingError extends DailyTrackingState {
  final String message;

  DailyTrackingError({required this.message});

  @override
  List<Object> get props => [message];
}