abstract class RecipeEvent {}
 

class FetchIngredientsEvent extends RecipeEvent {}

class FetchRecipesEvent extends RecipeEvent {
  final int centerId;
  FetchRecipesEvent(this.centerId);
}

class AddRecipeEvent extends RecipeEvent {
  final String itemName;
  final String mealType;
  final int ingredientId;
  final String description;
  final String imagePath;
  final String creator;
  AddRecipeEvent({
    required this.itemName,
    required this.mealType,
    required this.ingredientId,
    required this.description,
    required this.imagePath,
    required this.creator,
  });
}

class DeleteRecipeEvent extends RecipeEvent {
  final int recipeId;
  DeleteRecipeEvent(this.recipeId);
}