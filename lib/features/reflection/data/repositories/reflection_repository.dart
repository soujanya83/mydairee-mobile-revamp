import 'package:mydiaree/core/config/app_urls.dart';
import 'package:mydiaree/core/services/apiresoponse.dart';
import 'package:mydiaree/features/reflection/data/model/reflection_list_model.dart';
import 'package:mydiaree/features/reflection/data/model/reflection_new_model.dart';

class ReflectionRepository {
  /// Fetch all reflections
  Future<ApiResponse<ReflectionListModel?>> getReflections({
    required String centerId,
    String? search,
    String? status,
    List<String>? children,
    List<String>? authors,
    int? page,
  }) async {
    return await getAndParseData(
      '${AppUrls.getReflections}?center_id=$centerId&page=${page ?? 1}',
      fromJson: (json) => ReflectionListModel.fromJson(json),
    );
  }

  Future<ApiResponse> addOrEditReflection({
    String? reflectionId,
    required String title,
    required String about,
    required String eylf,
    required String roomId,
    required List<String> children,
    required List<String> educators,
    required List<String> media,
  }) async {
    return await postAndParse(
      AppUrls.addReflection,
      dummy: true,
      {
        if (reflectionId != null) 'id': reflectionId,
        'title': title,
        'about': about,
        'eylf': eylf,
        'room_id': roomId,
        'children': children,
        'educators': educators,
        'media': media,
      },
    );
  }

  /// Delete multiple reflections
  Future<ApiResponse> deleteReflections(List<String> reflectionIds) async {
    return await postAndParse(
      AppUrls.deleteReflections, // Add to AppUrls.dart
      dummy: true,
      {
        'reflection_ids': reflectionIds,
      },
    );
  }

  Future<ApiResponse<ReflectionNewModel?>> getReflectionDataNew(
      String id) async {
    return await getAndParseData(
      '${AppUrls.addNewReflection}?id=$id',
      fromJson: (json) => ReflectionNewModel.fromJson(json),
    );
  }

  Future<ApiResponse> addReflectionWithFiles({
    required String title,
    required String about,
    required String eylf,
    required String selectedRoom,
    required String selectedChildren,
    required String selectedStaff,
    required String centerId,
    List<String>? files,
    String? id,
  }) async {
    final data = {
      'center_id': centerId,
      'title': title,
      'about': 'about',
      'eylf': eylf,
      'selected_rooms': selectedRoom,
      'selected_children': selectedChildren,
      'selected_staff': selectedStaff,
      if (id != null) 'id': id,
    };
    print(data);
    if (files != null && files.isNotEmpty) {
      print('Files: $files');
    } else {
      print('No files to upload');
    }

    return await postAndParse(
      AppUrls.addReflection,
      data,
      filesPath: files,
      fileField: 'media[]',
    );
  }

  Future<ApiResponse> deleteReflection(String reflectionId) async {
    return await deleteDataApi(
      '${AppUrls.deleteReflection}/$reflectionId',
    );
  }
}
