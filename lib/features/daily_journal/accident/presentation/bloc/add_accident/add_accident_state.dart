import 'package:equatable/equatable.dart';

abstract class AddAccidentState extends Equatable {
  const AddAccidentState();

  @override
  List<Object> get props => [];
}

class AddAccidentInitial extends AddAccidentState {}

class AddAccidentLoading extends AddAccidentState {}

class AddAccidentSuccess extends AddAccidentState {
  final String message;

   AddAccidentSuccess({required this.message});

  @override
  List<Object> get props => [message];
}

class AddAccidentFailure extends AddAccidentState {
  final String error;

  const AddAccidentFailure({required this.error});

  @override
  List<Object> get props => [error];
}