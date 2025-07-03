import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mydiaree/features/daily_journal/accident/data/repositories/accident_repo.dart';
import 'package:mydiaree/features/daily_journal/accident/presentation/bloc/accident_list/accident_list_event.dart';

class AccidentBloc extends Bloc<AccidentEvent, AccidentState> {
  AccidentRepository repository = AccidentRepository();

  AccidentBloc() : super(AccidentLoadingState()) {
    on<LoadAccidentsEvent>((event, emit) async {
      emit(AccidentLoadingState());
      try {
        final accidents = await repository.fetchAccidents();
        emit(AccidentLoadedState(accidents: accidents));
      } catch (e) {
        emit(AccidentErrorState(message: e.toString()));
      }
    }); 
  }
}
