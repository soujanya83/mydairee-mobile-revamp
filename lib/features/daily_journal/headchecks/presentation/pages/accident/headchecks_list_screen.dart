import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:mydiaree/core/config/app_colors.dart';
import 'package:mydiaree/core/widgets/custom_app_bar.dart';
import 'package:mydiaree/core/widgets/custom_scaffold.dart';
import 'package:mydiaree/core/widgets/custom_buton.dart';
import 'package:mydiaree/core/widgets/dropdowns/center_dropdown.dart';
import 'package:mydiaree/core/widgets/custom_dropdown.dart';
import 'package:mydiaree/features/daily_journal/headchecks/data/model/headcheks_model.dart';
import 'package:mydiaree/features/daily_journal/headchecks/data/repositories/headchecks_repo.dart';
import 'package:mydiaree/features/room/data/model/room_list_model.dart';
import 'package:mydiaree/features/room/data/repositories/room_repositories.dart';
import 'package:mydiaree/features/daily_journal/headchecks/presentation/widget/headchecks_custom_widgets.dart';
import 'package:mydiaree/core/cubit/globle_repository.dart';
import 'package:mydiaree/core/cubit/globle_model/center_model.dart';
import 'package:mydiaree/main.dart';

class HeadChecksScreen extends StatefulWidget {
  const HeadChecksScreen({super.key});

  @override
  State<HeadChecksScreen> createState() => _HeadChecksScreenState();
}

class _HeadChecksScreenState extends State<HeadChecksScreen> {
  List<Datum> centers = [];
  String selectedCenterId = '1';
  List<Room> rooms = [];
  String? selectedRoomId;
  DateTime selectedDate = DateTime.now();

  List<HeadCheckModel> headChecks = [];
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    fetchCentersAndInit();
  }

  Future<void> fetchCentersAndInit() async {
    setState(() => isLoading = true);
    final centerResponse = await GlobalRepository().getCenters();
    centers = centerResponse?.data?.data ?? [];
    if (centers.isNotEmpty) {
      selectedCenterId = centers.first.id;
      await fetchRooms(selectedCenterId!);
      if (rooms.isNotEmpty) {
        selectedRoomId = rooms.first.id?.toString();
      }
      await fetchHeadChecks();
    }
    setState(() => isLoading = false);
  }

  Future<void> fetchRooms(String centerId) async {
    final roomResponse = await RoomRepository().getRooms(centerId: centerId);
    rooms = roomResponse.data?.rooms ?? [];
    if (rooms.isNotEmpty &&
        (selectedRoomId == null ||
            !rooms.any((r) => r.id?.toString() == selectedRoomId))) {
      selectedRoomId = rooms.first.id?.toString();
    }
    setState(() {});
  }

  Future<void> fetchHeadChecks() async {
    setState(() => isLoading = true);
    final response = await HeadChecksRepository().getHeadChecksData(
      centerId: selectedCenterId ?? '',
      roomId: selectedRoomId ?? '',
      date: selectedDate,
    );
    headChecks = response.data?.headChecks ?? [];
    setState(() => isLoading = false);
  }

  void _onCenterChanged(Datum center) async {
    setState(() {
      selectedCenterId = center.id;
      rooms = [];
      selectedRoomId = null;
      isLoading = true;
    });
    await fetchRooms(center.id);
    if (rooms.isNotEmpty) {
      selectedRoomId = rooms.first.id?.toString();
    }
    await fetchHeadChecks();
    setState(() => isLoading = false);
  }

  void _onRoomChanged(String? roomId) async {
    print('Selected Room ID: $roomId');
    setState(() {
      selectedRoomId = roomId;
      isLoading = true;
    });
    await fetchHeadChecks();
    setState(() => isLoading = false);
  }

  void _onDateChanged(DateTime date) async {
    setState(() {
      selectedDate = date;
      isLoading = true;
    });
    await fetchHeadChecks();
    setState(() => isLoading = false);
  }

  Future<void> saveAllHeadChecks() async {
    final hours = headChecks
      .map((e) => e.time.split(':')[0].replaceAll(RegExp(r'[^\d]'), ''))
      .toList();
    final mins = headChecks
      .map((e) => e.time.split(':').length > 1
        ? e.time.split(':')[1].replaceAll(RegExp(r'[^\d]'), '')
        : '')
      .toList();
    final headCounts = headChecks.map((e) => e.headCount ?? '').toList();
    final signatures = headChecks.map((e) => e.signature ?? '').toList();
    final comments = headChecks.map((e) => e.comments ?? '').toList();
    print(headCounts);
    print(hours);
    print(mins);
    if (headCounts.isEmpty || hours.isEmpty || mins.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please fill all fields')),
      );
      return;
    }
    print(signatures);
    print(comments);
    // return;

    setState(() => isLoading = true);
    final response = await HeadChecksRepository().addHeadChecks(
      hours: hours,
      mins: mins,
      headCounts: headCounts,
      signatures: signatures,
      comments: comments,
      roomId: selectedRoomId ?? '',
      centerId: selectedCenterId ?? '',
      diaryDate: DateFormat('dd/MM/yyyy').format(selectedDate),
    );
    setState(() => isLoading = false);

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(response.message),
        backgroundColor: response.success ? Colors.green : Colors.red,
      ),
    );
    if (response.success) {
      await fetchHeadChecks();
    }
  }

  void _addEmptyHeadCheckWidget() {
    setState(() {
      headChecks.add(
        HeadCheckModel(
          id: null,
          roomId: selectedRoomId.toString(),
          diaryDate: DateFormat('dd/MM/yyyy').format(selectedDate),
          time: '',
          headCount: '',
          signature: '',
          comments: '',
          createdBy: '',
          createdAt: '',
        ),
      );
    });
  }

  final GlobalRepository globalRepository = GlobalRepository();
  @override
  Widget build(BuildContext context) {
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      if (centerDataGloble == null) {
        centerDataGloble = await globalRepository.getCenters();
      }
    });
    return CustomScaffold(
      appBar: const CustomAppBar(title: 'Head Checks'),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : Padding(
              padding: const EdgeInsets.all(12.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Center filter
                  CenterDropdown(
                    selectedCenterId: selectedCenterId,
                    onChanged: _onCenterChanged,
                  ),
                  const SizedBox(height: 10),
                  // Room filter
                  CustomDropdown<String>(
                    width: screenWidth * .95,
                    value: selectedRoomId,
                    items: rooms.map((r) => r.id?.toString() ?? '').toList(),
                    hint: 'Select Room',
                    // width: 250,
                    onChanged: _onRoomChanged,
                    displayItem: (id) {
                      final room = rooms.firstWhere(
                          (r) => r.id?.toString() == id,
                          orElse: () => Room());
                      return room.name ?? id;
                    },
                  ),
                  const SizedBox(height: 10),
                  // Date filter
                  // Row(
                  //   children: [
                  //     Text('Date:',
                  //         style: Theme.of(context).textTheme.bodyMedium),
                  //     const SizedBox(width: 8),
                  //     DatePickerButton(
                  //       date: selectedDate,
                  //       onDateSelected: _onDateChanged,
                  //     ),
                  //   ],
                  // ),
                  const SizedBox(height: 10),
                  // HeadChecks List
                  Expanded(
                    child: headChecks.isEmpty
                        ? const Center(child: Text('No head checks'))
                        : ListView.builder(
                            itemCount: headChecks.length,
                            itemBuilder: (context, index) {
                                final headCheck = headChecks[index];
                                String hour = '';
                                String minute = '';
                                try {
                                final timeParts = headCheck.time.split(':');
                                if (timeParts.isNotEmpty) {
                                  hour = timeParts[0].replaceAll('hh', 'h');
                                }
                                if (timeParts.length > 1) {
                                  minute = timeParts[1].replaceAll('mm', 'm');
                                }
                                } catch (e) {
                                hour = '';
                                minute = '';
                                }
                              final headCountController = TextEditingController(
                                  text: headCheck.headCount ?? '');
                              final signatureController = TextEditingController(
                                  text: headCheck.signature ?? '');
                              final commentsController = TextEditingController(
                                  text: headCheck.comments ?? '');

                              return Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: HeadCheckCard(
                                  index: index,
                                  hour: hour,
                                  minute: minute,
                                  headCountController: headCountController,
                                  signatureController: signatureController,
                                  commentsController: commentsController,
                                  onHourChanged: (newHour) {
                                    setState(() {
                                      // Convert "5h" to "5hh"
                                      final formattedHour =
                                          (newHour ?? '').replaceAll('h', 'hh');
                                      final formattedMinute =
                                          minute.replaceAll('m', 'mm');
                                      headChecks[index] = headCheck.copyWith(
                                          time:
                                              '$formattedHour:$formattedMinute');
                                    });
                                  },
                                  onMinuteChanged: (newMinute) {
                                    setState(() {
                                      final formattedHour =
                                          hour.replaceAll('h', 'hh');
                                      final formattedMinute = (newMinute ?? '')
                                          .replaceAll('m', 'mm');
                                      headChecks[index] = headCheck.copyWith(
                                          time:
                                              '$formattedHour:$formattedMinute');
                                    });
                                  },
                                  onHeadCountChanged: (val) {
                                    setState(() {
                                      headChecks[index] =
                                          headCheck.copyWith(headCount: val);
                                    });
                                  },
                                  onSignatureChanged: (val) {
                                    setState(() {
                                      headChecks[index] =
                                          headCheck.copyWith(signature: val);
                                    });
                                  },
                                  onCommentsChanged: (val) {
                                    setState(() {
                                      headChecks[index] =
                                          headCheck.copyWith(comments: val);
                                    });
                                  },
                                  onDelete: headCheck.id != null
                                      ? () async {
                                          await HeadChecksRepository()
                                              .deleteHeadCheck(headCheck.id!);
                                          await fetchHeadChecks();
                                        }
                                      : null,
                                  onCancel: () {},
                                  onAdd: null,
                                  onRemove: null,
                                ),
                              );
                            },
                          ),
                  ),
                  const SizedBox(height: 20),
                  CustomButton(
                    width: 180,
                    text: 'Save All Head Checks',
                    ontap: saveAllHeadChecks,
                  ),
                  const SizedBox(height: 15),
                ],
              ),
            ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _addEmptyHeadCheckWidget();
        },
        backgroundColor: AppColors.primaryColor,
        mini: true,
        child: const Icon(Icons.add, size: 20),
      ),
    );
  }
}
