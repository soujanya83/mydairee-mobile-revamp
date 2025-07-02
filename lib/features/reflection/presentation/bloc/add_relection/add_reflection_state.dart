import 'package:equatable/equatable.dart';

abstract class AddReflectionState extends Equatable {
  const AddReflectionState();

  @override
  List<Object?> get props => [];
}

class AddReflectionInitial extends AddReflectionState {}

class AddReflectionLoading extends AddReflectionState {}

class AddReflectionSuccess extends AddReflectionState {
  final String message;

  const AddReflectionSuccess(this.message);

  @override
  List<Object?> get props => [message];
}

class AddReflectionFailure extends AddReflectionState {
  final String message;

  const AddReflectionFailure(this.message);

  @override
  List<Object?> get props => [message];
}