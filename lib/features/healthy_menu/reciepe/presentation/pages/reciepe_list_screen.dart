import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:mydiaree/core/config/app_colors.dart';
import 'package:mydiaree/core/config/app_urls.dart';
import 'package:mydiaree/core/utils/ui_helper.dart';
import 'package:mydiaree/core/widgets/custom_app_bar.dart';
import 'package:mydiaree/core/widgets/custom_buton.dart';
import 'package:mydiaree/core/widgets/custom_scaffold.dart';
import 'package:mydiaree/core/widgets/dropdowns/center_dropdown.dart';
import 'package:mydiaree/features/healthy_menu/reciepe/data/model/reciepe_model.dart';
import 'package:mydiaree/features/healthy_menu/reciepe/data/repositories/reciepe_repository.dart';
import 'package:mydiaree/features/healthy_menu/reciepe/presentation/pages/add_reciepe_screen.dart'; 

class RecipeListScreen extends StatefulWidget {
  const RecipeListScreen({super.key});

  @override
  State<RecipeListScreen> createState() => _RecipeListScreenState();
}

class _RecipeListScreenState extends State<RecipeListScreen> {
  final RecipeRepository _repository = RecipeRepository();
  bool _isLoading = false;
  RecipeResponseModel? _recipeResponse;
  String? selectedCenterId = '1'; // Default center
  String? selectedMealType;
  String searchQuery = '';
  
  @override
  void initState() {
    super.initState();
    _loadRecipes();
  }
  
  Future<void> _loadRecipes() async {
    setState(() {
      _isLoading = true;
    });
    
    try {
      final response = await _repository.fetchRecipes();
      
      setState(() {
        _isLoading = false;
        if (response.success && response.data != null) {
          _recipeResponse = response.data;
        } else {
          UIHelpers.showToast(
            context,
            message: response.message,
            backgroundColor: AppColors.errorColor,
          );
        }
      });
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
      UIHelpers.showToast(
        context,
        message: 'Failed to load recipes',
        backgroundColor: AppColors.errorColor,
      );
    }
  }
  
  Future<void> _deleteRecipe(String recipeId) async {
    setState(() {
      _isLoading = true;
    });
    
    try {
      final response = await _repository.deleteRecipe(recipeId);
      
      setState(() {
        _isLoading = false;
      });
      
      if (response.success) {
        UIHelpers.showToast(
          context,
          message: 'Recipe deleted successfully',
          backgroundColor: AppColors.successColor,
        );
        // Reload recipes after deletion
        _loadRecipes();
      } else {
        UIHelpers.showToast(
          context,
          message: response.message,
          backgroundColor: AppColors.errorColor,
        );
      }
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
      UIHelpers.showToast(
        context,
        message: 'Failed to delete recipe',
        backgroundColor: AppColors.errorColor,
      );
    }
  }
  
  List<RecipeModel> _getFilteredRecipes() {
    if (_recipeResponse == null) return [];
    
    List<RecipeModel> allRecipes = [];
    
    // Collect all recipes from all meal types
    _recipeResponse!.recipes.forEach((mealType, recipes) {
      if (selectedMealType == null || mealType == selectedMealType) {
        allRecipes.addAll(recipes);
      }
    });
    
    // Filter by center
    if (selectedCenterId != null) {
      allRecipes = allRecipes.where((recipe) => 
        recipe.centerId.toString() == selectedCenterId).toList();
    }
    
    // Filter by search query
    if (searchQuery.isNotEmpty) {
      allRecipes = allRecipes.where((recipe) => 
        recipe.itemName.toLowerCase().contains(searchQuery.toLowerCase())).toList();
    }
    
    return allRecipes;
  }

  @override
  Widget build(BuildContext context) {
    return CustomScaffold(
      appBar: const CustomAppBar(
        title: "Recipes",
      ),
      body: Column(
        children: [
          UIHelpers.verticalSpace(20),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Row(
              children: [
                Expanded(
                  child: CenterDropdown(
                    selectedCenterId: selectedCenterId,
                    onChanged: (value) {
                      setState(() {
                        selectedCenterId = value.id.toString();
                      });
                    },
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12),
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.grey),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: DropdownButtonHideUnderline(
                      child: DropdownButton<String>(
                        isExpanded: true,
                        hint: const Text('All Meal Types'),
                        value: selectedMealType,
                        items: _recipeResponse?.uniqueMealTypes.map((type) {
                          return DropdownMenuItem(
                            value: type,
                            child: Text(_formatMealType(type)),
                          );
                        }).toList() ?? [],
                        onChanged: (value) {
                          setState(() {
                            selectedMealType = value;
                          });
                        },
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          UIHelpers.verticalSpace(10),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: TextField(
              decoration: InputDecoration(
                hintText: 'Search recipes...',
                prefixIcon: const Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              onChanged: (value) {
                setState(() {
                  searchQuery = value;
                });
              },
            ),
          ),
          UIHelpers.verticalSpace(16),
          Expanded(
            child: _isLoading 
                ? const Center(child: CircularProgressIndicator())
                : _recipeResponse == null
                    ? const Center(child: Text('No recipes available'))
                    : _buildRecipeGrid(),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: AppColors.primaryColor,
        child: const Icon(Icons.add),
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => AddRecipeScreen(
                centerId: selectedCenterId ?? '1',
              ),
            ),
          ).then((_) => _loadRecipes());
        },
      ),
    );
  }
  
  Widget _buildRecipeGrid() {
    final recipes = _getFilteredRecipes();
    
    if (recipes.isEmpty) {
      return const Center(child: Text('No recipes found'));
    }
    
    return GridView.builder(
      padding: const EdgeInsets.all(16),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        childAspectRatio: 0.7,
        crossAxisSpacing: 10,
        mainAxisSpacing: 10,
      ),
      itemCount: recipes.length,
      itemBuilder: (context, index) {
        final recipe = recipes[index];
        return Card(
          elevation: 3,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Image
              Expanded(
                flex: 5,
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: const BorderRadius.vertical(
                      top: Radius.circular(10),
                    ),
                    image: recipe.mediaUrl != null && recipe.mediaUrl!.isNotEmpty
                        ? DecorationImage(
                            image: NetworkImage(
                              '${AppUrls.baseUrl}/${recipe.mediaUrl}',
                            ),
                            fit: BoxFit.cover,
                            onError: (_, __) => const Icon(Icons.image_not_supported),
                          )
                        : null,
                    color: Colors.grey.shade200,
                  ),
                  child: recipe.mediaUrl == null || recipe.mediaUrl!.isEmpty
                      ? const Center(
                          child: Icon(
                            Icons.image_not_supported,
                            color: Colors.grey,
                            size: 30,
                          ),
                        )
                      : null,
                ),
              ),
              // Content
              Expanded(
                flex: 5,
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            recipe.itemName,
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 14,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                          UIHelpers.verticalSpace(4),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                            decoration: BoxDecoration(
                              color: AppColors.primaryColor.withOpacity(0.1),
                              borderRadius: BorderRadius.circular(4),
                            ),
                            child: Text(
                              _formatMealType(recipe.type),
                              style: TextStyle(
                                fontSize: 12,
                                color: AppColors.primaryColor,
                              ),
                            ),
                          ),
                          UIHelpers.verticalSpace(4),
                          Text(
                            'By ${recipe.createdByName}',
                            style: TextStyle(
                              fontSize: 12,
                              color: Colors.grey.shade600,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ],
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            _formatDate(recipe.createdAt),
                            style: TextStyle(
                              fontSize: 11,
                              color: Colors.grey.shade600,
                            ),
                          ),
                          Row(
                            children: [
                              InkWell(
                                onTap: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => AddRecipeScreen(
                                        centerId: selectedCenterId ?? '1',
                                        recipeId: recipe.id.toString(),
                                      ),
                                    ),
                                  ).then((_) => _loadRecipes());
                                },
                                child: Container(
                                  padding: const EdgeInsets.all(4),
                                  decoration: BoxDecoration(
                                    color: AppColors.primaryColor.withOpacity(0.1),
                                    borderRadius: BorderRadius.circular(4),
                                  ),
                                  child: Icon(
                                    Icons.edit_outlined,
                                    color: AppColors.primaryColor,
                                    size: 16,
                                  ),
                                ),
                              ),
                              const SizedBox(width: 6),
                              InkWell(
                                onTap: () => _showDeleteConfirmation(context, recipe.id.toString()),
                                child: Container(
                                  padding: const EdgeInsets.all(4),
                                  decoration: BoxDecoration(
                                    color: Colors.red.shade50,
                                    borderRadius: BorderRadius.circular(4),
                                  ),
                                  child: Icon(
                                    Icons.delete_outline,
                                    color: Colors.red.shade800,
                                    size: 16,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
  
  String _formatMealType(String type) {
    return type.replaceAll('_', ' ').toLowerCase().split(' ').map((word) => 
      word.isNotEmpty ? '${word[0].toUpperCase()}${word.substring(1)}' : '').join(' ');
  }
  
  String _formatDate(String dateStr) {
    try {
      final date = DateTime.parse(dateStr);
      return DateFormat('MMM dd, yyyy').format(date);
    } catch (e) {
      return dateStr;
    }
  }
  
  void _showDeleteConfirmation(BuildContext context, String recipeId) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Recipe'),
        content: const Text('Are you sure you want to delete this recipe?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
              _deleteRecipe(recipeId);
            },
            style: TextButton.styleFrom(foregroundColor: Colors.red),
            child: const Text('Delete'),
          ),
        ],
      ),
    );
  }
}