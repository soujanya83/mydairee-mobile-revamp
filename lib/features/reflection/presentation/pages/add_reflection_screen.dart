import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mydiaree/core/config/app_colors.dart';
import 'package:mydiaree/core/config/app_urls.dart';
import 'package:mydiaree/core/cubit/global_data_cubit.dart';
import 'package:mydiaree/core/cubit/globle_model/children_model.dart';
import 'package:mydiaree/core/cubit/globle_model/educator_model.dart';
import 'package:mydiaree/core/cubit/globle_repository.dart';
import 'package:mydiaree/core/services/apiresoponse.dart';
import 'package:mydiaree/core/utils/ui_helper.dart';
import 'package:mydiaree/core/widgets/custom_app_bar.dart';
import 'package:mydiaree/core/widgets/custom_background_widget.dart';
import 'package:mydiaree/core/widgets/custom_buton.dart';
import 'package:mydiaree/core/widgets/custom_dropdown.dart';
import 'package:mydiaree/core/widgets/custom_multi_selected_dialog.dart';
import 'package:mydiaree/core/widgets/custom_multiline_text_field.dart';
import 'package:mydiaree/core/widgets/custom_scaffold.dart';
import 'package:mydiaree/core/widgets/custom_text_field.dart';
import 'package:mydiaree/core/widgets/dropdowns/room_dropdown.dart';
import 'package:mydiaree/features/program_plan/data/model/children_program_plan_model.dart';
import 'package:mydiaree/features/program_plan/data/model/program_plan_data_model.dart';
import 'package:mydiaree/features/program_plan/data/model/user_add_program_model.dart';
import 'package:mydiaree/features/program_plan/data/repositories/program_plan_repository.dart';
import 'package:mydiaree/features/program_plan/presentation/widget/add_plan_widgets.dart';
import 'package:mydiaree/features/reflection/data/model/reflection_new_model.dart'
    hide Center;
import 'package:mydiaree/features/reflection/data/repositories/reflection_repository.dart';
import 'package:mydiaree/features/reflection/presentation/bloc/add_relection/add_reflection_bloc.dart';
import 'package:mydiaree/features/reflection/presentation/bloc/add_relection/add_reflection_event.dart';
import 'package:mydiaree/features/reflection/presentation/bloc/add_relection/add_reflection_state.dart';
import 'package:file_picker/file_picker.dart';
import 'package:mydiaree/features/room/data/model/room_list_model.dart' hide CenterData;

class AddReflectionScreen extends StatefulWidget {
  final String centerId;
  final String screenType;
  final String? id;

  const AddReflectionScreen({
    super.key,
    required this.centerId,
    this.id,
    required this.screenType,
  });

  @override
  State<AddReflectionScreen> createState() => _AddReflectionScreenState();
}

class _AddReflectionScreenState extends State<AddReflectionScreen> {
  final _formKey = GlobalKey<FormState>();

  bool isLoading = false;

  // Text controllers
  final TextEditingController titleController = TextEditingController();
  final TextEditingController reflectionController = TextEditingController();
  final TextEditingController eylfController = TextEditingController();

  // Selected values
  String? selectedRoomId;
  List<ChildIten> selectedChildren = [];
  List<EducatorItem> selectedEducators = [];
  List<String> selectedMedia = [];
  List<String> selectedEducatorIds = [];
  List<String> selectedEducatorNames = [];
  List<String> selectedChildrenIds = [];
  List<String> selectedChildrenNames = [];

  ReflectionNewModel? reflectionMeta;
  List<Outcome> eylfOutcomes = [];

  List<Media?> editMedia = [];

  @override
  void initState() {
    super.initState();
    _fetchRooms(widget.centerId);
    _fetchReflectionMeta();
  }

  Future<void> _fetchReflectionMeta() async {
    final response =
        await ReflectionRepository().getReflectionDataNew(widget.id ?? '');
    if (response.data != null) {
      setState(() {
        reflectionMeta = response.data;
        eylfOutcomes = reflectionMeta?.data?.outcomes ?? [];
      });
      // Call initialization after data is fetched
      if (widget.screenType == 'edit' && widget.id != null) {
        _initializeFromExistingData();
      }
    }
  }

  void _showEylfSelectionDialog() async {
    await showEylfDialog(
      context,
      reflectionMeta?.data?.outcomes?.map((o) {
        return EylfOutcome(
          id: o.id,
          title: o.title,
          name: o.name,
          addedBy: o.addedBy,
          addedAt: o.addedAt,
          activities: o.activities
              ?.map((a) => EylfOutcomeActivity(
                    id: a.id,
                    outcomeId: a.outcomeId,
                    title: a.title,
                    addedBy: a.addedBy,
                    addedAt: null, // or a.addedAt if compatible
                    choosen: false,
                  ))
              .toList(),
        );
      }).toList(),
      (String selectedActivities) {
        setState(() {
          eylfController.text = selectedActivities;
        });
      },
    );
  }

  void _initializeFromExistingData() async {
    if (widget.id == null || reflectionMeta?.data == null) return;

    final reflection = reflectionMeta!.data!.reflection;
    if (reflection == null) return;

    // Title, About, EYLF
    titleController.text = reflection.title ?? '';
    reflectionController.text = reflection.about ?? '';
    eylfController.text = reflection.eylf ?? '';

    // Room
    selectedRoomId = reflection.roomids;

    // Children
    selectedChildrenIds = reflection.children != null
        ? reflection.children!.map((c) => c.child?.id.toString() ?? '').toList()
        : [];
    selectedChildrenNames = reflection.children != null
        ? reflection.children!.map((c) => c.child?.name ?? '').toList()
        : [];

    // Educators
    selectedEducatorIds = reflection.staff != null
        ? reflection.staff!.map((e) => e.staff?.id?.toString() ?? '').toList()
        : [];
    selectedEducatorNames = reflection.staff != null
        ? reflection.staff!.map((e) => e.staff?.name ?? '').toList()
        : [];

    // Media
   try{
     editMedia = (reflection.media != null && reflection.media is List)
        ? List<Media>.from(reflection.media as List)
        : <Media>[];
   }catch (e) {
     print('Error parsing media: $e');
     editMedia = [];}
    await _fetchChildren(selectedRoomId.toString());
    await _fetchEducators(selectedRoomId.toString());
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
        // ignore: use_build_context_synchronously
        context,
        message: 'Failed to pick media: $e',
        backgroundColor: AppColors.errorColor,
      );
    }
  }

  ApiResponse<ChildrenAddProgramPlanModel?>? childrenData;
  final GlobalRepository repository = GlobalRepository();
  getChildren() async {
    childrenData = await repository.getChildren(widget.centerId);
  }

  RoomListModel? roomListModel;
  UserAddProgramPlanModel? users;
  ChildrenAddProgramPlanModel? childrens;

  Future<void> _fetchRooms(String centerId) async {
    final response = await repository.getRooms(centerId: '1');
    if (response.data != null) {
      setState(() {
        roomListModel = response.data;
      });
    }
  }

  Future<void> _fetchChildren(String roomId) async {
    final response = await repository.getChildren(roomId);
    if (response.data != null) {
      setState(() {
        childrens = response.data;
      });
    }
  }

  Future<void> _fetchEducators(String roomId) async {
    final response = await repository.getEducators(roomId);
    print('Fetching educators for roomId: $roomId');
    print('Educators API response: ${response.data?.users?.length}');
    if (response.data != null) {
      setState(() {
        users = response.data;
      });
    }
  }

  // void _onRoomChanged(RoomListItem room) async {
  //   setState(() {
  //     selectedRoomId = room.id;
  //     selectedChildren = [];
  //     selectedEducators = [];
  //   });
  //   await _fetchChildren(room.id);
  //   await _fetchEducators(room.id);
  // }

  void _showChildrenSelectionDialog() async {
    final children = childrens?.children ?? [];
    await showDialog(
      context: context,
      builder: (context) => CustomMultiSelectDialog(
        itemsId: children.map((c) => c.id.toString()).toList(),
        itemsName: children.map((c) => c.name ?? '').toList(),
        initiallySelectedIds: selectedChildren.map((c) => c.id).toList(),
        title: 'Select Children',
        onItemTap: (selectedIds) {
          setState(() {
            selectedChildren = children
                .where((c) => selectedIds.contains(c.id))
                .map((c) =>
                    ChildIten(id: c.id?.toString() ?? '', name: c.name ?? ''))
                .toList();
          });
        },
      ),
    );
  }

  void _showEducatorDialog() async {
    final educators = users?.users ?? [];
    await showDialog(
      context: context,
      builder: (context) => CustomMultiSelectDialog(
        itemsId: educators.map((e) => e.id?.toString() ?? '').toList(),
        itemsName: educators.map((e) => e.name ?? '').toList(),
        initiallySelectedIds: selectedEducators.map((e) => e.id).toList(),
        title: 'Select Educator',
        onItemTap: (selectedIds) {
          setState(() {
            selectedEducators = educators
                .where((e) => selectedIds.contains(e.id))
                .toList()
                .cast<EducatorItem>();
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

                InkWell(
                    onTap: () {
                      _fetchRooms(widget.centerId);
                    },
                    child: Text('Room',
                        style: Theme.of(context).textTheme.bodyMedium)),
                const SizedBox(height: 6),
                Builder(
                  builder: (context) {
                    final rooms = roomListModel?.rooms ?? [];
                    final roomIds = rooms
                        .where((room) =>
                            room.id != null && int.tryParse(room.id.toString()) != null)
                        .map((room) => int.parse(room.id.toString()))
                        .toSet()
                        .toList();
                    return CustomDropdown<int>(
                      value: (selectedRoomId != null &&
                              int.tryParse(selectedRoomId!) != null)
                          ? int.parse(selectedRoomId!)
                          : null,
                      items: roomIds,
                      hint: 'Select Room',
                      height: 45,
                      displayItem: (id) {
                        final room = rooms.firstWhere(
                          (r) => int.parse(r.id.toString()) == id,
                        );
                        return room.name ?? '';
                      },
                      onChanged: (id) async {
                        setState(() {
                          selectedRoomId = id?.toString();
                          selectedChildren = [];
                          selectedEducators = [];
                        });
                        if (id != null){
                          print('Selected Room ID: $id');
                          selectedChildren = [];
                          selectedEducators = [];
                          selectedChildrenIds = [];
                          selectedChildrenNames = [];
                          selectedEducatorIds = [];
                          selectedEducatorNames = [];
                          await _fetchChildren(id.toString());
                          await _fetchEducators(id.toString());
                        }
                      },
                    );
                  },
                ),

                const SizedBox(height: 16),

                if (selectedRoomId != null) ...[
                  Text('Educators',
                      style: Theme.of(context).textTheme.bodyMedium),
                  const SizedBox(height: 6),
                  Builder(
                    builder: (context) {
                      final educators = users?.users ?? [];
                      if (educators.isEmpty) {
                        return Container(
                          width: 180,
                          height: 38,
                          decoration: BoxDecoration(
                            color: AppColors.primaryColor.withOpacity(0.5),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: const Center(
                            child: Text(
                              'No educators found',
                              style: TextStyle(color: Colors.white),
                            ),
                          ),
                        );
                      }
                      return GestureDetector(
                        onTap: () {
                          showDialog(
                            context: context,
                            builder: (context) => CustomMultiSelectDialog(
                              title: 'Select Educator',
                              itemsId: educators
                                  .map((u) => u.id.toString())
                                  .toList(),
                              itemsName:
                                  educators.map((u) => u.name ?? '').toList(),
                              initiallySelectedIds: selectedEducatorIds,
                              onItemTap: (ids) {
                                setState(() {
                                  selectedEducatorIds = ids;
                                  selectedEducatorNames = educators
                                      .where(
                                          (u) => ids.contains(u.id.toString()))
                                      .map((u) => u.name ?? '')
                                      .toList();
                                });
                              },
                            ),
                          );
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
                              Text('Select Educator',
                                  style: TextStyle(color: Colors.white)),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                  const SizedBox(height: 8),
                  if (selectedEducatorNames.isNotEmpty)
                    Wrap(
                      spacing: 8,
                      children: selectedEducatorNames
                          .map((name) => Chip(label: Text(name)))
                          .toList(),
                    )
                  else
                    const Text('No educators selected',
                        style: TextStyle(color: Colors.grey)),
                  const SizedBox(height: 16),

                  // Children selection
                  Text('Children',
                      style: Theme.of(context).textTheme.bodyMedium),
                  const SizedBox(height: 6),
                  Builder(
                    builder: (context) {
                      final childrenList = childrens?.children ?? [];
                      if (childrenList.isEmpty) {
                        return Container(
                          width: 180,
                          height: 38,
                          decoration: BoxDecoration(
                            color: AppColors.primaryColor.withOpacity(0.5),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: const Center(
                            child: Text(
                              'No children found',
                              style: TextStyle(color: Colors.white),
                            ),
                          ),
                        );
                      }
                      return GestureDetector(
                        onTap: () {
                          showDialog(
                            context: context,
                            builder: (context) => CustomMultiSelectDialog(
                              title: 'Select Children',
                              itemsId: childrenList
                                  .map((c) => c.id.toString())
                                  .toList(),
                              itemsName: childrenList
                                  .map((c) => c.name ?? '')
                                  .toList(),
                              initiallySelectedIds: selectedChildrenIds,
                              onItemTap: (ids) {
                                setState(() {
                                  selectedChildrenIds = ids;
                                  selectedChildrenNames = childrenList
                                      .where(
                                          (c) => ids.contains(c.id.toString()))
                                      .map((c) => c.name ?? '')
                                      .toList();
                                });
                              },
                            ),
                          );
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
                      );
                    },
                  ),
                  const SizedBox(height: 8),
                  if (selectedChildrenNames.isNotEmpty)
                    Wrap(
                      spacing: 8,
                      children: selectedChildrenNames
                          .map((name) => Chip(label: Text(name)))
                          .toList(),
                    )
                  else
                    const Text('No children selected',
                        style: TextStyle(color: Colors.grey)),
                  const SizedBox(height: 16),
                ],

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
                      if (editMedia.isNotEmpty)
                        Padding(
                          padding: const EdgeInsets.only(top: 16),
                          child: GridView.builder(
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                            itemCount: editMedia.length,
                            gridDelegate:
                                const SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 2,
                              crossAxisSpacing: 8,
                              mainAxisSpacing: 8,
                              childAspectRatio: 1,
                            ),
                            itemBuilder: (context, index) {
                              final media = editMedia[index];
                              final isImage = media?.mediaUrl
                                          ?.toLowerCase()
                                          .endsWith('.jpg') ==
                                      true ||
                                  media?.mediaUrl
                                          ?.toLowerCase()
                                          .endsWith('.jpeg') ==
                                      true ||
                                  media?.mediaUrl
                                          ?.toLowerCase()
                                          .endsWith('.png') ==
                                      true;
                              return Stack(
                                children: [
                                  ClipRRect(
                                    borderRadius: BorderRadius.circular(12),
                                    child: isImage
                                        ? Image.network(
                                            AppUrls.baseApiUrl +'/'+ ( media?.mediaUrl ?? ''),
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
                                  // Optionally add a delete button for edit media
                                  Positioned(
                                    top: 4,
                                    right: 4,
                                    child: GestureDetector(
                                      onTap: () async {
                                        final mediaId = editMedia[index]
                                                ?.id
                                                ?.toString() ??
                                            '';
                                        setState(() {
                                          editMedia.removeAt(index);
                                        });

                                        final url =
                                            '${AppUrls.baseApiUrl}/api/reflection/reflection-media';
                                        final data = {
                                          'id': mediaId,
                                        };

                                        final response =
                                            await postAndParse(url, data);

                                        if (response.success) {
                                          UIHelpers.showToast(
                                            context,
                                            message:
                                                'Media deleted successfully',
                                            backgroundColor:
                                                AppColors.successColor,
                                          );
                                        } else {
                                          UIHelpers.showToast(
                                            context,
                                            message: response.message,
                                            backgroundColor:
                                                AppColors.errorColor,
                                          );
                                        }
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
                            isLoading: isLoading,
                            ontap: () async {
                              if (_formKey.currentState!.validate()) {
                                final selectedRoom = selectedRoomId ?? '';
                                final selectedChildren = selectedChildrenIds
                                    .join(','); // e.g. "101,102"
                                final selectedStaff = selectedEducatorIds
                                    .join(','); // e.g. "21,22"
                                final ReflectionRepository repository =
                                    ReflectionRepository();
                                setState(() {
                                  isLoading = true;
                                });
                                try {
                                  final response =
                                      await repository.addReflectionWithFiles(
                                    title: titleController.text,
                                    about: reflectionController.text,
                                    eylf: eylfController.text,
                                    selectedRoom: selectedRoom,
                                    selectedChildren: selectedChildren,
                                    selectedStaff: selectedStaff,
                                    centerId: widget.centerId,
                                    files:
                                        selectedMedia, // List<String> of file paths
                                    id: widget.screenType == 'edit'
                                        ? widget.id
                                        : null,
                                  );

                                  UIHelpers.showToast(
                                    context,
                                    message: response.message,
                                    backgroundColor: response.success
                                        ? AppColors.successColor
                                        : AppColors.errorColor,
                                  );
                                  // Optionally unset loading state here
                                  if (response.success) {
                                    // Optionally trigger a bloc event if needed
                                    Navigator.pop(context);
                                  }
                                } catch (e) {
                                  UIHelpers.showToast(
                                    context,
                                    message: 'Failed to submit reflection: $e',
                                    backgroundColor: AppColors.errorColor,
                                  );
                                  // Optionally unset loading state here
                                }
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
