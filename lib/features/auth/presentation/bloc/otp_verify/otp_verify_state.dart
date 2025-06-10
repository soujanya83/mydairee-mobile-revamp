import 'package:equatable/equatable.dart';

abstract class OtpVerifyState extends Equatable {
  final String? otp;

  const OtpVerifyState({
    this.otp = '',
  });

  @override
  List<Object?> get props => [
        otp,
      ];
}

class OtpVerifyInitial extends OtpVerifyState {
  const OtpVerifyInitial({super.otp = ''}) : super();

    OtpVerifyInitial copyWith({String? otp}) {
    return OtpVerifyInitial(otp: this.otp);
  }

  factory OtpVerifyInitial.fromState(OtpVerifyState state) {
    return OtpVerifyInitial(
      otp: state.otp,
    );
  }
}

class OtpVerifyLoading extends OtpVerifyState {
  const OtpVerifyLoading({super.otp});
}

class OtpVerifySuccess extends OtpVerifyState {
  const OtpVerifySuccess({super.otp});
}

class OtpVerifyFailure extends OtpVerifyState {
  final String error;
  const OtpVerifyFailure({required this.error, super.otp});

  @override
  List<Object?> get props => [otp, error];
}
