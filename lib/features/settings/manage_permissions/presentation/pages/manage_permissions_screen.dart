import 'package:flutter/material.dart';
import 'package:mydiaree/core/config/app_colors.dart';
import 'package:mydiaree/core/utils/ui_helper.dart';
import 'package:mydiaree/core/widgets/custom_app_bar.dart';
import 'package:mydiaree/core/widgets/custom_buton.dart';
import 'package:mydiaree/core/widgets/custom_scaffold.dart';
import 'package:mydiaree/features/settings/manage_permissions/data/model/permission_model.dart';
import 'package:mydiaree/features/settings/manage_permissions/data/model/user_model.dart';
import 'package:mydiaree/features/settings/manage_permissions/data/repositories/manage_permissions_repo.dart';
import 'package:mydiaree/features/settings/manage_permissions/presentation/pages/assigned_user_list_screen.dart';
import 'package:mydiaree/main.dart';
import 'package:mydiaree/core/widgets/custom_multi_selected_dialog.dart';

class ManagePermissionsScreen extends StatefulWidget {
  const ManagePermissionsScreen({super.key,});
  @override
  State<ManagePermissionsScreen> createState() =>
      _ManagePermissionsScreenState();
}

class _ManagePermissionsScreenState extends State<ManagePermissionsScreen> {
  final _formKey = GlobalKey<FormState>();
  final Map<String, bool> _permissions = {};
  bool _selectAll = false;
  List<PermissionModel> _permissionList = [];
  List<UserModel> _assignedUsers = [];
  bool _isLoading = true;
  bool _isAssigning = false;
  List<String> _selectedUserIds = [];
  List<UserModel> _staffList = [];

  final ManagePermissionsRepository _repo = ManagePermissionsRepository();

  @override
  void initState() {
    super.initState();
    _fetchPermissionsAndUsers();
    _fetchStaff();
  }

  Future<void> _fetchPermissionsAndUsers() async {
    setState(() => _isLoading = true);
    try {
      final permissions = await _repo.getPermissions();
      final users = await _repo.getAssignedUsers();
      setState(() {
        _permissionList = permissions;
        _assignedUsers = users;
        if (_permissions.isEmpty) {
          for (var perm in _permissionList) {
            _permissions[perm.name] = false;
          }
        }
      });
    } catch (e, s) {
      print(s.toString());
      print(e.toString());
      UIHelpers.showToast(context, message: e.toString(), backgroundColor: AppColors.errorColor);
    }
    setState(() => _isLoading = false);
  }

  Future<void> _fetchStaff() async {
    try {
      final staff = await _repo.getStaff('1');
      setState(() {
        _staffList = staff;
      });
    } catch (e) {
      UIHelpers.showToast(context, message: 'Failed to fetch staff: $e', backgroundColor: AppColors.errorColor);
    }
  }

  Future<void> _assignPermissions() async {
    if (_selectedUserIds.isEmpty) {
      UIHelpers.showToast(context, message: 'Please select at least one user', backgroundColor: AppColors.errorColor);
      return;
    }
    setState(() => _isAssigning = true);
    try {
      final Map<String, String> permissionsMap = {};
      _permissions.forEach((key, value) {
        permissionsMap['permissions[$key]'] = value ? '1' : '0';
      });
      final success = await _repo.assignPermissions(
        userIds: _selectedUserIds,
        centerId: '1',
        permissions: permissionsMap,
      );
      if (success) {
        UIHelpers.showToast(context, message: 'Permissions assigned successfully!', backgroundColor: AppColors.successColor);
      } else {
        UIHelpers.showToast(context, message: 'Failed to assign permissions', backgroundColor: AppColors.errorColor);
      }
    } catch (e) {
      UIHelpers.showToast(context, message: e.toString(), backgroundColor: AppColors.errorColor);
    }
    setState(() => _isAssigning = false);
  }

  void _toggleAllPermissions(bool? value) {
    setState(() {
      _selectAll = value ?? false;
      for (var perm in _permissionList) {
        _permissions[perm.name] = _selectAll;
      }
    });
  }

  // Helper to group permissions by module (based on label)
  Map<String, List<PermissionModel>> _groupPermissionsByModule(List<PermissionModel> permissions) {
    final Map<String, List<PermissionModel>> grouped = {};
    for (final perm in permissions) {
      // Extract module name from label (e.g., "Add Observation" -> "Observation")
      final label = perm.label.trim();
      String module = '';
      final parts = label.split(' ');
      if (parts.length > 1) {
        module = parts.sublist(1).join(' ');
      } else {
        module = label;
      }
      // Special handling for known modules
      final knownModules = [
        'Observation', 'Reflection', 'Qip', 'Room', 'Program Plan', 'Announcement', 'Survey', 'Recipe', 'Menu', 'Daily Diary', 'Head Checks', 'Accidents', 'Modules', 'Users', 'Centers', 'Parent', 'Child Group', 'Permission', 'Progress', 'Lesson', 'Assessment', 'Self Assessment'
      ];
      module = knownModules.firstWhere(
        (m) => label.toLowerCase().contains(m.toLowerCase()),
        orElse: () => module,
      );
      grouped.putIfAbsent(module, () => []).add(perm);
    }
    return grouped;
  }

  // Helper to map permission keys to icons
  IconData _getPermissionIcon(String key) {
    if (key.toLowerCase().contains('add')) return Icons.add_circle;
    if (key.toLowerCase().contains('approve')) return Icons.check_circle;
    if (key.toLowerCase().contains('delete')) return Icons.delete;
    if (key.toLowerCase().contains('update')) return Icons.edit;
    if (key.toLowerCase().contains('view')) return Icons.remove_red_eye;
    if (key.toLowerCase().contains('print')) return Icons.print;
    if (key.toLowerCase().contains('download')) return Icons.download;
    if (key.toLowerCase().contains('mail')) return Icons.mail;
    return Icons.settings;
  }

  // Helper to map module to icon
  IconData _getModuleIcon(String module) {
    switch (module.toLowerCase()) {
      case 'observation':
        return Icons.equalizer;
      case 'reflection':
        return Icons.lightbulb_outline;
      case 'qip':
        return Icons.assignment;
      case 'room':
        return Icons.meeting_room;
      case 'program plan':
        return Icons.event_note;
      case 'announcement':
        return Icons.announcement;
      case 'survey':
        return Icons.poll;
      case 'recipe':
        return Icons.restaurant_menu;
      case 'menu':
        return Icons.menu_book;
      case 'daily diary':
        return Icons.book;
      case 'head checks':
        return Icons.health_and_safety;
      case 'accidents':
        return Icons.warning;
      case 'modules':
        return Icons.extension;
      case 'users':
        return Icons.person;
      case 'centers':
        return Icons.location_city;
      case 'parent':
        return Icons.family_restroom;
      case 'child group':
        return Icons.group;
      case 'permission':
        return Icons.verified_user;
      case 'progress':
        return Icons.trending_up;
      case 'lesson':
        return Icons.menu_book;
      case 'assessment':
        return Icons.assignment_turned_in;
      case 'self assessment':
        return Icons.assignment_ind;
      default:
        return Icons.settings;
    }
  }

  @override
  Widget build(BuildContext context) {
    final groupedPermissions = _groupPermissionsByModule(_permissionList);

    return CustomScaffold(
      appBar: const CustomAppBar(title: 'Manage Permissions'),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
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
                          isLoading: false,
                          ontap: () {
                            Navigator.of(context).push(
                              MaterialPageRoute(
                                builder: (context) => const AssignedUserListScreen(),
                              ),
                            );
                            // showDialog(
                            //   context: context,
                            //   builder: (context) => AlertDialog(
                            //     title: const Text('Assigned Users'),
                            //     content: SizedBox(
                            //       width: 350,
                            //       child: ListView.builder(
                            //         shrinkWrap: true,
                            //         itemCount: _assignedUsers.length,
                            //         itemBuilder: (context, index) {
                            //           final user = _assignedUsers[index];
                            //           return ListTile(
                            //             leading: CircleAvatar(
                            //               backgroundColor: AppColors.primaryColor,
                            //               child: Text(user.name.isNotEmpty ? user.name[0] : ''),
                            //             ),
                            //             title: Text(user.name),
                            //             subtitle: Text(user.name),
                            //           );
                            //         },
                            //       ),
                            //     ),
                            //     actions: [
                            //       TextButton(
                            //         onPressed: () => Navigator.pop(context),
                            //         child: const Text('Close'),
                            //       ),
                            //     ],
                            //   ),
                            // );
                          },
                        )
                      ],
                    ),
                    const SizedBox(height: 16),
                    Text(
                      'Select User(s)',
                      style: Theme.of(context).textTheme.bodyMedium,
                    ),
                    const SizedBox(height: 6),
                    GestureDetector(
                      onTap: () {
                        if (_staffList.isEmpty) return;
                        showDialog(
                          context: context,
                          builder: (context) => CustomMultiSelectDialog(
                            title: 'Select Users',
                            itemsId: _staffList.map((u) => u.id.toString()).toList(),
                            itemsName: _staffList.map((u) => u.name).toList(),
                            initiallySelectedIds: _selectedUserIds,
                            onItemTap: (ids) {
                              setState(() {
                                _selectedUserIds = List<String>.from(ids);
                              });
                            },
                          ),
                        );
                      },
                      child: Container(
                        width: 220,
                        height: 38,
                        decoration: BoxDecoration(
                          color: AppColors.primaryColor,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Row(
                          children: const [
                            SizedBox(width: 8),
                            Icon(Icons.add_circle, color: Colors.white),
                            SizedBox(width: 8),
                            Text('Select Users', style: TextStyle(color: Colors.white)),
                          ],
                        ),
                      ),
                    ),
                    if (_selectedUserIds.isNotEmpty)
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 8),
                        child: SizedBox(
                          height: 40,
                          child: ListView(
                            scrollDirection: Axis.horizontal,
                            children: _selectedUserIds.map((userId) {
                              final user = _staffList.firstWhere(
                                (u) => u.id.toString() == userId,
                                orElse: () => UserModel(id: int.tryParse(userId) ?? 0, name: userId, colorClass: ''),
                              );
                              return Padding(
                                padding: const EdgeInsets.only(right: 8),
                                child: Chip(
                                  label: Text(user.name),
                                  deleteIcon: const Icon(Icons.close),
                                  onDeleted: () {
                                    setState(() {
                                      _selectedUserIds.remove(userId);
                                    });
                                  },
                                ),
                              );
                            }).toList(),
                          ),
                        ),
                      ),
                    const SizedBox(height: 16),
                    Align(
                      alignment: Alignment.topRight,
                      child: CustomButton(
                        borderRadius: 10,
                        text: 'Assign',
                        textAppTextStyles:
                            Theme.of(context).textTheme.labelMedium,
                        height: 37,
                        width: 90,
                        isLoading: _isAssigning,
                        ontap: _isAssigning ? null : _assignPermissions,
                      ),
                    ),
                    const SizedBox(height: 5),
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
                    const SizedBox(height: 16),
                    ...groupedPermissions.entries.map((entry) {
                      final module = entry.key;
                      final perms = entry.value;
                      final allSelected = perms.every((perm) => _permissions[perm.name] ?? false);
                      final anySelected = perms.any((perm) => _permissions[perm.name] ?? false);
                      return Container(
                        margin: const EdgeInsets.symmetric(vertical: 10),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(12),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.grey.withOpacity(0.5),
                              blurRadius: 8,
                              offset: const Offset(0, 2),
                            ),
                          ],
                          border: Border.all(color: Colors.grey.shade200),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // Card Header
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                              decoration: BoxDecoration(
                                color: AppColors.primaryColor.withOpacity(0.4),
                                borderRadius: const BorderRadius.vertical(top: Radius.circular(12)),
                              ),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Row(
                                    children: [
                                      Icon(_getModuleIcon(module), color: AppColors.primaryColor),
                                      const SizedBox(width: 10),
                                      SizedBox(
                                        width: MediaQuery.of(context).size.width * 0.5,
                                        child: Text(
                                          '${module[0].toUpperCase()}${module.substring(1)} Management',
                                          style: Theme.of(context).textTheme.titleMedium,
                                          maxLines: 2,
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                      ),
                                    ],
                                  ),
                                  TextButton.icon(
                                    style: TextButton.styleFrom(
                                      foregroundColor: allSelected
                                          ? AppColors.primaryColor
                                          : AppColors.grey,
                                    ),
                                    onPressed: () {
                                      setState(() {
                                        final newValue = !allSelected;
                                        for (final perm in perms) {
                                          _permissions[perm.name] = newValue;
                                        }
                                      });
                                    },
                                    icon: Icon(Icons.check_circle,
                                        color: allSelected
                                            ? AppColors.primaryColor
                                            : AppColors.grey),
                                    label: Text('All',style: Theme.of(context).textTheme.titleMedium?.copyWith(
                                      color: allSelected
                                            ? AppColors.primaryColor
                                            : AppColors.white
                                    ),),
                                  ),
                                ],
                              ),
                            ),
                            // Card Body
                            Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                              child: Column(
                                children: perms.map((perm) {
                                  return Container(
                                    margin: const EdgeInsets.symmetric(vertical: 6),
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: [
                                        Row(
                                          children: [
                                            Icon(_getPermissionIcon(perm.name), color: AppColors.primaryColor, size: 20),
                                            const SizedBox(width: 8),
                                            Text(
                                              perm.label,
                                              style: const TextStyle(fontSize: 15),
                                            ),
                                          ],
                                        ),
                                        Switch(
                                          value: _permissions[perm.name] ?? false,
                                          onChanged: (value) {
                                            setState(() {
                                              _permissions[perm.name] = value;
                                            });
                                          },
                                          activeColor: AppColors.primaryColor,
                                        ),
                                      ],
                                    ),
                                  );
                                }).toList(),
                              ),
                            ),
                          ],
                        ),
                      );
                    }).toList(),
                  ],
                ),
              ),
            ),
    );
  }
}

