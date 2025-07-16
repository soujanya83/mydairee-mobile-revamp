import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mydiaree/features/settings/super_admin_settings/data/repositories/settings_repository.dart';
import 'super_admin_setting_event.dart';
import 'super_admin_setting_state.dart';

class SuperAdminSettingsBloc
    extends Bloc<SuperAdminSettingsEvent, SuperAdminSettingsState> {
  final SuperAdminRepository repository = SuperAdminRepository();

  SuperAdminSettingsBloc() : super(SuperAdminSettingsInitial()) {
    on<FetchSuperAdminsEvent>((event, emit) async {
      emit(SuperAdminSettingsLoading());
      try {
        final superAdmins = await repository.getSuperAdmins();
        emit(SuperAdminSettingsLoaded(superAdmins: superAdmins));
      } catch (e) {
        emit(SuperAdminSettingsFailure(message: e.toString()));
      }
    });

    on<AddSuperAdminEvent>((event, emit) async {
      emit(SuperAdminSettingsLoading());
      try {
        final response = await repository.addSuperAdmin(
          name: event.name,
          email: event.email,
          password: event.password,
          contactNo: event.contactNo,
          gender: event.gender,
          avatarUrl: event.avatarUrl,
          centerName: event.centerName,
          streetAddress: event.streetAddress,
          city: event.city,
          state: event.state,
          zip: event.zip,
        );
        if (response.success) {
          emit(SuperAdminSettingsSuccess(
              message: 'Superadmin added successfully!'));
          add(FetchSuperAdminsEvent());
        } else {
          emit(SuperAdminSettingsFailure(message: response.message));
        }
      } catch (e) {
        emit(SuperAdminSettingsFailure(message: e.toString()));
      }
    });

    on<UpdateSuperAdminEvent>((event, emit) async {
      emit(SuperAdminSettingsLoading());
      try {
        final response = await repository.updateSuperAdmin(
          id: event.id,
          name: event.name,
          email: event.email,
          password: event.password,
          contactNo: event.contactNo,
          gender: event.gender,
          avatarUrl: event.avatarUrl,
          centerName: event.centerName,
          streetAddress: event.streetAddress,
          city: event.city,
          state: event.state,
          zip: event.zip,
        );
        if (response.success) {
          emit(SuperAdminSettingsSuccess(
              message: 'Superadmin updated successfully!'));
          add(FetchSuperAdminsEvent());
        } else {
          emit(SuperAdminSettingsFailure(message: response.message));
        }
      } catch (e) {
        emit(SuperAdminSettingsFailure(message: e.toString()));
      }
    });

    on<DeleteSuperAdminEvent>((event, emit) async {
      emit(SuperAdminSettingsLoading());
      try {
        final response = await repository.deleteSuperAdmin(event.superAdminId);
        if (response.success) {
          emit(SuperAdminSettingsSuccess(
              message: 'Superadmin deleted successfully!'));
          add(FetchSuperAdminsEvent());
        } else {
          emit(SuperAdminSettingsFailure(message: response.message));
        }
      } catch (e) {
        emit(SuperAdminSettingsFailure(message: e.toString()));
      }
    });
  }
}
