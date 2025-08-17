import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mydiaree/core/config/app_colors.dart';
import 'package:mydiaree/core/utils/ui_helper.dart';
import 'package:mydiaree/core/widgets/custom_action_button.dart';
import 'package:mydiaree/core/widgets/custom_app_bar.dart';
import 'package:mydiaree/core/widgets/custom_background_widget.dart';
import 'package:mydiaree/core/widgets/custom_scaffold.dart';
import 'package:mydiaree/core/widgets/dropdowns/center_dropdown.dart';
import 'package:mydiaree/features/settings/staff_setting/presentation/bloc/list/staff_setting_bloc.dart';
import 'package:mydiaree/features/settings/staff_setting/presentation/bloc/list/staff_setting_event.dart';
import 'package:mydiaree/features/settings/super_admin_settings/data/model/super_admin_model.dart';
import 'package:mydiaree/features/settings/super_admin_settings/data/repositories/settings_repository.dart';
import 'package:mydiaree/features/settings/super_admin_settings/presentation/bloc/list/super_admin_setting_bloc.dart';
import 'package:mydiaree/features/settings/super_admin_settings/presentation/bloc/list/super_admin_setting_event.dart';
import 'package:mydiaree/features/settings/super_admin_settings/presentation/bloc/list/super_admin_setting_state.dart';
import 'package:mydiaree/features/settings/super_admin_settings/presentation/pages/add_super_admin_screen.dart';
import 'dart:async';

class SuperAdminSettingsScreen extends StatefulWidget {
  const SuperAdminSettingsScreen({super.key});

  @override
  State<SuperAdminSettingsScreen> createState() =>
      _SuperAdminSettingsScreenState();
}

class _SuperAdminSettingsScreenState extends State<SuperAdminSettingsScreen> {
  String? _selectedCenter = 'Melbourne Center';
  bool _isDeleting = false;
  final SuperAdminRepository _repository = SuperAdminRepository();

  @override
  void initState() {
    super.initState();
    context.read<SuperAdminSettingsBloc>().add(FetchSuperAdminsEvent());
  }

  void _navigateToAddSuperAdminScreen() async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const AddSuperAdminScreen(isEdit: false),
      ),
    );
    if (result == true) {
      context.read<SuperAdminSettingsBloc>().add(FetchSuperAdminsEvent());
    }
  }

  void _navigateToEditSuperAdminScreen(SuperAdminModel superAdmin) async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => AddSuperAdminScreen(
          isEdit: true,
          superAdmin: superAdmin,
        ),
      ),
    );
    if (result == true) {
      context.read<SuperAdminSettingsBloc>().add(FetchSuperAdminsEvent());
    }
  }

  void _showDeleteConfirmationDialog(int superAdminId) {
    showDialog(
      context: context,
      barrierDismissible: !_isDeleting,
      builder: (context) => StatefulBuilder(
        builder: (context, setStateDialog) {
          return Stack(
            children: [
              AlertDialog(
                title: const Text('Are you sure?'),
                content: const Text('You will not be able to recover this Superadmin!'),
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
                            await _deleteSuperAdmin(superAdminId);
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

  Future<void> _deleteSuperAdmin(int superAdminId) async {
    setState(() => _isDeleting = true);
    bool success = false;
    try {
      success = await _repository.deleteSuperAdmin(superAdminId);
    } catch (e) {
      UIHelpers.showToast(context, message: 'Delete failed: $e', backgroundColor: AppColors.errorColor);
    }
    setState(() => _isDeleting = false);
    if (success) {
      UIHelpers.showToast(context, message: 'Superadmin deleted successfully!', backgroundColor: AppColors.successColor);
      context.read<SuperAdminSettingsBloc>().add(FetchSuperAdminsEvent());
    } else {
      UIHelpers.showToast(context, message: 'Failed to delete superadmin', backgroundColor: AppColors.errorColor);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        CustomScaffold(
          appBar: const CustomAppBar(title: 'Super-Admin Settings'),
          body: Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(20),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Super-Admin Settings',
                      style: Theme.of(context).textTheme.headlineSmall,
                    ),
                    UIHelpers.addButton(
                      ontap: _navigateToAddSuperAdminScreen,
                      context: context,
                    ),
                  ],
                ),
              ),
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
                            StatefulBuilder(builder: (context, setState) {
                              return CenterDropdown(
                                selectedCenterId: _selectedCenter,
                                onChanged: (value) {
                                  // context
                                  //     .read<StaffSettingsBloc>()
                                  //     .add(FetchStaffEvent());
                                  setState(() {
                                    _selectedCenter = value.id;
                                  });
                                },
                              );
                            }),
                            const SizedBox(height: 20),
                            BlocConsumer<SuperAdminSettingsBloc,
                                SuperAdminSettingsState>(
                              listener: (context, state) {
                                if (state is SuperAdminSettingsSuccess) {
                                  UIHelpers.showToast(
                                    context,
                                    message: state.message,
                                    backgroundColor: AppColors.successColor,
                                  );
                                } else if (state is SuperAdminSettingsFailure) {
                                  UIHelpers.showToast(
                                    context,
                                    message: state.message,
                                    backgroundColor: AppColors.errorColor,
                                  );
                                }
                              },
                              builder: (context, state) {
                                if (state is SuperAdminSettingsLoading) {
                                  return const Center(
                                      child: CircularProgressIndicator());
                                }
                                if (state is SuperAdminSettingsLoaded) {
                                  final superAdmins = state.superAdmins;
                                  return ListView.builder(
                                    shrinkWrap: true,
                                    physics: const NeverScrollableScrollPhysics(),
                                    itemCount: superAdmins.length,
                                    itemBuilder: (context, index) {
                                      final superAdmin = superAdmins[index];
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
                                                        fontWeight:
                                                            FontWeight.bold,
                                                      ),
                                                ),
                                                const SizedBox(height: 8),
                                                Row(
                                                  children: [
                                                    CircleAvatar(
                                                      radius: 20,
                                                      backgroundImage:
                                                          NetworkImage(
                                                        superAdmin.imageUrl.startsWith('http')
                                                          ? superAdmin.imageUrl
                                                          : 'https://mydiaree.com.au/${superAdmin.imageUrl}',
                                                      ),
                                                      onBackgroundImageError: (_,
                                                              __) =>
                                                          const Icon(Icons.person),
                                                    ),
                                                    const SizedBox(width: 8),
                                                    Text(
                                                      'Name: ${superAdmin.name}',
                                                      style: Theme.of(context)
                                                          .textTheme
                                                          .bodyMedium,
                                                    ),
                                                  ],
                                                ),
                                                const SizedBox(height: 4),
                                                Text(
                                                  'Email: ${superAdmin.email}',
                                                  style: Theme.of(context)
                                                      .textTheme
                                                      .bodyMedium,
                                                ),
                                                const SizedBox(height: 4),
                                                Text(
                                                  'Contact No.: ${superAdmin.contactNo.isNotEmpty ? superAdmin.contactNo : 'N/A'}',
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
                                                      color:
                                                          AppColors.primaryColor,
                                                      onPressed: () =>
                                                          _navigateToEditSuperAdminScreen(
                                                              superAdmin),
                                                    ),
                                                    const SizedBox(width: 8),
                                                    CustomActionButton(
                                                      icon: Icons.delete,
                                                      color: AppColors.errorColor,
                                                      onPressed: () =>
                                                          _showDeleteConfirmationDialog(
                                                              superAdmin.id),
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
                                    child: Text('No superadmins available'));
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
