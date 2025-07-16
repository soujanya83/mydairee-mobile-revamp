import 'dart:async';

import 'package:mydiaree/core/config/app_urls.dart';
import 'package:mydiaree/core/services/apiresoponse.dart';
import 'package:mydiaree/features/settings/staff_setting/data/model/staff_model.dart';

class StaffRepository {
  static List<Map<String, dynamic>> dummyStaffData = [
    {
      'id': '3',
      'name': 'Sagar Sutar',
      'email': 'rajatjain5498@gmail.com',
      'password': '',
      'contactNo': '8339042376',
      'gender': 'MALE',
      'avatarUrl': 'https://mydiaree.com.au/62062abbc5991.jpg',
      'userType': 'Staff',
    },
    {
      'id': '4',
      'name': 'Ishita Ray',
      'email': 'ishitaray0389@gmail.com',
      'password': '',
      'contactNo': '9830226803',
      'gender': 'FEMALE',
      'avatarUrl': 'https://mydiaree.com.au/AMIGA-Montessori.jpg',
      'userType': 'Staff',
    },
    {
      'id': '11',
      'name': 'Kailash Sahu',
      'email': 'kailashsahu@gmail.com',
      'password': '',
      'contactNo': '8339042376',
      'gender': 'MALE',
      'avatarUrl': 'https://mydiaree.com.au/AMIGA-Montessori.jpg',
      'userType': 'Staff',
    },
    {
      'id': '113',
      'name': 'Sagar Sutar',
      'email': 'sagarsutaar@gmail.com',
      'password': '',
      'contactNo': '8339042376',
      'gender': 'MALE',
      'avatarUrl': 'https://mydiaree.com.au/AMIGA-Montessori.jpg',
      'userType': 'Staff',
    },
    {
      'id': '117',
      'name': 'Aman',
      'email': 'aman@gmail.com',
      'password': '',
      'contactNo': '1233337890',
      'gender': 'MALE',
      'avatarUrl': 'https://mydiaree.com.au/AMIGA-Montessori.jpg',
      'userType': 'Staff',
    },
    {
      'id': '128',
      'name': 'admin',
      'email': 'admin@mykronicle.com',
      'password': '',
      'contactNo': '8909357490',
      'gender': 'MALE',
      'avatarUrl': 'https://mydiaree.com.au/AMIGA-Montessori.jpg',
      'userType': 'Staff',
    },
    {
      'id': '129',
      'name': 'Jacob Marsh',
      'email': 'jacobmarsha@mydairee.com',
      'password': '',
      'contactNo': '1234567890',
      'gender': 'MALE',
      'avatarUrl': 'https://mydiaree.com.au/6702097eac1f0.png',
      'userType': 'Staff',
    },
    {
      'id': '132',
      'name': 'rajat',
      'email': 'rj@gmail.com',
      'password': '',
      'contactNo': '8909355555',
      'gender': 'MALE',
      'avatarUrl': 'https://mydiaree.com.au/673b021a5959c.jpg',
      'userType': 'Staff',
    },
    {
      'id': '140',
      'name': 'Rajat tester',
      'email': 'rajatjain5498@mail.com',
      'password': '',
      'contactNo': '8909357490',
      'gender': 'MALE',
      'avatarUrl': 'https://mydiaree.com.au/67728ec93a784.png',
      'userType': 'Staff',
    },
    {
      'id': '141',
      'name': 'Jack',
      'email': 'jack@gmail.com',
      'password': '',
      'contactNo': '2552552554',
      'gender': 'MALE',
      'avatarUrl': 'https://mydiaree.com.au/67a0f5ee340c8.jpg',
      'userType': 'Staff',
    },
  ];

  static List<Map<String, dynamic>> dummyCentersData = [
    {'id': '1', 'name': 'Melbourne Center'},
    {'id': '2', 'name': 'Carramar Center'},
    {'id': '3', 'name': 'Brisbane Center'},
    {'id': '110', 'name': 'test'},
    {'id': '112', 'name': 'mytesting325'},
  ];

  Future<List<StaffModel>> getStaff() async {
    await Future.delayed(const Duration(seconds: 3));
    return dummyStaffData.map((data) => StaffModel.fromJson(data)).toList();
  }

  Future<ApiResponse> addStaff({
    required String name,
    required String email,
    required String password,
    required String contactNo,
    required String gender,
    required String avatarUrl,
    required String userType,
  }) async {
    return await postAndParse(
      AppUrls.staffStore,
      dummy: true,
      {
        'name': name,
        'email': email,
        'password': password,
        'contactNo': contactNo,
        'gender': gender,
        'avatarUrl': avatarUrl,
        'userType': userType,
      },
    );
  }

  Future<ApiResponse> updateStaff({
    required String id,
    required String name,
    required String email,
    required String password,
    required String contactNo,
    required String gender,
    required String avatarUrl,
    required String userType,
  }) async {
    return await postAndParse(
      '${AppUrls.staffUpdate}/$id',
      dummy: true,
      {
        'id': id,
        'name': name,
        'email': email,
        'password': password,
        'contactNo': contactNo,
        'gender': gender,
        'avatarUrl': avatarUrl,
        'userType': userType,
      },
    );
  }

  Future<ApiResponse> deleteStaff(String staffId) async {
    return await postAndParse(
      '${AppUrls.staffDelete}/$staffId',
      dummy: true,
      {
        '_method': 'DELETE',
      },
    );
  }
}
