import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:image_picker/image_picker.dart';
import 'package:mydiaree/core/config/app_urls.dart';
import 'package:mydiaree/core/services/api_services.dart';
import 'package:mydiaree/features/auth/data/models/login_model.dart';
import 'package:mydiaree/features/auth/data/models/signup_model.dart';

class AuthenticationRepository {
  Future<SignupModel?> registerUser({
    String? name = '',
    String? username = '',
    String? email  = '',
    String? password = '',
    String? contact = '',
    String? gender = 'Select',
    String? dob = '',
    XFile? profileImage,
  }) async {
    String url = AppUrls.signup; // Make sure this is defined in your AppUrls
    // Prepare data
    final data = {
      'name': name,
      'username': username,
      'email': email,
      'password': password,
      'contact': contact,
      'gender': gender,
      'dob': dob,
    };
    print('data is here of signup');
    print(data);

    // Prepare files if image is provided
    List<MultipartFile>? files;
    if (profileImage != null) {
      files = [
        await MultipartFile.fromFile(profileImage.path,
            filename: profileImage.name),
      ];
    } 
    await Future.delayed(const Duration(seconds: 5));
    return SignupModel(
      token: 'static_token', // Replace with actual token if needed
      id: '1',
      name: name,
      username: username,
      email: email,
      contact: contact,
      gender: gender,
      dob: dob,
      profileImageUrl: profileImage?.path ?? '', password: '',
    );

    // The following code is commented out because APIs are not available
    /*
    try {
      final response = await ApiServices.postData(
      url,
      data,
      files: files,
      fileField: 'profile_image', // Change this key as per your API
      );
      if (response.statusCode == 200) {
      return SignupModel.fromJson(jsonDecode(response.body));
      } else {
      throw Exception('Failed to sign up');
      }
    } catch (e) {
      return null;
    }
    */
  }

  // Example method for user login
  Future<LoginModel?> loginUser(String username, String password) async {
    try {
      const url = AppUrls.login;
      // The following code is commented out because APIs are not available
      /*
      final response = await ApiServices.postData(
        url,
        {
          'username': username,
          'password': password,
        },
      );
      */
      // if (response.statusCode == 200) {
      //   return LoginModel.fromJson(jsonDecode(response.body));
      // } else {
      //   throw Exception('Failed to login');
      // }
      await Future.delayed(const Duration(seconds: 3));
      return LoginModel(
        token: 'static_token', // Replace with actual token if needed
        userId: '1', );
    } catch (e) {
      return null;
    }
  }

  Future<void> logoutUser() async {}

  Future<Map<String, dynamic>> getUserData(String userId) async {
    return {};
  }
}
