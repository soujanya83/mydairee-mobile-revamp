import 'dart:io';
import 'package:dio/dio.dart';
import 'package:mydiaree/core/services/api_services.dart';
import 'package:mydiaree/features/settings/super_admin_settings/data/model/super_admin_model.dart';

class SuperAdminRepository {
  static const String baseUrl = 'https://mydiaree.com.au/api/settings';

  Future<List<SuperAdminModel>> getSuperAdmins() async {
    final response = await ApiServices.getData(
      '$baseUrl/superadmin_settings',
    );
    if (response.success && response.data != null && response.data['data'] != null) {
      final List<dynamic> dataList = response.data['data'];
      return dataList.map((e) => SuperAdminModel.fromJson(e)).toList();
    } else {
      throw Exception(response.message.isNotEmpty ? response.message : 'Failed to fetch superadmins');
    }
  }

  Future<bool> addSuperAdmin({
    required String name,
    required String email,
    required String password,
    required String contactNo,
    required String gender,
    File? avatarFile,
    required String centerName,
    required String streetAddress,
    required String city,
    required String state,
    required String zip,
  }) async {
    final dio = Dio();
    final headers = await ApiServices.getAuthHeaders();
    final formData = FormData.fromMap({
      if (avatarFile != null)
        'files': [await MultipartFile.fromFile(avatarFile.path, filename: avatarFile.path.split('/').last)],
      'email': email,
      'password': password,
      'contactNo': contactNo,
      'name': name,
      'gender': gender,
      'centerName': centerName,
      'adressStreet': streetAddress,
      'addressCity': city,
      'addressState': state,
      'addressZip': zip,
    });
    final response = await dio.request(
      '$baseUrl/superadmin/store',
      options: Options(method: 'POST', headers: headers),
      data: formData,
    );
    return response.statusCode == 200 && (response.data['status'] == true || response.data['status'] == 1);
  }

  Future<bool> updateSuperAdmin({
    required int id,
    required String name,
    required String email,
    required String password,
    required String contactNo,
    required String gender,
    File? avatarFile,
  }) async {
    final dio = Dio();
    final headers = await ApiServices.getAuthHeaders();
    final formData = FormData.fromMap({
      if (avatarFile != null)
        'files': [await MultipartFile.fromFile(avatarFile.path, filename: avatarFile.path.split('/').last)],
      'email': email,
      'password': password,
      'contactNo': contactNo,
      'name': name,
      'gender': gender,
      'id': id,
    });

    // Debug prints
    print('Updating SuperAdmin with values:');
    print('id: $id');
    print('name: $name');
    print('email: $email');
    print('password: $password');
    print('contactNo: $contactNo');
    print('gender: $gender');
    print('avatarFile: ${avatarFile?.path}');
    print('Headers: $headers');
    print('FormData fields: ${formData.fields}');
    print('FormData files: ${formData.files}');

    final response = await dio.request(
      '$baseUrl/superadmin/update',
      options: Options(method: 'POST', headers: headers),
      data: formData,
    );

    print('API Response statusCode: ${response.statusCode}');
    print('API Response data: ${response.data}');

    return response.statusCode == 200 && (response.data['status'] == true || response.data['status'] == 1);
  }

  Future<bool> deleteSuperAdmin(int id) async {
    final dio = Dio();
    final headers = await ApiServices.getAuthHeaders();
    final formData = FormData.fromMap({'id': id});
    final response = await dio.request(
      '$baseUrl/superadmin?',
      options: Options(method: 'POST', headers: headers),
      data: formData,
    );
    print('Delete API Response statusCode: ${response.statusCode}');
    print('Delete API Response data: ${response.data}');
    return response.statusCode == 200 && (response.data['status'] == true || response.data['status'] == 1);
  }
}