import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mydiaree/core/config/app_colors.dart';
import 'package:mydiaree/core/utils/ui_helper.dart';
import 'package:mydiaree/core/widgets/custom_app_bar.dart';
import 'package:mydiaree/core/widgets/custom_buton.dart';
import 'package:mydiaree/core/widgets/custom_dropdown.dart';
import 'package:mydiaree/core/widgets/custom_multiline_text_field.dart';
import 'package:mydiaree/core/widgets/custom_scaffold.dart';
import 'package:mydiaree/core/widgets/custom_text_field.dart';
import 'package:mydiaree/core/widgets/dropdowns/room_dropdown.dart';
import 'package:mydiaree/features/program_plan/presentation/bloc/programlist/add_plan/add_plan_bloc.dart';
import 'package:mydiaree/features/program_plan/presentation/bloc/programlist/add_plan/add_plan_event.dart';
import 'package:mydiaree/features/program_plan/presentation/bloc/programlist/add_plan/add_plan_state.dart';
import 'package:mydiaree/features/program_plan/presentation/widget/add_plan_widgets.dart';

class AddProgramPlanScreen extends StatefulWidget {
  final String centerId;
  final Map<String, dynamic>? programPlan;
  final String screenType;

  const AddProgramPlanScreen({
    super.key,
    required this.centerId,
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
  List<String> selectedEducators = [];
  List<String> selectedChildren = [];

  @override
  void initState() {
    super.initState();
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
    if (data['educators'] is List) {
      selectedEducators = List<String>.from(data['educators']);
    }
    if (data['children'] is List) {
      selectedChildren = List<String>.from(data['children']);
    }
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

  assignPracticalLifeInController() {
    print('assigning here');
    practicalLifeController.text = '';
    print(
        '======================PracticalLifeController===========================');
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
    assignPracticalLifeData();
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

                // Room selection
                Text('Room', style: Theme.of(context).textTheme.bodyMedium),
                const SizedBox(height: 6),
                RoomDropdown(
                  selectedRoomId: selectedRoomId,
                  onChanged: (room) {
                    setState(() {
                      selectedRoomId = room.id;
                    });
                  },
                ),

                const SizedBox(height: 16),

                // Educators selection
                Text('Educators',
                    style: Theme.of(context).textTheme.bodyMedium),
                const SizedBox(height: 6),
                GestureDetector(
                  onTap: _showEducatorSelectionDialog,
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
                              label: Text(edu),
                              onDeleted: () {
                                setState(() {
                                  selectedEducators.remove(edu);
                                });
                              },
                            ))
                        .toList(),
                  ),
                const SizedBox(height: 16),

                // Children selection
                Text('Children', style: Theme.of(context).textTheme.bodyMedium),
                const SizedBox(height: 6),
                GestureDetector(
                  onTap: _showChildrenSelectionDialog,
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
                ),
                const SizedBox(height: 10),
                if (selectedChildren.isNotEmpty)
                  Wrap(
                    spacing: 8,
                    children: selectedChildren
                        .map((child) => Chip(
                              label: Text(child),
                              onDeleted: () {
                                setState(() {
                                  selectedChildren.remove(child);
                                });
                              },
                            ))
                        .toList(),
                  ),
                const SizedBox(height: 16),

                // Focus Areas
                CustomMultilineTextField(
                  title: 'Practical Life',
                  context: context,
                  controller: practicalLifeController,
                  onTap: () {
                    showPracticalLifeDialog(
                      context,
                      practicalLifeData,
                      assignPracticalLifeInController,
                    );
                  },
                ),
                const SizedBox(height: 16),

                CustomMultilineTextField(
                  title: 'Sensorial',
                  context: context,
                  controller: sensorialController,
                  onTap: () {
                    showPracticalLifeDialog(context, practicalLifeData, () {});
                  },
                ),
                const SizedBox(height: 16),

                CustomMultilineTextField(
                  title: 'Math',
                  context: context,
                  controller: mathController,
                  onTap: () {
                    showPracticalLifeDialog(context, practicalLifeData, () {});
                  },
                ),
                const SizedBox(height: 16),

                CustomMultilineTextField(
                  title: 'Language',
                  context: context,
                  controller: languageController,
                  onTap: () {
                    showPracticalLifeDialog(context, practicalLifeData, () {});
                  },
                ),
                const SizedBox(height: 16),

                CustomMultilineTextField(
                  title: 'Culture',
                  context: context,
                  controller: cultureController,
                  onTap: () {
                    showPracticalLifeDialog(context, practicalLifeData, () {});
                  },
                ),

                // EYLF
                const SizedBox(height: 6),
                CustomMultilineTextField(
                  title: 'EYLF',
                  context: context,
                  controller: eylfController,
                  onTap: () {
                    showPracticalLifeDialog(context, practicalLifeData, () {});
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
                                        educators: selectedEducators,
                                        children: selectedChildren,
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
      'educators': selectedEducators,
      'children': selectedChildren,
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
