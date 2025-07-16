import 'package:equatable/equatable.dart';
import 'package:mydiaree/features/settings/parent_setting/data/model/parent_model.dart'; 

abstract class ParentSettingsState extends Equatable {
  const ParentSettingsState();

  @override
  List<Object?> get props => [];
}

class ParentSettingsInitial extends ParentSettingsState {}

class ParentSettingsLoading extends ParentSettingsState {}

class ParentSettingsLoaded extends ParentSettingsState {
  final List<ParentModel> parents;

  const ParentSettingsLoaded({required this.parents});

  @override
  List<Object?> get props => [parents];
}

class ParentSettingsSuccess extends ParentSettingsState {
  final String message;

  const ParentSettingsSuccess({required this.message});

  @override
  List<Object?> get props => [message];
}

class ParentSettingsFailure extends ParentSettingsState {
  final String message;

  const ParentSettingsFailure({required this.message});

  @override
  List<Object?> get props => [message];
}