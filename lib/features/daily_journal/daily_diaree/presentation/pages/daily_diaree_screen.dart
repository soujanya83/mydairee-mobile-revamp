import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:mydiaree/core/cubit/globle_repository.dart';
import 'package:mydiaree/core/services/user_type_helper.dart';
import 'package:mydiaree/core/utils/ui_helper.dart';
import 'package:mydiaree/core/config/app_colors.dart';
import 'package:mydiaree/core/widgets/custom_app_bar.dart';
import 'package:mydiaree/core/widgets/custom_scaffold.dart';
import 'package:mydiaree/core/widgets/dropdowns/center_dropdown.dart';
import 'package:mydiaree/core/widgets/custom_dropdown.dart';
import 'package:mydiaree/features/room/data/repositories/room_repositories.dart';
import 'package:mydiaree/features/room/data/model/room_list_model.dart';
import 'package:mydiaree/features/daily_journal/daily_diaree/presentation/bloc/screen%20name/daily_diaree_bloc.dart';
import 'package:mydiaree/features/daily_journal/daily_diaree/presentation/bloc/screen%20name/daily_diaree_event.dart';
import 'package:mydiaree/features/daily_journal/daily_diaree/presentation/bloc/screen%20name/daily_diaree_state.dart';
import 'package:mydiaree/features/daily_journal/daily_diaree/presentation/widget/daily_diaree_custom.dart';
import 'package:mydiaree/main.dart';

class DailyTrackingScreen extends StatefulWidget {
  const DailyTrackingScreen({super.key});

  @override
  State<DailyTrackingScreen> createState() => _DailyTrackingScreenState();
}

class _DailyTrackingScreenState extends State<DailyTrackingScreen> {
  String selectedCenterId = '';
  String? selectedRoomId;
  DateTime selectedDate = DateTime.now();

  bool isLoadingRooms = true;
  List<Room> rooms = [];

  @override
  void initState() {
    super.initState();
    selectedCenterId = globalSelectedCenterId ?? '';
    _fetchRooms();
  }

  Future<void> _fetchRooms() async {
    setState(() => isLoadingRooms = true);
    try {
      final repo = RoomRepository();
      final resp = await repo.getRooms(centerId: selectedCenterId);
      print(
          'Rooms API response: success=${resp.success}, data=${resp.data?.rooms?.length}');
      if (resp.success && resp.data != null) {
        final fetched = resp.data!.rooms ?? [];
        if (kDebugMode) {
          print('Fetched rooms: ${fetched.map((r) => r.name).toList()}');
        }
        setState(() {
          rooms = fetched;
          if (rooms.isNotEmpty) {
            selectedRoomId = rooms.first.id.toString();
          }
        });
      }
    } catch (_) {
      setState(() {
        rooms = [];
        selectedRoomId = null;
      });
    } finally {
      _loadData();
      setState(() => isLoadingRooms = false);
    }
  }

  void _loadData() {
    if (selectedRoomId != null) {
      context.read<DailyTrackingBloc>().add(LoadDailyTrackingEvent(
            centerId: selectedCenterId,
            roomId: selectedRoomId!,
            date: selectedDate,
          ));
    }
  }

  @override
  Widget build(BuildContext context) {
    return CustomScaffold(
      appBar: const CustomAppBar(title: 'Daily Childcare Tracking'),
      body: Column(
        children: [
          // Filters: Center, Room, Date
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                GestureDetector(
                  onTap: () async {
                    final picked = await showDatePicker(
                      context: context,
                      initialDate: selectedDate,
                      firstDate:
                          DateTime.now().subtract(const Duration(days: 365)),
                      lastDate: DateTime.now().add(const Duration(days: 365)),
                    );
                    if (picked != null) {
                      setState(() => selectedDate = picked);
                      _loadData();
                    }
                  },
                  child: Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                    decoration: BoxDecoration(
                      border: Border.all(color: AppColors.primaryColor),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(DateFormat('dd-MM-yyyy').format(selectedDate)),
                  ),
                ),
              ],
            ),
          ),
          Column(
            children: [
              CenterDropdown(
                selectedCenterId: selectedCenterId,
                onChanged: (c) async {
                  selectedCenterId = c.id.toString();
                  selectedRoomId = null;
                  await _fetchRooms();
                  _loadData();
                },
              ),
              const SizedBox(height: 12),
              // only room‐loading spinner in the dropdown area
              if (isLoadingRooms)
                Center(
                    child: Container(
                  height: 50,
                  decoration: BoxDecoration(
                    border: Border.all(color: AppColors.grey),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: const Center(
                    child: CircularProgressIndicator(strokeWidth: 2),
                  ),
                ))
              else if (rooms.isEmpty)
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: CustomDropdown<Room>(
                    value: null,
                    items: const [],
                    hint: 'No rooms available here',
                    displayItem: (_) => '',
                    onChanged: null,
                  ),
                )
              else
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: CustomDropdown<Room>(
                    value: selectedRoomId == null
                        ? null
                        : rooms.firstWhere(
                            (r) => r.id.toString() == selectedRoomId,
                            orElse: () => rooms.first,
                          ),
                    items: rooms,
                    hint: 'Select Room',
                    displayItem: (r) => r.name ?? '',
                    onChanged: (r) {
                      setState(() {
                        selectedRoomId = r?.id.toString();
                      });
                      _loadData();
                    },
                  ),
                ),
              const SizedBox(width: 12),
            ],
          ),

          // Body: if no rooms show message, else let BlocBuilder handle its own loading
          Expanded(
            child: rooms.isEmpty &&
                    !(DailyTrackingBloc().state is DailyTrackingLoading)
                ? const Center(
                    child: Text(
                      'No rooms available for this center',
                      style: TextStyle(fontSize: 16),
                    ),
                  )
                : BlocListener<DailyTrackingBloc, DailyTrackingState>(
                    listener: (context, state) {
                      if (state is DailyTrackingError) {
                        //  UIHelpers.showToast(
                        //    context,
                        //    message: state.message,
                        //    backgroundColor: AppColors.errorColor,
                        //  );
                      }
                    },
                    child: BlocBuilder<DailyTrackingBloc, DailyTrackingState>(
                      builder: (context, state) {
                        // daily‐diary loading spinner
                        if (state is DailyTrackingLoading) {
                          return const Center(
                              child: CircularProgressIndicator());
                        }
                        if (state is DailyTrackingError) {
                          return const Center(
                              child: Text('Failed to load data'));
                        }
                        if (state is DailyTrackingLoaded) {
                          final children =
                              state.diareeData?.data?.children ?? [];
                          if (children.isEmpty) {
                            return const Center(
                                child: Text('No data available'));
                          }

                          return GridView.builder(
                            padding: const EdgeInsets.all(16),
                            gridDelegate:
                                const SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 1,
                              childAspectRatio: 0.7,
                              crossAxisSpacing: 16,
                              mainAxisSpacing: 16,
                            ),
                            itemCount: children.length,
                            itemBuilder: (c, i) {
                              final ce = children[i];
                              return ChildCard(
                                isCanAddEdit: !UserTypeHelper.isParent,
                                child: ce,
                                imageUrl: ce.child?.imageUrl ?? '',
                                date: DateFormat('yyyy-MM-dd')
                                    .format(selectedDate),
                                onAddEntriesPressed: () => _loadData(),
                                activitiesCount: 0,
                                meals: 0,
                                naps: 0,
                              );
                            },
                          );
                        }
                        return const SizedBox.shrink();
                      },
                    ),
                  ),
          ),
        ],
      ),
    );
  }
}
