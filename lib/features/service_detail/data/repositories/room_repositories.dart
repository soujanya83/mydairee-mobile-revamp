
// Repository
import 'package:mydiaree/core/services/apiresoponse.dart';
import 'package:mydiaree/core/config/app_urls.dart';

class ServiceRepository {
  Future<ApiResponse> submitServiceDetail({
    required Map<String, dynamic> serviceData,
  }) async {
    return postAndParse(
      AppUrls.submitServiceDetails,
      dummy: true,
      serviceData,
    );
  }
}
