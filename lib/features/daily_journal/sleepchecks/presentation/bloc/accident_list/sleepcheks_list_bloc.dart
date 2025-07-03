import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mydiaree/features/daily_journal/accident/data/repositories/accident_repo.dart';
import 'package:mydiaree/features/daily_journal/accident/presentation/bloc/accident_list/accident_list_event.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mydiaree/features/daily_journal/sleepchecks/data/repositories/sleep_checks_repo.dart';
import 'package:mydiaree/features/daily_journal/sleepchecks/presentation/bloc/accident_list/sleepchecks_list_event.dart';
import 'package:mydiaree/features/daily_journal/sleepchecks/presentation/bloc/accident_list/sleepcheks_list_state.dart';

class SleepChecklistBloc
    extends Bloc<SleepChecklistEvent, SleepChecklistState> {
  final SleepChecklistRepository repository = SleepChecklistRepository();

  SleepChecklistBloc() : super(SleepChecklistInitial()) {
    on<FetchSleepChecklistEvent>(_onFetchSleepChecklist);
    on<AddSleepCheckEvent>(_onAddSleepCheck);
    on<UpdateSleepCheckEvent>(_onUpdateSleepCheck);
    on<DeleteSleepCheckEvent>(_onDeleteSleepCheck);
  }

  Future<void> _onFetchSleepChecklist(
      FetchSleepChecklistEvent event, Emitter<SleepChecklistState> emit) async {
    emit(SleepChecklistLoading());
    try {
      final sleepChecks = await repository.getSleepChecklist(
        userId: event.userId,
        centerId: event.centerId,
        roomId: event.roomId,
        date: event.date,
      );
      emit(SleepChecklistLoaded(sleepChecks: sleepChecks.data?.children ?? []));
    } catch (e) {
      emit(SleepChecklistFailure(error: e.toString()));
    }
  }

  Future<void> _onAddSleepCheck(
      AddSleepCheckEvent event, Emitter<SleepChecklistState> emit) async {
    emit(SleepChecklistLoading());
    try {
      await repository.addUpdateSleepCheck(
        userId: event.userId,
        childId: event.childId,
        roomId: event.roomId,
        diaryDate: event.diaryDate,
        time: event.time,
        breathing: event.breathing,
        bodyTemperature: event.bodyTemperature,
        notes: event.notes,
      );
      emit(SleepChecklistSuccess(message: 'Sleep check added successfully'));
      add(FetchSleepChecklistEvent(
        userId: event.userId,
        centerId: event.centerId,
        roomId: event.roomId,
        date: event.diaryDate,
      ));
    } catch (e) {
      emit(SleepChecklistFailure(error: e.toString()));
    }
  }

  Future<void> _onUpdateSleepCheck(
      UpdateSleepCheckEvent event, Emitter<SleepChecklistState> emit) async {
    emit(SleepChecklistLoading());
    try {
      await repository.addUpdateSleepCheck(
        userId: event.userId,
        id: event.id,
        childId: event.childId,
        roomId: event.roomId,
        diaryDate: event.diaryDate,
        time: event.time,
        breathing: event.breathing,
        bodyTemperature: event.bodyTemperature,
        notes: event.notes,
      );
      emit(const SleepChecklistSuccess(message: 'Sleep check updated successfully'));
      add(FetchSleepChecklistEvent(
        userId: event.userId,
        centerId: event.centerId,
        roomId: event.roomId,
        date: event.diaryDate,
      ));
    } catch (e) {
      emit(SleepChecklistFailure(error: e.toString()));
    }
  }

  Future<void> _onDeleteSleepCheck(
      DeleteSleepCheckEvent event, Emitter<SleepChecklistState> emit) async {
    emit(SleepChecklistLoading());
    try {
      await repository.deleteSleepCheck(userId: event.userId, id: event.id);
      emit(SleepChecklistSuccess(message: 'Sleep check deleted successfully'));
      add(FetchSleepChecklistEvent(
        userId: event.userId,
        centerId: event.centerId,
        roomId: event.roomId,
        date: event.diaryDate,
      ));
    } catch (e) {
      emit(SleepChecklistFailure(error: e.toString()));
    }
  }
}
