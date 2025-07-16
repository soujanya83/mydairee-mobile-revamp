import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mydiaree/core/config/app_colors.dart';
import 'package:mydiaree/core/utils/ui_helper.dart';
import 'package:mydiaree/core/widgets/custom_buton.dart';
import 'package:mydiaree/features/settings/manage_permissions/data/model/user_model.dart';
import 'package:mydiaree/features/settings/manage_permissions/data/model/permission_model.dart';
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
  _PermissionDialogState createState() => _PermissionDialogState();
}

class _PermissionDialogState extends State<PermissionDialog> {
  late Map<String, bool> _permissions;
  late bool _selectAll;

  @override
  void initState() {
    super.initState();
    _permissions = {};
    for (var perm in widget.allPermissions) {
      _permissions[perm.key ?? ''] = widget.user.permissions.contains(perm.key);
    }
    _selectAll = _permissions.values.every((v) => v);
  }

  void _toggleAllPermissions(bool? value) {
    setState(() {
      _selectAll = value ?? false;
      for (var perm in widget.allPermissions) {
        _permissions[perm.key ?? ''] = _selectAll;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(
        'Edit Permissions for ${widget.user.name}',
        style: Theme.of(context).textTheme.titleMedium,
      ),
      content: Container(
        width: double.maxFinite,
        child: BlocListener<AssignerPermissionUserBloc, AssignerPermissionUserState>(
          listener: (context, state) {
            if (state is AssignerPermissionUserLoaded) {
              UIHelpers.showToast(
                context,
                message: 'success',
                backgroundColor: AppColors.successColor,
              );
              Navigator.pop(context); // Close dialog on success
            } else if (state is AssignerPermissionUserError) {
              UIHelpers.showToast(
                context,
                message: state.message,
                backgroundColor: AppColors.errorColor,
              );
            }
          },
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Checkbox(
                      value: _selectAll,
                      onChanged: _toggleAllPermissions,
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
                ),
                UIHelpers.verticalSpace(5),
                GridView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
                    maxCrossAxisExtent: 250,
                    mainAxisSpacing: 10,
                    crossAxisSpacing: 10,
                    childAspectRatio: 4,
                  ),
                  itemCount: widget.allPermissions.length,
                  itemBuilder: (context, index) {
                    final perm = widget.allPermissions[index];
                    return Row(
                      children: [
                        Checkbox(
                          value: _permissions[perm.key] ?? false,
                          onChanged: (value) {
                            setState(() {
                              _permissions[perm.key ?? ''] = value ?? false;
                              _selectAll = _permissions.values.every((v) => v);
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
        CustomButton(
          text: 'Save',
          height: 37,
          width: 90,
          borderRadius: 10,
          textAppTextStyles: Theme.of(context).textTheme.labelMedium,
          ontap: () {
            final selected = _permissions.entries
                .where((entry) => entry.value)
                .map((entry) => entry.key)
                .toList();
            context.read<AssignerPermissionUserBloc>().add(
                  UpdateUserPermissions(widget.user.id, selected),
                );
          },
        ),
      ],
    );
  }
}