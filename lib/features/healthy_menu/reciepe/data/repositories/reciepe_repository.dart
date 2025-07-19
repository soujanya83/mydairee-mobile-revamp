import 'package:mydiaree/core/services/apiresoponse.dart';
import 'package:mydiaree/features/healthy_menu/reciepe/data/model/reciepe_model.dart'; 

class RecipeRepository {
  // Dummy data for centers (reused from menu)
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

  // Dummy data for ingredients
  final Map<String, dynamic> _dummyIngredients = {
    "success": true,
    "data": [
      {"id": 1, "name": "All Purpose Flour"},
      {"id": 2, "name": "Powdered Sugar"},
      {"id": 4, "name": "Butter"},
      {"id": 5, "name": "Baking Soda"},
      {"id": 6, "name": "Milk"},
      {"id": 7, "name": "Vanilla Essence"},
      {"id": 8, "name": "Coriander"},
      {"id": 9, "name": "Mint"},
      {"id": 10, "name": "Roasted Gram Dal"},
      {"id": 11, "name": "Chilli"},
      {"id": 12, "name": "Ginger"},
      {"id": 13, "name": "Garlic"},
      {"id": 14, "name": "Lemon Juice"},
      {"id": 15, "name": "Cumin Powder"},
      {"id": 16, "name": "Chaat Masala"},
      {"id": 17, "name": "Aamchur Powder"},
      {"id": 18, "name": "Salt"},
      {"id": 19, "name": "Water"},
      {"id": 20, "name": "Oil"},
      {"id": 21, "name": "Bread"},
      {"id": 22, "name": "Cheese"},
      {"id": 24, "name": "Tomato"},
      {"id": 25, "name": "Beetroot"},
      {"id": 26, "name": "Carrot"},
      {"id": 27, "name": "Onion"},
      {"id": 28, "name": "Potato"},
      {"id": 29, "name": "Mushroom"},
      {"id": 30, "name": "Rice"},
      {"id": 31, "name": "Curd"},
      {"id": 34, "name": "Dal"},
      {"id": 35, "name": "Oats"},
      {"id": 37, "name": "Soya Sauce"},
      {"id": 38, "name": "Bread Butter"},
    ]
  };

  // Dummy data for recipes
  final Map<String, dynamic> _dummyRecipes = {
    "success": true,
    "data": [
      {
        "id": 1,
        "itemName": "Samosa",
        "type": "SNACKS",
        "imageUrl": "https://mydiaree.com.au/storage/uploads/recipes/potato-samosa_11240.jpg",
        "creator": "Deepti (Superadmin)",
        "createdAt": "21-01-2022",
        "description": "Crispy samosa with potato filling",
        "ingredientId": 28
      },
      {
        "id": 5,
        "itemName": "Dahi Wada",
        "type": "SNACKS",
        "imageUrl": "https://mydiaree.com.au/storage/uploads/recipes/dahi-balla-2.jpg",
        "creator": "Deepti (Superadmin)",
        "createdAt": "21-01-2022",
        "description": "Soft wadas soaked in curd",
        "ingredientId": 31
      },
      {
        "id": 68,
        "itemName": "Dalbati",
        "type": "LUNCH",
        "imageUrl": "https://mydiaree.com.au/storage/uploads/recipes/Dal bati.jpeg",
        "creator": "Kailash Sahu (Staff)",
        "createdAt": "14-02-2022",
        "description": "Traditional Rajasthani dal and bati",
        "ingredientId": 34
      },
      {
        "id": 199,
        "itemName": "Test2",
        "type": "MORNING_TEA",
        "imageUrl": "https://mydiaree.com.au/storage/uploads/recipes/IMG-20250421-WA0007.jpg",
        "creator": "Deepti (Superadmin)",
        "createdAt": "22-04-2025",
        "description": "Test morning tea recipe",
        "ingredientId": 6
      },],
  };
  Future<ApiResponse<List<IngredientModel>>> fetchIngredients({bool dummy = true}) async {
    try {
      if (dummy) {
        await Future.delayed(const Duration(seconds: 1));
        return ApiResponse(
          success: _dummyIngredients["success"] as bool,
          data: (_dummyIngredients["data"] as List)
              .map((json) => IngredientModel.fromJson(json as Map<String, dynamic>))
              .toList(),
          message: "Ingredients fetched successfully",
        );
      }
      return ApiResponse(success: false, message: "Real API not implemented");
    } catch (e) {
      return ApiResponse(success: false, message: "Error: $e");
    }
  }

  Future<ApiResponse<List<RecipeModel>>> fetchRecipes({
    required int centerId,
    bool dummy = true,
  }) async {
    try {
      if (dummy) {
        await Future.delayed(const Duration(seconds: 1));
        return ApiResponse(
          success: _dummyRecipes["success"] as bool,
          data: (_dummyRecipes["data"] as List)
              .map((json) => RecipeModel.fromJson(json as Map<String, dynamic>))
              .toList(),
          message: "Recipes fetched successfully",
        );
      }
      return ApiResponse(success: false, message: "Real API not implemented");
    } catch (e) {
      return ApiResponse(success: false, message: "Error: $e");
    }
  }

  Future<ApiResponse> addRecipe({
      String? id,
    required String itemName,
    required String mealType,
    required int ingredientId,
    required String description,
    required String imagePath,
    required String creator,
    bool dummy = true,
  }) async {
    try {
      if (dummy) {
        await Future.delayed(const Duration(seconds: 1));
        print('DEBUG: Adding recipe - itemName: $itemName, mealType: $mealType, ingredientId: $ingredientId, description: $description, imagePath: $imagePath, creator: $creator');
        return ApiResponse(success: true, message: "Recipe added successfully");
      }
      return ApiResponse(success: false, message: "Real API not implemented");
    } catch (e) {
      return ApiResponse(success: false, message: "Error: $e");
    }
  }

  Future<ApiResponse> deleteRecipe({
    required int recipeId,
    bool dummy = true,
  }) async {
    try {
      if (dummy) {
        await Future.delayed(const Duration(seconds: 1));
        print('DEBUG: Deleting recipe - recipeId: $recipeId');
        return ApiResponse(success: true, message: "Recipe deleted successfully");
      }
      return ApiResponse(success: false, message: "Real API not implemented");
    } catch (e) {
      return ApiResponse(success: false, message: "Error: $e");
    }
  }
}