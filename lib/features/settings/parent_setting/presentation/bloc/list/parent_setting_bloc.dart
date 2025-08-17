import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mydiaree/features/settings/parent_setting/data/repositories/parent_settings_repository.dart';
import 'parent_setting_event.dart';
import 'parent_setting_state.dart';

class ParentSettingsBloc
    extends Bloc<ParentSettingsEvent, ParentSettingsState> {
  final ParentRepository repository = ParentRepository();

  ParentSettingsBloc() : super(ParentSettingsInitial()) {
    on<FetchParentsEvent>((event, emit) async {
      emit(ParentSettingsLoading());
      try {
        final parents = await repository.getParents(centerId: event.centerId);
        emit(ParentSettingsLoaded(parents: parents));
      } catch (e) {
        emit(ParentSettingsFailure(message: e.toString()));
      }
    });
  }
}
