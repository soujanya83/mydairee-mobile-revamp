import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:mydiaree/core/config/app_colors.dart';
import 'package:mydiaree/core/services/user_type_helper.dart';
import 'package:mydiaree/core/utils/ui_helper.dart';
import 'package:mydiaree/core/widgets/custom_app_bar.dart';
import 'package:mydiaree/core/widgets/custom_background_widget.dart';
import 'package:mydiaree/core/widgets/custom_dropdown.dart';
import 'package:mydiaree/core/widgets/custom_scaffold.dart';
import 'package:mydiaree/core/widgets/dropdowns/center_dropdown.dart';
import 'package:mydiaree/features/daily_journal/accident/data/models/accident_list_response_model.dart';
import 'package:mydiaree/features/daily_journal/accident/data/repositories/accident_repo.dart';
import 'package:mydiaree/features/daily_journal/accident/presentation/bloc/accident_list/accident_list_bloc.dart';
import 'package:mydiaree/features/daily_journal/accident/presentation/bloc/accident_list/accident_list_event.dart';
import 'package:mydiaree/features/daily_journal/accident/presentation/bloc/accident_list/accident_list_state.dart';
import 'package:mydiaree/features/daily_journal/accident/presentation/pages/accident/add_accident_screen.dart';
import 'package:mydiaree/features/room/data/repositories/room_repositories.dart';

import '../../../../room/data/model/room_list_model.dart';

class AccidentListScreen extends StatefulWidget {
  const AccidentListScreen({Key? key}) : super(key: key);

  @override
  State<AccidentListScreen> createState() => _AccidentListScreenState();
}

class _AccidentListScreenState extends State<AccidentListScreen> {
  String? selectedCenterId = '1'; // Default center
  String? selectedRoomId;
  List<Room> rooms = [];
  bool isLoadingRooms = true;

  @override
  void initState() {
    super.initState();
    _fetchRooms();
  }

  Future<void> _fetchRooms() async {
    setState(() {
      isLoadingRooms = true;
    });

    try {
      final roomRepository = RoomRepository();
      final roomsResponse = await roomRepository.getRooms(centerId: selectedCenterId.toString());
      
      if (roomsResponse.success && roomsResponse.data != null) {
        setState(() {
          rooms = roomsResponse.data!.rooms ?? [];
          if (rooms.isNotEmpty) {
            selectedRoomId = rooms.first.id.toString();
          }
        });
      }
    } catch (e) {
    } finally {
      setState(() {
        isLoadingRooms = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => AccidentListBloc()
        ..add(
          FetchAccidentsEvent(
            centerId: selectedCenterId ?? '1',
            roomId: selectedRoomId,
          ),
        ),
      child: CustomScaffold(
        appBar: const CustomAppBar(title: 'Accident List'),
        body: Column(
          children: [
            // 1. Add Accident Button at the top
            Padding(
              padding: const EdgeInsets.all(20.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('Accidents', style: Theme.of(context).textTheme.bodyLarge),
                  if (!UserTypeHelper.isParent)
                  UIHelpers.addButton(
                    context: context,
                    ontap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => AddAccidentScreen(
                            centerid: selectedCenterId ?? '',
                            roomid: selectedRoomId ?? '',
                          ),
                        ),
                      ).then((_) {
                        context.read<AccidentListBloc>().add(
                              FetchAccidentsEvent(
                                centerId: selectedCenterId ?? '1',
                                roomId: selectedRoomId,
                              ),
                            );
                      });
                    },
                  ),
                ],
              ),
            ),

            // 2. Center Dropdown
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: CenterDropdown(
                selectedCenterId: selectedCenterId,
                onChanged: (center) async {
                  setState(() {
                    selectedCenterId = center.id.toString();
                    selectedRoomId = null;
                    rooms = [];
                  });
                  
                  await _fetchRooms();
                  context.read<AccidentListBloc>().add(
                        FetchAccidentsEvent(
                          centerId: selectedCenterId!,
                          roomId: selectedRoomId,
                        ),
                      );
                },
              ),
            ),
            const SizedBox(height: 16),

            // 3. Room Dropdown
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: isLoadingRooms
                ? Container(
                    height: 50,
                    decoration: BoxDecoration(
                      border: Border.all(color: AppColors.grey),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: const Center(
                      child: CircularProgressIndicator(strokeWidth: 2),
                    ),
                  )
                : rooms.isEmpty
                  ? Container(
                      height: 50,
                      decoration: BoxDecoration(
                        border: Border.all(color: AppColors.grey),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: const Center(
                        child: Text('No rooms available for this center'),
                      ),
                    )
                  : CustomDropdown<Room>(
                      value: selectedRoomId == null
                          ? rooms.first
                          : rooms.firstWhere(
                              (room) => room.id.toString() == selectedRoomId,
                              orElse: () => rooms.first,
                            ),
                      items: rooms,
                      hint: 'Select Room',
                      borderColor: AppColors.primaryColor,
                      displayItem: (room) => room.name ?? '',
                      onChanged: (room) {
                        if (room != null) {
                          setState(() {
                            selectedRoomId = room.id.toString();
                          });
                          
                          // Update the accident list with the new room
                          context.read<AccidentListBloc>().add(
                                FetchAccidentsEvent(
                                  centerId: selectedCenterId!,
                                  roomId: selectedRoomId,
                                ),
                              );
                        }
                      },
                    ),
            ),
            const SizedBox(height: 16),

            // 4. Accident List (with loading indicator only for this section)
            Expanded(
              child: BlocBuilder<AccidentListBloc, AccidentListState>(
                builder: (context, state) {
                  if (state is AccidentListLoading) {
                    return const Center(child: CircularProgressIndicator());
                  } else if (state is AccidentListLoaded) {
                    final accidents = state.filteredAccidents;

                    if (accidents.isEmpty) {
                      return const Center(child: Text('No accidents found'));
                    }

                    return ListView.builder(
                      itemCount: accidents.length,
                      itemBuilder: (context, index) {
                        final accident = accidents[index];
                        return Padding(
                          padding: const EdgeInsets.only(
                              top: 8, left: 20, right: 20, bottom: 8),
                          child: PatternBackground(
                            elevation: 1,
                            borderRadius: BorderRadius.circular(5),
                            child: ListTile(
                              contentPadding: const EdgeInsets.symmetric(
                                  horizontal: 16, vertical: 10),
                              leading: CircleAvatar(
                                backgroundColor: AppColors.primaryColor
                                    .withOpacity(.3),
                                child: Text(
                                  '${index + 1}',
                                  style: const TextStyle(
                                      color: Colors.blue,
                                      fontWeight: FontWeight.bold),
                                ),
                              ),
                              title: Text(
                                accident.child_name,
                                style: const TextStyle(
                                  color: AppColors.primaryColor,
                                  fontWeight: FontWeight.w600,
                                  fontSize: 16,
                                ),
                              ),
                              subtitle: Padding(
                                padding: const EdgeInsets.only(top: 6.0),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      'Created By: ${accident.username}',
                                      style: const TextStyle(
                                          fontSize: 13, color: Colors.black87),
                                    ),
                                    const SizedBox(height: 2),
                                    Text(
                                      _formatDate(accident.incident_date),
                                      style: const TextStyle(
                                          fontSize: 12, color: Colors.grey),
                                    ),
                                  ],
                                ),
                              ),
                              // hide edit icon for parents
                              trailing: UserTypeHelper.isParent
                                  ? null
                                  : Container(
                                      height: 40,
                                      width: 40,
                                      decoration: BoxDecoration(
                                        color: AppColors.grey.withOpacity(.3),
                                        shape: BoxShape.circle,
                                      ),
                                      child: IconButton(
                                        icon: const Icon(Icons.edit,
                                            color: AppColors.black),
                                        onPressed: () {
                                          Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                              builder: (context) =>
                                                  AddAccidentScreen(
                                                centerid:
                                                    selectedCenterId ?? '',
                                                roomid:
                                                    accident.roomid.toString(),
                                                accidentId:
                                                    accident.id.toString(),
                                                isEditing: true,
                                              ),
                                            ),
                                          ).then((_) {
                                            context
                                                .read<AccidentListBloc>()
                                                .add(
                                                  FetchAccidentsEvent(
                                                    centerId:
                                                        selectedCenterId ??
                                                            '1',
                                                    roomId: selectedRoomId,
                                                  ),
                                                );
                                          });
                                        },
                                      ),
                                    ),
                              onTap: () {
                                // view-only for parents, edit/view screen for others
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => AddAccidentScreen(
                                      centerid: selectedCenterId ?? '',
                                      roomid: selectedRoomId ?? '',
                                      accidentId: accident.id.toString(),
                                      isEditing:
                                        !UserTypeHelper.isParent, // disable edit if parent
                                    ),
                                  ),
                                );
                              },
                            ),
                          ),
                        );
                      },
                    );
                  } else if (state is AccidentListError) {
                    return Center(child: Text(state.message));
                  }
                  return const SizedBox.shrink();
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  String _formatDate(String dateStr) {
    try {
      final date = DateTime.parse(dateStr);
      return DateFormat('MMM dd, yyyy').format(date);
    } catch (e) {
      return dateStr;
    }
  }
}
