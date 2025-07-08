import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mydiaree/features/daily_journal/headchecks/data/repositories/headchecks_repo.dart';
import 'package:mydiaree/features/daily_journal/headchecks/presentation/bloc/accident_list/heachckecks_list_state.dart';
import 'package:mydiaree/features/daily_journal/headchecks/presentation/bloc/accident_list/headchecks_list_event.dart';

class HeadChecksBloc extends Bloc<HeadChecksEvent, HeadChecksState> {
    HeadChecksRepository repository = HeadChecksRepository();

  HeadChecksBloc() : super(HeadChecksInitial()) {
    on<LoadHeadChecksInitial>(_onLoadInitial);  
    on<AddHeadCheckEvent>(_onAddHeadCheck);
    on<RemoveHeadCheckEvent>(_onRemoveHeadCheck);
    on<UpdateHeadCheckEvent>(_onUpdateHeadCheck);
    on<SaveHeadChecksEvent>(_onSaveHeadChecks);
  }

  Future<void> _onLoadInitial(LoadHeadChecksInitial event, Emitter<HeadChecksState> emit) async {
    emit(HeadChecksLoading());
    try {  
      final headChecksResponse = await repository.getHeadChecksData(
        userId: event.userId,
        centerId: '',
        roomId: null,
        date: DateTime.now(),
      );
      if (!headChecksResponse.success) {
        emit(HeadChecksError(message: headChecksResponse.message,));
        return;
      }
      final headCheckList = headChecksResponse.data;
      emit(HeadChecksLoaded( 
        currentCenterIndex: 0, 
        currentRoomIndex: 0,
        date: DateTime.now(),
        headChecks: headCheckList!=null && headCheckList.headChecks.isNotEmpty
            ? headCheckList.headChecks
                .map((model) => HeadCheckData.fromModel(model))
                .toList()
            : [
                HeadCheckData(
                  hour: '1h',
                  minute: '0m',
                  headCountController: TextEditingController(),
                  signatureController: TextEditingController(),
                  commentsController: TextEditingController(),
                ),
              ],
        userId: event.userId,
      ));
    } catch (e) {
      emit(HeadChecksError( message: ''));
    }
  }


  void _onAddHeadCheck(AddHeadCheckEvent event, Emitter<HeadChecksState> emit) {
    if (state is HeadChecksLoaded) {
      final currentState = state as HeadChecksLoaded;
      final newHeadChecks = List<HeadCheckData>.from(currentState.headChecks)
        ..add(HeadCheckData(
          hour: '1h',
          minute: '0m',
          headCountController: TextEditingController(),
          signatureController: TextEditingController(),
          commentsController: TextEditingController(),
        ));
      emit(currentState.copyWith(headChecks: newHeadChecks));
    }
  }

  void _onRemoveHeadCheck(RemoveHeadCheckEvent event, Emitter<HeadChecksState> emit) {
    if (state is HeadChecksLoaded) {
      final currentState = state as HeadChecksLoaded;
      final newHeadChecks = List<HeadCheckData>.from(currentState.headChecks)
        ..removeAt(event.index);
      emit(currentState.copyWith(headChecks: newHeadChecks));
    }
  }

  void _onUpdateHeadCheck(UpdateHeadCheckEvent event, Emitter<HeadChecksState> emit) {
    if (state is HeadChecksLoaded) {
      final currentState = state as HeadChecksLoaded;
      final newHeadChecks = List<HeadCheckData>.from(currentState.headChecks);
      newHeadChecks[event.index] = newHeadChecks[event.index].copyWith(
        hour: event.hour,
        minute: event.minute,
      );
      emit(currentState.copyWith(headChecks: newHeadChecks));
    }
  }

  Future<void> _onSaveHeadChecks(SaveHeadChecksEvent event, Emitter<HeadChecksState> emit) async {
    if (state is HeadChecksLoaded) {
      final currentState = state as HeadChecksLoaded;
      emit(HeadChecksLoading());
      try {
        final response = await repository.saveHeadChecks(
          userId: event.userId,
          roomId: event.roomId,
          date: event.date,
          headChecks: event.headChecks,
        );
        if (!response.success) {
          emit(HeadChecksError(message: response.message));
          return;
        }
        emit(currentState.copyWith());
        // Trigger a reload to refresh data
        add(LoadHeadChecksInitial(userId: event.userId));
      } catch (e) {
        emit(HeadChecksError(message: e.toString()));
      }
    }
  }
}