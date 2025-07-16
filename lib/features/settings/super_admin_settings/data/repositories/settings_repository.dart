import 'package:mydiaree/core/config/app_urls.dart';
import 'package:mydiaree/core/services/apiresoponse.dart';
import 'package:mydiaree/features/settings/super_admin_settings/data/model/super_admin_model.dart';

class SuperAdminRepository {
  // Dummy data for superadmins
  static List<Map<String, dynamic>> dummySuperAdminsData = [
    {
      'id': '1',
      'name': 'Deepti',
      'email': 'info@mydiaree.com',
      'password': '',
      'contactNo': '8339042317',
      'gender': 'FEMALE',
      'avatarUrl': 'https://mydiaree.com.au/uploads/superadmins/1749498975.jpeg',
      'centerName': 'Main Center',
      'streetAddress': '123 Main St',
      'city': 'Sydney',
      'state': 'NSW',
      'zip': '2000',
    },
    {
      'id': '7',
      'name': 'Demo Admin',
      'email': 'demoadmin@mykronicle.com',
      'password': '',
      'contactNo': '8637271545',
      'gender': 'MALE',
      'avatarUrl': 'https://mydiaree.com.au/uploads/superadmins/1748950397.png',
      'centerName': 'Demo Center',
      'streetAddress': '456 Demo Rd',
      'city': 'Melbourne',
      'state': 'VIC',
      'zip': '3000',
    },
    // Add other dummy data as needed
  ];

  Future<List<SuperAdminModel>> getSuperAdmins() async {
    // Simulate API call with dummy data
    return dummySuperAdminsData.map((data) => SuperAdminModel.fromJson(data)).toList();
  }

  Future<ApiResponse> addSuperAdmin({
    required String name,
    required String email,
    required String password,
    required String contactNo,
    required String gender,
    required String avatarUrl,
    required String centerName,
    required String streetAddress,
    required String city,
    required String state,
    required String zip,
  }) async {
    return await postAndParse(
      AppUrls.addSuperAdmin,
      dummy: true,
      {
        'name': name,
        'email': email,
        'password': password,
        'contactNo': contactNo,
        'gender': gender,
        'avatarUrl': avatarUrl,
        'centerName': centerName,
        'streetAddress': streetAddress,
        'city': city,
        'state': state,
        'zip': zip,
      },
    );
  }

  Future<ApiResponse> updateSuperAdmin({
    required String id,
    required String name,
    required String email,
    required String password,
    required String contactNo,
    required String gender,
    required String avatarUrl,
    required String centerName,
    required String streetAddress,
    required String city,
    required String state,
    required String zip,
  }) async {
    return await postAndParse(
      '${AppUrls.updateSuperAdmin}/$id',
      dummy: true,
      {
        'id': id,
        'name': name,
        'email': email,
        'password': password,
        'contactNo': contactNo,
        'gender': gender,
        'avatarUrl': avatarUrl,
        'centerName': centerName,
        'streetAddress': streetAddress,
        'city': city,
        'state': state,
        'zip': zip,
      },
    );
  }

  Future<ApiResponse> deleteSuperAdmin(String superAdminId) async {
    return await postAndParse(
      '${AppUrls.deleteSuperAdmin}/$superAdminId',
      dummy: true,
      {
        '_method': 'DELETE',
      },
    );
  }
}