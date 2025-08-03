import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mydiaree/features/healthy_menu/menu/data/model/menu_model.dart';
import 'package:mydiaree/features/healthy_menu/menu/data/repositories/menu_repository.dart';
import 'package:mydiaree/features/healthy_menu/menu/presentation/bloc/menu_event.dart';
import 'package:mydiaree/features/healthy_menu/menu/presentation/bloc/menu_state.dart';

class MenuBloc extends Bloc<MenuEvent, MenuState> {
  final MenuRepository _repository = MenuRepository();

  MenuBloc() : super(MenuInitial()) {
    on<FetchMenuItemsEvent>(_onFetchMenuItems);
    on<FetchRecipesEvent>(_onFetchRecipes);
    on<SaveRecipesEvent>(_onSaveRecipes);
  }

  Future<void> _onFetchMenuItems(
    FetchMenuItemsEvent event,
    Emitter<MenuState> emit,
  ) async {
    emit(MenuLoading());
    try {
      final response = await _repository.getMenuItems(
        event.selectedDate,
        centerId: event.centerId,
      );
      
      if (response.success && response.data != null) {
        emit(MenuItemsLoaded(
          menuItems: response.data!.menus,
          centers: response.data!.centers,
          selectedDate: response.data!.selectedDate,
          selectedDay: response.data!.selectedDay,
        ));
      } else {
        emit(MenuError(message: response.message));
      }
    } catch (e) {
      emit(MenuError(message: e.toString()));
    }
  }

  Future<void> _onFetchRecipes(
    FetchRecipesEvent event,
    Emitter<MenuState> emit,
  ) async {
    emit(MenuLoading());
    try {
      final response = await _repository.getRecipes();
      
      if (response.success && response.data != null) {
        emit(RecipesLoaded(
          recipes: response.data!.recipes,
          centers: response.data!.centers,
          uniqueMealTypes: response.data!.uniqueMealTypes,
          ingredients: response.data!.ingredients,
        ));
      } else {
        emit(MenuError(message: response.message));
      }
    } catch (e) {
      emit(MenuError(message: e.toString()));
    }
  }

  Future<void> _onSaveRecipes(
    SaveRecipesEvent event,
    Emitter<MenuState> emit,
  ) async {
    emit(MenuLoading());
    try {
      final response = await _repository.saveRecipes(
        selectedDate: event.selectedDate,
        day: event.day,
        mealType: event.mealType,
        recipeIds: event.recipeIds,
        centerId: event.centerId,
      );
      
      if (response.success) {
        // Refresh menu items after successful save
        add(FetchMenuItemsEvent(
          event.centerId,
          event.selectedDate,
        ));
        emit(RecipesSaved(message: "Recipes saved successfully"));
      } else {
        emit(MenuError(message: response.message));
      }
    } catch (e) {
      emit(MenuError(message: e.toString()));
    }
  }
}