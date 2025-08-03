import 'package:mydiaree/core/utils/helper_functions.dart';

// Menu API Response Model
class MenuResponse {
  final String status;
  final String selectedDate;
  final String selectedDay;
  final List<MenuItemModel> menus;
  final List<CenterModel> centers;
  
  MenuResponse({
    required this.status,
    required this.selectedDate,
    required this.selectedDay,
    required this.menus,
    required this.centers,
  });
  
  factory MenuResponse.fromJson(Map<String, dynamic> json) {
    return MenuResponse(
      status: json['status'] ?? '',
      selectedDate: json['selected_date'] ?? '',
      selectedDay: json['selected_day'] ?? '',
      menus: (json['menus'] as List<dynamic>?)
              ?.map((e) => MenuItemModel.fromJson(e))
              .toList() ?? [],
      centers: (json['centers'] as List<dynamic>?)
              ?.map((e) => CenterModel.fromJson(e))
              .toList() ?? [],
    );
  }
}

class MenuItemModel {
  final int id;
  final String name;
  final String day;
  final String mealType;
  final String? colorClass;
  final String? mediaUrl;
  final String createdAt;
  final List<RecipeModel> recipes;
  
  MenuItemModel({
    required this.id,
    required this.name,
    required this.day,
    required this.mealType,
    this.colorClass,
    this.mediaUrl,
    required this.createdAt,
    this.recipes = const [],
  });
  
  factory MenuItemModel.fromJson(Map<String, dynamic> json) {
    return MenuItemModel(
      id: json['id'] ?? 0,
      name: json['name'] ?? '',
      day: json['day'] ?? '',
      mealType: json['mealType'] ?? '',
      colorClass: json['colorClass'],
      mediaUrl: json['mediaUrl'],
      createdAt: json['createdAt'] ?? '',
      recipes: const [], // API doesn't include recipes in this response
    );
  }
}

class CenterModel {
  final int id;
  final dynamic userId;
  final String centerName;
  final String adressStreet;
  final String addressCity;
  final String addressState;
  final String addressZip;
  final String createdAt;
  final String updatedAt;
  
  CenterModel({
    required this.id,
    this.userId,
    required this.centerName,
    required this.adressStreet,
    required this.addressCity,
    required this.addressState,
    required this.addressZip,
    required this.createdAt,
    required this.updatedAt,
  });
  
  factory CenterModel.fromJson(Map<String, dynamic> json) {
    return CenterModel(
      id: json['id'] ?? 0,
      userId: json['user_id'],
      centerName: json['centerName'] ?? '',
      adressStreet: json['adressStreet'] ?? '',
      addressCity: json['addressCity'] ?? '',
      addressState: json['addressState'] ?? '',
      addressZip: json['addressZip'] ?? '',
      createdAt: json['created_at'] ?? '',
      updatedAt: json['updated_at'] ?? '',
    );
  }
}

class RecipeModel {
  final int id;
  final String itemName;
  final String type;
  final String recipe;
  final int centerId;
  final String createdAt;
  final String createdBy;
  final String? mediaUrl;
  final String createdByName;
  final String createdByRole;
  
  RecipeModel({
    required this.id,
    required this.itemName,
    required this.type,
    required this.recipe,
    required this.centerId,
    required this.createdAt,
    required this.createdBy,
    this.mediaUrl,
    required this.createdByName,
    required this.createdByRole,
  });
  
  factory RecipeModel.fromJson(Map<String, dynamic> json) {
    return RecipeModel(
      id: json['id'] ?? 0,
      itemName: json['itemName'] ?? '',
      type: json['type'] ?? '',
      recipe: json['recipe'] ?? '',
      centerId: json['centerid'] ?? 0,
      createdAt: json['createdAt'] ?? '',
      createdBy: json['createdBy'] ?? '',
      mediaUrl: json['mediaUrl'],
      createdByName: json['created_by_name'] ?? '',
      createdByRole: json['created_by_role'] ?? '',
    );
  }
}

class RecipeResponse {
  final String status;
  final List<CenterModel> centers;
  final Map<String, List<RecipeModel>> recipes;
  final List<String> uniqueMealTypes;
  final List<IngredientModel> ingredients;
  
  RecipeResponse({
    required this.status,
    required this.centers,
    required this.recipes,
    required this.uniqueMealTypes,
    required this.ingredients,
  });
  
  factory RecipeResponse.fromJson(Map<String, dynamic> json) {
    final recipesMap = <String, List<RecipeModel>>{};
    
    if (json['recipes'] is Map<String, dynamic>) {
      json['recipes'].forEach((key, value) {
        recipesMap[key] = (value as List<dynamic>)
            .map((e) => RecipeModel.fromJson(e))
            .toList();
      });
    }
    
    return RecipeResponse(
      status: json['status'] ?? '',
      centers: (json['centers'] as List<dynamic>?)
          ?.map((e) => CenterModel.fromJson(e))
          .toList() ?? [],
      recipes: recipesMap,
      uniqueMealTypes: (json['unique_meal_types'] as List<dynamic>?)
          ?.map((e) => e.toString())
          .toList() ?? [],
      ingredients: (json['ingredients'] as List<dynamic>?)
          ?.map((e) => IngredientModel.fromJson(e))
          .toList() ?? [],
    );
  }
}

class IngredientModel {
  final int id;
  final String name;
  
  IngredientModel({
    required this.id,
    required this.name,
  });
  
  factory IngredientModel.fromJson(Map<String, dynamic> json) {
    return IngredientModel(
      id: json['id'] ?? 0,
      name: json['name'] ?? '',
    );
  }
}