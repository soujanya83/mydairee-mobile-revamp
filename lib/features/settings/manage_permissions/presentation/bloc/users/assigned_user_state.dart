import 'package:mydiaree/features/settings/manage_permissions/data/model/permission_model.dart';
import 'package:mydiaree/features/settings/manage_permissions/data/model/user_model.dart';

abstract class AssignerPermissionUserState {}

class AssignerPermissionUserInitial extends AssignerPermissionUserState {}

class AssignerPermissionUserLoading extends AssignerPermissionUserState {}

class AssignerPermissionUserLoaded extends AssignerPermissionUserState {
  final List<UserModel> users;
  final List<PermissionModel> permissions;

  AssignerPermissionUserLoaded.AssignerPermissionUserLoaded(this.users, this.permissions);
}

class AssignerPermissionUserError extends AssignerPermissionUserState {
  final String message;

  AssignerPermissionUserError(this.message);
}