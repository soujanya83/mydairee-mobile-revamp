import 'package:equatable/equatable.dart';

abstract class UpdatePasswordEvent extends Equatable {
  @override
  List<Object?> get props => [];
}

class UpdatePasswordSubmitted extends UpdatePasswordEvent {
  final String newPassword;
  final String email;

  UpdatePasswordSubmitted({
    required this.newPassword,
    required this.email,
  });

  @override
  List<Object?> get props => [newPassword, email];
}
