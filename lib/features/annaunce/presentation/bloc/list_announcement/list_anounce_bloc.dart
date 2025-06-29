import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:mydiaree/features/annaunce/data/repositories/announcement_repositories.dart';
import 'package:mydiaree/features/annaunce/presentation/bloc/list_announcement/list_room_event.dart';
import 'package:mydiaree/features/annaunce/presentation/bloc/list_announcement/list_room_state.dart';

class AnnounceListBloc extends Bloc<AnnounceListEvent, AnnounceListState> {
   AnnoucementRepository repository = AnnoucementRepository();

  AnnounceListBloc() : super(AnnounceListInitial()) {
    on<FetchAnnounceEvent>(_onFetchAnnouncement);
    on<DeleteSelectedAnnounceEvent>(_onDeleteAnnouncement);
  }

  Future<void> _onFetchAnnouncement(
    FetchAnnounceEvent event,
    Emitter<AnnounceListState> emit,
  ) async {
    emit(AnnounceListLoading());
    try {
      final response = await repository.getAnnouncement(
        centerId: event.centerId,
      );

      if (response.success && response.data != null) {
        emit(AnnounceListLoaded(announcementData: response.data!));
      } else {
        emit(AnnounceListError(message: response.message));
      }
    } catch (e) {
      emit(AnnounceListError(message: 'Failed to fetch announcements: $e'));
    }
  }

  Future<void> _onDeleteAnnouncement(
    DeleteSelectedAnnounceEvent event,
    Emitter<AnnounceListState> emit,
  ) async {
    emit(AnnounceListLoading());
    try {
      final response = await repository.deleteMultipleAnnouncement(
        roomIds: event.announcement,
      );

      if (response.success) {
        add(FetchAnnounceEvent(centerId: event.centerId));
        emit(AnnouncementDeletedState()); // Optional
      } else {
        emit(AnnounceListError(message: response.message));
      }
    } catch (e) {
      emit(AnnounceListError(message: 'Failed to delete announcements'));
    }
  }
}