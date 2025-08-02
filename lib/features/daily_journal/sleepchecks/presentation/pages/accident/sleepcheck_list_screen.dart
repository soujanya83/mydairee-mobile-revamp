// accident_list_screen.dart

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mydiaree/core/config/app_colors.dart';
import 'package:mydiaree/core/utils/ui_helper.dart';
import 'package:mydiaree/core/widgets/custom_app_bar.dart';
import 'package:mydiaree/core/widgets/custom_background_widget.dart';
import 'package:mydiaree/core/widgets/custom_buton.dart';
import 'package:mydiaree/core/widgets/custom_network_image.dart';
import 'package:mydiaree/core/widgets/custom_scaffold.dart';
import 'package:mydiaree/core/widgets/dropdowns/center_dropdown.dart';
import 'package:mydiaree/core/widgets/dropdowns/room_dropdown.dart';
import 'package:intl/intl.dart';
import 'package:mydiaree/core/widgets/custom_dropdown.dart';
import 'package:mydiaree/features/daily_journal/sleepchecks/presentation/bloc/accident_list/sleepchecks_list_event.dart';
import 'package:mydiaree/features/daily_journal/sleepchecks/presentation/bloc/accident_list/sleepcheks_list_bloc.dart';
import 'package:mydiaree/features/daily_journal/sleepchecks/presentation/bloc/accident_list/sleepcheks_list_state.dart';

class SleepCheckListScreen extends StatefulWidget {
  const SleepCheckListScreen({super.key});

  @override
  _SleepCheckListScreenState createState() => _SleepCheckListScreenState();
}

class _SleepCheckListScreenState extends State<SleepCheckListScreen> {
  final List<String> breathingOptions = ['Regular', 'Fast', 'Difficult'];
  final List<String> bodyTempOptions = ['Warm', 'Cool', 'Hot'];
  List<String>? hours;
  List<String>? minutes;
  DateTime? date;
  int currentIndex = 0;
  int currentRoomIndex = 0;
  int currentAddIndex = -1;
  String addSleepHour = '';
  String addSleepMinute = '';
  String addBreathing = '';
  String addTemperature = '';
  TextEditingController addNotesController = TextEditingController();
  String? selectedCenterId;
  String? selectedRoomId;
  @override
  void initState() {
    super.initState();
    hours = List<String>.generate(24, (counter) => "${counter + 1}");
    minutes = List<String>.generate(60, (counter) => "$counter");
    date = DateTime.now();
  }

  String formatTimeString(String inputTime) {
    try {
      String cleaned = inputTime.replaceAll(RegExp(r'[^0-9:]'), '');
      List<String> parts = cleaned.split(':');
      if (parts.length != 2) {
        throw FormatException('Invalid time format');
      }
      int hours = int.tryParse(parts[0]) ?? 0;
      int minutes = int.tryParse(parts[1]) ?? 0;
      if (hours < 0 || hours > 23 || minutes < 0 || minutes > 59) {
        throw FormatException('Time values out of range');
      }
      return '${hours.toString().padLeft(2, '0')}:${minutes.toString().padLeft(2, '0')}';
    } catch (e) {
      print('Error formatting time: $e');
      return '00:00';
    }
  }

  @override
  Widget build(BuildContext context) {
    // Fetch sleep checklist when the screen is first built
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final bloc = context.read<SleepChecklistBloc>();
      bloc.add(FetchSleepChecklistEvent(
        userId: '',
        centerId: selectedCenterId ?? '',
        roomId: selectedRoomId ?? '',
        date: DateTime.now(),
      ));
    });
    return CustomScaffold(
      appBar: const CustomAppBar(title: 'Sleep Check List'),
      // drawer: GetDrawer(),
      body: BlocListener<SleepChecklistBloc, SleepChecklistState>(
        listener: (context, state) {
          if (state is SleepChecklistFailure) {
            UIHelpers.showToast(
              context,
              message: state.error,
              backgroundColor: AppColors.errorColor,
            );
          } else if (state is SleepChecklistSuccess) {
            UIHelpers.showToast(
              context,
              message: state.message,
              backgroundColor: AppColors.successColor,
            );
          }
          //  else if (state is CentersLoaded && state.centers.isNotEmpty) {
          //   context.read<SleepChecklistBloc>().add(FetchRoomsEvent(
          //         userId: MyApp.LOGIN_ID_VALUE,
          //         centerId: state.centers[currentIndex].id,
          //       ));
          // } else if (state is RoomsLoaded && state.rooms.isNotEmpty) {
          //   context.read<SleepChecklistBloc>().add(FetchSleepChecklistEvent(
          //         userId: MyApp.LOGIN_ID_VALUE,
          //         centerId: state.rooms[currentRoomIndex].centerid,
          //         roomId: state.rooms[currentRoomIndex].id,
          //         date: date!,
          //       ));
          // }
        },
        child: SingleChildScrollView(
          padding: EdgeInsets.all(MediaQuery.of(context).size.width * 0.03),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Text('Sleep Check List',
                      style: Theme.of(context).textTheme.headlineSmall),
                  const Spacer(),

                  // CustomDatePicker(
                  //   title: '',
                  //   selectedDate: date,
                  //   onDateSelected: (selectedDate) {
                  //     setState(() => date = selectedDate);
                  //     if (date != null) {
                  //       context.read<SleepChecklistBloc>().add(FetchSleepChecklistEvent(
                  //             userId: MyApp.LOGIN_ID_VALUE,
                  //             centerId: currentIndex < (context.read<SleepChecklistBloc>().state as CentersLoaded).centers.length
                  //                 ? (context.read<SleepChecklistBloc>().state as CentersLoaded).centers[currentIndex].id
                  //                 : '',
                  //             roomId: currentRoomIndex < (context.read<SleepChecklistBloc>().state as RoomsLoaded).rooms.length
                  //                 ? (context.read<SleepChecklistBloc>().state as RoomsLoaded).rooms[currentRoomIndex].id
                  //                 : '',
                  //             date: date!,
                  //           ));
                  //     }
                  //   },
                  // ),
                ],
              ),
              const SizedBox(
                height: 10,
              ),
              StatefulBuilder(builder: (context, setState) {
                return CenterDropdown(
                  selectedCenterId: selectedCenterId,
                  onChanged: (value) {
                    setState(
                      () {
                        selectedCenterId = value.id;
                      },
                    );
                  },
                );
              }),
              // Text('Room', style: Theme.of(context).textTheme.bodyMedium),
              const SizedBox(height: 6),
              // StatefulBuilder(builder: (context, setState) {
              //   return RoomDropdown(
              //     selectedRoomId: selectedRoomId,
              //     onChanged: (room) {
              //       setState(() {
              //         selectedRoomId = room.id;
              //       });
              //     },
              //   );
              // }),
              const SizedBox(height: 10),
              BlocBuilder<SleepChecklistBloc, SleepChecklistState>(
                builder: (context, state) {
                  if (state is SleepChecklistLoading) {
                    return SizedBox(
                      height: MediaQuery.of(context).size.height * 0.7,
                      child: const Center(child: CircularProgressIndicator()),
                    );
                  } else if (state is SleepChecklistLoaded) {
                    return ListView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: state.sleepChecks.length,
                      itemBuilder: (context, parentalIndex) {
                        final child = state.sleepChecks[parentalIndex];
                        return Padding(
                          padding: const EdgeInsets.only(top: 10, bottom: 10),
                          child: PatternBackground(
                            child: Column(
                              children: [
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Row(
                                    children: [
                                      Container(
                                        width: 50,
                                        height: 50,
                                        decoration: BoxDecoration(
                                          shape: BoxShape.circle,
                                          border: Border.all(
                                              color: Colors.grey, width: 1.0),
                                        ),
                                        child: const CustomNetworkImage(
                                          imageUrl: '',
                                        ),
                                      ),
                                      const SizedBox(width: 20),
                                      Text(
                                        child.name,
                                        style: Theme.of(context)
                                            .textTheme
                                            .titleMedium,
                                      ),
                                    ],
                                  ),
                                ),
                                const Divider(),
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: ListView.builder(
                                    shrinkWrap: true,
                                    physics:
                                        const NeverScrollableScrollPhysics(),
                                    itemCount: child.sleepChecks.length + 1,
                                    itemBuilder: (context, internalIndex) {
                                      if (internalIndex <
                                          child.sleepChecks.length) {
                                        final sleepCheck =
                                            child.sleepChecks[internalIndex];
                                        String sleepHour = sleepCheck
                                                .time.isNotEmpty
                                            ? '${int.parse(sleepCheck.time.split(':')[0])}'
                                            : hours![0];
                                        String sleepMinute = sleepCheck
                                                .time.isNotEmpty
                                            ? '${int.parse(sleepCheck.time.split(':')[1])}'
                                            : minutes![0];
                                        TextEditingController notesController =
                                            TextEditingController(
                                                text: sleepCheck.notes);
                                        return Padding(
                                          padding: const EdgeInsets.all(5.0),
                                          child: PatternBackground(
                                            child: Padding(
                                              padding:
                                                  const EdgeInsets.all(12.0),
                                              child: Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  CustomTimePicker(
                                                    title: 'Time',
                                                    selectedHour: sleepHour,
                                                    selectedMinute: sleepMinute,
                                                    hours: hours,
                                                    minutes: minutes,
                                                    onHourChanged: (value) {
                                                      sleepCheck.time =
                                                          formatTimeString(
                                                              '$value:${sleepMinute.replaceAll('m', '')}');
                                                      setState(() {});
                                                    },
                                                    onMinuteChanged: (value) {
                                                      sleepCheck.time =
                                                          formatTimeString(
                                                              '$sleepHour:${value!.replaceAll('m', '')}');
                                                      setState(() {});
                                                    },
                                                  ),
                                                  const SizedBox(height: 15),
                                                  Row(
                                                    children: [
                                                      Expanded(
                                                        child: Column(
                                                          crossAxisAlignment:
                                                              CrossAxisAlignment
                                                                  .start,
                                                          children: [
                                                            Text('Breathing',
                                                                style: Theme.of(context)
                                                                    .textTheme
                                                                    .bodyMedium),
                                                            const SizedBox(
                                                                height: 5),
                                                            CustomDropdown(
                                                              height: 40,
                                                              value: breathingOptions
                                                                      .contains(
                                                                          sleepCheck
                                                                              .breathing)
                                                                  ? sleepCheck
                                                                      .breathing
                                                                  : null,
                                                              items:
                                                                  breathingOptions,
                                                              hint: 'Select',
                                                              onChanged:
                                                                  (value) {
                                                                sleepCheck
                                                                        .breathing =
                                                                    value!;
                                                                setState(() {});
                                                              },
                                                            ),
                                                          ],
                                                        ),
                                                      ),
                                                      const SizedBox(width: 10),
                                                      Expanded(
                                                        child: Column(
                                                          crossAxisAlignment:
                                                              CrossAxisAlignment
                                                                  .start,
                                                          children: [
                                                            Text('Body Temperature',
                                                                style: Theme.of(
                                                                        context)
                                                                    .textTheme
                                                                    .bodyMedium),
                                                            const SizedBox(
                                                                height: 5),
                                                            CustomDropdown(
                                                              height: 40,
                                                              value: bodyTempOptions
                                                                      .contains(
                                                                          sleepCheck
                                                                              .bodyTemperature)
                                                                  ? sleepCheck
                                                                      .bodyTemperature
                                                                  : null,
                                                              items:
                                                                  bodyTempOptions,
                                                              hint: 'Select',
                                                              onChanged:
                                                                  (value) {
                                                                sleepCheck
                                                                        .bodyTemperature =
                                                                    value!;
                                                                setState(() {});
                                                              },
                                                            ),
                                                          ],
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                  const SizedBox(height: 15),
                                                  Text('Notes',
                                                      style: Theme.of(context)
                                                          .textTheme
                                                          .bodyMedium),
                                                  const SizedBox(height: 5),
                                                  TextField(
                                                    controller: notesController,
                                                    maxLines: 2,
                                                    onChanged: (value) =>
                                                        sleepCheck.notes =
                                                            value,
                                                    decoration:
                                                        const InputDecoration(
                                                      enabledBorder:
                                                          OutlineInputBorder(
                                                        borderSide: BorderSide(
                                                            color:
                                                                Colors.black26,
                                                            width: 0.0),
                                                      ),
                                                      border:
                                                          OutlineInputBorder(
                                                        borderRadius:
                                                            BorderRadius.all(
                                                                Radius.circular(
                                                                    4)),
                                                      ),
                                                    ),
                                                  ),
                                                  const SizedBox(height: 10),
                                                  Row(
                                                    children: [
                                                      CustomButton(
                                                        height: 40,
                                                        width: 80,
                                                        text: 'UPDATE',
                                                        ontap: () {
                                                          context
                                                              .read<
                                                                  SleepChecklistBloc>()
                                                              .add(
                                                                  UpdateSleepCheckEvent(
                                                                userId: '',
                                                                id: sleepCheck
                                                                    .id,
                                                                childId:
                                                                    sleepCheck
                                                                        .childId,
                                                                roomId:
                                                                    sleepCheck
                                                                        .roomId,
                                                                diaryDate:
                                                                    date!,
                                                                time: sleepCheck
                                                                    .time,
                                                                breathing:
                                                                    sleepCheck
                                                                        .breathing,
                                                                bodyTemperature:
                                                                    sleepCheck
                                                                        .bodyTemperature,
                                                                notes:
                                                                    sleepCheck
                                                                        .notes,
                                                                centerId: '',
                                                              ));
                                                        },
                                                      ),
                                                      const SizedBox(width: 10),
                                                      CustomButton(
                                                        height: 40,
                                                        width: 80,
                                                        text: 'DELETE',
                                                        color: Colors.red,
                                                        ontap: () {
                                                          context
                                                              .read<
                                                                  SleepChecklistBloc>()
                                                              .add(
                                                                  DeleteSleepCheckEvent(
                                                                userId: '',
                                                                id: sleepCheck
                                                                    .id,
                                                                centerId: '',
                                                                roomId:
                                                                    child.room,
                                                                diaryDate:
                                                                    date!,
                                                              ));
                                                        },
                                                      ),
                                                    ],
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ),
                                        );
                                      } else {
                                        if (currentAddIndex == parentalIndex) {
                                          return _buildAddWidget(
                                            context,
                                            roomId: child.room,
                                            childId: child.id,
                                            centerId: '',
                                          );
                                        }
                                        return Column(
                                          children: [
                                            const SizedBox(height: 20),
                                            Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              children: [
                                                Text('ADD SLEEP CHECK',
                                                    style: Theme.of(context)
                                                        .textTheme
                                                        .titleMedium),
                                                CustomButton(
                                                  height: 40,
                                                  width: 80,
                                                  text: 'ADD',
                                                  ontap: () {
                                                    setState(() {
                                                      currentAddIndex =
                                                          parentalIndex;
                                                      addSleepHour = hours![0];
                                                      addSleepMinute =
                                                          minutes![0];
                                                      addBreathing =
                                                          breathingOptions[0];
                                                      addTemperature =
                                                          bodyTempOptions[0];
                                                      addNotesController
                                                          .clear();
                                                    });
                                                  },
                                                ),
                                              ],
                                            ),
                                          ],
                                        );
                                      }
                                    },
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    );
                  }
                  return const SizedBox.shrink();
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildAddWidget(BuildContext context,
      {required String roomId,
      required String childId,
      required String centerId}) {
    return PatternBackground(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('ADD NEW SLEEP CHECK',
                style: Theme.of(context).textTheme.titleMedium),
            const SizedBox(height: 10),
            CustomTimePicker(
              title: 'Time',
              selectedHour: addSleepHour,
              selectedMinute: addSleepMinute,
              hours: hours,
              minutes: minutes,
              onHourChanged: (value) => setState(() => addSleepHour = value!),
              onMinuteChanged: (value) =>
                  setState(() => addSleepMinute = value!),
            ),
            const SizedBox(height: 15),
            Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Breathing',
                          style: Theme.of(context).textTheme.bodyMedium),
                      const SizedBox(height: 5),
                      CustomDropdown(
                        height: 40,
                        value: breathingOptions.contains(addBreathing)
                            ? addBreathing
                            : null,
                        items: breathingOptions,
                        hint: 'Select',
                        onChanged: (value) =>
                            setState(() => addBreathing = value!),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Body Temperature',
                          style: Theme.of(context).textTheme.bodyMedium),
                      const SizedBox(height: 5),
                      CustomDropdown(
                        height: 40,
                        value: bodyTempOptions.contains(addTemperature)
                            ? addTemperature
                            : null,
                        items: bodyTempOptions,
                        hint: 'Select',
                        onChanged: (value) =>
                            setState(() => addTemperature = value!),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 15),
            Text('Notes', style: Theme.of(context).textTheme.bodyMedium),
            const SizedBox(height: 5),
            TextField(
              controller: addNotesController,
              maxLines: 2,
              decoration: const InputDecoration(
                enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.black26, width: 0.0),
                ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(4)),
                ),
              ),
            ),
            const SizedBox(height: 10),
            Row(
              children: [
                CustomButton(
                  height: 40,
                  width: 80,
                  text: 'ADD',
                  ontap: () {
                    if (addSleepHour.isNotEmpty &&
                        addSleepMinute.isNotEmpty &&
                        addBreathing.isNotEmpty &&
                        addTemperature.isNotEmpty) {
                      context.read<SleepChecklistBloc>().add(AddSleepCheckEvent(
                            userId: '',
                            childId: childId,
                            roomId: roomId,
                            diaryDate: date!,
                            time: formatTimeString(
                                '$addSleepHour:$addSleepMinute'),
                            breathing: addBreathing,
                            bodyTemperature: addTemperature,
                            notes: addNotesController.text,
                            centerId: centerId,
                          ));
                      setState(() => currentAddIndex = -1);
                    } else {
                      UIHelpers.showToast(
                        context,
                        message: 'Please fill all required fields',
                        backgroundColor: AppColors.errorColor,
                      );
                    }
                  },
                ),
                const SizedBox(width: 10),
                CustomButton(
                  height: 40,
                  width: 80,
                  text: 'CANCEL',
                  color: Colors.grey,
                  ontap: () => setState(() => currentAddIndex = -1),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

// Custom Date Picker Widget
class CustomDatePicker extends StatelessWidget {
  final String title;
  final DateTime? selectedDate;
  final Function(DateTime?) onDateSelected;

  const CustomDatePicker({
    super.key,
    required this.title,
    required this.selectedDate,
    required this.onDateSelected,
  });

  Future<DateTime?> _selectDate(
      BuildContext context, DateTime initialDate) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: initialDate,
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );
    return picked;
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (title.isNotEmpty)
          Text(title, style: Theme.of(context).textTheme.bodyMedium),
        if (title.isNotEmpty) const SizedBox(height: 6),
        GestureDetector(
          onTap: () async {
            final date =
                await _selectDate(context, selectedDate ?? DateTime.now());
            if (date != null) onDateSelected(date);
          },
          child: Container(
            height: 35,
            width: 120,
            decoration: BoxDecoration(
              border: Border.all(color: AppColors.grey),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8.0),
              child: Row(
                children: [
                  Text(
                    selectedDate != null
                        ? DateFormat("dd-MM-yyyy").format(selectedDate!)
                        : 'Select Date',
                    style: const TextStyle(fontSize: 14.0),
                  ),
                  const Spacer(),
                  const Icon(Icons.calendar_today, color: Colors.grey),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}

// Custom Time Picker Widget
class CustomTimePicker extends StatelessWidget {
  final String title;
  final String? selectedHour;
  final String? selectedMinute;
  final List<String>? hours;
  final List<String>? minutes;
  final Function(String?) onHourChanged;
  final Function(String?) onMinuteChanged;

  const CustomTimePicker({
    super.key,
    required this.title,
    required this.selectedHour,
    required this.selectedMinute,
    required this.hours,
    required this.minutes,
    required this.onHourChanged,
    required this.onMinuteChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(title, style: Theme.of(context).textTheme.bodyMedium),
        const SizedBox(height: 6),
        Row(
          children: [
            Expanded(
              child: CustomDropdown(
                height: 40,
                value: selectedHour,
                items: hours ?? [],
                // itemNames: hours?.map((h) => '${h}h').toList(),
                onChanged: (value) {
                  onHourChanged(value);
                },
                hint: 'Hour',
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: CustomDropdown(
                height: 40,
                value: selectedMinute,
                items: minutes ?? [],
                // itemNames: minutes?.map((m) => '${m}m').toList(),
                onChanged: (value) {
                  onMinuteChanged(value);
                },
                hint: 'Minute',
              ),
            ),
          ],
        ),
      ],
    );
  }
}
