import 'package:mydiaree/features/auth/admin/data/models/login_model.dart';
abstract class ParentLoginState {}

class ParentLoginInitial extends ParentLoginState {}

class ParentLoginLoading extends ParentLoginState {}

class ParentLoginSuccess extends ParentLoginState {
  final String message;
  final LoginModel? loginData;

  ParentLoginSuccess({
    this.loginData,
    required this.message,
  });
}

class ParentLoginError extends ParentLoginState {
  final String message;

  ParentLoginError({
    required this.message,
  });
}
