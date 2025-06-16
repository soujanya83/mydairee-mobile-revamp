import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mydiaree/core/config/app_colors.dart';
import 'package:mydiaree/core/utils/hexconversion.dart';
import 'package:mydiaree/core/utils/ui_helper.dart';
import 'package:mydiaree/core/widgets/custom_app_bar.dart';
import 'package:mydiaree/core/widgets/custom_background_widget.dart';
import 'package:mydiaree/core/widgets/custom_dropdown.dart';
import 'package:mydiaree/core/widgets/custom_scaffold.dart';
import 'package:mydiaree/core/widgets/custom_text_field.dart';
import 'package:mydiaree/features/room/presentation/bloc/list_room/list_room_bloc.dart';
import 'package:mydiaree/features/room/presentation/bloc/list_room/list_room_event.dart';
import 'package:mydiaree/features/room/presentation/bloc/list_room/list_room_state.dart';
import 'package:mydiaree/features/room/presentation/pages/add_room_screen.dart';
import 'package:mydiaree/main.dart';

class RoomsListScreen extends StatelessWidget {
  RoomsListScreen({super.key});

  String _chosenValue = 'Select';

  String searchString = '';

  bool roomsFetched = true;

  bool usersFetched = true;

  int currentIndex = 0;

  List<bool> checkValues = [false, false, false, false, false];

  // Sample check values
  List statList = [];

  bool centersFetched = true;

  bool permissionAdd = true;

  bool permission = true;

  bool permissionDel = true;

  bool permissionupdate = true;

  List<String> selectedRooms = [];

  String? selectedStatus;

  // Sample static data
  final List<Map<String, dynamic>> centers = [
    {'id': '1', 'centerName': 'Main Center'},
    {'id': '2', 'centerName': 'North Branch'},
    {'id': '3', 'centerName': 'South Branch'},
  ];

  @override
  Widget build(BuildContext context) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<RoomListBloc>().add(const FetchRoomsEvent(centerId: '1'));
    });
    final TextEditingController searchController = TextEditingController();
    bool permissionAdd = true;

    return CustomScaffold(
      appBar: const CustomAppBar(title: "Rooms"),
      body: BlocConsumer<RoomListBloc, RoomListState>(
        listener: (context, state) {
          if (state is RoomDeletedState) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text("Rooms deleted successfully")),
            );
          } else if (state is RoomListError) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(state.message)),
            );
          }
        },
        builder: (context, state) {
          if (state is RoomListLoading) {
            return const Center(child: CircularProgressIndicator());
          } else if (state is RoomListError) {
            return Center(child: Text(state.message));
          } else if (state is RoomListLoaded) {
            return SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(12.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Row(
                      children: [
                        Text(
                          'Rooms',
                          style: Theme.of(context).textTheme.headlineSmall,
                        ),
                        const Spacer(),
                        if (permissionAdd)
                          UIHelpers.addButton(
                            context: context,
                            ontap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) =>
                                      const AddRoomScreen(centerId: ''),
                                ),
                              );
                            },
                          ),
                      ],
                    ),
                    const SizedBox(height: 5),
                    StatefulBuilder(
                      builder: (context,setstate) {
                        return CustomDropdown(
                          height: 35,
                          onChanged: (value) {
                            print('centers');
                            final index =
                                centers.indexWhere((c) => c['centerName'] == value);
                            if (index != -1) {}
                            setstate((){});
                          },
                          value: centers.isNotEmpty ? centers : 'Select Center',
                          items: centers.isNotEmpty
                              ? centers
                                  .map((center) => center['centerName'] as String)
                                  .toList()
                              : ['Select Center'],
                        );
                      }
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 8.0, bottom: 3),
                      child: CustomTextFormWidget(
                        contentpadding: const EdgeInsets.only(top: 4),
                        prefixWidget: const Icon(Icons.search),
                        height: 40,
                        hintText: '',
                        controller: searchController,
                        onChanged: (value) {},
                      ),
                    ),
                    const SizedBox(height: 5),
                    StatefulBuilder(builder: (context, setstateddd) {
                      return CustomDropdown(
                        height: 35,
                        width: screenWidth * .3,
                        onChanged: (value) {
                          selectedStatus = value;
                          setstateddd(
                            () {},
                          );
                        },
                        value: selectedStatus,
                        items: const <String>['Select', 'Active', 'Inactive'],
                      );
                    }),
                    StatefulBuilder(builder: (context, setstateddd) {
                      return ListView.builder(
                        physics: const NeverScrollableScrollPhysics(),
                        shrinkWrap: true,
                        itemCount: state.roomsData.rooms.length,
                        itemBuilder: (BuildContext context, int index) {
                          return RoomCard(
                            isSelected: selectedRooms
                                .contains(state.roomsData.rooms[index].id),
                            permissionUpdate: true,
                            onSelectionChanged: (selected) {
                              print(selectedRooms.toList());
                              print(state.roomsData.rooms[index].id);
                              print(selectedRooms
                                  .contains(state.roomsData.rooms[index].id));
                              print(selected);
                              print(state.roomsData.rooms[index].id);
                              if (selected) {
                                print('enter in true');
                                // if (!selectedRooms.contains(
                                //     state.roomsData.rooms[index].id))
                                if (true) {
                                  selectedRooms
                                      .add(state.roomsData.rooms[index].id);
                                  setstateddd(
                                    () {},
                                  );
                                }
                              } else {
                                print('enter in false');
                                if (selectedRooms.contains(
                                    state.roomsData.rooms[index].id)) {
                                  selectedRooms
                                      .remove(state.roomsData.rooms[index].id);
                                  setstateddd(
                                    () {},
                                  );
                                }
                              }
                            },
                            onEditPressed: () {},
                            roomId: state.roomsData.rooms[index].id,
                            roomName: state.roomsData.rooms[index].name,
                            roomColor: state.roomsData.rooms[index].color,
                            userName: state.roomsData.rooms[index].userName,
                            status: state.roomsData.rooms[index].status,
                            children: state.roomsData.rooms[index].children
                                .map((child) => child.name)
                                .toList(),
                          );
                        },
                      );
                    }),
                    const SizedBox(height: 10),
                    if (selectedRooms.isNotEmpty)
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 16.0),
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.red,
                            foregroundColor: Colors.white,
                          ),
                          onPressed: () {
                            _showDeleteConfirmationDialog(context);
                          },
                          child: const Text('Delete Selected'),
                        ),
                      ),
                  ],
                ),
              ),
            );
          }
          return Container();
        },
      ),
    );
  }

  void _showDeleteConfirmationDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text("Delete Items?"),
          content: const Text("This action cannot be undone."),
          actions: [
            TextButton(
              child: const Text("Cancel"),
              onPressed: () => Navigator.pop(context),
            ),
            TextButton(
              style: TextButton.styleFrom(
                foregroundColor: Colors.white,
                backgroundColor: Colors.red,
              ),
              child: const Text("Delete"),
              onPressed: () {
                context.read<RoomListBloc>().add(DeleteSelectedRoomsEvent());
                Navigator.pop(context);
              },
            ),
          ],
        );
      },
    );
  }
}

class RoomCard extends StatelessWidget {
  final String roomId;
  final String roomName;
  final String roomColor;
  final String userName;
  final String status;
  final List<String> children;
  final bool isSelected;
  final bool permissionUpdate;
  final Function(bool) onSelectionChanged;
  final VoidCallback onEditPressed;

  const RoomCard({
    required this.roomId,
    required this.roomName,
    required this.roomColor,
    required this.userName,
    required this.status,
    required this.children,
    required this.isSelected,
    required this.permissionUpdate,
    required this.onSelectionChanged,
    required this.onEditPressed,
  });

  Color _safeHexColor(String? color) {
    try {
      return HexColor(color ?? "#FFFFFF");
    } catch (e) {
      return HexColor("#FFFFFF"); // Default to white on error
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: PatternBackground(
        child: ClipRRect(
          borderRadius: BorderRadius.circular(12),
          child: Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  _safeHexColor(roomColor),
                  Colors.transparent,
                ],
                stops: const [0.02, 0.02],
              ),
            ),
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: Row(
                    children: [
                      GestureDetector(
                        onTap: () {},
                        child: Text(
                          roomName,
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                      const Spacer(),
                      if (permissionUpdate)
                        IconButton(
                          icon: const Icon(
                            Icons.edit,
                            color: AppColors.primaryColor,
                          ),
                          onPressed: onEditPressed,
                        ),
                      Checkbox(
                        value: isSelected,
                        fillColor:
                            WidgetStateProperty.all(AppColors.primaryColor),
                        onChanged: (val) => onSelectionChanged(val ?? false),
                        overlayColor:
                            WidgetStateProperty.all(AppColors.primaryColor),
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 12.0),
                  child: Row(
                    children: [
                      const Icon(Icons.child_care, color: Colors.orange),
                      const SizedBox(width: 8),
                      Text(
                        children.isNotEmpty ? children.length.toString() : '0',
                        style: const TextStyle(fontWeight: FontWeight.w500),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 8),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 12.0),
                  child: Row(
                    children: [
                      const Icon(Icons.person, color: AppColors.primaryColor),
                      const SizedBox(width: 8),
                      Text(
                        userName,
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          color: AppColors.primaryColor,
                        ),
                      ),
                      const Text(' (Lead)', style: TextStyle(fontSize: 12)),
                    ],
                  ),
                ),
                const SizedBox(height: 15),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
