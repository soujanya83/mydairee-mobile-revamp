// 📁 add_room_state.dart
import 'package:equatable/equatable.dart';
import 'package:mydiaree/features/observation/data/model/observation_model.dart';

abstract class ViewObservationState extends Equatable {
  const ViewObservationState();

  @override
  List<Object?> get props => [];
}

class ViewObservationInitial extends ViewObservationState {}

class ViewObservationLoading extends ViewObservationState {}

class ViewObservationLoaded extends ViewObservationState {
  final ObservationModel data;

  const ViewObservationLoaded(this.data);

  @override
  List<Object?> get props => [data];
}

class ViewObservationFailure extends ViewObservationState {
  final String error;

  const ViewObservationFailure(this.error);

  @override
  List<Object?> get props => [error];
}
