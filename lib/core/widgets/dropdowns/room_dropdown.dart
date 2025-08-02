// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:mydiaree/core/config/app_colors.dart';
// import 'package:mydiaree/features/room/data/model/room_list_model.dart';
// import 'package:mydiaree/features/room/presentation/bloc/list_room/list_room_bloc.dart';
// import 'package:mydiaree/features/room/presentation/bloc/list_room/list_room_event.dart';
// import 'package:mydiaree/features/room/presentation/bloc/list_room/list_room_state.dart';

// class RoomDropdown extends StatelessWidget {
//   final String? selectedRoomId;
//   final String? centerId;
//   final void Function(RoomItem selectedRoom)? onChanged;
//   final double height;
//   final String hint;

//   const RoomDropdown({
//     super.key,
//     this.selectedRoomId,
//     this.onChanged,
//     this.height = 40,
//     this.hint = 'Select Room',
//     this.centerId,
//   });

//   @override
//   Widget build(BuildContext context) {
//     return BlocBuilder<RoomListBloc, RoomListState>(
//       builder: (context, state) {
//         if (state is RoomListInitial) {
//           context
//               .read<RoomListBloc>()
//               .add(FetchRoomsEvent(centerId: centerId ?? '1'));
//         }
//         if (state is RoomListLoading) {
//           return Material(
//             elevation: 1.2,
//             color: AppColors.white,
//             borderRadius: BorderRadius.circular(8),
//             child: Container(
//               height: height,
//               padding: const EdgeInsets.symmetric(horizontal: 12),
//               decoration: BoxDecoration(
//                 border: Border.all(color: AppColors.primaryColor),
//                 borderRadius: BorderRadius.circular(8),
//                 color: AppColors.white,
//               ),
//               child: const Align(
//                 alignment: Alignment.centerLeft,
//                 child: Text("Loading rooms..."),
//               ),
//             ),
//           );
//         } else if (state is RoomListLoaded) {
//           final rooms = state.roomsData.rooms;

//           if (rooms.isEmpty) {
//             return Material(
//               elevation: 1.2,
//               color: AppColors.white,
//               borderRadius: BorderRadius.circular(8),
//               child: Container(
//                 height: height,
//                 padding: const EdgeInsets.symmetric(horizontal: 12),
//                 decoration: BoxDecoration(
//                   border: Border.all(color: Colors.grey),
//                   borderRadius: BorderRadius.circular(8),
//                   color: Colors.grey.shade200,
//                 ),
//                 child: const Align(
//                   alignment: Alignment.centerLeft,
//                   child: Text("No rooms available"),
//                 ),
//               ),
//             );
//           }

//           RoomItem? selectedRoom;
//           if (selectedRoomId != null &&
//               rooms.any((room) => room.id == selectedRoomId)) {
//             selectedRoom =
//                 rooms.firstWhere((room) => room.id == selectedRoomId);
//           }

//           return DropdownButtonHideUnderline(
//             child: Material(
//               elevation: 1.2,
//               color: AppColors.white,
//               borderRadius: BorderRadius.circular(8),
//               child: Container(
//                 height: height,
//                 padding: const EdgeInsets.symmetric(horizontal: 12),
//                 decoration: BoxDecoration(
//                   color: AppColors.white,
//                   border: Border.all(color: AppColors.primaryColor),
//                   borderRadius: BorderRadius.circular(8),
//                 ),
//                 child: DropdownButton<RoomItem>(
//                   isExpanded: true,
//                   value: selectedRoom,
//                   hint: Text(hint),
//                   items: rooms.map((room) {
//                     return DropdownMenuItem<RoomItem>(
//                       value: room,
//                       child: Text(room.name),
//                     );
//                   }).toList(),
//                   onChanged: (value) {
//                     if (value != null) {
//                       onChanged?.call(value);
//                     }
//                   },
//                 ),
//               ),
//             ),
//           );
//         } else if (state is AnnounceListError) {
//           return Text(state.message);
//         }

//         return Container(
//           height: height,
//           padding: const EdgeInsets.symmetric(horizontal: 12),
//           decoration: BoxDecoration(
//             border: Border.all(color: Colors.grey),
//             borderRadius: BorderRadius.circular(8),
//             color: Colors.grey.shade200,
//           ),
//           child: const Align(
//             alignment: Alignment.centerLeft,
//             child: Text("Loading rooms..."),
//           ),
//         );
//       },
//     );
//   }
// }
