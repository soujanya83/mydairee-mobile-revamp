import 'package:intl/intl.dart';
import 'package:mydiaree/core/config/app_urls.dart';
import 'package:mydiaree/core/services/apiresoponse.dart';
import 'package:mydiaree/features/daily_journal/headchecks/data/model/headcheks_model.dart';
import 'package:mydiaree/features/daily_journal/headchecks/data/model/room_head_check_center_model.dart';

class HeadChecksRepository {
  Future<ApiResponse<HeadCheckListModel?>> getHeadChecksData({
    required String userId,
    required String centerId,
    String? roomId,
    required DateTime date,
  }) async {
    final url = '${AppUrls.baseApiUrl}/api/headChecks?centerid=1&roomid=1';
    print(url);
    print('=============');

    final ApiResponse<HeadCheckListModel?> response = await getAndParseData(
      url,
      fromJson: (json) {
        print('repo json');
        print(json['data']['headChecks']);
        return HeadCheckListModel.fromJson(json['data']);
      },
    );
    print('Response from HeadChecksRepository: ${response.data}');
    return response;
  }

  Future<ApiResponse<RoomHeadChecksCenterModel?>> getCenterRooms(
      String centerId) async {
    final url = '${AppUrls.baseApiUrl}/api/headchecks/getCenterRooms';
    final data = {'centerid': centerId};
    return await postAndParse(
      url,
      data,
      fromJson: (json) => RoomHeadChecksCenterModel.fromJson(json),
    );
  }

  Future<ApiResponse> addHeadChecks({
    required List<String> hours,
    required List<String> mins,
    required List<String> headCounts,
    required List<String> signatures,
    required List<String> comments,
    required String roomId,
    required String centerId,
    required String diaryDate,
    required String userId,
  }) async {
    final url = '${AppUrls.baseApiUrl}/api/headchecks/store';
    final data = {
      "hour": hours,
      "mins": mins,
      "headCount": headCounts,
      "signature": signatures,
      "comments": comments,
      "roomid": roomId,
      "centerid": centerId,
      "diarydate": diaryDate,
      "headcheck": true,
      "userid": userId,
    };
    return await postAndParse(url, data);
  }

  Future<ApiResponse> deleteHeadCheck(String headCheckId) async {
    final url =
        '${AppUrls.baseApiUrl}/api/headcheckdelete?headCheckId=$headCheckId';
    return await postAndParse(url, {});
  }
}
