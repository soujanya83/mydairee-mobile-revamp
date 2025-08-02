import 'package:equatable/equatable.dart';
import 'package:mydiaree/features/room/data/model/childrens_room_model.dart';

abstract class ViewRoomState extends Equatable {
  @override
  List<Object?> get props => [];
}

class ViewRoomInitial extends ViewRoomState {}

class ViewRoomLoading extends ViewRoomState {}

class ViewRoomLoaded extends ViewRoomState {
  final ChildrensRoomModel childrenData;
  ViewRoomLoaded(this.childrenData);

  @override
  List<Object?> get props => [childrenData];
}

class ViewRoomError extends ViewRoomState {
  final String message;
  ViewRoomError(this.message);

  @override
  List<Object?> get props => [message];
}