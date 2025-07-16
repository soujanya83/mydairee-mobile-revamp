import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mydiaree/features/settings/center_settings/data/repositories/settings_repository.dart';
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

    on<AddCenterEvent>((event, emit) async {
      emit(CentersSettingsLoading());
      try {
        final response = await repository.addCenter(event.center);
        if (response.success) {
          emit(const CentersSettingsSuccess(message: 'Center added successfully!'));
          add(FetchCentersEvent());
        } else {
          emit(CentersSettingsFailure(message: response.message));
        }
      } catch (e) {
        emit(CentersSettingsFailure(message: e.toString()));
      }
    });

    on<UpdateCenterEvent>((event, emit) async {
      emit(CentersSettingsLoading());
      try {
        final response = await repository.updateCenter(event.center);
        if (response.success) {
          emit(CentersSettingsSuccess(message: 'Center updated successfully!'));
          add(FetchCentersEvent());
        } else {
          emit(CentersSettingsFailure(message: response.message));
        }
      } catch (e) {
        emit(CentersSettingsFailure(message: e.toString()));
      }
    });

    on<DeleteCenterEvent>((event, emit) async {
      emit(CentersSettingsLoading());
      try {
        final response = await repository.deleteCenter(event.centerId);
        if (response.success) {
          emit(CentersSettingsSuccess(message: 'Center deleted successfully!'));
          add(FetchCentersEvent());
        } else {
          emit(CentersSettingsFailure(message: response.message));
        }
      } catch (e) {
        emit(CentersSettingsFailure(message: e.toString()));
      }
    });
  }
}
