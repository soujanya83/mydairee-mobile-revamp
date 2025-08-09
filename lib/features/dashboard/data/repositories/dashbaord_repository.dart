import 'package:mydiaree/core/config/app_urls.dart';
import 'package:mydiaree/core/services/apiresoponse.dart';
import 'package:mydiaree/core/services/api_services.dart';
import 'package:mydiaree/features/dashboard/data/model/birthday_response.dart';
import 'package:mydiaree/features/dashboard/data/model/dashboard_response.dart';
import 'package:mydiaree/features/dashboard/data/model/event_response.dart';

class DashboardRepository {
  Future<ApiResponse<DashboardResponse?>> getDashboard() async {
    final url = '${AppUrls.baseUrl}/api/dashboard';
    return await getAndParseData<DashboardResponse>(
      url,
      fromJson: (j) => DashboardResponse.fromJson(j),
    );
  }

  Future<ApiResponse<EventsResponse?>> getEvents() async {
    final url = '${AppUrls.baseUrl}/api/announcements/events';
    return await getAndParseData<EventsResponse>(
      url,
      fromJson: (j) => EventsResponse.fromJson(j),
    );
  }

  Future<ApiResponse<BirthdaysResponse?>> getBirthdays() async {
    final url = '${AppUrls.baseUrl}/api/users/birthday';
    return await getAndParseData<BirthdaysResponse>(
      url,
      fromJson: (j) => BirthdaysResponse.fromJson(j),
    );
  }
}