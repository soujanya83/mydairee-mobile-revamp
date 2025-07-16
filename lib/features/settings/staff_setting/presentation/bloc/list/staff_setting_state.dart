import 'package:equatable/equatable.dart';
import 'package:mydiaree/features/observation/presentation/pages/add_observation/add_observation_screen.dart';
import 'package:mydiaree/features/settings/staff_setting/data/model/staff_model.dart'; 

abstract class StaffSettingsState extends Equatable {
  const StaffSettingsState();

  @override
  List<Object?> get props => [];
}

class StaffSettingsInitial extends StaffSettingsState {}

class StaffSettingsLoading extends StaffSettingsState {}

class StaffSettingsLoaded extends StaffSettingsState {
  final List<StaffModel> staff;

  const StaffSettingsLoaded({required this.staff});

  @override
  List<Object?> get props => [staff];
}

class StaffSettingsSuccess extends StaffSettingsState {
  final String message;

  const StaffSettingsSuccess({required this.message});

  @override
  List<Object?> get props => [message];
}

class StaffSettingsFailure extends StaffSettingsState {
  final String message;

  const StaffSettingsFailure({required this.message});

  @override
  List<Object?> get props => [message];
}