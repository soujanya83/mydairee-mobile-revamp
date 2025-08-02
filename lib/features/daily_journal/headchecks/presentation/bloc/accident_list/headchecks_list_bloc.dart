import 'package:flutter_bloc/flutter_bloc.dart';
import 'headchecks_list_event.dart';
import 'heachckecks_list_state.dart';
import 'package:mydiaree/features/daily_journal/headchecks/data/repositories/headchecks_repo.dart';

class HeadChecksBloc extends Bloc<HeadChecksEvent, HeadChecksState> {
  final HeadChecksRepository repository = HeadChecksRepository();

  HeadChecksBloc() : super(HeadChecksInitial()) {
    on<LoadHeadChecksInitial>(_onLoadInitial);
  }

  Future<void> _onLoadInitial(LoadHeadChecksInitial event, Emitter<HeadChecksState> emit) async {
    print('Loading HeadChecks...');
    emit(HeadChecksLoading());
    try {
      final response = await repository.getHeadChecksData(
      userId: event.userId,
      centerId: event.centerId,
      roomId: event.roomId,
      date: event.date,
      );
      print('HeadChecks response: $response');
      if (!response.success || response.data == null) {
      emit(HeadChecksError(message: response.message));
      return;
      }
      emit(HeadChecksLoaded(response.data!));
    } catch (e) {
      print('HeadChecks error: $e');
      emit(HeadChecksError(message: e.toString()));
    }
  }
}