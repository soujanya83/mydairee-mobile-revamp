import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mydiaree/core/services/apiresoponse.dart';
import 'package:mydiaree/features/auth/admin/data/repositories/auth_repository.dart';
import 'package:mydiaree/features/auth/admin/presentation/bloc/login/login_event.dart';
import 'package:mydiaree/features/auth/admin/presentation/bloc/login/login_state.dart';

class LoginBloc extends Bloc<LoginEvent, LoginState> {
  AdminAuthenticationRepository repository = AdminAuthenticationRepository();
  LoginBloc() : super(LoginInitial()) {
    on<LoginSubmitted>((event, emit) async {
      if (state is LoginInitial || state is LoginError) {
        emit(LoginLoading());
        try {
          final response = await repository.loginUser(
            event.email,
            event.password,
          );
          if (response.success){
            emit(LoginSuccess(
                message: response.data?.message??'', loginData: response.data));
          } else {
            emit(LoginError(message: response.message));
          }
        } catch (e, s) {
          emit(LoginError(message: defaultErrorMessage()));
        }
        emit(LoginInitial());
      }
    });
  }
}
