import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mydiaree/features/settings/manage_permissions/data/model/permission_model.dart';
import 'package:mydiaree/features/settings/manage_permissions/data/repositories/manage_permissions_repo.dart';
import 'manage_permission_events.dart';
import 'manage_permission_state.dart';

class PermissionBloc extends Bloc<PermissionEvent, PermissionState> {
  final ManagePermissionsRepository repository = ManagePermissionsRepository();

  PermissionBloc() : super(PermissionInitial()) {
    on<FetchPermissionsEvent>(_onFetchPermissions);
    on<AssignPermissionsEvent>(_onAssignPermissions);
  }

  Future<void> _onFetchPermissions(
      FetchPermissionsEvent event, Emitter<PermissionState> emit) async {
    emit(PermissionLoading());
    try {
      final response = await repository.getPermissions();
      if (response.success && response.data != null) {
        emit(PermissionLoaded(response.data?.data??[]));
      } else {
        print('data==============');
        print(response.data.toString());
        emit(PermissionFailure('Failed to load permissions'));
      }
    } catch (e) {
      print('-------------------');
      print(e.toString());
      emit(PermissionFailure('Error: $e'));
    }
  }

  Future<void> _onAssignPermissions(
      AssignPermissionsEvent event, Emitter<PermissionState> emit) async {
    emit(PermissionLoading());
    try {
      final selectedPermissions = event.permissions.entries
          .where((entry) => entry.value)
          .map((entry) => entry.key)
          .toList();
      final response = await repository.addPermissions(
        userId: event.userId,
        permissions: selectedPermissions,
      );
      if (response.success) {
        emit(PermissionSuccess('Permissions assigned successfully'));
      } else {
        emit(PermissionFailure(
            'Failed to assign permissions: ${response.message}'));
      }
    } catch (e) {
      emit(PermissionFailure('Error: $e'));
    }
  }
}
