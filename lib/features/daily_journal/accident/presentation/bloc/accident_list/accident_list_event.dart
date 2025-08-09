import 'package:mydiaree/features/daily_journal/accident/data/models/accident_list_response_model.dart';
import 'package:mydiaree/features/daily_journal/accident/data/repositories/accident_repo.dart';

// Events
abstract class AccidentEvent {}

class LoadAccidentsEvent extends AccidentEvent {}

// Accident List Events
abstract class AccidentListEvent {}

class FetchAccidentsEvent extends AccidentListEvent {
  final String centerId;
  final String? roomId;

  FetchAccidentsEvent({
    required this.centerId,
    this.roomId,
  });
}

class FilterAccidentsByCenterEvent extends AccidentListEvent {
  final String centerId;

  FilterAccidentsByCenterEvent(this.centerId);
}

class FilterAccidentsByRoomEvent extends AccidentListEvent {
  final String roomId;

  FilterAccidentsByRoomEvent(this.roomId);
}

class SearchAccidentsEvent extends AccidentListEvent {
  final String query;

  SearchAccidentsEvent(this.query);
}

// State
abstract class AccidentState {}

class AccidentLoadingState extends AccidentState {}

class AccidentLoadedState extends AccidentState {
  final List<AccidentListData> accidents;
  AccidentLoadedState({required this.accidents});
}

class AccidentErrorState extends AccidentState {
  final String message;
  AccidentErrorState({required this.message});
}