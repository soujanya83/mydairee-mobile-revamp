// 📁 add_room_event.dart
import 'package:equatable/equatable.dart';
abstract class ViewObservationEvent extends Equatable {
  const ViewObservationEvent();

  @override
  List<Object?> get props => [];
}

class FetchObservationEvent extends ViewObservationEvent {
  final String observationId;

  const FetchObservationEvent({required this.observationId});

  @override
  List<Object?> get props => [observationId];
}
