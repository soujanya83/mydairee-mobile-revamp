import 'package:flutter_bloc/flutter_bloc.dart'; 
import 'package:mydiaree/features/snapshot/data/repositories/snapshot_repository.dart';
import 'package:mydiaree/features/snapshot/presentation/bloc/snapshot_list/snapshot_events.dart'; 
import 'package:mydiaree/features/snapshot/presentation/bloc/snapshot_list/snapshot_state.dart';

class SnapshotBloc extends Bloc<SnapshotEvent, SnapshotState> {
  final SnapshotRepository repository = SnapshotRepository();

  SnapshotBloc() : super(SnapshotInitial()) {
    on<LoadSnapshotsEvent>(_onLoadSnapshots);
    on<ChangeCenterEvent>(_onChangeCenter);
    on<DeleteSnapshotEvent>(_onDeleteSnapshot);
  }

  Future<void> _onLoadSnapshots(LoadSnapshotsEvent event, Emitter<SnapshotState> emit) async {
    emit(SnapshotLoading());
    try {
      final snapshots = await repository.getSnapshots(event.centerId);
      print('Loaded ${snapshots.length} snapshots for center ${event.centerId}');
      emit(SnapshotLoaded(snapshots: snapshots, selectedCenterId: event.centerId));
    } catch (e) {
      print('Error loading snapshots: $e');
      emit(const SnapshotError('Failed to load snapshots'));
    }
  }

  Future<void> _onChangeCenter(ChangeCenterEvent event, Emitter<SnapshotState> emit) async {
    emit(SnapshotLoading());
    try {
      final snapshots = await repository.getSnapshots(event.centerId);
      print('Changed center to ${event.centerId}, loaded ${snapshots.length} snapshots');
      emit(SnapshotLoaded(snapshots: snapshots, selectedCenterId: event.centerId));
    } catch (e) {
      print('Error changing center: $e');
      emit(const SnapshotError('Failed to change center'));
    }
  }

  Future<void> _onDeleteSnapshot(DeleteSnapshotEvent event, Emitter<SnapshotState> emit) async {
    try {
      await repository.deleteSnapshot(event.snapshotId);
      if (state is SnapshotLoaded) {
        final currentState = state as SnapshotLoaded;
        final updatedSnapshots = currentState.snapshots.where((s) => s.id != event.snapshotId).toList();
        print('Deleted snapshot ${event.snapshotId}, ${updatedSnapshots.length} snapshots remaining');
        emit(SnapshotLoaded(snapshots: updatedSnapshots, selectedCenterId: currentState.selectedCenterId));
      }
    } catch (e) {
      print('Error deleting snapshot: $e');
      emit(const SnapshotError('Failed to delete snapshot'));
    }
  }
}