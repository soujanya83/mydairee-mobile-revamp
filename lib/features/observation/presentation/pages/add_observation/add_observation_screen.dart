import 'package:flutter/material.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:mydiaree/core/utils/ui_helper.dart';
import 'package:mydiaree/core/widgets/custom_buton.dart';
import 'package:mydiaree/features/observation/presentation/pages/add_observation/add_observation_child_screens/add_observation_links.dart';
import 'package:mydiaree/features/observation/presentation/pages/add_observation/add_observation_child_screens/add_observation_assessment_screen.dart';
import 'package:reorderable_grid_view/reorderable_grid_view.dart';
import 'package:file_picker/file_picker.dart';
import 'dart:io';
import 'package:mydiaree/core/config/app_colors.dart';
import 'package:mydiaree/core/widgets/custom_app_bar.dart';
import 'package:mydiaree/core/widgets/custom_scaffold.dart';
import 'package:mydiaree/core/widgets/custom_text_field.dart';
import 'package:mydiaree/core/widgets/custom_multi_selected_dialog.dart';
import 'package:mydiaree/features/observation/data/repositories/observation_repositories.dart';
import 'package:mydiaree/features/observation/data/model/add_new_observation_response.dart'
    hide Center;
import 'package:mydiaree/core/services/apiresoponse.dart';
import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:mydiaree/core/services/api_services.dart';
import 'package:mydiaree/core/config/app_urls.dart';

String observationIdAfterSave = '';

class AddObservationScreen extends StatefulWidget {
  final String type;
  final String centerId;
  final String? id;

  const AddObservationScreen({
    super.key,
    required this.type,
    required this.centerId,
    this.id,
  });

  @override
  AddObservationScreenState createState() => AddObservationScreenState();
}

class AddObservationScreenState extends State<AddObservationScreen>
    with TickerProviderStateMixin {
  TabController? _controller;
  double mediaHeight = 0;
  bool _addCompleted = false;

  late ObservationRepository _observationRepository;
  bool isLoading = false;
  bool isSaving = false;
  AddNewObservationData? observationData;
  String currentTab = "observation";
  String currentSubTab = "MONTESSORI";

  static List<ChildModel> selectedChildren = [];
  static List<RoomsModel> selectedRooms = [];
  static List<File> files = [];
  static List<TextEditingController> captions = [];

  static TextEditingController titleController = TextEditingController();
  static TextEditingController observationController = TextEditingController();
  static TextEditingController analysisController = TextEditingController();
  static TextEditingController reflectionController = TextEditingController();
  static TextEditingController childVoiceController = TextEditingController();
  static TextEditingController futurePlanController = TextEditingController();

  final List<ChildModel> _allChildren = [];
  final List<RoomsModel> _allRooms = [];

  List<Media> selectedMedia = [];
  bool isDeletingMedia = false;

  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    _controller = TabController(length: 3, vsync: this);
    if (widget.type == 'edit') {
      observationIdAfterSave = widget.id ?? '';
    }
    _observationRepository = ObservationRepository();
    selectedChildren.clear();
    selectedRooms.clear();
    _loadObservationData();
    _fetchRoomsAndChildren();
    _controller!.addListener(() {
      if (!_controller!.indexIsChanging) {
        if (_addCompleted && _controller!.index == 0) {
          _controller!.animateTo(1);
          return;
        }
        _updateTabInfo();
      }
    });
  }

  Future<void> _fetchRoomsAndChildren() async {
    try {
      // Fetch children
      final childrenResp =
          await _observationRepository.getChildrenByCenterId(widget.centerId);
      if (childrenResp.success &&
          childrenResp.data != null &&
          childrenResp.data['children'] != null){
        _allChildren.clear();
        for (var child in childrenResp.data['children']) {
          _allChildren.add(ChildModel(
            childId: child['id'].toString(),
            name: '${child['name'] ?? ''} ${child['lastname'] ?? ''}',
            imageUrl: child['imageUrl'] ?? '',
          ));
        }
      } else {
        print('Failed to load children: ${childrenResp.message}');
      }
    } catch (e) {
      print('Error loading children: $e');
    } finally {
      if (this.mounted) setState(() {});
    }

    try {
      // Fetch rooms
      final roomsResp =
          await _observationRepository.getRoomsByCenterId(widget.centerId);
      if (roomsResp.success &&
          roomsResp.data != null &&
          roomsResp.data['rooms'] != null) {
        _allRooms.clear();
        for (var room in roomsResp.data['rooms']) {
          _allRooms.add(RoomsModel(
            room: RoomsDescModel(
              id: room['id'].toString(),
              name: room['name'] ?? '',
            ),
            child: [],
          ));
        }
      } else {
        print('Failed to load rooms: ${roomsResp.message}');
      }
    } catch (e) {
      print('Error loading rooms: $e');
    } finally {
      if (this.mounted) setState(() {});
    }
  }

  Future<void> _loadObservationData() async {
    setState(() {
      isLoading = true;
    });

    try {
      final response = await _observationRepository.getAddNewObservation(
        observationId: widget.id,
        tab: '1',
        tab2: '1',
        centerId: widget.centerId,
      );
      if (response.success && response.data != null) {
        setState(() {
          observationData = response.data!.data;
          _populateFormFields();
          initializeMediaFromObservation();
        });
      } else {
        print('Error loading data: ${response.message}');
      }
    } catch (e) {
      print('Exception when loading data: $e');
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  void initializeMediaFromObservation() {
    if (observationData != null && observationData!.observation.id > 0) {
      if (observationData!.observation.media.isNotEmpty) {
        setState(() {
          selectedMedia = List.from(observationData!.observation.media);
        });
      }
    }
  }

  void _updateTabInfo() {
    String tab = "observation";
    String subTab = "MONTESSORI";

    switch (_controller!.index) {
      case 0:
        tab = "observation";
        break;
      case 1:
        tab = "assessments";
        if (currentSubTab == "MONTESSORI" ||
            currentSubTab == "EYLF" ||
            currentSubTab == "DEVELOPMENTAL MILESTONE") {
          subTab = currentSubTab;
        }
        break;
      case 2:
        tab = "links";
        break;
    }

    if (tab != currentTab || subTab != currentSubTab) {
      setState(() {
        currentTab = tab;
        currentSubTab = subTab;
      });
      _loadObservationData();
    }
  }

  String stripHtmlTags(String htmlString) {
    // Decode HTML entities and remove HTML tags
    final decoded = htmlString
        .replaceAll('&lt;', '<')
        .replaceAll('&gt;', '>')
        .replaceAll('&amp;', '&')
        .replaceAll('&quot;', '"')
        .replaceAll('&#39;', "'");
    return decoded
        .replaceAll(RegExp(r'<[^>]*>'), '')
        .replaceAll('\n', ' ')
        .trim();
  }

  void _populateFormFields() {
    // print('===============');
    // print(observationData!.observation.id);
    // print('-------------');return;
  

    if (observationData != null && observationData!.observation.id > 0) {
      titleController.text = stripHtmlTags(observationData!.observation.title);
      observationController.text =
          stripHtmlTags(observationData!.observation.obestitle);
      analysisController.text =
          stripHtmlTags(observationData!.observation.notes);
      reflectionController.text =
          stripHtmlTags(observationData!.observation.reflection);
      childVoiceController.text =
          stripHtmlTags(observationData!.observation.childVoice);
      futurePlanController.text =
          stripHtmlTags(observationData!.observation.futurePlan);

      selectedChildren.clear();
      for (var childObs in observationData!.observation.child) {
        selectedChildren.add(ChildModel(
          childId: childObs.childId.toString(),
          name: '${childObs.child.name} ${childObs.child.lastname}',
          imageUrl: childObs.child.imageUrl,
        ));
      }

      selectedRooms.clear();
      // Handle observationData!.observation.room which can be like "[1797944727]" or "1797944727,1797944728"
      selectedRooms.clear();
      try {
        String roomStr = observationData!.observation.room;
        print('Raw room string: $roomStr');
        // Remove brackets if present
        roomStr = roomStr.replaceAll('[', '').replaceAll(']', '');
        print('Room string after removing brackets: $roomStr');
        if (roomStr.isNotEmpty) {
          final roomIds = roomStr.split(',');
          print('Parsed room IDs: $roomIds');
          for (String roomId in roomIds) {
        // Remove any surrounding quotes from the room ID
        final trimmedId = roomId.trim().replaceAll('"', '');
        if (trimmedId.isEmpty) continue;
        for (var room in _allRooms) {
          if (room.room.id == trimmedId) {
            selectedRooms.add(room);
            break;
          }
        }
          }
        }
      } catch (e) {
        print('Error parsing room ids: $e');
      }
    }
  }

  void _showChildrenDialog() async {
    await showDialog<List<Map<String, String>>>(
      context: context,
      builder: (context) => CustomMultiSelectDialog(
        itemsId: _allChildren.map((child) => child.childId!).toList(),
        itemsName: _allChildren.map((child) => child.name).toList(),
        initiallySelectedIds:
            selectedChildren.map((child) => child.childId!).toList(),
        title: 'Select Children',
        onItemTap: (selectedIds) {
          setState(() {
            selectedChildren = _allChildren
                .where((child) => selectedIds.contains(child.childId))
                .toList();
          });
        },
      ),
    );
  }

  void _showRoomDialog() async {
    await showDialog<List<Map<String, String>>>(
      context: context,
      builder: (context) => CustomMultiSelectDialog(
        itemsId: _allRooms.map((room) => room.room.id).toList(),
        itemsName: _allRooms.map((room) => room.room.name).toList(),
        initiallySelectedIds:
            selectedRooms.map((room) => room.room.id).toList(),
        title: 'Select Rooms',
        onItemTap: (selectedIds) {
          setState(() {
            selectedRooms = _allRooms
                .where((room) => selectedIds.contains(room.room.id))
                .toList();
          });
        },
      ),
    );
  }

  Widget rectBorderWidget(Size size, BuildContext context) {
    return DottedBorder(
      child: Container(
        width: 100,
        height: 100,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Icon(Icons.add, color: AppColors.primaryColor),
            Text('Upload', style: Theme.of(context).textTheme.bodyMedium),
          ],
        ),
      ),
    );
  }

  Future<void> deleteMedia(int mediaId) async {
    setState(() {
      isDeletingMedia = true;
    });

    try {
      final response = await _observationRepository.deleteObservationMedia(
        mediaId: mediaId,
      );

      if (response.success) {
        setState(() {
          selectedMedia.removeWhere((media) => media.id == mediaId);
        });
        UIHelpers.showToast(context, message: 'Media deleted successfully');
      } else {
        UIHelpers.showToast(context, message: 'Failed to delete media');
        print('Failed to delete media: ${response.message}');
      }
    } catch (e) {
      print('Error deleting media: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error deleting media: $e'),
          backgroundColor: Colors.red,
        ),
      );
    } finally {
      setState(() {
        isDeletingMedia = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return CustomScaffold(
      appBar: CustomAppBar(
        title: 'Add Observation',
        toolbarHeight: 50,
        bottom: PreferredSize(
          preferredSize: Size(size.width, 48),
          child: TabBar(
            controller: _controller,
            labelColor: AppColors.primaryColor,
            unselectedLabelColor: AppColors.grey,
            tabs: const [
              Tab(text: 'Add Observation'),
              Tab(text: 'Assessments'),
              Tab(text: 'Links'),
            ],
          ),
        ),
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : TabBarView(
              controller: _controller,
              children: <Widget>[
                SingleChildScrollView(
                  child: Padding(
                    padding: const EdgeInsets.all(18.0),
                    child: Form(
                      key: _formKey,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Text('Children',
                              style: Theme.of(context).textTheme.bodyMedium),
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
                          if (selectedChildren.isNotEmpty)
                            Wrap(
                              spacing: 8.0,
                              runSpacing: 4.0,
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
                          Text('Rooms',
                              style: Theme.of(context).textTheme.bodyMedium),
                          const SizedBox(height: 6),
                          GestureDetector(
                            onTap: _showRoomDialog,
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
                                  Text('Select Rooms',
                                      style: TextStyle(color: Colors.white)),
                                ],
                              ),
                            ),
                          ),
                          const SizedBox(height: 10),
                          if (selectedRooms.isNotEmpty)
                            Wrap(
                              spacing: 8.0,
                              runSpacing: 4.0,
                              children: selectedRooms
                                  .map((room) => Chip(
                                        label: Text(room.room.name),
                                        onDeleted: () {
                                          setState(() {
                                            selectedRooms.remove(room);
                                          });
                                        },
                                      ))
                                  .toList(),
                            ),
                          const SizedBox(height: 16),
                          CustomTextFormWidget(
                            controller: titleController,
                            hintText: 'Title',
                            title: 'Title',
                            validator: (v) =>
                                v == null || v.isEmpty ? 'Enter Title' : null,
                          ),
                          const SizedBox(height: 12),
                          CustomTextFormWidget(
                            controller: observationController,
                            hintText: 'Observation',
                            title: 'Observation',
                            minLines: 3,
                            maxLines: 5,
                            validator: (v) => v == null || v.isEmpty
                                ? 'Enter Observation'
                                : null,
                          ),
                          const SizedBox(height: 12),
                          CustomTextFormWidget(
                            controller: analysisController,
                            hintText: 'Analysis/Evaluation',
                            title: 'Analysis/Evaluation',
                            minLines: 3,
                            maxLines: 5,
                            validator: (v) => v == null || v.isEmpty
                                ? 'Enter Analysis/Evaluation'
                                : null,
                          ),
                          const SizedBox(height: 12),
                          CustomTextFormWidget(
                            controller: reflectionController,
                            hintText: 'Reflection',
                            title: 'Reflection',
                            minLines: 3,
                            maxLines: 5,
                            validator: (v) => v == null || v.isEmpty
                                ? 'Enter Reflection'
                                : null,
                          ),
                          const SizedBox(height: 12),
                          CustomTextFormWidget(
                            controller: childVoiceController,
                            hintText: 'Child\'s Voice',
                            title: 'Child\'s Voice',
                            minLines: 3,
                            maxLines: 5,
                            validator: (v) => v == null || v.isEmpty
                                ? 'Enter Child\'s Voice'
                                : null,
                          ),
                          const SizedBox(height: 12),
                          CustomTextFormWidget(
                            controller: futurePlanController,
                            hintText: 'Future Plan/Extension',
                            title: 'Future Plan/Extension',
                            minLines: 3,
                            maxLines: 5,
                            validator: (v) => v == null || v.isEmpty
                                ? 'Enter Future Plan/Extension'
                                : null,
                          ),
                          const SizedBox(height: 16),
                          Text('Media',
                              style: Theme.of(context).textTheme.bodyMedium),
                          const SizedBox(height: 6),
                          GestureDetector(
                            onTap: () async {
                              FilePickerResult? result = await FilePicker
                                  .platform
                                  .pickFiles(type: FileType.image);
                              if (result != null) {
                                setState(() {
                                  files.add(File(result.files.single.path!));
                                  mediaHeight += 100.0;
                                });
                              }
                            },
                            child: rectBorderWidget(size, context),
                          ),
                          const SizedBox(height: 10),
                          if (files.isNotEmpty)
                            ReorderableGridView.count(
                              crossAxisCount: 3,
                              shrinkWrap: true,
                              physics: const NeverScrollableScrollPhysics(),
                              mainAxisSpacing: 8.0,
                              crossAxisSpacing: 8.0,
                              onReorder: (oldIndex, newIndex) {
                                setState(() {
                                  File file1 = files[oldIndex];
                                  File file2 = files[newIndex];
                                  files[oldIndex] = file2;
                                  files[newIndex] = file1;
                                });
                              },
                              children:
                                  List<Widget>.generate(files.length, (index) {
                                return Stack(
                                  key: ValueKey(files[index].path),
                                  children: [
                                    Container(
                                      width: 100,
                                      height: 100,
                                      decoration: BoxDecoration(
                                        shape: BoxShape.rectangle,
                                        image: DecorationImage(
                                          image: FileImage(files[index]),
                                          fit: BoxFit.cover,
                                        ),
                                      ),
                                    ),
                                    Positioned(
                                      right: 0,
                                      top: 0,
                                      child: GestureDetector(
                                        child: const Icon(Icons.close,
                                            size: 20, color: AppColors.grey),
                                        onTap: () {
                                          setState(() {
                                            files.removeAt(index);
                                            mediaHeight -= 100.0;
                                          });
                                        },
                                      ),
                                    ),
                                  ],
                                );
                              }),
                            ),
                          const SizedBox(height: 30),
                          if (selectedMedia.isNotEmpty)
                            GridView.builder(
                              shrinkWrap: true,
                              physics: const NeverScrollableScrollPhysics(),
                              gridDelegate:
                                  const SliverGridDelegateWithFixedCrossAxisCount(
                                crossAxisCount: 3,
                                crossAxisSpacing: 8,
                                mainAxisSpacing: 8,
                              ),
                              itemCount: selectedMedia.length,
                              itemBuilder: (context, index) {
                                final media = selectedMedia[index];
                                return Stack(
                                  children: [
                                    ClipRRect(
                                      borderRadius: BorderRadius.circular(12),
                                      child: Container(
                                        width: 100,
                                        height: 100,
                                        decoration: BoxDecoration(
                                          shape: BoxShape.rectangle,
                                          borderRadius:
                                              BorderRadius.circular(12),
                                          border: Border.all(
                                              color: AppColors.primaryColor,
                                              width: 2),
                                          boxShadow: const [
                                            const BoxShadow(
                                              color: Colors.black12,
                                              blurRadius: 6,
                                              offset: Offset(0, 2),
                                            ),
                                          ],
                                        ),
                                        child: Image.network(
                                          '${AppUrls.baseUrl}/${media.mediaUrl}',
                                          fit: BoxFit.cover,
                                          errorBuilder:
                                              (context, error, stackTrace) =>
                                                  Container(
                                            color: Colors.grey[300],
                                            child: const Icon(
                                                Icons.broken_image,
                                                color: Colors.grey,
                                                size: 40),
                                          ),
                                        ),
                                      ),
                                    ),
                                    Positioned(
                                      right: 4,
                                      top: 4,
                                      child: GestureDetector(
                                        onTap: () => deleteMedia(media.id),
                                        child: Container(
                                          padding: const EdgeInsets.all(4),
                                          decoration: const BoxDecoration(
                                            color: Colors.red,
                                            shape: BoxShape.circle,
                                            boxShadow: [
                                              BoxShadow(
                                                color: Colors.black26,
                                                blurRadius: 4,
                                                offset: Offset(0, 2),
                                              ),
                                            ],
                                          ),
                                          child: const Icon(Icons.close,
                                              color: Colors.white, size: 16),
                                        ),
                                      ),
                                    ),
                                  ],
                                );
                              },
                            ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              OutlinedButton(
                                onPressed: () {
                                  print(observationData!
                                      .observation.media.length);
                                  print(selectedMedia.length);
                                },
                                child: const Text('CANCEL',
                                    style: TextStyle(color: Colors.black)),
                              ),
                              const SizedBox(width: 10),
                              CustomButton(
                                height: 45,
                                width: 150,
                                isLoading: isSaving,
                                text: 'SAVE & NEXT',
                                ontap: () async {
                                  if (!_formKey.currentState!.validate()) {
                                    UIHelpers.showToast(context,
                                        message:
                                            'Please fill all required fields.');
                                    return;
                                  }
                                  if (selectedChildren.isEmpty) {
                                    UIHelpers.showToast(context,
                                        message:
                                            'Please select at least one child.');
                                    return;
                                  }
                                  if (selectedRooms.isEmpty) {
                                    UIHelpers.showToast(context,
                                        message:
                                            'Please select at least one room.');
                                    return;
                                  }

                                  final fields = {
                                    'obestitle': observationController.text,
                                    'title': titleController.text,
                                    'notes': analysisController.text,
                                    'reflection': reflectionController.text,
                                    'child_voice': childVoiceController.text,
                                    'future_plan': futurePlanController.text,
                                    'selected_rooms': selectedRooms
                                        .map((r) => r.room.id)
                                        .toList(),
                                    'selected_children': selectedChildren
                                        .map((c) => c.childId)
                                        .join(','),
                                    'center_id': widget.centerId,
                                  };
                                  if (widget.type == 'edit' || true) {
                                    fields.addAll({
                                      'id': widget.id ?? '',
                                      //  observationData?.observation.id
                                      //         .toString() ??
                                      //     ''
                                    });
                                  }
                                  final filePaths =
                                      files.map((f) => f.path).toList();
                                  if (this.mounted) {
                                    setState(() {
                                      isSaving = true;
                                    });
                                  }
                                  final response = await _observationRepository
                                      .saveObservation(
                                    filePaths: filePaths,
                                    fields: fields,
                                  );
                                  if (this.mounted) {
                                    setState(() {
                                      isSaving = false;
                                    });
                                  }
                                  if (response.success) {
                                    UIHelpers.showToast(context,
                                        message: 'Observation saved');
                                    setState(() {
                                      _addCompleted = true;
                                    });
                                    if (response.data != null &&
                                        response.data['id'] != null) {
                                      observationIdAfterSave =
                                          response.data['id'].toString();
                                    }
                                    _controller!.animateTo(1);
                                  } else {
                                    // ignore: use_build_context_synchronously
                                    UIHelpers.showToast(context,
                                        message: response.message);
                                  }
                                },
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                AssessmentsScreen(
                  observationId: widget.type == 'edit'
                      ? widget.id.toString()
                      : observationIdAfterSave,
                  observationData: observationData,
                  onTabChanged: (subTab) {
                    setState(() {
                      currentSubTab = subTab;
                    });
                    _loadObservationData();
                  },
                  onSaveDevelopmentMilestone: () {
                    _controller!.animateTo(2);
                  },
                ),
                ObservationLinkingScreen(
                  centerId: widget.centerId,
                  observationData: observationData,
                  observationId: observationIdAfterSave,
                ),
              ],
            ),
    );
  }
}

class RoomsModel {
  final RoomsDescModel room;
  final List<dynamic> child;

  RoomsModel({
    required this.room,
    required this.child,
  });

  @override
  String toString() {
    return room.name;
  }
}

class RoomsDescModel {
  final String id;
  final String name;

  RoomsDescModel({
    required this.id,
    required this.name,
  });
}

class ChildModel {
  final String? childId;
  final String name;
  final String imageUrl;

  ChildModel({
    this.childId,
    required this.name,
    required this.imageUrl,
  });
}
