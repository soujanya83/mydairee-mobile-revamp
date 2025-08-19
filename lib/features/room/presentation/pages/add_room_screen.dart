import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';
import 'package:mydiaree/core/config/app_colors.dart';
import 'package:mydiaree/core/cubit/globle_model/educator_model.dart';
import 'package:mydiaree/core/cubit/globle_repository.dart';
import 'package:mydiaree/core/services/apiresoponse.dart';
import 'package:mydiaree/core/utils/ui_helper.dart';
import 'package:mydiaree/core/widgets/custom_app_bar.dart';
import 'package:mydiaree/core/widgets/custom_buton.dart';
import 'package:mydiaree/core/widgets/custom_dropdown.dart';
import 'package:mydiaree/core/widgets/custom_multi_selected_dialog.dart';
import 'package:mydiaree/core/widgets/custom_scaffold.dart';
import 'package:mydiaree/core/widgets/custom_text_field.dart';
import 'package:mydiaree/features/program_plan/data/model/user_add_program_model.dart';
import 'package:mydiaree/features/room/data/model/room_list_model.dart';
import 'package:mydiaree/features/room/data/model/staff_model.dart' show Staff;
import 'package:mydiaree/features/room/data/repositories/room_repositories.dart';
import 'package:mydiaree/features/room/presentation/bloc/add_room/add_room_bloc.dart';
import 'package:mydiaree/features/room/presentation/bloc/add_room/add_room_event.dart';
import 'package:mydiaree/features/room/presentation/bloc/add_room/add_room_state.dart';
import 'package:mydiaree/features/room/presentation/bloc/list_room/list_room_bloc.dart';
import 'package:mydiaree/features/room/presentation/bloc/list_room/list_room_state.dart';
import 'package:mydiaree/features/room/presentation/bloc/list_room/list_room_event.dart';

class AddRoomScreen extends StatefulWidget {
  final String centerId;
  final String screenType;
  final Room? room; // <-- Add this parameter

  const AddRoomScreen({
    Key? key,
    required this.centerId,
    required this.screenType,
    this.room, // <-- Add this parameter
  }) : super(key: key);

  @override
  State<AddRoomScreen> createState() => _AddRoomScreenState();
}

class _AddRoomScreenState extends State<AddRoomScreen> {
  final TextEditingController name = TextEditingController();
  final TextEditingController capacity = TextEditingController();
  final TextEditingController ageFrom = TextEditingController();
  final TextEditingController ageTo = TextEditingController();

  String _chosenStatus = 'Active';
  Color pickerColor = AppColors.primaryColor;
  Color currentColor = AppColors.primaryColor;

  List<User?> selectedEducators = [];
  final _formKey = GlobalKey<FormState>();
  final GlobalRepository repository = GlobalRepository();
  ApiResponse<UserAddProgramPlanModel?>? educatorData;

  Future<void> getEducator() async {
    educatorData = await repository.getEducators('1013182027');
    setState(() {});
  }

  bool isLoading = false;

  List<Staff> staffList = [];
  List<Staff> selectedStaff = [];
  Future<void> fetchStaff() async {
    final response = await RoomRepository().getStaffList();
    if (response.success && response.data != null) {
      setState(() {
        staffList = response.data!.data ?? [];
      });
    }
  }

  @override
  void initState() {
    super.initState();
    fetchStaff();
    if (widget.screenType == 'edit' && widget.room != null) {
      final room = widget.room!;
      name.text = room.name ?? '';
      capacity.text = room.capacity?.toString() ?? '';
      ageFrom.text = room.ageFrom?.toString() ?? '';
      ageTo.text = room.ageTo?.toString() ?? '';
      _chosenStatus = room.status ?? 'Active';

      // --- Color parsing with error handling ---
      Color safeColor = AppColors.primaryColor;
      String? colorStr = room.color;
      if (colorStr != null && colorStr.isNotEmpty) {
        try {
          // Remove any leading '#' or '##'
          colorStr = colorStr.replaceAll(RegExp(r'^#+'), '');
          // Remove any non-hex characters and limit to 6 or 8 chars
          colorStr = colorStr.replaceAll(RegExp(r'[^0-9a-fA-F]'), '');
          if (colorStr.length == 6) {
            colorStr = 'FF' + colorStr; // Add alpha if missing
          } else if (colorStr.length == 8) {
            // already has alpha
          } else {
            throw Exception('Invalid color length');
          }
          safeColor = Color(int.parse('0x$colorStr'));
        } catch (e) {
          // fallback to default color
          safeColor = AppColors.primaryColor;
        }
      }
      currentColor = safeColor;
      pickerColor = safeColor;
      try {
        if (educatorData != null &&
            educatorData!.success &&
            educatorData!.data != null) {
          selectedEducators = educatorData!.data!.users ?? [];
        } else {
          selectedEducators = [];
        }
      } catch (e) {
        debugPrint('Error parsing educatorIds: $e');
        selectedEducators = [];
      }
    }
  }

  void changeColor(Color color) {
    pickerColor = color;
  }

  // void _showEducatorDialog() async {
  //   final educators = educatorData?.data?.users ?? [];
  //   await showDialog<List<Map<String, String>>>(
  //     context: context,
  //     builder: (context) => CustomMultiSelectDialog(
  //       itemsId: List.generate(
  //         educators.length,
  //         (index) => educators[index].id.toString(),
  //       ),
  //       itemsName: List.generate(
  //         educators.length,
  //         (index) => educators[index].name ?? '',
  //       ),
  //       initiallySelectedIds: List.generate(
  //         selectedEducators.length,
  //         (index) => selectedEducators[index]?.id?.toString() ?? '',
  //       ),
  //       title: 'Select Educator',
  //       onItemTap: (selectedIds) {
  //         setState(() {
  //           selectedEducators = educators
  //               .where((e) => selectedIds.contains(e.id.toString()))
  //               .toList();
  //         });
  //       },
  //     ),
  //   );
  // }

  void _showEducatorAndStaffDialog() async {
    final educators = educatorData?.data?.users ?? [];
    await showDialog(
      context: context,
      builder: (context) => CustomMultiSelectDialog(
        itemsId: [
          ...educators.map((e) => 'edu_${e.id}'),
          ...staffList.map((s) => 'staff_${s.id}')
        ],
        itemsName: [
          ...educators.map((e) => '${e.name ?? ''}'),
          ...staffList.map((s) => '${s.name ?? ''}')
        ],
        initiallySelectedIds: [
          ...selectedEducators.map((e) => 'edu_${e?.id}'),
          ...selectedStaff.map((s) => 'staff_${s.id}')
        ],
        title: 'Select Educator/Staff',
        onItemTap: (selectedIds) {
          setState(() {
            selectedEducators = educators
                .where((e) => selectedIds.contains('edu_${e.id}'))
                .toList();
            selectedStaff = staffList
                .where((s) => selectedIds.contains('staff_${s.id}'))
                .toList();
          });
        },
      ),
    );
  }

  Future<void> submitRoom() async {
    if (_formKey.currentState?.validate() != true) return;
    final educatorIds =
        selectedEducators.map((e) => e?.id).whereType<int>().toList();

    final response = await RoomRepository().addRoom(
      roomName: name.text,
      roomCapacity: capacity.text,
      ageFrom: ageFrom.text,
      ageTo: ageTo.text,
      roomStatus: _chosenStatus,
      roomColor:
          '#${currentColor.value.toRadixString(16).padLeft(8, '0').substring(2)}',
      dcenterid: widget.centerId,
      educators: educatorIds,
      roomId: (widget.screenType == 'edit') ? widget.room?.id.toString() : null,
    );

    UIHelpers.showToast(
      context,
      message: response.message,
      backgroundColor:
          response.success ? AppColors.successColor : AppColors.errorColor,
    );
    if (response.success) {
      final roomListBloc = context.read<RoomListBloc>();
      roomListBloc.add(FetchRoomsEvent(centerId: widget.centerId));
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return CustomScaffold(
      appBar: const CustomAppBar(title: "Add Room"),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Add Room',
                    style: Theme.of(context).textTheme.headlineSmall),
                const SizedBox(height: 16),
                CustomTextFormWidget(
                  controller: name,
                  hintText: 'Room Name',
                  title: 'Room Name',
                  validator: (v) =>
                      v == null || v.isEmpty ? 'Enter Room Name' : null,
                ),
                const SizedBox(height: 12),
                CustomTextFormWidget(
                  controller: capacity,
                  hintText: 'Capacity',
                  title: 'Room Capacity',
                  keyboardType: TextInputType.number,
                  validator: (v) {
                    if (v == null || v.isEmpty) return 'Enter Capacity';
                    final n = int.tryParse(v);
                    if (n == null || n <= 0) return 'Enter valid capacity';
                    return null;
                  },
                ),
                const SizedBox(height: 12),
                Row(
                  children: [
                    Expanded(
                      child: CustomTextFormWidget(
                        controller: ageFrom,
                        hintText: 'Age From',
                        title: 'Age From',
                        keyboardType: TextInputType.number,
                        validator: (v) {
                          if (v == null || v.isEmpty) return 'Enter age';
                          final n = int.tryParse(v);
                          if (n == null || n < 0) return 'Enter valid age';
                          return null;
                        },
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: CustomTextFormWidget(
                        controller: ageTo,
                        hintText: 'Age To',
                        title: 'Age To',
                        keyboardType: TextInputType.number,
                        validator: (v) {
                          if (v == null || v.isEmpty) return 'Enter age';
                          final n = int.tryParse(v);
                          final from = int.tryParse(ageFrom.text);
                          if (n == null || n < 0) return 'Enter valid age';
                          if (from != null && n < from) {
                            return 'Enter Valid Age';
                          }
                          return null;
                        },
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                Text('Room Status',
                    style: Theme.of(context).textTheme.bodyMedium),
                const SizedBox(height: 6),
                CustomDropdown(
                  height: 45,
                  value: _chosenStatus,
                  items: const ['Active', 'Inactive'],
                  onChanged: (val) {
                    setState(() => _chosenStatus = val!);
                  },
                ),
                const SizedBox(height: 16),
                Text('Room Color',
                    style: Theme.of(context).textTheme.bodyMedium),
                const SizedBox(height: 6),
                GestureDetector(
                  onTap: () {
                    showDialog(
                      context: context,
                      builder: (_) => AlertDialog(
                        title: const Text('Pick a color'),
                        content: SingleChildScrollView(
                          child: ColorPicker(
                            pickerColor: currentColor,
                            onColorChanged: (color) {
                              changeColor(color);
                            },
                          ),
                        ),
                        actions: [
                          TextButton(
                            onPressed: () {
                              setState(() => currentColor = pickerColor);
                              Navigator.of(context).pop();
                            },
                            child: const Text('Choose'),
                          ),
                        ],
                      ),
                    );
                  },
                  child: Builder(
                    builder: (context) {
                      try {
                        return Container(
                          height: 45,
                          width: double.infinity,
                          decoration: BoxDecoration(
                            color: currentColor,
                            borderRadius: BorderRadius.circular(8),
                            border: Border.all(color: AppColors.grey),
                          ),
                        );
                      } catch (e) {
                        // fallback UI if color error
                        return Container(
                          height: 45,
                          width: double.infinity,
                          decoration: BoxDecoration(
                            color: AppColors.primaryColor,
                            borderRadius: BorderRadius.circular(8),
                            border: Border.all(color: AppColors.grey),
                          ),
                          child: Center(
                            child: Text(
                              'Invalid color',
                              style: TextStyle(color: Colors.white),
                            ),
                          ),
                        );
                      }
                    },
                  ),
                ),
                const SizedBox(height: 16),
                Text('Educator', style: Theme.of(context).textTheme.bodyMedium),
                const SizedBox(height: 6),
                GestureDetector(
                  onTap: () {
                    _showEducatorAndStaffDialog();
                  },
                  child: Container(
                    width: 180,
                    height: 38,
                    decoration: BoxDecoration(
                      color: AppColors.primaryColor,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: const Row(
                      children: [
                        SizedBox(width: 8),
                        Icon(Icons.add_circle, color: Colors.white),
                        SizedBox(width: 8),
                        Text('Select Educator',
                            style: TextStyle(color: Colors.white)),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 10),
                if (selectedStaff.isNotEmpty)
                  Wrap(
                    spacing: 8,
                    children: selectedStaff
                        .map((staff) => Chip(
                              label: Text(staff.name ?? ''),
                              onDeleted: () {
                                setState(() {
                                  selectedStaff
                                      .removeWhere((s) => s.id == staff.id);
                                });
                              },
                            ))
                        .toList(),
                  ),
                const SizedBox(height: 30),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    OutlinedButton(
                      onPressed: () => Navigator.pop(context),
                      child: const Text('CANCEL',
                          style: TextStyle(color: Colors.black)),
                    ),
                    const SizedBox(width: 16),
                    CustomButton(
                      height: 45,
                      width: 100,
                      text: 'SAVE',
                      isLoading: isLoading,
                      ontap: () async {
                        if (_formKey.currentState?.validate() != true) return;
                        setState(() {
                          isLoading = true;
                        });
                        final staffIds = selectedStaff
                            .map((s) => s.id)
                            .whereType<int>()
                            .toList();
                        final response = await RoomRepository().addRoom(
                          roomId: widget.screenType == 'edit'
                              ? widget.room?.id.toString()
                              : null,
                          roomName: name.text,
                          roomCapacity: capacity.text,

                          ageFrom: ageFrom.text,
                          ageTo: ageTo.text,
                          roomStatus: _chosenStatus,
                          roomColor:
                              '#${currentColor.value.toRadixString(16).padLeft(8, '0').substring(2)}',
                          dcenterid: widget.centerId,
                          // educators: selectedEducators
                          //     .map((e) => e?.id)
                          //     .whereType<int>()
                          //     .toList(),
                          educators: staffIds,
                        );
                        setState(() {
                          isLoading = false;
                        });
                        UIHelpers.showToast(
                          context,
                          message: response.message,
                          backgroundColor: response.success
                              ? AppColors.successColor
                              : AppColors.errorColor,
                        );

                        if (response.success) {
                          WidgetsBinding.instance.addPostFrameCallback((_) {
                            context.read<RoomListBloc>().add(
                                FetchRoomsEvent(centerId: widget.centerId));
                          });
                          Navigator.pop(context);
                        }
                      },
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
