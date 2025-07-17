import 'package:mydiaree/features/settings/manage_permissions/data/model/permission_model.dart';
import 'package:mydiaree/features/settings/manage_permissions/data/model/user_model.dart';

abstract class AssignerPermissionUserState {}

class AssignerPermissionUserInitial extends AssignerPermissionUserState {}

class AssignerPermissionUserLoading extends AssignerPermissionUserState {}

class AssignerPermissionUserAdded extends AssignerPermissionUserState {}

class AssignerPermissionUserLoaded extends AssignerPermissionUserState {
  final List<UserModel> users;
  AssignerPermissionUserLoaded(this.users);
}

class AssignerPermissionUserError extends AssignerPermissionUserState {
  final String message;

  AssignerPermissionUserError(this.message);
}
