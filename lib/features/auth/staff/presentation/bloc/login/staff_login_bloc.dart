import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mydiaree/core/services/apiresoponse.dart';
import 'package:mydiaree/features/auth/staff/data/repositories/staff_auth_repo.dart';
import 'package:mydiaree/features/auth/staff/presentation/bloc/login/staff_event.dart';
import 'package:mydiaree/features/auth/staff/presentation/bloc/login/staff_login_state.dart';

class StaffLoginBloc extends Bloc<StaffLoginEvent, StaffLoginState> {
  StaffAuthenticationRepository repository = StaffAuthenticationRepository();

  StaffLoginBloc() : super(StaffLoginInitial()) {
    on<StaffLoginSubmitted>((event, emit) async {
      if (state is StaffLoginInitial || state is StaffLoginError) {
        emit(StaffLoginLoading());
        try {
          final response = await repository.staffLoginWithPass(
            email: event.employeeCode,
            password: event.pin,
          );
          if (response.success) {
            emit(StaffLoginSuccess(
              message: response.message,
              loginData: response.data,
            ));
          } else {
            emit(StaffLoginError(message: response.message));
          }
        } catch (e) {
          emit(StaffLoginError(message: defaultErrorMessage()));
        }
        emit(StaffLoginInitial());
      }
    });
  }
}
