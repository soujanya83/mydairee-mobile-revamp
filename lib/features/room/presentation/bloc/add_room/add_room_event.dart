// 📁 add_room_event.dart
import 'package:equatable/equatable.dart';

abstract class AddRoomEvent extends Equatable {
  const AddRoomEvent();

  @override
  List<Object?> get props => [];
}

class SubmitAddRoomEvent extends AddRoomEvent {
  final String centerId;
  final String name;
  final String capacity;
  final String ageFrom;
  final String ageTo;
  final String roomStatus;
  final String color;
  final dynamic educators;
  final String? id;

  const SubmitAddRoomEvent({
    this.id,
    required this.centerId,
    required this.name,
    required this.capacity,
    required this.ageFrom,
    required this.ageTo,
    required this.roomStatus,
    required this.color,
    required this.educators,
  });

  @override
  List<Object?> get props => [
        id,
        centerId,
        name,
        capacity,
        ageFrom,
        ageTo,
        roomStatus,
        color,
        educators,
      ];
}
