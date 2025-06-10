import 'package:flutter_bloc/flutter_bloc.dart';
import 'otp_verify_event.dart';
import 'otp_verify_state.dart';

class OtpVerifyBloc extends Bloc<OtpVerifyEvent, OtpVerifyState> {
  OtpVerifyBloc() : super(const OtpVerifyInitial()) {
    if (state is OtpVerifyInitial) {
      on<OtpChanged>((event, emit) {
        emit((state as OtpVerifyInitial).copyWith(otp: event.otp));
      });
    }

    on<OtpSubmitted>((event, emit) async {
      emit(OtpVerifyLoading(otp: event.otp));
      await Future.delayed(const Duration(seconds: 2));
      // Dummy check: OTP must be '123456'
      if (event.otp == '123456') {
        emit(OtpVerifySuccess(otp: event.otp));
      } else {
        emit(const OtpVerifyFailure(error: 'Invalid OTP'));
      }
    });

    on<OtpResendRequested>((event, emit) async {
      emit(OtpVerifyLoading(otp: state.otp));
      await Future.delayed(const Duration(seconds: 1));
      // Simulate resend success
      emit(OtpVerifyInitial());
    });
  }
}
