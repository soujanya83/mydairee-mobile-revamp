import 'package:equatable/equatable.dart';
import 'package:mydiaree/features/healthy_menu/menu/data/model/menu_model.dart';

abstract class MenuState extends Equatable {
  const MenuState();

  @override
  List<Object?> get props => [];
}

class MenuInitial extends MenuState {}

class MenuLoading extends MenuState {}

class MenuItemsLoaded extends MenuState {
  final List<MenuItemModel> menuItems;
  final List<CenterModel> centers;
  final String selectedDate;
  final String selectedDay;

  const MenuItemsLoaded({
    required this.menuItems,
    required this.centers,
    required this.selectedDate,
    required this.selectedDay,
  });

  @override
  List<Object?> get props => [menuItems, centers, selectedDate, selectedDay];
}

class RecipesLoaded extends MenuState {
  final Map<String, List<RecipeModel>> recipes;
  final List<CenterModel> centers;
  final List<String> uniqueMealTypes;
  final List<IngredientModel> ingredients;

  const RecipesLoaded({
    required this.recipes,
    required this.centers,
    required this.uniqueMealTypes,
    required this.ingredients,
  });

  @override
  List<Object?> get props => [recipes, centers, uniqueMealTypes, ingredients];
}

class RecipesSaved extends MenuState {
  final String message;

  const RecipesSaved({required this.message});

  @override
  List<Object?> get props => [message];
}

class MenuError extends MenuState {
  final String message;

  const MenuError({required this.message});

  @override
  List<Object?> get props => [message];
}

