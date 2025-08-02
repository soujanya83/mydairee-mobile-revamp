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
import 'package:mydiaree/features/program_plan/data/model/children_program_plan_model.dart';
import 'package:mydiaree/features/program_plan/data/model/program_plan_data_model.dart';
import 'package:mydiaree/features/program_plan/data/model/program_plan_list_model.dart';
import 'package:mydiaree/features/program_plan/data/model/user_add_program_model.dart';
import 'package:mydiaree/features/program_plan/data/repositories/program_plan_repository.dart';
import 'package:mydiaree/features/program_plan/presentation/bloc/programlist/add_plan/add_plan_bloc.dart';
import 'package:mydiaree/features/program_plan/presentation/bloc/programlist/add_plan/add_plan_event.dart';
import 'package:mydiaree/features/program_plan/presentation/bloc/programlist/add_plan/add_plan_state.dart';
import 'package:mydiaree/features/program_plan/presentation/bloc/programlist/program_list_bloc.dart';
import 'package:mydiaree/features/program_plan/presentation/bloc/programlist/program_list_event.dart';
import 'package:mydiaree/features/program_plan/presentation/widget/add_plan_widgets.dart';
import 'package:mydiaree/features/program_plan/presentation/widget/eylf_wrapper.dart';

class AddProgramPlanScreen extends StatefulWidget {
  final String centerId;
  final String? programPlanId;
  final String screenType;
  final ProgramPlan? editPlanData;

  const AddProgramPlanScreen({
    super.key,
    required this.centerId,
    this.programPlanId,
    this.editPlanData,
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

  bool loading = false;

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

  String getMonthNumber(String? monthName) {
    if (monthName == null) return '';
    final months = [
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
    final index = months.indexOf(monthName);
    if (index == -1) return '';
    return (index + 1).toString().padLeft(2, '0');
  }

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
    if (programPlanData == null) {
      getProgramPlan();
    }
    if (widget.screenType == 'edit' && widget.editPlanData != null) {
      _initializeFromExistingData();
    }
  }

  void _initializeFromExistingData() {
    final data = widget.editPlanData!;
    print('Loaded editPlanData: $data');
    selectedMonth = data.months != null
        ? months[(data.months! - 1).clamp(0, months.length - 1)]
        : null;
    print('selectedMonth: $selectedMonth');
    selectedYear = data.years;
    print('selectedYear: $selectedYear');

    // Set text fields
    focusAreasController.text = data.focusArea ?? '';
    print('focusAreasController: ${focusAreasController.text}');
    outdoorExperiencesController.text = data.outdoorExperiences ?? '';
    print('outdoorExperiencesController: ${outdoorExperiencesController.text}');
    inquiryTopicController.text = data.inquiryTopic ?? '';
    print('inquiryTopicController: ${inquiryTopicController.text}');
    sustainabilityTopicController.text = data.sustainabilityTopic ?? '';
    print(
        'sustainabilityTopicController: ${sustainabilityTopicController.text}');
    specialEventsController.text = data.specialEvents ?? '';
    print('specialEventsController: ${specialEventsController.text}');
    childrenVoicesController.text = data.childrenVoices ?? '';
    print('childrenVoicesController: ${childrenVoicesController.text}');
    familiesInputController.text = data.familiesInput ?? '';
    print('familiesInputController: ${familiesInputController.text}');
    groupExperienceController.text = data.groupExperience ?? '';
    print('groupExperienceController: ${groupExperienceController.text}');
    spontaneousExperienceController.text = data.spontaneousExperience ?? '';
    print(
        'spontaneousExperienceController: ${spontaneousExperienceController.text}');
    mindfulnessExperienceController.text = data.mindfulnessExperiences ?? '';
    print(
        'mindfulnessExperienceController: ${mindfulnessExperienceController.text}');
    eylfController.text = data.eylf ?? '';
    print('eylfController: ${eylfController.text}');
    practicalLifeController.text = data.practicalLife ?? '';
    print('practicalLifeController: ${practicalLifeController.text}');
    sensorialController.text = data.sensorial ?? '';
    print('sensorialController: ${sensorialController.text}');
    mathController.text = data.math ?? '';
    print('mathController: ${mathController.text}');
    languageController.text = data.language ?? '';
    print('languageController: ${languageController.text}');
    cultureController.text = data.culture ?? '';
    print('cultureController: ${cultureController.text}');

    selectedRoomId = data.roomId?.toString();
    print('selectedRoomId: $selectedRoomId');
    selectedChildrenIds = data.children != null
        ? data.children!.split(',').map((e) => e.trim()).toList()
        : [];
    selectedEducatorIds = data.educators != null
        ? data.educators!.split(',').map((e) => e.trim()).toList()
        : [];
    if (selectedRoomId != null) {
      ProgramPlanRepository().getRoomUsers(selectedRoomId!).then((roomUsers) {
        setState(() {
          user = roomUsers;
          if (user != null && user!.users!.isNotEmpty) {
            selectedEducatorNames = user!.users!
                .where((u) => selectedEducatorIds.contains(u.id.toString()))
                .map((u) => u.name ?? '')
                .toList();
          }
        });
      });
      ProgramPlanRepository()
          .getRoomChildren(selectedRoomId!)
          .then((roomChildren) {
        setState(() {
          children = roomChildren; 
          if (children != null && children!.children!.isNotEmpty) {
            selectedChildrenNames = children!.children!
                .where((c) => selectedChildrenIds.contains(c.id.toString()))
                .map((c) => c.name ?? '')
                .toList();
          }
        });
      });
    } else {
      user = null;
      children = null;
      selectedEducatorNames = [];
      selectedChildrenNames = [];
    }

    // Set selected educators and children (assuming comma-separated string of IDs)
    if (data.educators != null && data.educators!.isNotEmpty) {
      selectedEducatorIds =
          data.educators!.split(',').map((e) => e.trim()).toList();
      print('selectedEducatorIds: $selectedEducatorIds');
      // Optionally, set selectedEducatorNames if you have user data loaded
    } else {
      selectedEducatorIds = [];
      print('selectedEducatorIds: []');
    }
    if (data.children != null && data.children!.isNotEmpty) {
      selectedChildrenIds =
          data.children!.split(',').map((e) => e.trim()).toList();
      print('selectedChildrenIds: $selectedChildrenIds');
      // Optionally, set selectedChildrenNames if you have children data loaded
    } else {
      selectedChildrenIds = [];
      print('selectedChildrenIds: []');
    }
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
                      (String selectedActivities) {
                        practicalLifeController.text = selectedActivities;
                      },
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
                    showPracticalLifeDialog(
                        context, programPlanData?.montessoriSubjects?[1],
                        (String selectedActivities) {
                      mathController.text = selectedActivities;
                    });
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
                  onTap: () async {
                    await showEylfDialog(
                      context,
                      programPlanData?.eylfOutcomes,
                      (String selectedActivities) {
                        eylfController.text = selectedActivities;
                      },
                    );
                  },
                ),
                const SizedBox(height: 16),
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
                          Navigator.pop(context);
                        }
                      },
                      child: BlocBuilder<AddPlanBloc, AddPlanState>(
                        builder: (context, state) {
                          return CustomButton(
                            height: 45,
                            width: 100,
                            text: 'SAVE',
                            isLoading: loading,
                            ontap: () async {
                              if (selectedMonth == null || selectedMonth!.isEmpty) {
                              UIHelpers.showToast(
                                context,
                                message: 'Please select a month.',
                                backgroundColor: AppColors.errorColor,
                              );
                              return;
                              }
                              if (selectedYear == null || selectedYear!.isEmpty) {
                              UIHelpers.showToast(
                                context,
                                message: 'Please select a year.',
                                backgroundColor: AppColors.errorColor,
                              );
                              return;
                              }
                              if (selectedRoomId == null || selectedRoomId!.isEmpty) {
                              UIHelpers.showToast(
                                context,
                                message: 'Please select a room.',
                                backgroundColor: AppColors.errorColor,
                              );
                              return;
                              }
                              if (selectedEducatorIds.isEmpty) {
                              UIHelpers.showToast(
                                context,
                                message: 'Please select at least one educator.',
                                backgroundColor: AppColors.errorColor,
                              );
                              return;
                              }
                              if (selectedChildrenIds.isEmpty) {
                              UIHelpers.showToast(
                                context,
                                message: 'Please select at least one child.',
                                backgroundColor: AppColors.errorColor,
                              );
                              return;
                              }
                              if (_formKey.currentState?.validate() != true) {
                              return;
                              }
                              
                              try {
                              final ProgramPlanRepository repository =
                                ProgramPlanRepository();
                              setState(() {
                                loading = true;
                              }); 
                              print(widget.programPlanId);
                              print(widget.screenType);
                              final response = await repository.addOrEditPlan(
                                centerId: widget.centerId,
                                planId: (widget.screenType == 'edit')
                                  ? widget.programPlanId
                                  : null,
                                month: getMonthNumber(selectedMonth),
                                year: selectedYear ?? '',
                                roomId: selectedRoomId ?? '',
                                educators: selectedEducatorIds,
                                children: selectedChildrenIds,
                                focusArea: focusAreasController.text,
                                outdoorExperiences:
                                  outdoorExperiencesController.text,
                                inquiryTopic: inquiryTopicController.text,
                                sustainabilityTopic:
                                  sustainabilityTopicController.text,
                                specialEvents: specialEventsController.text,
                                childrenVoices: childrenVoicesController.text,
                                familiesInput: familiesInputController.text,
                                groupExperience:
                                  groupExperienceController.text,
                                spontaneousExperience:
                                  spontaneousExperienceController.text,
                                mindfulnessExperience:
                                  mindfulnessExperienceController.text,
                                eylf: eylfController.text,
                                practicalLife: practicalLifeController.text,
                                sensorial: sensorialController.text,
                                math: mathController.text,
                                language: languageController.text,
                                culture: cultureController.text,
                              );
                              
                              UIHelpers.showToast(
                                context,
                                message: response.message,
                                backgroundColor: response.success
                                  ? AppColors.successColor
                                  : AppColors.errorColor,
                              );
                              setState(() {
                                loading = false;
                              });  
                              if (response.success) {
                                BlocProvider.of<ProgramPlanBloc>(context).add(
                                FetchProgramPlansEvent(
                                  centerId: widget.centerId,
                                ),
                                );
                                Navigator.pop(context);
                              }
                              } catch (e, s) {
                              print('Error: $e');
                              print('StackTrace: $s');
                              setState(() {
                                loading = false;
                              });
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
