import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:mydiaree/core/widgets/custom_app_bar.dart';
import 'package:mydiaree/core/widgets/custom_buton.dart';
import 'package:mydiaree/core/widgets/custom_scaffold.dart';
import 'package:mydiaree/core/widgets/dropdowns/center_dropdown.dart';
import 'package:mydiaree/core/widgets/dropdowns/room_dropdown.dart';
import 'package:mydiaree/features/daily_journal/headchecks/data/model/headcheks_model.dart';
import 'package:mydiaree/features/daily_journal/headchecks/data/repositories/headchecks_repo.dart';
import 'package:mydiaree/features/daily_journal/headchecks/presentation/pages/accident/head_checks_dailog.dart';
import 'package:mydiaree/features/daily_journal/headchecks/presentation/widget/headchecks_custom_widgets.dart';

class HeadChecksScreen extends StatefulWidget {
  const HeadChecksScreen({super.key});

  @override
  _HeadChecksScreenState createState() => _HeadChecksScreenState();
}

class _HeadChecksScreenState extends State<HeadChecksScreen> {
  String selectedCenterId = '1';
  String selectedRoomId = '1';
  String selectedUserId = '1';
  DateTime selectedDate = DateTime.now();

  List<HeadCheckModel> headChecks = [];
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    fetchHeadChecks();
  }

  Future<void> fetchHeadChecks() async {
    setState(() => isLoading = true);
    final response = await HeadChecksRepository().getHeadChecksData(
      userId: selectedUserId,
      centerId: selectedCenterId,
      roomId: selectedRoomId,
      date: selectedDate,
    );
    setState(() {
      isLoading = false;
      headChecks = response.data?.headChecks ?? [];
    });
  }

  Future<void> addOrEditHeadCheck({
    String? hour,
    String? minute,
    String? headCount,
    String? signature,
    String? comments,
    bool isEdit = false,
  }) async {
    await HeadChecksRepository().addHeadChecks(
      hours: [hour ?? ''],
      mins: [minute ?? ''],
      headCounts: [headCount ?? ''],
      signatures: [signature ?? ''],
      comments: [comments ?? ''],
      roomId: selectedRoomId,
      centerId: selectedCenterId,
      diaryDate: DateFormat('dd/MM/yyyy').format(selectedDate),
      userId: selectedUserId,
    );
    await fetchHeadChecks();
  }

  Future<void> deleteHeadCheck(String headCheckId) async {
    await HeadChecksRepository().deleteHeadCheck(headCheckId);
    await fetchHeadChecks();
  }

  void _showAddHeadCheckDialog() {
    showDialog(
      context: context,
      builder: (ctx) => HeadCheckEditDialog(
        onSave: (hour, minute, headCount, signature, comments) async {
          await addOrEditHeadCheck(
            hour: hour,
            minute: minute,
            headCount: headCount,
            signature: signature,
            comments: comments,
          );
        },
      ),
    );
  }

  void _showEditHeadCheckDialog(HeadCheckModel headCheck) {
    final timeParts = headCheck.time.split(':');
    final hour = timeParts.isNotEmpty ? timeParts[0] : '';
    final minute = timeParts.length > 1 ? timeParts[1] : '';
    showDialog(
      context: context,
      builder: (ctx) => HeadCheckEditDialog(
        hour: hour,
        minute: minute,
        headCount: headCheck.headCount,
        signature: headCheck.signature,
        comments: headCheck.comments,
        onSave: (newHour, newMinute, newHeadCount, newSignature,
            newComments) async {
          await addOrEditHeadCheck(
            hour: newHour,
            minute: newMinute,
            headCount: newHeadCount,
            signature: newSignature,
            comments: newComments,
            isEdit: true,
          );
        },
      ),
    );
  }

  void _addEmptyHeadCheckWidget() {
    setState(() {
      headChecks.add(
        HeadCheckModel(
          id: null,
          roomId: selectedRoomId,
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

  @override
  Widget build(BuildContext context) {
    return CustomScaffold(
      appBar: const CustomAppBar(title: 'Head Checks'),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 10),
              CenterDropdown(
                selectedCenterId: selectedCenterId,
                onChanged: (value) async {
                  setState(() {
                    selectedCenterId = value.id;
                    selectedRoomId = '1';
                  });
                  await fetchHeadChecks();
                },
              ),
              const SizedBox(height: 6),
              // RoomDropdown can be added here if needed
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  CustomButton(
                    width: 180,
                    text: 'Add Head Check',
                    ontap: _showAddHeadCheckDialog,
                  ),
                  const SizedBox(width: 10),
                  IconButton(
                    icon: const Icon(Icons.add_circle,
                        color: Colors.green, size: 32),
                    onPressed: _addEmptyHeadCheckWidget,
                  ),
                ],
              ),
              const SizedBox(height: 10),
              isLoading
                  ? SizedBox(
                      height: MediaQuery.of(context).size.height * 0.7,
                      child: const Center(child: CircularProgressIndicator()),
                    )
                  : headChecks.isEmpty
                      ? const Center(
                          child:
                              Text('No head checks available for this date.'))
                      : Column(
                          children: [
                            Text(headChecks.length.toString()),
                            const SizedBox(height: 10),
                            ListView.builder(
                              shrinkWrap: true,
                              physics: const NeverScrollableScrollPhysics(),
                              itemCount: headChecks.length,
                              itemBuilder: (context, index) {
                                final headCheck = headChecks[index];
                                final timeParts = headCheck.time.split(':');
                                final hour =
                                    timeParts.isNotEmpty ? timeParts[0] : '';
                                final minute =
                                    timeParts.length > 1 ? timeParts[1] : '';
                                final headCountController =
                                    TextEditingController(
                                        text: headCheck.headCount ?? '');
                                final signatureController =
                                    TextEditingController(
                                        text: headCheck.signature ?? '');
                                final commentsController =
                                    TextEditingController(
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
                                    onRemove: () async {
                                      await deleteHeadCheck(headCheck.id ?? '');
                                    },
                                    onHourChanged: (newHour) {
                                      setState(() {
                                        final newTime =
                                            '${newHour ?? ''}:${minute}';
                                        headChecks[index] =
                                            headCheck.copyWith(time: newTime);
                                      });
                                    },
                                    onMinuteChanged: (newMinute) {
                                      setState(() {
                                        final newTime =
                                            '${hour}:${newMinute ?? ''}';
                                        headChecks[index] =
                                            headCheck.copyWith(time: newTime);
                                      });
                                    },
                                    onDelete: () {
                                      setState(() {
                                        headChecks[index] = headCheck.copyWith(
                                          time: '${hour}:${minute}',
                                          headCount: headCountController.text,
                                          signature: signatureController.text,
                                          comments: commentsController.text,
                                        );
                                      });
                                    },
                                    onCancel: () {},
                                    // Add these callbacks:
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
                                  ),
                                );
                              },
                            ),
                            SizedBox(
                              height: 10,
                            ),
                            CustomButton(
                              width: 180,
                              text: 'Save All Head Checks',
                              ontap: () async {
                                // Collect all fields from headChecks list
                                final hours = headChecks
                                  .map((e) {
                                    final hourStr = e.time.split(':')[0];
                                    // Remove all non-digit characters
                                    return hourStr.replaceAll(RegExp(r'[^0-9]'), '');
                                  })
                                  .toList();

                                final mins = headChecks
                                  .map((e) {
                                    final parts = e.time.split(':');
                                    final minStr = parts.length > 1 ? parts[1] : '';
                                    // Remove all non-digit characters
                                    return minStr.replaceAll(RegExp(r'[^0-9]'), '');
                                  })
                                  .toList();
                                print(hours);
                                print(mins);
                                 return;
                                final headCounts = headChecks
                                    .map((e) => e.headCount ?? '')
                                    .toList();
                                final signatures = headChecks
                                    .map((e) => e.signature ?? '')
                                    .toList();
                                final comments = headChecks
                                    .map((e) => e.comments ?? '')
                                    .toList();

                                setState(() => isLoading = true);
                                final response =
                                    await HeadChecksRepository().addHeadChecks(
                                  hours: hours,
                                  mins: mins,
                                  headCounts: headCounts,
                                  signatures: signatures,
                                  comments: comments,
                                  roomId: selectedRoomId,
                                  centerId: selectedCenterId,
                                  diaryDate: DateFormat('dd/MM/yyyy')
                                      .format(selectedDate),
                                  userId: selectedUserId,
                                );
                                setState(() => isLoading = false);

                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: Text(response.message),
                                    backgroundColor: response.success
                                        ? Colors.green
                                        : Colors.red,
                                  ),
                                );
                                if (response.success) {
                                  await fetchHeadChecks();
                                }
                              },
                            )
                          ],
                        ),
            ],
          ),
        ),
      ),
    );
  }
}
