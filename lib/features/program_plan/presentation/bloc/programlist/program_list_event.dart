import 'package:equatable/equatable.dart';

abstract class ProgramPlanListEvent extends Equatable {
  const ProgramPlanListEvent();

  @override
  List<Object?> get props => [];
}

class FetchProgramPlansEvent extends ProgramPlanListEvent {
  final String centerId;

  const FetchProgramPlansEvent({required this.centerId});

  @override
  List<Object> get props => [centerId];
}

class DeleteProgramPlanEvent extends ProgramPlanListEvent {
  final String planId;

  const DeleteProgramPlanEvent({required this.planId});

  @override
  List<Object> get props => [planId];
}
