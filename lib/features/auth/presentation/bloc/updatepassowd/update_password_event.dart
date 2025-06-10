import 'package:equatable/equatable.dart';

abstract class UpdatePasswordEvent extends Equatable {
  const UpdatePasswordEvent();

  @override
  List<Object?> get props => [];
}

class UpdatePasswordOldPasswordChanged extends UpdatePasswordEvent {
  final String oldPassword;

  const UpdatePasswordOldPasswordChanged(this.oldPassword);

  @override
  List<Object?> get props => [oldPassword];
}

class UpdatePasswordNewPasswordChanged extends UpdatePasswordEvent {
  final String newPassword;

  const UpdatePasswordNewPasswordChanged(this.newPassword);

  @override
  List<Object?> get props => [newPassword];
}

class UpdatePasswordConfirmPasswordChanged extends UpdatePasswordEvent {
  final String confirmPassword;

  const UpdatePasswordConfirmPasswordChanged(this.confirmPassword);

  @override
  List<Object?> get props => [confirmPassword];
}

class UpdatePasswordSubmitted extends UpdatePasswordEvent {
  const UpdatePasswordSubmitted();
}
