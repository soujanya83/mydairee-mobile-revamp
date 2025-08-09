import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mydiaree/features/daily_journal/accident/data/repositories/accident_repo.dart';
import 'package:mydiaree/features/daily_journal/accident/presentation/bloc/accident_list/accident_list_event.dart';
import 'package:mydiaree/features/daily_journal/accident/presentation/bloc/accident_list/accident_list_state.dart';

class AccidentListBloc extends Bloc<AccidentListEvent, AccidentListState> {
  final AccidentRepository repository = AccidentRepository();
  
  AccidentListBloc() : super(AccidentListInitial()) {
    on<FetchAccidentsEvent>(_onFetchAccidents);
    on<FilterAccidentsByCenterEvent>(_onFilterByCenter);
    on<FilterAccidentsByRoomEvent>(_onFilterByRoom);
    on<SearchAccidentsEvent>(_onSearchAccidents);
  }
  
  Future<void> _onFetchAccidents(
    FetchAccidentsEvent event,
    Emitter<AccidentListState> emit,
  ) async {
    emit(AccidentListLoading());
    
    try {
      final response = await repository.getAccidents(
        centerId: event.centerId,
        roomId: event.roomId,
      );
      
      if (response.success && response.data != null) {
        emit(AccidentListLoaded(
          response: response.data!,
          selectedCenterId: event.centerId,
          selectedRoomId: event.roomId,
        ));
      } else {
        emit(AccidentListError(response.message));
      }
    } catch (e) {
      emit(AccidentListError('Failed to load accidents: ${e.toString()}'));
    }
  }
  
  void _onFilterByCenter(
    FilterAccidentsByCenterEvent event,
    Emitter<AccidentListState> emit,
  ) {
    if (state is AccidentListLoaded) {
      add(FetchAccidentsEvent(
        centerId: event.centerId,
        roomId: (state as AccidentListLoaded).selectedRoomId,
      ));
    }
  }
  
  void _onFilterByRoom(
    FilterAccidentsByRoomEvent event,
    Emitter<AccidentListState> emit,
  ) {
    if (state is AccidentListLoaded) {
      add(FetchAccidentsEvent(
        centerId: (state as AccidentListLoaded).selectedCenterId ?? '1',
        roomId: event.roomId,
      ));
    }
  }
  
  void _onSearchAccidents(
    SearchAccidentsEvent event,
    Emitter<AccidentListState> emit,
  ) {
    if (state is AccidentListLoaded) {
      final currentState = state as AccidentListLoaded;
      emit(currentState.copyWith(searchQuery: event.query));
    }
  }
}
