
import 'package:mydiaree/core/services/apiresoponse.dart';
import 'package:mydiaree/features/healthy_menu/reciepe/data/model/reciepe_model.dart';

class IngredientRepository {
  Future<ApiResponse> fetchIngredients({bool dummy = true}) async {
    try {
      if (dummy) {
        await Future.delayed(const Duration(seconds: 1));
        return ApiResponse(
          success: true,
          data: [
            IngredientModel(id: 1, name: 'All Purpose Flour'),
            IngredientModel(id: 2, name: 'Powdered Sugar'),
            IngredientModel(id: 4, name: 'Butter'),
            IngredientModel(id: 5, name: 'Baking Soda'),
            IngredientModel(id: 6, name: 'Milk'),
            IngredientModel(id: 7, name: 'Vanilla Essence'),
            IngredientModel(id: 8, name: 'Coriander'),
            IngredientModel(id: 9, name: 'Mint'),
            IngredientModel(id: 10, name: 'Roasted Gram Dal'),
            IngredientModel(id: 11, name: 'Chilli'),
            IngredientModel(id: 12, name: 'Ginger'),
            IngredientModel(id: 13, name: 'Garlic'),
            IngredientModel(id: 14, name: 'Lemon Juice'),
            IngredientModel(id: 15, name: 'Cumin Powder'),
            IngredientModel(id: 16, name: 'Chaat Masala'),
            IngredientModel(id: 17, name: 'Aamchur Powder'),
            IngredientModel(id: 18, name: 'Salt'),
            IngredientModel(id: 19, name: 'Water'),
            IngredientModel(id: 20, name: 'Oil'),
            IngredientModel(id: 21, name: 'Bread'),
            IngredientModel(id: 22, name: 'Cheese'),
            IngredientModel(id: 24, name: 'Tomato'),
            IngredientModel(id: 25, name: 'Beetroot'),
            IngredientModel(id: 26, name: 'Carrot'),
            IngredientModel(id: 27, name: 'Onion'),
            IngredientModel(id: 28, name: 'Potato'),
            IngredientModel(id: 29, name: 'Mushroom'),
            IngredientModel(id: 30, name: 'Rice'),
            IngredientModel(id: 31, name: 'Curd'),
            IngredientModel(id: 34, name: 'Dal'),
            IngredientModel(id: 35, name: 'Oats'),
            IngredientModel(id: 37, name: 'Soya Sauce'),
            IngredientModel(id: 38, name: 'Bread Butter'),
          ], message: '',
        );
      }
      return ApiResponse(success: false, message: "Real API not implemented");
    } catch (e) {
      return ApiResponse(success: false, message: "Error: $e");
    }
  }

  Future<ApiResponse> addIngredient({
    required String name,
    required String creator,
    bool dummy = true,
  }) async {
    try {
      if (dummy) {
        await Future.delayed(const Duration(seconds: 1));
        print('DEBUG: Adding ingredient - name: $name, creator: $creator');
        return ApiResponse(success: true, message: "Ingredient added successfully");
      }
      return ApiResponse(success: false, message: "Real API not implemented");
    } catch (e) {
      return ApiResponse(success: false, message: "Error: $e");
    }
  }

  Future<ApiResponse> updateIngredient({
    required int id,
    required String name,
    required String creator,
    bool dummy = true,
  }) async {
    try {
      if (dummy) {
        await Future.delayed(const Duration(seconds: 1));
        print('DEBUG: Updating ingredient - id: $id, name: $name, creator: $creator');
        return ApiResponse(success: true, message: "Ingredient updated successfully");
      }
      return ApiResponse(success: false, message: "Real API not implemented");
    } catch (e) {
      return ApiResponse(success: false, message: "Error: $e");
    }
  }

  Future<ApiResponse> deleteIngredient(int id, {bool dummy = true}) async {
    try {
      if (dummy) {
        await Future.delayed(const Duration(seconds: 1));
        print('DEBUG: Deleting ingredient - id: $id');
        return ApiResponse(success: true, message: "Ingredient deleted successfully");
      }
      return ApiResponse(success: false, message: "Real API not implemented");
    } catch (e) {
      return ApiResponse(success: false, message: "Error: $e");
    }
  }}