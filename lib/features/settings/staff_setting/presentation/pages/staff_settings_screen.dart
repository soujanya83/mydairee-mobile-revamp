import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mydiaree/core/config/app_colors.dart';
import 'package:mydiaree/core/config/app_urls.dart';
import 'package:mydiaree/core/cubit/globle_repository.dart';
import 'package:mydiaree/core/utils/ui_helper.dart';
import 'package:mydiaree/core/widgets/custom_action_button.dart';
import 'package:mydiaree/core/widgets/custom_app_bar.dart';
import 'package:mydiaree/core/widgets/custom_background_widget.dart';
import 'package:mydiaree/core/widgets/custom_scaffold.dart';
import 'package:mydiaree/core/widgets/dropdowns/center_dropdown.dart';
import 'package:mydiaree/features/settings/staff_setting/data/model/staff_model.dart';
import 'package:mydiaree/features/settings/staff_setting/data/repositories/staff_settings_repository.dart';
import 'package:mydiaree/features/settings/staff_setting/presentation/bloc/list/staff_setting_bloc.dart';
import 'package:mydiaree/features/settings/staff_setting/presentation/bloc/list/staff_setting_event.dart';
import 'package:mydiaree/features/settings/staff_setting/presentation/bloc/list/staff_setting_state.dart';
import 'package:mydiaree/features/settings/staff_setting/presentation/pages/add_staff_setting_screen.dart';

// ignore: must_be_immutable
class StaffSettingsScreen extends StatefulWidget {
  StaffSettingsScreen({super.key});

  @override
  State<StaffSettingsScreen> createState() => _StaffSettingsScreenState();
}

class _StaffSettingsScreenState extends State<StaffSettingsScreen> {
  String? _selectedCenterId = '';
  bool _isDeleting = false;
  final StaffRepository _repository = StaffRepository();

  @override
  void initState() {
    super.initState();
    _selectedCenterId = globalSelectedCenterId;
    context.read<StaffSettingsBloc>().add(FetchStaffEvent(centerId: _selectedCenterId.toString()));
  }

  void _navigateToAddStaffScreen(BuildContext context) async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const AddStaffScreen(isEdit: false),
      ),
    );
    if (result == true) {
      context.read<StaffSettingsBloc>().add(FetchStaffEvent(centerId: _selectedCenterId.toString()  ));
    }
  }

  void _navigateToEditStaffScreen(BuildContext context, StaffModel staff) async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => AddStaffScreen(
          isEdit: true,
          staff: staff,
          centerId: _selectedCenterId.toString(),
        ),
      ),
    );
    if (result == true) {
      context.read<StaffSettingsBloc>().add(FetchStaffEvent(centerId: _selectedCenterId.toString()));
    }
  }

  void _showDeleteConfirmationDialog(BuildContext context, dynamic staffId) {
    showDialog(
      context: context,
      barrierDismissible: !_isDeleting,
      builder: (context) => StatefulBuilder(
        builder: (context, setStateDialog) {
          return Stack(
            children: [
              AlertDialog(
                title: const Text('Are you sure?'),
                content: const Text('You will not be able to recover this Staff!'),
                actions: [
                  TextButton(
                    onPressed: _isDeleting ? null : () => Navigator.pop(context),
                    child: const Text('Cancel'),
                  ),
                  TextButton(
                    style: TextButton.styleFrom(foregroundColor: AppColors.errorColor),
                    onPressed: _isDeleting
                        ? null
                        : () async {
                            setStateDialog(() => _isDeleting = true);
                            Navigator.of(context).pop(); // Close dialog
                            await _deleteStaff(staffId);
                          },
                    child: _isDeleting
                        ? SizedBox(
                            width: 20,
                            height: 20,
                            child: CircularProgressIndicator(strokeWidth: 2),
                          )
                        : const Text('Yes, delete it!'),
                  ),
                ],
              ),
              if (_isDeleting)
                Positioned.fill(
                  child: Container(
                    color: Colors.black.withOpacity(0.2),
                    child: const Center(child: CircularProgressIndicator()),
                  ),
                ),
            ],
          );
        },
      ),
    );
  }

  Future<void> _deleteStaff(dynamic staffId) async {
    setState(() => _isDeleting = true);
    bool success = false;
    try {
      final response = await _repository.deleteStaff(staffId.toString());
      success = response.success;
    } catch (e) {
      UIHelpers.showToast(context, message: 'Delete failed: $e', backgroundColor: AppColors.errorColor);
    }
    setState(() => _isDeleting = false);
    if (success) {
      UIHelpers.showToast(context, message: 'Staff deleted successfully!', backgroundColor: AppColors.successColor);
      context.read<StaffSettingsBloc>().add(FetchStaffEvent(centerId: _selectedCenterId.toString()));
    } else {
      UIHelpers.showToast(context, message: 'Failed to delete staff', backgroundColor: AppColors.errorColor);
    }
  }


  @override
  Widget build(BuildContext context) {
     return Stack(
      children: [
        CustomScaffold(
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
                  selectedCenterId: _selectedCenterId,
                  onChanged: (value) {
                    context.read<StaffSettingsBloc>().add(FetchStaffEvent(centerId: value.id));
                    setState(() {
                      _selectedCenterId = value.id;
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
                                                        staff.imageUrl.startsWith('http')
                                                          ? staff.imageUrl
                                                          : '${AppUrls.baseUrl}/${staff.imageUrl}',
                                                      ),
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
        ),
        if (_isDeleting)
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
