import 'package:mydiaree/features/reflection/data/model/reflection_list_model_screen.dart'; 

abstract class ReflectionListState {}

class ReflectionListInitial extends ReflectionListState {}

class ReflectionListLoading extends ReflectionListState {}

class ReflectionListLoaded extends ReflectionListState {
  final ReflectionListModel reflections;
  final int currentPage;
  final int totalPages;

  ReflectionListLoaded({
    required this.reflections,
    required this.currentPage,
    required this.totalPages,
  });
}

class ReflectionDeletedState extends ReflectionListState {}

class ReflectionListError extends ReflectionListState {
  final String message;

  ReflectionListError({required this.message});
}