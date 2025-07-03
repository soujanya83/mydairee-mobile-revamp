import 'package:equatable/equatable.dart';

abstract class SleepChecklistEvent extends Equatable {
  const SleepChecklistEvent();

  @override
  List<Object?> get props => [];
}

class FetchCentersEvent extends SleepChecklistEvent {
  final String userId;

  const FetchCentersEvent({required this.userId});

  @override
  List<Object?> get props => [userId];
}

class FetchRoomsEvent extends SleepChecklistEvent {
  final String userId;
  final String centerId;

  const FetchRoomsEvent({required this.userId, required this.centerId});

  @override
  List<Object?> get props => [userId, centerId];
}

class FetchSleepChecklistEvent extends SleepChecklistEvent {
  final String userId;
  final String centerId;
  final String roomId;
  final DateTime date;

  const FetchSleepChecklistEvent({
    required this.userId,
    required this.centerId,
    required this.roomId,
    required this.date,
  });

  @override
  List<Object?> get props => [userId, centerId, roomId, date];
}

class AddSleepCheckEvent extends SleepChecklistEvent {
  final String userId;
  final String childId;
  final String roomId;
  final DateTime diaryDate;
  final String time;
  final String breathing;
  final String bodyTemperature;
  final String notes;
  final String centerId;

  const AddSleepCheckEvent({
    required this.userId,
    required this.childId,
    required this.roomId,
    required this.diaryDate,
    required this.time,
    required this.breathing,
    required this.bodyTemperature,
    required this.notes,
    required this.centerId,
  });

  @override
  List<Object?> get props => [
        userId,
        childId,
        roomId,
        diaryDate,
        time,
        breathing,
        bodyTemperature,
        notes,
        centerId,
      ];
}

class UpdateSleepCheckEvent extends SleepChecklistEvent {
  final String userId;
  final String id;
  final String childId;
  final String roomId;
  final DateTime diaryDate;
  final String time;
  final String breathing;
  final String bodyTemperature;
  final String notes;
  final String centerId;

  const UpdateSleepCheckEvent({
    required this.userId,
    required this.id,
    required this.childId,
    required this.roomId,
    required this.diaryDate,
    required this.time,
    required this.breathing,
    required this.bodyTemperature,
    required this.notes,
    required this.centerId,
  });

  @override
  List<Object?> get props => [
        userId,
        id,
        childId,
        roomId,
        diaryDate,
        time,
        breathing,
        bodyTemperature,
        notes,
        centerId,
      ];
}

class DeleteSleepCheckEvent extends SleepChecklistEvent {
  final String userId;
  final String id;
  final String centerId;
  final String roomId;
  final DateTime diaryDate;

  const DeleteSleepCheckEvent({
    required this.userId,
    required this.id,
    required this.centerId,
    required this.roomId,
    required this.diaryDate,
  });

  @override
  List<Object?> get props => [userId, id, centerId, roomId, diaryDate];
}