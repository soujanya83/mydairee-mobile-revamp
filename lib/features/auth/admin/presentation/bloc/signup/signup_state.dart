import 'package:equatable/equatable.dart';
import 'package:image_picker/image_picker.dart';
import 'package:mydiaree/features/auth/admin/data/models/signup_model.dart';

abstract class SignUpState {
  const SignUpState();
}

class SignUpInitial extends SignUpState {
  const SignUpInitial();
}

class SignUpLoading extends SignUpState {
  SignUpLoading();
}

class SignUpSuccess extends SignUpState {
  final String message;
  final SignupModel? signupData;
  const SignUpSuccess({
    required this.message,
    this.signupData,
  }) : super();
}

class SignUpError extends SignUpState {
  final String message;
  final SignupModel? signupData;
  const SignUpError({
    required this.message,
    this.signupData,
  }) : super();
}
