import 'package:equatable/equatable.dart';
import 'package:mydiaree/features/room/data/model/room_list_model.dart';

enum DeletionStatus { initial, inProgress, success, failure }

class RoomListState extends Equatable {
  const RoomListState();

  @override
  List<Object> get props => [];
}

class RoomListInitial extends RoomListState {}

class RoomListLoading extends RoomListState {}

class RoomListError extends RoomListState {
  final String message;

  const RoomListError({required this.message});

  @override
  List<Object> get props => [message];
}

class RoomListLoaded extends RoomListState {
  final RoomListModel roomsData;

  const RoomListLoaded({
    required this.roomsData,
  });

  RoomListLoaded copyWith({
    List<Map<String, dynamic>>? rooms,
    List<Map<String, dynamic>>? filteredRooms,
    List<Map<String, dynamic>>? centers,
    int? selectedCenterIndex,
    String? searchQuery,
    String? statusFilter,
    Map<String, bool>? selectedRooms,
    DeletionStatus? deletionStatus,
  }) {
    return RoomListLoaded(
      roomsData: roomsData,
    );
  }

  @override
  List<Object> get props => [
        roomsData,
      ];
}


class RoomDeletedState extends RoomListState {}