import 'package:mydiaree/features/healthy_menu/reciepe/data/model/reciepe_model.dart';

abstract class AddRecipeState {}

class AddRecipeInitial extends AddRecipeState {}

class AddRecipeLoading extends AddRecipeState {}

class AddRecipeIngredientsLoaded extends AddRecipeState {
  final List<IngredientModel> ingredients;
  AddRecipeIngredientsLoaded(this.ingredients);
}

class AddRecipeSuccess extends AddRecipeState {
  final String message;
  AddRecipeSuccess(this.message);
}

class AddRecipeError extends AddRecipeState {
  final String message;
  AddRecipeError(this.message);
}