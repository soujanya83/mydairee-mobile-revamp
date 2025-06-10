import 'package:equatable/equatable.dart';

abstract class OtpVerifyEvent extends Equatable {
  const OtpVerifyEvent();

  @override
  List<Object?> get props => [];
}

class OtpChanged extends OtpVerifyEvent {
  final String otp;
  const OtpChanged(this.otp);

  @override
  List<Object?> get props => [otp];
}

class OtpSubmitted extends OtpVerifyEvent {
  final String otp;
  const OtpSubmitted(this.otp);

  @override
  List<Object?> get props => [otp];
}

class OtpResendRequested extends OtpVerifyEvent {
  const OtpResendRequested();
}