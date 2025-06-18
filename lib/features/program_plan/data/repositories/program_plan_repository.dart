import 'package:mydiaree/core/config/app_urls.dart';
import 'package:mydiaree/core/services/apiresoponse.dart';
import 'package:mydiaree/features/program_plan/data/model/program_plan_list_model.dart';

class ProgramPlanRepository {
  Future<ApiResponse<ProgramPlanListModel?>> getProgramPlans({
    required String centerId,
    String? searchQuery,
    String? statusFilter,
  }) async {
    return await postAndParse(
      AppUrls.getRooms,
      dummy: true,
      dummyData: dummyProgramPlanListData,
      {
        'center_id': centerId,
        if (searchQuery != null) 'search': searchQuery,
        if (statusFilter != null && statusFilter != 'Select')
          'status': statusFilter,
      },
      fromJson: (json) {
        print('json -----');
        print(json);
        return ProgramPlanListModel.fromJson(json);
      },
    );
  }

  Future<bool> deletePlan({required String planId}) async {
    await Future.delayed(const Duration(milliseconds: 500));
    return true; // simulate success
  }
}

final dummyProgramPlanListData = {
  "plans": [
    {
      "id": "1",
      "roomid": "101",
      "name": "January Plan",
      "startDate": "2025-01-01",
      "endDate": "2025-01-31",
      "inqTopicTitle": "Inquiry About Nature",
      "susTopicTitle": "Sustainability in Daily Life",
      "inqTopicDetails": "Explore trees, animals, and plants.",
      "susTopicDetails": "Reduce, Reuse, Recycle concept.",
      "artExperiments": "Leaf painting, clay modelling",
      "activityDetails": "Storytelling, group reading",
      "outdoorActivityDetails": "Nature walk, garden exploration",
      "otherExperience": "Puppet show and yoga session",
      "specialActivity": "Republic Day Celebration",
      "createdAt": "2024-12-25",
      "createdBy": "Teacher A",
      "checked": "true"
    },
    {
      "id": "2",
      "roomid": "102",
      "name": "February Plan",
      "startDate": "2025-02-01",
      "endDate": "2025-02-28",
      "inqTopicTitle": "Community Helpers",
      "susTopicTitle": "Saving Water",
      "inqTopicDetails": "Know about doctors, teachers, police",
      "susTopicDetails": "Why & how to save water",
      "artExperiments": "Paper collage, badge making",
      "activityDetails": "Role play, poem recitation",
      "outdoorActivityDetails": "Visit to fire station",
      "otherExperience": "Sensory games",
      "specialActivity": "Sports Day",
      "createdAt": "2025-01-26",
      "createdBy": "Teacher B",
      "checked": "false"
    },
    {
      "id": "2",
      "roomid": "102",
      "name": "February Plan",
      "startDate": "2025-02-01",
      "endDate": "2025-02-28",
      "inqTopicTitle": "Community Helpers",
      "susTopicTitle": "Saving Water",
      "inqTopicDetails": "Know about doctors, teachers, police",
      "susTopicDetails": "Why & how to save water",
      "artExperiments": "Paper collage, badge making",
      "activityDetails": "Role play, poem recitation",
      "outdoorActivityDetails": "Visit to fire station",
      "otherExperience": "Sensory games",
      "specialActivity": "Sports Day",
      "createdAt": "2025-01-26",
      "createdBy": "Teacher B",
      "checked": "false"
    },
    {
      "id": "2",
      "roomid": "102",
      "name": "February Plan",
      "startDate": "2025-02-01",
      "endDate": "2025-02-28",
      "inqTopicTitle": "Community Helpers",
      "susTopicTitle": "Saving Water",
      "inqTopicDetails": "Know about doctors, teachers, police",
      "susTopicDetails": "Why & how to save water",
      "artExperiments": "Paper collage, badge making",
      "activityDetails": "Role play, poem recitation",
      "outdoorActivityDetails": "Visit to fire station",
      "otherExperience": "Sensory games",
      "specialActivity": "Sports Day",
      "createdAt": "2025-01-26",
      "createdBy": "Teacher B",
      "checked": "false"
    },
    {
      "id": "2",
      "roomid": "102",
      "name": "February Plan",
      "startDate": "2025-02-01",
      "endDate": "2025-02-28",
      "inqTopicTitle": "Community Helpers",
      "susTopicTitle": "Saving Water",
      "inqTopicDetails": "Know about doctors, teachers, police",
      "susTopicDetails": "Why & how to save water",
      "artExperiments": "Paper collage, badge making",
      "activityDetails": "Role play, poem recitation",
      "outdoorActivityDetails": "Visit to fire station",
      "otherExperience": "Sensory games",
      "specialActivity": "Sports Day",
      "createdAt": "2025-01-26",
      "createdBy": "Teacher B",
      "checked": "false"
    },
    {
      "id": "2",
      "roomid": "102",
      "name": "February Plan",
      "startDate": "2025-02-01",
      "endDate": "2025-02-28",
      "inqTopicTitle": "Community Helpers",
      "susTopicTitle": "Saving Water",
      "inqTopicDetails": "Know about doctors, teachers, police",
      "susTopicDetails": "Why & how to save water",
      "artExperiments": "Paper collage, badge making",
      "activityDetails": "Role play, poem recitation",
      "outdoorActivityDetails": "Visit to fire station",
      "otherExperience": "Sensory games",
      "specialActivity": "Sports Day",
      "createdAt": "2025-01-26",
      "createdBy": "Teacher B",
      "checked": "false"
    },
    {
      "id": "2",
      "roomid": "102",
      "name": "February Plan",
      "startDate": "2025-02-01",
      "endDate": "2025-02-28",
      "inqTopicTitle": "Community Helpers",
      "susTopicTitle": "Saving Water",
      "inqTopicDetails": "Know about doctors, teachers, police",
      "susTopicDetails": "Why & how to save water",
      "artExperiments": "Paper collage, badge making",
      "activityDetails": "Role play, poem recitation",
      "outdoorActivityDetails": "Visit to fire station",
      "otherExperience": "Sensory games",
      "specialActivity": "Sports Day",
      "createdAt": "2025-01-26",
      "createdBy": "Teacher B",
      "checked": "false"
    }
  ]
};
