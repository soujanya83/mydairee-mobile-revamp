import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mydiaree/core/config/app_colors.dart';
import 'package:mydiaree/core/utils/ui_helper.dart';
import 'package:mydiaree/core/widgets/custom_background_widget.dart';
import 'package:mydiaree/core/widgets/custom_buton.dart';
import 'package:mydiaree/features/healthy_menu/menu/presentation/bloc/menu_bloc.dart';
import 'package:mydiaree/features/healthy_menu/menu/presentation/bloc/menu_event.dart';
import 'package:mydiaree/features/healthy_menu/menu/presentation/bloc/menu_state.dart';
import 'package:mydiaree/main.dart';

class IngredientModal extends StatefulWidget {
  final String day;
  final String mealType;
  final String selectedDate;
  final String centerId;

  const IngredientModal({
    required this.day,
    required this.mealType,
    required this.selectedDate,
    required this.centerId,
    super.key,
  });

  @override
  // ignore: library_private_types_in_public_api
  _IngredientModalState createState() => _IngredientModalState();
}

class _IngredientModalState extends State<IngredientModal> {
  final List<int> _selectedRecipeIds = [];

  @override
  void initState() {
    super.initState();
    context.read<MenuBloc>().add(FetchRecipesEvent(widget.mealType));
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: screenHeight * .4,
      child: Padding(
        padding: EdgeInsets.only(
            top: screenHeight * .15,
            bottom: screenHeight * .15,
            left: 20,
            right: 20),
        child: PatternBackground(
          height: 49,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                children: [
                  UIHelpers.verticalSpace(30),
                  Text('Add Items for ${widget.mealType}',
                      style: Theme.of(context)
                          .textTheme
                          .titleLarge!
                          .copyWith(fontSize: 20)),
                  UIHelpers.verticalSpace(30),
                  SizedBox(
                    width: double.maxFinite,
                    child: BlocListener<MenuBloc, MenuState>(
                      listener: (context, state) {
                        if (state is MenuSuccess) {
                          Navigator.pop(context); // Close modal on success
                        } else if (state is MenuError) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                                content: Text(state.message),
                                backgroundColor: AppColors.errorColor),
                          );
                        }
                      },
                      child: BlocBuilder<MenuBloc, MenuState>(
                        builder: (context, state) {
                          if (state is MenuLoading) {
                            return Column(
                              children: [
                                SizedBox(
                                  height: screenHeight * .2,
                                ),
                                const Center(
                                    child: CircularProgressIndicator(
                                  color: AppColors.primaryColor,
                                )),
                              ],
                            );
                          } else if (state is MenuRecipesLoaded) {
                            return SingleChildScrollView(
                              child: Column(
                                children: state.recipes.map((recipe) {
                                  return CheckboxListTile(
                                    title: Text(recipe.itemName),
                                    value:
                                        _selectedRecipeIds.contains(recipe.id),
                                    onChanged: (value) {
                                      setState(() {
                                        if (value == true) {
                                          _selectedRecipeIds.add(recipe.id);
                                        } else {
                                          _selectedRecipeIds.remove(recipe.id);
                                        }
                                      });
                                    },
                                    activeColor: AppColors.primaryColor,
                                  );
                                }).toList(),
                              ),
                            );
                          } else if (state is MenuError) {
                            return Text('Error: ${state.message}',
                                style: const TextStyle(color: Colors.red));
                          }
                          return const Text('Loading recipes...',
                              style: TextStyle(color: Colors.grey));
                        },
                      ),
                    ),
                  ),
                ],
              ),
              Padding(
                padding: const EdgeInsets.all(20.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    CustomButton(
                      text: 'Cancel',
                      height: 37,
                      width: 90,
                      borderRadius: 10,
                      textAppTextStyles:
                          Theme.of(context).textTheme.labelMedium,
                      ontap: () => Navigator.pop(context),
                    ),
                    const SizedBox(
                      width: 30,
                    ),
                    CustomButton(
                      text: 'Save',
                      height: 37,
                      width: 90,
                      borderRadius: 10,
                      textAppTextStyles:
                          Theme.of(context).textTheme.labelMedium,
                      ontap: () {
                        context.read<MenuBloc>().add(SaveMenuItemEvent(
                              centerId: widget.centerId,
                              date: widget.selectedDate,
                              day: widget.day,
                              mealType: widget.mealType,
                              recipeIds: _selectedRecipeIds,
                            ));
                      },
                    ),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
