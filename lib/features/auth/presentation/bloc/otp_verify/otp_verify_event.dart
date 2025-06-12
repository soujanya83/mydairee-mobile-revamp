abstract class OtpVerifyEvent {
  const OtpVerifyEvent();
}

class OtpSubmitted extends OtpVerifyEvent {
  final String otp;
  const OtpSubmitted(this.otp);
}

class OtpResendRequested extends OtpVerifyEvent {
  const OtpResendRequested();
}
