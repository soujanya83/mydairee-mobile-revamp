import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/widgets.dart';
import 'package:mydiaree/core/services/api_services.dart';

class ApiResponse<T> {
  final bool success;
  final String message;
  final T? data;

  ApiResponse({required this.success, required this.message, this.data});
}

Future<ApiResponse<T?>> postAndParse<T>(String url, Map<String, dynamic> data,
    {T Function(dynamic json)? fromJson,
    List<String>? filesPath,
    String? fileField,
    bool dummy = false,
    Map<String, dynamic>? dummyData}) async {
  try {
    print('Posting data to $url with data: ${jsonEncode(data)}');
    final response = await ApiServices.postData(url, data,
        filesPath: filesPath,
        fileField: fileField,
        dummy: dummy,
        dummyData: dummyData);
      if(dummyData != null) { 
        print('Dummy Data: $dummyData');
        await Future.delayed(const Duration(seconds: 2));
        return ApiResponse(
          success: true,
          data: fromJson != null ? fromJson(dummyData) : null,
          message: '',
        );
      }
    print('Response: ${response.data}');
    print('Success: ${response.success}');
    print('Message: ${response.message}');
    if (response.success) {
      return ApiResponse(
          success: true,
          data: fromJson != null ? fromJson(response.data ?? {}) : null,
          message: response.message);
    } else {
      return ApiResponse(success: false, message: response.message);
    }
  } catch (e, s) {
    print('error in postAndParse function');
    debugPrint(e.toString());
    debugPrint(s.toString());
    return ApiResponse(success: false, message: 'Something Went Wrong');
  }
}

Future<ApiResponse<T?>> getAndParseData<T>(
  String url, { 
  T Function(dynamic json)? fromJson, 
  Map<String, dynamic>? dummyData,
  Map<String, dynamic>? queryParameters,
}) async {
  try {
    final response = await ApiServices.getData(
      url,
      queryParameters: queryParameters, 
      dummyData: dummyData,
    );
    print('Response: ${response.data}');
    print('Success: ${response.success}');
    print('Message: ${response.message}');
    if (response.success) {
      try {
        if (fromJson != null) {
          return ApiResponse(
            success: true,
            data: fromJson(response.data),
            message: response.message,
          );
        } else {
          return ApiResponse(
            success: true,
            data: response.data as T?,
            message: response.message,
          );
        }
      } catch (e,s) {
        print('Error parsing data: $e');
        print('Stack: $s');
        return ApiResponse(success: false, message: 'Data parsing error');
      }
      return ApiResponse(
        success: true,
        data: fromJson != null ? fromJson(response.data) : null,
        message: response.message,
      );
    } else {
      return ApiResponse(success: false, message: response.message);
    }
  } catch (e) {
    return ApiResponse(success: false, message: 'Something Went Wrong');
  }
}

Future<ApiResponse> deleteDataApi(String url, {Map<String, dynamic>? headers, Map<String, dynamic>? data}) async {
  try {
    print('Deleting data from $url');
    final response = await ApiServices.deleteData(url, headers: headers, data: data);
    print('Response: ${response.data}');
    print('Success: ${response.success}');
    print('Message: ${response.message}');
    
    if (response.success) {
      return ApiResponse(success: true, message: response.message);
    } else {
      return ApiResponse(success: false, message: response.message);
    }
  } catch (e, s) {
    print('Error in deleteDataById');
    print('Error: $e');
    print('Stack: $s');
    return ApiResponse(success: false, message: 'Something Went Wrong');
  }
}



String getApiMessage(Response response) {
  try {
    return response.data['message']?.toString() ?? '';
  } catch (e) {
    return '';
  }
}


String defaultErrorMessage() {
  return 'Something Went Wrong';
}
