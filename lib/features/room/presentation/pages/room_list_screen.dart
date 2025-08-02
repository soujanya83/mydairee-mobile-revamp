import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mydiaree/core/utils/helper_functions.dart';
import 'package:mydiaree/core/utils/ui_helper.dart';
import 'package:mydiaree/core/widgets/custom_app_bar.dart';
import 'package:mydiaree/core/widgets/custom_buton.dart';
import 'package:mydiaree/core/widgets/custom_dropdown.dart';
import 'package:mydiaree/core/widgets/custom_scaffold.dart';
import 'package:mydiaree/core/widgets/custom_text_field.dart';
import 'package:mydiaree/core/widgets/dropdowns/center_dropdown.dart';
import 'package:mydiaree/features/room/data/repositories/room_repositories.dart';
import 'package:mydiaree/features/room/presentation/bloc/list_room/list_room_bloc.dart';
import 'package:mydiaree/features/room/presentation/bloc/list_room/list_room_event.dart';
import 'package:mydiaree/features/room/presentation/bloc/list_room/list_room_state.dart';
import 'package:mydiaree/features/room/presentation/pages/add_room_screen.dart';
import 'package:mydiaree/features/room/presentation/pages/view_room_screen.dart';
import 'package:mydiaree/features/room/presentation/widget/room_list_custom_widgets.dart';
import 'package:mydiaree/main.dart';

// ignore: must_be_immutable
class RoomsListScreen extends StatefulWidget {
  const RoomsListScreen({super.key});

  @override
  State<RoomsListScreen> createState() => _RoomsListScreenState();
}

class _RoomsListScreenState extends State<RoomsListScreen> {
  String searchString = '';

  bool roomsFetched = true;

  bool usersFetched = true;

  int currentIndex = 0;

  // Sample check values
  List statList = [];

  bool centersFetched = true;

  bool permissionAdd = true;

  bool permission = true;

  bool permissionDel = true;

  bool permissionupdate = true;

  List<String> selectedRooms = [];

  String? selectedStatus = 'Active';

  String selectedCenterId = '1';

  String? selectedCenterName;

  Future<void> deleteRooms(List<int> roomIds) async {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => const Center(child: CircularProgressIndicator()),
    );
    final response = await RoomRepository().deleteMultipleRooms(roomIds);

    Navigator.of(context, rootNavigator: true).pop();
    if (response.success) {
      UIHelpers.showToast(context, message: response.message);
      context
          .read<RoomListBloc>()
          .add(FetchRoomsEvent(centerId: selectedCenterId));
    } else {
      UIHelpers.showToast(context, message: response.message);
    }
  }

  final TextEditingController searchController = TextEditingController();

  initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context
          .read<RoomListBloc>()
          .add(FetchRoomsEvent(centerId: selectedCenterId));
    });
  }

  @override
  Widget build(BuildContext context) {
    return CustomScaffold(
      appBar: const CustomAppBar(title: "Rooms"),
      body: BlocConsumer<RoomListBloc, RoomListState>(
        listener: (context, state) {
          if (state is RoomDeletedState) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text("Rooms deleted successfully")),
            );
          } else if (state is AnnounceListError) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(state.message)),
            );
          }
        },
        builder: (context, state) {
          if (state is RoomListLoading) {
            return const Center(child: CircularProgressIndicator());
          } else if (state is AnnounceListError) {
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
                        Text('Rooms',
                            style: Theme.of(context).textTheme.headlineSmall),
                        const Spacer(),
                        if (selectedRooms.isNotEmpty)
                          Padding(
                            padding: const EdgeInsets.symmetric(vertical: 1.0),
                            child: CustomButton(
                              width: 130,
                              height: 35,
                              borderRadius: 10,
                              color: Colors.red,
                              text: 'Delete Selected',
                              ontap: () {
                                showDeleteConfirmationDialog(context, () async {
                                  // Convert selectedRooms to List<int>
                                  final roomIds = selectedRooms
                                      .map((id) => int.tryParse(id))
                                      .whereType<int>()
                                      .toList();

                                  Navigator.pop(context);
                                  await deleteRooms(roomIds);
                                  selectedRooms.clear();
                                });
                              },
                            ),
                          ),
                        SizedBox(width: 10),
                        if (permissionAdd)
                          UIHelpers.addButton(
                            context: context,
                            ontap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => AddRoomScreen(
                                    centerId: selectedCenterId ?? '',
                                    screenType: 'add',
                                  ),
                                ),
                              );
                            },
                          ),
                      ],
                    ),
                    const SizedBox(height: 5),
                    StatefulBuilder(builder: (context, setState) {
                      return CenterDropdown(
                        selectedCenterId: selectedCenterId,
                        onChanged: (value) {
                          setState(() {
                            selectedCenterId = value.id;
                          });
                          WidgetsBinding.instance.addPostFrameCallback((_) {
                            context.read<RoomListBloc>().add(
                                FetchRoomsEvent(centerId: selectedCenterId));
                          });
                        },
                      );
                    }),
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
                    CustomDropdown(
                      height: 35,
                      width: screenWidth * .3,
                      hint: 'Select',
                      onChanged: (value) {
                        selectedStatus = value;
                        setState(() {});
                      },
                      value: selectedStatus,
                      items: const <String>['Active', 'Inactive'],
                    ),
                    StatefulBuilder(builder: (context, setstateddd) {
                      final rooms = state.roomsData.rooms ?? [];

                      if(rooms.isEmpty) {
                        return SizedBox(
                          height: MediaQuery.of(context).size.height * 0.4,
                          child: const Center( 
                            child: Text('No rooms available'),
                          ),
                        );
                      }
                      return ListView.builder(
                        physics: const NeverScrollableScrollPhysics(),
                        shrinkWrap: true,
                        itemCount: rooms.length,
                        itemBuilder: (BuildContext context, int index) {
                          final room = rooms[index];
                          final roomId = room.id?.toString() ?? '';
                          final roomName = room.name ?? '';
                          final roomColor =
                              getColorFromHex(room.color ?? '#1711c1');
                          final userName = room.createdBy ?? '';
                          final status = room.status ?? '';
                          final educators = (room.educators != null)
                              ? List<String>.from(room.educators!
                                  .map((e) => e?.userid?.toString() ?? '')
                                  .where((id) => id.isNotEmpty)
                                  .toList())
                              : <String>[];

                          return InkWell(
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) =>
                                      ViewRoomScreen(room: room),
                                ),
                              );
                            },
                            child: RoomCard(
                              isSelected: selectedRooms.contains(roomId),
                              permissionUpdate: true,
                              onSelectionChanged: (bool selected) {
                                setstateddd(() {
                                  if (selected) {
                                    if (!selectedRooms.contains(roomId)) {
                                      selectedRooms.add(roomId);
                                    }
                                  } else {
                                    selectedRooms.remove(roomId);
                                  }
                                  setState(() {});
                                });
                              },
                              roomId: roomId,
                              roomName: roomName,
                              roomColor: roomColor,
                              userName: userName.toString(),
                              status: status,
                              educators: educators,
                              // onEditPressed: () {},
                            ),
                          );
                        },
                      );
                    }),
                    const SizedBox(height: 10),
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
}
