import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mydiaree/core/utils/helper_functions.dart';
import 'package:mydiaree/core/utils/ui_helper.dart';
import 'package:mydiaree/core/widgets/custom_app_bar.dart';
import 'package:mydiaree/core/widgets/custom_dropdown.dart';
import 'package:mydiaree/core/widgets/custom_scaffold.dart';
import 'package:mydiaree/core/widgets/custom_text_field.dart';
import 'package:mydiaree/core/widgets/dropdowns/center_dropdown.dart';
import 'package:mydiaree/features/room/presentation/bloc/list_room/list_room_bloc.dart';
import 'package:mydiaree/features/room/presentation/bloc/list_room/list_room_event.dart';
import 'package:mydiaree/features/room/presentation/bloc/list_room/list_room_state.dart';
import 'package:mydiaree/features/room/presentation/pages/add_room_screen.dart';
import 'package:mydiaree/features/room/presentation/widget/room_list_custom_widgets.dart';
import 'package:mydiaree/main.dart';

// ignore: must_be_immutable
class RoomsListScreen extends StatelessWidget {
  RoomsListScreen({super.key});

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

  String? selectedCenterId;

  String? selectedCenterName;
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
                    CenterDropdown(
                      onChanged: (value) {
                        selectedCenterId = value.id;
                      },
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
                        hint: 'Select',
                        onChanged: (value) {
                          selectedStatus = value;
                          setstateddd(
                            () {},
                          );
                        },
                        value: selectedStatus,
                        items: const <String>['Active', 'Inactive'],
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
                              if (selected) {
                                if (true) {
                                  selectedRooms
                                      .add(state.roomsData.rooms[index].id);
                                  setstateddd(
                                    () {},
                                  );
                                }
                              } else {
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
                            onEditPressed: () {
                              Map<String, dynamic>? existingRoomData = {
                                'id': state.roomsData.rooms[index].id,
                                'centerId': selectedCenterId,
                                'name': state.roomsData.rooms[index].name,
                                'color': getColorValue(
                                    state.roomsData.rooms[index].color),
                                'status': state.roomsData.rooms[index].status,
                                'educatorIds':
                                    state.roomsData.rooms[index].educatorIds,
                                'capacity': state.roomsData.rooms[index].capacity,
                                'ageFrom': state.roomsData.rooms[index].ageFrom,
                                'ageTo': state.roomsData.rooms[index].ageTo,
                              };
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => AddRoomScreen(
                                    centerId: selectedCenterId??'',
                                     screenType: 'edit',
                                    room: existingRoomData,
                                  ),
                                ),
                              );
                            },
                            roomId: state.roomsData.rooms[index].id,
                            roomName: state.roomsData.rooms[index].name,
                            roomColor: getColorValue(
                                    state.roomsData.rooms[index].color)
                                .toString(),
                            userName: state.roomsData.rooms[index].userName,
                            status: state.roomsData.rooms[index].status,
                            educators: state.roomsData.rooms[index].educatorIds,
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
                            showDeleteConfirmationDialog(context, () {
                              context
                                  .read<RoomListBloc>()
                                  .add(DeleteSelectedRoomsEvent(selectedRooms));
                              Navigator.pop(context);
                            });
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
}
