import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mydiaree/features/auth/presentation/bloc/resetpassowd/reset_password_event.dart';
import 'package:mydiaree/features/auth/presentation/bloc/resetpassowd/reset_password_state.dart';

class UpdatePasswordBloc extends Bloc<UpdatePasswordEvent, UpdatePasswordState> {
  UpdatePasswordBloc() : super(const UpdatePasswordInitial()) {
    on<UpdatePasswordNewPasswordChanged>((event, emit) {
      emit(state.copyWith(newPassword: event.newPassword));
    });

    on<UpdatePasswordConfirmPasswordChanged>((event, emit) {
      emit(state.copyWith(confirmPassword: event.confirmPassword));
    });
    
    on<UpdatePasswordSubmitted>((event, emit) async {
      emit(UpdatePasswordSubmitting(
        newPassword: state.newPassword,
        confirmPassword: state.confirmPassword,
      ));

      // Simple validation example
      if ((state.newPassword ?? '').isEmpty || (state.confirmPassword ?? '').isEmpty) {
        emit(UpdatePasswordFailure(
          errorMessage: 'Please fill all fields',
          newPassword: state.newPassword,
          confirmPassword: state.confirmPassword,
        ));
        return;
      }
      if (state.newPassword != state.confirmPassword) {
        emit(UpdatePasswordFailure(
          errorMessage: 'Passwords do not match',
          newPassword: state.newPassword,
          confirmPassword: state.confirmPassword,
        ));
        return;
      }

      // Simulate API call
      await Future.delayed(const Duration(seconds: 2));
      // On success
      emit(UpdatePasswordSuccess(
        newPassword: state.newPassword,
        confirmPassword: state.confirmPassword,
      ));
    });
  }
}