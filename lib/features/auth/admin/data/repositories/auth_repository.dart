import 'package:image_picker/image_picker.dart';
import 'package:mydiaree/core/config/app_urls.dart';
import 'package:mydiaree/core/services/apiresoponse.dart';
import 'package:mydiaree/features/auth/admin/data/models/login_model.dart';
import 'package:mydiaree/features/auth/admin/data/models/signup_model.dart';

class AdminAuthenticationRepository {
  Future<ApiResponse<SignupModel?>> registerUser({
    String? name = '',
    String? username = '',
    String? email = '',
    String? password = '',
    String? contact = '',
    String? gender = 'Select',
    String? dob = '',
    XFile? profileImage,
  }) async {
    return postAndParse<SignupModel>(
      AppUrls.signup,
      dummy: true,
      {
        'name': name,
        'username': username,
        'email': email,
        'password': password,
        'contact': contact,
        'gender': gender,
        'dob': dob,
      },
      // fromJson: (json) => SignupModel.fromJson(json),
      filesPath: [profileImage?.path ?? ''],
      fileField: 'profile_image',
    );
  }

  // Example method for user login
  Future<ApiResponse<LoginModel?>> loginUser(
      String username, String password) async {
    return postAndParse(
      AppUrls.login,
      dummy: true,
      {
        'username': username,
        'password': password,
      },
      fromJson: (json) => LoginModel.fromJson(json),
    );
  }

  Future<ApiResponse> updatePassword({
    required String email,
    required String newPassword,
  }) async {
    return postAndParse(
      AppUrls.resetPassword,
      dummy: true,
      {
        'email': email,
        'new_password': newPassword,
      },
    );
  }

  Future<ApiResponse<LoginModel?>> forgotPassword(
      {required String email}) async {
    return postAndParse(
      AppUrls.forgotPassword,
      dummy: true,
      {
        'email': email,
      },
      fromJson: (json) => LoginModel.fromJson(json),
    );
  }

  Future<ApiResponse> otpVerify(
      {required String email, required String otp}) async {
    return postAndParse(
        AppUrls.otpVerify, dummy: true, {'email': email, 'otp': otp});
  }
}
