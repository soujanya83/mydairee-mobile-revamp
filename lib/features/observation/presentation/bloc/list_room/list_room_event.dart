import 'package:equatable/equatable.dart';

abstract class RoomListEvent extends Equatable {
  const RoomListEvent();

  @override
  List<Object> get props => [];
}

class FetchRoomsEvent extends RoomListEvent {
  final String centerId;

  const FetchRoomsEvent({required this.centerId});

  @override
  List<Object> get props => [centerId];
}


class DeleteSelectedRoomsEvent extends RoomListEvent {
  final List<String> roomsId;
  const DeleteSelectedRoomsEvent(this.roomsId);
}
