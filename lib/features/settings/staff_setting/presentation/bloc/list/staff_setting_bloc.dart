import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mydiaree/features/settings/staff_setting/data/repositories/staff_settings_repository.dart';
import 'staff_setting_event.dart';
import 'staff_setting_state.dart';

class StaffSettingsBloc extends Bloc<StaffSettingsEvent, StaffSettingsState> {
  final StaffRepository repository = StaffRepository();

  StaffSettingsBloc() : super(StaffSettingsInitial()) {
    on<FetchStaffEvent>((event, emit) async {
      emit(StaffSettingsLoading());
      print('emit loading');
      try {
        final staff = await repository.getStaff(event.centerId);
        emit(StaffSettingsLoaded(staff: staff));
         print('emit success');
      } catch (e) {
        emit(StaffSettingsFailure(message: e.toString()));
      }
    });
  }}