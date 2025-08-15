import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:mydiaree/core/config/app_urls.dart';
import 'package:mydiaree/core/services/api_services.dart';
import 'package:mydiaree/core/services/apiresoponse.dart';
import 'package:mydiaree/features/daily_journal/daily_diaree/data/model/daily_diaree_model.dart';

class DailyTrackingRepository {
  Future<ApiResponse<DailyDiareeModel?>> getDailyDiaree({
    required String centerId,
    required String roomId,
    required DateTime? date,
  }) async {
    final formattedDate = "${date?.year.toString().padLeft(4,'0')}-${date?.month.toString().padLeft(2,'0')}-${date?.day.toString().padLeft(2,'0')}";
    final url = '${AppUrls.baseUrl}/api/DailyDiary/list'
        '?center_id=$centerId'
        '&room_id=$roomId'
        '&selected_date=$formattedDate';
    //  final nUrl = 'https://mydiaree.com.au/api/DailyDiary/list?center_id=102&room_id=1621392989&selected_date=2025-08-12';
    return await getAndParseData(
      url,
      fromJson: (json) {
        debugPrint(json.toString(), wrapWidth: 1024);
        print('vvvvvvvvvvvvv');
        final data = DailyDiareeModel.fromJson(json);
        print('======++++++++++++++++=========');
        print(data.data);
        print(data.data?.centers?.length);
        print(data.data?.rooms?.length);
        print(data.message);
        print(data.data?.children?.length);
        return data;
      },
    );
  }

  Future<ApiResponse<dynamic>> postBreakfast({
    required String date,
    required List<String> childIds,
    required String time,
    required String item,
    String? comments,
  }) async {
    final data = FormData.fromMap({
      'date': date,
      'time': time,
      'item': item,
      if (comments != null) 'comments': comments,
      // Add each childId as 'child_ids[]'
      for (var id in childIds) 'child_ids[]': id,
    });
    print('Posting Breakfast Data:');
    print({
      'date': date,
      'child_ids': childIds,
      'time': time,
      'item': item,
      if (comments != null) 'comments': comments,
    });
    final resp = await ApiServices.postData(
      '${AppUrls.baseUrl}/api/activities/breakfast',
      data,
    );
    print('Response from Breakfast API: ${resp.data.toString()}');
    return ApiResponse(success: resp.success, message: resp.message, data: resp.data);
  }


  Future<ApiResponse<dynamic>> postLunch({
    required String date,
    required List<String> childIds,
    required String time,
    required String item,
    String? comments,
  }) async {
    final data = FormData.fromMap({
      'date': date,
      'time': time,
      'item': item,
      if (comments != null) 'comments': comments,
      // Add each childId as 'child_ids[]'
      for (var id in childIds) 'child_ids[]': id,
    });
    print('Posting Breakfast Data:');
    print({
      'date': date,
      'child_ids': childIds,
      'time': time,
      'item': item,
      if (comments != null) 'comments': comments,
    });
    final resp = await ApiServices.postData(
      '${AppUrls.baseUrl}/api/activities/lunch',
      data,
    );
    print('Response from Lunch API: ${resp.data.toString()}');
    return ApiResponse(success: resp.success, message: resp.message, data: resp.data);
  }

  Future<ApiResponse<dynamic>> postLateSnack({
    required String date,
    required List<String> childIds,
    required String time,
    required String item,
    String? comments,
  }) async {
    final data = FormData.fromMap({
      'date': date,
      'child_ids': childIds,
      'time': time,
      'item': item,
      if (comments != null) 'comments': comments,
    });
    final resp = await ApiServices.postData(
      '${AppUrls.baseUrl}/api/activities/late-snack',
      data,
    );
    return ApiResponse(success: resp.success, message: resp.message, data: resp.data);
  }

  Future<ApiResponse<dynamic>> postMorningTea({
    required String date,
    required List<String> childIds,
    required String time,
    String? comments,
  }) async {
    final data = FormData.fromMap({
      'date': date,
      for (var id in childIds) 'child_ids[]': id,
      'time': time,
      if (comments != null) 'comments': comments,
    });
    final resp = await ApiServices.postData(
      '${AppUrls.baseUrl}/api/activities/morning-tea',
      data,
    );
    return ApiResponse(success: resp.success, message: resp.message, data: resp.data);
  }

  Future<ApiResponse<dynamic>> postAfternoonTea({
    required String date,
    required List<String> childIds,
    required String time,
    String? comments,
  }) async {
    final data = FormData.fromMap({
      'date': date,
       for (var id in childIds) 'child_ids[]': id,
      'time': time,
      if (comments != null) 'comments': comments,
    });
    final resp = await ApiServices.postData(
      '${AppUrls.baseUrl}/api/activities/afternoon-tea',
      data,
    );
    return ApiResponse(success: resp.success, message: resp.message, data: resp.data);
  }

  Future<ApiResponse<dynamic>> storeSleep({
    required String date,
    required List<String> childIds,
    required String sleepTime,
    required String wakeTime,
    String? comments,
    String? id, // when provided, will update existing
  }) async {
    final map = {
      'date': date,
      for (var id in childIds) 'child_ids[]': id,
      'sleep_time': sleepTime,
      'wake_time': wakeTime,
      if (comments != null) 'comments': comments,
      if (id != null) 'id': id,
    };
    final data = FormData.fromMap(map);
    print('data of sleep: ${data.fields}');
    final resp = await ApiServices.postData(
      '${AppUrls.baseUrl}/api/dailyDiary/storeSleep',
      data,
    );
    return ApiResponse(success: resp.success, message: resp.message, data: resp.data);
  }

  Future<ApiResponse<dynamic>> storeToileting({
    required String date,
    required List<String> childIds,
    required String time,
    required String status,
    String? comments,
    String? signature,
    String? id,
  }) async {
    final map = {
      'date': date,
      'child_ids': childIds,
      'time': time,
      'status': status,
      if (comments != null) 'comments': comments,
      if (signature != null) 'signature': signature,
      if (id != null) 'id': id,
    };
    final data = FormData.fromMap(map);
    final resp = await ApiServices.postData(
      '${AppUrls.baseUrl}/api/dailyDiary/storeToileting',
      data,
    );
    return ApiResponse(success: resp.success, message: resp.message, data: resp.data);
  }

  Future<ApiResponse<dynamic>> storeSunscreen({
    required String date,
    required List<String> childIds,
    required String time,
    String? comments,
    String? signature,
    String? id,
  }) async {
    final map = {
      'date': date,
      'child_ids': childIds,
      'time': time,
      if (comments != null) 'comments': comments,
      if (signature != null) 'signature': signature,
      if (id != null) 'id': id,
    };
    final data = FormData.fromMap(map);
    final resp = await ApiServices.postData(
      '${AppUrls.baseUrl}/api/dailyDiary/storeSunscreen',
      data,
    );
    return ApiResponse(success: resp.success, message: resp.message, data: resp.data);
  }

  Future<ApiResponse<dynamic>> storeBottle({
    required String date,
    required List<String> childIds,
    required String time,
    String? comments,
    String? id,
  }) async {
    final map = {
      'date': date,
      'child_ids': childIds,
      'time': time,
      if (comments != null) 'comments': comments,
      if (id != null) 'id': id,
    };
    final data = FormData.fromMap(map);
    final resp = await ApiServices.postData(
      '${AppUrls.baseUrl}/api/dailyDiary/storeBottle',
      data,
    );
    return ApiResponse(success: resp.success, message: resp.message, data: resp.data);
  }
}