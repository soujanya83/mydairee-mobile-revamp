import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mydiaree/features/auth/admin/data/repositories/auth_repository.dart';
import 'otp_verify_event.dart';
import 'otp_verify_state.dart';

class OtpVerifyBloc extends Bloc<OtpVerifyEvent, OtpVerifyState> {
  AdminAuthenticationRepository repository = AdminAuthenticationRepository();
  OtpVerifyBloc() : super(OtpVerifyInitial()) {
    on<OtpSubmitted>((event, emit) async {
      emit(OtpVerifyLoading());
      final response =
          await repository.otpVerify(email: event.email, otp: event.otp);
      if (response.success) {
        emit(OtpVerifySuccess(message: response.message));
      } else {
        emit(OtpVerifyFailure(message: response.message));
      }
    });

    on<OtpResendRequested>((event, emit) async {
      emit(OtpVerifyLoading());
      await Future.delayed(const Duration(seconds: 1));
      emit(OtpVerifyInitial());
    });
  }
}
