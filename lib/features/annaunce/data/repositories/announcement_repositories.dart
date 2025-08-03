import 'package:mydiaree/core/config/app_urls.dart';
import 'package:mydiaree/core/services/apiresoponse.dart';
import 'package:mydiaree/features/annaunce/data/model/announcement_list_model.dart';
import 'package:mydiaree/features/annaunce/data/model/announcement_create_model.dart';
import 'package:mydiaree/features/annaunce/data/model/announcement_view_model.dart';

class AnnoucementRepository {
  // Get announcement list
  Future<ApiResponse<AnnouncementsListModel?>> getAnnouncement({
    required String centerId,
    String? searchQuery,
  }) async {
    String url = '${AppUrls.baseApiUrl}/api/announcements/list?centerid=$centerId';
    if (searchQuery != null && searchQuery.isNotEmpty) {
      url += '&search=$searchQuery';
    }
    
    return await getAndParseData(
      url,
      fromJson: (json) => AnnouncementsListModel.fromJson(json),
    );
  }

  // Get create announcement data (rooms, children)
  Future<ApiResponse<AnnouncemenCreateModel?>> getCreateAnnouncementData({
    required String centerId,
  }) async {
    final url = '${AppUrls.baseApiUrl}/api/announcements/create?centerid=$centerId';
    
    return await getAndParseData(
      url,
      fromJson: (json) => AnnouncemenCreateModel.fromJson(json),
    );
  }

  // Add or edit announcement
  Future<ApiResponse> addOrEditAnnouncement({
    String? id,
    required String title,
    required String text,
    required String eventDate,
    required List<int> childIds,
    required String userId,
    required String centerId,
  }) async {
    final url = '${AppUrls.baseApiUrl}/api/announcements/store';
    
    final Map<String, dynamic> data = {
      "title": title,
      "text": text,
      "childId": childIds,
      "userid": userId,
      "centerid": centerId,
    };
    
    if (id != null) {
      data["id"] = id;
    }
    
    return await postAndParse(url, data);
  }

  // View announcement details
  Future<ApiResponse<AnnouncementViewModel?>> viewAnnouncement({
    required String announcementId,
  }) async {
    final url = '${AppUrls.baseApiUrl}/api/announcements/view?annid=$announcementId';
    
    return await getAndParseData(
      url,
      fromJson: (json) => AnnouncementViewModel.fromJson(json),
    );
  }

  // Delete announcement
  Future<ApiResponse> deleteAnnouncement({
    required String announcementId,
    required String userId,
  }) async {
    final url = '${AppUrls.baseApiUrl}/api/announcements/delete?announcementid=$announcementId&userid=$userId';
    
    return await deleteDataApi(url);
  }

  // Delete multiple announcements
  Future<ApiResponse> deleteMultipleAnnouncement({
    required List<String> announcementIds,
    required String userId,
  }) async {
    // If we have multiple deletion, we'll call delete for each one
    // This is because the API doesn't seem to support multiple deletion in a single call
    ApiResponse lastResponse = ApiResponse(success: true, message: 'No announcements to delete');
    
    for (String id in announcementIds) {
      lastResponse = await deleteAnnouncement(
        announcementId: id,
        userId: userId,
      );
      
      if (!lastResponse.success) {
        return lastResponse;
      }
    }
    
    return lastResponse;
  }
}