import 'package:mydiaree/core/config/app_urls.dart';
import 'package:mydiaree/core/services/api_services.dart';
import 'package:mydiaree/core/services/apiresoponse.dart';
import 'package:mydiaree/features/healthy_menu/menu/data/model/menu_model.dart';

class MenuRepository {
  Future<ApiResponse<MenuResponse?>> getMenuItems(String? selectedDate, {String? centerId}) async {
    final url = '${AppUrls.baseApiUrl}/api/healthy-menu';
    final data = {
      if (selectedDate != null) 'selected_date': selectedDate,
      if (centerId != null) 'center_id': centerId,
    };
    
    return await postAndParse<MenuResponse>(
      url,
      data,
      fromJson: (json) => MenuResponse.fromJson(json),
    );
  }
  
  Future<ApiResponse<RecipeResponse?>> getRecipes() async {
    final url = '${AppUrls.baseApiUrl}/api/healthy-recipes';
    
    return await postAndParse<RecipeResponse>(
      url,
      {},
      fromJson: (json) => RecipeResponse.fromJson(json),
    );
  }
  
  Future<ApiResponse> saveRecipes({
    required String selectedDate,
    required String day,
    required String mealType,
    required List<String> recipeIds,
    required String centerId,
  }) async {
    final url = '${AppUrls.baseApiUrl}/api/save-recipes';
    
    final Map<String, dynamic> data = {
      'selected_date': selectedDate,
      'day': day,
      'meal_type': mealType,
      'center_id': centerId,
      'recipe_ids': recipeIds, // Convert list to comma-separated string
    };
    
    // Add recipe_ids as separate fields
    // for (int i = 0; i < recipeIds.length; i++) {
    //   data['recipe_ids[$i]'] = recipeIds[i];
    // }
    
    return await ApiServices.postData(url, data);
  }
  
  Future<ApiResponse> deleteMenuItem(String menuId) async {
    final url = '${AppUrls.baseApiUrl}/api/menu/$menuId';
    return await deleteDataApi(url);
  }
}