import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mydiaree/core/config/app_colors.dart';
import 'package:mydiaree/core/utils/ui_helper.dart';
import 'package:mydiaree/core/widgets/custom_app_bar.dart';
import 'package:mydiaree/core/widgets/custom_buton.dart';
import 'package:mydiaree/core/widgets/custom_scaffold.dart';
import 'package:mydiaree/features/healthy_menu/ingredients/presentation/bloc/ingredient_bloc.dart';
import 'package:mydiaree/features/healthy_menu/ingredients/presentation/bloc/ingredient_event.dart';
import 'package:mydiaree/features/healthy_menu/ingredients/presentation/bloc/ingredient_state.dart';
import 'package:mydiaree/features/healthy_menu/ingredients/presentation/pages/add_ingredient_screen.dart';
import 'package:mydiaree/features/healthy_menu/reciepe/data/model/reciepe_model.dart';

class IngredientListScreen extends StatelessWidget {
  const IngredientListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    context.read<IngredientBloc>().add(FetchIngredientsEvent());
    return BlocProvider(
      create: (context) => IngredientBloc()..add(FetchIngredientsEvent()),
      child: CustomScaffold(
        appBar: const CustomAppBar(
          title: 'Ingredients',
        ),
        body: BlocBuilder<IngredientBloc, IngredientState>(
          builder: (context, state) {
            if (state is IngredientLoading) {
              return const Center(child: CircularProgressIndicator());
            } else if (state is IngredientLoaded) {
              return ListView.builder(
                padding: const EdgeInsets.all(16.0),
                itemCount: state.ingredients.length + 1, // +1 for header
                itemBuilder: (context, index) {
                  if (index == 0) {
                    return _buildTableHeader(context);
                  }
                  final ingredient = state.ingredients[index - 1];
                  return _buildIngredientRow(context, ingredient, index - 1);
                },
              );
            } else if (state is IngredientError) {
              return Center(child: Text(state.message));
            }
            return const Center(child: Text('No ingredients found'));
          },
        ),
      ),
    );
  }

  Widget _buildTableHeader(BuildContext context) {
    return Column(
      children: [
        SizedBox(height: 10,),
        Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Padding(
              padding: const EdgeInsets.only(right: 16.0),
              child: CustomButton(
                text: 'Add Ingredient',
                height: 36,
                width: 120,
                borderRadius: 8,
                textAppTextStyles: Theme.of(context).textTheme.labelMedium,
                ontap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => BlocProvider(
                        create: (context) => IngredientBloc(),
                        child: const AddIngredientScreen(),
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
        SizedBox(height: 10,),
        Container(
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
        ),
      ],
    );
  }

  Widget _buildIngredientRow(
      BuildContext context, IngredientModel ingredient, int index) {
    final colors = [
      Colors.cyan[100]!,
      Colors.purple[100]!,
      Colors.blue[100]!,
      Colors.brown[100]!,
      Colors.pink[100]!,
    ];
    final rowColor = colors[index % colors.length];

    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      margin: const EdgeInsets.symmetric(vertical: 4),
      child: Container(
        color: rowColor,
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
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => BlocProvider(
                            create: (context) => IngredientBloc(),
                            child: AddIngredientScreen(ingredient: ingredient),
                          ),
                        ),
                      );
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
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12)),
                          title: const Text('Confirm Delete'),
                          content: Text(
                              'Delete this ingredient: ${ingredient.name}?'),
                          actions: [
                            TextButton(
                              onPressed: () => Navigator.pop(context),
                              child: const Text('Cancel'),
                            ),
                            TextButton(
                              onPressed: () {
                                context
                                    .read<IngredientBloc>()
                                    .add(DeleteIngredientEvent(ingredient.id));
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
            ),
          ],
        ),
      ),
    );
  }
}

// Placeholder for CustomActionButton (same as recipe module)
class CustomActionButton extends StatefulWidget {
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
  _CustomActionButtonState createState() => _CustomActionButtonState();
}

class _CustomActionButtonState extends State<CustomActionButton> {
  double _scale = 1.0;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: (_) => setState(() => _scale = 0.95),
      onTapUp: (_) => setState(() => _scale = 1.0),
      onTapCancel: () => setState(() => _scale = 1.0),
      onTap: widget.onPressed,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 100),
        transform: Matrix4.identity()..scale(_scale),
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: widget.color.withOpacity(0.1),
        ),
        child: Icon(
          widget.icon,
          color: widget.color,
          size: 24,
        ),
      ),
    );
  }
}
