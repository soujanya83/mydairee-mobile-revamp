import 'dart:io';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mydiaree/core/config/app_colors.dart';
import 'package:mydiaree/core/utils/ui_helper.dart';
import 'package:mydiaree/core/widgets/custom_app_bar.dart';
import 'package:mydiaree/core/widgets/custom_buton.dart';
import 'package:mydiaree/core/widgets/custom_scaffold.dart';
import 'package:mydiaree/core/widgets/custom_text_field.dart';
import 'package:mydiaree/features/settings/staff_setting/data/model/staff_model.dart';
import 'package:mydiaree/features/settings/staff_setting/presentation/bloc/list/staff_setting_bloc.dart';
import 'package:mydiaree/features/settings/staff_setting/presentation/bloc/list/staff_setting_event.dart';
import 'package:mydiaree/features/settings/staff_setting/presentation/bloc/list/staff_setting_state.dart';

class AddStaffScreen extends StatefulWidget {
  final bool isEdit;
  final StaffModel? staff;

  const AddStaffScreen({
    super.key,
    required this.isEdit,
    this.staff,
  });

  @override
  State<AddStaffScreen> createState() => _AddStaffScreenState();
}

class _AddStaffScreenState extends State<AddStaffScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController nameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController contactNoController = TextEditingController();
  String? _selectedGender;
  File? _profileImage;
  bool _obscurePassword = true;

  @override
  void initState() {
    super.initState();
    if (widget.isEdit && widget.staff != null) {
      nameController.text = widget.staff?.name ?? '';
      emailController.text = widget.staff?.email ?? '';
      contactNoController.text = widget.staff?.contactNo ?? '';
      _selectedGender =
          ['MALE', 'FEMALE', 'OTHERS'].contains(widget.staff?.gender)
              ? widget.staff?.gender
              : null;
    }
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

  @override
  Widget build(BuildContext context) {
    return CustomScaffold(
      appBar: CustomAppBar(
        title: widget.isEdit ? 'Edit Staff' : 'Add New Staff',
      ),
      body: BlocListener<StaffSettingsBloc, StaffSettingsState>(
        listener: (context, state) {
          if (state is StaffSettingsSuccess) {
            UIHelpers.showToast(
              context,
              message: state.message,
              backgroundColor: AppColors.successColor,
            );
            Navigator.pop(context);
          } else if (state is StaffSettingsFailure) {
            UIHelpers.showToast(
              context,
              message: state.message,
              backgroundColor: AppColors.errorColor,
            );
          }
        },
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Staff Details',
                  style: Theme.of(context).textTheme.titleMedium,
                ),
                const SizedBox(height: 16),
                Center(
                  child: Stack(
                    children: [
                      CircleAvatar(
                        radius: 50,
                        backgroundColor: AppColors.grey,
                        backgroundImage: _profileImage != null
                            ? FileImage(_profileImage!)
                            : (widget.isEdit &&
                                    widget.staff?.avatarUrl.isNotEmpty == true
                                ? NetworkImage(widget.staff!.avatarUrl)
                                : null),
                        child: _profileImage == null &&
                                (widget.staff?.avatarUrl.isEmpty ?? true)
                            ? const Icon(Icons.person,
                                size: 50, color: Colors.grey)
                            : null,
                      ),
                      Positioned(
                        bottom: 0,
                        right: 0,
                        child: GestureDetector(
                          onTap: _pickImage,
                          child: Container(
                            padding: const EdgeInsets.all(4),
                            decoration: const BoxDecoration(
                              color: AppColors.primaryColor,
                              shape: BoxShape.circle,
                            ),
                            child: const Icon(
                              Icons.camera_alt,
                              color: Colors.white,
                              size: 20,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 16),
                CustomTextFormWidget(
                  title: 'Name',
                  controller: nameController,
                  validator: (value) =>
                      value?.isEmpty ?? true ? 'Please enter name' : null,
                ),
                const SizedBox(height: 16),
                CustomTextFormWidget(
                  title: 'Email',
                  controller: emailController,
                  validator: (value) {
                    if (value?.isEmpty ?? true) return 'Please enter email';
                    if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$')
                        .hasMatch(value!)) {
                      return 'Please enter a valid email';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),
                CustomTextFormWidget(
                  title: widget.isEdit ? 'Password (Optional)' : 'Password',
                  controller: passwordController,
                  isObs: _obscurePassword,
                  validator: (value) {
                    if (!widget.isEdit && (value?.isEmpty ?? true)) {
                      return 'Please enter password';
                    }
                    return null;
                  },
                  suffixWidget: IconButton(
                    icon: Icon(
                      _obscurePassword
                          ? Icons.visibility_off
                          : Icons.visibility,
                      color: AppColors.primaryColor,
                    ),
                    onPressed: () {
                      setState(() {
                        _obscurePassword = !_obscurePassword;
                      });
                    },
                  ),
                ),
                const SizedBox(height: 16),
                CustomTextFormWidget(
                  keyboardType: TextInputType.number,
                  title: 'Contact No.',
                  controller: contactNoController,
                  validator: (value) {
                    if (value?.isEmpty ?? true)
                      return 'Please enter contact number';
                    if (!RegExp(r'^\d{9,15}$').hasMatch(value!)) {
                      return 'Please enter a valid contact number';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),
                DropdownButtonFormField<String>(
                  decoration: const InputDecoration(
                      labelText: 'Gender',
                      border: OutlineInputBorder(
                        borderSide: BorderSide(color: AppColors.primaryColor),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: AppColors.primaryColor),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: AppColors.primaryColor),
                      )),
                  value: _selectedGender,
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
                const SizedBox(height: 24),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    OutlinedButton(
                      onPressed: () => Navigator.pop(context),
                      child: const Text('Cancel'),
                    ),
                    const SizedBox(width: 16),
                    BlocBuilder<StaffSettingsBloc, StaffSettingsState>(
                      builder: (context, state) {
                        return CustomButton(
                          text: widget.isEdit ? 'Update' : 'Save',
                          height: 45,
                          width: 100,
                          isLoading: state is StaffSettingsLoading,
                          ontap: () {
                            if (_formKey.currentState?.validate() ??
                                false && _selectedGender != null) {
                              final event = widget.isEdit
                                  ? UpdateStaffEvent(
                                      id: widget.staff?.id ?? '',
                                      name: nameController.text,
                                      email: emailController.text,
                                      password: passwordController.text,
                                      contactNo: contactNoController.text,
                                      gender: _selectedGender!,
                                      avatarUrl: _profileImage?.path ??
                                          widget.staff?.avatarUrl ??
                                          '',
                                      userType: 'Staff',
                                    )
                                  : AddStaffEvent(
                                      name: nameController.text,
                                      email: emailController.text,
                                      password: passwordController.text,
                                      contactNo: contactNoController.text,
                                      gender: _selectedGender!,
                                      avatarUrl: _profileImage?.path ?? '',
                                      userType: 'Staff',
                                    );
                              context.read<StaffSettingsBloc>().add(event);
                            } else if (_selectedGender == null) {
                              UIHelpers.showToast(
                                context,
                                message: 'Please select a gender',
                                backgroundColor: AppColors.errorColor,
                              );
                            }
                          },
                        );
                      },
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    nameController.dispose();
    emailController.dispose();
    passwordController.dispose();
    contactNoController.dispose();
    super.dispose();
  }
}
