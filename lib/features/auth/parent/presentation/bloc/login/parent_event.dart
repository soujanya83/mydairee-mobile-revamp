abstract class ParentLoginEvent {}

class ParentLoginSubmitted extends ParentLoginEvent {
  final String email;
  final String password;

  ParentLoginSubmitted({
    required this.email,
    required this.password,
  });
}
