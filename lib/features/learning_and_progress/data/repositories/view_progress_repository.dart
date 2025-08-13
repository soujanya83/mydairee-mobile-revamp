import 'package:mydiaree/core/config/app_urls.dart';
import 'package:mydiaree/core/services/api_services.dart';
import 'package:mydiaree/core/services/apiresoponse.dart';
import 'package:mydiaree/features/learning_and_progress/data/model/assessment_model.dart';

class ViewProgressRepository {
  /// Fetches the child's learning & progress data and returns a list of assessments.
  Future<ApiResponse<List<AssessmentModel>?>> fetchAssessments(String childId) async {
    final resp = await ApiServices.getData(
      AppUrls.baseUrl+'/api/learningandprogress/lnpdata?id=$childId',           
    );
    if (!resp.success || resp.data == null) {
      return ApiResponse(success: false, message: resp.message, data: null);
    }

    final json = resp.data as Map<String, dynamic>;
    final data = (json['data'] ?? {}) as Map<String, dynamic>;
    final plan = (data['progress_plan'] as List<dynamic>?) ?? [];

    final assessments = plan
        .map((e) => AssessmentModel.fromJson(e as Map<String, dynamic>))
        .toList();

    return ApiResponse(
      success: true,
      message: resp.message,
      data: assessments,
    );
  }

  Future<ApiResponse<void>> updateAssessmentStatus(
      String assessmentId,
      String childId,
      AssessmentStatus newStatus,
  ) async {
    final resp = await ApiServices.postData(
      '',           // ← ensure this URL is defined
      {
        'id': assessmentId,
        'childid': childId,
        'status': newStatus.toString().split('.').last,
      },
    );
    return ApiResponse(success: resp.success, message: resp.message);
  }
}