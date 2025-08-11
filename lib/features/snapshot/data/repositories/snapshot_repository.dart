import 'package:mydiaree/core/config/app_urls.dart';
import 'package:mydiaree/core/services/api_services.dart';
import 'package:mydiaree/core/services/apiresoponse.dart';
import 'package:mydiaree/features/snapshot/data/model/snapshot_model.dart';

class SnapshotRepository {
  Future<List<SnapshotModel>> getSnapshots(String centerId) async {
    // call GET /snapshot/index?centerid=…
    final apiResp = await ApiServices.getData(
      AppUrls.baseUrl + '/api/snapshot/index?centerid=$centerId',
    );

    if (!apiResp.success || apiResp.data == null) {
      throw Exception(apiResp.message);
    }

    final json = apiResp.data as Map<String, dynamic>;
    final paged = json['snapshots'] as Map<String, dynamic>;
    final list = (paged['data'] as List<dynamic>?) ?? [];

    return list
        .map((e) =>
            SnapshotModel.fromJson(e as Map<String, dynamic>))
        .toList();
  }

  Future<ApiResponse> addOrEditSnapshot({
    String? snapshotId,
    required String title,
    required String about,
    required String roomId,
    required List<String> children,
    required List<String> media,
  }) =>
      // keep your existing dummy POST logic
      postAndParse(
        AppUrls.addSnapshot,
        {
          if (snapshotId != null) 'id': snapshotId,
          'title': title,
          'about': about,
          'room_id': roomId,
          'children': children,
          'media': media,
        },
        dummy: true,
      );

  Future<void> deleteSnapshot(int id) async {
    // keep your existing dummy DELETE logic
    await Future.delayed(const Duration(seconds: 1));
  }
}
