import 'package:flutter/material.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';
import 'package:mydiaree/core/config/app_colors.dart';
import 'package:mydiaree/core/widgets/custom_app_bar.dart';
import 'package:mydiaree/core/widgets/custom_dropdown.dart';
import 'package:mydiaree/core/widgets/custom_multi_selected_dialog.dart';
import 'package:mydiaree/core/widgets/custom_scaffold.dart';
import 'package:mydiaree/core/widgets/custom_text_field.dart';

class AddRoomScreen extends StatefulWidget {
  final String centerId;
  const AddRoomScreen({super.key, required this.centerId});

  @override
  State<AddRoomScreen> createState() => _AddRoomScreenState();
}

class _AddRoomScreenState extends State<AddRoomScreen> {
  final TextEditingController name = TextEditingController();
  final TextEditingController capacity = TextEditingController();
  final TextEditingController ageFrom = TextEditingController();
  final TextEditingController ageTo = TextEditingController();

  String _chosenStatus = 'Active';
  Color pickerColor = AppColors.primaryColor;
  Color currentColor = AppColors.primaryColor;

  final List<Map<String, String>> educators = [
    {'id': '1', 'name': 'John Doe'},
    {'id': '2', 'name': 'Jane Smith'},
    {'id': '3', 'name': 'Mike Johnson'},
    {'id': '1', 'name': 'John Doe'},
    {'id': '2', 'name': 'Jane Smith'},
    {'id': '3', 'name': 'Mike Johnson'},
    {'id': '1', 'name': 'John Doe'},
    {'id': '2', 'name': 'Jane Smith'},
    {'id': '3', 'name': 'Mike Johnson'},
    {'id': '1', 'name': 'John Doe'},
    {'id': '2', 'name': 'Jane Smith'},
    {'id': '3', 'name': 'Mike Johnson'},
    {'id': '1', 'name': 'John Doe'},
    {'id': '2', 'name': 'Jane Smith'},
    {'id': '3', 'name': 'Mike Johnson'},
    {'id': '1', 'name': 'John Doe'},
    {'id': '2', 'name': 'Jane Smith'},
    {'id': '3', 'name': 'Mike Johnson'},
    {'id': '1', 'name': 'John Doe'},
    {'id': '2', 'name': 'Jane Smith'},
    {'id': '3', 'name': 'Mike Johnson'},
    {'id': '1', 'name': 'John Doe'},
    {'id': '2', 'name': 'Jane Smith'},
    {'id': '3', 'name': 'Mike Johnson'},
    {'id': '1', 'name': 'John Doe'},
    {'id': '2', 'name': 'Jane Smith'},
    {'id': '3', 'name': 'Mike Johnson'},
    {'id': '1', 'name': 'John Doe'},
    {'id': '2', 'name': 'Jane Smith'},
    {'id': '3', 'name': 'Mike Johnson'},
  ];
  List<Map<String, String>> selectedEducators = [];

  final _formKey = GlobalKey<FormState>();

  void changeColor(Color color) {
    pickerColor = color;
  }

  void _showEducatorDialog() async {
    await showDialog<List<Map<String, String>>>(
      context: context,
      builder: (context) => CustomMultiSelectDialog(
        educatorIds: educators.map((e) => e['id']!).toList(),
        educatorNames: educators.map((e) => e['name']!).toList(),
        initiallySelectedIds: selectedEducators.map((e) => e['id']!).toList(),
        title: 'Select Educator',
        onItemTap: (selectedIds) {
          setState(() {
            selectedEducators =
                educators.where((e) => selectedIds.contains(e['id'])).toList();
          });
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return CustomScaffold(
      appBar: const CustomAppBar(title: "Add Room"),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Add Room',
                    style: Theme.of(context).textTheme.headlineSmall),
                const SizedBox(height: 16),
                CustomTextFormWidget(
                  controller: name,
                  hintText: 'Room Name',
                  title: 'Room Name',
                  validator: (v) =>
                      v == null || v.isEmpty ? 'Enter Room Name' : null,
                ),
                const SizedBox(height: 12),
                CustomTextFormWidget(
                  controller: capacity,
                  hintText: 'Capacity',
                  title: 'Room Capacity',
                  keyboardType: TextInputType.number,
                  validator: (v) {
                    if (v == null || v.isEmpty) return 'Enter Capacity';
                    final n = int.tryParse(v);
                    if (n == null || n <= 0) return 'Enter valid capacity';
                    return null;
                  },
                ),
                const SizedBox(height: 12),
                Row(
                  children: [
                    Expanded(
                      child: CustomTextFormWidget(
                        controller: ageFrom,
                        hintText: 'Age From',
                        title: 'Age From',
                        keyboardType: TextInputType.number,
                        validator: (v) {
                          if (v == null || v.isEmpty) return 'Enter age';
                          final n = int.tryParse(v);
                          if (n == null || n < 0) return 'Enter valid age';
                          return null;
                        },
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: CustomTextFormWidget(
                        controller: ageTo,
                        hintText: 'Age To',
                        title: 'Age To',
                        keyboardType: TextInputType.number,
                        validator: (v) {
                          if (v == null || v.isEmpty) return 'Enter age';
                          final n = int.tryParse(v);
                          final from = int.tryParse(ageFrom.text);
                          if (n == null || n < 0) return 'Enter valid age';
                          if (from != null && n < from) {
                            return 'Age To must be >= Age From';
                          }
                          return null;
                        },
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                Text('Room Status',
                    style: Theme.of(context).textTheme.bodyMedium),
                const SizedBox(height: 6),
                CustomDropdown(
                  height: 45,
                  value: _chosenStatus,
                  items: const ['Active', 'Inactive'],
                  onChanged: (val) {
                    setState(() => _chosenStatus = val!);
                  },
                ),
                const SizedBox(height: 16),
                Text('Room Color',
                    style: Theme.of(context).textTheme.bodyMedium),
                const SizedBox(height: 6),
                GestureDetector(
                  onTap: () {
                    showDialog(
                      context: context,
                      builder: (_) => AlertDialog(
                        title: const Text('Pick a color'),
                        content: SingleChildScrollView(
                          child: ColorPicker(
                            pickerColor: currentColor,
                            onColorChanged: (color) {
                              changeColor(color);
                            },
                          ),
                        ),
                        actions: [
                          TextButton(
                            onPressed: () {
                              setState(() => currentColor = pickerColor);
                              Navigator.of(context).pop();
                            },
                            child: const Text('Choose'),
                          ),
                        ],
                      ),
                    );
                  },
                  child: Container(
                    height: 45,
                    width: double.infinity,
                    decoration: BoxDecoration(
                      color: currentColor,
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(color: AppColors.grey),
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                Text('Educator', style: Theme.of(context).textTheme.bodyMedium),
                const SizedBox(height: 6),
                GestureDetector(
                  onTap: _showEducatorDialog,
                  child: Container(
                    width: 180,
                    height: 38,
                    decoration: BoxDecoration(
                      color: AppColors.primaryColor,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: const Row(
                      children: [
                        SizedBox(width: 8),
                        Icon(Icons.add_circle, color: Colors.white),
                        SizedBox(width: 8),
                        Text('Select Educator',
                            style: TextStyle(color: Colors.white)),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 10),
                if (selectedEducators.isNotEmpty)
                  Wrap(
                    spacing: 8,
                    children: selectedEducators
                        .map((edu) => Chip(
                              label: Text(edu['name']!),
                              onDeleted: () {
                                setState(() {
                                  selectedEducators
                                      .removeWhere((e) => e['id'] == edu['id']);
                                });
                              },
                            ))
                        .toList(),
                  ),
                const SizedBox(height: 30),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    OutlinedButton(
                      onPressed: () => Navigator.pop(context),
                      child: const Text('CANCEL',
                          style: TextStyle(color: Colors.black)),
                    ),
                    const SizedBox(width: 16),
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.primaryColor,
                      ),
                      onPressed: () {
                        _showEducatorDialog();
                      },
                      child: const Text('SAVE',
                          style: TextStyle(color: Colors.white)),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
