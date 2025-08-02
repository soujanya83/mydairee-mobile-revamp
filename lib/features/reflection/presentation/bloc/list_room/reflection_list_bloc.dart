import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mydiaree/features/reflection/presentation/bloc/list_room/reflection_list_event.dart';
import 'package:mydiaree/features/reflection/presentation/bloc/list_room/reflection_list_state.dart';
import 'package:mydiaree/features/reflection/presentation/pages/reflection_list_screen.dart';
import 'package:flutter_bloc/flutter_bloc.dart'; 
import 'package:mydiaree/features/reflection/data/repositories/reflection_repository.dart';
import 'package:mydiaree/features/reflection/presentation/bloc/list_room/reflection_list_event.dart';
import 'package:mydiaree/features/reflection/presentation/bloc/list_room/reflection_list_state.dart';

class ReflectionListBloc
    extends Bloc<ReflectionListEvent, ReflectionListState> {
  final ReflectionRepository _reflectionRepository = ReflectionRepository();

  ReflectionListBloc() : super(ReflectionListInitial()) {
    on<FetchReflectionsEvent>(_onFetchReflections);
    on<DeleteSelectedReflectionsEvent>(_onDeleteSelectedReflections);
  }

  Future<void> _onFetchReflections(
    FetchReflectionsEvent event,
    Emitter<ReflectionListState> emit,
  ) async {
    emit(ReflectionListLoading());

    try {
      final response = await _reflectionRepository.getReflections(
        centerId: event.centerId,
        // search: event.search,
        // status: event.status,
        // children: event.children,
        // authors: event.authors,
        // page: event.page,
      );

      if (response.success && response.data != null) {
        emit(ReflectionListLoaded(
          reflections: response.data!,
          currentPage: event.page,
          totalPages: 3, // Replace with actual total pages from backend
        ));
      } else {
        emit(ReflectionListError(message: response.message));
      }
    } catch (e) {
      emit(ReflectionListError(message: 'Failed to load reflections: $e'));
    }
  }

  Future<void> _onDeleteSelectedReflections(
    DeleteSelectedReflectionsEvent event,
    Emitter<ReflectionListState> emit,
  ) async {
    emit(ReflectionListLoading());

    try {
      final response =
          await _reflectionRepository.deleteReflections(event.reflectionIds);
      if (response.success){
        emit(ReflectionDeletedState());
        add(FetchReflectionsEvent(centerId: event.centerId)); // Reload list
      } else {
        emit(ReflectionListError(message: response.message));
      }
    } catch (e) {
      emit(ReflectionListError(message: 'Failed to delete reflections: $e'));
    }
  }
}
