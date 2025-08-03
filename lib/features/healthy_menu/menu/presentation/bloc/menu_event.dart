import 'package:equatable/equatable.dart';

abstract class MenuEvent extends Equatable {
  const MenuEvent();

  @override
  List<Object?> get props => [];
}

class FetchMenuItemsEvent extends MenuEvent {
  final String? centerId;
  final String selectedDate;

  const FetchMenuItemsEvent(this.centerId, this.selectedDate);

  @override
  List<Object?> get props => [centerId, selectedDate];
}

class FetchRecipesEvent extends MenuEvent {
  const FetchRecipesEvent();

  @override
  List<Object?> get props => [];
}

class SaveRecipesEvent extends MenuEvent {
  final String selectedDate;
  final String day;
  final String mealType;
  final List<String> recipeIds;
  final String centerId;

  const SaveRecipesEvent({
    required this.selectedDate,
    required this.day,
    required this.mealType,
    required this.recipeIds,
    required this.centerId,
  });

  @override
  List<Object?> get props => [selectedDate, day, mealType, recipeIds, centerId];
}