import 'package:flutter_bloc/flutter_bloc.dart';
import 'forgot_password_event.dart';
import 'forgot_password_state.dart';

class ForgotPasswordBloc
    extends Bloc<ForgotPasswordEvent, ForgotPasswordState> {
  ForgotPasswordBloc() : super(ForgotPasswordInitial()) {
    on<ForgotPasswordEmailChanged>((event, emit) {
      // Update the state with the new email
      if (state is ForgotPasswordInitial) {
        final currentState = state as ForgotPasswordInitial;
        emit(currentState.copyWith(email: event.email));
      }
    });

    on<ForgotPasswordSubmitted>((event, emit) async {
      emit(ForgotPasswordLoading());
      try {
        await Future.delayed(const Duration(seconds: 2));
      } catch (e) {
        emit(ForgotPasswordFailure(error: e.toString()));
      }
    });
  }
}
