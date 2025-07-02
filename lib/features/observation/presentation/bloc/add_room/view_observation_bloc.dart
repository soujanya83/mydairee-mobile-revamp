import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mydiaree/features/observation/data/repositories/observation_repositories.dart';
import 'package:mydiaree/features/observation/presentation/bloc/add_room/view_observation_event.dart';
import 'package:mydiaree/features/observation/presentation/bloc/add_room/view_observation_state.dart';

class ViewObservationBloc
    extends Bloc<ViewObservationEvent, ViewObservationState> {
  final ObservationRepository repository = ObservationRepository();

  ViewObservationBloc() : super(ViewObservationInitial()) {
    on<FetchObservationEvent>((event, emit) async {
      print('fetching observation with id: ${event.observationId}');
      emit(ViewObservationLoading());
      try {
        final observation = await repository.viewObservation(
            observationId: event.observationId);

        emit(ViewObservationLoaded(observation.data!));
      } catch (e, s) {
        print(s.toString());
        print(e.toString());
        emit(ViewObservationFailure(e.toString()));
      }
    });
  }
}
