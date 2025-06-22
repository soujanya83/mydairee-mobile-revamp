import 'package:mydiaree/features/auth/admin/data/models/login_model.dart';

abstract class StaffLoginState {}

class StaffLoginInitial extends StaffLoginState {}

class StaffLoginLoading extends StaffLoginState {}

class StaffLoginSuccess extends StaffLoginState {
  final String message;
  final LoginModel? loginData;

  StaffLoginSuccess({
    this.loginData,
    required this.message,
  });
}

class StaffLoginError extends StaffLoginState {
  final String message;

  StaffLoginError({
    required this.message,
  });
}
