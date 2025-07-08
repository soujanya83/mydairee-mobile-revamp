import 'package:flutter/material.dart';
import 'package:mydiaree/core/config/app_colors.dart';
import 'package:mydiaree/core/utils/ui_helper.dart';
import 'package:mydiaree/core/widgets/custom_scaffold.dart';
import 'package:mydiaree/core/widgets/dropdowns/center_dropdown.dart';
import 'package:mydiaree/features/program_plan/presentation/bloc/programlist/program_list_bloc.dart';
import 'package:mydiaree/features/program_plan/presentation/bloc/programlist/program_list_event.dart';
import 'package:mydiaree/features/program_plan/presentation/bloc/programlist/program_list_state.dart';
import 'package:mydiaree/features/program_plan/presentation/pages/add_program_plan_screen.dart';
import 'package:mydiaree/features/program_plan/presentation/widget/plan_card.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

// ignore: must_be_immutable
class ProgramPlansListScreen extends StatelessWidget {
  ProgramPlansListScreen({super.key});

  String selectedCenterId = '';
  Map<String, dynamic> programDetaiJson = {
    "month": "June",
    "year": "2025",
    "room_id": "room_123",
    "focus_area": "Physical development",
    "outdoor_experiences": "Water play, sand pit",
    "inquiry_topic": "Life cycle of a butterfly",
    "sustainability_topic": "Recycling",
    "special_events": "Father’s Day celebration",
    "children_voices": "We want more time outside",
    "families_input": "Parents suggested a garden day",
    "group_experience": "Circle time and story telling",
    "spontaneous_experience": "Bird spotted during play",
    "mindfulness_experiences": "Breathing exercises after lunch",
    "eylf": "Outcome 1: Children have a strong sense of identity",
    "practical_life": "Pouring, sweeping",
    "sensorial": "Sound boxes, pink tower",
    "math": "Counting beads, number rods",
    "language": "Letter tracing, sandpaper letters",
    "culture": "Globe, continent puzzle",
    "educators": ["educator_1", "educator_2"],
    "children": ["child_1", "child_2", "child_3"]
  };

  @override
  Widget build(BuildContext context) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      // context
      //     .read<ProgramPlanBloc>()
      //     .add(const FetchProgramPlansEvent(centerId: '1'));
    });
    return CustomScaffold(
      appBar: AppBar(
        title: Text('Program Plan $selectedCenterId',
            style: Theme.of(context).textTheme.headlineSmall),
        backgroundColor: AppColors.primaryColor,
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(12.0),
            child: Row(
              children: [
                Text('Program Plan',
                    style: Theme.of(context).textTheme.headlineSmall),
                const Spacer(),
                UIHelpers.addButton(
                    context: context,
                    ontap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => AddProgramPlanScreen(
                                    centerId: selectedCenterId,
                                    screenType: 'add',
                                  )));
                    }),
              ],
            ),
          ),
          Padding(
              padding: const EdgeInsets.all(12.0),
              child: StatefulBuilder(builder: (context, stateChange) {
                return CenterDropdown(
                    selectedCenterId: selectedCenterId,
                    onChanged: (value) {
                      stateChange(() {});
                      WidgetsBinding.instance.addPostFrameCallback((_) {
                        context.read<ProgramPlanBloc>().add(
                            FetchProgramPlansEvent(centerId: selectedCenterId));
                      });
                      print('--------${value.id.toString()}------------');
                      selectedCenterId = value.id;
                      print('====$selectedCenterId=======');
                    });
              })),
          const SizedBox(height: 10),
          Expanded(
            child: BlocBuilder<ProgramPlanBloc, ProgramPlanListState>(
              builder: (context, state) {
                if (state is ProgramPlanLoading) {
                  return const Center(child: CircularProgressIndicator());
                } else if (state is ProgramPlanError) {
                  return Center(child: Text(state.message));
                } else if (state is ProgramPlanLoaded) {
                  if (state.prgramPlanListData?.plans.isEmpty ?? true) {
                    return const Center(child: Text('No plans found.'));
                  }

                  return ListView.builder(
                    shrinkWrap: true, 
                    itemCount: state.prgramPlanListData?.plans.length ?? 0,
                    itemBuilder: (context, index) {
                      final plan = state.prgramPlanListData!.plans[index];
                      return Padding(
                        padding: const EdgeInsetsGeometry.only(
                            top: 10, bottom: 10, left: 15, right: 15),
                        child: PlanCard(
                          month: DateTime.tryParse(plan.endDate)
                                  ?.month
                                  .toString() ??
                              '',
                          year: DateTime.tryParse(plan.endDate)
                                  ?.year
                                  .toString() ??
                              '',
                          roomName: plan.name,
                          creatorName: plan.createdBy,
                          createdAt: plan.createdAt,
                          updatedAt: plan.endDate,
                          onEditPressed: () {
                            Navigator.push(context,
                                MaterialPageRoute(builder: (context) {
                              return AddProgramPlanScreen(
                                centerId: selectedCenterId,
                                screenType: 'edit',
                                programPlan: programDetaiJson,
                              );
                            }));
                          },
                          onDeletePressed: () {},
                        ),
                      );
                    },
                  );
                }

                return const SizedBox();
              },
            ),
          ),
        ],
      ),
    );
  }
}
