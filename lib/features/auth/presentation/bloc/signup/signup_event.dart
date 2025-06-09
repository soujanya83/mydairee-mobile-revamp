import 'package:equatable/equatable.dart';
import 'package:image_picker/image_picker.dart';

abstract class SignupEvent extends Equatable {
  const SignupEvent();

  @override
  List<Object?> get props => [];
}


class SignupNameChanged extends SignupEvent {
  final String name;

  const SignupNameChanged(this.name);

  @override
  List<Object?> get props => [name];
}

class SignupUsernameChanged extends SignupEvent {
  final String username;

  const SignupUsernameChanged(this.username);

  @override
  List<Object?> get props => [username];
}

class SignupEmailChanged extends SignupEvent {
  final String email;

  const SignupEmailChanged(this.email);

  @override
  List<Object?> get props => [email];
}

class SignupPasswordChanged extends SignupEvent {
  final String password;

  const SignupPasswordChanged(this.password);

  @override
  List<Object?> get props => [password];
}

class SignupContactChanged extends SignupEvent {
  final String contact;

  const SignupContactChanged(this.contact);

  @override
  List<Object?> get props => [contact];
}

class SignupGenderChanged extends SignupEvent {
  final String gender;

  const SignupGenderChanged(this.gender);

  @override
  List<Object?> get props => [gender];
}

class SignupDobChanged extends SignupEvent {
  final String dob;

  const SignupDobChanged(this.dob);

  @override
  List<Object?> get props => [dob];
}

class SignupImageChanged extends SignupEvent {
  final XFile? image;

  const SignupImageChanged(this.image);

  @override
  List<Object?> get props => [image];
}

class SignupSubmitted extends SignupEvent {
  const SignupSubmitted();
}