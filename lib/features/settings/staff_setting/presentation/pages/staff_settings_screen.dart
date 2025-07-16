import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mydiaree/core/config/app_colors.dart';
import 'package:mydiaree/core/utils/ui_helper.dart';
import 'package:mydiaree/core/widgets/custom_action_button.dart';
import 'package:mydiaree/core/widgets/custom_app_bar.dart';
import 'package:mydiaree/core/widgets/custom_background_widget.dart';
import 'package:mydiaree/core/widgets/custom_scaffold.dart';
import 'package:mydiaree/core/widgets/dropdowns/center_dropdown.dart';
import 'package:mydiaree/features/settings/staff_setting/data/model/staff_model.dart';
import 'package:mydiaree/features/settings/staff_setting/presentation/bloc/list/staff_setting_bloc.dart';
import 'package:mydiaree/features/settings/staff_setting/presentation/bloc/list/staff_setting_event.dart';
import 'package:mydiaree/features/settings/staff_setting/presentation/bloc/list/staff_setting_state.dart';
import 'package:mydiaree/features/settings/staff_setting/presentation/pages/add_staff_setting_screen.dart';

// ignore: must_be_immutable
class StaffSettingsScreen extends StatelessWidget {
  StaffSettingsScreen({super.key});

  String? _selectedCenter = 'Melbourne Center';

  void _navigateToAddStaffScreen(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const AddStaffScreen(isEdit: false),
      ),
    );
  }

  void _navigateToEditStaffScreen(BuildContext context, StaffModel staff) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => AddStaffScreen(
          isEdit: true,
          staff: staff,
        ),
      ),
    );
  }

  void _showDeleteConfirmationDialog(BuildContext context, String staffId) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Are you sure?'),
        content: const Text('You will not be able to recover this Staff!'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            style: TextButton.styleFrom(foregroundColor: AppColors.errorColor),
            onPressed: () {
              context.read<StaffSettingsBloc>().add(DeleteStaffEvent(staffId));
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
    context.read<StaffSettingsBloc>().add(FetchStaffEvent());
    return CustomScaffold(
      appBar: const CustomAppBar(title: 'Staff Settings'),
      body: Column(
        children: [
          const SizedBox(
            height: 20,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              UIHelpers.addButton(
                ontap: () {
                  _navigateToAddStaffScreen(context);
                },
                context: context,
              ),
              const SizedBox(
                width: 20,
              ),
            ],
          ),
          
          const SizedBox(
            height: 20,
          ),
          StatefulBuilder(builder: (context, setState) {
            return CenterDropdown(
              selectedCenterId: _selectedCenter,
              onChanged: (value) {
                context.read<StaffSettingsBloc>().add(FetchStaffEvent());
                setState(() {
                  _selectedCenter = value.id;
                });
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
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(height: 20),
                        BlocConsumer<StaffSettingsBloc, StaffSettingsState>(
                          listener: (context, state) {
                            if (state is StaffSettingsSuccess) {
                              UIHelpers.showToast(
                                context,
                                message: state.message,
                                backgroundColor: AppColors.successColor,
                              );
                            } else if (state is StaffSettingsFailure) {
                              UIHelpers.showToast(
                                context,
                                message: state.message,
                                backgroundColor: AppColors.errorColor,
                              );
                            }
                          },
                          builder: (context, state) {
                            if (state is StaffSettingsLoading) {
                              return const Center(
                                  child: CircularProgressIndicator());
                            }
                            if (state is StaffSettingsLoaded) {
                              final staffList = state.staff;
                              return ListView.builder(
                                shrinkWrap: true,
                                physics: const NeverScrollableScrollPhysics(),
                                itemCount: staffList.length,
                                itemBuilder: (context, index) {
                                  final staff = staffList[index];
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
                                                  backgroundColor:
                                                      AppColors.grey,
                                                  radius: 20,
                                                  backgroundImage: NetworkImage(
                                                      staff.avatarUrl),
                                                  onBackgroundImageError: (_,
                                                          __) =>
                                                      const Icon(Icons.person),
                                                ),
                                                const SizedBox(width: 8),
                                                Text(
                                                  'Name: ${staff.name}',
                                                  style: Theme.of(context)
                                                      .textTheme
                                                      .bodyMedium,
                                                ),
                                              ],
                                            ),
                                            const SizedBox(height: 4),
                                            Text(
                                              'Email: ${staff.email}',
                                              style: Theme.of(context)
                                                  .textTheme
                                                  .bodyMedium,
                                            ),
                                            const SizedBox(height: 4),
                                            Text(
                                              'Contact No.: ${staff.contactNo.isNotEmpty ? staff.contactNo : 'N/A'}',
                                              style: Theme.of(context)
                                                  .textTheme
                                                  .bodyMedium,
                                            ),
                                            const SizedBox(height: 12),
                                            Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.end,
                                              children: [
                                                CustomActionButton(
                                                  icon: Icons.edit_rounded,
                                                  color: AppColors.primaryColor,
                                                  onPressed: () =>
                                                      _navigateToEditStaffScreen(
                                                          context, staff),
                                                ),
                                                const SizedBox(width: 8),
                                                CustomActionButton(
                                                  icon: Icons.delete,
                                                  color: AppColors.errorColor,
                                                  onPressed: () =>
                                                      _showDeleteConfirmationDialog(
                                                          context, staff.id),
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
                                child: Text('No staff available'));
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
