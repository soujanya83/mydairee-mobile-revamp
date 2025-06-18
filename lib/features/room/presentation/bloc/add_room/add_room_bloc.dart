import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mydiaree/features/room/data/repositories/room_repositories.dart';
import 'add_room_event.dart';
import 'add_room_state.dart';

class AddRoomBloc extends Bloc<AddRoomEvent, AddRoomState> {
  RoomRepository repository = RoomRepository();
  AddRoomBloc() : super(AddRoomInitial()) {
    on<SubmitAddRoomEvent>((event, emit) async {
      emit(AddRoomLoading());
      try {
        final response = await repository.addOrEditRoom(
          centerId: event.centerId,
          name: event.name,
          capacity: event.capacity,
          ageFrom: event.ageFrom,
          ageTo: event.ageTo,
          roomStatus: event.roomStatus,
          color: event.color,
          educators: event.educators,
        );
        if (response.success) {
          emit(AddRoomSuccess(response.message));
        } else {
          emit(AddRoomFailure(response.message));
        }
      } catch (e) {
        emit(AddRoomFailure(e.toString()));
      }
    });
  }
}
