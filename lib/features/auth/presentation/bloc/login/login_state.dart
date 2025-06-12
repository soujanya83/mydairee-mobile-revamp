import 'package:mydiaree/features/auth/data/models/login_model.dart';

abstract class LoginState {}

class LoginInitial extends LoginState {}

class LoginLoading extends LoginState {}

class LoginSuccess extends LoginState {
  final String message;
  final LoginModel? loginData;
  LoginSuccess({
    this.loginData,
    required this.message,
  });
}

class LoginError extends LoginState {
  final String message;
  LoginError({
    required this.message,
  });
}
