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
  Future<ApiResponse> addRoom({
    required String centerId,
    required String name,
    required String color,
    required String leadUserId,
  }) async {
    return postAndParse(
      AppUrls.addRoom,
      dummy: true,
      {
        'center_id': centerId,
        'name': name,
        'color': color,
        'lead_user_id': leadUserId,
      },
    );
  }

  // Update room details
  Future<ApiResponse> updateRoom({
    required String roomId,
    String? name,
    String? color,
    String? leadUserId,
    String? status,
  }) async {
    return postAndParse(
      AppUrls.updateRoom,
      dummy: true,
      {
        'room_id': roomId,
        if (name != null) 'name': name,
        if (color != null) 'color': color,
        if (leadUserId != null) 'lead_user_id': leadUserId,
        if (status != null) 'status': status,
      },
    );
  }

  // Delete single room
  Future<ApiResponse> deleteRoom({
    required String roomId,
  }) async {
    return postAndParse(
      AppUrls.deleteRoom,
      dummy: true,
      {
        'room_id': roomId,
      },
    );
  }

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
