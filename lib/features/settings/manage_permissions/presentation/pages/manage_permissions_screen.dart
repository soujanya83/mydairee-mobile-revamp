import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mydiaree/core/config/app_colors.dart';
import 'package:mydiaree/core/cubit/global_data_cubit.dart';
import 'package:mydiaree/core/utils/ui_helper.dart';
import 'package:mydiaree/core/widgets/custom_app_bar.dart';
import 'package:mydiaree/core/widgets/custom_buton.dart';
import 'package:mydiaree/core/widgets/custom_scaffold.dart';
import 'package:mydiaree/features/settings/manage_permissions/data/model/permission_model.dart';
import 'package:mydiaree/features/settings/manage_permissions/presentation/bloc/list/manage_permission_bloc.dart';
import 'package:mydiaree/features/settings/manage_permissions/presentation/bloc/list/manage_permission_events.dart';
import 'package:mydiaree/features/settings/manage_permissions/presentation/bloc/list/manage_permission_state.dart';
import 'package:mydiaree/features/settings/manage_permissions/presentation/pages/assigned_user_list_screen.dart';

class ManagePermissionsScreen extends StatefulWidget {
  const ManagePermissionsScreen({super.key});

  @override
  State<ManagePermissionsScreen> createState() =>
      _ManagePermissionsScreenState();
}

class _ManagePermissionsScreenState extends State<ManagePermissionsScreen> {
  final _formKey = GlobalKey<FormState>();
  String? _selectedUserId;
  final Map<String, bool> _permissions = {};
  bool _selectAll = false;
  List<PermissionModel> _permissionList = [];

  @override
  void initState() {
    super.initState();
    // Load educators and permissions
    context.read<GlobalDataCubit>().loadEducators();
    context.read<PermissionBloc>().add(FetchPermissionsEvent());
  }

  void _toggleAllPermissions(bool? value) {
    setState(() {
      _selectAll = value ?? false;
      for (var perm in _permissionList) {
        _permissions[perm.key ?? ''] = _selectAll;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return CustomScaffold(
      appBar: const CustomAppBar(title: 'Manage Permissions'),
      body: BlocListener<PermissionBloc, PermissionState>(
        listener: (context, state) {
          if (state is PermissionSuccess) {
            UIHelpers.showToast(
              context,
              message: state.message,
              backgroundColor: AppColors.successColor,
            );
          } else if (state is PermissionFailure) {
            UIHelpers.showToast(
              context,
              message: state.message,
              backgroundColor: AppColors.errorColor,
            );
          }
        },
        child: BlocBuilder<PermissionBloc, PermissionState>(
          builder: (context, state) {
            if (state is PermissionLoading) {
              return const Center(child: CircularProgressIndicator());
            } else if (state is PermissionLoaded) {
              _permissionList = state.permissions;
              // Initialize permissions map if not already done
              if (_permissions.isEmpty) {
                for (var perm in _permissionList) {
                  _permissions[perm.key ?? ''] = false;
                }
              }
            } else if (state is PermissionFailure) {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(state.message),
                    const SizedBox(height: 16),
                    CustomButton(
                      text: 'Retry',
                      height: 45,
                      width: 100,
                      ontap: () => context
                          .read<PermissionBloc>()
                          .add(FetchPermissionsEvent()),
                    ),
                  ],
                ),
              );
            }

            return SingleChildScrollView(
              padding: const EdgeInsets.all(20),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Assign Permissions',
                          style: Theme.of(context).textTheme.titleMedium,
                        ),
                        CustomButton(
                          borderRadius: 10,
                          text: 'Assigned',
                          textAppTextStyles:
                              Theme.of(context).textTheme.labelMedium,
                          height: 37,
                          width: 90,
                          isLoading: state is PermissionLoading,
                          ontap: () {
                            Navigator.push(context, MaterialPageRoute(builder: (context){
                              return AssignedUserListScreen();
                            }));
                          },
                        )
                      ],
                    ),
                    const SizedBox(height: 16),
                    BlocBuilder<GlobalDataCubit, GlobalDataState>(
                      builder: (context, globalState) {
                        final users =
                            globalState.educatorsData?.educators ?? [];
                        return DropdownButtonFormField<String>(
                          decoration: const InputDecoration(
                            labelText: 'Select User',
                            border: OutlineInputBorder(
                              borderSide:
                                  BorderSide(color: AppColors.primaryColor),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderSide:
                                  BorderSide(color: AppColors.primaryColor),
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderSide:
                                  BorderSide(color: AppColors.primaryColor),
                            ),
                            disabledBorder: OutlineInputBorder(
                              borderSide:
                                  BorderSide(color: AppColors.primaryColor),
                            ),
                          ),
                          value: _selectedUserId,
                          items: users
                              .map((user) => DropdownMenuItem(
                                    value: user.id,
                                    child: Text(user.name),
                                  ))
                              .toList(),
                          onChanged: (value) {
                            setState(() {
                              _selectedUserId = value;
                            });
                          },
                          validator: (value) =>
                              value == null ? 'Please select a user' : null,
                        );
                      },
                    ),
                    const SizedBox(height: 16),
                    Align(
                      alignment: Alignment.topRight,
                      child: BlocBuilder<PermissionBloc, PermissionState>(
                        builder: (context, state) {
                          return CustomButton(
                            borderRadius: 10,
                            text: 'Assign',
                            textAppTextStyles:
                                Theme.of(context).textTheme.labelMedium,
                            height: 37,
                            width: 90,
                            isLoading: state is PermissionLoading,
                            ontap: () {
                              if (_formKey.currentState?.validate() ?? false) {
                                context.read<PermissionBloc>().add(
                                      AssignPermissionsEvent(
                                        userId: _selectedUserId!,
                                        permissions: _permissions,
                                      ),
                                    );
                              } else {
                                UIHelpers.showToast(
                                  context,
                                  message: 'Please select a user',
                                  backgroundColor: AppColors.errorColor,
                                );
                              }
                            },
                          );
                        },
                      ),
                    ),
                    UIHelpers.verticalSpace(5),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
                      ],
                    ),
                    const SizedBox(height: 16),
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
                      itemCount: _permissionList.length,
                      itemBuilder: (context, index) {
                        final perm = _permissionList[index];
                        return Row(
                          children: [
                            Checkbox(
                              value: _permissions[perm.key] ?? false,
                              onChanged: (value) {
                                setState(() {
                                  _permissions[perm.key ?? ''] = value ?? false;
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
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
