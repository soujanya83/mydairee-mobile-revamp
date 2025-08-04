import 'package:flutter/material.dart';
import 'package:mydiaree/core/config/app_colors.dart';
import 'package:mydiaree/core/utils/ui_helper.dart';
import 'package:mydiaree/core/widgets/custom_app_bar.dart';
import 'package:mydiaree/core/widgets/custom_buton.dart';
import 'package:mydiaree/core/widgets/custom_scaffold.dart';
import 'package:mydiaree/core/widgets/custom_text_field.dart'; 
import 'package:mydiaree/features/healthy_menu/ingredients/data/repositories/ingredient_repository.dart';
import 'package:mydiaree/main.dart';

class AddIngredientScreen extends StatefulWidget {
  final int? ingredientId;

  const AddIngredientScreen({super.key, this.ingredientId});

  @override
  _AddIngredientScreenState createState() => _AddIngredientScreenState();
}

class _AddIngredientScreenState extends State<AddIngredientScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final IngredientRepository _repository = IngredientRepository();
  
  bool _isLoading = false;
  bool _isSaving = false;
  
  @override
  void initState() {
    super.initState();
    if (widget.ingredientId != null) {
      _loadIngredient();
    }
  }
  
  Future<void> _loadIngredient() async {
    setState(() {
      _isLoading = true;
    });
    
    try {
      final response = await _repository.getIngredientForEdit(widget.ingredientId.toString());
      
      setState(() {
        _isLoading = false;
        if (response.success && response.data != null) {
          _nameController.text = response.data!.recipe.name;
        } else {
          UIHelpers.showToast(
            context,
            message: response.message,
            backgroundColor: AppColors.errorColor,
          );
        }
      });
    } catch (e) {
      print("Error loading ingredient: $e");
      setState(() {
        _isLoading = false;
      });
      UIHelpers.showToast(
        context,
        message: 'Failed to load ingredient: ${e.toString()}',
        backgroundColor: AppColors.errorColor,
      );
    }
  }
  
  Future<void> _saveIngredient() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }
    
    setState(() {
      _isSaving = true;
    });
    
    try {
      final response;
      
      if (widget.ingredientId != null) {
        // Update existing ingredient
        response = await _repository.updateIngredient(
          ingredientId: widget.ingredientId.toString(),
          name: _nameController.text,
        );
      } else {
        // Add new ingredient
        response = await _repository.addIngredient(
          name: _nameController.text,
        );
      }
      
      setState(() {
        _isSaving = false;
      });
      
      if (response.success) {
        UIHelpers.showToast(
          context,
          message: widget.ingredientId != null ? 'Ingredient updated successfully' : 'Ingredient added successfully',
          backgroundColor: AppColors.successColor,
        );
        Navigator.pop(context, true); // Pass true to indicate refresh needed
      } else {
        UIHelpers.showToast(
          context,
          message: response.message,
          backgroundColor: AppColors.errorColor,
        );
      }
    } catch (e) {
      print("Error saving ingredient: $e");
      setState(() {
        _isSaving = false;
      });
      UIHelpers.showToast(
        context,
        message: 'Failed to save ingredient: ${e.toString()}',
        backgroundColor: AppColors.errorColor,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return CustomScaffold(
      appBar: CustomAppBar(
        title: widget.ingredientId == null ? 'Add Ingredient' : 'Edit Ingredient',
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
                    CustomTextFormWidget(
                      controller: _nameController,
                      title: 'Ingredient Name',
                      hintText: 'Enter ingredient name',
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter ingredient name';
                        }
                        return null;
                      },
                    ),
                    UIHelpers.verticalSpace(40),
                    CustomButton(
                      text: 'Save',
                      isLoading: _isSaving,
                      width: screenWidth * 0.9,
                      borderRadius: 10,
                      textAppTextStyles: Theme.of(context).textTheme.labelMedium,
                      ontap: _saveIngredient,
                    ),
                  ],
                ),
              ),
            ),
    );
  }
}