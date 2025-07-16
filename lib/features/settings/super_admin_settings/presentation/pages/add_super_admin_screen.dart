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
import 'package:mydiaree/features/settings/super_admin_settings/data/model/super_admin_model.dart';
import 'package:mydiaree/features/settings/super_admin_settings/presentation/bloc/list/super_admin_setting_bloc.dart';
import 'package:mydiaree/features/settings/super_admin_settings/presentation/bloc/list/super_admin_setting_event.dart';
import 'package:mydiaree/features/settings/super_admin_settings/presentation/bloc/list/super_admin_setting_state.dart';

class AddSuperAdminScreen extends StatefulWidget {
  final bool isEdit;
  final SuperAdminModel? superAdmin;

  const AddSuperAdminScreen({
    super.key,
    required this.isEdit,
    this.superAdmin,
  });

  @override
  State<AddSuperAdminScreen> createState() => _AddSuperAdminScreenState();
}

class _AddSuperAdminScreenState extends State<AddSuperAdminScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController nameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController contactNoController = TextEditingController();
  final TextEditingController centerNameController = TextEditingController();
  final TextEditingController streetAddressController = TextEditingController();
  final TextEditingController cityController = TextEditingController();
  final TextEditingController stateController = TextEditingController();
  final TextEditingController zipController = TextEditingController();
  String? _selectedGender;
  File? _profileImage;

  @override
  void initState() {
    super.initState();
    if (widget.isEdit && widget.superAdmin != null) {
      try {
        nameController.text = widget.superAdmin?.name ?? '';
        emailController.text = widget.superAdmin?.email ?? '';
        contactNoController.text = widget.superAdmin?.contactNo ?? '';
        _selectedGender =
            ['MALE', 'FEMALE', 'OTHERS'].contains(widget.superAdmin?.gender)
                ? widget.superAdmin?.gender
                : null;
        centerNameController.text = widget.superAdmin?.centerName ?? '';
        streetAddressController.text = widget.superAdmin?.streetAddress ?? '';
        cityController.text = widget.superAdmin?.city ?? '';
        stateController.text = widget.superAdmin?.state ?? '';
        zipController.text = widget.superAdmin?.zip ?? '';
      } catch (e) {}
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
        title: widget.isEdit ? 'Edit Superadmin' : 'Add New Superadmin',
      ),
      body: BlocListener<SuperAdminSettingsBloc, SuperAdminSettingsState>(
        listener: (context, state) {
          if (state is SuperAdminSettingsSuccess) {
            UIHelpers.showToast(
              context,
              message: state.message,
              backgroundColor: AppColors.successColor,
            );
            Navigator.pop(context);
          } else if (state is SuperAdminSettingsFailure) {
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
                  'Superadmin Details',
                  style: Theme.of(context).textTheme.titleMedium,
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
                if (!widget.isEdit) ...[
                  const SizedBox(height: 16),
                  CustomTextFormWidget(
                    title: 'Password',
                    controller: passwordController,
                    isObs: true,
                    validator: (value) =>
                        value?.isEmpty ?? true ? 'Please enter password' : null,
                  ),
                ],
                const SizedBox(height: 16),
                CustomTextFormWidget(
                  title: 'Contact No.',
                  controller: contactNoController,
                  validator: (value) {
                    if (value?.isEmpty ?? true)
                      return 'Please enter contact number';
                    if (!RegExp(r'^\d{9,15}$').hasMatch(value!)) {
                      return 'Please enter a valid contact number (9-15 digits)';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),
                DropdownButtonFormField<String>(
                  decoration: InputDecoration(
                      labelText: 'Gender',
                      border: OutlineInputBorder(
                        borderSide: BorderSide(color: AppColors.primaryColor),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: AppColors.primaryColor),
                      ),
                      focusColor: AppColors.white),
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
                const SizedBox(height: 16),
                GestureDetector(
                  onTap: _pickImage,
                  child: Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: AppColors.white,
                      border: Border.all(color: AppColors.primaryColor),
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: Row(
                      children: [
                        Expanded(
                          child: Text(
                            _profileImage?.path.split('/').last ??
                                'Select Profile Image',
                            style: Theme.of(context).textTheme.bodyMedium,
                          ),
                        ),
                        const Icon(Icons.upload_file,
                            color: AppColors.primaryColor),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 24),
                Text(
                  'Center Details',
                  style: Theme.of(context).textTheme.titleMedium,
                ),
                const SizedBox(height: 16),
                CustomTextFormWidget(
                  title: 'Center Name',
                  controller: centerNameController,
                  validator: (value) => value?.isEmpty ?? true
                      ? 'Please enter center name'
                      : null,
                ),
                const SizedBox(height: 16),
                CustomTextFormWidget(
                  title: 'Street Address',
                  controller: streetAddressController,
                  validator: (value) => value?.isEmpty ?? true
                      ? 'Please enter street address'
                      : null,
                ),
                const SizedBox(height: 16),
                CustomTextFormWidget(
                  title: 'City',
                  controller: cityController,
                  validator: (value) =>
                      value?.isEmpty ?? true ? 'Please enter city' : null,
                ),
                const SizedBox(height: 16),
                CustomTextFormWidget(
                  title: 'State',
                  controller: stateController,
                  validator: (value) =>
                      value?.isEmpty ?? true ? 'Please enter state' : null,
                ),
                const SizedBox(height: 16),
                CustomTextFormWidget(
                  title: 'ZIP Code',
                  controller: zipController,
                  validator: (value) {
                    if (value?.isEmpty ?? true) return 'Please enter ZIP code';
                    if (!RegExp(r'^\d{4,5}$').hasMatch(value!)) {
                      return 'Please enter a valid ZIP code (4-5 digits)';
                    }
                    return null;
                  },
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
                    BlocBuilder<SuperAdminSettingsBloc,
                        SuperAdminSettingsState>(
                      builder: (context, state) {
                        return CustomButton(
                          text: widget.isEdit ? 'Update' : 'Save',
                          height: 45,
                          width: 100,
                          isLoading: state is SuperAdminSettingsLoading,
                          ontap: () {
                            // if (_formKey.currentState?.validate() ??
                            //     false && _selectedGender != null)
                            if (true) {
                              final event = true
                                  ? UpdateSuperAdminEvent(
                                      id: widget.superAdmin?.id ?? '',
                                      name: nameController.text,
                                      email: emailController.text,
                                      password: '',
                                      contactNo: contactNoController.text,
                                      gender: _selectedGender!,
                                      avatarUrl: _profileImage?.path ??
                                          widget.superAdmin?.avatarUrl ??
                                          '',
                                      centerName: centerNameController.text,
                                      streetAddress:
                                          streetAddressController.text,
                                      city: cityController.text,
                                      state: stateController.text,
                                      zip: zipController.text,
                                    )
                                  : AddSuperAdminEvent(
                                      name: nameController.text,
                                      email: emailController.text,
                                      password: passwordController.text,
                                      contactNo: contactNoController.text,
                                      gender: _selectedGender!,
                                      avatarUrl: _profileImage?.path ?? '',
                                      centerName: centerNameController.text,
                                      streetAddress:
                                          streetAddressController.text,
                                      city: cityController.text,
                                      state: stateController.text,
                                      zip: zipController.text,
                                    );
                              context.read<SuperAdminSettingsBloc>().add(event);
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
    centerNameController.dispose();
    streetAddressController.dispose();
    cityController.dispose();
    stateController.dispose();
    zipController.dispose();
    super.dispose();
  }
}
