import 'package:equatable/equatable.dart';
import 'package:mydiaree/features/snapshot/data/model/snapshot_model.dart'; 

abstract class SnapshotState extends Equatable {
  const SnapshotState();

  @override
  List<Object> get props => [];
}

class SnapshotInitial extends SnapshotState {}

class SnapshotLoading extends SnapshotState {}

class SnapshotLoaded extends SnapshotState {
  final List<SnapshotModel> snapshots;
  final String selectedCenterId;

  const SnapshotLoaded({
    required this.snapshots,
    required this.selectedCenterId,
  });

  @override
  List<Object> get props => [snapshots, selectedCenterId];
}

class SnapshotError extends SnapshotState {
  final String message;

  const SnapshotError(this.message);

  @override
  List<Object> get props => [message];
}