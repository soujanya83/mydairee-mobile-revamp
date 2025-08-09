import 'package:mydiaree/core/config/app_urls.dart';
import 'package:mydiaree/core/services/apiresoponse.dart';
import 'package:mydiaree/features/service_detail/data/models/service_details_model.dart';

class ServiceDetailsRepository {
  // Get service details
  Future<ApiResponse<ServiceDetailsResponse?>> getServiceDetails({
    required String centerId,
  }) async {
    final url = '${AppUrls.baseUrl}/api/ServiceDetails?user_center_id=$centerId';
    
    return await getAndParseData(
      url,
      fromJson: (json) => ServiceDetailsResponse.fromJson(json),
    );
  }

  // Save service details
  Future<ApiResponse> saveServiceDetails({
    required Map<String, dynamic> serviceData,
  }) async {
    final url = '${AppUrls.baseUrl}/api/ServiceDetails';
    
    return await postAndParse(
      url,
      serviceData,
    );
  }
}