import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mydiaree/features/daily_journal/daily_diaree/data/repositories/daily_diaree_reposiory.dart';
import 'package:mydiaree/features/daily_journal/daily_diaree/presentation/bloc/screen%20name/daily_diaree_event.dart';
import 'package:mydiaree/features/daily_journal/daily_diaree/presentation/bloc/screen%20name/daily_diaree_state.dart';

class DailyTrackingBloc extends Bloc<DailyTrackingEvent, DailyTrackingState> {
    DailyTrackingRepository repository = DailyTrackingRepository();

  DailyTrackingBloc() : super(DailyTrackingLoading()) {
    on<LoadDailyTrackingEvent>(_onLoadDailyTracking);
    on<SaveActivityEvent>(_onSaveActivity);
  }

  Future<void> _onLoadDailyTracking(LoadDailyTrackingEvent event, Emitter<DailyTrackingState> emit) async {
    emit(DailyTrackingLoading());
    try {
      final children = await repository.getChildren();
      emit(DailyTrackingLoaded(children: children, isActivitySaved: false));
    } catch (e) {
      emit(DailyTrackingError(message: e.toString()));
    }
  }

  Future<void> _onSaveActivity(SaveActivityEvent event, Emitter<DailyTrackingState> emit) async {
    try {
      await repository.saveActivity(event.childIds, event.activity);
      final children = await repository.getChildren();
      emit(DailyTrackingLoaded(children: children, isActivitySaved: true));
    } catch (e) {
      emit(DailyTrackingError(message: e.toString()));
    }
  }
}