import 'package:mydiaree/core/services/apiresoponse.dart';
import 'package:mydiaree/features/healthy_menu/menu/data/model/menu_model.dart';

class MenuRepository {
  // Dummy data for centers
  final Map<String, dynamic> _dummyCenters = {
    "success": true,
    "data": [
      {"id": 1, "name": "Melbourne Center"},
      {"id": 2, "name": "Carramar Center"},
      {"id": 3, "name": "Brisbane Center"},
      {"id": 110, "name": "test"},
      {"id": 112, "name": "mytesting325"}
    ]
  };

  // Dummy data for recipes
  final Map<String, dynamic> _dummyRecipes = {
    "success": true,
    "data": [
      {"id": 1, "itemName": "Oatmeal", "type": "Breakfast"},
      {"id": 2, "itemName": "Fruit Salad", "type": "Morning Tea"},
      {"id": 3, "itemName": "Chicken Sandwich", "type": "Lunch"},
      {"id": 4, "itemName": "Cheese Platter", "type": "Afternoon Tea"},
      {"id": 5, "itemName": "Nuts", "type": "Late Snacks"}
    ]
  };

  // Dummy data for menu items
  final Map<String, dynamic> _dummyMenuItems = {
    "success": true,
    "data": [
      {
        "id": 1,
        "centerId": 1,
        "date": "21-07-2025",
        "day": "Monday",
        "mealType": "Breakfast",
        "recipes": [
          {"id": 1, "itemName": "Oatmeal", "type": "Breakfast"}
        ]
      }
    ]
  };



  Future<ApiResponse<List<RecipeModel>>> fetchRecipesByType(String mealType, {bool dummy = true}) async {
    try {
      if (dummy) {
        await Future.delayed(const Duration(seconds: 1));
        return ApiResponse(
          success: _dummyRecipes["success"] as bool,
          data: (_dummyRecipes["data"] as List)
              .map((json) => RecipeModel.fromJson(json as Map<String, dynamic>))
              .where((recipe) => recipe.type == mealType)
              .toList(),
          message: "Recipes fetched successfully",
        );
      }
      return ApiResponse(success: false, message: "Real API not implemented");
    } catch (e) {
      return ApiResponse(success: false, message: "Error: $e");
    }
  }

  Future<ApiResponse<List<MenuItemModel>>> fetchMenuItems({
    required int centerId,
    required String date,
    bool dummy = true,
  }) async {
    try {
      if (dummy) {
        await Future.delayed(const Duration(seconds: 1));
        return ApiResponse(
          success: _dummyMenuItems["success"] as bool,
          data: (_dummyMenuItems["data"] as List)
              .map((json) => MenuItemModel.fromJson(json as Map<String, dynamic>))
              .where((item) => item.centerId == centerId && item.date == date)
              .toList(),
          message: "Menu items fetched successfully",
        );
      }
      return ApiResponse(success: false, message: "Real API not implemented");
    } catch (e) {
      return ApiResponse(success: false, message: "Error: $e");
    }
  }

  Future<ApiResponse> saveMenuItem({
    required String centerId,
    required String date,
    required String day,
    required String mealType,
    required List<int> recipeIds,
    bool dummy = true,
  }) async {
    try {
      if (dummy) {
        await Future.delayed(const Duration(seconds: 1));
        print('DEBUG: Saving menu item - centerId: $centerId, date: $date, day: $day, mealType: $mealType, recipeIds: $recipeIds');
        return ApiResponse(success: true, message: "Menu item saved successfully");
      }
      return ApiResponse(success: false, message: "Real API not implemented");
    } catch (e) {
      return ApiResponse(success: false, message: "Error: $e");
    }
  }
}