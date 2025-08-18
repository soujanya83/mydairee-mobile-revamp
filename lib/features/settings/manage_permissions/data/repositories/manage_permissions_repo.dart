import 'package:dio/dio.dart';
import 'package:mydiaree/core/config/app_urls.dart';
import 'package:mydiaree/core/services/api_services.dart';
import 'package:mydiaree/features/settings/manage_permissions/data/model/permission_model.dart';
import 'package:mydiaree/features/settings/manage_permissions/data/model/user_model.dart';

class StaffModel {
  final int id;
  final String name;
  final String email;
  final String contactNo;
  final String userType;
  final String? imageUrl;
  final String? status;
  final String? title;

  StaffModel({
    required this.id,
    required this.name,
    required this.email,
    required this.contactNo,
    required this.userType,
    this.imageUrl,
    this.status,
    this.title,
  });

  factory StaffModel.fromJson(Map<String, dynamic> json) {
    return StaffModel(
      id: json['id'] is int ? json['id'] : int.tryParse(json['id'].toString()) ?? 0,
      name: json['name'] ?? '',
      email: json['email'] ?? '',
      contactNo: json['contactNo'] ?? '',
      userType: json['userType'] ?? '',
      imageUrl: json['imageUrl'],
      status: json['status'],
      title: json['title'],
    );
  }
}

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



  Future<List<StaffModel>> getStaffList() async {
    final headers = await ApiServices.getAuthHeaders();
    final dio = Dio();
    print('DEBUG: Fetching staff with headers: $headers');
    final response = await dio.request(
      '$baseUrl/manage_permissions',
      options: Options(method: 'GET', headers: headers),
    );
    print('DEBUG: Response status: ${response.statusCode}, data: ${response.data}');
    if (response.statusCode == 200 &&
        response.data['data'] != null &&
        response.data['data']['users'] != null) {
      final List<dynamic> dataList = response.data['data']['users'];
      return dataList.map((e) => StaffModel.fromJson(e)).toList();
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
