import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mydiaree/core/config/app_colors.dart';
import 'package:mydiaree/core/utils/ui_helper.dart';
import 'package:mydiaree/core/widgets/custom_action_button.dart';
import 'package:mydiaree/core/widgets/custom_app_bar.dart';
import 'package:mydiaree/core/widgets/custom_background_widget.dart';
import 'package:mydiaree/core/widgets/custom_buton.dart';
import 'package:mydiaree/core/widgets/custom_scaffold.dart';
import 'package:mydiaree/core/widgets/dropdowns/center_dropdown.dart';
import 'package:mydiaree/features/healthy_menu/reciepe/data/model/reciepe_model.dart';
import 'package:mydiaree/features/healthy_menu/reciepe/presentation/bloc/add_edit/add_reciepe_bloc.dart';
import 'package:mydiaree/features/healthy_menu/reciepe/presentation/bloc/list/reciepe_bloc.dart';
import 'package:mydiaree/features/healthy_menu/reciepe/presentation/bloc/list/reciepe_event.dart';
import 'package:mydiaree/features/healthy_menu/reciepe/presentation/bloc/list/reciepe_state.dart';
import 'package:mydiaree/features/healthy_menu/reciepe/presentation/pages/add_reciepe_screen.dart';
import 'package:mydiaree/main.dart';

class RecipeScreen extends StatefulWidget {
  const RecipeScreen({super.key});

  @override
  _RecipeScreenState createState() => _RecipeScreenState();
}

class _RecipeScreenState extends State<RecipeScreen> {
  @override
  void initState() {
    super.initState();
    context
        .read<RecipeBloc>()
        .add(FetchRecipesEvent(1)); // Default to Melbourne Center
  }

  String? selectedCenterId;
  @override
  Widget build(BuildContext context) {
    return CustomScaffold(
      appBar: const CustomAppBar(
        title: 'Recipe',
      ),
      body: Column(
        children: [
          UIHelpers.verticalSpace(20),
          StatefulBuilder(builder: (context, setState) {
            return CenterDropdown(
              selectedCenterId: selectedCenterId,
              onChanged: (value) {
                setState(
                  () {
                    selectedCenterId = value.id;
                  },
                );
              },
            );
          }),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 10),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                const SizedBox(width: 16),
                CustomButton(
                  text: 'Add Recipes',
                  height: 36,
                  width: 120,
                  borderRadius: 8,
                  textAppTextStyles: Theme.of(context).textTheme.labelMedium,
                  ontap: () {
                    Navigator.push(context,
                        MaterialPageRoute(builder: (context) {
                      return const AddRecipeScreen();
                    }));
                  },
                ),
              ],
            ),
          ),
          const Divider(),
          // Recipe Sections
          Expanded(
            child: BlocBuilder<RecipeBloc, RecipeState>(
              builder: (context, state) {
                if (state is RecipeLoading) {
                  return const Center(child: CircularProgressIndicator());
                } else if (state is RecipeRecipesLoaded) {
                  final recipes = state.recipes;
                  final mealTypes = recipes.map((r) => r.type).toSet().toList();
                  return SingleChildScrollView(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: mealTypes.map((mealType) {
                        final mealRecipes =
                            recipes.where((r) => r.type == mealType).toList();
                        return Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              StringExtension(mealType
                                      .replaceAll('_', ' ')
                                      .toLowerCase())
                                  .capitalize(),
                              style: Theme.of(context)
                                  .textTheme
                                  .bodyLarge
                                  ?.copyWith(
                                      decoration: TextDecoration.underline,
                                      fontSize: 17),
                            ),
                            UIHelpers.verticalSpace(8),
                            GridView.builder(
                              shrinkWrap: true,
                              physics: const NeverScrollableScrollPhysics(),
                              gridDelegate:
                                  const SliverGridDelegateWithFixedCrossAxisCount(
                                crossAxisCount: 2,
                                crossAxisSpacing: 16,
                                mainAxisSpacing: 16,
                                childAspectRatio: 0.7,
                              ),
                              itemCount: mealRecipes.length,
                              itemBuilder: (context, index) {
                                final recipe = mealRecipes[index];
                                return _buildRecipeCard(context, recipe);
                              },
                            ),
                            const Divider(),
                          ],
                        );
                      }).toList(),
                    ),
                  );
                } else if (state is RecipeError) {
                  return Center(child: Text('Error: ${state.message}'));
                }
                return const Center(child: Text('No recipes available'));
              },
            ),
          ),
        ],
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
                Text(
                  recipe.itemName,
                  style: Theme.of(context)
                      .textTheme
                      .bodyMedium
                      ?.copyWith(fontSize: 15),
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
                    recipe.imageUrl,
                    fit: BoxFit.contain,
                    errorBuilder: (context, error, stackTrace) =>
                        const Icon(Icons.error),
                  ),
                ),
              );
            },
            child: Image.network(
              recipe.imageUrl.isNotEmpty
                  ? recipe.imageUrl
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
              child: SizedBox(
            height: 10,
          )),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  recipe.creator,
                  style: const TextStyle(fontSize: 12, color: Colors.grey),
                ),
              ],
            ),
          ),
          const SizedBox(
            height: 1,
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Padding(
                  padding: const  EdgeInsets.only(bottom: 5),
                  child: SizedBox(
                    width: screenWidth * .20,
                    child: AutoSizeText(
                      recipe.createdAt,
                      style: const TextStyle(fontSize: 12, color: Colors.grey),
                    ),
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    CustomActionButton(
                      padding: EdgeInsets.all(4),
                      iconSize: 15,
                      icon: Icons.edit_rounded,
                      color: AppColors.primaryColor,
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => BlocProvider(
                              create: (context) => AddRecipeBloc(),
                              child: AddRecipeScreen(recipe: recipe),
                            ),
                          ),
                        );
                        print('Edit recipe: ${recipe.id}');
                      },
                    ),
                     const SizedBox(width: 8),
                CustomActionButton(
                  padding: EdgeInsets.all(4),
                  iconSize: 15,
                  icon: Icons.delete,
                  color: AppColors.errorColor,
                  onPressed: () {
                    showDialog(
                      context: context,
                      builder: (context) => AlertDialog(
                        title: const Text('Confirm Delete'),
                        content:
                            Text('Delete this recipe: ${recipe.itemName}?'),
                        actions: [
                          TextButton(
                            onPressed: () => Navigator.pop(context),
                            child: const Text('Cancel'),
                          ),
                          TextButton(
                            onPressed: () {
                              context
                                  .read<RecipeBloc>()
                                  .add(DeleteRecipeEvent(recipe.id));
                              Navigator.pop(context);
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
}
