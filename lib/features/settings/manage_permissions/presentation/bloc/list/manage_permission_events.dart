abstract class PermissionEvent {}

class FetchPermissionsEvent extends PermissionEvent {}

class AssignPermissionsEvent extends PermissionEvent {
  final String userId;
  final Map<String, bool> permissions;

  AssignPermissionsEvent({required this.userId, required this.permissions});
}