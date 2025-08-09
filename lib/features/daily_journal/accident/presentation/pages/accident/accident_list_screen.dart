// // accident_list_screen.dart

// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:mydiaree/core/config/app_colors.dart';
// import 'package:mydiaree/core/utils/ui_helper.dart';
// import 'package:mydiaree/core/widgets/custom_app_bar.dart';
// import 'package:mydiaree/core/widgets/custom_background_widget.dart';
// import 'package:mydiaree/core/widgets/custom_scaffold.dart';
// import 'package:mydiaree/core/widgets/dropdowns/center_dropdown.dart';
// import 'package:mydiaree/core/widgets/dropdowns/room_dropdown.dart';
// import 'package:mydiaree/features/daily_journal/accident/presentation/bloc/accident_list/accident_list_bloc.dart';
// import 'package:mydiaree/features/daily_journal/accident/presentation/bloc/accident_list/accident_list_event.dart';
// import 'package:mydiaree/features/daily_journal/accident/presentation/pages/accident/add_accident_screen.dart';

// // ignore: must_be_immutable
// class AccidentListScreen extends StatelessWidget{
//   AccidentListScreen({super.key});
//   String? selectedCenterId;
//   String? selectedRoomId;
//   @override
//   Widget build(BuildContext context) {
//     return BlocProvider(
//       create: (context) => AccidentListBloc()..add(LoadAccidentsEvent()),
//       child: CustomScaffold(
//         appBar: const CustomAppBar(title: 'Accident List'),
//         body: BlocBuilder<AccidentBloc, AccidentState>(
//           builder: (context, state) {
//             if (state is AccidentLoadingState) {
//               return const Center(child: CircularProgressIndicator());
//             } else if (state is AccidentLoadedState) {
//               if (state.accidents.isEmpty) {
//                 return const Center(child: Text('No accidents found.'));
//               }
//               return Column(
//                 children: [
//                   Padding(
//                     padding: const EdgeInsets.all(20.0),
//                     child: Row(
//                       mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                       children: [
//                         Text('Accidents',
//                             style: Theme.of(context).textTheme.bodyLarge),
//                         UIHelpers.addButton(
//                           context: context,
//                           ontap: () {
//                             Navigator.push(context,
//                                 MaterialPageRoute(builder: (context) {
//                               return AddAccidentScreen(
//                                 centerid: selectedCenterId ?? '',
//                                 roomid: selectedRoomId ?? '',
//                                 accid: '',
//                                 type: 'add',
//                               );
//                             }));
//                           },
//                         ),
//                       ],
//                     ),
//                   ),
//                   StatefulBuilder(builder: (context, setState) {
//                     return CenterDropdown(
//                       selectedCenterId: selectedCenterId,
//                       onChanged: (value) {
//                         setState(
//                           () {
//                             selectedCenterId = value.id;
//                           },
//                         );
//                       },
//                     );
//                   }),
//                   // Text('Room', style: Theme.of(context).textTheme.bodyMedium),
//                   const SizedBox(height: 6),
//                   // Padding(
//                   //   padding: const EdgeInsets.only(left: 10, right: 10),
//                   //   child: StatefulBuilder(builder: (context, setState) {
//                   //     return RoomDropdown(
//                   //       selectedRoomId: selectedRoomId,
//                   //       onChanged: (room) {
//                   //         setState(() {
//                   //           selectedRoomId = room.id;
//                   //         });
//                   //       },
//                   //     );
//                   //   }),
//                   // ),
//                   ListView.builder(
//                     shrinkWrap: true,
//                     itemCount: state.accidents.length,
//                     // separatorBuilder: (_, __) => const Divider(height: 1),
//                     itemBuilder: (context, index) {
//                       final accident = state.accidents[index];
//                       return Padding(
//                         padding:
//                             const EdgeInsets.only(top: 8, left: 20, right: 20),
//                         child: PatternBackground(
//                           elevation: 1,
//                           borderRadius: BorderRadius.circular(5),
//                           child: ListTile(
//                             contentPadding: const EdgeInsets.symmetric(
//                                 horizontal: 16, vertical: 10),
//                             leading: CircleAvatar(
//                               backgroundColor:
//                                   // ignore: deprecated_member_use
//                                   AppColors.primaryColor.withOpacity(.3),
//                               child: Text(
//                                 '${index + 1}',
//                                 style: const TextStyle(
//                                     color: Colors.blue,
//                                     fontWeight: FontWeight.bold),
//                               ),
//                             ),
//                             title: GestureDetector(
//                               onTap: () {
//                                 Navigator.pushNamed(
//                                   context,
//                                   '/accident/details',
//                                   arguments: accident,
//                                 );
//                               },
//                               child: Text(
//                                 accident.childName,
//                                 style: const TextStyle(
//                                   color: AppColors.primaryColor,
//                                   fontWeight: FontWeight.w600,
//                                   fontSize: 16,
//                                 ),
//                               ),
//                             ),
//                             subtitle: Padding(
//                               padding: const EdgeInsets.only(top: 6.0),
//                               child: Column(
//                                 crossAxisAlignment: CrossAxisAlignment.start,
//                                 children: [
//                                   Text(
//                                     'Created By: ${accident.createdBy}',
//                                     style: const TextStyle(
//                                         fontSize: 13, color: Colors.black87),
//                                   ),
//                                   const SizedBox(height: 2),
//                                   Text(
//                                     accident.date,
//                                     style: const TextStyle(
//                                         fontSize: 12, color: Colors.grey),
//                                   ),
//                                 ],
//                               ),
//                             ),
//                             trailing: Container(
//                               height: 40,
//                               width: 40,
//                               decoration: BoxDecoration(
//                                 color: AppColors.grey.withOpacity(.3),
//                                 shape: BoxShape.circle,
//                               ),
//                               child: IconButton(
//                                 icon: const Icon(Icons.edit,
//                                     color: AppColors.black),
//                                 onPressed: () {},
//                               ),
//                             ),
//                           ),
//                         ),
//                       );
//                     },
//                   ),
//                 ],
//               );
//             } else if (state is AccidentErrorState) {
//               return Center(child: Text(state.message));
//             }
//             return const SizedBox.shrink();
//           },
//         ),
//       ),
//     );
//   }
// }
