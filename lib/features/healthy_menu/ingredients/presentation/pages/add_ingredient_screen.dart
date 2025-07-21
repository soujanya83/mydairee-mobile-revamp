import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mydiaree/core/config/app_colors.dart';
import 'package:mydiaree/core/utils/ui_helper.dart';
import 'package:mydiaree/core/widgets/custom_app_bar.dart';
import 'package:mydiaree/core/widgets/custom_buton.dart';
import 'package:mydiaree/core/widgets/custom_scaffold.dart';
import 'package:mydiaree/core/widgets/custom_text_field.dart'; 
import 'package:mydiaree/features/healthy_menu/ingredients/presentation/bloc/ingredient_bloc.dart';
import 'package:mydiaree/features/healthy_menu/ingredients/presentation/bloc/ingredient_event.dart';
import 'package:mydiaree/features/healthy_menu/ingredients/presentation/bloc/ingredient_state.dart';
import 'package:mydiaree/features/healthy_menu/reciepe/data/model/reciepe_model.dart';
import 'package:mydiaree/main.dart';

class AddIngredientScreen extends StatefulWidget {
  final IngredientModel? ingredient;

  const AddIngredientScreen({super.key, this.ingredient});

  @override
  _AddIngredientScreenState createState() => _AddIngredientScreenState();
}

class _AddIngredientScreenState extends State<AddIngredientScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();

  @override
  void initState() {
    super.initState();
    if (widget.ingredient != null) {
      _nameController.text = widget.ingredient!.name;
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return CustomScaffold(
      appBar: CustomAppBar(
        title: widget.ingredient == null ? 'Add Ingredient' : 'Edit Ingredient',
      ),
      body: BlocListener<IngredientBloc, IngredientState>(
        listener: (context, state) {
          if (state is IngredientSuccess) {
            Navigator.pop(context);
            context.read<IngredientBloc>().add(FetchIngredientsEvent());
          } else if (state is IngredientError) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.message),
                backgroundColor: AppColors.errorColor,
              ),
            );
          }
        },
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CustomTextFormWidget(
                  controller: _nameController,
                  hintText: 'Ingredient Name',
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
                  width: screenWidth * 0.9,
                  borderRadius: 10,
                  textAppTextStyles: Theme.of(context).textTheme.labelMedium,
                  ontap: () {
                    if (_formKey.currentState!.validate()) {
                      if (widget.ingredient == null) {
                        context.read<IngredientBloc>().add(AddIngredientEvent(
                              name: _nameController.text,
                              creator: 'Deepti (Superadmin)',  
                            ));
                      } else {
                        context.read<IngredientBloc>().add(EditIngredientEvent(
                              id: widget.ingredient!.id,
                              name: _nameController.text,
                              creator: 'Deepti (Superadmin)', 
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