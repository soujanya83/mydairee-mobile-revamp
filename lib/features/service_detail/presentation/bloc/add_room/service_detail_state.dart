
// State
import 'package:equatable/equatable.dart';

abstract class ServiceDetailState extends Equatable {
  const ServiceDetailState();

  @override
  List<Object?> get props => [];
}

class ServiceDetailInitial extends ServiceDetailState {}

class ServiceDetailLoading extends ServiceDetailState {}

class ServiceDetailSuccess extends ServiceDetailState {
  final String message;
  const ServiceDetailSuccess(this.message);

  @override
  List<Object?> get props => [message];
}

class ServiceDetailFailure extends ServiceDetailState {
  final String error;
  const ServiceDetailFailure(this.error);

  @override
  List<Object?> get props => [error];
}
