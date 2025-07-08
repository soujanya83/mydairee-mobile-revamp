import 'package:intl/intl.dart';
import 'package:mydiaree/core/config/app_urls.dart';
import 'package:mydiaree/core/services/apiresoponse.dart';
import 'package:mydiaree/features/daily_journal/headchecks/data/model/headcheks_model.dart';
import 'package:mydiaree/features/daily_journal/headchecks/presentation/bloc/accident_list/heachckecks_list_state.dart';

class HeadChecksRepository {

  Future<ApiResponse<HeadCheckListModel?>> getHeadChecksData({
    required String userId,
    required String centerId,
    String? roomId,
    required DateTime date,
  }) async {
    return await postAndParse(
      AppUrls.getHeadChecks,
      dummy: true,
      dummyData: dummyHeadCheckListData,
      {
        'userid': userId,
        'centerid': centerId,
        if (roomId != null) 'roomid': roomId,
        'date': DateFormat("yyyy-MM-dd").format(date),
      },
      fromJson: (json) {
        try {
          return HeadCheckListModel.fromJson(json);
        } catch (e, s) {
          print('====================');
          print(e.toString());
          print('----------');
          print(s.toString());
          print('----------');
          return HeadCheckListModel.fromJson(dummyHeadCheckListData);
        }
      },
    );
  }

  Future<ApiResponse> saveHeadChecks({
    required String userId,
    required String roomId,
    required DateTime date,
    required List<HeadCheckData> headChecks,
  }) async {
    final data = headChecks
        .asMap()
        .entries
        .map((entry) => {
              'time': '${entry.value.hour}:${entry.value.minute}',
              'headcount': entry.value.headCountController.text,
              'signature': entry.value.signatureController.text,
              'comments': entry.value.commentsController.text,
              'roomid': roomId,
              'diarydate': DateFormat("dd-MM-yyyy").format(date),
              'createdAt': DateTime.now().toString(),
              'createdBy': userId,
            })
        .toList();
    final objToSend = {
      'userid': userId,
      'headcounts': data,
    };

    return await postAndParse(
      AppUrls.addHeadChecks,
      dummy: true,
      objToSend,
    );
  }
}