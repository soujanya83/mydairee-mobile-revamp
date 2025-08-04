// accident_list_screen.dart

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mydiaree/core/config/app_colors.dart';
import 'package:mydiaree/core/utils/ui_helper.dart';
import 'package:mydiaree/core/widgets/custom_app_bar.dart';
import 'package:mydiaree/core/widgets/custom_background_widget.dart';
import 'package:mydiaree/core/widgets/custom_scaffold.dart';
import 'package:mydiaree/core/widgets/dropdowns/center_dropdown.dart';
import 'package:mydiaree/core/widgets/dropdowns/room_dropdown.dart';
import 'package:mydiaree/features/daily_journal/accident/data/models/accident_list_response_model.dart';
import 'package:mydiaree/features/daily_journal/accident/presentation/bloc/accident_list/accident_list_bloc.dart';
import 'package:mydiaree/features/daily_journal/accident/presentation/bloc/accident_list/accident_list_event.dart';
import 'package:mydiaree/features/daily_journal/accident/presentation/pages/accident/add_accident_screen.dart';

class AccidentListScreen extends StatefulWidget {
  const AccidentListScreen({super.key});

  @override
  State<AccidentListScreen> createState() => _AccidentListScreenState();
}

class _AccidentListScreenState extends State<AccidentListScreen> {
  String? selectedCenterId = '1'; // Default center
  String? selectedRoomId;
  final AccidentBloc _accidentBloc = AccidentBloc();
  
  @override
  void initState() {
    super.initState();
    _loadAccidents();
  }
  
  void _loadAccidents() {
    if (selectedCenterId != null && selectedRoomId != null) {
      _accidentBloc.add(LoadAccidentsEvent(
        centerId: selectedCenterId!,
        roomId: selectedRoomId!,
      ));
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => _accidentBloc,
      child: CustomScaffold(
        appBar: const CustomAppBar(title: 'Accident List'),
        body: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(20.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('Accidents', style: Theme.of(context).textTheme.titleLarge),
                  UIHelpers.addButton(
                    context: context,
                    ontap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => AddAccidentScreen(
                            centerid: selectedCenterId ?? '1',
                            roomid: selectedRoomId ?? '',
                            accid: '',
                            type: 'add',
                          ),
                        ),
                      ).then((_) => _loadAccidents());
                    },
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  CenterDropdown(
                    selectedCenterId: selectedCenterId,
                    onChanged: (value) {
                      setState(() {
                        selectedCenterId = value.id.toString();
                        selectedRoomId = null; // Reset room when center changes
                      });
                    },
                  ),
                  const SizedBox(height: 16),
                  // if (selectedCenterId != null)
                  //   RoomDropdown(
                  //     centerId: selectedCenterId!,
                  //     selectedRoomId: selectedRoomId,
                  //     onChanged: (room) {
                  //       setState(() {
                  //         selectedRoomId = room.id.toString();
                  //       });
                  //       _loadAccidents();
                  //     },
                  //   ),
                ],
              ),
            ),
            const SizedBox(height: 20),
            Expanded(
              child: BlocBuilder<AccidentBloc, AccidentState>(
                builder: (context, state) {
                  if (state is AccidentLoadingState) {
                    return const Center(child: CircularProgressIndicator());
                  } else if (state is AccidentLoadedState) {
                    if (state.accidents.isEmpty) {
                      return const Center(child: Text('No accidents found.'));
                    }
                    
                    return ListView.builder(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      itemCount: state.accidents.length,
                      itemBuilder: (context, index) {
                        final accident = state.accidents[index];
                        return Padding(
                          padding: const EdgeInsets.only(bottom: 12),
                          child: PatternBackground(
                            elevation: 1,
                            borderRadius: BorderRadius.circular(8),
                            child: ListTile(
                              contentPadding: const EdgeInsets.symmetric(
                                horizontal: 16,
                                vertical: 10,
                              ),
                              leading: CircleAvatar(
                                backgroundColor: AppColors.primaryColor.withOpacity(.3),
                                child: Text(
                                  '${index + 1}',
                                  style: const TextStyle(
                                    color: AppColors.primaryColor,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                              title: GestureDetector(
                                onTap: () {
                                  // Navigator.push(
                                  //   context,
                                  //   MaterialPageRoute(
                                  //     builder: (context) => AccidentDetailScreen(
                                  //       accidentId: accident.id.toString(),
                                  //       centerId: selectedCenterId ?? '1',
                                  //       roomId: selectedRoomId ?? '',
                                  //     ),
                                  //   ),
                                  // ).then((_) => _loadAccidents());
                                },
                                child: Text(
                                  accident.childName,
                                  style: const TextStyle(
                                    color: AppColors.primaryColor,
                                    fontWeight: FontWeight.w600,
                                    fontSize: 16,
                                  ),
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
                                        fontSize: 13,
                                        color: Colors.black87,
                                      ),
                                    ),
                                    const SizedBox(height: 2),
                                    Text(
                                      'Incident Date: ${accident.incidentDate}',
                                      style: const TextStyle(
                                        fontSize: 12,
                                        color: Colors.grey,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              trailing: Container(
                                height: 40,
                                width: 40,
                                decoration: BoxDecoration(
                                  color: AppColors.grey.withOpacity(.3),
                                  shape: BoxShape.circle,
                                ),
                                child: IconButton(
                                  icon: const Icon(Icons.edit, color: AppColors.black),
                                  onPressed: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => AddAccidentScreen(
                                          centerid: selectedCenterId ?? '1',
                                          roomid: selectedRoomId ?? '',
                                          accid: accident.id.toString(),
                                          type: 'edit',
                                        ),
                                      ),
                                    ).then((_) => _loadAccidents());
                                  },
                                ),
                              ),
                            ),
                          ),
                        );
                      },
                    );
                  } else if (state is AccidentErrorState) {
                    return Center(child: Text(state.message));
                  }
                  
                  return const Center(
                    child: Text('Please select a center and room to view accidents'),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
