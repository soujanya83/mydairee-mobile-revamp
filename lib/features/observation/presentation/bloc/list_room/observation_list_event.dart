import 'package:equatable/equatable.dart';
abstract class ObservationListEvent extends Equatable {
  const ObservationListEvent();

  @override
  List<Object> get props => [];
}

class FetchObservationsEvent extends ObservationListEvent {
  final String centerId;

  const FetchObservationsEvent({required this.centerId});

  @override
  List<Object> get props => [centerId];
}

class DeleteSelectedObservationsEvent extends ObservationListEvent {
  final String observationsId;
  final String centerId;
  const DeleteSelectedObservationsEvent(this.observationsId, {required this.centerId});

  @override
  List<Object> get props => [observationsId, centerId];
}
