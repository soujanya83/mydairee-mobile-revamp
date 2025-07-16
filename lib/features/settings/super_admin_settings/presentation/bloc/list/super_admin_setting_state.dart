import 'package:equatable/equatable.dart';
import 'package:mydiaree/features/settings/super_admin_settings/data/model/super_admin_model.dart'; 

abstract class SuperAdminSettingsState extends Equatable {
  const SuperAdminSettingsState();

  @override
  List<Object?> get props => [];
}

class SuperAdminSettingsInitial extends SuperAdminSettingsState {}

class SuperAdminSettingsLoading extends SuperAdminSettingsState {}

class SuperAdminSettingsLoaded extends SuperAdminSettingsState {
  final List<SuperAdminModel> superAdmins;

  const SuperAdminSettingsLoaded({required this.superAdmins});

  @override
  List<Object?> get props => [superAdmins];
}

class SuperAdminSettingsSuccess extends SuperAdminSettingsState {
  final String message;

  const SuperAdminSettingsSuccess({required this.message});

  @override
  List<Object?> get props => [message];
}

class SuperAdminSettingsFailure extends SuperAdminSettingsState {
  final String message;

  const SuperAdminSettingsFailure({required this.message});

  @override
  List<Object?> get props => [message];
}