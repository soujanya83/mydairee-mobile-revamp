import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mydiaree/features/room/presentation/bloc/view_room/vieiw_room_event.dart';
import 'package:mydiaree/features/room/presentation/bloc/view_room/vieiw_room_state.dart';

import 'package:mydiaree/features/room/data/repositories/room_repositories.dart';

class ViewRoomBloc extends Bloc<ViewRoomEvent, ViewRoomState> {
  final RoomRepository repository = RoomRepository();
  ViewRoomBloc() : super(ViewRoomInitial()) {
    on<FetchRoomChildrenEvent>((event, emit) async {
      emit(ViewRoomLoading());
      final response = await repository.getChildrenByRoomId(event.roomId);
      if (response.success && response.data != null) {
        emit(ViewRoomLoaded(response.data!));
      } else {
        emit(ViewRoomError(response.message));
      }
    });
  }
}