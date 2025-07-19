import 'package:mydiaree/features/healthy_menu/reciepe/data/model/reciepe_model.dart'; 

abstract class RecipeState {}

class RecipeInitial extends RecipeState {}

class RecipeLoading extends RecipeState {}

 
class RecipeIngredientsLoaded extends RecipeState {
  final List<IngredientModel> ingredients;
  RecipeIngredientsLoaded(this.ingredients);
}

class RecipeRecipesLoaded extends RecipeState {
  final List<RecipeModel> recipes;
  RecipeRecipesLoaded(this.recipes);
}

class RecipeSuccess extends RecipeState {
  final String message;
  RecipeSuccess(this.message);
}

class RecipeError extends RecipeState {
  final String message;
  RecipeError(this.message);
}