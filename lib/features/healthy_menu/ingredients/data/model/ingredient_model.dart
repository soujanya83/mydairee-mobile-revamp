class IngredientResponseModel {
  final String status;
  final List<IngredientModel> ingredients;
  
  IngredientResponseModel({
    required this.status,
    required this.ingredients,
  });
  
  factory IngredientResponseModel.fromJson(Map<String, dynamic> json) {
    return IngredientResponseModel(
      status: json['status'] ?? '',
      ingredients: (json['ingredients'] as List<dynamic>?)
          ?.map((e) => IngredientModel.fromJson(e))
          .toList() ?? [],
    );
  }
}

class IngredientModel {
  final int id;
  final String name;
  final String colorClass;
  
  IngredientModel({
    required this.id,
    required this.name,
    required this.colorClass,
  });
  
  factory IngredientModel.fromJson(Map<String, dynamic> json) {
    return IngredientModel(
      id: json['id'] ?? 0,
      name: json['name'] ?? '',
      colorClass: json['colorClass'] ?? '',
    );
  }
}

class IngredientEditResponseModel {
  final String status;
  final String message;
  final IngredientEditModel recipe;
  
  IngredientEditResponseModel({
    required this.status,
    required this.message,
    required this.recipe,
  });
  
  factory IngredientEditResponseModel.fromJson(Map<String, dynamic> json) {
    return IngredientEditResponseModel(
      status: json['status'] ?? '',
      message: json['message'] ?? '',
      recipe: IngredientEditModel.fromJson(json['recipe']),
    );
  }
}

class IngredientEditModel {
  final int id;
  final String name;
  
  IngredientEditModel({
    required this.id,
    required this.name,
  });
  
  factory IngredientEditModel.fromJson(Map<String, dynamic> json) {
    return IngredientEditModel(
      id: json['id'] ?? 0,
      name: json['name'] ?? '',
    );
  }
}