import 'package:equatable/equatable.dart';

abstract class AnnounceListEvent extends Equatable {
  const AnnounceListEvent();

  @override
  List<Object> get props => [];
}

class FetchAnnounceEvent extends AnnounceListEvent {
  final String centerId;
  final String? searchQuery;

  const FetchAnnounceEvent({
    required this.centerId,
    this.searchQuery,
  });

  @override
  List<Object> get props => [centerId];
}

class DeleteSelectedAnnounceEvent extends AnnounceListEvent {
  final List<String> announcement;
  final String centerId;
  final String userId;
  
  const DeleteSelectedAnnounceEvent({
    required this.announcement,
    required this.centerId,
    required this.userId,
  });

  @override
  List<Object> get props => [announcement, centerId, userId];
}
