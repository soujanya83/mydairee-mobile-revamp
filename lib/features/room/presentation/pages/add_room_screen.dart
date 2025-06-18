import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';
import 'package:mydiaree/core/config/app_colors.dart';
import 'package:mydiaree/core/cubit/global_data_cubit.dart';
import 'package:mydiaree/core/cubit/globle_model/educator_model.dart';
import 'package:mydiaree/core/utils/ui_helper.dart';
import 'package:mydiaree/core/widgets/custom_app_bar.dart';
import 'package:mydiaree/core/widgets/custom_buton.dart';
import 'package:mydiaree/core/widgets/custom_dropdown.dart';
import 'package:mydiaree/core/widgets/custom_multi_selected_dialog.dart';
import 'package:mydiaree/core/widgets/custom_scaffold.dart';
import 'package:mydiaree/core/widgets/custom_text_field.dart';
import 'package:mydiaree/features/room/presentation/bloc/add_room/add_room_bloc.dart';
import 'package:mydiaree/features/room/presentation/bloc/add_room/add_room_event.dart';
import 'package:mydiaree/features/room/presentation/bloc/add_room/add_room_state.dart';
import 'package:mydiaree/features/room/presentation/bloc/list_room/list_room_bloc.dart';

class AddRoomScreen extends StatefulWidget {
  final String screenType;
  final String centerId;
  final Map<String, dynamic>? room;
  const AddRoomScreen(
      {super.key, required this.centerId, this.room, required this.screenType});
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

  List<EducatorItem?> selectedEducators = [];
  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();

    if (widget.room != null && widget.screenType == 'edit') {
      name.text = widget.room!['name'] ?? '';
      capacity.text = widget.room!['capacity']?.toString() ?? '';
      ageFrom.text = widget.room!['ageFrom']?.toString() ?? '';
      ageTo.text = widget.room!['ageTo']?.toString() ?? '';
      _chosenStatus = widget.room!['status'] ?? 'Active';
      currentColor =
          Color(widget.room!['color'] ?? AppColors.primaryColor.value);
      pickerColor = currentColor;
      try {
        selectedEducators = List.generate(
                context.read<GlobalDataState>().centersData?.data.length ?? 0,
                (index) => context
                    .read<GlobalDataState>()
                    .educatorsData
                    ?.educators[index])
            .toList()
            .where((e) =>
                context
                    .read<GlobalDataState>()
                    .educatorsData
                    ?.educators
                    .contains(e) ??
                false)
            .toList();
      } catch (e) {
        debugPrint('Error parsing educatorIds: $e');
        selectedEducators = [];
      }
    }
  }

  void changeColor(Color color) {
    pickerColor = color;
  }

  void _showEducatorDialog() async {
    final globalState = context.read<GlobalDataCubit>().state;

    await showDialog<List<Map<String, String>>>(
      context: context,
      builder: (context) => CustomMultiSelectDialog(
        educatorIds: List.generate(
          globalState.educatorsData?.educators.length ?? 0,
          (index) {
            return globalState.educatorsData?.educators[index].id ?? '';
          },
        ),
        educatorNames: List.generate(
          globalState.educatorsData?.educators.length ?? 0,
          (index) {
            return globalState.educatorsData?.educators[index].name ?? '';
          },
        ),
        initiallySelectedIds: List.generate(selectedEducators.length, (index) {
          return selectedEducators[index]?.id ?? '';
        }),
        title: 'Select Educator',
        onItemTap: (selectedIds) {
          setState(() {
            final educators = globalState.educatorsData?.educators ?? [];
            selectedEducators =
                educators.where((e) => selectedIds.contains(e.id)).toList();
          });
        },
      ),
    );
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
                            return 'Age To must be >= Age From';
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
                  child: Container(
                    height: 45,
                    width: double.infinity,
                    decoration: BoxDecoration(
                      color: currentColor,
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(color: AppColors.grey),
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                Text('Educator', style: Theme.of(context).textTheme.bodyMedium),
                const SizedBox(height: 6),
                GestureDetector(
                  onTap: _showEducatorDialog,
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
                if (selectedEducators.isNotEmpty)
                  Wrap(
                    spacing: 8,
                    children: selectedEducators
                        .map((edu) => Chip(
                              label: Text(edu?.name ?? ''),
                              onDeleted: () {
                                setState(() {
                                  selectedEducators
                                      .removeWhere((e) => e?.id == edu?.id);
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
                    BlocListener<AddRoomBloc, AddRoomState>(
                        listener: (context, state) {
                      if (state is AddRoomFailure) {
                        UIHelpers.showToast(
                          context,
                          message: state.error,
                          backgroundColor: AppColors.errorColor,
                        );
                      } else if (state is AddRoomSuccess) {
                        UIHelpers.showToast(
                          context,
                          message: state.message,
                          backgroundColor: AppColors.successColor,
                        );
                        Navigator.pop(context);
                      }
                    }, child: BlocBuilder<AddRoomBloc, AddRoomState>(
                            builder: (context, state) {
                      return CustomButton(
                        height: 45,
                        width: 100,
                        text: 'SAVE',
                        isLoading: state is AddRoomLoading,
                        ontap: () {
                          {
                            context.read<AddRoomBloc>().add(SubmitAddRoomEvent(
                                id: (widget.screenType == 'edit')
                                    ? (widget.room?['id'])
                                    : null,
                                centerId:
                                    widget.room?['centerId'].toString() ?? '',
                                name: name.text,
                                capacity: capacity.text,
                                ageFrom: ageFrom.text,
                                ageTo: ageTo.text,
                                roomStatus: _chosenStatus,
                                color: currentColor.toString(),
                                educators: selectedEducators));
                          }
                        },
                      );
                    })),
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
