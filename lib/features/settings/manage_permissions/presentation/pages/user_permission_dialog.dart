import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mydiaree/core/config/app_colors.dart';
import 'package:mydiaree/core/utils/ui_helper.dart';
import 'package:mydiaree/core/widgets/custom_buton.dart';
import 'package:mydiaree/features/settings/manage_permissions/data/model/user_model.dart';
import 'package:mydiaree/features/settings/manage_permissions/data/model/permission_model.dart';
import 'package:mydiaree/features/settings/manage_permissions/presentation/bloc/list/manage_permission_bloc.dart';
import 'package:mydiaree/features/settings/manage_permissions/presentation/bloc/list/manage_permission_events.dart';
import 'package:mydiaree/features/settings/manage_permissions/presentation/bloc/list/manage_permission_state.dart';
import 'package:mydiaree/features/settings/manage_permissions/presentation/bloc/users/assigned_user_bloc.dart';
import 'package:mydiaree/features/settings/manage_permissions/presentation/bloc/users/assigned_user_event.dart';
import 'package:mydiaree/features/settings/manage_permissions/presentation/bloc/users/assigned_user_state.dart';

class PermissionDialog extends StatefulWidget {
  final UserModel user;
  final List<PermissionModel> allPermissions;

  const PermissionDialog({
    required this.user,
    required this.allPermissions,
    super.key,
  });

  @override
  // ignore: library_private_types_in_public_api
  _PermissionDialogState createState() => _PermissionDialogState();
}

class _PermissionDialogState extends State<PermissionDialog> {
  late Map<String, bool> _permissions;
  late bool _selectAll;

  @override
  void initState() {
    super.initState();
    initialize();
  }

  initialize() {
    print(
        'DEBUG: Initializing PermissionDialog state for user: ${widget.user.name}');
    _permissions = {};
    print('DEBUG: Initialized empty _permissions map: $_permissions');

    // Initialize permissions map with false values from allPermissions
    print(
        'DEBUG: Processing widget.allPermissions (length: ${widget.allPermissions.length})');
    for (var perm in widget.allPermissions) {
      if (perm.key != null) {
        _permissions[perm.key!] = false;
        print('DEBUG: Added permission ${perm.key} with value false');
      } else {
        print('DEBUG: Skipped permission with null key: $perm');
      }
    }

    // Update permissions based on user's current permissions
    print(
        'DEBUG: Comparing with user permissions (length: ${widget.user.permissions.length})');
    for (var perm in widget.allPermissions) {
      if (perm.key != null) {
        final hasPermission =
            widget.user.permissions.any((p) => p.key == perm.key);
        _permissions[perm.key!] = hasPermission;
        print('DEBUG: Updated permission ${perm.key} to $hasPermission');
      } else {
        print(
            'DEBUG: Skipped permission with null key during comparison: $perm');
      }
    }

    _selectAll = _permissions.values.every((v) => v);
    print('DEBUG: Set _selectAll to $_selectAll');
    print('DEBUG: Final _permissions map: $_permissions');
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      insetPadding: const EdgeInsets.all(0),
      title: Text(
        'Edit Permissions for ${widget.user.name}',
        style: Theme.of(context).textTheme.titleMedium,
      ),
      content: SizedBox(
        width: double.maxFinite,
        child: BlocListener<PermissionBloc, PermissionState>(
          listener: (context, state) {
            if (state is PermissionSuccess) {
              UIHelpers.showToast(
                context,
                message: state.message,
                backgroundColor: AppColors.successColor,
              );
              Navigator.pop(context); // Close dialog on success
            } else if (state is PermissionFailure) {
              UIHelpers.showToast(
                context,
                message: state.message.isNotEmpty
                    ? state.message
                    : 'Failed to update permissions',
                backgroundColor: AppColors.errorColor,
              );
            }
          },
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(
                20), // Match ManagePermissionsScreen padding
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    BlocBuilder<PermissionBloc, PermissionState>(
                        builder: (context, state) {
                      return Row(
                        children: [
                          if (state is PermissionLoaded)
                            Checkbox(
                              value: _selectAll,
                              onChanged: (value) {
                                _permissions.clear();
                                for (int i = 0;
                                    i < state.permissions.length;
                                    i++) {
                                  if (value ?? false) {
                                    _permissions.addAll(
                                        {'${state.permissions[i].key}': true});
                                  } else {
                                    _permissions.addAll(
                                        {'${state.permissions[i].key}': false});
                                  }
                                }
                                setState(() {
                                  _selectAll = value ?? false;
                                });
                              },
                              activeColor: AppColors.primaryColor,
                            ),
                          const SizedBox(width: 8),
                          const Text(
                            'Select All Permissions',
                            style: TextStyle(
                              color: AppColors.successColor,
                              fontWeight: FontWeight.bold,
                              decoration: TextDecoration.underline,
                            ),
                          ),
                        ],
                      );
                    }),
                  ],
                ),
                const SizedBox(height: 16),
                BlocBuilder<PermissionBloc, PermissionState>(
                    builder: (context, state) {
                  return Column(
                    children: [
                      if (state is PermissionLoaded)
                        GridView.builder(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          gridDelegate:
                              const SliverGridDelegateWithMaxCrossAxisExtent(
                            maxCrossAxisExtent: 250,
                            mainAxisSpacing: 10,
                            crossAxisSpacing: 10,
                            childAspectRatio: 4,
                          ),
                          itemCount: state.permissions.length,
                          itemBuilder: (context, index) {
                            final perm = state.permissions[index];
                            return Row(
                              children: [
                                Checkbox(
                                  value: _permissions[perm.key] ?? false,
                                  onChanged: (value) {
                                    setState(() {
                                      _permissions[perm.key ?? ''] =
                                          value ?? false;
                                      _selectAll =
                                          _permissions.values.every((v) => v);
                                    });
                                  },
                                  activeColor: AppColors.primaryColor,
                                ),
                                Expanded(
                                  child: Text(
                                    perm.label ?? '',
                                    style: const TextStyle(fontSize: 14),
                                  ),
                                ),
                              ],
                            );
                          },
                        ),
                    ],
                  );
                }),
              ],
            ),
          ),
        ),
      ),
      actions: [
        CustomButton(
          text: 'Cancel',
          height: 37,
          width: 90,
          borderRadius: 10,
          textAppTextStyles: Theme.of(context).textTheme.labelMedium,
          ontap: () => Navigator.pop(context),
        ),
        BlocBuilder<AssignerPermissionUserBloc, AssignerPermissionUserState>(
            builder: (context, state) {
          if (state is AssignerPermissionUserAdded) {
            Navigator.pop(context);
          }
          return CustomButton(
            text: 'Save',
            height: 37,
            width: 90,
            borderRadius: 10,
            textAppTextStyles: Theme.of(context).textTheme.labelMedium,
            isLoading: state is AssignerPermissionUserLoading,
            ontap: () {
              context.read<AssignerPermissionUserBloc>().add(
                    UpdateUserPermissions(
                        widget.user.id, _permissions.keys.toList()),
               );
            },
          );
        }),
      ],
    );
  }
}
