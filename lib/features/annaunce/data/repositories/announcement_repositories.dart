import 'package:mydiaree/core/config/app_urls.dart';
import 'package:mydiaree/core/services/apiresoponse.dart';
import 'package:mydiaree/features/annaunce/data/model/announcement_list_model.dart';

Map<String, dynamic> dummyAnouncementListData = {
  "announcements": [
    {
      "id": "1",
      "title": "Holiday Notice",
      "text": "School will remain closed tomorrow.",
      "eventDate": "2025-06-25",
      "status": "Active",
      "createdBy": "Admin",
      "createdAt": "2025-06-23T10:00:00Z",
      "aid": "A123"
    },
    {
      "id": "1",
      "title": "Holiday Notice",
      "text": "School will remain closed tomorrow.",
      "eventDate": "2025-06-25",
      "status": "Active",
      "createdBy": "Admin",
      "createdAt": "2025-06-23T10:00:00Z",
      "aid": "A123"
    },
    {
      "id": "1",
      "title": "Holiday Notice",
      "text": "School will remain closed tomorrow.",
      "eventDate": "2025-06-25",
      "status": "Active",
      "createdBy": "Admin",
      "createdAt": "2025-06-23T10:00:00Z",
      "aid": "A123"
    },
    {
      "id": "1",
      "title": "Holiday Notice",
      "text": "School will remain closed tomorrow.",
      "eventDate": "2025-06-25",
      "status": "Active",
      "createdBy": "Admin",
      "createdAt": "2025-06-23T10:00:00Z",
      "aid": "A123"
    },
  ]
};

class AnnoucementRepository {
  Future<ApiResponse<AnnouncementListModel?>> getAnnouncement({
    required String centerId,
    String? searchQuery,
    String? statusFilter,
  }) async {
    return await postAndParse(
      AppUrls.getRooms,
      dummy: true,
      dummyData: dummyAnouncementListData,
      {
        'center_id': centerId,
        if (searchQuery != null) 'search': searchQuery,
        if (statusFilter != null && statusFilter != 'Select')
          'status': statusFilter,
      },
      fromJson: (json) => AnnouncementListModel.fromJson(json),
    );
  }

  Future<ApiResponse> addOrEditAnnouncement({
    String? id,
    required String title,
    required String text,
    required String eventDate,
    required String status,
    required String createdBy,
  }) async {
    return await postAndParse(
      AppUrls.addAnnouncement,
      {
        if (id != null) 'id': id,
        'title': title,
        'text': text,
        'eventDate': eventDate,
        'status': status,
        'createdBy': createdBy,
      },
    );
  }

  // Update room details
  // Future<ApiResponse> updateRoom({
  //   required String roomId,
  //   String? name,
  //   String? color,
  //   String? leadUserId,
  //   String? status,
  //   String? capacity,
  //   String? ageFrom,
  //   String? ageTo,
  // }) async {
  //   return postAndParse(
  //     AppUrls.updateRoom,
  //     dummy: true,
  //     {
  //       'room_id': roomId,
  //       if (name != null) 'name': name,
  //       if (color != null) 'color': color,
  //       if (leadUserId != null) 'lead_user_id': leadUserId,
  //       if (status != null) 'status': status,
  //       if (capacity != null) 'capacity': capacity,
  //       if (ageFrom != null) 'age_from': ageFrom,
  //       if (ageTo != null) 'age_to': ageTo,
  //     },
  //   );
  // }

  Future<ApiResponse> deleteMultipleAnnouncement({
    required List<String> roomIds,
  }) async {
    return postAndParse(
      AppUrls.deleteMultipleRooms,
      dummy: true,
      {
        'room_ids': roomIds,
      },
    );
  }
}
