import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mydiaree/core/config/app_colors.dart';
import 'package:mydiaree/core/utils/ui_helper.dart';
import 'package:mydiaree/core/widgets/custom_app_bar.dart';
import 'package:mydiaree/core/widgets/custom_buton.dart';
import 'package:mydiaree/core/widgets/custom_dropdown.dart';
import 'package:mydiaree/core/widgets/custom_multi_selected_dialog.dart';
import 'package:mydiaree/core/widgets/custom_multiline_text_field.dart';
import 'package:mydiaree/core/widgets/custom_scaffold.dart';
import 'package:mydiaree/core/widgets/custom_text_field.dart';
import 'package:mydiaree/core/widgets/dropdowns/room_dropdown.dart';
import 'package:mydiaree/features/program_plan/data/model/ChildrenAddProgramPlan.dart';
import 'package:mydiaree/features/program_plan/data/model/UsersAddProgramPlan.dart';
import 'package:mydiaree/features/program_plan/data/model/program_plan_data_model.dart';
import 'package:mydiaree/features/program_plan/data/model/program_plan_list_model.dart';
import 'package:mydiaree/features/program_plan/data/repositories/program_plan_repository.dart';
import 'package:mydiaree/features/program_plan/presentation/bloc/programlist/add_plan/add_plan_bloc.dart';
import 'package:mydiaree/features/program_plan/presentation/bloc/programlist/add_plan/add_plan_event.dart';
import 'package:mydiaree/features/program_plan/presentation/bloc/programlist/add_plan/add_plan_state.dart';
import 'package:mydiaree/features/program_plan/presentation/widget/add_plan_widgets.dart';
import 'package:mydiaree/features/program_plan/presentation/widget/eylf_wrapper.dart';

class AddProgramPlanScreen extends StatefulWidget {
  final String centerId;
  final String? programPlanId;
  final Map<String, dynamic>? programPlan;
  final String screenType;

  const AddProgramPlanScreen({
    super.key,
    required this.centerId,
    this.programPlanId,
    this.programPlan,
    required this.screenType,
  });

  @override
  State<AddProgramPlanScreen> createState() => _AddProgramPlanScreenState();
}

class _AddProgramPlanScreenState extends State<AddProgramPlanScreen> {
  final _formKey = GlobalKey<FormState>();

  // Dropdown values
  String? selectedMonth = 'January';
  String? selectedYear = '2025';
  String? selectedRoom;

  String? selectedRoomId;

  // Text controllers
  final TextEditingController focusAreasController = TextEditingController();
  final TextEditingController outdoorExperiencesController =
      TextEditingController();
  final TextEditingController inquiryTopicController = TextEditingController();
  final TextEditingController sustainabilityTopicController =
      TextEditingController();
  final TextEditingController specialEventsController = TextEditingController();
  final TextEditingController childrenVoicesController =
      TextEditingController();
  final TextEditingController familiesInputController = TextEditingController();
  final TextEditingController groupExperienceController =
      TextEditingController();
  final TextEditingController spontaneousExperienceController =
      TextEditingController();
  final TextEditingController mindfulnessExperienceController =
      TextEditingController();
  final TextEditingController eylfController = TextEditingController();
  final TextEditingController practicalLifeController = TextEditingController();
  final TextEditingController sensorialController = TextEditingController();
  final TextEditingController mathController = TextEditingController();
  final TextEditingController languageController = TextEditingController();
  final TextEditingController cultureController = TextEditingController();

  // Lists for dropdowns
  final List<String> months = [
    'January',
    'February',
    'March',
    'April',
    'May',
    'June',
    'July',
    'August',
    'September',
    'October',
    'November',
    'December'
  ];

  final List<String> years = List.generate(
      11, (index) => (DateTime.now().year - 5 + index).toString());
  List<String> rooms = []; // This should be populated from your data

  // Selected educators and children
  List<String> selectedEducatorIds = [];
  List<String> selectedEducatorNames = [];
  List<String> selectedChildrenIds = [];
  List<String> selectedChildrenNames = [];

  ProgramPlanData? programPlanData;
  ChildrenAddProgramPlanModel? children;
  UserAddProgramPlanModel? user;

  getProgramPlan() {
    ProgramPlanRepository()
        .getProgramPlanData(
            centerId: widget.centerId, planId: widget.programPlanId)
        .then((response) {
      if (response.data != null) {
        setState(() {
          programPlanData = response.data;
        });
      }
    });
  }

  @override
  void initState() {
    super.initState();
    getProgramPlan();
    if (widget.screenType == 'edit' && widget.programPlan != null) {
      _initializeFromExistingData();
    }
  }

  void _initializeFromExistingData() {
    final data = widget.programPlan!;

    // Set dropdown values
    selectedMonth = data['month'];
    selectedYear = data['year'];
    selectedRoom = data['room_id'];

    // Set text fields
    focusAreasController.text = data['focus_area'] ?? '';
    outdoorExperiencesController.text = data['outdoor_experiences'] ?? '';
    inquiryTopicController.text = data['inquiry_topic'] ?? '';
    sustainabilityTopicController.text = data['sustainability_topic'] ?? '';
    specialEventsController.text = data['special_events'] ?? '';
    childrenVoicesController.text = data['children_voices'] ?? '';
    familiesInputController.text = data['families_input'] ?? '';
    groupExperienceController.text = data['group_experience'] ?? '';
    spontaneousExperienceController.text = data['spontaneous_experience'] ?? '';
    mindfulnessExperienceController.text =
        data['mindfulness_experiences'] ?? '';
    eylfController.text = data['eylf'] ?? '';
    practicalLifeController.text = data['practical_life'] ?? '';
    sensorialController.text = data['sensorial'] ?? '';
    mathController.text = data['math'] ?? '';
    languageController.text = data['language'] ?? '';
    cultureController.text = data['culture'] ?? '';

    // Set selected educators and children
    if (data['educators'] is List) {}
    if (data['children'] is List) {}
  }

  void _showEducatorSelectionDialog() {
    // TODO: Implement educator selection dialog similar to AddRoomScreen
    // You can use the same pattern from AddRoomScreen's _showEducatorDialog
  }

  void _showChildrenSelectionDialog() {
    // TODO: Implement children selection dialog
  }

  void _showEylfSelectionDialog() {
    // TODO: Implement EYLF selection dialog
  }

  assignPracticalLifeInController(){
    // assignEylfOutcomeInController(programPlanData?.eylfOutcomes ?? [],practicalLifeController);
    // return;
    print('assigning here');
    practicalLifeController.text = '';
    print('======================PracticalLifeController===========================');
    for (int parentIndex = 0;
        parentIndex < (practicalLifeData?.activity.length ?? 0);
        parentIndex++) {
      String activity = practicalLifeData?.activity[parentIndex].title ?? '';
      bool isDone = false;
      print(
          '====================*******i*****=$parentIndex============================');
      for (int childIndex = 0;
          childIndex <
              (practicalLifeData?.activity[parentIndex].subActivity.length ??
                  0);
          childIndex++) {
        print(
            '====================##########j##########=$childIndex===($parentIndex)=========================');
        print(
            '======value=${practicalLifeData?.activity[parentIndex].subActivity[childIndex].choosen ?? false}==========');

        if (practicalLifeData
                ?.activity[parentIndex].subActivity[childIndex].choosen ??
            false) {
          if (!isDone) {
            practicalLifeController.text += '**$activity** - \n';
            isDone = true;
          }

          String subActivity = practicalLifeData
                  ?.activity[parentIndex].subActivity[childIndex].title ??
              '';
          print('===================00eir0ir0====================');
          practicalLifeController.text += '**• **$subActivity.\n';
        }
      }
    }
    Future.delayed(Duration(seconds: 3), () {
      print('text file is the ===========');
      print(practicalLifeController.text);
    });
  }

  @override
  Widget build(BuildContext context) { 
    return CustomScaffold(
      appBar: const CustomAppBar(title: "Create Program Plan"),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Program Plan Details',
                    style: Theme.of(context).textTheme.headlineSmall),
                const SizedBox(height: 16),

                // Month and Year selection
                Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Month',
                              style: Theme.of(context).textTheme.bodyMedium),
                          const SizedBox(height: 6),
                          CustomDropdown(
                            height: 45,
                            value: selectedMonth,
                            items: months,
                            onChanged: (val) {
                              setState(() => selectedMonth = val!);
                            },
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Year',
                              style: Theme.of(context).textTheme.bodyMedium),
                          const SizedBox(height: 6),
                          CustomDropdown(
                            height: 45,
                            value: selectedYear,
                            items: years,
                            onChanged: (val) {
                              setState(() => selectedYear = val!);
                            },
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),

                Text('Room', style: Theme.of(context).textTheme.bodyMedium),
                const SizedBox(height: 6),
                Builder(
                  builder: (context) {
                    final rooms = programPlanData?.rooms ?? [];
                    return CustomDropdown<int>(
                      value: (selectedRoomId != null &&
                              int.tryParse(selectedRoomId!) != null)
                          ? int.parse(selectedRoomId!)
                          : null,
                      items: rooms
                          .where((room) => room.id != null)
                          .map((room) => room.id!)
                          .toList(),
                      hint: 'Select Room',
                      height: 45,
                      displayItem: (id) {
                        final room = rooms.firstWhere(
                          (r) => r.id == id,
                        );
                        return room.name ?? '';
                      },
                      onChanged: (id) async {
                        selectedRoomId = id?.toString();
                        if (id != null) {
                          user = await ProgramPlanRepository()
                              .getRoomUsers(selectedRoomId!);
                          children = await ProgramPlanRepository()
                              .getRoomChildren(selectedRoomId!);
                        } else {
                          user = null;
                          children = null;
                        }
                        setState(() {});
                      },
                    );
                  },
                ),

                const SizedBox(height: 16),

                if (selectedRoomId != null) ...[
                  Text('Educators',
                      style: Theme.of(context).textTheme.bodyMedium),
                  const SizedBox(height: 6),
                  Builder(
                    builder: (context) {
                      final educators = user?.users ?? [];
                      if (educators.isEmpty) {
                        return Container(
                          width: 180,
                          height: 38,
                          decoration: BoxDecoration(
                            color: AppColors.primaryColor.withOpacity(0.5),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: const Center(
                            child: Text(
                              'No educators found',
                              style: TextStyle(color: Colors.white),
                            ),
                          ),
                        );
                      }
                      return GestureDetector(
                        onTap: () {
                          showDialog(
                            context: context,
                            builder: (context) => CustomMultiSelectDialog(
                              title: 'Select Educator',
                              itemsId: educators
                                  .map((u) => u.id.toString())
                                  .toList(),
                              itemsName:
                                  educators.map((u) => u.name ?? '').toList(),
                              initiallySelectedIds: selectedEducatorIds,
                              onItemTap: (ids) {
                                setState(() {
                                  selectedEducatorIds = ids;
                                  selectedEducatorNames = educators
                                      .where(
                                          (u) => ids.contains(u.id.toString()))
                                      .map((u) => u.name ?? '')
                                      .toList();
                                });
                              },
                            ),
                          );
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
                      );
                    },
                  ),
                  const SizedBox(height: 8),
                  if (selectedEducatorNames.isNotEmpty)
                    Wrap(
                      spacing: 8,
                      children: selectedEducatorNames
                          .map((name) => Chip(label: Text(name)))
                          .toList(),
                    )
                  else
                    const Text('No educators selected',
                        style: TextStyle(color: Colors.grey)),
                  const SizedBox(height: 16),

                  // Children selection
                  Text('Children',
                      style: Theme.of(context).textTheme.bodyMedium),
                  const SizedBox(height: 6),
                  Builder(
                    builder: (context) {
                      final childrenList = children?.children ?? [];
                      if (childrenList.isEmpty) {
                        return Container(
                          width: 180,
                          height: 38,
                          decoration: BoxDecoration(
                            color: AppColors.primaryColor.withOpacity(0.5),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: const Center(
                            child: Text(
                              'No children found',
                              style: TextStyle(color: Colors.white),
                            ),
                          ),
                        );
                      }
                      return GestureDetector(
                        onTap: () {
                          showDialog(
                            context: context,
                            builder: (context) => CustomMultiSelectDialog(
                              title: 'Select Children',
                              itemsId: childrenList
                                  .map((c) => c.id.toString())
                                  .toList(),
                              itemsName: childrenList
                                  .map((c) => c.name ?? '')
                                  .toList(),
                              initiallySelectedIds: selectedChildrenIds,
                              onItemTap: (ids) {
                                setState(() {
                                  selectedChildrenIds = ids;
                                  selectedChildrenNames = childrenList
                                      .where(
                                          (c) => ids.contains(c.id.toString()))
                                      .map((c) => c.name ?? '')
                                      .toList();
                                });
                              },
                            ),
                          );
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
                              Text('Select Children',
                                  style: TextStyle(color: Colors.white)),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                  const SizedBox(height: 8),
                  if (selectedChildrenNames.isNotEmpty)
                    Wrap(
                      spacing: 8,
                      children: selectedChildrenNames
                          .map((name) => Chip(label: Text(name)))
                          .toList(),
                    )
                  else
                    const Text('No children selected',
                        style: TextStyle(color: Colors.grey)),
                  const SizedBox(height: 16),
                ],

                // Focus Areas
                CustomMultilineTextField(
                  title: 'Practical Life',
                  context: context,
                  controller: practicalLifeController,
                  onTap: () {
                    showPracticalLifeDialog(
                      context,
                      programPlanData?.montessoriSubjects?[0],
                      assignPracticalLifeInController,
                    );
                  },
                ),
                // const SizedBox(height: 16),

                // CustomMultilineTextField(
                //   title: 'Sensorial',
                //   context: context,
                //   controller: sensorialController,
                //   onTap: () {
                //     showPracticalLifeDialog(context, programPlanData?.montessoriSubjects?[0], () {});
                //   },
                // ),
                const SizedBox(height: 16),

                CustomMultilineTextField(
                  title: 'Math',
                  context: context,
                  controller: mathController,
                  onTap: () {
                    showPracticalLifeDialog(context, programPlanData?.montessoriSubjects?[1], () {});
                  },
                ),
                const SizedBox(height: 16),

                // CustomMultilineTextField(
                //   title: 'Language',
                //   context: context,
                //   controller: languageController,
                //   onTap: () {
                //     showPracticalLifeDialog(context, programPlanData?.montessoriSubjects?[0], () {});
                //   },
                // ),
                // const SizedBox(height: 16),

                // CustomMultilineTextField(
                //   title: 'Culture',
                //   context: context,
                //   controller: cultureController,
                //   onTap: () {
                //     showPracticalLifeDialog(context, programPlanData?.montessoriSubjects?[0], () {});
                //   },
                // ),

                // // EYLF
                // const SizedBox(height: 6),
                CustomMultilineTextField(
                  title: 'EYLF',
                  context: context,
                  controller: eylfController,
                  onTap: () {
                    showPracticalLifeDialog(context, programPlanData?.montessoriSubjects?[0], () {});
                  },
                ),
                const SizedBox(height: 16),

                // Additional Experiences
                Text('Additional Experiences',
                    style: Theme.of(context).textTheme.titleSmall),
                const SizedBox(height: 16),
                CustomTextFormWidget(
                  controller: outdoorExperiencesController,
                  hintText: 'Outdoor Experiences',
                  title: 'Outdoor Experiences',
                  maxLines: 3,
                ),
                const SizedBox(height: 16),

                CustomTextFormWidget(
                  controller: inquiryTopicController,
                  hintText: 'Inquiry Topic',
                  title: 'Inquiry Topic',
                  maxLines: 3,
                ),
                const SizedBox(height: 16),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    OutlinedButton(
                      onPressed: () => Navigator.pop(context),
                      child: const Text('CANCEL',
                          style: TextStyle(color: Colors.black)),
                    ),
                    const SizedBox(width: 16),
                    BlocListener<AddPlanBloc, AddPlanState>(
                      listener: (context, state) {
                        if (state is AddPlanFailure) {
                          UIHelpers.showToast(
                            context,
                            message: state.message,
                            backgroundColor: AppColors.errorColor,
                          );
                        } else if (state is AddPlanSuccess) {
                          UIHelpers.showToast(
                            context,
                            message: state.message,
                            backgroundColor: AppColors.successColor,
                          );
                          Navigator.pop(
                              context); // or go to another screen if needed
                        }
                      },
                      child: BlocBuilder<AddPlanBloc, AddPlanState>(
                        builder: (context, state) {
                          return CustomButton(
                            height: 45,
                            width: 100,
                            text: 'SAVE',
                            isLoading: state is AddPlanLoading,
                            ontap: () {
                              try {
                                context.read<AddPlanBloc>().add(
                                      SubmitAddPlanEvent(
                                        planId: (widget.screenType == 'edit')
                                            ? 'id'
                                            : null,
                                        month: selectedMonth ?? '',
                                        year: selectedYear ?? '',
                                        roomId: selectedRoom ?? '',
                                        educators: selectedEducatorIds,
                                        children: selectedChildrenIds,
                                        focusArea: focusAreasController.text,
                                        outdoorExperiences:
                                            outdoorExperiencesController.text,
                                        inquiryTopic:
                                            inquiryTopicController.text,
                                        sustainabilityTopic:
                                            sustainabilityTopicController.text,
                                        specialEvents:
                                            specialEventsController.text,
                                        childrenVoices:
                                            childrenVoicesController.text,
                                        familiesInput:
                                            familiesInputController.text,
                                        groupExperience:
                                            groupExperienceController.text,
                                        spontaneousExperience:
                                            spontaneousExperienceController
                                                .text,
                                        mindfulnessExperience:
                                            mindfulnessExperienceController
                                                .text,
                                        eylf: eylfController.text,
                                        practicalLife:
                                            practicalLifeController.text,
                                        sensorial: sensorialController.text,
                                        math: mathController.text,
                                        language: languageController.text,
                                        culture: cultureController.text,
                                      ),
                                    );
                              } catch (e, s) {
                                print('Error: $e');
                                print('StackTrace: $s');
                              }
                            },
                          );
                        },
                      ),
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

  void _submitForm() {
    if (!_formKey.currentState!.validate()) return;

    // TODO: Implement form submission
    // You can follow the pattern from AddRoomScreen's submit logic

    final formData = {
      'center_id': widget.centerId,
      'month': selectedMonth,
      'year': selectedYear,
      'room_id': selectedRoom,
      'educators': selectedEducatorIds,
      'children': selectedChildrenIds,
      'focus_area': focusAreasController.text,
      'practical_life': practicalLifeController.text,
      'sensorial': sensorialController.text,
      'math': mathController.text,
      'language': languageController.text,
      'culture': cultureController.text,
      'eylf': eylfController.text,
      'outdoor_experiences': outdoorExperiencesController.text,
      'inquiry_topic': inquiryTopicController.text,
      // Add other fields as needed
    };

    if (widget.screenType == 'edit' && widget.programPlan != null) {
      formData['id'] = widget.programPlan!['id'];
      // TODO: Call edit API
    } else {
      // TODO: Call create API
    }
  }

  @override
  void dispose() {
    focusAreasController.dispose();
    outdoorExperiencesController.dispose();
    inquiryTopicController.dispose();
    sustainabilityTopicController.dispose();
    specialEventsController.dispose();
    childrenVoicesController.dispose();
    familiesInputController.dispose();
    groupExperienceController.dispose();
    spontaneousExperienceController.dispose();
    mindfulnessExperienceController.dispose();
    eylfController.dispose();
    practicalLifeController.dispose();
    sensorialController.dispose();
    mathController.dispose();
    languageController.dispose();
    cultureController.dispose();
    super.dispose();
  }
}
