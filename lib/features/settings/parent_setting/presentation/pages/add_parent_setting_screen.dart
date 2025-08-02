import 'dart:io';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mydiaree/core/config/app_colors.dart';
import 'package:mydiaree/core/cubit/global_data_cubit.dart';
import 'package:mydiaree/core/cubit/globle_model/children_model.dart';
import 'package:mydiaree/core/cubit/globle_repository.dart';
import 'package:mydiaree/core/services/apiresoponse.dart';
import 'package:mydiaree/core/utils/ui_helper.dart';
import 'package:mydiaree/core/widgets/custom_app_bar.dart';
import 'package:mydiaree/core/widgets/custom_buton.dart';
import 'package:mydiaree/core/widgets/custom_dropdown.dart';
import 'package:mydiaree/core/widgets/custom_multi_selected_dialog.dart';
import 'package:mydiaree/core/widgets/custom_scaffold.dart';
import 'package:mydiaree/core/widgets/custom_text_field.dart';
import 'package:mydiaree/features/settings/parent_setting/data/model/parent_model.dart';
import 'package:mydiaree/features/settings/parent_setting/presentation/bloc/list/parent_setting_bloc.dart';
import 'package:mydiaree/features/settings/parent_setting/presentation/bloc/list/parent_setting_event.dart';
import 'package:mydiaree/features/settings/parent_setting/presentation/bloc/list/parent_setting_state.dart';

class AddParentScreen extends StatefulWidget {
  final bool isEdit;
  final ParentModel? parent;
  final String? centerId;

  const AddParentScreen({
    this.centerId,
    super.key,
    required this.isEdit,
    this.parent,
  });

  @override
  State<AddParentScreen> createState() => _AddParentScreenState();
}

class _AddParentScreenState extends State<AddParentScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController nameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController contactNoController = TextEditingController();
  final List<Map<String, String>> _children = [];
  String? _selectedGender;
  File? _profileImage;
  bool _obscurePassword = true;

  @override
  void initState() {
    super.initState();
    if (widget.isEdit && widget.parent != null) {
      nameController.text = widget.parent?.name ?? '';
      emailController.text = widget.parent?.email ?? '';
      contactNoController.text = widget.parent?.contactNo ?? '';
      _selectedGender =
          ['MALE', 'FEMALE', 'OTHERS'].contains(widget.parent?.gender)
              ? widget.parent?.gender
              : null;
      _children.addAll(widget.parent?.children ?? []);
    }
    getChildren();
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

  // Future<void> _showChildrenDialog() async {
  //   final globalState = context.read<GlobalDataCubit>().state;
  //   final children = globalState.childrenData?.data ?? [];
  //   await showDialog<List<Map<String, String>>>(
  //     context: context,
  //     builder: (context) => CustomMultiSelectDialog(
  //       itemsId: List.generate(
  //         children.length,
  //         (index) => children[index].id,
  //       ),
  //       itemsName: List.generate(
  //         children.length,
  //         (index) => children[index].name,
  //       ),
  //       initiallySelectedIds:
  //           _children.map((child) => child['id'] ?? '').toList(),
  //       title: 'Select Children',
  //       onItemTap: (selectedIdsAndRoles) {
  //         setState(() {
  //           _children.clear();
  //           _children.addAll(selectedIdsAndRoles);
  //         });
  //       },
  //     ),
  //   );
  // }

  ApiResponse<ChildModel?>? childrenData;
  final GlobalRepository repository = GlobalRepository();
  getChildren() async {
    // childrenData = await repository.getChildren(widget.centerId ?? '');
  }

  Future<void> _showChildrenDialog() async {
    final children = childrenData?.data?.data ?? [];

    await showDialog<List<String>>(
      context: context,
      builder: (context) => CustomMultiSelectDialog(
        itemsId: children.map((c) => c.id).toList(),
        itemsName: children.map((c) => c.name).toList(),
        initiallySelectedIds:
            _children.map((child) => child['id'] ?? '').toList(),
        title: 'Select Children',
        onItemTap: (selectedIds) {
          setState(() {
            _children.clear();
            for (final id in selectedIds) {
              final child = children.firstWhere((c) => c.id == id,
                  orElse: () => ChildIten(id: '', name: ''));
              if (child.id.isNotEmpty) {
                _children.add({'id': child.id, 'name': child.name});
              }
            }
          });
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return CustomScaffold(
      appBar: CustomAppBar(
        title: widget.isEdit ? 'Edit Parent' : 'Add New Parent',
      ),
      body: BlocListener<ParentSettingsBloc, ParentSettingsState>(
        listener: (context, state) {
          if (state is ParentSettingsSuccess) {
            UIHelpers.showToast(
              context,
              message: state.message,
              backgroundColor: AppColors.successColor,
            );
            Navigator.pop(context);
          } else if (state is ParentSettingsFailure) {
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
                  'Parent Details',
                  style: Theme.of(context).textTheme.titleMedium,
                ),
                const SizedBox(height: 16),
                Center(
                  child: Stack(
                    children: [
                      CircleAvatar(
                        backgroundColor: AppColors.grey,
                        radius: 50,
                        backgroundImage: _profileImage != null
                            ? FileImage(_profileImage!)
                            : (widget.isEdit &&
                                    widget.parent?.avatarUrl.isNotEmpty == true
                                ? NetworkImage(widget.parent!.avatarUrl)
                                : null),
                        child: _profileImage == null &&
                                (widget.parent?.avatarUrl.isEmpty ?? true)
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
                    ),
                    disabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: AppColors.primaryColor),
                    ),
                  ),
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
                Text(
                  'Children',
                  style: Theme.of(context).textTheme.titleMedium,
                ),
                const SizedBox(height: 6),
                GestureDetector(
                  onTap: _showChildrenDialog,
                  child: Container(
                    width: 180,
                    height: 38,
                    decoration: BoxDecoration(
                      color: AppColors.primaryColor,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: const Row(
                      children: [
                        SizedBox(width: 8),
                        Icon(Icons.add_circle, color: Colors.white),
                        SizedBox(width: 8),
                        Text('Select Children',
                            style: TextStyle(color: Colors.white)),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 10),
                if (_children.isNotEmpty)
                  Wrap(
                    spacing: 8,
                    children: _children
                        .asMap()
                        .entries
                        .map((entry) => Chip(
                              label: Text(
                                  '${entry.value['name']} (${entry.value['role']})'),
                              onDeleted: () {
                                setState(() {
                                  _children.removeAt(entry.key);
                                });
                              },
                            ))
                        .toList(),
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
                    BlocBuilder<ParentSettingsBloc, ParentSettingsState>(
                      builder: (context, state) {
                        return CustomButton(
                          text: widget.isEdit ? 'Update' : 'Save',
                          height: 45,
                          width: 100,
                          isLoading: state is ParentSettingsLoading,
                          ontap: () {
                            if (_formKey.currentState?.validate() ?? false) {
                              final event = widget.isEdit
                                  ? UpdateParentEvent(
                                      id: widget.parent?.id ?? '',
                                      name: nameController.text,
                                      email: emailController.text,
                                      password: passwordController.text,
                                      contactNo: contactNoController.text,
                                      gender: _selectedGender!,
                                      avatarUrl: _profileImage?.path ??
                                          widget.parent?.avatarUrl ??
                                          '',
                                      children: _children,
                                    )
                                  : AddParentEvent(
                                      name: nameController.text,
                                      email: emailController.text,
                                      password: passwordController.text,
                                      contactNo: contactNoController.text,
                                      gender: _selectedGender!,
                                      avatarUrl: _profileImage?.path ?? '',
                                      children: _children,
                                    );
                              context.read<ParentSettingsBloc>().add(event);
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

class CustomMultiSelectDialog extends StatefulWidget {
  final List<String> itemsId;
  final List<String> itemsName;
  final List<String> initiallySelectedIds;
  final String title;
  final Function(List<Map<String, String>>) onItemTap;

  const CustomMultiSelectDialog({
    super.key,
    required this.itemsId,
    required this.itemsName,
    this.initiallySelectedIds = const [],
    required this.title,
    required this.onItemTap,
  });

  @override
  State<CustomMultiSelectDialog> createState() =>
      _CustomMultiSelectDialogState();
}

class _CustomMultiSelectDialogState extends State<CustomMultiSelectDialog> {
  late List<String> selectedIds;
  final Map<String, String> selectedRoles = {};

  @override
  void initState() {
    super.initState();
    selectedIds = List<String>.from(widget.initiallySelectedIds);
    // Initialize roles for initially selected IDs
    for (var id in widget.initiallySelectedIds) {
      selectedRoles[id] = selectedRoles[id] ?? 'Father'; // Default role
    }
  }

  @override
  Widget build(BuildContext context) {
    final roles = ['Father', 'Mother', 'Brother', 'Sister', 'Other'];
    return Dialog(
      insetPadding: EdgeInsets.all(10),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              widget.title,
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 18,
              ),
            ),
            const SizedBox(height: 12),
            SizedBox(
              height: 300,
              width: double.maxFinite,
              child: Scrollbar(
                thumbVisibility: true,
                child: ListView.builder(
                  shrinkWrap: true,
                  itemCount: widget.itemsId.length,
                  itemBuilder: (context, index) {
                    final id = widget.itemsId[index];
                    final name = widget.itemsName[index];
                    final isChecked = selectedIds.contains(id);
                    return Row(
                      children: [
                        Expanded(
                          child: CheckboxListTile(
                            value: isChecked,
                            title: Text(name),
                            activeColor: AppColors.primaryColor,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                            onChanged: (val) {
                              setState(() {
                                if (val == true) {
                                  if (!selectedIds.contains(id)) {
                                    selectedIds.add(id);
                                    selectedRoles[id] =
                                        selectedRoles[id] ?? 'Father';
                                  }
                                } else {
                                  selectedIds
                                      .removeWhere((element) => element == id);
                                  selectedRoles.remove(id);
                                }
                              });
                            },
                          ),
                        ),
                        if (isChecked)
                          SizedBox(
                            width: 120,
                            child: CustomDropdown(
                              height: 40,
                              value: selectedRoles[id],
                              items: roles,
                              hint: 'Select Role',
                              onChanged: (val) {
                                setState(() {
                                  selectedRoles[id] = val!;
                                });
                              },
                            ),
                          ),
                      ],
                    );
                  },
                ),
              ),
            ),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text('Cancel'),
                ),
                const SizedBox(width: 8),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primaryColor,
                  ),
                  onPressed: () {
                    final selectedIdsAndRoles = selectedIds
                        .map((id) => {
                              'id': id,
                              'name':
                                  widget.itemsName[widget.itemsId.indexOf(id)],
                              'role': selectedRoles[id] ?? 'Father',
                            })
                        .toList();
                    widget.onItemTap(selectedIdsAndRoles);
                    Navigator.pop(context);
                  },
                  child:
                      const Text('OK', style: TextStyle(color: Colors.white)),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
