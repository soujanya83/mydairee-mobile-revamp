import 'package:flutter/material.dart';
import 'package:mydiaree/core/config/app_colors.dart';
import 'package:mydiaree/core/widgets/custom_app_bar.dart';
import 'package:mydiaree/core/widgets/custom_scaffold.dart';
import 'package:mydiaree/core/widgets/custom_text_field.dart';
import 'package:mydiaree/features/settings/manage_permissions/data/model/user_model.dart';
import 'package:mydiaree/features/settings/manage_permissions/data/model/permission_model.dart';
import 'package:mydiaree/features/settings/manage_permissions/data/repositories/manage_permissions_repo.dart';
import 'package:mydiaree/core/utils/ui_helper.dart';
import 'package:mydiaree/main.dart';

import 'package:mydiaree/core/widgets/custom_buton.dart';
class AssignedUserListScreen extends StatefulWidget {
  final List<PermissionModel>? permissionList;
  const AssignedUserListScreen({super.key, this.permissionList});

  @override
  State<AssignedUserListScreen> createState() => _AssignedUserListScreenState();
}

class _AssignedUserListScreenState extends State<AssignedUserListScreen> {
  final ManagePermissionsRepository _repo = ManagePermissionsRepository();
  List<UserModel> _users = [];
  List<UserModel> _filteredUsers = [];
  bool _isLoading = true;
  String _searchText = '';
  List<PermissionModel> _permissionList = [];

  @override
  void initState() {
    super.initState();
    _fetchUsers();
    if (widget.permissionList != null) {
      _permissionList = widget.permissionList!;
    } else {
      _fetchPermissions();
    }
  }

  Future<void> _fetchPermissions() async {
    try {
      final perms = await _repo.getPermissions();
      setState(() {
        _permissionList = perms;
      });
    } catch (_) {}
  }

  Future<void> _fetchUsers() async {
    setState(() => _isLoading = true);
    try {
      final users = await _repo.getAssignedUsers();
      setState(() {
        _users = users;
        _filteredUsers = users;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
    }
  }

  void _onSearch(String value) {
    setState(() {
      _searchText = value;
      _filteredUsers = _users
          .where((u) => u.name.toLowerCase().contains(_searchText.toLowerCase()))
          .toList();
    });
  }

  void _showUserPermissionsScreen(UserModel user) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => UserPermissionScreen(
          user: user,
          permissionList: _permissionList,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return CustomScaffold(
      appBar: const CustomAppBar(title: 'Assigned Users'),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  // Search input
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SizedBox(
                        width: screenWidth * 0.9,
                        child: CustomTextFormWidget(
                          hintText: 'Search User Name...',
                          onChanged: (value){
                            _onSearch(value??'');
                          },
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  // Table header
                  Container(
                    color: AppColors.primaryColor.withOpacity(0.08),
                    padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 8),
                    child: Row(
                      children: const [
                        SizedBox(width: 40, child: Text('#', style: TextStyle(fontWeight: FontWeight.bold))),
                        Expanded(child: Text('User Name', style: TextStyle(fontWeight: FontWeight.bold))),
                        SizedBox(width: 100, child: Text('Action', style: TextStyle(fontWeight: FontWeight.bold))),
                      ],
                    ),
                  ),
                  const Divider(height: 0),
                  Expanded(
                    child: _filteredUsers.isEmpty
                        ? const Center(child: Text('No users found'))
                        : ListView.separated(
                            itemCount: _filteredUsers.length,
                            separatorBuilder: (_, __) => const Divider(height: 0),
                            itemBuilder: (context, index) {
                              final user = _filteredUsers[index];
                              return Container(
                                color: index % 2 == 0
                                    ? Colors.white
                                    : AppColors.primaryColor.withOpacity(0.03),
                                child: Row(
                                  children: [
                                    SizedBox(
                                      width: 40,
                                      child: Padding(
                                        padding: const EdgeInsets.symmetric(vertical: 16),
                                        child: Text('${index + 1}'),
                                      ),
                                    ),
                                    Expanded(
                                      child: Padding(
                                        padding: const EdgeInsets.symmetric(vertical: 16),
                                        child: Text(user.name),
                                      ),
                                    ),
                                    SizedBox(
                                      width: 100,
                                      child: Padding(
                                        padding: const EdgeInsets.symmetric(vertical: 8),
                                        child: ElevatedButton.icon(
                                          style: ElevatedButton.styleFrom(
                                            backgroundColor: AppColors.primaryColor,
                                            minimumSize: const Size(80, 36),
                                            padding: const EdgeInsets.symmetric(horizontal: 8),
                                          ),
                                          onPressed: () => _showUserPermissionsScreen(user),
                                          icon: const Icon(Icons.remove_red_eye, size: 18, color: Colors.white),
                                          label: const Text('View', style: TextStyle(color: Colors.white)),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              );
                            },
                          ),
                  ),
                ],
              ),
            ),
    );
  }
}

// Permission screen for a user (was dialog, now a full screen)
class UserPermissionScreen extends StatefulWidget {
  final UserModel user;
  final List<PermissionModel> permissionList;
  const UserPermissionScreen({
    required this.user,
    required this.permissionList,
  });

  @override
  State<UserPermissionScreen> createState() => _UserPermissionScreenState();
}

class _UserPermissionScreenState extends State<UserPermissionScreen> {
  late Map<String, bool> _permissions;
  bool _selectAll = false;
  bool _isSaving = false;
  final ManagePermissionsRepository _repo = ManagePermissionsRepository();

  @override
  void initState() {
    super.initState();
    _initPermissions();
  }

  void _initPermissions() {
    _permissions = { for (var perm in widget.permissionList) perm.name: false };
    _selectAll = _permissions.values.every((v) => v);
  }

  void _toggleAll(bool? value) {
    setState(() {
      _selectAll = value ?? false;
      _permissions.updateAll((key, _) => _selectAll);
    });
  }

  void _togglePermission(String key, bool value) {
    setState(() {
      _permissions[key] = value;
      _selectAll = _permissions.values.every((v) => v);
    });
  }

  Future<void> _savePermissions() async {
    setState(() => _isSaving = true);
    try {
      final Map<String, String> permissionsMap = {};
      _permissions.forEach((key, value) {
        permissionsMap['permissions[$key]'] = value ? '1' : '0';
      });
      final success = await _repo.assignPermissions(
        userIds: [widget.user.id.toString()],
        centerId: '1',
        permissions: permissionsMap,
      );
      if (success) {
        UIHelpers.showToast(context, message: 'Permissions assigned successfully!', backgroundColor: AppColors.successColor);
        Navigator.pop(context);
      } else {
        UIHelpers.showToast(context, message: 'Failed to assign permissions', backgroundColor: AppColors.errorColor);
      }
    } catch (e) {
      UIHelpers.showToast(context, message: e.toString(), backgroundColor: AppColors.errorColor);
    }
    setState(() => _isSaving = false);
  }

  @override
  Widget build(BuildContext context) {
    return CustomScaffold(
      appBar: CustomAppBar(title: 'Permissions for ${widget.user.name}'),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            Row(
              children: [
                Checkbox(
                  value: _selectAll,
                  onChanged: _toggleAll,
                  activeColor: AppColors.primaryColor,
                ),
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
            const SizedBox(height: 12),
            Expanded(
              child: GridView.builder(
                itemCount: widget.permissionList.length,
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  mainAxisSpacing: 8,
                  crossAxisSpacing: 8,
                  childAspectRatio: 4.5,
                ),
                itemBuilder: (context, idx) {
                  final perm = widget.permissionList[idx];
                  return Row(
                    children: [
                      Checkbox(
                        value: _permissions[perm.name] ?? false,
                        onChanged: (val) => _togglePermission(perm.name, val ?? false),
                        activeColor: AppColors.primaryColor,
                      ),
                      Expanded(child: Text(perm.label)),
                    ],
                  );
                },
              ),
            ),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                OutlinedButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text('Close'),
                ),
                const SizedBox(width: 12),
                CustomButton(
                  width: 100,
                  isLoading: _isSaving,
                  ontap: _isSaving ? null : _savePermissions,
                  text: 'Save',
                ),
                
              ],
            ),
          ],
        ),
      ),
    );
  }
}
