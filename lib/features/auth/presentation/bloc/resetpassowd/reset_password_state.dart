import 'package:equatable/equatable.dart';

abstract class UpdatePasswordState extends Equatable {
  final String? newPassword;
  final String? confirmPassword;

  const UpdatePasswordState(this.newPassword, this.confirmPassword);

  @override
  List<Object?> get props => [newPassword, confirmPassword];

  UpdatePasswordState copyWith({
    String? newPassword,
    String? confirmPassword,
  });
}

class UpdatePasswordInitial extends UpdatePasswordState {
  const UpdatePasswordInitial({String? newPassword, String? confirmPassword})
      : super(newPassword, confirmPassword);

  @override
  UpdatePasswordInitial copyWith({
    String? newPassword,
    String? confirmPassword,
  }) {
    return UpdatePasswordInitial(
      newPassword: newPassword ?? this.newPassword,
      confirmPassword: confirmPassword ?? this.confirmPassword,
    );
  }
}

class UpdatePasswordSubmitting extends UpdatePasswordState {
  const UpdatePasswordSubmitting({String? newPassword, String? confirmPassword})
      : super(newPassword, confirmPassword);

  @override
  UpdatePasswordSubmitting copyWith({
    String? newPassword,
    String? confirmPassword,
  }) {
    return UpdatePasswordSubmitting(
      newPassword: newPassword ?? this.newPassword,
      confirmPassword: confirmPassword ?? this.confirmPassword,
    );
  }
}

class UpdatePasswordSuccess extends UpdatePasswordState {
  const UpdatePasswordSuccess({String? newPassword, String? confirmPassword})
      : super(newPassword, confirmPassword);

  @override
  UpdatePasswordSuccess copyWith({
    String? newPassword,
    String? confirmPassword,
  }) {
    return UpdatePasswordSuccess(
      newPassword: newPassword ?? this.newPassword,
      confirmPassword: confirmPassword ?? this.confirmPassword,
    );
  }
}

class UpdatePasswordFailure extends UpdatePasswordState {
  final String? errorMessage;

  const UpdatePasswordFailure(
      {this.errorMessage, String? newPassword, String? confirmPassword})
      : super(newPassword, confirmPassword);

  @override
  List<Object?> get props => [errorMessage, newPassword, confirmPassword];

  @override
  UpdatePasswordFailure copyWith({
    String? newPassword,
    String? confirmPassword,
    String? errorMessage,
  }) {
    return UpdatePasswordFailure(
      errorMessage: errorMessage ?? this.errorMessage,
      newPassword: newPassword ?? this.newPassword,
      confirmPassword: confirmPassword ?? this.confirmPassword,
    );
  }
}
