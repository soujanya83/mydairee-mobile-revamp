abstract class UserTypeEvent {}

class SelectUserTypeEvent extends UserTypeEvent {
  final String userType;

  SelectUserTypeEvent(this.userType);
}

class ButtonPressEvent extends UserTypeEvent {}
