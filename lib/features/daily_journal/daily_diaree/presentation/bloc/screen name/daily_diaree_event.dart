import 'package:equatable/equatable.dart';
import 'package:mydiaree/features/daily_journal/daily_diaree/data/model/child_model.dart';

abstract class DailyTrackingEvent extends Equatable {
  @override
  List<Object> get props => [];
}

class LoadDailyTrackingEvent extends DailyTrackingEvent {}

class SaveActivityEvent extends DailyTrackingEvent {
  final List<String> childIds;
  final ActivityModel activity;

  SaveActivityEvent({required this.childIds, required this.activity});

  @override
  List<Object> get props => [childIds, activity];
}