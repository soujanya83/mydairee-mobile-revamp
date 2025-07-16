import 'package:equatable/equatable.dart'; 
import 'package:mydiaree/features/settings/center_settings/data/model/center_model.dart';

abstract class CentersSettingsEvent extends Equatable {
  const CentersSettingsEvent();

  @override
  List<Object?> get props => [];
}

class FetchCentersEvent extends CentersSettingsEvent {}

class AddCenterEvent extends CentersSettingsEvent {
  final CenterModel center;

  const AddCenterEvent(this.center);

  @override
  List<Object?> get props => [center];
}

class UpdateCenterEvent extends CentersSettingsEvent {
  final CenterModel center;

  const UpdateCenterEvent(this.center);

  @override
  List<Object?> get props => [center];
}

class DeleteCenterEvent extends CentersSettingsEvent {
  final String centerId;

  const DeleteCenterEvent(this.centerId);

  @override
  List<Object?> get props => [centerId];
}