import 'dart:io';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mydiaree/core/config/app_colors.dart';
import 'package:mydiaree/core/utils/ui_helper.dart';
import 'package:mydiaree/core/widgets/custom_app_bar.dart';
import 'package:mydiaree/core/widgets/custom_buton.dart';
import 'package:mydiaree/core/widgets/custom_dropdown.dart';
import 'package:mydiaree/core/widgets/custom_scaffold.dart';
import 'package:mydiaree/core/widgets/custom_text_field.dart';
import 'package:mydiaree/features/healthy_menu/reciepe/data/model/reciepe_model.dart';
import 'package:mydiaree/features/healthy_menu/reciepe/presentation/bloc/add_edit/add_reciepe_bloc.dart';
import 'package:mydiaree/features/healthy_menu/reciepe/presentation/bloc/add_edit/add_reciepe_event.dart';
import 'package:mydiaree/features/healthy_menu/reciepe/presentation/bloc/add_edit/add_reciepe_state.dart';
import 'package:mydiaree/features/healthy_menu/reciepe/presentation/bloc/list/reciepe_bloc.dart';
import 'package:mydiaree/features/healthy_menu/reciepe/presentation/bloc/list/reciepe_event.dart';
import 'package:mydiaree/main.dart';

class AddRecipeScreen extends StatefulWidget {
  final RecipeModel? recipe;

  const AddRecipeScreen({super.key, this.recipe});

  @override
  _AddRecipeScreenState createState() => _AddRecipeScreenState();
}

class _AddRecipeScreenState extends State<AddRecipeScreen> {
  final _formKey = GlobalKey<FormState>();
  final _itemNameController = TextEditingController();
  final _descriptionController = TextEditingController();
  String? _selectedMealType;
  IngredientModel? _selectedIngredient;
  File? _selectedImage;
  String? _mealTypeError;
  String? _ingredientError;
  final List<String> _mealTypes = [
    'BREAKFAST',
    'LUNCH',
    'SNACKS',
    'MORNING_TEA',
    'AFTERNOON_TEA',
  ];

  @override
  void initState() {
    super.initState();
    context.read<AddRecipeBloc>().add(FetchIngredientsForAddEvent());

    // Prefill fields if editing a recipe
    if (widget.recipe != null) {
      _itemNameController.text = widget.recipe!.itemName;
      _descriptionController.text = widget.recipe!.description;
      _selectedMealType = widget.recipe!.type;
      // Ingredient will be set after ingredients are loaded in BlocListener
    }
  }

  @override
  void dispose() {
    _itemNameController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  Future<void> _pickImage() async {
    final result = await FilePicker.platform.pickFiles(
      type: FileType.image,
      allowMultiple: false,
    );
    if (result != null && result.files.single.path != null) {
      final file = File(result.files.single.path!);
      final sizeInMB = file.lengthSync() / (1024 * 1024);
      if (sizeInMB <= 5) {
        setState(() {
          _selectedImage = file;
        });
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Image must be under 5MB')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return CustomScaffold(
      appBar: CustomAppBar(
        title: widget.recipe == null ? 'Add Recipe' : 'Edit Recipe',
      ),
      body: BlocListener<AddRecipeBloc, AddRecipeState>(
        listener: (context, state) {
          if (state is AddRecipeSuccess) {
            Navigator.pop(context);
            context.read<RecipeBloc>().add(FetchRecipesEvent(1)); // Refresh recipes
          } else if (state is AddRecipeError) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.message),
                backgroundColor: AppColors.errorColor,
              ),
            );
          } else if (state is AddRecipeIngredientsLoaded && widget.recipe != null) {
            // Prefill ingredient after ingredients are loaded
            if (_selectedIngredient == null) {
              final ingredient = state.ingredients.firstWhere(
                (ing) => ing.id == widget.recipe!.ingredientId,
                // orElse: () => null,
              );
              if (ingredient != null) {
                setState(() {
                  _selectedIngredient = ingredient;
                });
              }
            }
          }
        },
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Item Name
                CustomTextFormWidget(
                  controller: _itemNameController,
                  hintText: 'Item Name',
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter item name';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),
                // Meal Type
                CustomDropdown<String>(
                  height: 50,
                  value: _selectedMealType,
                  items: _mealTypes,
                  hint: 'Select Meal Type',
                  onChanged: (value) {
                    setState(() {
                      _selectedMealType = value;
                      _mealTypeError = null;
                    });
                  },
                  displayItem: (type) => type.replaceAll('_', ' ').toLowerCase().capitalize(),
                ),
                if (_mealTypeError != null)
                  Padding(
                    padding: const EdgeInsets.only(top: 8.0),
                    child: Text(
                      _mealTypeError!,
                      style: const TextStyle(color: AppColors.errorColor, fontSize: 12),
                    ),
                  ),
                const SizedBox(height: 16),
                // Ingredient
                BlocBuilder<AddRecipeBloc, AddRecipeState>(
                  builder: (context, state) {
                    List<IngredientModel> ingredients = [];
                    if (state is AddRecipeIngredientsLoaded) {
                      ingredients = state.ingredients;
                    }
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        CustomDropdown<IngredientModel>(
                          height: 50,
                          value: _selectedIngredient,
                          items: ingredients,
                          hint: 'Select Ingredient',
                          onChanged: (value) {
                            setState(() {
                              _selectedIngredient = value;
                              _ingredientError = null;
                            });
                          },
                          displayItem: (ingredient) => ingredient.name,
                        ),
                        if (_ingredientError != null)
                          Padding(
                            padding: const EdgeInsets.only(top: 8.0),
                            child: Text(
                              _ingredientError!,
                              style: const TextStyle(color: AppColors.errorColor, fontSize: 12),
                            ),
                          ),
                      ],
                    );
                  },
                ),
                const SizedBox(height: 16),
                // Description
                CustomTextFormWidget(
                  title: 'Description Recipe',
                  maxLines: 5,
                  minLines: 5,
                  controller: _descriptionController,
                  hintText: 'Enter description',
                ),
                const SizedBox(height: 16),
                // Image Upload
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          if (_selectedImage != null)
                            Stack(
                              children: [
                                ClipRRect(
                                  borderRadius: BorderRadius.circular(8),
                                  child: Container(
                                    height: 150,
                                    width: 150,
                                    decoration: BoxDecoration(
                                      border: Border.all(color: AppColors.primaryColor),
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                    child: Image.file(
                                      _selectedImage!,
                                      fit: BoxFit.cover,
                                      errorBuilder: (context, error, stackTrace) => const Icon(Icons.error),
                                    ),
                                  ),
                                ),
                                Positioned(
                                  top: 4,
                                  right: 4,
                                  child: GestureDetector(
                                    onTap: _pickImage,
                                    child: Container(
                                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                                      color: AppColors.primaryColor.withOpacity(0.7),
                                      child: const Text(
                                        'Change',
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 10,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            )
                          else if (widget.recipe != null && widget.recipe!.imageUrl.isNotEmpty)
                            Stack(
                              children: [
                                ClipRRect(
                                  borderRadius: BorderRadius.circular(8),
                                  child: Container(
                                    height: 150,
                                    width: 150,
                                    decoration: BoxDecoration(
                                      border: Border.all(color: AppColors.primaryColor),
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                    child: Image.network(
                                      widget.recipe!.imageUrl,
                                      fit: BoxFit.cover,
                                      errorBuilder: (context, error, stackTrace) => const Icon(Icons.error),
                                    ),
                                  ),
                                ),
                                Positioned(
                                  top: 4,
                                  right: 4,
                                  child: GestureDetector(
                                    onTap: _pickImage,
                                    child: Container(
                                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                                      color: AppColors.primaryColor.withOpacity(0.7),
                                      child: const Text(
                                        'Edit',
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 12,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            )
                          else
                            GestureDetector(
                              onTap: _pickImage,
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(8),
                                child: Container(
                                  height: 150,
                                  width: 150,
                                  decoration: BoxDecoration(
                                    border: Border.all(color: AppColors.primaryColor),
                                    borderRadius: BorderRadius.circular(8),
                                    color: AppColors.white,
                                  ),
                                  child: const Center(
                                    child: Text(
                                      'Upload Image',
                                      style: TextStyle(
                                        color: AppColors.primaryColor,
                                        fontSize: 14,
                                        fontWeight: FontWeight.bold,
                                      ),
                                      textAlign: TextAlign.center,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          const SizedBox(height: 4),
                          const Text(
                            '(Under 5 MB Only)',
                            style: TextStyle(fontSize: 12, color: Colors.green),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                UIHelpers.verticalSpace(40),
                CustomButton(
                  text: 'Save',
                  width: screenWidth * 0.9,
                  borderRadius: 10,
                  textAppTextStyles: Theme.of(context).textTheme.labelMedium,
                  ontap: () {
                    setState(() {
                      _mealTypeError = _selectedMealType == null ? 'Please select a meal type' : null;
                      _ingredientError = _selectedIngredient == null ? 'Please select an ingredient' : null;
                    });
                    if (_formKey.currentState!.validate() && _mealTypeError == null && _ingredientError == null) {
                      if (widget.recipe == null) {
                        context.read<AddRecipeBloc>().add(CreateRecipeEvent(
                              itemName: _itemNameController.text,
                              mealType: _selectedMealType!,
                              ingredientId: _selectedIngredient!.id,
                              description: _descriptionController.text,
                              imagePath: _selectedImage?.path ?? '',
                              creator: 'Deepti (Superadmin)', // Replace with actual user
                            ));
                      } else {
                        context.read<AddRecipeBloc>().add(EditRecipeEvent(
                              id: widget.recipe!.id,
                              itemName: _itemNameController.text,
                              mealType: _selectedMealType!,
                              ingredientId: _selectedIngredient!.id,
                              description: _descriptionController.text,
                              imagePath: _selectedImage?.path ?? widget.recipe!.imageUrl,
                              creator: 'Deepti (Superadmin)', // Replace with actual user
                            ));
                      }
                    }
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

// Extension to capitalize meal type strings
extension StringExtension on String {
  String capitalize() {
    return "${this[0].toUpperCase()}${substring(1).toLowerCase()}";
  }
}