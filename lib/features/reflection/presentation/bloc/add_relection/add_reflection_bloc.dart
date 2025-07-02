import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mydiaree/features/reflection/data/repositories/reflection_repository.dart';
import 'add_reflection_event.dart';
import 'add_reflection_state.dart';

class AddReflectionBloc extends Bloc<AddReflectionEvent, AddReflectionState> {
    ReflectionRepository repository = ReflectionRepository();

  AddReflectionBloc()
      : super(AddReflectionInitial()) {
    on<SubmitAddReflectionEvent>((event, emit) async {
      emit(AddReflectionLoading());
      try {
        final response = await repository.addOrEditReflection(
          reflectionId: event.reflectionId,
          title: event.title,
          about: event.about,
          eylf: event.eylf,
          roomId: event.roomId,
          children: event.children,
          educators: event.educators,
          media: event.media,
        );

        if (response.success) {
          emit(AddReflectionSuccess(response.message));
        } else {
          emit(AddReflectionFailure(response.message));
        }
      } catch (e) {
        emit(AddReflectionFailure(e.toString()));
      }
    });
  }
}
