import 'package:flutter/material.dart';
import 'package:mydiaree/core/config/app_colors.dart';
import 'package:mydiaree/core/utils/ui_helper.dart';
import 'package:mydiaree/core/widgets/custom_action_button.dart';
import 'package:mydiaree/core/widgets/custom_app_bar.dart';
import 'package:mydiaree/core/widgets/custom_background_widget.dart';
import 'package:mydiaree/core/widgets/custom_scaffold.dart';
import 'package:mydiaree/core/widgets/dropdowns/center_dropdown.dart';
import 'package:mydiaree/features/settings/parent_setting/data/model/parent_model.dart';
import 'package:mydiaree/features/settings/parent_setting/data/repositories/parent_settings_repository.dart';

import 'package:mydiaree/features/settings/parent_setting/presentation/pages/add_parent_setting_screen.dart';

class ParentSettingsScreen extends StatefulWidget {
  const ParentSettingsScreen({super.key});

  @override
  State<ParentSettingsScreen> createState() => _ParentSettingsScreenState();
}

class _ParentSettingsScreenState extends State<ParentSettingsScreen> {
  String? _selectedCenter = '1';
  bool _isLoading = false;
  final ParentRepository _repository = ParentRepository();
  List<ParentModel> _parents = [];







  @override
  void initState() {
    super.initState();
    _fetchParents();
  }

  Future<void> _fetchParents() async {
    setState(() => _isLoading = true);
    try {
      final parents = await _repository.getParents(centerId: _selectedCenter ?? '1');
      setState(() {
        _parents = parents;
      });
    } catch (e) {
      UIHelpers.showToast(context, message: e.toString(), backgroundColor: AppColors.errorColor);
    }
    setState(() => _isLoading = false);
  }

  Future<void> _addOrEditParent({ParentModel? parent}) async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => AddParentScreen(
          isEdit: parent != null,
          parent: parent,
          centerId: _selectedCenter,
        ),
      ),
    );
    if (result == true) {
      await _fetchParents();
    }
  }

  void _showDeleteConfirmationDialog(int parentId) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Are you sure?'),
        content: const Text('You will not be able to recover this Parent!'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            style: TextButton.styleFrom(foregroundColor: AppColors.errorColor),
            onPressed: () async {
              Navigator.pop(context);
              _deleteParentWithOverlay(parentId);
            },
            child: const Text('Yes, delete it!'),
          ),
        ],
      ),
    );
  }

  Future<void> _deleteParentWithOverlay(int parentId) async {
    setState(() => _isLoading = true);
    final success = await _repository.deleteParent(parentId);
    setState(() => _isLoading = false);
    if (success) {
      UIHelpers.showToast(context, message: 'Parent deleted successfully!', backgroundColor: AppColors.successColor);
      await _fetchParents();
    } else {
      UIHelpers.showToast(context, message: 'Failed to delete parent', backgroundColor: AppColors.errorColor);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        AbsorbPointer(
          absorbing: _isLoading,
          child: CustomScaffold(
            appBar: const CustomAppBar(title: 'Parent Settings'),
            body: Column(
              children: [
                const SizedBox(height: 10),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    UIHelpers.addButton(
                      ontap: () => _addOrEditParent(),
                      context: context,
                    ),
                    const SizedBox(width: 10),
                  ],
                ),
                const SizedBox(height: 10),
                StatefulBuilder(builder: (context, setState) {
                  return CenterDropdown(
                    selectedCenterId: _selectedCenter,
                    onChanged: (value) async {
                      setState(() {
                        _selectedCenter = value.id;
                      });
                      await _fetchParents();
                    },
                  );
                }),
                  const SizedBox(height: 10),
                Expanded(
                  child: _isLoading
                      ? const SizedBox.shrink()
                      : SingleChildScrollView(
                          padding: const EdgeInsets.all(10),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Padding(
                                padding: const EdgeInsets.all(8),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    const SizedBox(height: 20),
                                    _parents.isEmpty
                                        ? const Center(child: Text('No parents available'))
                                        : ListView.builder(
                                            shrinkWrap: true,
                                            physics: const NeverScrollableScrollPhysics(),
                                            itemCount: _parents.length,
                                            itemBuilder: (context, index) {
                                              final parent = _parents[index];
                                              final hasImage = parent.imageUrl != null && parent.imageUrl!.isNotEmpty;
                                              return Padding(
                                                padding: const EdgeInsets.symmetric(vertical: 10),
                                                child: PatternBackground(
                                                  elevation: 1,
                                                  child: Padding(
                                                    padding: const EdgeInsets.all(16),
                                                    child: Column(
                                                      crossAxisAlignment: CrossAxisAlignment.start,
                                                      children: [
                                                        Text(
                                                          'Sr. No.: ${index + 1}',
                                                          style: Theme.of(context)
                                                              .textTheme
                                                              .bodyMedium
                                                              ?.copyWith(fontWeight: FontWeight.bold),
                                                        ),
                                                        const SizedBox(height: 8),
                                                        Row(
                                                          children: [
                                                            hasImage
                                                                ? CircleAvatar(
                                                                    radius: 20,
                                                                    backgroundImage: NetworkImage(
                                                                      parent.imageUrl!.startsWith('http')
                                                                          ? parent.imageUrl!
                                                                          : 'https://mydiaree.com.au/${parent.imageUrl}',
                                                                    ),
                                                                  )
                                                                : const CircleAvatar(
                                                                    radius: 20,
                                                                    backgroundColor: AppColors.grey,
                                                                    child: Icon(Icons.person, color: Colors.white),
                                                                  ),
                                                            const SizedBox(width: 8),
                                                            Text(
                                                              'Name: ${parent.name}',
                                                              style: Theme.of(context).textTheme.bodyMedium,
                                                            ),
                                                          ],
                                                        ),
                                                        const SizedBox(height: 4),
                                                        Text(
                                                          'Email: ${parent.email}',
                                                          style: Theme.of(context).textTheme.bodyMedium,
                                                        ),
                                                        const SizedBox(height: 4),
                                                        Text(
                                                          'Contact No.: ${parent.contactNo.isNotEmpty ? parent.contactNo : 'N/A'}',
                                                          style: Theme.of(context).textTheme.bodyMedium,
                                                        ),
                                                        const SizedBox(height: 4),
                                                        Text(
                                                          'Children:',
                                                          style: Theme.of(context)
                                                              .textTheme
                                                              .bodyMedium
                                                              ?.copyWith(fontWeight: FontWeight.bold),
                                                        ),
                                                        ...parent.children.map((child) => Padding(
                                                              padding: const EdgeInsets.only(left: 16),
                                                              child: Text(
                                                                '• ${child.name} ${child.lastname} (${child.relation})',
                                                                style: Theme.of(context).textTheme.bodyMedium,
                                                              ),
                                                            )),
                                                        const SizedBox(height: 12),
                                                        Row(
                                                          mainAxisAlignment: MainAxisAlignment.end,
                                                          children: [
                                                            CustomActionButton(
                                                              icon: Icons.edit_rounded,
                                                              color: AppColors.primaryColor,
                                                              onPressed: () => _addOrEditParent(parent: parent),
                                                            ),
                                                            const SizedBox(width: 8),
                                                            CustomActionButton(
                                                              icon: Icons.delete,
                                                              color: AppColors.errorColor,
                                                              onPressed: () => _showDeleteConfirmationDialog(parent.id),
                                                            ),
                                                          ],
                                                        ),
                                                      ],
                                                    ),
                                                  ),
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
                ),
              ],
            ),
          ),
        ),
        if (_isLoading)
          Positioned.fill(
            child: Container(
              color: Colors.black.withOpacity(0.2),
              child: const Center(child: CircularProgressIndicator()),
            ),
          ),
      ],
    );
  }
}
