import 'package:mydiaree/core/config/app_urls.dart';
import 'package:mydiaree/core/cubit/globle_model/center_model.dart';
import 'package:mydiaree/core/services/apiresoponse.dart';
import 'package:mydiaree/features/program_plan/data/model/children_program_plan_model.dart';
import 'package:mydiaree/features/program_plan/data/model/user_add_program_model.dart';
import 'package:mydiaree/features/room/data/model/room_list_model.dart';

/// holds the globally selected center ID
String? globalSelectedCenterId;

ApiResponse<CenterModel?>? centerDataGloble;

class GlobalRepository {
  Future<ApiResponse<CenterModel?>?> getCenters() async {
    final resp = await getAndParseData<CenterModel?>(
      AppUrls.getCenters,
      fromJson: (json) => CenterModel.fromJson(json),
    );
    if (resp.success && resp.data?.data != null && resp.data!.data!.isNotEmpty) {
      // set the default center ID once
      globalSelectedCenterId = resp.data!.data!.first.id.toString();
      centerDataGloble = resp;
    }
    return resp;
  }

  Future<ApiResponse<ChildrenAddProgramPlanModel?>> getChildren(String roomId) async {
    return postAndParse<ChildrenAddProgramPlanModel?>(
      AppUrls.getRoomChildren,
      {'room_id': roomId},
      fromJson: (json) => ChildrenAddProgramPlanModel.fromJson(json),
    );
  }

  Future<ApiResponse<UserAddProgramPlanModel?>> getEducators(String roomId) async {

    return postAndParse<UserAddProgramPlanModel?>(
      AppUrls.getRoomUsers ,
      {'room_id': roomId},
      fromJson: (json) => UserAddProgramPlanModel.fromJson(json),
    );
  }

  Future<ApiResponse<RoomListModel?>> getRooms({
    required String centerId,
    String? searchQuery,
    String? statusFilter,
  }) async {
    return await postAndParse(
      AppUrls.getRooms,
      {
        'center_id': centerId,
      },
      fromJson: (json) => RoomListModel.fromJson(json),
    );
  }

 
}
