import 'package:mydiaree/features/auth/data/models/login_model.dart';

abstract class LoginState {
  final String? email;
  final String? password;
  final bool? isPasswordVisible;
  final bool? isRemembered;

  const LoginState({
    this.isRemembered = false,
    this.email = '',
    this.password = '',
    this.isPasswordVisible = false,
  });
}

class LoginInitial extends LoginState {
  const LoginInitial({
    super.email = '',
    super.password = '',
    super.isPasswordVisible = false,
    super.isRemembered = false,
  });

  LoginInitial copyWith({
    bool? isRemembered,
    String? email,
    String? password,
    bool? isPasswordVisible,
  }) {
    return LoginInitial(
      isRemembered: isRemembered ?? this.isRemembered,
      email: email ?? this.email,
      password: password ?? this.password,
      isPasswordVisible: isPasswordVisible ?? this.isPasswordVisible,
    );
  }
  factory LoginInitial.fromState(LoginState state) {
    return LoginInitial(
      email: state.email,
      password: state.password,
      isPasswordVisible: state.isPasswordVisible,
      isRemembered: state.isRemembered,
    );
  }
}

class LoginLoading extends LoginState {
  const LoginLoading({
    super.email,
    super.password,
    super.isPasswordVisible,
    super.isRemembered,
  });

  factory LoginLoading.fromState(LoginState state) {
    return LoginLoading(
      email: state.email,
      password: state.password,
      isPasswordVisible: state.isPasswordVisible,
      isRemembered: state.isRemembered,
    );
  }
}

class LoginSuccess extends LoginState {
  final String message;
  final LoginModel? loginData;
  const LoginSuccess(
    {
   this.loginData,
    required this.message,
  });
}

class LoginError extends LoginState {
  final String errorMessage;
  const LoginError({
    this.errorMessage = 'An error occurred during login.',
    super.email = '',
    super.password = '',
    super.isPasswordVisible = false,
    super.isRemembered = false,
  });

  LoginError copyWith({
    String? errorMessage,
    String? email,
    String? password,
    bool? isPasswordVisible,
    bool? isRemembered,
  }) {
    return LoginError(
      errorMessage: errorMessage ?? this.errorMessage,
      email: email ?? this.email,
      password: password ?? this.password,
      isPasswordVisible: isPasswordVisible ?? this.isPasswordVisible,
      isRemembered: isRemembered ?? this.isRemembered,
    );
  }

  factory LoginError.fromState(LoginState state, String errorMessage) {
    return LoginError(
      email: state.email,
      password: state.password,
      isPasswordVisible: state.isPasswordVisible,
      isRemembered: state.isRemembered,
      errorMessage: errorMessage,
    );
  }
}
