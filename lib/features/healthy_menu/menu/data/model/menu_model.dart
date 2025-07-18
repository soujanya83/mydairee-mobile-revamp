class MenuItemModel {
  final int id;
  final int centerId;
  final String date;
  final String day;
  final String mealType;
  final List<RecipeModel> recipes;

  MenuItemModel({
    required this.id,
    required this.centerId,
    required this.date,
    required this.day,
    required this.mealType,
    required this.recipes,
  });

  factory MenuItemModel.fromJson(Map<String, dynamic> json) {
    return MenuItemModel(
      id: json['id'] as int,
      centerId: json['centerId'] as int,
      date: json['date'] as String,
      day: json['day'] as String,
      mealType: json['mealType'] as String,
      recipes: (json['recipes'] as List)
          .map((e) => RecipeModel.fromJson(e as Map<String, dynamic>))
          .toList(),
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'centerId': centerId,
        'date': date,
        'day': day,
        'mealType': mealType,
        'recipes': recipes.map((e) => e.toJson()).toList(),
      };
}

class RecipeModel {
  final int id;
  final String itemName;
  final String type; // e.g., Breakfast, Lunch

  RecipeModel({required this.id, required this.itemName, required this.type});

  factory RecipeModel.fromJson(Map<String, dynamic> json) {
    return RecipeModel(
      id: json['id'] as int,
      itemName: json['itemName'] as String,
      type: json['type'] as String,
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'itemName': itemName,
        'type': type,
      };
}