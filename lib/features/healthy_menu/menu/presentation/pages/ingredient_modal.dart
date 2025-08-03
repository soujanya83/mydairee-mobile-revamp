import 'package:flutter/material.dart';
import 'package:mydiaree/core/config/app_colors.dart';
import 'package:mydiaree/core/config/app_urls.dart';
import 'package:mydiaree/core/utils/ui_helper.dart';
import 'package:mydiaree/core/widgets/custom_buton.dart';
import 'package:mydiaree/features/healthy_menu/menu/data/model/menu_model.dart';
import 'package:mydiaree/features/healthy_menu/menu/data/repositories/menu_repository.dart';

class IngredientModal extends StatefulWidget {
  final String day;
  final String mealType;
  final String selectedDate;
  final String centerId;
  final VoidCallback? onRecipesSaved;

  const IngredientModal({
    Key? key,
    required this.day,
    required this.mealType,
    required this.selectedDate,
    required this.centerId,
    this.onRecipesSaved,
  }) : super(key: key);

  @override
  State<IngredientModal> createState() => _IngredientModalState();
}

class _IngredientModalState extends State<IngredientModal> {
  final MenuRepository _repository = MenuRepository();
  bool _isLoading = true;
  RecipeResponse? _recipeResponse;
  List<String> selectedRecipeIds = [];
  String? _searchQuery;

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
      final response = await _repository.getRecipes();
      setState(() {
        _isLoading = false;
        if (response.success && response.data != null) {
          _recipeResponse = response.data;
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

  List<RecipeModel> _getFilteredRecipes() {
    if (_recipeResponse == null) return [];

    // Get the recipes for the selected meal type
    final String normalizedMealType = _getNormalizedMealType(widget.mealType);
    final List<RecipeModel> recipes = _recipeResponse!.recipes[normalizedMealType] ?? [];
    
    // Filter by center ID
    final centerId = int.tryParse(widget.centerId);
    final centerFilteredRecipes = centerId != null 
        ? recipes.where((recipe) => recipe.centerId == centerId).toList()
        : recipes;
    
    // Apply search filter if any
    if (_searchQuery != null && _searchQuery!.isNotEmpty) {
      return centerFilteredRecipes.where((recipe) => 
        recipe.itemName.toLowerCase().contains(_searchQuery!.toLowerCase())).toList();
    }
    
    return centerFilteredRecipes;
  }

  String _getNormalizedMealType(String mealType) {
    switch (mealType.toLowerCase()) {
      case 'breakfast':
        return 'BREAKFAST';
      case 'morning tea':
      case 'morning_tea':
        return 'MORNING_TEA';
      case 'lunch':
        return 'LUNCH';
      case 'afternoon tea':
      case 'afternoon_tea':
        return 'AFTERNOON_TEA';
      case 'late snacks':
      case 'late_snacks':
        return 'LATE_SNACKS';
      default:
        return mealType.toUpperCase();
    }
  }

  Future<void> _saveRecipes() async {
    if (selectedRecipeIds.isEmpty) {
      UIHelpers.showToast(
        context,
        message: 'Please select at least one recipe',
        backgroundColor: AppColors.errorColor,
      );
      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      final response = await _repository.saveRecipes(
        selectedDate: widget.selectedDate,
        day: widget.day,
        mealType: widget.mealType,
        recipeIds: selectedRecipeIds,
        centerId: widget.centerId,
      );

      setState(() {
        _isLoading = false;
      });

      if (response.success) {
        UIHelpers.showToast(
          context,
          message: 'Recipes saved successfully',
          backgroundColor: AppColors.successColor,
        );
        Navigator.pop(context);
        if (widget.onRecipesSaved != null) {
          widget.onRecipesSaved!();
        }
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
        message: 'Failed to save recipes',
        backgroundColor: AppColors.errorColor,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      child: Container(
        width: double.infinity,
        constraints: BoxConstraints(
          maxHeight: MediaQuery.of(context).size.height * 0.8,
          maxWidth: MediaQuery.of(context).size.width * 0.9,
        ),
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Select Recipes for ${widget.day} - ${widget.mealType}',
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.close),
                  onPressed: () => Navigator.pop(context),
                ),
              ],
            ),
            const SizedBox(height: 16),
            TextField(
              decoration: InputDecoration(
                hintText: 'Search recipes...',
                prefixIcon: const Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              onChanged: (value) {
                setState(() {
                  _searchQuery = value;
                });
              },
            ),
            const SizedBox(height: 16),
            Expanded(
              child: _isLoading
                  ? const Center(child: CircularProgressIndicator())
                  : _recipeResponse == null
                      ? const Center(child: Text('No recipes available'))
                      : _buildRecipesList(),
            ),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                CustomButton(
                  text: 'Cancel',
                  color: Colors.grey,
                  ontap: () => Navigator.pop(context),
                ),
                const SizedBox(width: 16),
                CustomButton(
                  text: 'Save',
                  isLoading: _isLoading,
                  ontap: _saveRecipes,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildRecipesList() {
    final recipes = _getFilteredRecipes();
    
    if (recipes.isEmpty) {
      return const Center(child: Text('No recipes available for this meal type'));
    }
    
    return ListView.builder(
      itemCount: recipes.length,
      itemBuilder: (context, index) {
        final recipe = recipes[index];
        final isSelected = selectedRecipeIds.contains(recipe.id.toString());
        
        return ListTile(
          leading: recipe.mediaUrl != null && recipe.mediaUrl!.isNotEmpty
              ? ClipRRect(
                  borderRadius: BorderRadius.circular(4),
                  child: Image.network(
                    '${AppUrls.baseApiUrl}/${recipe.mediaUrl}',
                    width: 50,
                    height: 50,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) {
                      return Container(
                        width: 50,
                        height: 50,
                        color: Colors.grey.shade200,
                        child: const Icon(Icons.image_not_supported),
                      );
                    },
                  ),
                )
              : Container(
                  width: 50,
                  height: 50,
                  color: Colors.grey.shade200,
                  child: const Icon(Icons.image_not_supported),
                ),
          title: Text(recipe.itemName),
          subtitle: Text('Created by: ${recipe.createdByName}'),
          trailing: Checkbox(
            value: isSelected,
            activeColor: AppColors.primaryColor,
            onChanged: (value) {
              setState(() {
                if (value == true) {
                  selectedRecipeIds.add(recipe.id.toString());
                } else {
                  selectedRecipeIds.remove(recipe.id.toString());
                }
              });
            },
          ),
          onTap: () {
            setState(() {
              if (isSelected) {
                selectedRecipeIds.remove(recipe.id.toString());
              } else {
                selectedRecipeIds.add(recipe.id.toString());
              }
            });
          },
        );
      },
    );
  }
}
