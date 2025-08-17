import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mydiaree/features/settings/center_settings/data/repositories/center_repo.dart';
import 'package:mydiaree/features/settings/center_settings/presentation/bloc/center_settings/center_setting_event.dart';
import 'package:mydiaree/features/settings/center_settings/presentation/bloc/center_settings/center_setting_state.dart';

class CentersSettingsBloc
    extends Bloc<CentersSettingsEvent, CentersSettingsState> {
  final CentersRepository repository = CentersRepository();

  CentersSettingsBloc() : super(CentersSettingsInitial()) {
    on<FetchCentersEvent>((event, emit) async {
      emit(CentersSettingsLoading());
      try {
        final centers = await repository.getCenters();
        emit(CentersSettingsLoaded(centers: centers));
      } catch (e) {
        emit(CentersSettingsFailure(message: e.toString()));
      }
    });

  }}
