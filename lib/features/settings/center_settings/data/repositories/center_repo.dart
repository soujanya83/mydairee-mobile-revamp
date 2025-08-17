import 'dart:io';
import 'package:dio/dio.dart';
import 'package:mydiaree/core/config/app_urls.dart';
import 'package:mydiaree/core/services/api_services.dart';
import 'package:mydiaree/features/settings/center_settings/data/model/center_model.dart';

class CentersRepository {
  static const String baseUrl = 'https://mydiaree.com.au/api/settings';

  Future<List<CenterModel>> getCenters() async {
    final response = await ApiServices.getData(
      '$baseUrl/center_settings',
    );
    if (response.success && response.data != null && response.data['data'] != null) {
      final List<dynamic> dataList = response.data['data'];
      return dataList.map((e) => CenterModel.fromJson(e)).toList();
    } else {
      throw Exception(response.message.isNotEmpty ? response.message : 'Failed to fetch centers');
    }
  }

  Future<bool> addCenter({
    required String centerName,
    required String streetAddress,
    required String city,
    required String state,
    required String zip, 
  }) async {
    final dio = Dio();
    final headers = await ApiServices.getAuthHeaders();
    final formData = FormData.fromMap({ 
      'centerName': centerName,
      'adressStreet': streetAddress,
      'addressCity': city,
      'addressState': state,
      'addressZip': zip,
    });
    final response = await dio.request(
      '$baseUrl/center_store',
      options: Options(method: 'POST', headers: headers),
      data: formData,
    );
    return response.statusCode == 200 && (response.data['status'] == true || response.data['status'] == 1);
  }

  Future<bool> updateCenter({
    required int id,
    required String centerName,
    required String streetAddress,
    required String city,
    required String state,
    required String zip, 
  }) async {
    final dio = Dio();
    final headers = await ApiServices.getAuthHeaders();
    final formData = FormData.fromMap({ 
      'centerName': centerName,
      'adressStreet': streetAddress,
      'addressCity': city,
      'addressState': state,
      'addressZip': zip,
    });
    final response = await dio.request(
      '$baseUrl/center/$id',
      options: Options(method: 'POST', headers: headers),
      data: formData,
    );
    return response.statusCode == 200 && (response.data['status'] == true || response.data['status'] == 1);
  }

  Future<bool> deleteCenter(int id) async {
    final dio = Dio();
    final headers = await ApiServices.getAuthHeaders();
    final response = await dio.request(
      '$baseUrl/center/$id/destroy',
      options: Options(method: 'DELETE', headers: headers),
    );
    return response.statusCode == 200 && (response.data['status'] == true || response.data['status'] == 1);
  }
}