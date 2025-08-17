import 'package:dio/dio.dart';
import 'package:mydiaree/core/config/app_urls.dart';
import 'package:mydiaree/core/services/api_services.dart';
import 'package:mydiaree/features/settings/manage_permissions/data/model/permission_model.dart';
import 'package:mydiaree/features/settings/manage_permissions/data/model/user_model.dart';

class ManagePermissionsRepository {
  static const String baseUrl = '${AppUrls.baseUrl}/api/settings';

  Future<List<PermissionModel>> getPermissions() async {
    final headers = await ApiServices.getAuthHeaders();
    final dio = Dio();
    print('DEBUG: Fetching permissions with headers: $headers');
    final response = await dio.request(
      '$baseUrl/permissions-assigned',
      options: Options(method: 'GET', headers: headers),
    );
    print('DEBUG: Response status: ${response.statusCode}, data: ${response.data}');
    if (response.statusCode == 200 && response.data['permissions'] != null) {
      final List<dynamic> dataList = response.data['permissions'];
      return dataList.map((e) => PermissionModel.fromJson(e)).toList();
    } else {
      throw Exception(response.data['message'] ?? 'Failed to fetch permissions');
    }
  }

  Future<List<UserModel>> getAssignedUsers() async {
    final headers = await ApiServices.getAuthHeaders();
    final dio = Dio();
    print('DEBUG: Fetching assigned users with headers: $headers');
    final response = await dio.request(
      '$baseUrl/permissions-assigned',
      options: Options(method: 'GET', headers: headers),
    );
    print('DEBUG: Response status: ${response.statusCode}, data: ${response.data}');
    if (response.statusCode == 200 && response.data['assigned_users'] != null) {
      final List<dynamic> dataList = response.data['assigned_users'];
      return dataList.map((e) => UserModel.fromJson(e)).toList();
    } else {
      throw Exception(response.data['message'] ?? 'Failed to fetch assigned users');
    }
  }

  Future<List<UserModel>> getStaff(String centerId) async {
    final headers = await ApiServices.getAuthHeaders();
    final dio = Dio();
    print('DEBUG: Fetching staff for centerId: $centerId with headers: $headers');
    final response = await dio.request(
      '$baseUrl/staff_settings?center_id=$centerId',
      options: Options(method: 'GET', headers: headers),
    );
    print('DEBUG: Response status: ${response.statusCode}, data: ${response.data}');
    if (response.statusCode == 200 &&
        response.data['data'] != null &&
        response.data['data']['staff'] != null) {
      final List<dynamic> dataList = response.data['data']['staff'];
      return dataList
          .map((e) => UserModel(
                id: e['id'] is int ? e['id'] : int.tryParse(e['id'].toString()) ?? 0,
                name: e['name'] ?? '',
                colorClass: e['userType'] ?? '',
              ))
          .toList();
    } else {
      throw Exception(response.data['message'] ?? 'Failed to fetch staff');
    }
  }

  Future<bool> assignPermissions({
    required List<String> userIds,
    required String centerId,
    required Map<String, String> permissions,
  }) async {
    final headers = await ApiServices.getAuthHeaders();
    final dio = Dio();
    final formDataMap = Map<String, dynamic>.from(permissions);
    // Add all user_ids[] for each user
    for (final userId in userIds) {
      formDataMap.putIfAbsent('user_ids[]', () => []).add(userId);
    }
    formDataMap['centerid'] = centerId;
    final formData = FormData.fromMap(formDataMap);
    print('DEBUG: Assigning permissions with data: $formDataMap and headers: $headers');
    final response = await dio.request(
      '${AppUrls.baseUrl}/api/settings/assign-permissions',
      options: Options(method: 'POST', headers: headers),
      data: formData,
    );
    print('DEBUG: Response status: ${response.statusCode}, data: ${response.data}');
    return response.statusCode == 200 && (response.data['success'] == true || response.data['status'] == true);
  }
}
