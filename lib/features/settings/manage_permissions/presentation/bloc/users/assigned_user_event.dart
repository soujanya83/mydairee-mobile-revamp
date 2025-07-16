abstract class AssignerPermissionUserEvent {}

class FetchUsersAndPermissions extends AssignerPermissionUserEvent {}

class UpdateUserPermissions extends AssignerPermissionUserEvent {
  final int userId;
  final List<String> permissions;

  UpdateUserPermissions(this.userId, this.permissions);
}