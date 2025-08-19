import 'package:dio/dio.dart';
import 'package:image_picker/image_picker.dart';
import 'package:mydiaree/core/config/app_urls.dart';
import 'package:mydiaree/core/services/apiresoponse.dart';
import 'package:mydiaree/features/auth/admin/data/models/login_model.dart';

class AdminAuthenticationRepository {
  Future<ApiResponse<Map<String, dynamic>?>> registerUser({
    required String name,
    required String username,
    required String email,
    required String password,
    required String contact,
    required String gender,
    required String dob,
    XFile? profileImage,
    String? title,
  }) async {
    try {
      final dio = Dio();
      final Map<String, dynamic> data = {};

      data['name'] = name;
      data['username'] = username;
      data['emailid'] = email;
      data['password'] = password;
      data['contactNo'] = contact;
      data['gender'] = gender.toUpperCase();
      data['dob'] = dob;
      if (title != null && title.isNotEmpty) data['title'] = title;
      if (profileImage != null) {
        data['imageUrl'] = await MultipartFile.fromFile(profileImage.path, filename: profileImage.name);
      }

      print('sent data');
      print(data);

      final formData = FormData.fromMap(data);

      final headers = {
        'Accept': 'application/json',
      };

      final response = await dio.post(
        '${AppUrls.baseUrl}/api/store',
        data: formData,
        options: Options(
          headers: headers,
          validateStatus: (status) => true,
        ),
      );
      print('Response Received');
      print('Response Data: ${response.data}');

      if (response.statusCode == 201 || response.data['status'] == 201) {
        return ApiResponse(
          success: true,
          data: response.data as Map<String, dynamic>?,
          message: response.data['message']?.toString() ?? 'Registration successful',
        );
      }
      if (response.data['status'] == 'error' || response.statusCode == 400) {
        String msg = response.data['message']?.toString() ?? 'Registration failed';
        if (response.data['errors'] != null) {
          final errors = response.data['errors'] as Map<String, dynamic>;
          msg += '\n' +
              errors.entries
                  .map((e) => '${e.key}: ${(e.value as List).join(", ")}')
                  .join('\n');
        }
        return ApiResponse(
          success: false,
          data: response.data as Map<String, dynamic>?,
          message: msg,
        );
      }
      return ApiResponse(
        success: false,
        data: response.data as Map<String, dynamic>?,
        message: response.data['message']?.toString() ?? 'Registration failed',
      );
    } catch (e) {
      return ApiResponse(success: false, message: 'Something Went Wrong');
    }
  }

  Future<ApiResponse<LoginModel?>> loginUser(
      String email, String password) async {
    return postAndParse(
      AppUrls.login,
      dummy: false,
      {
        'email': email,
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
