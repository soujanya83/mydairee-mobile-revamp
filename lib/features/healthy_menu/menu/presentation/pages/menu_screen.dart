import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:mydiaree/core/config/app_colors.dart';
import 'package:mydiaree/core/config/app_urls.dart';
import 'package:mydiaree/core/utils/ui_helper.dart';
import 'package:mydiaree/core/widgets/custom_app_bar.dart';
import 'package:mydiaree/core/widgets/custom_buton.dart';
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

  String? selectedCenterId;
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
                showDialog(
                  context: context,
                  builder: (context) => IngredientModal(
                    day: day,
                    mealType: mealType,
                    selectedDate: _formatDate(_selectedDate),
                    centerId: selectedCenterId!,
                    onRecipesSaved: () {
                      _loadMenuItems();
                    },
                  ),
                );
              },
            ),
          ],
        ),
        UIHelpers.verticalSpace(8),
        items.isEmpty
            ? const Text('No items added', style: TextStyle(color: Colors.grey))
            : ListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: items.length,
                itemBuilder: (context, index) {
                  final item = items[index];
                  return Card(
                    margin: const EdgeInsets.only(bottom: 8),
                    child: ListTile(
                      contentPadding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      leading: item.mediaUrl != null && item.mediaUrl!.isNotEmpty
                          ? ClipRRect(
                              borderRadius: BorderRadius.circular(4),
                              child: Image.network(
                                '${AppUrls.baseApiUrl}/${item.mediaUrl}',
                                width: 50,
                                height: 50,
                                fit: BoxFit.cover,
                                errorBuilder: (context, error, stackTrace) {
                                  return Container(
                                    width: 50,
                                    height: 50,
                                    color: Colors.grey.shade200,
                                    child: const Icon(Icons.image_not_supported),
                                  );
                                },
                              ),
                            )
                          : Container(
                              width: 50,
                              height: 50,
                              color: Colors.grey.shade200,
                              child: const Icon(Icons.image_not_supported),
                            ),
                      title: Text(
                        item.name,
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      subtitle: const Text(
                        'Tap to view details',
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.grey,
                        ),
                      ),
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
}