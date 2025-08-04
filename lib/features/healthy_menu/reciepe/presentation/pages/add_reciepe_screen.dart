import 'dart:io';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:html/parser.dart' as html_parser;
import 'package:mydiaree/core/config/app_colors.dart';
import 'package:mydiaree/core/config/app_urls.dart';
import 'package:mydiaree/core/services/apiresoponse.dart';
import 'package:mydiaree/core/utils/ui_helper.dart';
import 'package:mydiaree/core/widgets/custom_app_bar.dart';
import 'package:mydiaree/core/widgets/custom_buton.dart';
import 'package:mydiaree/core/widgets/custom_scaffold.dart';
import 'package:mydiaree/core/widgets/custom_text_field.dart';
import 'package:mydiaree/features/healthy_menu/reciepe/data/model/reciepe_model.dart';
import 'package:mydiaree/features/healthy_menu/reciepe/data/repositories/reciepe_repository.dart';
import 'package:mydiaree/features/healthy_menu/reciepe/presentation/bloc/list/reciepe_bloc.dart';

class AddRecipeScreen extends StatefulWidget {
  final String centerId;
  final String? recipeId;
  
  const AddRecipeScreen({
    super.key,
    required this.centerId,
    this.recipeId,
  });

  @override
  State<AddRecipeScreen> createState() => _AddRecipeScreenState();
}

class _AddRecipeScreenState extends State<AddRecipeScreen> {
  final _formKey = GlobalKey<FormState>();
  final RecipeRepository _repository = RecipeRepository();
  
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  
  bool _isLoading = false;
  bool _isSaving = false;
  
  String? _selectedMealType;
  String? _selectedIngredientId;
  
  File? _selectedImage;
  List<String> _mealTypes = [];
  List<IngredientModel> _ingredients = [];
  RecipeEditModel? _recipeForEdit;
  
  @override
  void initState() {
    super.initState();
    _loadInitialData();
  }
  
  Future<void> _loadInitialData() async {
    setState(() {
      _isLoading = true;
    });
    
    try {
      // First fetch recipes to get meal types and ingredients
      final recipesResponse = await _repository.fetchRecipes();
      
      if (recipesResponse.success && recipesResponse.data != null) {
        setState(() {
          _mealTypes = recipesResponse.data!.uniqueMealTypes;
          _ingredients = recipesResponse.data!.ingredients;
        });
        
        // If editing, fetch the recipe details
        if (widget.recipeId != null) {
          final editResponse = await _repository.getRecipeForEdit(widget.recipeId!);
          
          if (editResponse.success && editResponse.data != null) {
            final recipeData = editResponse.data!.recipe;
            setState(() {
              _recipeForEdit = recipeData;
              _nameController.text = recipeData.itemName;
              _selectedMealType = recipeData.type;
              
              // HTML decode the recipe text
              String description = recipeData.recipe;
              if (description.contains('&lt;p&gt;')) {
                try {
                  description = html_parser.parse(description).body?.text ?? description;
                } catch (e) {
                  // If parsing fails, keep the original description
                  print("HTML parsing error: $e");
                }
              }
              _descriptionController.text = description;
              
              // Set ingredient ID if available
              // This needs to be implemented if the API returns the ingredient
            });
          } else {
            UIHelpers.showToast(
              context,
              message: editResponse.message,
              backgroundColor: AppColors.errorColor,
            );
          }
        }
      } else {
        UIHelpers.showToast(
          context,
          message: recipesResponse.message,
          backgroundColor: AppColors.errorColor,
        );
      }
    } catch (e) {
      print("Error loading initial data: $e");
      UIHelpers.showToast(
        context,
        message: 'Failed to load data: ${e.toString()}',
        backgroundColor: AppColors.errorColor,
      );
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }
  
  Future<void> _pickImage() async {
    try {
      final result = await FilePicker.platform.pickFiles(
        type: FileType.image,
        allowMultiple: false,
      );
      
      if (result != null && result.files.single.path != null) {
        setState(() {
          _selectedImage = File(result.files.single.path!);
        });
      }
    } catch (e) {
      print("Error picking image: $e");
      UIHelpers.showToast(
        context,
        message: 'Failed to pick image',
        backgroundColor: AppColors.errorColor,
      );
    }
  }
  
  Future<void> _saveRecipe() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }
    
    if (_selectedMealType == null) {
      UIHelpers.showToast(
        context,
        message: 'Please select a meal type',
        backgroundColor: AppColors.errorColor,
      );
      return;
    }
    
    if (_selectedIngredientId == null) {
      UIHelpers.showToast(
        context,
        message: 'Please select an ingredient',
        backgroundColor: AppColors.errorColor,
      );
      return;
    }
    
    setState(() {
      _isSaving = true;
    });
    
    try {
      final List<String>? filesPath = _selectedImage != null ? [_selectedImage!.path] : null;
      
      final ApiResponse response;
      
      if (widget.recipeId != null) {
        // Update existing recipe
        response = await _repository.updateRecipe(
          recipeId: widget.recipeId!,
          itemName: _nameController.text,
          mealType: _selectedMealType!,
          ingredient: _selectedIngredientId!,
          recipe: _descriptionController.text,
          centerId: widget.centerId,
          filesPath: filesPath,
        );
      } else {
        // Add new recipe
        response = await _repository.addRecipe(
          itemName: _nameController.text,
          mealType: _selectedMealType!,
          ingredient: _selectedIngredientId!,
          recipe: _descriptionController.text,
          centerId: widget.centerId,
          filesPath: filesPath,
        );
      }
      
      setState(() {
        _isSaving = false;
      });
      
      if (response.success) {
        UIHelpers.showToast(
          context,
          message: widget.recipeId != null ? 'Recipe updated successfully' : 'Recipe added successfully',
          backgroundColor: AppColors.successColor,
        );
        Navigator.pop(context);
      } else {
        UIHelpers.showToast(
          context,
          message: response.message,
          backgroundColor: AppColors.errorColor,
        );
      }
    } catch (e) {
      print("Error saving recipe: $e");
      setState(() {
        _isSaving = false;
      });
      UIHelpers.showToast(
        context,
        message: 'Failed to save recipe: ${e.toString()}',
        backgroundColor: AppColors.errorColor,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return CustomScaffold(
      appBar: CustomAppBar(
        title: widget.recipeId != null ? "Edit Recipe" : "Add Recipe",
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              padding: const EdgeInsets.all(16.0),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Recipe Name
                    CustomTextFormWidget(
                      controller: _nameController,
                      title: 'Recipe Name',
                      hintText: 'Enter recipe name',
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter recipe name';
                        }
                        return null;
                      },
                    ),
                    UIHelpers.verticalSpace(16),
                    
                    // Meal Type
                    Text(
                      'Meal Type',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                        color: AppColors.primaryColor,
                      ),
                    ),
                    UIHelpers.verticalSpace(8),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 12),
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.grey),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: DropdownButtonHideUnderline(
                        child: DropdownButton<String>(
                          isExpanded: true,
                          hint: const Text('Select Meal Type'),
                          value: _selectedMealType,
                          items: _mealTypes.map((type) {
                            return DropdownMenuItem(
                              value: type,
                              child: Text(_formatMealType(type)),
                            );
                          }).toList(),
                          onChanged: (value) {
                            setState(() {
                              _selectedMealType = value;
                            });
                          },
                        ),
                      ),
                    ),
                    UIHelpers.verticalSpace(16),
                    
                    // Ingredient
                    Text(
                      'Main Ingredient',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                        color: AppColors.primaryColor,
                      ),
                    ),
                    UIHelpers.verticalSpace(8),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 12),
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.grey),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: DropdownButtonHideUnderline(
                        child: DropdownButton<String>(
                          isExpanded: true,
                          hint: const Text('Select Ingredient'),
                          value: _selectedIngredientId,
                          items: _ingredients.map((ingredient) {
                            return DropdownMenuItem(
                              value: ingredient.id.toString(),
                              child: Text(ingredient.name),
                            );
                          }).toList(),
                          onChanged: (value) {
                            setState(() {
                              _selectedIngredientId = value;
                            });
                          },
                        ),
                      ),
                    ),
                    UIHelpers.verticalSpace(16),
                    
                    // Description
                    CustomTextFormWidget(
                      controller: _descriptionController,
                      title: 'Recipe Description',
                      hintText: 'Enter recipe description',
                      maxLines: 5,
                      minLines: 5,
                    ),
                    UIHelpers.verticalSpace(16),
                    
                    // Image Upload
                    Text(
                      'Recipe Image',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                        color: AppColors.primaryColor,
                      ),
                    ),
                    UIHelpers.verticalSpace(8),
                    InkWell(
                      onTap: _pickImage,
                      child: Container(
                        height: 150,
                        width: double.infinity,
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.grey),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: _selectedImage != null
                            ? ClipRRect(
                                borderRadius: BorderRadius.circular(8),
                                child: Image.file(
                                  _selectedImage!,
                                  fit: BoxFit.cover,
                                ),
                              )
                            : _recipeForEdit != null
                                ? Center(
                                    child: Text(
                                      'Tap to change image',
                                      style: TextStyle(
                                        color: AppColors.primaryColor,
                                      ),
                                    ),
                                  )
                                : const Center(
                                    child: Icon(
                                      Icons.add_photo_alternate_outlined,
                                      size: 40,
                                      color: Colors.grey,
                                    ),
                                  ),
                      ),
                    ),
                    UIHelpers.verticalSpace(24),
                    
                    // Save Button
                    Align(
                      alignment: Alignment.centerRight,
                      child: CustomButton(text: widget.recipeId != null ? 'Update Recipe' : 'Add Recipe',
                        isLoading: _isSaving,
                        ontap: (){
                          _saveRecipe();
                        },
                        // width: double.infinity,
                        ),
                    ),
                    // CustomButton(

                    //   text: 'save',
                    //   // text: widget.recipeId != null ? 'Update Recipe' : 'Add Recipe',
                    //   isLoading: _isSaving,
                    //       ontap: _saveRecipe,
                    //       width: double.infinity,
                    // ),
                  ],
                ),
              ),
            ),
    );
  }
  
  String _formatMealType(String type) {
    return type.replaceAll('_', ' ').toLowerCase().split(' ').map((word) => 
      word.isNotEmpty ? '${word[0].toUpperCase()}${word.substring(1)}' : '').join(' ');
  }
}
