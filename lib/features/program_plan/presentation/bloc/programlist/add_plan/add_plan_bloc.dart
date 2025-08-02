import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mydiaree/features/program_plan/data/repositories/program_plan_repository.dart';
import 'add_plan_event.dart';
import 'add_plan_state.dart';

class AddPlanBloc extends Bloc<AddPlanEvent, AddPlanState> {
  ProgramPlanRepository repository = ProgramPlanRepository();

  AddPlanBloc() : super(AddPlanInitial()) {
    on<SubmitAddPlanEvent>((event, emit) async {
      print('SubmitAddPlanEvent triggered with event: $event');
      emit(AddPlanLoading());
      try {
        final response = await repository.addOrEditPlan(
          centerId: event.centerId,
          planId: event.planId,
          month: event.month,
          year: event.year,
          roomId: event.roomId,
          educators: event.educators,
          children: event.children,
          focusArea: event.focusArea,
          outdoorExperiences: event.outdoorExperiences,
          inquiryTopic: event.inquiryTopic,
          sustainabilityTopic: event.sustainabilityTopic,
          specialEvents: event.specialEvents,
          childrenVoices: event.childrenVoices,
          familiesInput: event.familiesInput,
          groupExperience: event.groupExperience,
          spontaneousExperience: event.spontaneousExperience,
          mindfulnessExperience: event.mindfulnessExperience,
          eylf: event.eylf,
          practicalLife: event.practicalLife,
          sensorial: event.sensorial,
          math: event.math,
          language: event.language,
          culture: event.culture,
        );

        if (response.success) {
          emit(AddPlanSuccess(response.message));
        } else {
          emit(AddPlanFailure(response.message));
        }
      } catch (e,s) {
        print('error in SubmitAddPlanEvent');
        print(s.toString());
        print(e.toString());
        emit(AddPlanFailure(e.toString()));
      }
    });
 
  }
}
