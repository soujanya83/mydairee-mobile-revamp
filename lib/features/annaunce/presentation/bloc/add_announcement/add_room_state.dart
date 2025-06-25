
// 📁 add_room_state.dart
import 'package:equatable/equatable.dart';

abstract class AddAnnounceState extends Equatable {
  const AddAnnounceState();

  @override
  List<Object?> get props => [];
}

class AddAnnounceInitial extends AddAnnounceState {}

class AddAnnounceLoading extends AddAnnounceState {}

class AddAnnounceSuccess extends AddAnnounceState {
  final String message;

  const AddAnnounceSuccess(this.message);

  @override
  List<Object?> get props => [message];
}

class AddAnnounceFailure extends AddAnnounceState {
  final String error;

  const AddAnnounceFailure(this.error);

  @override
  List<Object?> get props => [error];
}
