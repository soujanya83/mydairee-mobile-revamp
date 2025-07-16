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
        final parents = await repository.getParents();
        emit(ParentSettingsLoaded(parents: parents));
      } catch (e) {
        emit(ParentSettingsFailure(message: e.toString()));
      }
    });

    on<AddParentEvent>((event, emit) async {
      emit(ParentSettingsLoading());
      try {
        final response = await repository.addParent(
          name: event.name,
          email: event.email,
          password: event.password,
          contactNo: event.contactNo,
          gender: event.gender,
          avatarUrl: event.avatarUrl,
          children: event.children,
        );
        if (response.success) {
          emit(ParentSettingsSuccess(message: 'Parent added successfully!'));
          add(FetchParentsEvent());
        } else {
          emit(ParentSettingsFailure(message: response.message));
        }
      } catch (e) {
        emit(ParentSettingsFailure(message: e.toString()));
      }
    });

    on<UpdateParentEvent>((event, emit) async {
      emit(ParentSettingsLoading());
      try {
        final response = await repository.updateParent(
          id: event.id,
          name: event.name,
          email: event.email,
          password: event.password,
          contactNo: event.contactNo,
          gender: event.gender,
          avatarUrl: event.avatarUrl,
          children: event.children,
        );
        if (response.success) {
          emit(ParentSettingsSuccess(message: 'Parent updated successfully!'));
          add(FetchParentsEvent());
        } else {
          emit(ParentSettingsFailure(message: response.message));
        }
      } catch (e) {
        emit(ParentSettingsFailure(message: e.toString()));
      }
    });

    on<DeleteParentEvent>((event, emit) async {
      emit(ParentSettingsLoading());
      try {
        final response = await repository.deleteParent(event.parentId);
        if (response.success) {
          emit(ParentSettingsSuccess(message: 'Parent deleted successfully!'));
          add(FetchParentsEvent());
        } else {
          emit(ParentSettingsFailure(message: response.message));
        }
      } catch (e) {
        emit(ParentSettingsFailure(message: e.toString()));
      }
    });
  }
}
