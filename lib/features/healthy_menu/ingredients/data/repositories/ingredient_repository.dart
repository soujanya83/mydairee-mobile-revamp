import 'package:mydiaree/core/config/app_urls.dart';
import 'package:mydiaree/core/services/api_services.dart';
import 'package:mydiaree/core/services/apiresoponse.dart';
import 'package:mydiaree/features/healthy_menu/ingredients/data/model/ingredient_model.dart';

class IngredientRepository {
  // Fetch ingredients with Bloc
  Future<ApiResponse<IngredientResponseModel?>> fetchIngredients() async {
    final url = '${AppUrls.baseUrl}/api/ingredients';

    return await getAndParseData<IngredientResponseModel>(
      url,
      fromJson: (json) => IngredientResponseModel.fromJson(json),
    );
  }

  // Add ingredient without Bloc
  Future<ApiResponse> addIngredient({
    required String name,
  }) async {
    final url = '${AppUrls.baseUrl}/api/ingredient/store';

    final Map<String, dynamic> data = {
      'name': name,
    };

    return await ApiServices.postData(
      url,
      data,
    );
  }

  // Get ingredient for edit without Bloc
  Future<ApiResponse<IngredientEditResponseModel?>> getIngredientForEdit(
      String ingredientId) async {
    final url = '${AppUrls.baseUrl}/api/ingredients/edit/$ingredientId';

    return await getAndParseData<IngredientEditResponseModel>(
      url,
      fromJson: (json) => IngredientEditResponseModel.fromJson(json),
    );
  }

  // Update ingredient without Bloc
  Future<ApiResponse> updateIngredient({
    required String ingredientId,
    required String name,
  }) async {
    final url = '${AppUrls.baseUrl}/api/ingredient/update/$ingredientId';

    final Map<String, dynamic> data = {
      'name': name,
    };

    return await ApiServices.postData(
      url,
      data,
    );
  }

  // Delete ingredient without Bloc
  Future<ApiResponse> deleteIngredient(String ingredientId) async {
    final url = '${AppUrls.baseUrl}/api/ingredient/$ingredientId';
    return await deleteDataApi(url);
  }
}