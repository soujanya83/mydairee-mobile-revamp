import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mydiaree/core/config/app_colors.dart';
import 'package:mydiaree/core/utils/ui_helper.dart';
import 'package:mydiaree/core/widgets/custom_action_button.dart';
import 'package:mydiaree/core/widgets/custom_app_bar.dart';
import 'package:mydiaree/core/widgets/custom_background_widget.dart';
import 'package:mydiaree/core/widgets/custom_scaffold.dart';
import 'package:mydiaree/core/widgets/dropdowns/center_dropdown.dart';
import 'package:mydiaree/features/settings/parent_setting/data/model/parent_model.dart';
import 'package:mydiaree/features/settings/parent_setting/presentation/bloc/list/parent_setting_bloc.dart';
import 'package:mydiaree/features/settings/parent_setting/presentation/bloc/list/parent_setting_event.dart';
import 'package:mydiaree/features/settings/parent_setting/presentation/bloc/list/parent_setting_state.dart';
import 'package:mydiaree/features/settings/parent_setting/presentation/pages/add_parent_setting_screen.dart';

class ParentSettingsScreen extends StatefulWidget {
  const ParentSettingsScreen({super.key});

  @override
  State<ParentSettingsScreen> createState() => _ParentSettingsScreenState();
}

class _ParentSettingsScreenState extends State<ParentSettingsScreen> {
  String? _selectedCenter = 'Melbourne Center';
  @override
  void initState() {
    super.initState();
    context.read<ParentSettingsBloc>().add(FetchParentsEvent());
  }

  void _navigateToAddParentScreen() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const AddParentScreen(isEdit: false),
      ),
    );
  }

  void _navigateToEditParentScreen(ParentModel parent) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => AddParentScreen(
          isEdit: true,
          parent: parent,
        ),
      ),
    );
  }

  void _showDeleteConfirmationDialog(String parentId) {
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
            onPressed: () {
              context
                  .read<ParentSettingsBloc>()
                  .add(DeleteParentEvent(parentId));
              Navigator.pop(context);
            },
            child: const Text('Yes, delete it!'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return CustomScaffold(
      appBar: const CustomAppBar(title: 'Parent Settings'),
      body: Column(
        children: [
          SizedBox(
            height: 10,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              UIHelpers.addButton(
                ontap: _navigateToAddParentScreen,
                context: context,
              ),
            const  SizedBox(
                width: 10,
              ),
            ],
          ),
          const  SizedBox(
                height: 10,
              ),
          StatefulBuilder(builder: (context, setState) {
            return CenterDropdown(
              selectedCenterId: _selectedCenter,
              onChanged: (value) {
                context.read<ParentSettingsBloc>().add(FetchParentsEvent());
              },
            );
          }),
          Expanded(
            child: SingleChildScrollView(
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
                        BlocConsumer<ParentSettingsBloc, ParentSettingsState>(
                          listener: (context, state) {
                            if (state is ParentSettingsSuccess) {
                              UIHelpers.showToast(
                                context,
                                message: state.message,
                                backgroundColor: AppColors.successColor,
                              );
                            } else if (state is ParentSettingsFailure) {
                              UIHelpers.showToast(
                                context,
                                message: state.message,
                                backgroundColor: AppColors.errorColor,
                              );
                            }
                          },
                          builder: (context, state) {
                            if (state is ParentSettingsLoading) {
                              return const Center(
                                  child: CircularProgressIndicator());
                            }
                            if (state is ParentSettingsLoaded) {
                              final parentList = state.parents;
                              return ListView.builder(
                                shrinkWrap: true,
                                physics: const NeverScrollableScrollPhysics(),
                                itemCount: parentList.length,
                                itemBuilder: (context, index) {
                                  final parent = parentList[index];
                                  return Padding(
                                    padding: const EdgeInsets.symmetric(
                                        vertical: 10),
                                    child: PatternBackground(
                                      elevation: 1,
                                      child: Padding(
                                        padding: const EdgeInsets.all(16),
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              'Sr. No.: ${index + 1}',
                                              style: Theme.of(context)
                                                  .textTheme
                                                  .bodyMedium
                                                  ?.copyWith(
                                                    fontWeight: FontWeight.bold,
                                                  ),
                                            ),
                                            const SizedBox(height: 8),
                                            Row(
                                              children: [
                                                CircleAvatar(
                                                  radius: 20,
                                                  backgroundImage: NetworkImage(
                                                      parent.avatarUrl),
                                                  onBackgroundImageError: (_,
                                                          __) =>
                                                      const Icon(Icons.person),
                                                ),
                                                const SizedBox(width: 8),
                                                Text(
                                                  'Name: ${parent.name}',
                                                  style: Theme.of(context)
                                                      .textTheme
                                                      .bodyMedium,
                                                ),
                                              ],
                                            ),
                                            const SizedBox(height: 4),
                                            Text(
                                              'Email: ${parent.email}',
                                              style: Theme.of(context)
                                                  .textTheme
                                                  .bodyMedium,
                                            ),
                                            const SizedBox(height: 4),
                                            Text(
                                              'Contact No.: ${parent.contactNo.isNotEmpty ? parent.contactNo : 'N/A'}',
                                              style: Theme.of(context)
                                                  .textTheme
                                                  .bodyMedium,
                                            ),
                                            const SizedBox(height: 4),
                                            Text(
                                              'Children:',
                                              style: Theme.of(context)
                                                  .textTheme
                                                  .bodyMedium
                                                  ?.copyWith(
                                                    fontWeight: FontWeight.bold,
                                                  ),
                                            ),
                                            ...parent.children
                                                .map((child) => Padding(
                                                      padding:
                                                          const EdgeInsets.only(
                                                              left: 16),
                                                      child: Text(
                                                        '• ${child['name']} (${child['role']})',
                                                        style: Theme.of(context)
                                                            .textTheme
                                                            .bodyMedium,
                                                      ),
                                                    )),
                                            const SizedBox(height: 12),
                                            Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.end,
                                              children: [
                                                CustomActionButton(
                                                  icon: Icons.edit_rounded,
                                                  color: AppColors.primaryColor,
                                                  onPressed: () =>
                                                      _navigateToEditParentScreen(
                                                          parent),
                                                ),
                                                const SizedBox(width: 8),
                                                CustomActionButton(
                                                  icon: Icons.delete,
                                                  color: AppColors.errorColor,
                                                  onPressed: () =>
                                                      _showDeleteConfirmationDialog(
                                                          parent.id),
                                                ),
                                              ],
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  );
                                },
                              );
                            }
                            return const Center(
                                child: Text('No parents available'));
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
    );
  }
}
