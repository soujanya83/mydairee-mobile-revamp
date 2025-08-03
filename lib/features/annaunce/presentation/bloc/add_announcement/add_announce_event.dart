import 'package:equatable/equatable.dart';

abstract class AddAnnouncementEvent extends Equatable {
  const AddAnnouncementEvent();

  @override
  List<Object?> get props => [];
}

class SubmitAddAnnouncementEvent extends AddAnnouncementEvent {
  final String? id;
  final String title;
  final String text;
  final String eventDate;
  final List<int> childIds;
  final String userId;
  final String centerId;

  const SubmitAddAnnouncementEvent({
    this.id,
    required this.title,
    required this.text,
    required this.eventDate,
    required this.childIds,
    required this.userId,
    required this.centerId,
  });

  @override
  List<Object?> get props => [id, title, text, eventDate, childIds, userId, centerId];
}
