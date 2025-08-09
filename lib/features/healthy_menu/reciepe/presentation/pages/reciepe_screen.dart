import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:mydiaree/core/config/app_colors.dart';
import 'package:mydiaree/core/config/app_urls.dart';
import 'package:mydiaree/core/services/user_type_helper.dart';
import 'package:mydiaree/core/utils/ui_helper.dart';
import 'package:mydiaree/core/widgets/custom_action_button.dart';
import 'package:mydiaree/core/widgets/custom_app_bar.dart';
import 'package:mydiaree/core/widgets/custom_background_widget.dart';
import 'package:mydiaree/core/widgets/custom_buton.dart';
import 'package:mydiaree/core/widgets/custom_scaffold.dart';
import 'package:mydiaree/core/widgets/dropdowns/center_dropdown.dart';
import 'package:mydiaree/features/healthy_menu/reciepe/data/model/reciepe_model.dart';
import 'package:mydiaree/features/healthy_menu/reciepe/data/repositories/reciepe_repository.dart';
import 'package:mydiaree/features/healthy_menu/reciepe/presentation/pages/add_reciepe_screen.dart';
import 'package:mydiaree/main.dart';

class RecipeScreen extends StatefulWidget {
  const RecipeScreen({super.key});

  @override
  _RecipeScreenState createState() => _RecipeScreenState();
}

class _RecipeScreenState extends State<RecipeScreen> {
  final RecipeRepository _repository = RecipeRepository();
  bool _isLoading = false;
  RecipeResponseModel? _recipeResponse;
  String? selectedCenterId = '1'; // Default to Melbourne Center
  List<RecipeModel> _filteredRecipes = [];
  
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
          _filterRecipesByCenterId();
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
  
  void _filterRecipesByCenterId() {
    if (_recipeResponse == null) return;
    
    _filteredRecipes = [];
    
    // Collect all recipes from all meal types
    _recipeResponse!.recipes.forEach((mealType, recipes) {
      if (selectedCenterId != null) {
        _filteredRecipes.addAll(recipes.where(
          (recipe) => recipe.centerId.toString() == selectedCenterId
        ));
      } else {
        _filteredRecipes.addAll(recipes);
      }
    });
  }
  
  Future<void> _deleteRecipe(int recipeId) async {
    setState(() {
      _isLoading = true;
    });
    
    try {
      final response = await _repository.deleteRecipe(recipeId.toString());
      
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

  @override
  Widget build(BuildContext context) {
    return CustomScaffold(
      appBar: const CustomAppBar(
        title: 'Recipe',
      ),
      body: Column(
        children: [
          UIHelpers.verticalSpace(20),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: CenterDropdown(
              selectedCenterId: selectedCenterId,
              onChanged: (value) {
                setState(() {
                  selectedCenterId = value.id.toString();
                  _filterRecipesByCenterId();
                });
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 10),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                const SizedBox(width: 16),
                if (!UserTypeHelper.isParent)
                CustomButton(
                  text: 'Add Recipes',
                  height: 36,
                  width: 120,
                  borderRadius: 8,
                  textAppTextStyles: Theme.of(context).textTheme.labelMedium,
                  ontap: () {
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
              ],
            ),
          ),
          const Divider(),
          // Recipe Sections
          Expanded(
            child: _isLoading 
                ? const Center(child: CircularProgressIndicator())
                : _recipeResponse == null
                    ? const Center(child: Text('No recipes available'))
                    : _buildRecipeSections(),
          ),
        ],
      ),
    );
  }
  
  Widget _buildRecipeSections() {
    // Group recipes by meal type
    final Map<String, List<RecipeModel>> recipesByMealType = {};
    
    for (final recipe in _filteredRecipes) {
      if (!recipesByMealType.containsKey(recipe.type)) {
        recipesByMealType[recipe.type] = [];
      }
      recipesByMealType[recipe.type]!.add(recipe);
    }
    
    if (recipesByMealType.isEmpty) {
      return const Center(child: Text('No recipes found for this center'));
    }
    
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: recipesByMealType.entries.map((entry) {
          final mealType = entry.key;
          final recipes = entry.value;
          
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                _formatMealType(mealType),
                style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                  decoration: TextDecoration.underline,
                  fontSize: 17,
                ),
              ),
              UIHelpers.verticalSpace(8),
              GridView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  crossAxisSpacing: 16,
                  mainAxisSpacing: 16,
                  childAspectRatio: 0.7,
                ),
                itemCount: recipes.length,
                itemBuilder: (context, index) {
                  final recipe = recipes[index];
                  return _buildRecipeCard(context, recipe);
                },
              ),
              const Divider(),
            ],
          );
        }).toList(),
      ),
    );
  }

  Widget _buildRecipeCard(BuildContext context, RecipeModel recipe) {
    return PatternBackground(
      height: screenHeight * .8,
      elevation: 2,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Text(
                    recipe.itemName,
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(fontSize: 15),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
          ),
          // Image
          GestureDetector(
            onTap: () {
              showDialog(
                context: context,
                builder: (context) => Dialog(
                  child: Image.network(
                    recipe.mediaUrl != null && recipe.mediaUrl!.isNotEmpty
                        ? '${AppUrls.baseUrl}/${recipe.mediaUrl}'
                        : 'https://mydiaree.com.au/uploads/superadmins/1749498975.jpeg',
                    fit: BoxFit.contain,
                    errorBuilder: (context, error, stackTrace) =>
                        const Icon(Icons.error),
                  ),
                ),
              );
            },
            child: Image.network(
              recipe.mediaUrl != null && recipe.mediaUrl!.isNotEmpty
                  ? '${AppUrls.baseUrl}/${recipe.mediaUrl}'
                  : 'https://mydiaree.com.au/uploads/superadmins/1749498975.jpeg',
              height: screenHeight * .1,
              width: double.infinity,
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) => Center(
                child: SizedBox(
                  height: screenHeight * .1,
                  width: double.infinity,
                  child: const Icon(Icons.error),
                ),
              ),
            ),
          ),
          // Card Body
          const Expanded(
            child: SizedBox(height: 10),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'By ${recipe.createdByName}',
                  style: const TextStyle(fontSize: 12, color: Colors.grey),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
          const SizedBox(height: 1),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Padding(
                  padding: const EdgeInsets.only(bottom: 5),
                  child: SizedBox(
                    width: screenWidth * .20,
                    child: AutoSizeText(
                      _formatDate(recipe.createdAt),
                      style: const TextStyle(fontSize: 12, color: Colors.grey),
                    ),
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                   if (!UserTypeHelper.isParent)
                    CustomActionButton(
                      padding: const EdgeInsets.all(4),
                      iconSize: 15,
                      icon: Icons.edit_rounded,
                      color: AppColors.primaryColor,
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => AddRecipeScreen(
                              centerId: recipe.centerId.toString(),
                              recipeId: recipe.id.toString(),
                            ),
                          ),
                        ).then((_) => _loadRecipes());
                      },
                    ),
                    const SizedBox(width: 8),
                    CustomActionButton(
                      padding: const EdgeInsets.all(4),
                      iconSize: 15,
                      icon: Icons.delete,
                      color: AppColors.errorColor,
                      onPressed: () {
                        showDialog(
                          context: context,
                          builder: (context) => AlertDialog(
                            title: const Text('Confirm Delete'),
                            content: Text('Delete this recipe: ${recipe.itemName}?'),
                            actions: [
                              TextButton(
                                onPressed: () => Navigator.pop(context),
                                child: const Text('Cancel'),
                              ),
                              TextButton(
                                onPressed: () {
                                  Navigator.pop(context);
                                  _deleteRecipe(recipe.id);
                                },
                                child: const Text(
                                  'Delete',
                                  style: TextStyle(color: Colors.red),
                                ),
                              ),
                            ],
                          ),
                        );
                      },
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
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
}
