import 'package:mydiaree/features/daily_journal/accident/data/repositories/accident_repo.dart';

abstract class AccidentState {}

class AccidentLoadingState extends AccidentState {}

class AccidentLoadedState extends AccidentState {
  final List<Accident> accidents;
  AccidentLoadedState({required this.accidents});
}

class AccidentErrorState extends AccidentState {
  final String message;
  AccidentErrorState({required this.message});
}
