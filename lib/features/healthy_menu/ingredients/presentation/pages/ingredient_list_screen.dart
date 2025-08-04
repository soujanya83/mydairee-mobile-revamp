import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mydiaree/core/config/app_colors.dart';
import 'package:mydiaree/core/utils/ui_helper.dart';
import 'package:mydiaree/core/widgets/custom_app_bar.dart';
import 'package:mydiaree/core/widgets/custom_buton.dart';
import 'package:mydiaree/core/widgets/custom_scaffold.dart';
import 'package:mydiaree/features/healthy_menu/ingredients/data/model/ingredient_model.dart';
import 'package:mydiaree/features/healthy_menu/ingredients/data/repositories/ingredient_repository.dart';
import 'package:mydiaree/features/healthy_menu/ingredients/presentation/bloc/ingredient_bloc.dart';
import 'package:mydiaree/features/healthy_menu/ingredients/presentation/bloc/ingredient_event.dart';
import 'package:mydiaree/features/healthy_menu/ingredients/presentation/bloc/ingredient_state.dart';
import 'package:mydiaree/features/healthy_menu/ingredients/presentation/pages/add_ingredient_screen.dart';

class IngredientListScreen extends StatefulWidget {
  const IngredientListScreen({super.key});

  @override
  _IngredientListScreenState createState() => _IngredientListScreenState();
}

class _IngredientListScreenState extends State<IngredientListScreen> {
  final IngredientRepository _repository = IngredientRepository();
  late IngredientBloc _ingredientBloc;
  bool _isDeleting = false;
  
  @override
  void initState() {
    super.initState();
    _ingredientBloc = IngredientBloc();
    _loadIngredients();
  }
  
  @override
  void dispose() {
    _ingredientBloc.close();
    super.dispose();
  }
  
  void _loadIngredients() {
    _ingredientBloc.add(FetchIngredientsEvent());
  }
  
  Future<void> _deleteIngredient(int id) async {
    setState(() {
      _isDeleting = true;
    });
    
    try {
      final response = await _repository.deleteIngredient(id.toString());
      
      setState(() {
        _isDeleting = false;
      });
      
      if (response.success) {
        UIHelpers.showToast(
          context,
          message: 'Ingredient deleted successfully',
          backgroundColor: AppColors.successColor,
        );
        // Reload ingredients using bloc
        _loadIngredients();
      } else {
        UIHelpers.showToast(
          context,
          message: response.message,
          backgroundColor: AppColors.errorColor,
        );
      }
    } catch (e) {
      print("Error deleting ingredient: $e");
      setState(() {
        _isDeleting = false;
      });
      UIHelpers.showToast(
        context,
        message: 'Failed to delete ingredient: ${e.toString()}',
        backgroundColor: AppColors.errorColor,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return CustomScaffold(
      appBar: const CustomAppBar(
        title: 'Ingredients',
      ),
      body: _isDeleting
          ? const Center(child: CircularProgressIndicator())
          : BlocBuilder<IngredientBloc, IngredientState>(
              bloc: _ingredientBloc,
              builder: (context, state) {
                if (state is IngredientLoading) {
                  return const Center(child: CircularProgressIndicator());
                } else if (state is IngredientLoaded) {
                  return Column(
                    children: [
                      const SizedBox(height: 10),
                      Padding(
                        padding: const EdgeInsets.only(right: 16.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            CustomButton(
                              text: 'Add Ingredient',
                              height: 36,
                              width: 120,
                              borderRadius: 8,
                              textAppTextStyles: Theme.of(context).textTheme.labelMedium,
                              ontap: () async {
                                final result = await Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => const AddIngredientScreen(),
                                  ),
                                );
                                
                                if (result == true) {
                                  _loadIngredients();
                                }
                              },
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 10),
                      Expanded(
                        child: ListView.builder(
                          padding: const EdgeInsets.all(16.0),
                          itemCount: state.ingredients.length + 1, // +1 for header
                          itemBuilder: (context, index) {
                            if (index == 0) {
                              return _buildTableHeader(context);
                            }
                            final ingredient = state.ingredients[index - 1] as IngredientModel;
                            return _buildIngredientRow(ingredient, index - 1);
                          },
                        ),
                      ),
                    ],
                  );
                } else if (state is IngredientError) {
                  return Center(child: Text(state.message));
                }
                return const Center(child: Text('No ingredients found'));
              },
            ),
    );
  }

  Widget _buildTableHeader(BuildContext context) {
    return Container(
      color: AppColors.primaryColor.withOpacity(0.1),
      padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
      child: Row(
        children: [
          SizedBox(
            width: 50,
            child: Text(
              '#',
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
            ),
          ),
          Expanded(
            child: Text(
              'Ingredient Name',
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
            ),
          ),
          SizedBox(
            width: 120,
            child: Text(
              'Action',
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
              textAlign: TextAlign.center,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildIngredientRow(IngredientModel ingredient, int index) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      margin: const EdgeInsets.symmetric(vertical: 4),
      child: Container(
        color: _getColorForIngredient(ingredient.colorClass),
        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
        child: Row(
          children: [
            SizedBox(
              width: 50,
              child: Text(
                '${index + 1}',
                style: Theme.of(context)
                    .textTheme
                    .bodyMedium
                    ?.copyWith(fontSize: 14),
              ),
            ),
            Expanded(
              child: Text(
                ingredient.name,
                style: Theme.of(context)
                    .textTheme
                    .bodyMedium
                    ?.copyWith(fontSize: 14),
              ),
            ),
            SizedBox(
              width: 120,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CustomActionButton(
                    icon: Icons.edit_rounded,
                    color: AppColors.primaryColor,
                    onPressed: () async {
                      final result = await Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => AddIngredientScreen(
                            ingredientId: ingredient.id,
                          ),
                        ),
                      );
                      
                      if (result == true) {
                        _loadIngredients();
                      }
                    },
                  ),
                  const SizedBox(width: 8),
                  CustomActionButton(
                    icon: Icons.delete,
                    color: AppColors.errorColor,
                    onPressed: () {
                      showDialog(
                        context: context,
                        builder: (context) => AlertDialog(
                          title: const Text('Confirm Delete'),
                          content: Text('Delete this ingredient: ${ingredient.name}?'),
                          actions: [
                            TextButton(
                              onPressed: () => Navigator.pop(context),
                              child: const Text('Cancel'),
                            ),
                            TextButton(
                              onPressed: () {
                                Navigator.pop(context);
                                _deleteIngredient(ingredient.id);
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
            ),
          ],
        ),
      ),
    );
  }
  
  Color _getColorForIngredient(String colorClass) {
    switch (colorClass) {
      case 'xl-turquoise':
        return Colors.teal.shade100;
      case 'xl-parpl':
        return Colors.purple.shade100;
      case 'xl-blue':
        return Colors.blue.shade100;
      case 'xl-khaki':
        return Colors.amber.shade100;
      case 'xl-pink':
        return Colors.pink.shade100;
      default:
        return Colors.grey.shade100;
    }
  }
}

// Custom Action Button Widget
class CustomActionButton extends StatelessWidget {
  final IconData icon;
  final Color color;
  final VoidCallback onPressed;

  const CustomActionButton({
    required this.icon,
    required this.color,
    required this.onPressed,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onPressed,
      borderRadius: BorderRadius.circular(20),
      child: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: color.withOpacity(0.1),
        ),
        child: Icon(
          icon,
          color: color,
          size: 20,
        ),
      ),
    );
  }
}
