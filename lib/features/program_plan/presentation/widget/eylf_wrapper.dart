// import 'dart:convert';
// import 'package:flutter/material.dart';
// import 'package:mydiaree/core/config/app_colors.dart';
// import 'package:mydiaree/core/widgets/custom_buton.dart';
// import 'package:mydiaree/features/program_plan/data/model/program_plan_data_model.dart'; 

// class EylfOutcomeActivityWrapper {
//   EylfOutcomeActivity activity;
//   bool choosen;

//   EylfOutcomeActivityWrapper({
//     required this.activity,
//     this.choosen = false,
//   });
// }

// void showEylfOutcomeDialog(
//   BuildContext context,
//   List<EylfOutcome>? eylfOutcomes,
//   Function() assignEylfOutcomeInController,
// ) {
//   // Create wrappers for activities to manage choosen state
//   List<EylfOutcome> wrappedOutcomes = eylfOutcomes?.map((outcome) {
//         return EylfOutcome(
//           id: outcome.id,
//           title: outcome.title,
//           name: outcome.name,
//           addedBy: outcome.addedBy,
//           addedAt: outcome.addedAt,
//           activities: outcome.activities,
//         );
//       }).toList() ??
//       [];

//   showDialog(
//     context: context,
//     builder: (ctx) {
//       return StatefulBuilder(
//         builder: (context, setState) {
//           return AlertDialog(
//             contentPadding: const EdgeInsets.all(20),
//             backgroundColor: AppColors.white,
//             insetPadding: EdgeInsets.zero,
//             title: Text(
//               'Select EYLF Outcomes',
//               style: Theme.of(context).textTheme.bodyLarge,
//             ),
//             content: Container(
//               color: AppColors.white,
//               width: double.maxFinite,
//               height: 500,
//               child: SingleChildScrollView(
//                 child: Column(
//                   children: [
//                     SingleChildScrollView(
//                       child: Column(
//                         children: List.generate(
//                           wrappedOutcomes.length,
//                           (parentIndex) {
//                             return eylfExpansionTile(
//                               context,
//                               parentIndex,
//                               wrappedOutcomes,
//                               setState,
//                               assignEylfOutcomeInController,
//                             );
//                           },
//                         ),
//                       ),
//                     ),
//                   ],
//                 ),
//               ),
//             ),
//             actions: [
//               CustomButton(
//                 height: 45,
//                 width: 100,
//                 text: 'SAVE',
//                 isLoading: false, // TODO: Add loading state
//                 ontap: () {
//                   assignEylfOutcomeInController();
//                   Navigator.pop(context);
//                 },
//               ),
//             ],
//           );
//         },
//       );
//     },
//   );
// }

// Widget eylfExpansionTile(
//   BuildContext context,
//   int parentIndex,
//   List<EylfOutcome> wrappedOutcomes,
//   StateSetter setState,
//   Function() assignEylfOutcomeInController,
// ) {
//   final outcome = wrappedOutcomes[parentIndex];
//   return ExpansionTile(
//     title: Text(
//       outcome.title ?? 'Untitled Outcome',
//       style: Theme.of(context).textTheme.titleMedium,
//     ),
//     children: outcome.activities?.asMap().entries.map((entry) {
//           final activity = entry.value;
//           return CheckboxListTile(
//             title: Text(
//               activity.title ?? 'Untitled Activity',
//               style: Theme.of(context).textTheme.bodyMedium,
//             ),
//             value: activity.choosen,
//             onChanged: (bool? value) {
//               setState(() {
//                 activity.choosen = value ?? false;
//               });
//             },
//           );
//         }).toList() ??
//         [
//           Text(
//             'No activities available',
//             style: Theme.of(context).textTheme.bodyMedium,
//           ),
//         ],
//   );
// }

// void assignEylfOutcomeInController(
//   List<EylfOutcome>? eylfOutcomes,
//   TextEditingController eylfOutcomeController,
// ) {
//   print('Assigning EYLF outcomes');
//   eylfOutcomeController.text = '';
//   print('======================EylfOutcomeController===========================');
//   for (int parentIndex = 0; parentIndex < (eylfOutcomes?.length ?? 0); parentIndex++) {
//     String outcomeTitle = eylfOutcomes?[parentIndex].title ?? '';
//     bool isDone = false;
//     print('====================*******Outcome Index*****=$parentIndex============================');
//     for (int childIndex = 0;
//         childIndex < (eylfOutcomes?[parentIndex].activities?.length ?? 0);
//         childIndex++) {
//       print(
//           '====================##########Activity Index##########=$childIndex===($parentIndex)=========================');
//       final activityWrapper = eylfOutcomes?[parentIndex].activities?[childIndex] as EylfOutcomeActivityWrapper?;
//       print(
//           '======value=${activityWrapper?.choosen ?? false}==========');

//       if (activityWrapper?.choosen ?? false) {
//         if (!isDone) {
//           eylfOutcomeController.text += '**$outcomeTitle** - \n';
//           isDone = true;
//         }

//         String activityTitle = activityWrapper?.activity.title ?? '';
//         print('===================00eir0ir0====================');
//         eylfOutcomeController.text += '**• **$activityTitle.\n';
//       }
//     }
//   }
//   Future.delayed(const Duration(seconds: 3), () {
//     print('Text field content:');
//     print(eylfOutcomeController.text);
//   });
// }