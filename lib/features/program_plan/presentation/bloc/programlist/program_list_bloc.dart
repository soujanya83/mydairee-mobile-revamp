import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mydiaree/features/program_plan/data/repositories/program_plan_repository.dart';
import 'package:mydiaree/features/program_plan/presentation/bloc/programlist/program_list_event.dart';
import 'package:mydiaree/features/program_plan/presentation/bloc/programlist/program_list_state.dart';

class ProgramPlanBloc extends Bloc<ProgramPlanListEvent, ProgramPlanListState> {
  ProgramPlanRepository repository = ProgramPlanRepository();
  ProgramPlanBloc() : super(ProgramPlanInitial()) {
    on<FetchProgramPlansEvent>(_onFetchProgramPlans);
    on<DeleteProgramPlanEvent>(_onDeleteProgramPlan);
    
  }

  Future<void> _onFetchProgramPlans(
      FetchProgramPlansEvent event, Emitter<ProgramPlanListState> emit) async {
    emit(ProgramPlanLoading());
    try {
      final response = await repository.getProgramPlans(centerId: event.centerId);
      print('here in fetch program plans');
      print('Response: ${response.data}');
      print('Success: ${response.success}');
      print('Message: ${response.message}');
      if (response.success == false) {
        emit(ProgramPlanError(response.message));
        return;
      }
      emit(ProgramPlanLoaded(response.data));
    } catch (e) {
      emit(const ProgramPlanError('Failed to fetch program plans'));
    }
  }

  Future<void> _onDeleteProgramPlan(
      DeleteProgramPlanEvent event, Emitter<ProgramPlanListState> emit) async {
    emit(ProgramPlanLoading());
    try {
      final response = await repository.deletePlan(planId: event.planId);
      if (response.success) {
        emit(ProgramPlanDeleted());
        
      } else {
        emit(const ProgramPlanError('Failed to delete the plan.'));
      }
    } catch (e) {
      emit(ProgramPlanError('Error occurred while deleting: $e'));
    }
  }
}
