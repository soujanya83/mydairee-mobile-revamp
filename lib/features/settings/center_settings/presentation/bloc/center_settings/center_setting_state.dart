import 'package:equatable/equatable.dart';
import 'package:mydiaree/features/settings/center_settings/data/model/center_model.dart';

abstract class CentersSettingsState extends Equatable {
  const CentersSettingsState();

  @override
  List<Object?> get props => [];
}

class CentersSettingsInitial extends CentersSettingsState {}

class CentersSettingsLoading extends CentersSettingsState {}

class CentersSettingsLoaded extends CentersSettingsState {
  final List<CenterModel> centers;

  const CentersSettingsLoaded({required this.centers});

  @override
  List<Object?> get props => [centers];
}

class CentersSettingsSuccess extends CentersSettingsState {
  final String message;

  const CentersSettingsSuccess({required this.message});

  @override
  List<Object?> get props => [message];
}

class CentersSettingsFailure extends CentersSettingsState {
  final String message;

  const CentersSettingsFailure({required this.message});

  @override
  List<Object?> get props => [message];
}