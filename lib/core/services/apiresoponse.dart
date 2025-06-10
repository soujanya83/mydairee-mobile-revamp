import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:mydiaree/core/services/api_services.dart';

class ApiResponse<T> {
  final bool success;
  final String message;
  final T? data;

  ApiResponse({required this.success,required this.message, this.data});
}

Future<ApiResponse<T?>> postAndParse<T>(
  String url,
  Map<String, dynamic> data, {
  T Function(dynamic json)? fromJson,
  List<String>? filesPath,
  String? fileField,
}) async {
  try {
    final response = await ApiServices.postData(
      url,
      data,
      filesPath: filesPath,
      fileField: fileField,
    );
    if (response.success) {
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

Future<ApiResponse<T?>> getAndParseData<T>(
  String url, {
  Map<String, dynamic>? data,
  T Function(dynamic json)? fromJson,
}) async {
  try {
    final response = await ApiServices.getData(
      url,
      queryParameters: data,
    );
    if (response.success) {
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



String getApiMessage(Response response) {
  try {
    return jsonDecode(response.data)['msg'].toString();
  } catch (e) {
    return '';
  }
}

String defaultErrorMessage() {
    return 'Something Went Wrong'; 
}
