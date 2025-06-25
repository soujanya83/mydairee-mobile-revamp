import 'package:mydiaree/core/config/app_urls.dart';
import 'package:mydiaree/core/services/apiresoponse.dart';
import 'package:mydiaree/features/room/data/model/room_list_model.dart';

Map<String, dynamic> dummyRoomListData = {
  "rooms": [
    {
      "id": "1",
      "name": "Room A",
      "color": "#FF5733",
      "userName": "John Doe",
      "status": "Active",
      "capacity": 20,
      "ageFrom": 2,
      "ageTo": 5,
      "educatorIds": ["1", "2"],
      "child": [
        {"name": "Child 1"},
        {"name": "Child 2"}
      ]
    },
    {
      "id": "2",
      "name": "Room B",
      "color": "#33FF57",
      "userName": "Jane Smith",
      "status": "Active",
      "capacity": 15,
      "ageFrom": 3,
      "ageTo": 6,
      "educatorIds": ["2", "3"],
      "child": [
        {"name": "Child 3"}
      ]
    },
    {
      "id": "3",
      "name": "Room C",
      "color": "#3357FF",
      "userName": "Mike Johnson",
      "status": "Inactive",
      "capacity": 10,
      "ageFrom": 1,
      "ageTo": 3,
      "educatorIds": ["1", "3"],
      "child": []
    }
  ],
  "centers": [
    {"id": "1", "centerName": "Main Center"},
    {"id": "2", "centerName": "North Branch"},
    {"id": "3", "centerName": "South Branch"}
  ]
};

class RoomRepository {
  Future<ApiResponse<RoomListModel?>> getRooms({
    required String centerId,
    String? searchQuery,
    String? statusFilter,
  }) async {
    return await postAndParse(
      AppUrls.getRooms,
      dummy: true,
      dummyData: dummyRoomListData,
      {
        'center_id': centerId,
        if (searchQuery != null) 'search': searchQuery,
        if (statusFilter != null && statusFilter != 'Select')
          'status': statusFilter,
      },
      fromJson: (json) => RoomListModel.fromJson(json),
    );
  }

  // Add a new room
  Future<ApiResponse> addOrEditRoom({
    String? id,
    required String centerId,
    required String name,
    required String capacity,
    required String ageFrom,
    required String ageTo,
    required String roomStatus,
    required String color,
    required dynamic educators,
  }) async {
    return postAndParse(
      AppUrls.addRoom,
      dummy: true,
      {
        if (id != null) 'id': id,
        'center_id': centerId,
        'name': name,
        'capacity': capacity,
        'age_from': ageFrom,
        'age_to': ageTo,
        'room_status': roomStatus,
        'color': color,
        'educatos': educators,
      },
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
  Future<ApiResponse> deleteMultipleRooms({
    required List<String> roomIds,
  }) async {
    return postAndParse(
      AppUrls.deleteMultipleRooms,
      dummy: true,
      {
        'room_ids': roomIds,
      },
    );
  }
}
