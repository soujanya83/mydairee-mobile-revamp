abstract class MenuEvent {}

class FetchCentersEvent extends MenuEvent {}

class FetchRecipesEvent extends MenuEvent {
  final String mealType;
  FetchRecipesEvent(this.mealType);
}

class FetchMenuItemsEvent extends MenuEvent {
  final int centerId;
  final String date;
  FetchMenuItemsEvent(this.centerId, this.date);
}

class SaveMenuItemEvent extends MenuEvent {
  final String centerId;
  final String date;
  final String day;
  final String mealType;
  final List<int> recipeIds;
  SaveMenuItemEvent({
    required this.centerId,
    required this.date,
    required this.day,
    required this.mealType,
    required this.recipeIds,
  });
}