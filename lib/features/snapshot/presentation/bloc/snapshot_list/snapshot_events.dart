import 'package:equatable/equatable.dart';

abstract class SnapshotEvent extends Equatable {
  const SnapshotEvent();

  @override
  List<Object> get props => [];
}

class LoadSnapshotsEvent extends SnapshotEvent {
  final String centerId;

  const LoadSnapshotsEvent(this.centerId);

  @override
  List<Object> get props => [centerId];
}

class ChangeCenterEvent extends SnapshotEvent {
  final String centerId;

  const ChangeCenterEvent(this.centerId);

  @override
  List<Object> get props => [centerId];
}

class DeleteSnapshotEvent extends SnapshotEvent {
  final int snapshotId;

  const DeleteSnapshotEvent(this.snapshotId);

  @override
  List<Object> get props => [snapshotId];
}