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
  }
}
    
