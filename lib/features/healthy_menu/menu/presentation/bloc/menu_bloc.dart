import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mydiaree/features/healthy_menu/menu/data/repositories/menu_repository.dart';
import 'package:mydiaree/features/healthy_menu/menu/presentation/bloc/menu_event.dart';
import 'package:mydiaree/features/healthy_menu/menu/presentation/bloc/menu_state.dart';

class MenuBloc extends Bloc<MenuEvent, MenuState> {
  final MenuRepository repository = MenuRepository();

  MenuBloc() : super(MenuInitial()) {
    on<FetchRecipesEvent>((event, emit) async {
      emit(MenuLoading());
      final response = await repository.fetchRecipesByType(event.mealType);
      if (response.success) {
        emit(MenuRecipesLoaded(response.data!));
      } else {
        emit(MenuError(response.message));
      }
    });

    on<FetchMenuItemsEvent>((event, emit) async {
      emit(MenuLoading());
      final response = await repository.fetchMenuItems(
          centerId: event.centerId, date: event.date);
      if (response.success) {
        emit(MenuItemsLoaded(response.data!));
      } else {
        emit(MenuError(response.message));
      }
    });

    on<SaveMenuItemEvent>((event, emit) async {
      emit(MenuLoading());
      final response = await repository.saveMenuItem(
        centerId: event.centerId,
        date: event.date,
        day: event.day,
        mealType: event.mealType,
        recipeIds: event.recipeIds,
      );
      if (response.success) {
        emit(MenuSuccess(response.message));
      } else {
        emit(MenuError(response.message));
      }
    });
  }
}