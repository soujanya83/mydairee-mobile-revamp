import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mydiaree/core/config/app_colors.dart';
import 'package:mydiaree/core/cubit/global_data_cubit.dart';
import 'package:mydiaree/core/cubit/globle_model/children_model.dart';
import 'package:mydiaree/core/cubit/globle_repository.dart';
import 'package:mydiaree/core/services/apiresoponse.dart';
import 'package:mydiaree/core/utils/ui_helper.dart';
import 'package:mydiaree/core/widgets/custom_app_bar.dart';
import 'package:mydiaree/core/widgets/custom_background_widget.dart';
import 'package:mydiaree/core/widgets/custom_buton.dart';
import 'package:mydiaree/core/widgets/custom_multi_selected_dialog.dart';
import 'package:mydiaree/core/widgets/custom_multiline_text_field.dart';
import 'package:mydiaree/core/widgets/custom_text_field.dart';
import 'package:mydiaree/core/widgets/custom_scaffold.dart';
import 'package:mydiaree/core/widgets/dropdowns/room_dropdown.dart';
import 'package:mydiaree/features/snapshot/presentation/bloc/add_snapshot/add_snapshot_bloc.dart';
import 'package:mydiaree/features/snapshot/presentation/bloc/add_snapshot/add_snapshot_event.dart';
import 'package:mydiaree/features/snapshot/presentation/bloc/add_snapshot/add_snapshot_state.dart';
import 'package:file_picker/file_picker.dart';

class AddSnapshotScreen extends StatefulWidget {
  final String centerId;
  final Map<String, dynamic>? snapshot;
  final String screenType;
  final String? id;

  const AddSnapshotScreen({
    super.key,
    required this.centerId,
    this.id,
    this.snapshot,
    required this.screenType,
  });

  @override
  State<AddSnapshotScreen> createState() => _AddSnapshotScreenState();
}

class _AddSnapshotScreenState extends State<AddSnapshotScreen> {
  final _formKey = GlobalKey<FormState>();

  // Text controllers
  final TextEditingController titleController = TextEditingController();
  final TextEditingController detailsController = TextEditingController();

  // Selected values
  String? selectedRoomId;
  List<ChildIten> selectedChildren = [];
  List<Map<String, dynamic>> selectedMedia =
      []; // {path: String, type: 'file'|'network'}

  @override
  void initState() {
    super.initState();
    if (widget.screenType == 'edit' && widget.snapshot != null) {
      _initializeFromExistingData();
    }
  }

  void _initializeFromExistingData() {
    final data = widget.snapshot!;
    titleController.text = data['title'] ?? '';
    detailsController.text = data['about'] ?? '';
    selectedRoomId = data['room_id'];
    if (data['children'] is List) {
      selectedChildren = List<ChildIten>.from(data['children']
          .map((c) => ChildIten(id: c['id'] ?? '', name: c['name'] ?? '')));
    }
    if (data['images'] is List) {
      selectedMedia = List<String>.from(data['images'])
          .map((path) => {'path': path, 'type': 'network'})
          .toList();
    }
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
        final files =
            result.files.map((f) => {'path': f.path!, 'type': 'file'}).toList();

        // Limit to 10 files
        final newMedia = [
          ...selectedMedia,
          ...files
              .where((f) => !selectedMedia.any((m) => m['path'] == f['path'])),
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

  ApiResponse<ChildModel?>? childrenData;
  final GlobalRepository repository = GlobalRepository();
  getChildren() async {
    // childrenData = await repository.getChildren(widget.centerId);
  }

  void _showChildrenSelectionDialog() async {
    final children = childrenData?.data?.data ?? [];
    await showDialog<List<String>>(
      context: context,
      builder: (context) => CustomMultiSelectDialog(
        itemsId: children.map((child) => child.id ?? '').toList(),
        itemsName: children.map((child) => child.name ?? '').toList(),
        initiallySelectedIds:
            selectedChildren.map((child) => child?.id ?? '').toList(),
        title: 'Select Children',
        onItemTap: (selectedIds) {
          setState(() {
            selectedChildren = children
                .where((child) => selectedIds.contains(child.id))
                .toList();
          });
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return CustomScaffold(
      appBar: const CustomAppBar(title: 'Create Snapshot'),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Snapshot Details',
                  style: Theme.of(context).textTheme.headlineSmall,
                ),
                const SizedBox(height: 16),

                // Title
                CustomTextFormWidget(
                  title: 'Snapshot Title',
                  controller: titleController,
                ),
                const SizedBox(height: 16),

                // Details
                CustomMultilineTextField(
                  title: 'Snapshot Details',
                  readOnly: false,
                  context: context,
                  controller: detailsController,
                  maxLines: 5,
                  onTap: () {},
                ),
                const SizedBox(height: 16),

                // Room selection
                Text('Room', style: Theme.of(context).textTheme.bodyMedium),
                const SizedBox(height: 6),
                // RoomDropdown(
                //   selectedRoomId: selectedRoomId,
                //   onChanged: (room) {
                //     setState(() {
                //       selectedRoomId = room.id;
                //     });
                //   },
                // ),
                const SizedBox(height: 16),

                // Children selection
                Text('Children', style: Theme.of(context).textTheme.bodyMedium),
                const SizedBox(height: 6),
                GestureDetector(
                  onTap: (){
                    _showChildrenSelectionDialog();
                  },
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

                // Media Upload
                Text('Media Upload',
                    style: Theme.of(context).textTheme.titleSmall),
                const SizedBox(height: 16),
                PatternBackground(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Network Images (only in edit mode)
                      if (widget.screenType == 'edit' &&
                          selectedMedia.any((m) => m['type'] == 'network'))
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Already Saved Images',
                              style: Theme.of(context).textTheme.titleSmall,
                            ),
                            const SizedBox(height: 8),
                            GridView.builder(
                              shrinkWrap: true,
                              physics: const NeverScrollableScrollPhysics(),
                              itemCount: selectedMedia
                                  .where((m) => m['type'] == 'network')
                                  .length,
                              gridDelegate:
                                  const SliverGridDelegateWithFixedCrossAxisCount(
                                crossAxisCount: 2,
                                crossAxisSpacing: 8,
                                mainAxisSpacing: 8,
                                childAspectRatio: 1,
                              ),
                              itemBuilder: (context, index) {
                                final media = selectedMedia
                                    .where((m) => m['type'] == 'network')
                                    .toList()[index];
                                final isImage = media['path']
                                        .toLowerCase()
                                        .endsWith('.jpg') ||
                                    media['path']
                                        .toLowerCase()
                                        .endsWith('.jpeg') ||
                                    media['path']
                                        .toLowerCase()
                                        .endsWith('.png');
                                return Stack(
                                  children: [
                                    ClipRRect(
                                      borderRadius: BorderRadius.circular(12),
                                      child: isImage
                                          ? Image.network(
                                              media['path'],
                                              width: double.infinity,
                                              height: double.infinity,
                                              fit: BoxFit.cover,
                                              errorBuilder: (context, error,
                                                      stackTrace) =>
                                                  Container(
                                                color: Colors.black12,
                                                child: const Center(
                                                  child: Icon(
                                                    Icons.broken_image,
                                                    color: Colors.grey,
                                                    size: 48,
                                                  ),
                                                ),
                                              ),
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
                                            selectedMedia.remove(media);
                                          });
                                        },
                                        child: Container(
                                          decoration: const BoxDecoration(
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
                            const SizedBox(height: 16),
                          ],
                        ),

                      // File Picker
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

                      // Local Files
                      if (selectedMedia.any((m) => m['type'] == 'file'))
                        Padding(
                          padding: const EdgeInsets.only(top: 16),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Selected Files',
                                style: Theme.of(context).textTheme.titleSmall,
                              ),
                              const SizedBox(height: 8),
                              GridView.builder(
                                shrinkWrap: true,
                                physics: const NeverScrollableScrollPhysics(),
                                itemCount: selectedMedia
                                    .where((m) => m['type'] == 'file')
                                    .length,
                                gridDelegate:
                                    const SliverGridDelegateWithFixedCrossAxisCount(
                                  crossAxisCount: 2,
                                  crossAxisSpacing: 8,
                                  mainAxisSpacing: 8,
                                  childAspectRatio: 1,
                                ),
                                itemBuilder: (context, index) {
                                  final media = selectedMedia
                                      .where((m) => m['type'] == 'file')
                                      .toList()[index];
                                  final isImage = media['path']
                                          .toLowerCase()
                                          .endsWith('.jpg') ||
                                      media['path']
                                          .toLowerCase()
                                          .endsWith('.jpeg') ||
                                      media['path']
                                          .toLowerCase()
                                          .endsWith('.png');
                                  return Stack(
                                    children: [
                                      ClipRRect(
                                        borderRadius: BorderRadius.circular(12),
                                        child: isImage
                                            ? Image.file(
                                                File(media['path']),
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
                                              selectedMedia.remove(media);
                                            });
                                          },
                                          child: Container(
                                            decoration: const BoxDecoration(
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
                            ],
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
                    BlocListener<AddSnapshotBloc, AddSnapshotState>(
                      listener: (context, state) {
                        if (state is AddSnapshotFailure) {
                          UIHelpers.showToast(
                            context,
                            message: state.message,
                            backgroundColor: AppColors.errorColor,
                          );
                        } else if (state is AddSnapshotSuccess) {
                          UIHelpers.showToast(
                            context,
                            message: state.message,
                            backgroundColor: AppColors.successColor,
                          );
                          Navigator.pop(context);
                        }
                      },
                      child: BlocBuilder<AddSnapshotBloc, AddSnapshotState>(
                        builder: (context, state) {
                          return CustomButton(
                            height: 45,
                            width: 100,
                            text: 'SUBMIT',
                            isLoading: state is AddSnapshotLoading,
                            ontap: () {
                              if (_formKey.currentState!.validate()) {
                                context.read<AddSnapshotBloc>().add(
                                      SubmitAddSnapshotEvent(
                                        snapshotId: widget.screenType == 'edit'
                                            ? widget.id
                                            : null,
                                        title: titleController.text,
                                        about: detailsController.text,
                                        roomId: selectedRoomId ?? '',
                                        children: selectedChildren
                                            .map((c) => c.id)
                                            .toList(),
                                        media: selectedMedia
                                            .map((m) => m['path'] as String)
                                            .toList(),
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
    detailsController.dispose();
    super.dispose();
  }
}
