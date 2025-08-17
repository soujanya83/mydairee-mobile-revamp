import 'dart:io';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mydiaree/core/config/app_colors.dart';
import 'package:mydiaree/core/config/app_urls.dart';
import 'package:mydiaree/core/utils/ui_helper.dart';
import 'package:mydiaree/core/widgets/custom_app_bar.dart';
import 'package:mydiaree/core/widgets/custom_buton.dart';
import 'package:mydiaree/core/widgets/custom_scaffold.dart';
import 'package:mydiaree/core/widgets/custom_text_field.dart';
import 'package:mydiaree/features/settings/staff_setting/data/model/staff_model.dart';
import 'package:mydiaree/features/settings/staff_setting/data/repositories/staff_settings_repository.dart';
import 'package:mydiaree/features/settings/staff_setting/presentation/bloc/list/staff_setting_bloc.dart';
import 'package:mydiaree/features/settings/staff_setting/presentation/bloc/list/staff_setting_event.dart';

class AddStaffScreen extends StatefulWidget {
  final bool isEdit;
  final StaffModel? staff;
  final String? centerId;

  const AddStaffScreen({
    super.key,
    required this.isEdit,
    this.staff,
    this.centerId,
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
  bool _isLoading = false;
  final StaffRepository _repository = StaffRepository();

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

  Future<void> _submit() async {
    if (!(_formKey.currentState?.validate() ?? false) || _selectedGender == null) {
      if (_selectedGender == null) {
        UIHelpers.showToast(
          context,
          message: 'Please select a gender',
          backgroundColor: AppColors.errorColor,
        );
      }
      return;
    }
    setState(() => _isLoading = true);
    var success = false;
    var message = '';
    try {
      if (widget.isEdit && widget.staff != null) {
        final response = await _repository.updateStaff(
          id: widget.staff!.id.toString(),
          name: nameController.text,
          email: emailController.text,
          password: passwordController.text,
          contactNo: contactNoController.text,
          gender: _selectedGender!,
          avatarFile: _profileImage,
          centerId: widget.centerId!,
        );
        success = response.success;
        message = response.message;
      } else {
        final response = await _repository.addStaff(
          name: nameController.text,
          email: emailController.text,
          password: passwordController.text,
          contactNo: contactNoController.text,
          gender: _selectedGender!,
          avatarFile: _profileImage,
          centerId: widget.centerId??'1',
        );
        success = response.success;
        message = response.message;
      }
    } catch (e,s) {
      print(e.toString());
      print(s.toString());
      UIHelpers.showToast(
        context,
        message: e.toString(),
        backgroundColor: AppColors.errorColor,
      );
    }
    setState(() => _isLoading = false);
    if (success) {
      UIHelpers.showToast(
        context,
        message: widget.isEdit ? 'Staff updated successfully!' : 'Staff added successfully!',
        backgroundColor: AppColors.successColor,
      );
      if (widget.centerId != null) {
        context.read<StaffSettingsBloc>().add(FetchStaffEvent(centerId: widget.centerId!));
      }
      Navigator.pop(context, true);
    } else {
      UIHelpers.showToast(
        context,
        message: message,
        backgroundColor: AppColors.errorColor,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return CustomScaffold(
      appBar: CustomAppBar(
        title: widget.isEdit ? 'Edit Staff' : 'Add New Staff',
      ),
      body: SingleChildScrollView(
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
                                  widget.staff?.imageUrl.isNotEmpty == true
                              ? NetworkImage(
                                  widget.staff!.imageUrl.startsWith('http')
                                    ? widget.staff!.imageUrl
                                    : '${AppUrls.baseUrl}/${widget.staff!.imageUrl}',
                                )
                              : null),
                      child: _profileImage == null &&
                              (widget.staff?.imageUrl.isEmpty ?? true)
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
                  if (!RegExp(r"^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$")
                      .hasMatch(value!.trim())) {
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
                  CustomButton(
                    text: widget.isEdit ? 'Update' : 'Save',
                    height: 45,
                    width: 100,
                    isLoading: _isLoading,
                    ontap: _isLoading ? null : _submit,
                  ),
                ],
              ),
            ],
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
