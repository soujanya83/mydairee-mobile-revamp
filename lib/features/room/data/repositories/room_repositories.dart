import 'package:mydiaree/core/config/app_urls.dart';
import 'package:mydiaree/core/services/apiresoponse.dart';
import 'package:mydiaree/features/room/data/model/childrens_room_model.dart';
import 'package:mydiaree/features/room/data/model/room_list_model.dart';
import 'package:mydiaree/features/room/data/model/staff_model.dart' show Staff, StaffListModel;
 
class RoomRepository {
  Future<ApiResponse<RoomListModel?>> getRooms({
    required String centerId,
    String? searchQuery,
    String? statusFilter,
  }) async {
    String url = '${AppUrls.baseUrl}/api/rooms?user_center_id=$centerId';
    print('=============== Room Fetch URL ===============');
    print(url);
    return await getAndParseData(
      url,
      fromJson:(json){
        print('=========+++++++++++++++++==========');
        print(json);
        return RoomListModel.fromJson(json);
      },
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
    print('edit room data: $data');

    return await postAndParse(
      AppUrls.addRoom,
      data,
    );
  }


Future<ApiResponse<StaffListModel?>> getStaffList() async {
  const url = '${AppUrls.baseUrl}/api/staffs';
  return await getAndParseData(
    url,
    fromJson: (json) => StaffListModel.fromJson(json),
  );
}
 
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
    final url = '${AppUrls.baseUrl}/api/room/$roomId/children';
    return await getAndParseData(
      url,
      fromJson: (json) => ChildrensRoomModel.fromJson(json),
    );
  }
}
