import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:mydiaree/core/config/app_colors.dart';
import 'package:mydiaree/core/config/app_urls.dart';
import 'package:mydiaree/core/services/api_services.dart';
import 'package:mydiaree/core/utils/ui_helper.dart';
import 'package:mydiaree/core/widgets/custom_app_bar.dart';
import 'package:mydiaree/core/widgets/custom_buton.dart';
import 'package:mydiaree/core/widgets/custom_multi_selected_dialog.dart';
import 'package:mydiaree/core/widgets/custom_scaffold.dart';
import 'package:mydiaree/core/widgets/dropdowns/center_dropdown.dart';
import 'package:mydiaree/features/daily_journal/headchecks/presentation/widget/headchecks_custom_widgets.dart';
import 'package:mydiaree/features/healthy_menu/menu/data/model/menu_model.dart';
import 'package:mydiaree/features/healthy_menu/menu/data/repositories/menu_repository.dart';
import 'package:mydiaree/features/healthy_menu/menu/presentation/pages/ingredient_modal.dart';

class MenuScreen extends StatefulWidget {
  const MenuScreen({super.key});

  @override
  State<MenuScreen> createState() => _MenuScreenState();
}

class _MenuScreenState extends State<MenuScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  DateTime _selectedDate = DateTime.now();
  final List<String> _days = [
    'Monday',
    'Tuesday',
    'Wednesday',
    'Thursday',
    'Friday'
  ];

  String selectedCenterId = '1';
  bool _isLoading = false;
  List<MenuItemModel> _menuItems = [];
  List<CenterModel> _centers = [];
  
  final MenuRepository _repository = MenuRepository();

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: _days.length, vsync: this);
    _loadMenuItems();
  }
  
  Future<void> _loadMenuItems() async {
    setState(() {
      _isLoading = true;
    });
    
    try {
      final response = await _repository.getMenuItems(
        _formatDate(_selectedDate),
        centerId: selectedCenterId,
      );
      
      setState(() {
        _isLoading = false;
        if (response.success && response.data != null) {
          _menuItems = response.data!.menus;
          _centers = response.data!.centers;
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
        message: 'Failed to load menu items',
        backgroundColor: AppColors.errorColor,
      );
    }
  }

  Future<void> _loadRecipesAndShowDialog(String day, String mealType) async {
    // First show a dialog with loading state
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext dialogContext) {
        return AlertDialog(
          backgroundColor: Colors.white,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const CircularProgressIndicator(),
              UIHelpers.verticalSpace(16),
              Text(
                'Loading ${mealType} Recipes',
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        );
      },
    );
    
    try {
      // Get the normalized meal type
      final String normalizedType = _getNormalizedMealType(mealType);
      
      // Use the API endpoint from Postman
      final url = '${AppUrls.baseApiUrl}/api/get-recipes-by-type?type=$normalizedType';
      
      final response = await ApiServices.getData(url);
      
      // Close the loading dialog
      Navigator.of(context).pop();
      
      if (response.success) {
        // Parse the recipes from the response
        final recipesJson = response.data['recipes'] as List<dynamic>;
        final recipes = recipesJson
            .map((json) => RecipeByTypeModel(
                  id: json['id'] as int,
                  itemName: json['itemName'] as String,
                ))
            .toList();
        
        if (recipes.isEmpty) {
          UIHelpers.showToast(
            context,
            message: 'No recipes available for this meal type',
            backgroundColor: AppColors.errorColor,
          );
          return;
        }
        
        // Show multi-select dialog
        _showRecipeSelectionDialog(recipes, day, mealType);
      } else {
        UIHelpers.showToast(
          context,
          message: response.message,
          backgroundColor: AppColors.errorColor,
        );
      }
    } catch (e) {
      print("Error loading recipes by type: $e");
      
      // Make sure to close the loading dialog in case of error
      if (Navigator.of(context).canPop()) {
        Navigator.of(context).pop();
      }
      
      UIHelpers.showToast(
        context,
        message: 'Failed to load recipes',
        backgroundColor: AppColors.errorColor,
      );
    }
  }

  void _showRecipeSelectionDialog(List<RecipeByTypeModel> recipes, String day, String mealType) {
    // Convert recipes to ID and name lists
    final List<String> itemsId = recipes.map((recipe) => recipe.id.toString()).toList();
    final List<String> itemsName = recipes.map((recipe) => recipe.itemName).toList();
    
    // Track selected IDs
    List<String> selectedIds = [];
    
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return Dialog(
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
              backgroundColor: Colors.white,
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      'Select ${mealType} Recipes',
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 18,
                        color: AppColors.primaryColor,
                      ),
                    ),
                    const SizedBox(height: 12),
                    Container(
                      height: 300,
                      width: double.maxFinite,
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.grey.shade200),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Scrollbar(
                        thumbVisibility: true,
                        child: ListView.builder(
                          shrinkWrap: true,
                          itemCount: itemsId.length,
                          padding: const EdgeInsets.symmetric(vertical: 4),
                          itemBuilder: (context, index) {
                            final id = itemsId[index];
                            final name = itemsName[index];
                            final isChecked = selectedIds.contains(id);
                            
                            return CheckboxListTile(
                              value: isChecked,
                              title: Text(
                                name,
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: isChecked ? FontWeight.w600 : FontWeight.w400,
                                ),
                              ),
                              activeColor: AppColors.primaryColor,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                              dense: true,
                              onChanged: (val) {
                                setState(() {
                                  if (val == true) {
                                    if (!selectedIds.contains(id)) {
                                      selectedIds.add(id);
                                    }
                                  } else {
                                    selectedIds.removeWhere((element) => element == id);
                                  }
                                });
                              },
                            );
                          },
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        TextButton(
                          onPressed: () => Navigator.pop(context),
                          style: TextButton.styleFrom(
                            foregroundColor: Colors.grey.shade700,
                            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                          ),
                          child: const Text('Cancel'),
                        ),
                        const SizedBox(width: 8),
                        ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColors.primaryColor,
                            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                          onPressed: () {
                            Navigator.pop(context);
                            if (selectedIds.isNotEmpty) {
                              _saveSelectedRecipes(selectedIds, day, mealType);
                            } else {
                              UIHelpers.showToast(
                                context,
                                message: 'Please select at least one recipe',
                                backgroundColor: AppColors.errorColor,
                              );
                            }
                          },
                          child: const Text(
                            'OK', 
                            style: TextStyle(color: Colors.white),
                          ),
                        ),
                      ],
                    )
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }

  Future<void> _saveSelectedRecipes(List<String> recipeIds, String day, String mealType) async {
    
    // Show a dialog with loading state
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext dialogContext) {
        return AlertDialog(
          backgroundColor: Colors.white,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const CircularProgressIndicator(),
              UIHelpers.verticalSpace(16),
              const Text(
                'Adding items to menu...',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        );
      },
    );
    
    try {
      final response = await _repository.saveRecipes(
        selectedDate: _formatDate(_selectedDate),
        day: day,
        mealType: _getNormalizedMealType(mealType),
        recipeIds: recipeIds,
        centerId: selectedCenterId!,
      );
      print(response.data.toString());
      print('Response: ${response.success}, Message: ${response.message}');
      
      // Close the loading dialog
      Navigator.of(context).pop();
      
      if (response.success) {
        UIHelpers.showToast(
          context,
          message: 'Recipes added to menu successfully',
          backgroundColor: AppColors.successColor,
        );
        // Reload menu items after adding recipes
        _loadMenuItems();
      } else {
        UIHelpers.showToast(
          context,
          message: response.message,
          backgroundColor: AppColors.errorColor,
        );
      }
    } catch (e) {
      print("Error saving recipes: $e");
      
      // Close the loading dialog in case of error
      if (Navigator.of(context).canPop()) {
        Navigator.of(context).pop();
      }
      
      UIHelpers.showToast(
        context,
        message: 'Failed to save recipes',
        backgroundColor: AppColors.errorColor,
      );
    }
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return CustomScaffold(
      appBar: const CustomAppBar(
        title: "Menu",
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
                });
                _loadMenuItems();
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 10),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Weekly Menu',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: AppColors.primaryColor,
                  ),
                ),
                DatePickerButton(
                  date: _selectedDate,
                  onDateSelected: (value) {
                    setState(() {
                      _selectedDate = value;
                    });
                    _loadMenuItems();
                  },
                ),
              ],
            ),
          ),
          const Divider(),
          // Tabs
          TabBar(
            controller: _tabController,
            tabs: _days.map((day) => Tab(text: day)).toList(),
            labelColor: AppColors.primaryColor,
            unselectedLabelColor: Colors.grey,
            indicatorColor: AppColors.primaryColor,
          ),
          // Tab Content
          Expanded(
            child: _isLoading 
                ? const Center(child: CircularProgressIndicator()) 
                : TabBarView(
                    controller: _tabController,
                    children: _days.map((day) {
                      return SingleChildScrollView(
                        padding: const EdgeInsets.all(16.0),
                        child: Column(
                          children: [
                            _buildMealSection(context, day, 'Breakfast'),
                            const Divider(),
                            _buildMealSection(context, day, 'Morning Tea'),
                            const Divider(),
                            _buildMealSection(context, day, 'Lunch'),
                            const Divider(),
                            _buildMealSection(context, day, 'Afternoon Tea'),
                            const Divider(),
                            _buildMealSection(context, day, 'Late Snacks'),
                          ],
                        ),
                      );
                    }).toList(),
                  ),
          ),
        ],
      ),
    );
  }

  Widget _buildMealSection(
    BuildContext context,
    String day,
    String mealType,
  ) {
    final items = _menuItems
        .where((item) =>
            item.day.toUpperCase() == day.toUpperCase() &&
            item.mealType.toUpperCase() == _getNormalizedMealType(mealType).toUpperCase())
        .toList();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              mealType,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                decoration: TextDecoration.underline,
              ),
            ),
            CustomButton(
              text: 'Add Item',
              height: 30,
              width: 80,
              borderRadius: 8,
              textAppTextStyles: Theme.of(context).textTheme.labelSmall,
              ontap: () {
                if (selectedCenterId == null) {
                  UIHelpers.showToast(
                    context,
                    message: 'Please select a center first',
                    backgroundColor: AppColors.errorColor,
                  );
                  return;
                }
                
                // Load recipes by type and show in multi-select dialog
                _loadRecipesAndShowDialog(day, mealType);
              },
            ),
          ],
        ),
        UIHelpers.verticalSpace(8),
        items.isEmpty
            ? const Text('No items added', style: TextStyle(color: Colors.grey))
            : GridView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  childAspectRatio: 0.7, // Further reduced to make cards taller
                  crossAxisSpacing: 15,
                  mainAxisSpacing: 15,
                ),
                itemCount: items.length,
                itemBuilder: (context, index) {
                  final item = items[index];
                  return Card(
                    elevation: 3,
                    shadowColor: Colors.black26,
                    color: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                      side: BorderSide(color: Colors.grey.shade200, width: 1),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Image part with rounded corners
                        Expanded(
                          flex: 6, // Increased image area
                          child: ClipRRect(
                            borderRadius: const BorderRadius.vertical(top: Radius.circular(12)),
                            child: Container(
                              width: double.infinity,
                              decoration: BoxDecoration(
                                color: Colors.grey.shade100,
                              ),
                              child: item.mediaUrl != null && item.mediaUrl!.isNotEmpty
                                  ? Image.network(
                                      '${AppUrls.baseApiUrl}/${item.mediaUrl}',
                                      fit: BoxFit.cover,
                                      errorBuilder: (_, __, ___) => Center(
                                        child: Icon(
                                          Icons.image_not_supported,
                                          color: Colors.grey.shade400,
                                          size: 40,
                                        ),
                                      ),
                                      loadingBuilder: (context, child, loadingProgress) {
                                        if (loadingProgress == null) return child;
                                        return Center(
                                          child: CircularProgressIndicator(
                                            value: loadingProgress.expectedTotalBytes != null
                                                ? loadingProgress.cumulativeBytesLoaded /
                                                    loadingProgress.expectedTotalBytes!
                                                : null,
                                            strokeWidth: 2,
                                            color: AppColors.primaryColor,
                                          ),
                                        );
                                      },
                                    )
                                  : Center(
                                      child: Icon(
                                        Icons.image_not_supported,
                                        color: Colors.grey.shade400,
                                        size: 40,
                                      ),
                                    ),
                            ),
                          ),
                        ),
                        // Info part with better padding and spacing
                        Expanded(
                          flex: 5,
                          child: Padding(
                            padding: const EdgeInsets.all(12.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                // Item name with better styling
                                Text(
                                  item.name,
                                  style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 14,
                                    height: 1.3,
                                  ),
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                ),
                                const SizedBox(height: 8),
                                
                                // Date and delete icon in a row
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    // Date with better styling
                                    Expanded(
                                      child: Text(
                                        DateFormat('MMM dd, yyyy').format(
                                          DateTime.parse(item.createdAt),
                                        ),
                                        style: TextStyle(
                                          fontSize: 12,
                                          color: Colors.grey.shade600,
                                        ),
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    ),
                                    // Delete button
                                    Material(
                                      color: Colors.transparent,
                                      child: InkWell(
                                        onTap: () => _showDeleteConfirmation(context, item.id.toString()),
                                        borderRadius: BorderRadius.circular(20),
                                        child: Container(
                                          padding: const EdgeInsets.all(6),
                                          decoration: BoxDecoration(
                                            color: Colors.red.shade50,
                                            shape: BoxShape.circle,
                                          ),
                                          child: Icon(
                                            Icons.delete_outline,
                                            color: Colors.red.shade800,
                                            size: 18,
                                          ),
                                        ),
                                      ),
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
              ),
      ],
    );
  }

  String _formatDate(DateTime date) {
    return '${date.day.toString().padLeft(2, '0')}-${date.month.toString().padLeft(2, '0')}-${date.year}';
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

  void _showDeleteConfirmation(BuildContext context, String recipeId) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        title: Row(
          children: [
            Icon(Icons.warning_amber_rounded, color: Colors.red.shade700),
            const SizedBox(width: 10),
            const Text('Delete Menu Item'),
          ],
        ),
        content: const Text(
          'Are you sure you want to delete this menu item? This action cannot be undone.',
          style: TextStyle(fontSize: 14),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            style: TextButton.styleFrom(
              foregroundColor: Colors.grey.shade700,
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            ),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
              _deleteRecipe(recipeId);
            },
            style: TextButton.styleFrom(
              foregroundColor: Colors.white,
              backgroundColor: Colors.red.shade700,
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            child: const Text('Delete'),
          ),
        ],
      ),
    );
  }

  Future<void> _deleteRecipe(String menuId) async {
    setState(() {
      _isLoading = true;
    });
    
    try {
      final response = await _repository.deleteMenuItem(menuId);
      
      setState(() {
        _isLoading = false;
      });
      
      if (response.success) {
        UIHelpers.showToast(
          context,
          message: 'Menu item deleted successfully',
          backgroundColor: AppColors.successColor,
        );
        // Reload menu items after deletion
        _loadMenuItems();
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
        message: 'Failed to delete menu item',
        backgroundColor: AppColors.errorColor,
      );
    }
  }
}