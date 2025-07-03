import 'package:equatable/equatable.dart';
import 'package:mydiaree/features/daily_journal/sleepchecks/data/model/sleep_check_model.dart';

abstract class SleepChecklistState extends Equatable {
  const SleepChecklistState();

  @override
  List<Object> get props => [];
}

class SleepChecklistInitial extends SleepChecklistState {}

class SleepChecklistLoading extends SleepChecklistState {}

class SleepChecklistLoaded extends SleepChecklistState {
  final List<SlipChecksChildModel> sleepChecks;

  const SleepChecklistLoaded({required this.sleepChecks});

  @override
  List<Object> get props => [sleepChecks];
}

class SleepChecklistSuccess extends SleepChecklistState {
  final String message;

  const SleepChecklistSuccess({required this.message});

  @override
  List<Object> get props => [message];
}

class SleepChecklistFailure extends SleepChecklistState {
  final String error;

  const SleepChecklistFailure({required this.error});

  @override
  List<Object> get props => [error];
}
