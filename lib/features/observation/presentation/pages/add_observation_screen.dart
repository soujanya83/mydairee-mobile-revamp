import 'package:flutter/material.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:mydiaree/core/widgets/custom_buton.dart'; 
import 'package:reorderable_grid_view/reorderable_grid_view.dart';
import 'package:file_picker/file_picker.dart';
import 'dart:io';
import 'package:mydiaree/core/config/app_colors.dart';
import 'package:mydiaree/core/widgets/custom_app_bar.dart';
import 'package:mydiaree/core/widgets/custom_scaffold.dart';
import 'package:mydiaree/core/widgets/custom_text_field.dart'; 
import 'package:mydiaree/core/widgets/custom_multi_selected_dialog.dart';

class AddObservationScreen extends StatefulWidget {
  final String type;
  final String centerId;

  const AddObservationScreen({
    Key? key,
    required this.type,
    required this.centerId,
  }) : super(key: key);

  @override
  AddObservationScreenState createState() => AddObservationScreenState();
}

class AddObservationScreenState extends State<AddObservationScreen> with TickerProviderStateMixin {
  TabController? _controller;
  double mediaHeight = 0;

  // Static dummy data
  static List<ChildModel> selectedChildren = [];
  static List<RoomsModel> selectedRooms = [];
  static List<File> files = [];
  static List<TextEditingController> captions = [];
  static List<List<ChildModel>> _editChildren = [];
  static List<List<StaffModel>> _editEducators = [];

  // Text controllers
  static TextEditingController titleController = TextEditingController();
  static TextEditingController observationController = TextEditingController();
  static TextEditingController analysisController = TextEditingController();
  static TextEditingController reflectionController = TextEditingController();
  static TextEditingController childVoiceController = TextEditingController();
  static TextEditingController futurePlanController = TextEditingController();

  // Dummy data for children, rooms, and educators
  final List<ChildModel> _allChildren = [
    ChildModel(childId: '1', name: 'John Doe', imageUrl: 'https://example.com/john.jpg'),
    ChildModel(childId: '2', name: 'Jane Smith', imageUrl: 'https://example.com/jane.jpg'),
    ChildModel(childId: '3', name: 'Alex Brown', imageUrl: 'https://example.com/alex.jpg'),
  ];

  final List<RoomsModel> _rooms = [
    RoomsModel(room: RoomsDescModel(id: 'r1', name: 'Room A'), child: []),
    RoomsModel(room: RoomsDescModel(id: 'r2', name: 'Room B'), child: []),
  ];

  final List<StaffModel> _allEducators = [
    StaffModel(id: 'e1', name: 'Teacher Alice'),
    StaffModel(id: 'e2', name: 'Teacher Bob'),
  ];

  @override
  void initState() {
    _controller = TabController(length: 3, vsync: this);
    super.initState();
  }

  @override
  void dispose() {
    _controller?.dispose();
    super.dispose();
  }

  void _showChildrenDialog() async {
    await showDialog<List<Map<String, String>>>(
      context: context,
      builder: (context) => CustomMultiSelectDialog(
        itemsId: _allChildren.map((child) => child.childId!).toList(),
        itemsName: _allChildren.map((child) => child.name).toList(),
        initiallySelectedIds: selectedChildren.map((child) => child.childId!).toList(),
        title: 'Select Children',
        onItemTap: (selectedIds) {
          setState(() {
            selectedChildren = _allChildren.where((child) => selectedIds.contains(child.childId)).toList();
          });
        },
      ),
    );
  }

  void _showRoomDialog() async {
    await showDialog<List<Map<String, String>>>(
      context: context,
      builder: (context) => CustomMultiSelectDialog(
        itemsId: _rooms.map((room) => room.room.id).toList(),
        itemsName: _rooms.map((room) => room.room.name).toList(),
        initiallySelectedIds: selectedRooms.map((room) => room.room.id).toList(),
        title: 'Select Rooms',
        onItemTap: (selectedIds) {
          setState(() {
            selectedRooms = _rooms.where((room) => selectedIds.contains(room.room.id)).toList();
          });
        },
      ),
    );
  }

  Widget rectBorderWidget(Size size, BuildContext context) {
    return DottedBorder(
      // dashPattern: const [8, 4],
      // strokeWidth: 2,
      // color: AppColors.grey,
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

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return CustomScaffold(
      appBar: const CustomAppBar(title: 'Add Observation'),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text('Add Observation', style: Theme.of(context).textTheme.headlineSmall),
              const SizedBox(height: 16),
              TabBar(
                controller: _controller,
                labelColor: AppColors.primaryColor,
                unselectedLabelColor: AppColors.grey,
                tabs: const [
                  Tab(text: 'Add Observation'),
                  Tab(text: 'Assessments'),
                  Tab(text: 'Links'),
                ],
              ),
              Container(
                height: size.height + selectedChildren.length * 50 + mediaHeight + selectedRooms.length * 50 + 300,
                child: TabBarView(
                  controller: _controller,
                  children: <Widget>[
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Text('Children', style: Theme.of(context).textTheme.bodyMedium),
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
                                Text('Select Children', style: TextStyle(color: Colors.white)),
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
                        Text('Rooms', style: Theme.of(context).textTheme.bodyMedium),
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
                                Text('Select Rooms', style: TextStyle(color: Colors.white)),
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
                          validator: (v) => v == null || v.isEmpty ? 'Enter Title' : null,
                        ),
                        const SizedBox(height: 12),
                        CustomTextFormWidget(
                          controller: observationController,
                          hintText: 'Observation',
                          title: 'Observation',
                          minLines: 3,
                          maxLines: 5,
                          validator: (v) => v == null || v.isEmpty ? 'Enter Observation' : null,
                        ),
                        const SizedBox(height: 12),
                        CustomTextFormWidget(
                          controller: analysisController,
                          hintText: 'Analysis/Evaluation',
                          title: 'Analysis/Evaluation',
                          minLines: 3,
                          maxLines: 5,
                          validator: (v) => v == null || v.isEmpty ? 'Enter Analysis/Evaluation' : null,
                        ),
                        const SizedBox(height: 12),
                        CustomTextFormWidget(
                          controller: reflectionController,
                          hintText: 'Reflection',
                          title: 'Reflection',
                          minLines: 3,
                          maxLines: 5,
                          validator: (v) => v == null || v.isEmpty ? 'Enter Reflection' : null,
                        ),
                        const SizedBox(height: 12),
                        CustomTextFormWidget(
                          controller: childVoiceController,
                          hintText: 'Child\'s Voice',
                          title: 'Child\'s Voice',
                          minLines: 3,
                          maxLines: 5,
                          validator: (v) => v == null || v.isEmpty ? 'Enter Child\'s Voice' : null,
                        ),
                        const SizedBox(height: 12),
                        CustomTextFormWidget(
                          controller: futurePlanController,
                          hintText: 'Future Plan/Extension',
                          title: 'Future Plan/Extension',
                          minLines: 3,
                          maxLines: 5,
                          validator: (v) => v == null || v.isEmpty ? 'Enter Future Plan/Extension' : null,
                        ),
                        const SizedBox(height: 16),
                        Text('Media', style: Theme.of(context).textTheme.bodyMedium),
                        const SizedBox(height: 6),
                        GestureDetector(
                          onTap: () async {
                            FilePickerResult? result = await FilePicker.platform.pickFiles(type: FileType.image);
                            if (result != null) {
                              setState(() {
                                files.add(File(result.files.single.path!));
                                captions.add(TextEditingController());
                                _editChildren.add([]);
                                _editEducators.add([]);
                                mediaHeight += 100.0;
                              });
                            }
                          },
                          child: rectBorderWidget(size, context),
                        ),
                        // const SizedBox(height: 10),
                        // if (files.isNotEmpty)
                        //   ReorderableWrap(
                        //     spacing: 8.0,
                        //     runSpacing: 4.0,
                        //     onReorder: (oldIndex, newIndex) {
                        //       setState(() {
                        //         File file1 = files[oldIndex];
                        //         File file2 = files[newIndex];
                        //         files[oldIndex] = file2;
                        //         files[newIndex] = file1;

                        //         TextEditingController caption1 = captions[oldIndex];
                        //         TextEditingController caption2 = captions[newIndex];
                        //         captions[oldIndex] = caption2;
                        //         captions[newIndex] = caption1;

                        //         List<ChildModel> child1 = _editChildren[oldIndex];
                        //         List<ChildModel> child2 = _editChildren[newIndex];
                        //         _editChildren[oldIndex] = child2;
                        //         _editChildren[newIndex] = child1;

                        //         List<StaffModel> edu1 = _editEducators[oldIndex];
                        //         List<StaffModel> edu2 = _editEducators[newIndex];
                        //         _editEducators[oldIndex] = edu2;
                        //         _editEducators[newIndex] = edu1;
                        //       });
                        //     },
                        //     children: List<Widget>.generate(files.length, (index) {
                        //       return Stack(
                        //         children: [
                        //           Container(
                        //             width: 100,
                        //             height: 100,
                        //             decoration: BoxDecoration(
                        //               shape: BoxShape.rectangle,
                        //               image: DecorationImage(
                        //                 image: FileImage(files[index]),
                        //                 fit: BoxFit.cover,
                        //               ),
                        //             ),
                        //           ),
                        //           Positioned(
                        //             right: 0,
                        //             top: 0,
                        //             child: GestureDetector(
                        //               child: const Icon(Icons.close, size: 20, color: AppColors.grey),
                        //               onTap: () {
                        //                 setState(() {
                        //                   files.removeAt(index);
                        //                   captions.removeAt(index);
                        //                   _editChildren.removeAt(index);
                        //                   _editEducators.removeAt(index);
                        //                   mediaHeight -= 100.0;
                        //                 });
                        //               },
                        //             ),
                        //           ),
                        //           Positioned(
                        //             right: 0,
                        //             top: 22,
                        //             child: GestureDetector(
                        //               child: const Icon(Icons.edit, size: 20, color: AppColors.grey),
                        //               onTap: () {
                        //                 showDialog(
                        //                   context: context,
                        //                   builder: (context) {
                        //                     return AlertDialog(
                        //                       title: const Text('Edit Image'),
                        //                       content: SingleChildScrollView(
                        //                         child: Container(
                        //                           height: size.height * 0.6,
                        //                           width: size.width * 0.7,
                        //                           child: ListView(
                        //                             children: [
                        //                               Container(
                        //                                 width: 100,
                        //                                 height: 100,
                        //                                 decoration: BoxDecoration(
                        //                                   image: DecorationImage(
                        //                                     image: FileImage(files[index]),
                        //                                     fit: BoxFit.cover,
                        //                                   ),
                        //                                 ),
                        //                               ),
                        //                               const SizedBox(height: 8),
                        //                               Text('Children', style: Theme.of(context).textTheme.bodyMedium),
                        //                               const SizedBox(height: 3),
                        //                               GestureDetector(
                        //                                 onTap: () async {
                        //                                   await showDialog<List<Map<String, String>>>(
                        //                                     context: context,
                        //                                     builder: (context) => CustomMultiSelectDialog(
                        //                                       itemsId: _allChildren.map((child) => child.childId!).toList(),
                        //                                       itemsName: _allChildren.map((child) => child.name).toList(),
                        //                                       initiallySelectedIds: _editChildren[index].map((child) => child.childId!).toList(),
                        //                                       title: 'Select Children',
                        //                                       onItemTap: (selectedIds) {
                        //                                         setState(() {
                        //                                           _editChildren[index] = _allChildren.where((child) => selectedIds.contains(child.childId)).toList();
                        //                                         });
                        //                                       },
                        //                                     ),
                        //                                   );
                        //                                 },
                        //                                 child: Container(
                        //                                   width: 180,
                        //                                   height: 38,
                        //                                   decoration: BoxDecoration(
                        //                                     color: AppColors.primaryColor,
                        //                                     borderRadius: BorderRadius.circular(8),
                        //                                   ),
                        //                                   child: const Row(
                        //                                     children: [
                        //                                       SizedBox(width: 8),
                        //                                       Icon(Icons.add_circle, color: Colors.white),
                        //                                       SizedBox(width: 8),
                        //                                       Text('Select Children', style: TextStyle(color: Colors.white)),
                        //                                     ],
                        //                                   ),
                        //                                 ),
                        //                               ),
                        //                               const SizedBox(height: 8),
                        //                               Text('Educators', style: Theme.of(context).textTheme.bodyMedium),
                        //                               const SizedBox(height: 3),
                        //                               GestureDetector(
                        //                                 onTap: () async {
                        //                                   await showDialog<List<Map<String, String>>>(
                        //                                     context: context,
                        //                                     builder: (context) => CustomMultiSelectDialog(
                        //                                       itemsId: _allEducators.map((edu) => edu.id).toList(),
                        //                                       itemsName: _allEducators.map((edu) => edu.name).toList(),
                        //                                       initiallySelectedIds: _editEducators[index].map((edu) => edu.id).toList(),
                        //                                       title: 'Select Educators',
                        //                                       onItemTap: (selectedIds) {
                        //                                         setState(() {
                        //                                           _editEducators[index] = _allEducators.where((edu) => selectedIds.contains(edu.id)).toList();
                        //                                         });
                        //                                       },
                        //                                     ),
                        //                                   );
                        //                                 },
                        //                                 child: Container(
                        //                                   width: 180,
                        //                                   height: 38,
                        //                                   decoration: BoxDecoration(
                        //                                     color: AppColors.primaryColor,
                        //                                     borderRadius: BorderRadius.circular(8),
                        //                                   ),
                        //                                   child: const Row(
                        //                                     children: [
                        //                                       SizedBox(width: 8),
                        //                                       Icon(Icons.add_circle, color: Colors.white),
                        //                                       SizedBox(width: 8),
                        //                                       Text('Select Educators', style: TextStyle(color: Colors.white)),
                        //                                     ],
                        //                                   ),
                        //                                 ),
                        //                               ),
                        //                               const SizedBox(height: 8),
                        //                               Text('Caption', style: Theme.of(context).textTheme.bodyMedium),
                        //                               const SizedBox(height: 3),
                        //                               CustomTextFormWidget(
                        //                                 controller: captions[index],
                        //                                 hintText: 'Caption',
                        //                                 title: 'Caption',
                        //                                 maxLines: 1,
                        //                                 validator: (v) => v == null || v.isEmpty ? 'Enter Caption' : null,
                        //                               ),
                        //                             ],
                        //                           ),
                        //                         ),
                        //                       ),
                        //                       actions: [
                        //                         TextButton(
                        //                           onPressed: () => Navigator.pop(context),
                        //                           child: const Text('OK'),
                        //                         ),
                        //                       ],
                        //                     );
                        //                   },
                        //                 );
                        //               },
                        //             ),
                        //           ),
                        //         ],
                        //       );
                        //     }),
                        //   ),
                        // const SizedBox(height: 30),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            OutlinedButton(
                              onPressed: () => Navigator.pop(context),
                              child: const Text('CANCEL', style: TextStyle(color: Colors.black)),
                            ),
                            const SizedBox(width: 16),
                            CustomButton(
                              height: 45,
                              width: 100,
                              text: 'DRAFT',
                              ontap: () {
                                print('Draft saved');
                              },
                            ),
                            const SizedBox(width: 16),
                            CustomButton(
                              height: 45,
                              width: 120,
                              text: 'SAVE & NEXT',
                              ontap: () {
                                print('Published');
                              },
                            ),
                          ],
                        ),
                      ],
                    ),
                    Container(child: Text('Assessments Tab (Placeholder)', style: Theme.of(context).textTheme.bodyMedium)),
                    Container(child: Text('Links Tab (Placeholder)', style: Theme.of(context).textTheme.bodyMedium)),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// Dummy models
class ChildModel {
  final String? childId;
  final String name;
  final String imageUrl;

  ChildModel({this.childId, required this.name, required this.imageUrl});
}

class RoomsModel {
  final RoomsDescModel room;
  final List<ChildModel> child;

  RoomsModel({required this.room, required this.child});
}

class RoomsDescModel {
  final String id;
  final String name;

  RoomsDescModel({required this.id, required this.name});
}

class StaffModel {
  final String id;
  final String name;

  StaffModel({required this.id, required this.name});
}