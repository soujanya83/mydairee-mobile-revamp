class RecipeModel {
  final int id;
  final String itemName;
  final String type; // e.g., Breakfast, Lunch
  final String imageUrl;
  final String creator;
  final String createdAt;
  final String description;
  final int ingredientId;

  RecipeModel({
    required this.id,
    required this.itemName,
    required this.type,
    required this.imageUrl,
    required this.creator,
    required this.createdAt,
    required this.description,
    required this.ingredientId,
  });

  factory RecipeModel.fromJson(Map<String, dynamic> json) {
    return RecipeModel(
      id: json['id'] as int,
      itemName: json['itemName'] as String,
      type: json['type'] as String,
      imageUrl: json['imageUrl'] as String,
      creator: json['creator'] as String,
      createdAt: json['createdAt'] as String,
      description: json['description'] as String,
      ingredientId: json['ingredientId'] as int,
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'itemName': itemName,
        'type': type,
        'imageUrl': imageUrl,
        'creator': creator,
        'createdAt': createdAt,
        'description': description,
        'ingredientId': ingredientId,
      };
}

class IngredientModel {
  final int id;
  final String name;

  IngredientModel({required this.id, required this.name});

  factory IngredientModel.fromJson(Map<String, dynamic> json) {
    return IngredientModel(
      id: json['id'] as int,
      name: json['name'] as String,
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
      };
}