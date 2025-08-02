import 'package:flutter/material.dart';
import 'package:mydiaree/core/config/app_colors.dart';
import 'package:mydiaree/core/widgets/custom_buton.dart';
import 'package:mydiaree/features/program_plan/data/model/program_plan_data_model.dart';

Widget montessoriExpansionTile(
  BuildContext context,
  int parentIndex,
  MontessoriSubject? data,
  void Function(void Function()) setState,
  Function(MontessoriSubject) assignController,
) {
  return Container(
    margin: const EdgeInsets.symmetric(vertical: 6),
    decoration: BoxDecoration(
        border: Border.all(color: AppColors.primaryColor),
        borderRadius: const BorderRadius.all(Radius.circular(6)),
        color: AppColors.white),
    child: Theme(
      data: Theme.of(context).copyWith(dividerColor: Colors.transparent),
      child: ExpansionTile(
        iconColor: AppColors.primaryColor,
        tilePadding: const EdgeInsets.symmetric(horizontal: 16),
        childrenPadding: const EdgeInsets.only(left: 12, right: 12, bottom: 12),
        title: Text(
          data?.activities?[parentIndex].title ?? '',
          style: const TextStyle(fontSize: 15),
        ),
        trailing: null,
        onExpansionChanged: (val) {
          setState(() {});
        },
        children: List.generate(
          data?.activities?[parentIndex].subActivities?.length ?? 0,
          (childIndex) {
            return CheckboxListTile(
              fillColor: const WidgetStatePropertyAll(AppColors.primaryColor),
              checkColor: AppColors.white,
              title: Text(
                data?.activities?[parentIndex].subActivities?[childIndex]
                        .title ??
                    '',
              ),
              value: data?.activities?[parentIndex].subActivities?[childIndex]
                      .choosen ??
                  false,
              onChanged: (val) {
                setState(() {
                  data?.activities?[parentIndex].subActivities?[childIndex]
                      .choosen = val ?? false;
                  assignController(data!);
                });
              },
            );
          },
        ),
      ),
    ),
  );
}

Future<MontessoriSubject?> showPracticalLifeDialog(
    BuildContext context,
    MontessoriSubject? practicalLifeData,
    Function(String) assignPracticalLifeInController) async {
  MontessoriSubject? selectedData = practicalLifeData;
  final result = await showDialog<MontessoriSubject>(
    context: context,
    builder: (ctx) {
      return StatefulBuilder(
        builder: (context, setState) {
          return AlertDialog(
            contentPadding: EdgeInsets.all(20),
            backgroundColor: AppColors.white,
            insetPadding: EdgeInsets.zero,
            title: Text(
              'Select Practical Life',
              style: Theme.of(context).textTheme.bodyLarge,
            ),
            content: Container(
              color: AppColors.white,
              width: double.maxFinite,
              height: 500,
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    SingleChildScrollView(
                      child: Column(
                        children: List.generate(
                          selectedData?.activities?.length ?? 0,
                          (parentIndex) {
                            return montessoriExpansionTile(
                              context,
                              parentIndex,
                              selectedData,
                              setState,
                              (data) {
                                selectedData = data;
                                String selectedActivities = '';
                                for (int i = 0;
                                    i < (data.activities?.length ?? 0);
                                    i++) {
                                  final activity = data.activities?[i];
                                  bool isDone = false;
                                  for (int j = 0;
                                      j <
                                          (activity?.subActivities?.length ??
                                              0);
                                      j++) {
                                    final subActivity =
                                        activity?.subActivities?[j];
                                    if (subActivity?.choosen ?? false) {
                                      if (!isDone) {
                                        selectedActivities +=
                                            '**${activity?.title ?? ''}** - \n';
                                        isDone = true;
                                      }
                                      selectedActivities +=
                                          '**• **${subActivity?.title ?? ''}.\n';
                                    }
                                  }
                                }
                                assignPracticalLifeInController(
                                    selectedActivities);
                              },
                            );
                          },
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            actions: [
              CustomButton(
                  height: 45,
                  width: 100,
                  text: 'SAVE',
                  isLoading: false, // TODO: Add loading state
                  ontap: () {
                    Navigator.pop(context, selectedData);
                  })
            ],
          );
        },
      );
    },
  );
  return result;
}

// EYLF Expansion Tile Widget
Widget eylfExpansionTile(
  BuildContext context,
  int parentIndex,
  EylfOutcome? data,
  void Function(void Function()) setState,
  Function(EylfOutcome) assignController,
) {
  return Container(
    margin: const EdgeInsets.symmetric(vertical: 6),
    decoration: BoxDecoration(
      border: Border.all(color: AppColors.primaryColor),
      borderRadius: const BorderRadius.all(Radius.circular(6)),
      color: AppColors.white,
    ),
    child: Theme(
      data: Theme.of(context).copyWith(dividerColor: Colors.transparent),
      child: ExpansionTile(
        iconColor: AppColors.primaryColor,
        tilePadding: const EdgeInsets.symmetric(horizontal: 16),
        childrenPadding: const EdgeInsets.only(left: 12, right: 12, bottom: 12),
        title: Text(
          data?.activities?[parentIndex].title ?? '',
          style: const TextStyle(fontSize: 15),
        ),
        trailing: null,
        onExpansionChanged: (val) {
          setState(() {});
        },
        children: List.generate(
          data?.activities?.length ?? 0,
          (childIndex) {
            final activity = data?.activities?[childIndex];
            return CheckboxListTile(
              fillColor: const WidgetStatePropertyAll(AppColors.primaryColor),
              checkColor: AppColors.white,
              title: Text(activity?.title ?? ''),
              value: activity?.choosen ?? false,
              onChanged: (val) {
                setState(() {
                  data?.activities?[childIndex].choosen = val ?? false;
                  assignController(data!);
                });
              },
            );
          },
        ),
      ),
    ),
  );
}
 
Future<List<EylfOutcome>?> showEylfDialog(
  BuildContext context,
  List<EylfOutcome>? eylfData,
  Function(String) assignEylfInController,
) async {
  List<EylfOutcome>? selectedData = eylfData != null
      ? eylfData.map((e) => EylfOutcome.fromJson(e.toJson())).toList()
      : [];
  final result = await showDialog<List<EylfOutcome>>(
    context: context,
    builder: (ctx) {
      return StatefulBuilder(
        builder: (context, setState) {
          return AlertDialog(
            contentPadding: const EdgeInsets.all(20),
            backgroundColor: AppColors.white,
            insetPadding: EdgeInsets.zero,
            title: Text(
              'Select EYLF Outcomes',
              style: Theme.of(context).textTheme.bodyLarge,
            ),
            content: Container(
              color: AppColors.white,
              width: double.maxFinite,
              height: 500,
              child: SingleChildScrollView(
                child: Column(
                  children: List.generate(
                    selectedData?.length ?? 0,
                    (parentIndex) {
                      final outcome = selectedData![parentIndex];
                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            outcome.title ?? '',
                            style: const TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 16),
                          ),
                          ...List.generate(
                            outcome.activities?.length ?? 0,
                            (childIndex) {
                              final activity = outcome.activities![childIndex];
                              return CheckboxListTile(
                                fillColor: const WidgetStatePropertyAll(
                                    AppColors.primaryColor),
                                checkColor: AppColors.white,
                                title: Text(activity.title ?? ''),
                                value: activity.choosen,
                                onChanged: (val) {
                                  setState(() {
                                    activity.choosen = val ?? false;
                                    String selectedActivities = '';
                                    for (final out in selectedData) {
                                      bool isDone = false;
                                      for (final act in out.activities ?? []) {
                                        if (act.choosen) {
                                          if (!isDone) {
                                            selectedActivities +=
                                                '**${out.title ?? ''}** - \n';
                                            isDone = true;
                                          }
                                          selectedActivities +=
                                              '**• **${act.title ?? ''}.\n';
                                        }
                                      }
                                    }
                                    assignEylfInController(selectedActivities);
                                  });
                                },
                              );
                            },
                          ),
                          const Divider(),
                        ],
                      );
                    },
                  ),
                ),
              ),
            ),
            actions: [
              CustomButton(
                height: 45,
                width: 100,
                text: 'SAVE',
                isLoading: false,
                ontap: () {
                  Navigator.pop(context, selectedData);
                },
              )
            ],
          );
        },
      );
    },
  );
  return result;
}
