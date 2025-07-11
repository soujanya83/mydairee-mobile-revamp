import 'package:equatable/equatable.dart';

abstract class AddSnapshotState extends Equatable {
  const AddSnapshotState();

  @override
  List<Object?> get props => [];
}

class AddSnapshotInitial extends AddSnapshotState {}

class AddSnapshotLoading extends AddSnapshotState {}

class AddSnapshotSuccess extends AddSnapshotState {
  final String message;

  const AddSnapshotSuccess(this.message);

  @override
  List<Object?> get props => [message];
}

class AddSnapshotFailure extends AddSnapshotState {
  final String message;

  const AddSnapshotFailure(this.message);

  @override
  List<Object?> get props => [message];
}