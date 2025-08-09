import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mydiaree/features/observation/data/model/observation_detail_model.dart';
import 'package:mydiaree/features/observation/data/repositories/observation_repositories.dart';
import 'package:mydiaree/features/observation/presentation/bloc/add_room/view_observation_event.dart';
import 'package:mydiaree/features/observation/presentation/bloc/add_room/view_observation_state.dart';

class ViewObservationBloc extends Bloc<ViewObservationEvent, ViewObservationState> {
  final ObservationRepository _repository = ObservationRepository();
  
  ViewObservationBloc() : super(ViewObservationInitial()) {
    on<FetchObservationEvent>(_onFetchObservation);
  }
  
  Future<void> _onFetchObservation(
    FetchObservationEvent event,
    Emitter<ViewObservationState> emit,
  ) async {
    emit(ViewObservationLoading());
    try {
      final response = await _repository.viewObservationDetail(
        observationId: event.observationId,
      );
      
      if (response.success && response.data != null) {
        emit(ViewObservationLoaded(data: response.data!));
      } else {
        emit(ViewObservationFailure(error: response.message));
      }
    } catch (e) {
      emit(ViewObservationFailure(error: 'Failed to load observation: $e'));
    }
  }
}
