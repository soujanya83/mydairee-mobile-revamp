abstract class OtpVerifyState {}

class OtpVerifyInitial extends OtpVerifyState {}

class OtpVerifyLoading extends OtpVerifyState {  
}

class OtpVerifySuccess extends OtpVerifyState {
   final String message;
  OtpVerifySuccess({required this.message});
}

class OtpVerifyFailure extends OtpVerifyState {
  final String message;
  OtpVerifyFailure({required this.message});
}
