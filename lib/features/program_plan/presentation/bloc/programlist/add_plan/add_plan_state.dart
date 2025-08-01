import 'package:equatable/equatable.dart';
import 'package:mydiaree/features/program_plan/data/model/program_plan_data_model.dart'
    hide User;

import 'package:mydiaree/features/program_plan/data/model/UsersAddProgramPlan.dart';
import 'package:mydiaree/features/program_plan/data/model/ChildrenAddProgramPlan.dart';

abstract class AddPlanState extends Equatable {
  const AddPlanState();

  @override
  List<Object?> get props => [];
}

class AddPlanInitial extends AddPlanState {}


class AddPlanLoading extends AddPlanState {}

class AddPlanSuccess extends AddPlanState {
  final String message;

  const AddPlanSuccess(this.message);

  @override
  List<Object?> get props => [message];
}

class AddPlanFailure extends AddPlanState {
  final String message;

  const AddPlanFailure(this.message);

  @override
  List<Object?> get props => [message];
}
