import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mydiaree/features/learning_and_progress/data/repositories/learning_and_progress_repository.dart';
import 'package:mydiaree/features/learning_and_progress/presentation/bloc/list/learning_and_progress_event.dart';
import 'package:mydiaree/features/learning_and_progress/presentation/bloc/list/learning_and_progress_state.dart'; 

class LearningAndProgressBloc extends Bloc<LearningAndProgressEvent, LearningAndProgressState> {
   
final LearningAndProgressRepository _repository = LearningAndProgressRepository();
  LearningAndProgressBloc() : super(LearningAndProgressLoading()) {
    on<FetchChildrenEvent>(_onFetchChildren);
    on<DeleteChildrenEvent>(_onDeleteChildren);
  }

  Future<void> _onFetchChildren(FetchChildrenEvent event, Emitter<LearningAndProgressState> emit) async {
    emit(LearningAndProgressLoading());
    try {
      final children = await _repository.fetchChildren(event.centerId);
      emit(LearningAndProgressLoaded(children));
    } catch (e) {
      emit(LearningAndProgressError('Failed to fetch children: $e'));
    }
  }

  Future<void> _onDeleteChildren(DeleteChildrenEvent event, Emitter<LearningAndProgressState> emit) async {
    try {
      await _repository.deleteChildren(event.childIds, event.centerId);
      emit(LearningAndProgressDeleted('Children deleted successfully'));
      add(FetchChildrenEvent(centerId: event.centerId));
    } catch (e) {
      emit(LearningAndProgressError('Failed to delete children: $e'));
    }
  }
}