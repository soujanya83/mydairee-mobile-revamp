import 'package:flutter/material.dart';
import 'package:mydiaree/core/config/app_colors.dart';
import 'package:mydiaree/core/widgets/custom_app_bar.dart';
import 'package:mydiaree/core/widgets/custom_scaffold.dart';
import 'package:mydiaree/core/widgets/custom_text_field.dart';
import 'package:mydiaree/features/settings/manage_permissions/data/model/user_model.dart';
import 'package:mydiaree/features/settings/manage_permissions/data/repositories/manage_permissions_repo.dart';
import 'package:mydiaree/main.dart';

class AssignedUserListScreen extends StatefulWidget {
  const AssignedUserListScreen({super.key});

  @override
  State<AssignedUserListScreen> createState() => _AssignedUserListScreenState();
}

class _AssignedUserListScreenState extends State<AssignedUserListScreen> {
  final ManagePermissionsRepository _repo = ManagePermissionsRepository();
  List<UserModel> _users = [];
  List<UserModel> _filteredUsers = [];
  bool _isLoading = true;
  String _searchText = '';

  @override
  void initState() {
    super.initState();
    _fetchUsers();
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
      // Optionally show error
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

  void _showUserPermissionsDialog(UserModel user) {
    // TODO: Implement permission dialog for user
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Permissions for ${user.name}'),
        content: const Text('Show user permissions here.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Close'),
          ),
        ],
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
                                          onPressed: () => _showUserPermissionsDialog(user),
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
