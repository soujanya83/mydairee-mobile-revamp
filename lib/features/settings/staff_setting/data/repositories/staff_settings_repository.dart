import 'dart:io';

import 'package:dio/dio.dart';
import 'package:mydiaree/core/services/api_services.dart';
import 'package:mydiaree/core/services/apiresoponse.dart';
import 'package:mydiaree/features/settings/staff_setting/data/model/staff_model.dart';

class StaffRepository {
  static const String baseUrl = 'https://mydiaree.com.au/api/settings';

  Future<List<StaffModel>> getStaff(String centerId) async {
    final response = await ApiServices.getData(
      '$baseUrl/staff_settings?center_id=$centerId',
    );
    if (response.success && response.data != null && response.data['data'] != null && response.data['data']['staff'] != null) {
      final List<dynamic> dataList = response.data['data']['staff'];
      return dataList.map((e) => StaffModel.fromJson(e)).toList();
    } else {
      throw Exception(response.message.isNotEmpty ? response.message : 'Failed to fetch staff');
    }
  }

  Future<ApiResponse> addStaff({
    required String name,
    required String email,
    required String password,
    required String contactNo,
    required String gender,
    File? avatarFile,
    required String centerId,
  }) async {
    final dio = Dio();
    final headers = await ApiServices.getAuthHeaders();

    // Format gender as in your example: leading space and capitalized
    String formattedGender = gender.trim().isNotEmpty
        ? ' ${gender[0].toUpperCase()}${gender.substring(1).toLowerCase()}'
        : '';

    final formData = FormData.fromMap({
      if (avatarFile != null)
        'files': [
          await MultipartFile.fromFile(
            avatarFile.path,
            filename: avatarFile.path.split('/').last,
          )
        ],
      'email': ' $email',
      'password': ' $password',
      'contactNo': ' $contactNo',
      'name': ' $name',
      'gender': formattedGender,
      'center_id': centerId,
    });

    try {
      final response = await dio.request(
      '$baseUrl/staff/store',
      options: Options(method: 'POST', headers: headers),
      data: formData,
      );
      print('addStaff response: =============');
      print('addStaff response: ${response.toString()}');
      return ApiResponse(
      success: response.statusCode == 200 && (response.data['status'] == true || response.data['status'] == 1),
      message: response.data['message'] ?? '',
      );
    } on DioError catch (e) {
      print('addStaff error: =============');
      print('addStaff error: ${e.response?.toString() ?? e.toString()}');
      return ApiResponse(
      success: false,
      message: e.response?.data['message']?.toString() ?? e.message ?? 'Unknown error',
      );
    }

    // return ApiResponse(
    //   success: response.statusCode == 200 && (response.data['status'] == true || response.data['status'] == 1),
    //   message: response.data['message'] ?? '',
    // );
  }
  Future<ApiResponse> updateStaff({
    required String id,
    required String name,
    required String email,
    required String password,
    required String contactNo,
    required String gender,
    File? avatarFile,
    required String centerId,
  }) async {
    final dio = Dio();
    final headers = await ApiServices.getAuthHeaders();

    // Format gender as in your example: leading space and capitalized
    String formattedGender = gender.trim().isNotEmpty
        ? ' ${gender[0].toUpperCase()}${gender.substring(1).toLowerCase()}'
        : '';

    final formData = FormData.fromMap({
      if (avatarFile != null)
        'files': [
          await MultipartFile.fromFile(
            avatarFile.path,
            filename: avatarFile.path.split('/').last,
          )
        ],
      'email': ' $email',
      'password': ' $password',
      'contactNo': ' $contactNo',
      'name': ' $name',
      'gender': formattedGender,
      'center_id': centerId,
    });

    try {
      final response = await dio.request(
        '$baseUrl/staff/$id',
        options: Options(method: 'POST', headers: headers),
        data: formData,
      );
      print('updateStaff response: ${response.toString()}');
      return ApiResponse(
        success: response.statusCode == 200 ,
        message: '',
      );
    } on DioError catch (e) {
      print('updateStaff error: ${e.response?.toString() ?? e.toString()}');
      return ApiResponse(
        success: false,
        message: e.response?.data['message']?.toString() ?? e.message ?? 'Unknown error',
      );
    }
  }

  Future<ApiResponse> deleteStaff(String staffId) async {
    final dio = Dio();
    final headers = await ApiServices.getAuthHeaders();
    final url = '$baseUrl/staff/destroy/$staffId';
    print('Request URL: $url');
    try {
      final response = await dio.request(
        url,
        options: Options(method: 'DELETE', headers: headers),
      );
      print('deleteStaff response: ${response.toString()}');
      return ApiResponse(
        success: response.statusCode == 200 && (response.data['status'] == true || response.data['status'] == 1),
        message: '',

      );
    } on DioError catch (e) {
      print('deleteStaff error: ${e.response?.toString() ?? e.toString()}');
      return ApiResponse(
        success: false,
        message: e.response?.data['message']?.toString() ?? e.message ?? 'Unknown error',
      );
    }
  }
}