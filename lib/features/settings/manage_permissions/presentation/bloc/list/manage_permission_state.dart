import 'package:mydiaree/features/settings/manage_permissions/data/model/permission_model.dart';


abstract class PermissionState {}

class PermissionInitial extends PermissionState {}

class PermissionLoading extends PermissionState {}

class PermissionLoaded extends PermissionState {
  final List<PermissionModel> permissions;

  PermissionLoaded(this.permissions);
}

class PermissionSuccess extends PermissionState {
  final String message;

  PermissionSuccess(this.message);
}

class PermissionFailure extends PermissionState {
  final String message;

  PermissionFailure(this.message);
}