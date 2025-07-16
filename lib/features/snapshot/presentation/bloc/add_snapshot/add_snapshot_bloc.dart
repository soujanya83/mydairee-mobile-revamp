import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mydiaree/features/snapshot/data/repositories/snapshot_repository.dart';
import 'add_snapshot_event.dart';
import 'add_snapshot_state.dart';

class AddSnapshotBloc extends Bloc<AddSnapshotEvent, AddSnapshotState> {
  final SnapshotRepository repository = SnapshotRepository();

  AddSnapshotBloc() : super(AddSnapshotInitial()) {
    on<SubmitAddSnapshotEvent>((event, emit) async {
      emit(AddSnapshotLoading());
      try {
        final response = await repository.addOrEditSnapshot(
          snapshotId: event.snapshotId,
          title: event.title,
          about: event.about,
          roomId: event.roomId,
          children: event.children,
          media: event.media,
        );
        if (response.success){
          emit(AddSnapshotSuccess(response.message));
        } else {
          emit(AddSnapshotFailure(response.message));
        }
      } catch (e) {
        emit(AddSnapshotFailure(e.toString()));
      }
    });
  }
}
