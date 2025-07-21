abstract class IngredientEvent {}

class FetchIngredientsEvent extends IngredientEvent {}

class AddIngredientEvent extends IngredientEvent {
  final String name;
  final String creator;

  AddIngredientEvent({required this.name, required this.creator});
}

class EditIngredientEvent extends IngredientEvent {
  final int id;
  final String name;
  final String creator;

  EditIngredientEvent({required this.id, required this.name, required this.creator});
}

class DeleteIngredientEvent extends IngredientEvent {
  final int id;

  DeleteIngredientEvent(this.id);
}