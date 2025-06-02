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
