import 'package:equatable/equatable.dart';

abstract class ViewRoomEvent extends Equatable {
  @override
  List<Object?> get props => [];
}

class FetchRoomChildrenEvent extends ViewRoomEvent {
  final String roomId;
  FetchRoomChildrenEvent(this.roomId);

  @override
  List<Object?> get props => [roomId];
}