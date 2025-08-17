import 'dart:io';
import 'package:dio/dio.dart';
import 'package:mydiaree/core/services/api_services.dart';
import 'package:mydiaree/features/settings/parent_setting/data/model/parent_model.dart';

class ParentRepository {
  static const String baseUrl = 'https://mydiaree.com.au/api/settings';

  Future<List<ParentModel>> getParents({required String centerId}) async {
    final headers = await ApiServices.getAuthHeaders();
    final dio = Dio();
    final response = await dio.request(
      '$baseUrl/parent_settings?center_id=$centerId',
      options: Options(method: 'GET', headers: headers),
    );
    if (response.statusCode == 200 && response.data['data'] != null && response.data['data']['parents'] != null) {
      final List<dynamic> dataList = response.data['data']['parents'];
      return dataList.map((e) => ParentModel.fromJson(e)).toList();
    } else {
      throw Exception(response.data['message'] ?? 'Failed to fetch parents');
    }
  }

  Future<bool> addParent({
    required String name,
    required String email,
    required String password,
    required String contactNo,
    required String gender,
    required List<Map<String, String>> children,
    required String centerId,
  }) async {
    try {
      print('Adding parent');
      final dio = Dio();
      final headers = await ApiServices.getAuthHeaders();
      print('Headers: $headers');
      final formDataMap = {
        'email': email,
        'password': password,
        'contactNo': contactNo,
        'name': name,
        'gender': gender,
        'center_id': centerId,
      };
      for (int i = 0; i < children.length; i++) {
        formDataMap['children[$i][childid]'] = children[i]['childid'] ?? '';
        formDataMap['children[$i][relation]'] = children[i]['relation'] ?? '';
        
      }
      //example
      //  for (int i = 0; i < 1; i++) {
      //   // formDataMap['children[$i][childid]'] = children[i]['childid'] ?? '';
      //   // formDataMap['children[$i][relation]'] = children[i]['relation'] ?? '';
      //   formDataMap['children[$i][childid]'] = '101';
      //   formDataMap['children[$i][relation]'] =  'Mother';
      // }
      print('FormData: $formDataMap');
      final formData = FormData.fromMap(formDataMap);
      final response = await dio.request(
        '$baseUrl/parent/store',
        options: Options(method: 'POST', headers: headers, validateStatus: (status) => true),
        data: formData,
      );
      print('Response status: ${response.statusCode}');
      print('Response data: ${response.data}');
      return response.statusCode == 200;
    } catch (e, s) {
      print('Error adding parent: $e');
      print('Stack trace: $s');
      return false;
    }
  }

  Future<bool> updateParent({
    required int id,
    required String name,
    required String email,
    required String password,
    required String contactNo,
    required String gender,
    required List<Map<String, String>> children,
    required String centerId,
  }) async {
    try {
      print('Updating parent with ID: $id');
      final dio = Dio();
      final headers = await ApiServices.getAuthHeaders();
      print('Headers: $headers');
      final formDataMap = {
        'id': id,
        'email': email,
        'password': password,
        'contactNo': contactNo,
        'name': name,
        'gender': gender,
        'center_id': centerId,
      };
      for (int i = 0; i < children.length; i++) {
        formDataMap['children[$i][childid]'] = children[i]['childid'] ?? '';
        formDataMap['children[$i][relation]'] = children[i]['relation'] ?? '';
      }
      // example
      //  for (int i = 0; i < 1; i++) {
      //   // formDataMap['children[$i][childid]'] = children[i]['childid'] ?? '';
      //   // formDataMap['children[$i][relation]'] = children[i]['relation'] ?? '';
      //   formDataMap['children[$i][childid]'] = '101';
      //   formDataMap['children[$i][relation]'] =  'Mother';
      // }
      final formData = FormData.fromMap(formDataMap);
      print('FormData: $formDataMap');
      final response = await dio.request(
        '$baseUrl/parent/update',
        options: Options(
          method: 'POST',
          headers: headers,
          validateStatus: (status) => true,
        ),
        data: formData,
      );
      print('Response status: ${response.statusCode}');
      print('Response data: ${response.data}');
      return response.statusCode == 200;
    } catch (e,s) {
      print('Error updating parent: $e');
      print('Stack trace: $s');
      return false;
    }
  }

  Future<bool> deleteParent(int parentId) async {
    try {
      print('Deleting parent with ID: $parentId');
      final dio = Dio();
      final headers = await ApiServices.getAuthHeaders();
      print('Headers: $headers');
      final url = '$baseUrl/parent/destroy/$parentId';
      print('Request URL: $url');
      final response = await dio.request(
        url,
        options: Options(method: 'DELETE', headers: headers),
      );
      print('Response status: ${response.statusCode}');
      print('Response data: ${response.data}');
      return response.statusCode == 200 && (response.data['success'] == true || response.data['status'] == true);
    } catch (e) {
      print('Error deleting parent: $e');
      return false;
    }
  }
}