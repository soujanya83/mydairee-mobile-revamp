import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mydiaree/core/config/app_colors.dart';
import 'package:mydiaree/core/utils/ui_helper.dart';
import 'package:mydiaree/core/widgets/custom_app_bar.dart';
import 'package:mydiaree/core/widgets/custom_buton.dart';
import 'package:mydiaree/core/widgets/custom_scaffold.dart';
import 'package:mydiaree/core/widgets/dropdowns/center_dropdown.dart';
import 'package:mydiaree/features/daily_journal/headchecks/presentation/widget/headchecks_custom_widgets.dart';
import 'package:mydiaree/features/daily_journal/sleepchecks/presentation/bloc/accident_list/sleepchecks_list_event.dart';
import 'package:mydiaree/features/healthy_menu/menu/data/model/menu_model.dart';
import 'package:mydiaree/features/healthy_menu/menu/presentation/bloc/menu_bloc.dart';
import 'package:mydiaree/features/healthy_menu/menu/presentation/bloc/menu_event.dart';
import 'package:mydiaree/features/healthy_menu/menu/presentation/bloc/menu_state.dart';
import 'package:mydiaree/features/healthy_menu/menu/presentation/pages/ingredient_modal.dart';

class MenuScreen extends StatefulWidget {
  const MenuScreen({super.key});

  @override
  _MenuScreenState createState() => _MenuScreenState();
}

class _MenuScreenState extends State<MenuScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  DateTime _selectedDate = DateTime(2025, 7, 21);
  final List<String> _days = [
    'Monday',
    'Tuesday',
    'Wednesday',
    'Thursday',
    'Friday'
  ];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: _days.length, vsync: this);
    context.read<MenuBloc>().add(FetchMenuItemsEvent(
          1,
          '21-07-2025',
        ));
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  String? selectedCenterId;
  @override
  Widget build(BuildContext context) {
    return CustomScaffold(
      appBar: const CustomAppBar(
        title: "Menu",
      ),
      body: Column(
        children: [
          UIHelpers.verticalSpace(20),
          // Center Dropdown and Date Picker
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
            padding: const EdgeInsets.symmetric(horizontal: 16.0,vertical: 10),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                const SizedBox(width: 16),
                StatefulBuilder(builder: (context, setState) {
                  return DatePickerButton(
                    date: _selectedDate,
                    onDateSelected: (value) {
                      setState(
                        () {
                          _selectedDate = value;
                        },
                      );
                    },
                  );
                })
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
            child: BlocBuilder<MenuBloc, MenuState>(
              builder: (context, state) {
                List<MenuItemModel> menuItems = [];
                if (state is MenuItemsLoaded) {
                  menuItems = state.menuItems;
                }
                return TabBarView(
                  controller: _tabController,
                  children: _days.map((day) {
                    return SingleChildScrollView(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        children: [
                          _buildMealSection(
                              context, day, 'Breakfast', menuItems),
                          const Divider(),
                          _buildMealSection(
                              context, day, 'Morning Tea', menuItems),
                          const Divider(),
                          _buildMealSection(context, day, 'Lunch', menuItems),
                          const Divider(),
                          _buildMealSection(
                              context, day, 'Afternoon Tea', menuItems),
                          const Divider(),
                          _buildMealSection(
                              context, day, 'Late Snacks', menuItems),
                        ],
                      ),
                    );
                  }).toList(),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMealSection(BuildContext context, String day, String mealType,
      List<MenuItemModel> menuItems) {
    final items = menuItems
        .where((item) => item.day == day && item.mealType == mealType)
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
                  decoration: TextDecoration.underline),
            ),
            CustomButton(
              text: 'Add Item',
              height: 30,
              width: 80,
              borderRadius: 8,
              textAppTextStyles: Theme.of(context).textTheme.labelSmall,
              ontap: () {
                showDialog(
                  context: context,
                  builder: (context) => IngredientModal(
                      day: day,
                      mealType: mealType,
                      selectedDate: _formatDate(_selectedDate),
                      centerId: selectedCenterId ?? ''),
                );
              },
            ),
          ],
        ),
        UIHelpers.verticalSpace(8),
        items.isEmpty
            ? const Text('No items added', style: TextStyle(color: Colors.grey))
            : Column(
                children: items.expand((item) => item.recipes).map((recipe) {
                  return Text(recipe.itemName,
                      style: const TextStyle(fontSize: 14));
                }).toList(),
              ),
      ],
    );
  }

  String _formatDate(DateTime date) {
    return '${date.day.toString().padLeft(2, '0')}-${date.month.toString().padLeft(2, '0')}-${date.year}';
  }
}
