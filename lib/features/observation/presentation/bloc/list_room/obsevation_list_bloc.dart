import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:mydiaree/features/observation/data/repositories/observation_repositories.dart';
import 'package:mydiaree/features/observation/presentation/bloc/list_room/observation_list_event.dart';
import 'package:mydiaree/features/observation/presentation/bloc/list_room/observation_list_state.dart';
import 'package:mydiaree/features/room/data/repositories/room_repositories.dart';
import 'package:mydiaree/features/room/presentation/bloc/list_room/list_room_event.dart';
import 'package:mydiaree/features/room/presentation/bloc/list_room/list_room_state.dart';

class ObservationListBloc
    extends Bloc<ObservationListEvent, ObservationListState> {
  ObservationRepository observationRepository = ObservationRepository();
  ObservationListBloc() : super(ObservationListInitial()) {
    on<FetchObservationsEvent>(_onFetchObservations);
    on<DeleteSelectedObservationsEvent>(_onDeleteObservations);
  }

  Future<void> _onFetchObservations(
    FetchObservationsEvent event,
    Emitter<ObservationListState> emit,
  ) async {
    emit(ObservationListLoading());
    try {
      final response = await observationRepository.getObservations(
        centerId: event.centerId,
      );

      if (response.success && response.data != null) {
        emit(ObservationListLoaded(
          observationsData: response.data!,
        ));
      } else {
        emit(ObservationListError(message: response.message));
      }
    } catch (e) {
      emit(ObservationListError(message: 'Failed to fetch observations: $e'));
    }
  }

  Future<void> _onDeleteObservations(
    DeleteSelectedObservationsEvent event,
    Emitter<ObservationListState> emit,
  ) async {
    emit(ObservationListLoading());
    try {
      final response = await observationRepository.deleteObservations(
          observationId: event.observationsId);
      if (response.success) {
        add(FetchObservationsEvent(centerId: event.centerId));
      } else {
        emit(ObservationListError(message: response.message));
      }
    } catch (e) {
      emit(
          const ObservationListError(message: 'Failed to delete observations'));
    }
  }
}
