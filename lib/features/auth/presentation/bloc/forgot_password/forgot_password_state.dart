import 'package:equatable/equatable.dart';

// ignore: must_be_immutable
abstract class ForgotPasswordState extends Equatable {
  String?  email;
   ForgotPasswordState(
      {this.email = ''}
   );

  @override
  List<Object?> get props => [];
}


// ignore: must_be_immutable
class ForgotPasswordInitial extends ForgotPasswordState { 
  ForgotPasswordInitial(
    {
      super.email = '',
    }
  );
  @override
  List<Object?> get props => [email];
  ForgotPasswordInitial copyWith({String? email}) {

    return ForgotPasswordInitial(email: email ?? this.email);
  }
}

// ignore: must_be_immutable
class ForgotPasswordLoading extends ForgotPasswordState {}

// ignore: must_be_immutable
class ForgotPasswordSuccess extends ForgotPasswordState {
  final String message;

  ForgotPasswordSuccess({required this.message});

  @override
  List<Object?> get props => [message];
}

// ignore: must_be_immutable
class ForgotPasswordFailure extends ForgotPasswordState {
  final String error;

  ForgotPasswordFailure({required this.error});

  @override
  List<Object?> get props => [error];
}