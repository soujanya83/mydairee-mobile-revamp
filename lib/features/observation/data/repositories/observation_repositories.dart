import 'package:flutter/rendering.dart';
import 'package:mydiaree/core/config/app_urls.dart';
import 'package:mydiaree/core/services/api_services.dart';
import 'package:mydiaree/core/services/apiresoponse.dart';
import 'package:mydiaree/features/observation/data/model/add_new_observation_response.dart';
import 'package:mydiaree/features/observation/data/model/child_response.dart';
import 'package:mydiaree/features/observation/data/model/observation_api_response.dart';
import 'package:mydiaree/features/observation/data/model/observation_detail_model.dart';
import 'package:mydiaree/features/observation/data/model/staff_response.dart';

class ObservationRepository {
  // Get list of observations
  Future<ApiResponse<ObservationApiResponse?>> getObservations({
    required String centerId,
    String? searchQuery,
    String? statusFilter,
    int? page,
  }) async {
    // return ApiResponse(success: true, message: 'Observations fetched successfully', data: ObservationApiResponse.fromJson(dummyObservations));
    String url = '${AppUrls.baseUrl}/api/observation/index?center_id=$centerId';

    if (searchQuery != null && searchQuery.isNotEmpty) {
      url += '&search=$searchQuery';
    }

    if (statusFilter != null && statusFilter != 'All') {
      url += '&status=$statusFilter';
    }

    if (page != null) {
      url += '&page=$page';
    }

    return await getAndParseData(
      url,
      // dummyData: dummyObservations,
      fromJson: (json) {
        // print('Response JSON: $json');
        return ObservationApiResponse.fromJson(json);
      },
    );
  }

  // View a single observation
  Future<ApiResponse<ObservationItem?>> viewObservation({
    required String observationId,
  }) async {
    final url =
        '${AppUrls.baseUrl}/api/observation/view?observation_id=$observationId';

    return await getAndParseData(
      url,
      fromJson: (json) => ObservationItem.fromJson(json),
    );
  }

  // Add or edit an observation
  Future<ApiResponse> addOrEditObservation({
    String? id,
    required String centerId,
    required String title,
    required String notes,
    required String reflection,
    required String childVoice,
    required String futurePlan,
    required List<int> childIds,
    required List<String> mediaFiles,
    required String status,
  }) async {
    final Map<String, dynamic> data = {
      if (id != null) 'id': id,
      'center_id': centerId,
      'title': title,
      'notes': notes,
      'reflection': reflection,
      'child_voice': childVoice,
      'future_plan': futurePlan,
      'child_ids': childIds,
      'status': status,
    };

    final url =
        '${AppUrls.baseUrl}/api/observation/${id != null ? 'update' : 'add'}';

    return await postAndParse(
      url,
      data,
      filesPath: mediaFiles.isNotEmpty ? mediaFiles : null,
      fileField: 'media[]',
    );
  }

  // Delete observation
  Future<ApiResponse> deleteObservation({
    required int observationId,
  }) async {
    const url = '${AppUrls.baseUrl}/api/observation/delete';

    return await postAndParse(
      url,
      {'observation_id': observationId},
    );
  }

  // Filter observations
  Future<ApiResponse<ObservationApiResponse?>> filterObservations({
    required String centerId,
    List<String>? authorIds,
    List<String>? childIds,
    List<String>? added,
    String? fromDate,
    String? toDate,
    List<String>? statuses,
  }) async {
    final Map<String, dynamic> data = {
      'center_id': centerId,
    };

    if (authorIds != null && authorIds.isNotEmpty) {
      data['authors'] = authorIds;
    }

    if (childIds != null && childIds.isNotEmpty) {
      data['childs'] = childIds;
    }

    if (added != null && added.isNotEmpty) {
      data['added'] = added;
    }

    if (fromDate != null && fromDate.isNotEmpty) {
      data['fromDate'] = fromDate;
    }

    if (toDate != null && toDate.isNotEmpty) {
      data['toDate'] = toDate;
    }

    if (statuses != null && statuses.isNotEmpty) {
      data['observations'] = statuses;
    }

    const url = '${AppUrls.baseUrl}/api/observation/filters';
    return await postAndParse(
      url,
      data,
      //   dummy: true,
      //   dummyData: filterDataDummy,
      // dummyData: {},
      fromJson: (json) {
        // Create an ObservationApiResponse from the response
        return ObservationApiResponse(
          success: json['status'] == 'success',
          observations: (json['observations'] as List?)
                  ?.map((obs) => ObservationItem.fromJson({
                        'id': obs['id'] ?? 0,
                        'userId': 0, // Default as it might not be in response
                        'title': obs['title'],
                        'obestitle': obs['obestitle'],
                        'status': obs['status'] ?? '',
                        'centerid': int.parse(centerId),
                        'date_added': obs['date_added'] ?? '',
                        'date_modified': '',
                        'created_at': obs['created_at'] ?? '',
                        'updated_at': obs['created_at'] ?? '',
                        'user': {
                          'name': obs['userName'] ?? '',
                          // Add other required user fields with defaults
                          'id': 0,
                          'userid': 0,
                          'username': '',
                          'emailid': '',
                          'email': '',
                          'center_status': 0,
                          'contactNo': '',
                          'dob': '',
                          'gender': '',
                          'imageUrl': '',
                          'userType': '',
                          'title': '',
                          'AuthToken': '',
                          'deviceid': '',
                          'devicetype': '',
                          'theme': 0,
                          'image_position': '',
                          'created_at': '',
                          'updated_at': '',
                        },
                        'media': obs['media'] != null ? [obs['media']] : [],
                        'child': [],
                        'seen': obs['seen'] ?? [],
                      }))
                  .toList() ??
              [],
          centers: [], // The response doesn't include centers
        );
      },
    );
  }

  // Get children for a center
  Future<ApiResponse<ChildrenResponse?>> getChildren({
    required String centerId,
  }) async {
    final url =
        '${AppUrls.baseUrl}/api/observation/get-children?center_id=$centerId';

    return await getAndParseData(
      url,
      // dummyData: dummyChildrenData,
      fromJson: (json) => ChildrenResponse.fromJson(json),
    );
  }

  // Get staff/authors for a center
  Future<ApiResponse<StaffResponse?>> getStaff({
    required String centerId,
  }) async {
    final url =
        '${AppUrls.baseUrl}/api/observation/get-staff?center_id=$centerId';

    return await getAndParseData(
      url,
      // dummyData: dummyStaffData,
      fromJson: (json) => StaffResponse.fromJson(json),
    );
  }

  Future<ApiResponse<ObservationDetailData?>> viewObservationDetail({
    required String observationId,
  }) async {
    final url = '${AppUrls.baseUrl}/api/observation/view/$observationId';

    return await getAndParseData(
      url,
      // dummyData: dummDataObservationView,
      fromJson: (json) => ObservationDetailResponse.fromJson(json).data,
    );
  }

  Future<ApiResponse<AddNewObservationResponse?>> getAddNewObservation({
    String? observationId,
    required String tab,
    required String tab2,
    required String centerId,
  }) async {
    final url = '${AppUrls.baseUrl}/api/observation/addnew'
        '${observationId?.isNotEmpty == true ? '?id=$observationId' : ''}'
        '${observationId?.isNotEmpty == true ? '&' : '?'}tab=$tab&tab2=$tab2&center_id=$centerId';
    print('-----------');
    print(url);

    return await getAndParseData(
      url,
      fromJson: (json) {
        print('============');
        print('Response JSON: ${json['data']['observation']}');
        //  debugPrint(json.toString(), wrapWidth: 1024);
        return AddNewObservationResponse.fromJson(json);
      },
    );
  }

  Future<ApiResponse> deleteObservationMedia({
    required int mediaId,
  }) async {
    const url = '${AppUrls.baseUrl}/api/observation/observation-media';

    final Map<String, dynamic> data = {
      'id': mediaId.toString(),
    };

    return await postAndParse(
      url,
      data,
    );
  }

  Future<ApiResponse> saveMontessoriAssessment({
    required String observationId,
    required List<Map<String, dynamic>> subactivities,
  }) async {
    final url = '${AppUrls.baseUrl}/api/observation/montessori/store';
    print('=========');
    print(url);
    final data = {
      "observationId": observationId,
      "subactivities": subactivities,
    };
    print('=========');
    print(data);
    return await postAndParse(
      url,
      data,
    );
  }

// EYLF Save
  Future<ApiResponse> saveEYLFAssessment({
    required String observationId,
    required List<int> subactivityIds,
  }) async {
    final url = '${AppUrls.baseUrl}/api/observation/eylf/store';
    print('=========');
    print({
      'observationId': observationId.toString(),
      'subactivityIds': subactivityIds,
    });
    return await postAndParse(
      url,
      {
        'observationId': observationId.toString(),
        'subactivityIds': subactivityIds,
      },
    );
  }

// Developmental Milestone Save
  Future<ApiResponse> saveDevelopmentMilestone({
    required String  observationId,
    required List<Map<String, dynamic>> selections,
  }) async {
    const url = '${AppUrls.baseUrl}/api/observation/devmilestone/store';
    final data = {
      "observationId": observationId,
      "selections": selections,
    };
    return await postAndParse(
      url,
      data,
    );
  }

// Save Observation (with files)
  Future<ApiResponse> saveObservation({
    required List<String> filePaths,
    required Map<String, dynamic> fields,
  }) async {
    final url = '${AppUrls.baseUrl}/api/observation/store';
    print('================');
    print(fields);
    print('================');
    return await postAndParse(
      url,
      fields,
      filesPath: filePaths,
      fileField: filePaths.isNotEmpty ? 'media[]' : null,
    );
  }

// Update Observation Status
  Future<ApiResponse> updateObservationStatus({
    required String observationId,
    required String status,
  }) async {
    const url = '${AppUrls.baseUrl}/api/observation/status/update';
    return await postAndParse(
      url,
      {
        'observationId': observationId.toString(),
        'status': status,
      },
    );
  }

  Future<ApiResponse> getRoomsByCenterId(String centerId) async {
    final url =
        '${AppUrls.baseUrl}/api/observation/get-rooms?center_id=$centerId';
    return await ApiServices.getData(url);
  }

  Future<ApiResponse> getChildrenByCenterId(String centerId) async {
    final url =
        '${AppUrls.baseUrl}/api/observation/get-children?center_id=$centerId';
    return await ApiServices.getData(url);
  }
}
