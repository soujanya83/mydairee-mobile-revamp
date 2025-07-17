import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mydiaree/features/settings/manage_permissions/data/repositories/manage_permissions_repo.dart';
import 'package:mydiaree/features/settings/manage_permissions/presentation/bloc/users/assigned_user_event.dart';
import 'package:mydiaree/features/settings/manage_permissions/presentation/bloc/users/assigned_user_state.dart';

class AssignerPermissionUserBloc
    extends Bloc<AssignerPermissionUserEvent, AssignerPermissionUserState> {
  final ManagePermissionsRepository repository = ManagePermissionsRepository();

  AssignerPermissionUserBloc() : super(AssignerPermissionUserInitial()) {
    on<FetchUsersAndPermissions>(_onFetchUsersAndPermissions);
    on<UpdateUserPermissions>(_onUpdateUserPermissions);
  }

  Future<void> _onFetchUsersAndPermissions(FetchUsersAndPermissions event,
      Emitter<AssignerPermissionUserState> emit) async {
    emit(AssignerPermissionUserLoading());
    try {
      final users = await repository.fetchUsers(dummy: true);
      emit(AssignerPermissionUserLoaded(users.data ?? []));
    } catch (e) {
      emit(AssignerPermissionUserError('Failed to load data: $e'));
    }
  }

  Future<void> _onUpdateUserPermissions(UpdateUserPermissions event,
      Emitter<AssignerPermissionUserState> emit) async {
    try {
      emit(AssignerPermissionUserLoading());
      await repository.updateUserPermissions(event.userId, event.permissions);
      emit(AssignerPermissionUserAdded());
      final users = await repository.fetchUsers(dummy: true);
      emit(AssignerPermissionUserLoaded(users.data ?? []));
    } catch (e) {
      emit(AssignerPermissionUserError('Failed to update permissions: $e'));
    }
  }
}
