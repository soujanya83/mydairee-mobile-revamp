import 'package:equatable/equatable.dart';

abstract class AnnounceListEvent extends Equatable {
  const AnnounceListEvent();

  @override
  List<Object> get props => [];
}

class FetchAnnounceEvent extends AnnounceListEvent {
  final String centerId;

  const FetchAnnounceEvent({required this.centerId});

  @override
  List<Object> get props => [centerId];
}


class DeleteSelectedAnnounceEvent extends AnnounceListEvent {
  final List<String> announcement;
  final String centerId; // Add this
  const DeleteSelectedAnnounceEvent(this.announcement, this.centerId);

  @override
  List<Object> get props => [announcement, centerId];
}
