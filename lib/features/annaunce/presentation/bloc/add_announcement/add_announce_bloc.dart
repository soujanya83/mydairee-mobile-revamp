import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mydiaree/features/annaunce/data/repositories/announcement_repositories.dart';
import 'add_announce_event.dart';
import 'add_room_state.dart';

class AnnounceBloc extends Bloc<AddAnnouncementEvent, AddAnnounceState> {
  final AnnoucementRepository repository = AnnoucementRepository();

  AnnounceBloc() : super(AddAnnounceInitial()) {
    on<SubmitAddAnnouncementEvent>((event, emit) async {
      emit(AddAnnounceLoading());
      try {
        final response = await repository.addOrEditAnnouncement(
          id: event.id,
          title: event.title,
          text: event.text,
          eventDate: event.eventDate,
          childIds: event.childIds,
          userId: event.userId,
          centerId: event.centerId,
        );
        
        if (response.success) {
          emit(AddAnnounceSuccess(response.message));
        } else {
          emit(AddAnnounceFailure(response.message));
        }
      } catch (e, s) {
        print('Error: $e');
        print('StackTrace: $s');
        emit(AddAnnounceFailure('Failed to submit announcement.'));
      }
    });
  }
}
