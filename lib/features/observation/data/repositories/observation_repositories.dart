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
      "notes": "Child was very active and engaged.",
      "reflection": "Great improvement in social skills.",
      "childVoice": "I like playing with my friends.",
      "futurePlan": "Encourage more group activities.",
      "dateAdded": "2024-06-01",
      "userName": "John Doe",
      "approverName": "Jane Smith",
      "status": "Published",
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
    },
    {
      "id": "2",
      "title": "Observation B",
      "notes": "Participated well in group activities.",
      "reflection": "Shows leadership in groups.",
      "childVoice": "I like helping my friends.",
      "futurePlan": "Give more leadership opportunities.",
      "dateAdded": "2024-06-02",
      "userName": "Jane Smith",
      "approverName": null,
      "status": "Published",
      "children": [
      {
        "childId": "c3",
        "childName": "Child 3",
        "imageUrl": "https://example.com/images/child3.jpg"
      }
      ]
    },
    {
      "id": "3",
      "title": "Observation C",
      "notes": "Needs improvement in sharing.",
      "reflection": "Struggles with turn-taking.",
      "childVoice": "I want to play first.",
      "futurePlan": "Practice sharing games.",
      "dateAdded": "2024-06-03",
      "userName": "Mike Johnson",
      "approverName": null,
      "status": "Draft",
      "children": [
      {
        "childId": "c4",
        "childName": "Child 4",
        "imageUrl": "https://example.com/images/child4.jpg"
      }
      ]
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
  "status": "Published",
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
  ],
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
