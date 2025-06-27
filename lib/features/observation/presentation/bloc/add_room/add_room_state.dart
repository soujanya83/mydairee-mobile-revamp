
// 📁 add_room_state.dart
import 'package:equatable/equatable.dart';

abstract class AddRoomState extends Equatable {
  const AddRoomState();

  @override
  List<Object?> get props => [];
}

class AddRoomInitial extends AddRoomState {}

class AddRoomLoading extends AddRoomState {}

class AddRoomSuccess extends AddRoomState {
  final String message;

  const AddRoomSuccess(this.message);

  @override
  List<Object?> get props => [message];
}

class AddRoomFailure extends AddRoomState {
  final String error;

  const AddRoomFailure(this.error);

  @override
  List<Object?> get props => [error];
}
