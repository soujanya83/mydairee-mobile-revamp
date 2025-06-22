abstract class OtpVerifyEvent {
  const OtpVerifyEvent();
}

class OtpSubmitted extends OtpVerifyEvent {
  final String otp;
  final String email;
  const OtpSubmitted(this.otp, this.email);
}

class OtpResendRequested extends OtpVerifyEvent {
  const OtpResendRequested();
}
