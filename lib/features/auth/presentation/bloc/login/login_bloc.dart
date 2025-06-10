import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mydiaree/core/services/apiresoponse.dart';
import 'package:mydiaree/features/auth/data/repositories/auth_repository.dart';
import 'package:mydiaree/features/auth/presentation/bloc/login/login_event.dart';
import 'package:mydiaree/features/auth/presentation/bloc/login/login_state.dart';

class LoginBloc extends Bloc<LoginEvent, LoginState> {
  AuthenticationRepository repository =
      AuthenticationRepository(); // Assuming you have a Repository class to handle data operations

  LoginBloc() : super(const LoginInitial()) {
    on<EmailChanged>((event, emit) {
      if (state is LoginInitial) {
        emit((state as LoginInitial).copyWith(email: event.email));
      }
    });

    on<PasswordChanged>((event, emit) {
      if (state is LoginInitial) {
        emit((state as LoginInitial).copyWith(password: event.password));
      }
    });

    on<PasswordVisibilityChanged>((event, emit) {
      if (state is LoginInitial || state is LoginError) {
        emit((state as LoginInitial)
            .copyWith(isPasswordVisible: event.isVisible));
      }
    });
    on<RememberMeChanged>((event, emit) {
      if (state is LoginInitial) {
        emit(
            (state as LoginInitial).copyWith(isRemembered: event.isRemembered));
      }
    });
    on<LoginSubmitted>((event, emit) async {
      if (state is LoginInitial || state is LoginError) {
        emit(LoginLoading.fromState(state));
        await Future.delayed(const Duration(seconds: 2));
        try {
          final response = await repository.loginUser(
            event.email,
            event.password,
          );
          if (response.success) {
            emit(LoginSuccess(
                message: "Login successful!", loginData: response.data));
          } else {
            emit(LoginError.fromState(state, response.message.toString()));
          }
        } catch (e, s) {
          emit(LoginError.fromState(state, defaultErrorMessage().toString()));
        }
        emit(LoginInitial.fromState(state));
      }
    });
  }
}
