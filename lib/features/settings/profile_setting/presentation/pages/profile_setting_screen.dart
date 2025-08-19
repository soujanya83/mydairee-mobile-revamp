import 'dart:io';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:mydiaree/core/config/app_colors.dart';
import 'package:mydiaree/core/utils/ui_helper.dart';
import 'package:mydiaree/core/widgets/custom_app_bar.dart';
import 'package:mydiaree/core/widgets/custom_buton.dart';
import 'package:mydiaree/core/widgets/custom_scaffold.dart';
import 'package:mydiaree/features/settings/profile_setting/data/repository/profile_setting_repository.dart';

class ProfileSettingScreen extends StatefulWidget {
  const ProfileSettingScreen({super.key});

  @override
  State<ProfileSettingScreen> createState() => _ProfileSettingScreenState();
}

class _ProfileSettingScreenState extends State<ProfileSettingScreen> {
  final _formKey = GlobalKey<FormState>();
  final _passwordFormKey = GlobalKey<FormState>();
  final ProfileSettingRepository _repo = ProfileSettingRepository();

  final TextEditingController nameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController contactNoController = TextEditingController();
  String? _selectedGender;
  File? _profileImage;
  String? _profileImageUrl;
  int? _userId;

  // Password fields
  final TextEditingController currentPasswordController =
      TextEditingController();
  final TextEditingController newPasswordController = TextEditingController();
  final TextEditingController confirmPasswordController =
      TextEditingController();

  // Separate loading variables
  bool _isProfileLoading = false;
  bool _isImageLoading = false;
  bool _isPasswordLoading = false;
  bool _obscureCurrent = true;
  bool _obscureNew = true;
  bool _obscureConfirm = true;

  @override
  void initState() {
    super.initState();
    _fetchProfile();
  }

  Future<void> _fetchProfile() async {
    setState(() => _isProfileLoading = true);
    await Future.delayed(const Duration(milliseconds: 500));
    setState(() {
      _userId = null; // 1;
      nameController.text = ''; // 'Deepti';
      emailController.text = ''; // 'info@mydiaree.com';
      contactNoController.text = ''; // '8339042376';
      _selectedGender = null; // 'FEMALE';
      _profileImageUrl = ''; // '';
      _isProfileLoading = false;
    });
  }

  Future<void> _pickImage() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.image,
      allowMultiple: false,
    );
    if (result != null &&
        result.files.isNotEmpty &&
        result.files.first.path != null) {
      setState(() {
        _profileImage = File(result.files.first.path!);
      });
    }
  }

  Future<void> _uploadProfileImage() async {
    if (_profileImage == null) {
      UIHelpers.showToast(context, message: 'Please select an image');
      return;
    }
    setState(() => _isImageLoading = true);
    final success = await _repo.uploadProfileImage([_profileImage!]);
    setState(() => _isImageLoading = false);
    if (success) {
      UIHelpers.showToast(context,
          message: 'Profile image updated!',
          backgroundColor: AppColors.successColor);
      // Optionally, refresh image from server
    } else {
      UIHelpers.showToast(context,
          message: 'Failed to update image',
          backgroundColor: AppColors.errorColor);
    }
  }

  Future<void> _updateProfile() async {
    if (!(_formKey.currentState?.validate() ?? false) ||
        _selectedGender == null) {
      if (_selectedGender == null) {
        UIHelpers.showToast(context,
            message: 'Please select a gender',
            backgroundColor: AppColors.errorColor);
      }
      return;
    }
    setState(() => _isProfileLoading = true);
    final success = await _repo.updateProfile(
      userId: _userId ?? 1,
      name: nameController.text,
      email: emailController.text,
      contactNo: contactNoController.text,
      gender: _selectedGender!,
    );
    setState(() => _isProfileLoading = false);
    if (success) {
      UIHelpers.showToast(context,
          message: 'Profile updated!', backgroundColor: AppColors.successColor);
    } else {
      UIHelpers.showToast(context,
          message: 'Failed to update profile',
          backgroundColor: AppColors.errorColor);
    }
  }

  Future<void> _changePassword() async {
    if (!(_passwordFormKey.currentState?.validate() ?? false)) return;
    setState(() => _isPasswordLoading = true);
    final success = await _repo.changePassword(
      userId: _userId ?? 1,
      currentPassword: currentPasswordController.text,
      newPassword: newPasswordController.text,
      newPasswordConfirmation: confirmPasswordController.text,
    );
    setState(() => _isPasswordLoading = false);
    if (success) {
      UIHelpers.showToast(context,
          message: 'Password updated!',
          backgroundColor: AppColors.successColor);
      currentPasswordController.clear();
      newPasswordController.clear();
      confirmPasswordController.clear();
    } else {
      UIHelpers.showToast(context,
          message: 'Failed to update password',
          backgroundColor: AppColors.errorColor);
    }
  }

  InputDecoration _inputDecoration(String label) {
    return InputDecoration(
      labelText: label,
      border: const OutlineInputBorder(
        borderSide: BorderSide(color: AppColors.primaryColor),
      ),
      focusedBorder: const OutlineInputBorder(
        borderSide: BorderSide(color: AppColors.primaryColor),
      ),
      enabledBorder: const OutlineInputBorder(
        borderSide: BorderSide(color: AppColors.primaryColor),
      ),
      labelStyle: const TextStyle(color: AppColors.primaryColor),
    );
  }

  @override
  Widget build(BuildContext context) {
    return CustomScaffold(
      appBar: const CustomAppBar(title: 'Profile Settings'),
      body: _isProfileLoading
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              padding: const EdgeInsets.all(20),
              child: Column(
                children: [
                  // Profile Photo
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Text('Profile Photo',
                        style: Theme.of(context).textTheme.titleMedium),
                  ),
                  const SizedBox(height: 10),
                  Row(
                    children: [
                      CircleAvatar(
                        radius: 52,
                        backgroundColor: AppColors.grey,
                        backgroundImage: _profileImage != null
                            ? FileImage(_profileImage!)
                            : (_profileImageUrl != null &&
                                    _profileImageUrl!.isNotEmpty
                                ? NetworkImage(_profileImageUrl!)
                                : null) as ImageProvider<Object>?,
                        child: _profileImage == null &&
                                (_profileImageUrl == null ||
                                    _profileImageUrl!.isEmpty)
                            ? const Icon(Icons.person,
                                size: 52, color: Colors.grey)
                            : null,
                      ),
                      const SizedBox(width: 20),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                                'Upload your photo.\nImage should be less than 2 MB'),
                            const SizedBox(height: 8),
                            Row(
                              children: [
                                OutlinedButton(
                                  onPressed: _pickImage,
                                  style: OutlinedButton.styleFrom(
                                    side: const BorderSide(
                                        color: AppColors.primaryColor),
                                  ),
                                  child: const Text('Upload Photo',
                                      style: TextStyle(
                                          color: AppColors.primaryColor)),
                                ),
                                const SizedBox(width: 12),
                                ElevatedButton(
                                  onPressed: _isImageLoading
                                      ? null
                                      : _uploadProfileImage,
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: AppColors.primaryColor,
                                  ),
                                  child: _isImageLoading
                                      ? const SizedBox(
                                          width: 18,
                                          height: 18,
                                          child: CircularProgressIndicator(
                                              strokeWidth: 2,
                                              color: Colors.white),
                                        )
                                      : const Text('Save',
                                          style:
                                              TextStyle(color: Colors.white)),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 32),
                  // Basic Information
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Text('Basic Information',
                        style: Theme.of(context).textTheme.titleMedium),
                  ),
                  const SizedBox(height: 10),
                  Form(
                    key: _formKey,
                    child: Column(
                      children: [
                        TextFormField(
                          controller: nameController,
                          decoration: _inputDecoration('Name'),
                          validator: (value) => value == null || value.isEmpty
                              ? 'Please enter name'
                              : null,
                        ),
                        const SizedBox(height: 16),
                        TextFormField(
                          controller: emailController,
                          decoration: _inputDecoration('Email ID'),
                          validator: (value) {
                            if (value == null || value.isEmpty)
                              return 'Please enter email';
                            if (!RegExp(
                                    r"^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$")
                                .hasMatch(value.trim())) {
                              return 'Please enter a valid email';
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 16),
                        TextFormField(
                          controller: contactNoController,
                          decoration: _inputDecoration('Contact No'),
                          validator: (value) {
                            if (value == null || value.isEmpty)
                              return 'Please enter contact number';
                            if (!RegExp(r'^\d{9,15}$').hasMatch(value)) {
                              return 'Please enter a valid contact number (9-15 digits)';
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 16),
                        DropdownButtonFormField<String>(
                          decoration: _inputDecoration('Gender'),
                          value: ['MALE', 'FEMALE', 'OTHERS']
                                  .contains(_selectedGender)
                              ? _selectedGender
                              : null,
                          items: ['MALE', 'FEMALE', 'OTHERS']
                              .map((gender) => DropdownMenuItem(
                                    value: gender,
                                    child: Text(gender),
                                  ))
                              .toList(),
                          onChanged: (value) {
                            setState(() {
                              _selectedGender = value;
                            });
                          },
                          validator: (value) =>
                              value == null ? 'Please select gender' : null,
                        ),
                        const SizedBox(height: 20),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            CustomButton(
                              text: 'Update',
                              height: 45,
                              width: 120,
                              isLoading: _isProfileLoading,
                              ontap: _isProfileLoading ? null : _updateProfile,
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 32),
                  // Change Password
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Text('Change Password',
                        style: Theme.of(context).textTheme.titleMedium),
                  ),
                  const SizedBox(height: 10),
                  Form(
                    key: _passwordFormKey,
                    child: Column(
                      children: [
                        TextFormField(
                          controller: currentPasswordController,
                          obscureText: _obscureCurrent,
                          decoration:
                              _inputDecoration('Current Password').copyWith(
                            suffixIcon: IconButton(
                              icon: Icon(
                                  _obscureCurrent
                                      ? Icons.visibility_off
                                      : Icons.visibility,
                                  color: AppColors.primaryColor),
                              onPressed: () => setState(
                                  () => _obscureCurrent = !_obscureCurrent),
                            ),
                          ),
                          validator: (value) => value == null || value.isEmpty
                              ? 'Enter current password'
                              : null,
                        ),
                        const SizedBox(height: 16),
                        TextFormField(
                          controller: newPasswordController,
                          obscureText: _obscureNew,
                          decoration: _inputDecoration('New Password').copyWith(
                            suffixIcon: IconButton(
                              icon: Icon(
                                  _obscureNew
                                      ? Icons.visibility_off
                                      : Icons.visibility,
                                  color: AppColors.primaryColor),
                              onPressed: () =>
                                  setState(() => _obscureNew = !_obscureNew),
                            ),
                          ),
                          validator: (value) => value == null || value.isEmpty
                              ? 'Enter new password'
                              : null,
                        ),
                        const SizedBox(height: 16),
                        TextFormField(
                          controller: confirmPasswordController,
                          obscureText: _obscureConfirm,
                          decoration:
                              _inputDecoration('Confirm New Password').copyWith(
                            suffixIcon: IconButton(
                              icon: Icon(
                                  _obscureConfirm
                                      ? Icons.visibility_off
                                      : Icons.visibility,
                                  color: AppColors.primaryColor),
                              onPressed: () => setState(
                                  () => _obscureConfirm = !_obscureConfirm),
                            ),
                          ),
                          validator: (value) {
                            if (value == null || value.isEmpty)
                              return 'Confirm new password';
                            if (value != newPasswordController.text)
                              return 'Passwords do not match';
                            return null;
                          },
                        ),
                        const SizedBox(height: 20),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            CustomButton(
                              text: 'Update',
                              height: 45,
                              width: 120,
                              isLoading: _isPasswordLoading,
                              ontap:
                                  _isPasswordLoading ? null : _changePassword,
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
    );
  }
}
