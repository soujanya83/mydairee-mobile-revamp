import 'package:flutter_bloc/flutter_bloc.dart';
import 'otp_verify_event.dart';
import 'otp_verify_state.dart';

class OtpVerifyBloc extends Bloc<OtpVerifyEvent, OtpVerifyState> {
  OtpVerifyBloc() : super(OtpVerifyInitial()) {
    on<OtpSubmitted>((event, emit) async {
      emit(OtpVerifyLoading());
      await Future.delayed(const Duration(seconds: 2));
      if (event.otp == '123456') {
        emit(OtpVerifySuccess(message: 'Successfull'));
      } else {
        emit(OtpVerifyFailure(message: 'Invalid OTP'));
      }
    });

    on<OtpResendRequested>((event, emit) async {
      emit(OtpVerifyLoading());
      await Future.delayed(const Duration(seconds: 1));
      emit(OtpVerifyInitial());
    });
  }
}
