import 'package:mydiaree/features/healthy_menu/reciepe/data/model/reciepe_model.dart';

abstract class AddRecipeScreenEvent {}

class FetchIngredientsForAddEvent extends AddRecipeScreenEvent {}

class CreateRecipeEvent extends AddRecipeScreenEvent {
  final String itemName;
  final String mealType;
  final int ingredientId;
  final String description;
  final String imagePath;
  final String creator;

  CreateRecipeEvent({
    required this.itemName,
    required this.mealType,
    required this.ingredientId,
    required this.description,
    required this.imagePath,
    required this.creator,
  });
}

class EditRecipeEvent extends AddRecipeScreenEvent {
  final int id;
  final String itemName;
  final String mealType;
  final int ingredientId;
  final String description;
  final String imagePath;
  final String creator;

  EditRecipeEvent({
    required this.id,
    required this.itemName,
    required this.mealType,
    required this.ingredientId,
    required this.description,
    required this.imagePath,
    required this.creator,
  });
}