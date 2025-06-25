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
  final String status;
  final String createdBy;
  final String centerId;

  const SubmitAddAnnouncementEvent( {
    
    this.id,
    required this.centerId,
    required this.title,
    required this.text,
    required this.eventDate,
    required this.status,
    required this.createdBy,
  });

  @override
  List<Object?> get props => [
        id,
        title,
        text,
        eventDate,
        status,
        createdBy,
        centerId
      ];
}
