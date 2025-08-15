import 'dart:convert';
import 'dart:math' as Math;

import 'package:dio/dio.dart';
import 'package:flutter/widgets.dart';
import 'package:mydiaree/core/services/apiresoponse.dart';
import 'package:mydiaree/core/services/shared_preference_service.dart';
import 'package:mydiaree/core/utils/helper_functions.dart';

class ApiServices {
  static Future<dynamic> fetchData(String url) async {
    final dio = Dio();
    try {
      final response = await dio.get(url);
      if (response.statusCode != 200) {
        return {
          'error': 'Failed to load data',
          'statusCode': response.statusCode
        };
      }
      return response.data;
    } catch (e) {
      return {'error': e.toString()};
    }
  }

  static Future<ApiResponse> getData(
    String url, {
    Map<String, dynamic>? headers,
    Map<String, dynamic>? queryParameters,
    Map<String, dynamic>? dummyData,
  }) async {
    final dio = Dio();

    try {
      if (dummyData != null) {
        // print('Dummy GET triggered');
        // print('Dummy Data: $dummyData');
        await Future.delayed(const Duration(seconds: 2));
        return ApiResponse(
          data: dummyData,
          success: true,
          message: 'Dummy get successful',
        );
      }

      // Prepare headers
      Options? options;
      options = Options(
        headers: headers ?? await getAuthHeaders(),
        validateStatus: (status) {
          return true;
        },
      );

      // Debug authentication
      // final authToken = await getToken();
      // // print('=================================');
      // // print('authotoken $authToken');

      // // // Print Debug Info
      // // print('Sending GET request');
      // // print('URL: $url');
      // // if (queryParameters != null) {
      // //   print('Query Parameters: $queryParameters');
      // // }
      // // if (headers != null) {
      // //   print('Headers: $headers');
      // // }

      // Perform request
      final response = await dio.get(
        url,
        queryParameters: queryParameters,
        options: options,
      );

      // Debug response
      print('Response Received');
      print('Status Code: ${response.statusCode}');
      print('Response Data: ${response.data.toString()}');
       
      if (validApiResponse(response)) {
        return ApiResponse(
          success: true,
          data: response.data,
          message: getApiMessage(response),
        );
      } else {
        return ApiResponse(
          success: false,
          data: response.data,
          message: getApiMessage(response),
        );
      }
    } catch (e, s) {
      print('Error in getData');
      print('Error: $e');
      print('Stack: $s');
      return ApiResponse(success: false, message: 'Something Went Wrong');
    }
  }

  static Future<ApiResponse> deleteData(
    String url, {
    Map<String, dynamic>? headers,
    dynamic data,
  }) async {
    final dio = Dio();

    try {
      Options options = Options(
        method: 'DELETE',
        headers: headers ?? await getAuthHeaders(),
        validateStatus: (status) => true,
      );

      print('Sending DELETE request');
      print('URL: $url');
      if (headers != null) {
        print('Headers: $headers');
      }

      final response = await dio.request(
        url,
        options: options,
        data: data,
      );

      print('Response Received');
      print('Status Code: ${response.statusCode}');
      print('Response Data: ${response.data}');

      if (validApiResponse(response)) {
        return ApiResponse(
          success: true,
          data: response.data,
          message: getApiMessage(response),
        );
      } else {
        return ApiResponse(
          success: false,
          data: response.data,
          message: getApiMessage(response),
        );
      }
    } catch (e, s) {
      print('Error in deleteData');
      print('Error: $e');
      print('Stack: $s');
      return ApiResponse(success: false, message: 'Something Went Wrong');
    }
  }

  static Future<ApiResponse> postData(String url, dynamic data,
      {Map<String, dynamic>? headers,
      List<String>? filesPath,
      String? fileField = 'file',
      bool dummy = false,
      Map<String, dynamic>? dummyData}) async {
    final dio = Dio();
    try {
      Options? options;
      options = Options(
        headers: headers ?? await getAuthHeaders(),
        validateStatus: (status) {
          return true;
        },
      );

      // Debug authentication
      final authToken = await getToken();
      print('Using auth token: ${authToken != null ? (authToken.substring(0, Math.min(10, authToken.length)) + "...") : "NULL"}');

      dynamic body = data;
      List<MultipartFile>? files;
      if (filesPath != null && filesPath.isNotEmpty) {
        try {
          files = await Future.wait(
            List.generate(filesPath.length, (index) {
              return MultipartFile.fromFile(filesPath[index],
                  filename: filesPath[index].split('/').last);
            }),
          );
        } catch (e) {
          debugPrint(e.toString());
        }
      }

      if (files != null && files.isNotEmpty) {
        debugPrint('running here');
        final formData = FormData();
        if (data is Map<String, dynamic>) {
          formData.fields.addAll(
            data.entries.map((e) => MapEntry(e.key, e.value.toString())),
          );
        }
        for (var file in files) {
          formData.files.add(MapEntry(fileField!, file));
        }
        body = formData;
      }

      // if (dummy) {
      //   print('dummy data');
      //   print(dummyData);
      //   print(options);
      //   await Future.delayed(const Duration(seconds: 3));
      //   return ApiResponse(
      //     data: dummyData,
      //     success: true,
      //     message: 'Dummy post successful',
      //   );
      // }

      final response = await dio.post(
        url,
        data: body,
        options: options,
      );
      if (validApiResponse(response)) {
        return ApiResponse(
            success: true,
            data: response.data,
            message: getApiMessage(response));
      }
      return ApiResponse(
          success: false,
          data: response.data,
          message: getApiMessage(response));
    } catch (e, s) {
      print('error in postData function');
      debugPrint(e.toString());
      debugPrint(s.toString());
      return ApiResponse(success: false, message: 'Something Went Wrong');
    }
  }

  static Future<dynamic> fetchDataDummy(String url) async {
    await Future.delayed(const Duration(seconds: 2));
    return {
      'statusCode': 200,
      'message': 'Dummy fetch successful',
      'data': {'url': url, 'result': 'This is dummy data'},
    };
  }

  static Future<dynamic> postDataDummy(
    String url,
    dynamic data, {
    Map<String, dynamic>? headers,
    List<String>? filesPath,
    String? fileField = 'file',
  }) async {
    await Future.delayed(const Duration(seconds: 4));
    return {
      'statusCode': 200,
      'message': 'Dummy post successful',
      'data': data,
    };
  }

  static Future<Map<String, dynamic>> getAuthHeaders() async {
    final token = await getToken();
    print('here is the token: $token');

    if (token == null || token.isEmpty) {
      print("WARNING: No authentication token available");
      return {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
      };
    }

    return {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
      'Authorization': 'Bearer $token',
    };
  }
}
