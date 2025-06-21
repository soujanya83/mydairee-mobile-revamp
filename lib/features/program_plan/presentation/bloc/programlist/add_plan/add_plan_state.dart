import 'package:equatable/equatable.dart';

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
