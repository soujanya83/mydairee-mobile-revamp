import 'package:mydiaree/core/config/app_urls.dart';
import 'package:mydiaree/core/services/apiresoponse.dart';
import 'package:mydiaree/features/auth/admin/data/models/login_model.dart';

class StaffAuthenticationRepository {
  Future<ApiResponse<LoginModel?>> staffLoginWithPass({
    required String email,
    required String password,
  }) async {
    return postAndParse<LoginModel>(AppUrls.login, dummy: true, {
      'email': email,
      'password': password,
    }, fromJson: (json) {
      print(json.toString());
      return LoginModel.fromJson(json);
    });
  }
}
