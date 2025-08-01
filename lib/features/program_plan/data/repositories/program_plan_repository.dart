import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:mydiaree/core/config/app_urls.dart';
import 'package:mydiaree/core/services/apiresoponse.dart';
import 'package:mydiaree/features/program_plan/data/model/program_plan_data_model.dart'
    hide User;
import 'package:mydiaree/features/program_plan/data/model/program_plan_list_model.dart';
import 'package:http/http.dart' as http;
import 'package:mydiaree/core/config/app_urls.dart';
import 'package:mydiaree/features/program_plan/data/model/UsersAddProgramPlan.dart';
import 'package:mydiaree/features/program_plan/data/model/ChildrenAddProgramPlan.dart';

class ProgramPlanRepository {
  Future<ApiResponse<ProgramPlanListModel?>> getProgramPlans({
    required String centerId,
    String? searchQuery,
    String? statusFilter,
  }) async {
    return await getAndParseData<ProgramPlanListModel?>(
      AppUrls.programPlan,
      queryParameters: {'centerid': centerId},
      fromJson: (json) {
        if (kDebugMode) {
          print('Program Plan List Data: ${jsonEncode(json)}');
        }
        return ProgramPlanListModel.fromJson(json);
      },
    );
  }

  Future<ApiResponse<ProgramPlanData?>> getProgramPlanData({
    required String centerId,
    String? planId,
  }) async {
    return await getAndParseData<ProgramPlanData?>(
      AppUrls.programPlanCreate,
      queryParameters: {'centerid': centerId, 'planId': planId},
      fromJson: (json) {
        if (kDebugMode) {
          print('Program Plan Data: ${jsonEncode(json)}');
        }
        return ProgramPlanData.fromJson(json);
      },
    );
  }

  Future<UserAddProgramPlanModel?> getRoomUsers(String roomId) async {
    if (kDebugMode) {
      print('calling getRoomUsers with roomId: $roomId');
    }
    final response = await postAndParse(
      AppUrls.getRoomUsers,
      {'room_id': roomId},
      dummy: false,
      fromJson: (json) => UserAddProgramPlanModel.fromJson(json),
    );
    print('Response from getRoomUsers: ${response.data}');
    return response.data;
  }

  Future<ChildrenAddProgramPlanModel?> getRoomChildren(String roomId) async {
    if (kDebugMode) {
      print('calling getRoomChildren with roomId: $roomId');
    }
    final response = await postAndParse(
      AppUrls.getRoomChildren,
      {'room_id': roomId},
      dummy: false,
      fromJson: (json) => ChildrenAddProgramPlanModel.fromJson(json),
    ); 
    return response.data;
  }

  Future<ApiResponse> addOrEditPlan({
    String? planId,
    required String month,
    required String year,
    required String roomId,
    required List<String> educators,
    required List<String> children,
    required String focusArea,
    required String outdoorExperiences,
    required String inquiryTopic,
    required String sustainabilityTopic,
    required String specialEvents,
    required String childrenVoices,
    required String familiesInput,
    required String groupExperience,
    required String spontaneousExperience,
    required String mindfulnessExperience,
    required String eylf,
    required String practicalLife,
    required String sensorial,
    required String math,
    required String language,
    required String culture,
  }) async {
    return postAndParse(
      AppUrls.addPlan,
      dummy: true,
      {
        if (planId != null) 'id': planId,
        'month': month,
        'year': year,
        'room_id': roomId,
        'educators': educators,
        'children': children,
        'focus_area': focusArea,
        'outdoor_experiences': outdoorExperiences,
        'inquiry_topic': inquiryTopic,
        'sustainability_topic': sustainabilityTopic,
        'special_events': specialEvents,
        'children_voices': childrenVoices,
        'families_input': familiesInput,
        'group_experience': groupExperience,
        'spontaneous_experience': spontaneousExperience,
        'mindfulness_experiences': mindfulnessExperience,
        'eylf': eylf,
        'practical_life': practicalLife,
        'sensorial': sensorial,
        'math': math,
        'language': language,
        'culture': culture,
      },
    );
  }

  Future<ApiResponse> deletePlan({required String planId}) async {
    return postAndParse(
      AppUrls.deletedataofprogramplan,
      dummy: false,
      {
        'program_id': planId,
      },
    );
  }
}

// final dummyProgramPlanListData = {
//   "plans": [
//     {
//       "id": "1",
//       "roomid": "101",
//       "name": "January Plan",
//       "startDate": "2025-01-01",
//       "endDate": "2025-01-31",
//       "inqTopicTitle": "Inquiry About Nature",
//       "susTopicTitle": "Sustainability in Daily Life",
//       "inqTopicDetails": "Explore trees, animals, and plants.",
//       "susTopicDetails": "Reduce, Reuse, Recycle concept.",
//       "artExperiments": "Leaf painting, clay modelling",
//       "activityDetails": "Storytelling, group reading",
//       "outdoorActivityDetails": "Nature walk, garden exploration",
//       "otherExperience": "Puppet show and yoga session",
//       "specialActivity": "Republic Day Celebration",
//       "createdAt": "2024-12-25",
//       "createdBy": "Teacher A",
//       "checked": "true"
//     },
//     {
//       "id": "2",
//       "roomid": "102",
//       "name": "February Plan",
//       "startDate": "2025-02-01",
//       "endDate": "2025-02-28",
//       "inqTopicTitle": "Community Helpers",
//       "susTopicTitle": "Saving Water",
//       "inqTopicDetails": "Know about doctors, teachers, police",
//       "susTopicDetails": "Why & how to save water",
//       "artExperiments": "Paper collage, badge making",
//       "activityDetails": "Role play, poem recitation",
//       "outdoorActivityDetails": "Visit to fire station",
//       "otherExperience": "Sensory games",
//       "specialActivity": "Sports Day",
//       "createdAt": "2025-01-26",
//       "createdBy": "Teacher B",
//       "checked": "false"
//     },
//     {
//       "id": "2",
//       "roomid": "102",
//       "name": "February Plan",
//       "startDate": "2025-02-01",
//       "endDate": "2025-02-28",
//       "inqTopicTitle": "Community Helpers",
//       "susTopicTitle": "Saving Water",
//       "inqTopicDetails": "Know about doctors, teachers, police",
//       "susTopicDetails": "Why & how to save water",
//       "artExperiments": "Paper collage, badge making",
//       "activityDetails": "Role play, poem recitation",
//       "outdoorActivityDetails": "Visit to fire station",
//       "otherExperience": "Sensory games",
//       "specialActivity": "Sports Day",
//       "createdAt": "2025-01-26",
//       "createdBy": "Teacher B",
//       "checked": "false"
//     },
//     {
//       "id": "2",
//       "roomid": "102",
//       "name": "February Plan",
//       "startDate": "2025-02-01",
//       "endDate": "2025-02-28",
//       "inqTopicTitle": "Community Helpers",
//       "susTopicTitle": "Saving Water",
//       "inqTopicDetails": "Know about doctors, teachers, police",
//       "susTopicDetails": "Why & how to save water",
//       "artExperiments": "Paper collage, badge making",
//       "activityDetails": "Role play, poem recitation",
//       "outdoorActivityDetails": "Visit to fire station",
//       "otherExperience": "Sensory games",
//       "specialActivity": "Sports Day",
//       "createdAt": "2025-01-26",
//       "createdBy": "Teacher B",
//       "checked": "false"
//     },
//     {
//       "id": "2",
//       "roomid": "102",
//       "name": "February Plan",
//       "startDate": "2025-02-01",
//       "endDate": "2025-02-28",
//       "inqTopicTitle": "Community Helpers",
//       "susTopicTitle": "Saving Water",
//       "inqTopicDetails": "Know about doctors, teachers, police",
//       "susTopicDetails": "Why & how to save water",
//       "artExperiments": "Paper collage, badge making",
//       "activityDetails": "Role play, poem recitation",
//       "outdoorActivityDetails": "Visit to fire station",
//       "otherExperience": "Sensory games",
//       "specialActivity": "Sports Day",
//       "createdAt": "2025-01-26",
//       "createdBy": "Teacher B",
//       "checked": "false"
//     },
//     {
//       "id": "2",
//       "roomid": "102",
//       "name": "February Plan",
//       "startDate": "2025-02-01",
//       "endDate": "2025-02-28",
//       "inqTopicTitle": "Community Helpers",
//       "susTopicTitle": "Saving Water",
//       "inqTopicDetails": "Know about doctors, teachers, police",
//       "susTopicDetails": "Why & how to save water",
//       "artExperiments": "Paper collage, badge making",
//       "activityDetails": "Role play, poem recitation",
//       "outdoorActivityDetails": "Visit to fire station",
//       "otherExperience": "Sensory games",
//       "specialActivity": "Sports Day",
//       "createdAt": "2025-01-26",
//       "createdBy": "Teacher B",
//       "checked": "false"
//     },
//     {
//       "id": "2",
//       "roomid": "102",
//       "name": "February Plan",
//       "startDate": "2025-02-01",
//       "endDate": "2025-02-28",
//       "inqTopicTitle": "Community Helpers",
//       "susTopicTitle": "Saving Water",
//       "inqTopicDetails": "Know about doctors, teachers, police",
//       "susTopicDetails": "Why & how to save water",
//       "artExperiments": "Paper collage, badge making",
//       "activityDetails": "Role play, poem recitation",
//       "outdoorActivityDetails": "Visit to fire station",
//       "otherExperience": "Sensory games",
//       "specialActivity": "Sports Day",
//       "createdAt": "2025-01-26",
//       "createdBy": "Teacher B",
//       "checked": "false"
//     }
//   ]
// };
