import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mydiaree/features/learning_and_progress/data/repositories/view_progress_repository.dart';
import 'package:mydiaree/features/learning_and_progress/presentation/bloc/view_progress/view_progress_event.dart';
import 'package:mydiaree/features/learning_and_progress/presentation/bloc/view_progress/view_progress_state.dart';

class ViewProgressBloc extends Bloc<ViewProgressEvent, ViewProgressState> {
  final ViewProgressRepository _repository = ViewProgressRepository();

  ViewProgressBloc() : super(ViewProgressLoading()) {
    on<FetchAssessmentsEvent>(_onFetchAssessments);
    on<UpdateAssessmentStatusEvent>(_onUpdateAssessmentStatus);
  }

  Future<void> _onFetchAssessments(FetchAssessmentsEvent event, Emitter<ViewProgressState> emit) async {
    emit(ViewProgressLoading());
    try {
      final assessments = await _repository.fetchAssessments(event.childId);
      emit(ViewProgressLoaded(assessments));
    } catch (e) {
      emit(ViewProgressError('Failed to fetch assessments: $e'));
    }
  }

  Future<void> _onUpdateAssessmentStatus(UpdateAssessmentStatusEvent event, Emitter<ViewProgressState> emit) async {
    try {
      await _repository.updateAssessmentStatus(event.assessmentId, event.childId, event.newStatus);
      emit(ViewProgressStatusUpdated('Status updated successfully'));
      add(FetchAssessmentsEvent(childId: event.childId));
    } catch (e) {
      emit(ViewProgressError('Failed to update status: $e'));
    }
  }
}