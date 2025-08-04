import 'package:flutter/material.dart';
import 'package:mydiaree/core/config/app_colors.dart';
import 'package:mydiaree/core/config/app_urls.dart';
import 'package:mydiaree/core/services/api_services.dart';
import 'package:mydiaree/core/services/apiresoponse.dart';
import 'package:mydiaree/core/utils/ui_helper.dart';
import 'package:mydiaree/core/widgets/custom_buton.dart';
import 'package:mydiaree/features/healthy_menu/menu/data/repositories/menu_repository.dart';

class IngredientModal extends StatefulWidget {
  final String day;
  final String mealType;
  final String selectedDate;
  final String centerId;
  final Function onRecipesSaved;

  const IngredientModal({
    Key? key,
    required this.day,
    required this.mealType,
    required this.selectedDate,
    required this.centerId,
    required this.onRecipesSaved,
  }) : super(key: key);

  @override
  State<IngredientModal> createState() => _IngredientModalState();
}

class _IngredientModalState extends State<IngredientModal> {
  final MenuRepository _repository = MenuRepository();
  bool _isLoading = true;
  bool _isSaving = false;
  List<RecipeByTypeModel> _recipes = [];
  final List<String> _selectedRecipeIds = [];

  @override
  void initState() {
    super.initState();
    _loadRecipesByType();
  }

  Future<void> _loadRecipesByType() async {
    setState(() {
      _isLoading = true;
    });

    try {
      // Get the normalized meal type
      final String normalizedType = _getNormalizedMealType(widget.mealType);
      
      // Use the API endpoint from Postman
      final url = '${AppUrls.baseApiUrl}/api/get-recipes-by-type?type=$normalizedType';
      
      final response = await ApiServices.getData(url);

      setState(() {
        _isLoading = false;
        if (response.success) {
          // Parse the recipes from the response
          final recipesJson = response.data['recipes'] as List<dynamic>;
          _recipes = recipesJson
              .map((json) => RecipeByTypeModel(
                    id: json['id'] as int,
                    itemName: json['itemName'] as String,
                  ))
              .toList();
        } else {
          UIHelpers.showToast(
            context,
            message: response.message,
            backgroundColor: AppColors.errorColor,
          );
        }
      });
    } catch (e) {
      print("Error loading recipes by type: $e");
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

  Future<void> _saveSelectedRecipes() async {
    
    if (_selectedRecipeIds.isEmpty) {
      UIHelpers.showToast(
        context,
        message: 'Please select at least one recipe',
        backgroundColor: AppColors.errorColor,
      );
      return;
    }

    setState(() {
      _isSaving = true;
    });

    try {
      final response = await _repository.saveRecipes(
        selectedDate: widget.selectedDate,
        day: widget.day,
        mealType: _getNormalizedMealType(widget.mealType),
        recipeIds: _selectedRecipeIds,
        centerId: widget.centerId,
      );

      setState(() {
        _isSaving = false;
      });

      if (response.success) {
        UIHelpers.showToast(
          context,
          message: 'Recipes added to menu successfully',
          backgroundColor: AppColors.successColor,
        );
        Navigator.pop(context);
        widget.onRecipesSaved();
      } else {
        UIHelpers.showToast(
          context,
          message: response.message,
          backgroundColor: AppColors.errorColor,
        );
      }
    } catch (e) {
      setState(() {
        _isSaving = false;
      });
      UIHelpers.showToast(
        context,
        message: 'Failed to save recipes',
        backgroundColor: AppColors.errorColor,
      );
    }
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

  @override
  Widget build(BuildContext context) {
    final Size screenSize = MediaQuery.of(context).size;
    
    return Dialog(
      backgroundColor: Colors.white,
      elevation: 8,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      child: Container(
        padding: const EdgeInsets.all(16),
        color: Colors.white,
        width: double.infinity,
        constraints: BoxConstraints(
          maxHeight: screenSize.height * 0.7,
          maxWidth: screenSize.width * 0.9,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header row
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Text(
                    'Select ${widget.mealType} Recipes',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: AppColors.primaryColor,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.close),
                  padding: EdgeInsets.zero,
                  constraints: const BoxConstraints(),
                  onPressed: () => Navigator.pop(context),
                ),
              ],
            ),
            const Divider(height: 24),
            
            // Day info
            Container(
              padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
              decoration: BoxDecoration(
                color: Colors.grey.shade100,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Text(
                'Day: ${widget.day}',
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
            const SizedBox(height: 16),
            
            // Content area - recipes list
            Expanded(
              child: _isLoading
                  ? const Center(
                      child: CircularProgressIndicator(),
                    )
                  : _recipes.isEmpty
                      ? Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                Icons.no_food,
                                size: 48,
                                color: Colors.grey.shade400,
                              ),
                              const SizedBox(height: 16),
                              Text(
                                'No recipes available for this meal type',
                                style: TextStyle(
                                  fontSize: 16,
                                  color: Colors.grey.shade600,
                                ),
                                textAlign: TextAlign.center,
                              ),
                            ],
                          ),
                        )
                      : ClipRRect(
                          borderRadius: BorderRadius.circular(8),
                          child: ListView.builder(
                            itemCount: _recipes.length,
                            shrinkWrap: true,
                            padding: EdgeInsets.zero,
                            itemBuilder: (context, index) {
                              final recipe = _recipes[index];
                              final isSelected = _selectedRecipeIds.contains(recipe.id.toString());
                              
                              return Card(
                                elevation: 1,
                                margin: const EdgeInsets.symmetric(vertical: 4),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(8),
                                  side: BorderSide(
                                    color: isSelected ? AppColors.primaryColor.withOpacity(0.3) : Colors.transparent,
                                    width: 1,
                                  ),
                                ),
                                child: CheckboxListTile(
                                  title: Text(
                                    recipe.itemName,
                                    style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
                                    ),
                                  ),
                                  value: isSelected,
                                  activeColor: AppColors.primaryColor,
                                  controlAffinity: ListTileControlAffinity.leading,
                                  contentPadding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                                  dense: true,
                                  onChanged: (bool? value) {
                                    setState(() {
                                      if (value == true) {
                                        _selectedRecipeIds.add(recipe.id.toString());
                                      } else {
                                        _selectedRecipeIds.remove(recipe.id.toString());
                                      }
                                    });
                                  },
                                ),
                              );
                            },
                          ),
                        ),
            ),
            
            // Button area
            const SizedBox(height: 16),
            SafeArea(
              child: CustomButton(
                text: 'Add to Menu',
                isLoading: _isSaving,
                ontap: _saveSelectedRecipes,
                width: double.infinity,
                height: 48,
                borderRadius: 8,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// Model for recipe response
class RecipeByTypeModel {
  final int id;
  final String itemName;

  RecipeByTypeModel({
    required this.id,
    required this.itemName,
  });
}
