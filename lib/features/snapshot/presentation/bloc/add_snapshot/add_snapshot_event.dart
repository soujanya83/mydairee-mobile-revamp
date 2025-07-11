import 'package:equatable/equatable.dart';

abstract class AddSnapshotEvent extends Equatable {
  const AddSnapshotEvent();

  @override
  List<Object?> get props => [];
}

class SubmitAddSnapshotEvent extends AddSnapshotEvent {
  final String? snapshotId;
  final String title;
  final String about;
  final String roomId;
  final List<String> children;
  final List<String> media;

  const SubmitAddSnapshotEvent({
    this.snapshotId,
    required this.title,
    required this.about,
    required this.roomId,
    required this.children,
    required this.media,
  });

  @override
  List<Object?> get props => [
        snapshotId,
        title,
        about,
        roomId,
        children,
        media,
      ];
}