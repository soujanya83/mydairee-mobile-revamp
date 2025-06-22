import 'package:equatable/equatable.dart';

abstract class UpdatePasswordState {}

class UpdatePasswordInitial extends UpdatePasswordState {}

class UpdatePasswordSubmitting extends UpdatePasswordState {
  UpdatePasswordSubmitting(
      {String? newPassword, String? confirmPassword, String? email});
}

class UpdatePasswordSuccess extends UpdatePasswordState {
  final String? message;
  UpdatePasswordSuccess({
    String? newPassword,
    this.message,
    String? email,
    String? confirmPassword,
  });
}

class UpdatePasswordFailure extends UpdatePasswordState {
  final String? message;
  UpdatePasswordFailure({
    String? newPassword,
    this.message,
    String? email,
    String? confirmPassword,
  });
}
