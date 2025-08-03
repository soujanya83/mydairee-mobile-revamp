import 'package:mydiaree/core/config/app_urls.dart';
import 'package:mydiaree/core/services/apiresoponse.dart';
import 'package:mydiaree/features/room/data/model/childrens_room_model.dart';
import 'package:mydiaree/features/room/data/model/room_list_model.dart';
import 'package:mydiaree/features/room/data/model/staff_model.dart' show Staff, StaffListModel;

// Map<String, dynamic> dummyRoomListData = {
//   "rooms": [
//     {
//       "id": "1",
//       "name": "Room A",
//       "color": "#FF5733",
//       "userName": "John Doe",
//       "status": "Active",
//       "capacity": 20,
//       "ageFrom": 2,
//       "ageTo": 5,
//       "educatorIds": ["1", "2"],
//       "child": [
//         {"name": "Child 1"},
//         {"name": "Child 2"}
//       ]
//     },
//     {
//       "id": "2",
//       "name": "Room B",
//       "color": "#33FF57",
//       "userName": "Jane Smith",
//       "status": "Active",
//       "capacity": 15,
//       "ageFrom": 3,
//       "ageTo": 6,
//       "educatorIds": ["2", "3"],
//       "child": [
//         {"name": "Child 3"}
//       ]
//     },
//     {
//       "id": "3",
//       "name": "Room C",
//       "color": "#3357FF",
//       "userName": "Mike Johnson",
//       "status": "Inactive",
//       "capacity": 10,
//       "ageFrom": 1,
//       "ageTo": 3,
//       "educatorIds": ["1", "3"],
//       "child": []
//     }
//   ],
//   "centers": [
//     {"id": "1", "centerName": "Main Center"},
//     {"id": "2", "centerName": "North Branch"},
//     {"id": "3", "centerName": "South Branch"}
//   ]
// };

class RoomRepository {
  Future<ApiResponse<RoomListModel?>> getRooms({
    required String centerId,
    String? searchQuery,
    String? statusFilter,
  }) async {
    return await postAndParse(
      AppUrls.getRooms,
      // dummy: true,
      // dummyData: dummyRoomListData,
      {
        'user_center_id': centerId,
      },
      fromJson: (json) => RoomListModel.fromJson(json),
    );
  }

  Future<ApiResponse> addRoom({
    required String roomName,
    required String roomCapacity,
    required String ageFrom,
    required String ageTo,
    required String roomStatus,
    required String roomColor,
    required String dcenterid,
    required List<int> educators,
    String? roomId,
  }) async {
    final data = {
      if (roomId != null) 'id': roomId,
      'room_name': roomName,
      'room_capacity': roomCapacity,
      'ageFrom': ageFrom,
      'ageTo': ageTo,
      'room_status': roomStatus,
      'room_color': roomColor,
      'dcenterid': dcenterid,
      'educators': educators,
    };

    return await postAndParse(
      AppUrls.addRoom,
      data,
    );
  }


Future<ApiResponse<StaffListModel?>> getStaffList() async {
  const url = '${AppUrls.baseApiUrl}/api/staffs';
  return await getAndParseData(
    url,
    fromJson: (json) => StaffListModel.fromJson(json),
  );
}

  // Update room details
  // Future<ApiResponse> updateRoom({
  //   required String roomId,
  //   String? name,
  //   String? color,
  //   String? leadUserId,
  //   String? status,
  //   String? capacity,
  //   String? ageFrom,
  //   String? ageTo,
  // }) async {
  //   return postAndParse(
  //     AppUrls.updateRoom,
  //     dummy: true,
  //     {
  //       'room_id': roomId,
  //       if (name != null) 'name': name,
  //       if (color != null) 'color': color,
  //       if (leadUserId != null) 'lead_user_id': leadUserId,
  //       if (status != null) 'status': status,
  //       if (capacity != null) 'capacity': capacity,
  //       if (ageFrom != null) 'age_from': ageFrom,
  //       if (ageTo != null) 'age_to': ageTo,
  //     },
  //   );
  // }

  // Batch delete rooms
  Future<ApiResponse> deleteMultipleRooms(List<int> selectedRoomIds) async {
    const url = AppUrls
        .bulkDeleteRooms; // e.g. 'https://mydiaree.com.au/api/rooms/bulk-delete'
    final data = {
      "selected_rooms": selectedRoomIds,
    };

    return await deleteDataApi(
      url,
      data: data,
    );
  }

  Future<ApiResponse<ChildrensRoomModel?>> getChildrenByRoomId(
      String roomId) async {
    final url = '${AppUrls.baseApiUrl}/api/room/$roomId/children';
    return await getAndParseData(
      url,
      fromJson: (json) => ChildrensRoomModel.fromJson(json),
    );
  }
}
