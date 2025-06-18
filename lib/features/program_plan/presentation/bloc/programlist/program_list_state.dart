import 'package:equatable/equatable.dart';
import 'package:mydiaree/features/program_plan/data/model/program_plan_list_model.dart';

class ProgramPlanListState extends Equatable {
  const ProgramPlanListState();

  @override
  List<Object?> get props => [];
}

class ProgramPlanInitial extends ProgramPlanListState {}

class ProgramPlanLoading extends ProgramPlanListState {}

class ProgramPlanLoaded extends ProgramPlanListState {
  final ProgramPlanListModel? prgramPlanListData;

  const ProgramPlanLoaded(this.prgramPlanListData);

  @override
  List<Object?> get props => [prgramPlanListData];
}

class ProgramPlanError extends ProgramPlanListState {
  final String message;

  const ProgramPlanError(this.message);

  @override
  List<Object?> get props => [message];
}

class ProgramPlanDeleted extends ProgramPlanListState {}
