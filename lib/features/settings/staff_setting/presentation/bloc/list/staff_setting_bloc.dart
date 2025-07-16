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
        final staff = await repository.getStaff();
        emit(StaffSettingsLoaded(staff: staff));
         print('emit success');
      } catch (e) {
        emit(StaffSettingsFailure(message: e.toString()));
      }
    });

    on<AddStaffEvent>((event, emit) async {
      emit(StaffSettingsLoading());
      try {
        final response = await repository.addStaff(
          name: event.name,
          email: event.email,
          password: event.password,
          contactNo: event.contactNo,
          gender: event.gender,
          avatarUrl: event.avatarUrl,
          userType: event.userType,
        );
        if (response.success) {
          emit(StaffSettingsSuccess(message: 'Staff added successfully!'));
          add(FetchStaffEvent());
        } else {
          emit(StaffSettingsFailure(message: response.message));
        }
      } catch (e) {
        emit(StaffSettingsFailure(message: e.toString()));
      }
    });

    on<UpdateStaffEvent>((event, emit) async {
      emit(StaffSettingsLoading());
      try {
        final response = await repository.updateStaff(
          id: event.id,
          name: event.name,
          email: event.email,
          password: event.password,
          contactNo: event.contactNo,
          gender: event.gender,
          avatarUrl: event.avatarUrl,
          userType: event.userType,
        );
        if (response.success) {
          emit(StaffSettingsSuccess(message: 'Staff updated successfully!'));
          add(FetchStaffEvent());
        } else {
          emit(StaffSettingsFailure(message: response.message));
        }
      } catch (e) {
        emit(StaffSettingsFailure(message: e.toString()));
      }
    });

    on<DeleteStaffEvent>((event, emit) async {
      emit(StaffSettingsLoading());
      try {
        final response = await repository.deleteStaff(event.staffId);
        if (response.success) {
          emit(StaffSettingsSuccess(message: 'Staff deleted successfully!'));
          add(FetchStaffEvent());
        } else {
          emit(StaffSettingsFailure(message: response.message));
        }
      } catch (e) {
        emit(StaffSettingsFailure(message: e.toString()));
      }
    });
  }
}