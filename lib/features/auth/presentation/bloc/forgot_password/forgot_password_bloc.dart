import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mydiaree/features/auth/data/repositories/auth_repository.dart';
import 'forgot_password_event.dart';
import 'forgot_password_state.dart';

class ForgotPasswordBloc
    extends Bloc<ForgotPasswordEvent, ForgotPasswordState> {
  AuthenticationRepository repository = AuthenticationRepository();
  ForgotPasswordBloc() : super(ForgotPasswordInitial()) {
    on<ForgotPasswordSubmitted>((event, emit) async {
      if (state is ForgotPasswordInitial || state is ForgotPasswordFailure){
        emit(ForgotPasswordLoading());
        try {
          final response = await repository.forgotPassword(email: event.email);
          if (response.success) {
            emit(ForgotPasswordSuccess(message: response.message));
          } else {
            emit(ForgotPasswordFailure(error: response.message));
          }
        } catch (e) {
          emit(ForgotPasswordFailure(error: e.toString()));
        }
      }
    });
  }
}
