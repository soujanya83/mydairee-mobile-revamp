import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:mydiaree/features/room/data/repositories/room_repositories.dart';
import 'package:mydiaree/features/room/presentation/bloc/list_room/list_room_event.dart';
import 'package:mydiaree/features/room/presentation/bloc/list_room/list_room_state.dart';

class RoomListBloc extends Bloc<RoomListEvent, RoomListState> {
  RoomRepository roomRepository = RoomRepository();
  RoomListBloc({req}) : super(RoomListInitial()) {
    on<FetchRoomsEvent>(_onFetchRooms);
  }

  Future<void> _onFetchRooms(
    FetchRoomsEvent event,
    Emitter<RoomListState> emit,
  ) async {
    emit(RoomListLoading());
    try {
      final response = await roomRepository.getRooms(
        centerId: event.centerId,
      );

      if (response.success && response.data != null) {
        emit(RoomListLoaded(
          roomsData: response.data!,
        ));
      } else {
        emit(RoomListError(message: response.message));
      }
    } catch (e) {
      emit(RoomListError(message: 'Failed to fetch rooms: $e'));
    }
  }
}
