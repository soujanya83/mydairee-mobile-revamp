abstract class LoginEvent {}

class EmailChanged extends LoginEvent {
  final String email;
  EmailChanged(this.email);
}

class PasswordChanged extends LoginEvent {
  final String password;
  PasswordChanged(this.password);
}

class PasswordVisibilityChanged extends LoginEvent {
  final bool isVisible;
  PasswordVisibilityChanged(this.isVisible);
}

class LoginSubmitted extends LoginEvent {
  final String email;
  final String password;
  LoginSubmitted({required this.email, required this.password});
}

class RememberMeChanged extends LoginEvent {
  final bool isRemembered;
  RememberMeChanged({required this.isRemembered});
}
