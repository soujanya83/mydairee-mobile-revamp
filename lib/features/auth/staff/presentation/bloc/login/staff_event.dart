abstract class StaffLoginEvent {}

class StaffLoginSubmitted extends StaffLoginEvent {
  final String employeeCode;
  final String pin;

  StaffLoginSubmitted({
    required this.employeeCode,
    required this.pin,
  });
}
