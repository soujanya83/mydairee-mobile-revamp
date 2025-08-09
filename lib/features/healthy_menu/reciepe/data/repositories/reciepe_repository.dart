import 'package:mydiaree/core/config/app_urls.dart';
import 'package:mydiaree/core/services/api_services.dart';
import 'package:mydiaree/core/services/apiresoponse.dart';
import 'package:mydiaree/features/healthy_menu/reciepe/data/model/reciepe_model.dart';

class RecipeRepository {
  // Fetch all recipes with their categories
  Future<ApiResponse<RecipeResponseModel?>> fetchRecipes() async {
    final url = '${AppUrls.baseUrl}/api/healthy-recipes';
    
    return await postAndParse<RecipeResponseModel>(
      url,
      {},
      fromJson: (json) => RecipeResponseModel.fromJson(json),
    );
  }
  
  // Delete a recipe
  Future<ApiResponse> deleteRecipe(String recipeId) async {
    final url = '${AppUrls.baseUrl}/api/recipe/delete/$recipeId';
    return await deleteDataApi(url);
  }
  
  // Add a new recipe
  Future<ApiResponse> addRecipe({
    required String itemName,
    required String mealType,
    required String ingredient,
    required String recipe,
    required String centerId,
    List<String>? filesPath,
  }) async {
    final url = '${AppUrls.baseUrl}/api/recipe/store';

    final Map<String, dynamic> data = {
      'itemName': itemName,
      'mealType': mealType,
      'ingredient': ingredient,
      'recipe': recipe,
      'centerId': centerId,
    };

    print('addRecipe data: $data'); // Debug print

    return await ApiServices.postData(
      url,
      data,
      filesPath: filesPath,
      fileField: 'image',
    );
  }
  
  // Get recipe details for editing
  Future<ApiResponse<RecipeEditResponseModel?>> getRecipeForEdit(String recipeId) async {
    final url = '${AppUrls.baseUrl}/api/recipe/edit/$recipeId';
    
    return await getAndParseData<RecipeEditResponseModel>(
      url,
      fromJson: (json) => RecipeEditResponseModel.fromJson(json),
    );
  }
  
  // Update existing recipe
  Future<ApiResponse> updateRecipe({
    required String recipeId,
    required String itemName,
    required String mealType,
    required String ingredient,
    required String recipe,
    required String centerId,
    List<String>? filesPath,
  }) async {
    final url = '${AppUrls.baseUrl}/api/recipe/update/$recipeId';
    
    final Map<String, dynamic> data = {
      'itemName': itemName,
      'mealType': mealType,
      'ingredient': ingredient,
      'recipe': recipe,
      'centerId': centerId,
    };
    
    return await ApiServices.postData(
      url, 
      data,
      filesPath: filesPath,
      fileField: 'recipeImage',
    );
  }
}