import 'package:image_picker/image_picker.dart';

abstract class SignupEvent  {}

class SignupSubmitted extends SignupEvent {
  final String name;
  final String username;
  final String email;
  final String password;
  final String contact;
  final String dob;
  final String? gender;
  final XFile? profileImage;

  SignupSubmitted({
    required this.name,
    required this.username,
    required this.email,
    required this.password,
    required this.contact,
    required this.dob,
    this.gender,
    this.profileImage,
  });
}