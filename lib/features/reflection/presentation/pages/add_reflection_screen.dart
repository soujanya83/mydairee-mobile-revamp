import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mydiaree/core/config/app_colors.dart';
import 'package:mydiaree/core/cubit/global_data_cubit.dart';
import 'package:mydiaree/core/cubit/globle_model/children_model.dart';
import 'package:mydiaree/core/cubit/globle_model/educator_model.dart';
import 'package:mydiaree/core/utils/ui_helper.dart';
import 'package:mydiaree/core/widgets/custom_app_bar.dart';
import 'package:mydiaree/core/widgets/custom_background_widget.dart';
import 'package:mydiaree/core/widgets/custom_buton.dart';
import 'package:mydiaree/core/widgets/custom_multi_selected_dialog.dart';
import 'package:mydiaree/core/widgets/custom_multiline_text_field.dart';
import 'package:mydiaree/core/widgets/custom_scaffold.dart';
import 'package:mydiaree/core/widgets/custom_text_field.dart';
import 'package:mydiaree/core/widgets/dropdowns/room_dropdown.dart';
import 'package:mydiaree/features/program_plan/presentation/widget/add_plan_widgets.dart';
import 'package:mydiaree/features/reflection/presentation/bloc/add_relection/add_reflection_bloc.dart';
import 'package:mydiaree/features/reflection/presentation/bloc/add_relection/add_reflection_event.dart';
import 'package:mydiaree/features/reflection/presentation/bloc/add_relection/add_reflection_state.dart';
import 'package:file_picker/file_picker.dart';

class AddReflectionScreen extends StatefulWidget {
  final String centerId;
  final Map<String, dynamic>? reflection;
  final String screenType;
  final String? id;

  const AddReflectionScreen({
    super.key,
    required this.centerId,
    this.id,
    this.reflection,
    required this.screenType,
  });

  @override
  State<AddReflectionScreen> createState() => _AddReflectionScreenState();
}

class _AddReflectionScreenState extends State<AddReflectionScreen> {
  final _formKey = GlobalKey<FormState>();

  // Text controllers
  final TextEditingController titleController = TextEditingController();
  final TextEditingController reflectionController = TextEditingController();
  final TextEditingController eylfController = TextEditingController();

  // Selected values
  String? selectedRoomId;
  List<ChildIten> selectedChildren = [];
  List<EducatorItem> selectedEducators = [];
  List<String> selectedMedia = [];

  @override
  void initState() {
    super.initState();
    if (widget.screenType == 'edit' && widget.reflection != null) {
      _initializeFromExistingData();
    }
  }

  void _initializeFromExistingData() {
    final data = widget.reflection!;
    titleController.text = data['title'] ?? '';
    reflectionController.text = data['about'] ?? '';
    eylfController.text = data['eylf'] ?? '';
    selectedRoomId = data['room_id'];
    if (data['children'] is List) {
      selectedChildren = List<ChildIten>.from(data['children']
          .map((c) => ChildIten(id: c['id'] ?? '', name: c['name'] ?? '')));
    }
    if (data['educators'] is List) {
      selectedEducators =
          List<EducatorItem>.from(data['educators'].map((e) => e['name']));
    }
    if (data['images'] is List) {
      selectedMedia = List<String>.from(data['images']);
    }
  }

  void _showRoomSelectionDialog() {
    // TODO: Implement room selection dialog
    // Can use RoomDropdown widget directly
  }

  // assignPracticalLifeInController(){
  //   print('assigning here');
  //   eylfController.text = '';
  //   print(
  //       '======================PracticalLifeController===========================');
  //   for (int parentIndex = 0;
  //       parentIndex < (practicalLifeData?.activity.length ?? 0);
  //       parentIndex++) {
  //     String activity = practicalLifeData?.activity[parentIndex].title ?? '';
  //     bool isDone = false;
  //     print(
  //         '====================*******i*****=$parentIndex============================');
  //     for (int childIndex = 0;
  //         childIndex <
  //             (practicalLifeData?.activity[parentIndex].subActivity.length ??
  //                 0);
  //         childIndex++) {
  //       print(
  //           '====================##########j##########=$childIndex===($parentIndex)=========================');
  //       print(
  //           '======value=${practicalLifeData?.activity[parentIndex].subActivity[childIndex].choosen ?? false}==========');

  //       if (practicalLifeData
  //               ?.activity[parentIndex].subActivity[childIndex].choosen ??
  //           false) {
  //         if (!isDone) {
  //           eylfController.text += '**$activity** - \n';
  //           isDone = true;
  //         }

  //         String subActivity = practicalLifeData
  //                 ?.activity[parentIndex].subActivity[childIndex].title ??
  //             '';
  //         print('===================00eir0ir0====================');
  //         eylfController.text += '**• **$subActivity.\n';
  //       }
  //     }
  //   }
  //   Future.delayed(Duration(seconds: 3), () {
  //     print('text file is the ===========');
  //     print(eylfController.text);
  //   });
  // }

  void _showEylfSelectionDialog(){
    // assignPracticalLifeData();
    // showPracticalLifeDialog(
    //     context, practicalLifeData, assignPracticalLifeInController);
  }

  Future<void> _pickMedia() async {
    try {
      final result = await FilePicker.platform.pickFiles(
        allowMultiple: true,
        type: FileType.custom,
        allowedExtensions: ['jpg', 'jpeg', 'png', 'mp4', 'mov', 'avi'],
        withData: false,
      );

      if (result != null && result.files.isNotEmpty) {
        final files = result.files.map((f) => f.path!).toList();

        // Limit to 10 files
        final newMedia = [
          ...selectedMedia,
          ...files.where((f) => !selectedMedia.contains(f))
        ].take(10).toList();

        setState(() {
          selectedMedia = newMedia;
        });
      }
    } catch (e) {
      UIHelpers.showToast(
        context,
        message: 'Failed to pick media: $e',
        backgroundColor: AppColors.errorColor,
      );
    }
  }

  void _showChildrenSelectionDialog() async {
    final globalState = context.read<GlobalDataCubit>().state;
    await showDialog<List<String>>(
      context: context,
      builder: (context) => CustomMultiSelectDialog(
        itemsId: List.generate(
          globalState.childrenData?.data.length ?? 0,
          (index) {
            return globalState.childrenData?.data[index].id ?? '';
          },
        ),
        itemsName: List.generate(
          globalState.childrenData?.data.length ?? 0,
          (index) {
            return globalState.childrenData?.data[index].name ?? '';
          },
        ),
        initiallySelectedIds: List.generate(selectedChildren.length, (index) {
          final child = globalState.childrenData?.data.firstWhere(
            (c) => c.name == selectedChildren[index].name,
            orElse: () {
              return ChildIten(id: '', name: '');
            },
          );
          return child?.id ?? '';
        }),
        title: 'Select Children',
        onItemTap: (selectedIds) {
          setState(() {
            final children = globalState.childrenData?.data ?? [];
            selectedChildren =
                children.where((c) => selectedIds.contains(c.id)).toList();
          });
        },
      ),
    );
  }

  void _showEducatorDialog() async {
    final globalState = context.read<GlobalDataCubit>().state;
    await showDialog<List<Map<String, String>>>(
      context: context,
      builder: (context) => CustomMultiSelectDialog(
        itemsId: List.generate(
          globalState.educatorsData?.educators.length ?? 0,
          (index) {
            return globalState.educatorsData?.educators[index].id ?? '';
          },
        ),
        itemsName: List.generate(
          globalState.educatorsData?.educators.length ?? 0,
          (index) {
            return globalState.educatorsData?.educators[index].name ?? '';
          },
        ),
        initiallySelectedIds: List.generate(selectedEducators.length, (index) {
          return selectedEducators[index]?.id ?? '';
        }),
        title: 'Select Educator',
        onItemTap: (selectedIds) {
          setState(() {
            final educators = globalState.educatorsData?.educators ?? [];
            selectedEducators =
                educators.where((e) => selectedIds.contains(e.id)).toList();
          });
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return CustomScaffold(
      appBar: const CustomAppBar(title: 'Create Reflection'),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Reflection Details',
                  style: Theme.of(context).textTheme.headlineSmall,
                ),
                const SizedBox(height: 16),

                // Title
                CustomTextFormWidget(
                  title: 'Title',
                  controller: titleController,
                ),
                const SizedBox(height: 16),

                // Reflection
                CustomMultilineTextField(
                  title: 'Reflection',
                  readOnly: false,
                  context: context,
                  controller: reflectionController,
                  maxLines: 5,
                  onTap: () {},
                ),
                const SizedBox(height: 16),

                // EYLF
                CustomMultilineTextField(
                  title: 'EYLF',
                  context: context,
                  controller: eylfController,
                  onTap: _showEylfSelectionDialog,
                ),
                const SizedBox(height: 16),

                // Room selection
                Text('Room', style: Theme.of(context).textTheme.bodyMedium),
                const SizedBox(height: 6),
                RoomDropdown(
                  selectedRoomId: selectedRoomId,
                  onChanged: (room) {
                    setState(() {
                      selectedRoomId = room.id;
                    });
                  },
                ),
                const SizedBox(height: 16),

                // Children selection
                Text('Children', style: Theme.of(context).textTheme.bodyMedium),
                const SizedBox(height: 6),
                GestureDetector(
                  onTap: _showChildrenSelectionDialog,
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
                if (selectedChildren.isNotEmpty)
                  Wrap(
                    spacing: 8,
                    children: selectedChildren
                        .map((child) => Chip(
                              label: Text(child.name),
                              onDeleted: () {
                                setState(() {
                                  selectedChildren.remove(child);
                                });
                              },
                            ))
                        .toList(),
                  ),
                const SizedBox(height: 16),

                // Educators selection
                Text('Educators',
                    style: Theme.of(context).textTheme.bodyMedium),
                const SizedBox(height: 6),
                GestureDetector(
                  onTap: _showEducatorDialog,
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
                        Text('Select Staff',
                            style: TextStyle(color: Colors.white)),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 10),
                if (selectedEducators.isNotEmpty)
                  Wrap(
                    spacing: 8,
                    children: selectedEducators
                        .map((edu) => Chip(
                              label: Text(edu.name),
                              onDeleted: () {
                                setState(() {
                                  selectedEducators.remove(edu);
                                });
                              },
                            ))
                        .toList(),
                  ),
                const SizedBox(height: 16),

                // Media Upload
                Text('Media Upload',
                    style: Theme.of(context).textTheme.titleSmall),
                const SizedBox(height: 16),
                PatternBackground(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Select Image/Video Button inside a border box
                      GestureDetector(
                        onTap: _pickMedia,
                        child: Container(
                          width: double.infinity,
                          height: 48,
                          decoration: BoxDecoration(
                            border: Border.all(
                                color: AppColors.primaryColor, width: 1.5),
                            borderRadius: BorderRadius.circular(8),
                            color: Colors.white,
                          ),
                          child: const Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(Icons.add_a_photo, color: Colors.black54),
                              SizedBox(width: 8),
                              Text(
                                'Select up to 10 Images/Videos',
                                style: TextStyle(
                                  color: Colors.black87,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(height: 8),
                      const Text(
                        'Only images and videos are allowed. Max 10 files.',
                        style: TextStyle(color: Colors.grey, fontSize: 12),
                      ),
                      // Show selected items below the border box
                      if (selectedMedia.isNotEmpty)
                        Padding(
                          padding: const EdgeInsets.only(top: 16),
                          child: GridView.builder(
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                            itemCount: selectedMedia.length,
                            gridDelegate:
                                const SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 2,
                              crossAxisSpacing: 8,
                              mainAxisSpacing: 8,
                              childAspectRatio: 1,
                            ),
                            itemBuilder: (context, index) {
                              final media = selectedMedia[index];
                              final isImage =
                                  media.toLowerCase().endsWith('.jpg') ||
                                      media.toLowerCase().endsWith('.jpeg') ||
                                      media.toLowerCase().endsWith('.png');
                              return Stack(
                                children: [
                                  ClipRRect(
                                    borderRadius: BorderRadius.circular(12),
                                    child: isImage
                                        ? Image.file(
                                            File(media),
                                            width: double.infinity,
                                            height: double.infinity,
                                            fit: BoxFit.cover,
                                          )
                                        : Container(
                                            color: Colors.black12,
                                            child: Center(
                                              child: Icon(
                                                Icons.videocam,
                                                color: Colors.grey[700],
                                                size: 48,
                                              ),
                                            ),
                                          ),
                                  ),
                                  Positioned(
                                    top: 4,
                                    right: 4,
                                    child: GestureDetector(
                                      onTap: () {
                                        setState(() {
                                          selectedMedia.removeAt(index);
                                        });
                                      },
                                      child: Container(
                                        decoration: BoxDecoration(
                                          color: Colors.black54,
                                          shape: BoxShape.circle,
                                        ),
                                        padding: const EdgeInsets.all(4),
                                        child: const Icon(
                                          Icons.close,
                                          color: Colors.white,
                                          size: 18,
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              );
                            },
                          ),
                        ),
                    ],
                  ),
                ),
                const SizedBox(height: 16),

                // Submit Button
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    OutlinedButton(
                      onPressed: () => Navigator.pop(context),
                      child: const Text('CANCEL',
                          style: TextStyle(color: Colors.black)),
                    ),
                    const SizedBox(width: 16),
                    BlocListener<AddReflectionBloc, AddReflectionState>(
                      listener: (context, state) {
                        if (state is AddReflectionFailure) {
                          UIHelpers.showToast(
                            context,
                            message: state.message,
                            backgroundColor: AppColors.errorColor,
                          );
                        } else if (state is AddReflectionSuccess) {
                          UIHelpers.showToast(
                            context,
                            message: state.message,
                            backgroundColor: AppColors.successColor,
                          );
                          Navigator.pop(context);
                        }
                      },
                      child: BlocBuilder<AddReflectionBloc, AddReflectionState>(
                        builder: (context, state) {
                          return CustomButton(
                            height: 45,
                            width: 100,
                            text: 'SUBMIT',
                            isLoading: state is AddReflectionLoading,
                            ontap: () {
                              if (_formKey.currentState!.validate()) {
                                context.read<AddReflectionBloc>().add(
                                      SubmitAddReflectionEvent(
                                        reflectionId:
                                            widget.screenType == 'edit'
                                                ? widget.id
                                                : null,
                                        title: titleController.text,
                                        about: reflectionController.text,
                                        eylf: eylfController.text,
                                        roomId: selectedRoomId ?? '',
                                        children: selectedChildren
                                            .map((c) => c.id)
                                            .toList(),
                                        educators: selectedEducators
                                            .map((e) => e.id)
                                            .toList(),
                                        media: selectedMedia,
                                      ),
                                    );
                              }
                            },
                          );
                        },
                      ),
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
    titleController.dispose();
    reflectionController.dispose();
    eylfController.dispose();
    super.dispose();
  }
}
