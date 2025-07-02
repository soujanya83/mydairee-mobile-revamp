import 'package:mydiaree/core/config/app_urls.dart';
import 'package:mydiaree/core/services/apiresoponse.dart';
import 'package:mydiaree/features/observation/data/model/observation_list_model.dart';
import 'package:mydiaree/features/observation/data/model/observation_model.dart';
import 'package:mydiaree/features/room/data/model/room_list_model.dart';

Map<String, dynamic> dummyObservationListData = {
  "observations": [
    {
      "id": "1",
      "title": "Observation A",
      "description": "Child was very active today.",
      "date": "2024-06-01",
      "childName": "Child 1",
      "educatorName": "John Doe",
      "status": "Active"
    },
    {
      "id": "2",
      "title": "Observation B",
      "description": "Participated well in group activities.",
      "date": "2024-06-02",
      "childName": "Child 2",
      "educatorName": "Jane Smith",
      "status": "Active"
    },
    {
      "id": "3",
      "title": "Observation C",
      "description": "Needs improvement in sharing.",
      "date": "2024-06-03",
      "childName": "Child 3",
      "educatorName": "Mike Johnson",
      "status": "Inactive"
    }
  ]
};

Map<String, dynamic> dummyObservationData = {
  "id": "1",
  "title": "Observation A",
  "notes": "Child was very active and engaged.",
  "reflection": "Great improvement in social skills.",
  "childVoice": "I like playing with my friends.",
  "futurePlan": "Encourage more group activities.",
  "dateAdded": "2024-06-01",
  "userName": "John Doe",
  "approverName": "Jane Smith",
  "status": "Active",
  "children": [
    {
      "childId": "c1",
      "childName": "Child 1",
      "imageUrl": "https://example.com/images/child1.jpg"
    },
    {
      "childId": "c2",
      "childName": "Child 2",
      "imageUrl": "https://example.com/images/child2.jpg"
    }
  ]
  ,
  "mediaFiles": [
    "https://example.com/media/file1.jpg",
    "https://example.com/media/file2.mp4"
  ]
};

class ObservationRepository {
  // Get list of observations
  Future<ApiResponse<ObservationListModel?>> getObservations({
    required String centerId,
    String? searchQuery,
    String? statusFilter,
  }) async {
    return await postAndParse(
      AppUrls.getObservations,
      dummy: true,
      dummyData: dummyObservationListData,
      {
        'center_id': centerId,
        if (searchQuery != null) 'search': searchQuery,
        if (statusFilter != null && statusFilter != 'Select')
          'status': statusFilter,
      },
      fromJson: (json) => ObservationListModel.fromJson(json),
    );
  }

  // View a single observation
  Future<ApiResponse<ObservationModel?>> viewObservation({
    required String observationId,
  }) async {
    return await postAndParse(
      AppUrls.viewObservation,
      {
        'observation_id': observationId,
      },
      dummy: true,
      dummyData: dummyObservationData,
      fromJson: (json) => ObservationModel.fromJson(json),
    );
  }

  // Add or edit an observation
  Future<ApiResponse> addOrEditObservation({
    String? id,
    required String centerId,
    required String title,
    required String description,
    required String date,
    required String childId,
    required String educatorId,
    required String status,
  }) async {
    return postAndParse(
      AppUrls.addOrEditObservation,
      dummy: true,
      {
        if (id != null) 'id': id,
        'center_id': centerId,
        'title': title,
        'description': description,
        'date': date,
        'child_id': childId,
        'educator_id': educatorId,
        'status': status,
      },
    );
  }

  // Delete observation(s)
  Future<ApiResponse> deleteObservations({
    required String observationId,
  }) async {
    return postAndParse(
      AppUrls.deleteObservations,
      dummy: true,
      {
        'observation_id': observationId,
      },
    );
  }
}
