import 'package:mydiaree/features/healthy_menu/menu/data/model/menu_model.dart';

abstract class MenuState {}

class MenuInitial extends MenuState {}

class MenuLoading extends MenuState {}
 

class MenuRecipesLoaded extends MenuState {
  final List<RecipeModel> recipes;
  MenuRecipesLoaded(this.recipes);
}

class MenuItemsLoaded extends MenuState {
  final List<MenuItemModel> menuItems;
  MenuItemsLoaded(this.menuItems);
}

class MenuSuccess extends MenuState {
  final String message;
  MenuSuccess(this.message);
}

class MenuError extends MenuState {
  final String message;
  MenuError(this.message);
}

