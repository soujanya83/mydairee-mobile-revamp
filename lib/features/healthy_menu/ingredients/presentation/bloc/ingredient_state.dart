

import 'package:mydiaree/features/healthy_menu/ingredients/data/model/ingredient_model.dart';

abstract class IngredientState {}

class IngredientInitial extends IngredientState {}

class IngredientLoading extends IngredientState {}

class IngredientLoaded extends IngredientState {
  final List<IngredientModel> ingredients;

  IngredientLoaded(this.ingredients);
}

class IngredientSuccess extends IngredientState {
  final String message;

  IngredientSuccess(this.message);
}

class IngredientError extends IngredientState {
  final String message;

  IngredientError(this.message);
}