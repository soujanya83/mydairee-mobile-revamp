import 'package:flutter/material.dart';
import 'package:mydiaree/core/config/app_urls.dart';
import 'package:mydiaree/core/widgets/custom_app_bar.dart';
import 'package:mydiaree/core/widgets/custom_scaffold.dart';
import 'package:mydiaree/core/utils/helper_functions.dart';
import 'package:mydiaree/features/room/presentation/bloc/view_room/vieiw_room_bloc.dart';
import 'package:mydiaree/features/room/presentation/bloc/view_room/vieiw_room_event.dart';
import 'package:mydiaree/features/room/presentation/bloc/view_room/vieiw_room_state.dart';
import 'package:mydiaree/features/room/presentation/pages/add_children_screen.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mydiaree/core/widgets/custom_buton.dart';
import 'package:mydiaree/features/room/data/model/room_list_model.dart';
import 'package:mydiaree/features/room/data/model/childrens_room_model.dart'
    hide Status;
import 'package:mydiaree/features/room/presentation/pages/add_children_screen.dart';
import 'package:mydiaree/core/widgets/custom_dropdown.dart';
import 'package:mydiaree/core/services/apiresoponse.dart';
import 'package:mydiaree/features/room/data/repositories/room_repositories.dart';

class ViewRoomScreen extends StatefulWidget {
  final Room room;
  const ViewRoomScreen({super.key, required this.room});

  @override
  State<ViewRoomScreen> createState() => _ViewRoomScreenState();
}

class _ViewRoomScreenState extends State<ViewRoomScreen> {
  ChildrensRoomModel? childrenData;
  List<int> selectedChildrenIds = [];
  String? selectedMoveRoomId;
  List<Room> allRooms = [];
  bool isMoving = false;

  @override
  void initState() {
    super.initState();
    context
        .read<ViewRoomBloc>()
        .add(FetchRoomChildrenEvent(widget.room.id.toString()));
    fetchRooms();
  }

  Future<void> fetchRooms() async {
    final response = await RoomRepository()
        .getRooms(centerId: widget.room.centerid?.toString() ?? '');
    if (response.success && response.data != null) {
      setState(() {
        allRooms = response.data!.rooms ?? [];
      });
    }
  }

  Future<void> moveSelectedChildren() async {
    if (selectedChildrenIds.isEmpty || selectedMoveRoomId == null) return;

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (ctx) => const Center(child: CircularProgressIndicator()),
    );

    final data = {
      'child_ids': selectedChildrenIds,
      'room_id': selectedMoveRoomId,
    };

    final response = await postAndParse(
      'https://mydiaree.com.au/api/move-children',
      data,
    );

    Navigator.of(context, rootNavigator: true).pop();

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(response.message),
        backgroundColor: response.success ? Colors.green : Colors.red,
      ),
    );

    if (response.success) {
      selectedChildrenIds.clear();
      selectedMoveRoomId = null;
      context
          .read<ViewRoomBloc>()
          .add(FetchRoomChildrenEvent(widget.room.id.toString()));
      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    return CustomScaffold(
      appBar: CustomAppBar(
        title: widget.room.name ?? 'Room Details',
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: BlocConsumer<ViewRoomBloc, ViewRoomState>(
          listener: (context, state) {
            if (state is ViewRoomLoaded) {
              setState(() {
                childrenData = state.childrenData;
              });
            }
          },
          builder: (context, state) {
            final children = childrenData?.allChildren ?? [];
            return ListView(
              children: [
                ListTile(
                  title: Text(widget.room.name ?? 'No name'),
                  subtitle: Text('ID: ${widget.room.id ?? ''}'),
                ),
                const SizedBox(height: 12),
                ListTile(
                  title: const Text('Capacity'),
                  subtitle: Text(widget.room.capacity?.toString() ?? ''),
                ),
                ListTile(
                  title: const Text('Age Range'),
                  subtitle: Text(
                      '${widget.room.ageFrom ?? '-'} to ${widget.room.ageTo ?? '-'}'),
                ),
                ListTile(
                  title: const Text('Status'),
                  subtitle: Text(widget.room.status ?? ''),
                ),
                ListTile(
                  title: const Text('Center ID'),
                  subtitle: Text(widget.room.centerid?.toString() ?? ''),
                ),
                ListTile(
                  title: const Text('Created By'),
                  subtitle: Text(widget.room.createdBy?.toString() ?? ''),
                ),
                const Divider(),
                ListTile(
                  title: const Text('Educators'),
                  subtitle: widget.room.educators != null &&
                          widget.room.educators!.isNotEmpty
                      ? Wrap(
                          spacing: 8,
                          children: widget.room.educators!
                              .map((e) => Chip(label: Text(e.name ?? '')))
                              .toList(),
                        )
                      : const Text('No educators assigned'),
                ),
                const SizedBox(height: 16),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    CustomButton(
                      width: 130,
                      borderRadius: 10,
                      height: 35,
                      text: 'Add Child',
                      ontap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => AddChildrenScreen(
                              centerId: widget.room.centerid?.toString(),
                              childId: null,
                              child: null,
                              roomId: widget.room.id.toString(),
                            ),
                          ),
                        );
                      },
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                ListTile(
                  title: const Text('Children'),
                  subtitle: Builder(
                    builder: (context) {
                      if (state is ViewRoomLoading) {
                        return const SizedBox();
                      }
                      if (state is ViewRoomError) {
                        return Text(state.message,
                            style: const TextStyle(color: Colors.red));
                      }
                      if (children.isEmpty) {
                        return const Text('No children assigned');
                      }
                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Wrap(
                            spacing: 8,
                            children: children.map((c) {
                              final isSelected =
                                  selectedChildrenIds.contains(c.id);
                              return Card(
                                elevation: 2,
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(8)),
                                child: InkWell(
                                  onTap: () {
                                    setState((){
                                      if (isSelected) {
                                        selectedChildrenIds.remove(c.id);
                                      } else {
                                        selectedChildrenIds.add(c.id!);
                                      }
                                    });
                                  },
                                  child: Padding(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 8, vertical: 4),
                                    child: Row(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        Checkbox(
                                          fillColor: MaterialStateProperty.all(
                                              Theme.of(context).primaryColor),
                                          value: isSelected,
                                          onChanged: (val) {
                                            setState(() {
                                              if (val == true) {
                                                selectedChildrenIds.add(c.id!);
                                              } else {
                                                selectedChildrenIds
                                                    .remove(c.id);
                                              }
                                            });
                                          },
                                        ),
                                        // CircleAvatar(
                                        //   radius: 16,
                                        //   backgroundImage: c.imageUrl != null &&
                                        //           c.imageUrl!.isNotEmpty
                                        //       ? NetworkImage(
                                        //           AppUrls.baseApiUrl +
                                        //               '/' +
                                        //               c.imageUrl!)
                                        //       : null,
                                        //   child: c.imageUrl == null ||
                                        //           c.imageUrl!.isEmpty
                                        //       ? const Icon(Icons.person,
                                        //           size: 18)
                                        //       : null,
                                        // ),
                                        const SizedBox(width: 8),
                                        Text(
                                            '${c.name ?? ''} ${c.lastname ?? ''}'),
                                        IconButton(
                                          icon:
                                              const Icon(Icons.edit, size: 18),
                                          onPressed: () {
                                            Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                builder: (context) =>
                                                    AddChildrenScreen(
                                                  roomId:
                                                      widget.room.id.toString(),
                                                  childId: c.id?.toString(),
                                                  centerId:
                                                      c.centerid?.toString(),
                                                  child: Child(
                                                    id: c.id,
                                                    name: c.name,
                                                    lastname: c.lastname,
                                                    imageUrl: c.imageUrl,
                                                    room: c.room,
                                                    centerid: c.centerid,
                                                    dob: c.dob?.toIso8601String(),
                                                    startDate: c.startDate?.toIso8601String(),
                                                    status: c.status != null
                                                        ? Status.values.firstWhere(
                                                            (s) => s.name == c.status!.name,
                                                            orElse: () => Status.values.first)
                                                        : null,
                                                    gender: c.gender != null
                                                        ? ChildGender.values.firstWhere(
                                                            (g) => g.name == c.gender,
                                                            orElse: () => ChildGender.values.first)
                                                        : null,
                                                    daysAttending: c.daysAttending,
                                                  ),
                                                ),
                                              ),
                                            );
                                          },
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              );
                            }).toList(),
                          ),
                          if (selectedChildrenIds.isNotEmpty)
                            Padding(
                              padding: const EdgeInsets.symmetric(vertical: 16),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Expanded(
                                    child: CustomDropdown<String>(
                                      width: double.infinity,
                                      value: selectedMoveRoomId,
                                      items: allRooms
                                          .where((r) =>
                                              r.id?.toString() !=
                                              widget.room.id.toString())
                                          .map((r) => r.id?.toString() ?? '')
                                          .toList(),
                                      hint: 'Select Room to Move',
                                      onChanged: (val) {
                                        setState(() {
                                          selectedMoveRoomId = val;
                                        });
                                      },
                                      displayItem: (id) {
                                        final room = allRooms.firstWhere(
                                            (r) => r.id?.toString() == id,
                                            orElse: () => Room());
                                        return room.name ?? id;
                                      },
                                    ),
                                  ),
                                  SizedBox(width: 8),
                                CustomButton(
                                  height: 33,width: 70,
                                    text: 'Move',
                                    isLoading: isMoving,
                                    ontap: () async {
                                      setState(() => isMoving = true);
                                      await moveSelectedChildren();
                                      setState(() => isMoving = false);
                                    },
                                  )
                               
                                ],
                              ),
                            ),
                        ],
                      );
                    },
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}
