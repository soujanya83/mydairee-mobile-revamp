import 'dart:io';
import 'package:dio/dio.dart';
import 'package:mydiaree/core/config/app_urls.dart';
import 'package:mydiaree/core/services/api_services.dart';

class ProfileSettingRepository {
  static const String baseUrl = '${AppUrls.baseUrl}/api/settings';

  Future<bool> uploadProfileImage(List<File> files) async {
    final headers = await ApiServices.getAuthHeaders();
    final formData = FormData();
    for (final file in files) {
      formData.files.add(MapEntry(
        'files',
        await MultipartFile.fromFile(file.path, filename: file.path.split('/').last),
      ));
    }
    final dio = Dio();
    final response = await dio.request(
      '$baseUrl/upload-profile-image',
      options: Options(method: 'POST', headers: headers),
      data: formData,
    );
    return response.statusCode == 200 && (response.data['success'] == true || response.data['status'] == true);
  }

  Future<bool> updateProfile({
    required int userId,
    required String name,
    required String email,
    required String contactNo,
    required String gender,
  }) async {
    final headers = await ApiServices.getAuthHeaders();
    final formData = FormData.fromMap({
      'name': name,
      'email': email,
      'contactNo': contactNo,
      'gender': gender,
    });
    final dio = Dio();
    final response = await dio.request(
      '$baseUrl/profile/update/$userId',
      options: Options(method: 'POST', headers: headers),
      data: formData,
    );
    return response.statusCode == 200 && (response.data['success'] == true || response.data['status'] == true);
  }

  Future<bool> changePassword({
    required int userId,
    required String currentPassword,
    required String newPassword,
    required String newPasswordConfirmation,
  }) async {
    final headers = await ApiServices.getAuthHeaders();
    final formData = FormData.fromMap({
      'current_password': currentPassword,
      'new_password': newPassword,
      'new_password_confirmation': newPasswordConfirmation,
    });
    final dio = Dio();
    final response = await dio.request(
      '$baseUrl/profile/change-password/$userId',
      options: Options(method: 'POST', headers: headers),
      data: formData,
    );
    return response.statusCode == 200 && (response.data['success'] == true || response.data['status'] == true);
  }
}
