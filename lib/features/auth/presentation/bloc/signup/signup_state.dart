import 'package:equatable/equatable.dart';
import 'package:image_picker/image_picker.dart';
import 'package:mydiaree/features/auth/data/models/signup_model.dart';

abstract class SignUpState {
  final String? name;
  final String? username;
  final String? email;
  final String? password;
  final String? contact;
  final String? gender;
  final String? dob;
  final XFile? profileImage;
  final bool? isPasswordVisible ;
  final SignupModel? signupData;

  const SignUpState({
    this.name = '',
    this.username = '',
    this.email = '',
    this.password = '',
    this.contact = '',
    this.gender = 'Select Gender',
    this.dob = '',
    this.profileImage,
    this.isPasswordVisible = false, 
    this.signupData,
  });
}

class SignUpInitial extends SignUpState {
  const SignUpInitial({
    super.name = '',
    super.username = '',
    super.email = '',
    super.password = '',
    super.contact = '',
    super.gender = 'Select Gender',
    super.dob = '',
    super.profileImage,
    super.isPasswordVisible = false, 
    super.signupData,
  });

  SignUpInitial copyWith({
    String? name,
    String? username,
    String? email,
    String? password,
    String? contact,
    String? gender,
    String? dob,
    XFile? profileImage,
    bool? isPasswordVisible,
    bool? isSubmitting,
    SignupModel? signupData,
  }) {
    return SignUpInitial(
      name: name ?? this.name,
      username: username ?? this.username,
      email: email ?? this.email,
      password: password ?? this.password,
      contact: contact ?? this.contact,
      gender: gender ?? this.gender,
      dob: dob ?? this.dob,
      profileImage: profileImage ?? this.profileImage,
      isPasswordVisible: isPasswordVisible ?? this.isPasswordVisible,
      signupData: signupData ?? this.signupData,
    );
  }
}

class SignUpLoading extends SignUpState {
  const SignUpLoading({
    super.name,
    super.username,
    super.email,
    super.password,
    super.contact,
    super.gender,
    super.dob,
    super.profileImage,
    super.isPasswordVisible, 
    super.signupData,
  });

  factory SignUpLoading.fromState(SignUpState state) {
    return SignUpLoading(
      name: state.name,
      username: state.username,
      email: state.email,
      password: state.password,
      contact: state.contact,
      gender: state.gender,
      dob: state.dob,
      profileImage: state.profileImage,
      isPasswordVisible: state.isPasswordVisible, 
      signupData: state.signupData,
    );
  }
}

class SignUpSuccess extends SignUpState {
  final String message;
  final SignupModel? signupData;
  const SignUpSuccess({
    required this.message,
    this.signupData,
  }) : super(signupData: signupData);
}

class SignUpError extends SignUpState {
  final String errorMessage;
  const SignUpError({
    this.errorMessage = 'An error occurred during signup.',
    super.name = '',
    super.username = '',
    super.email = '',
    super.password = '',
    super.contact = '',
    super.gender = 'Select Gender',
    super.dob = '',
    super.profileImage,
    super.isPasswordVisible = false, 
    super.signupData,
  });

  SignUpError copyWith({
    String? errorMessage,
    String? name,
    String? username,
    String? email,
    String? password,
    String? contact,
    String? gender,
    String? dob,
    XFile? profileImage,
    bool? isPasswordVisible,
    bool? isSubmitting,
    SignupModel? signupData,
  }) {
    return SignUpError(
      errorMessage: errorMessage ?? this.errorMessage,
      name: name ?? this.name,
      username: username ?? this.username,
      email: email ?? this.email,
      password: password ?? this.password,
      contact: contact ?? this.contact,
      gender: gender ?? this.gender,
      dob: dob ?? this.dob,
      profileImage: profileImage ?? this.profileImage,
      isPasswordVisible: isPasswordVisible ?? this.isPasswordVisible, 
      signupData: signupData ?? this.signupData,
    );
  }

  factory SignUpError.fromState(SignUpState state, String errorMessage) {
    return SignUpError(
      name: state.name,
      username: state.username,
      email: state.email,
      password: state.password,
      contact: state.contact,
      gender: state.gender,
      dob: state.dob,
      profileImage: state.profileImage,
      isPasswordVisible: state.isPasswordVisible, 
      signupData: state.signupData,
      errorMessage: errorMessage,
    );
  }
}