import 'dart:convert';
import 'package:intl/intl.dart';
import 'package:mydiaree/core/services/api_services.dart';
import 'package:mydiaree/core/services/apiresoponse.dart';
import 'package:mydiaree/features/daily_journal/sleepchecks/data/models/sleep_check_response_model.dart';

class SleepCheckRepository {
  final String baseUrl = 'https://mydiaree.com.au/api';

  Future<ApiResponse<SleepCheckResponseModel?>> getSleepChecks({
    required String centerId,
    String? roomId,
    String? date,
  }) async {
    final url =
        '$baseUrl/sleepcheck/list?centerid=$centerId${roomId != null ? '&roomid=$roomId' : ''}${date != null ? '&date=$date' : ''}';

    return await getAndParseData<SleepCheckResponseModel>(url,
        fromJson: (json) { 
      return SleepCheckResponseModel.fromJson(json);
    });
  }

  Future<ApiResponse> saveSleepCheck({
    required int childId,
    required String diaryDate,
    required int roomId,
    required String time,
    required String breathing,
    required String bodyTemperature,
    required String notes,
    required int userId,
  }) async {
    final url = '$baseUrl/sleepcheck/save';

    final Map<String, dynamic> data = {
      'childid': childId,
      'diarydate': diaryDate,
      'roomid': roomId,
      'time': time,
      'breathing': breathing,
      'body_temperature': bodyTemperature,
      'notes': notes,
      'userid': userId,
    };

    return await postAndParse(url, data);
  }

  Future<ApiResponse> updateSleepCheck({
    required int id,
    required int childId,
    required String diaryDate,
    required int roomId,
    required String time,
    required String breathing,
    required String bodyTemperature,
    required String notes,
    required int userId,
  }) async {
    final url = '$baseUrl/sleepcheck/update';

    final Map<String, dynamic> data = {
      'id': id,
      'childid': childId,
      'diarydate': diaryDate,
      'roomid': roomId,
      'time': time,
      'breathing': breathing,
      'body_temperature': bodyTemperature,
      'notes': notes,
      'userid': userId,
    };

    return await postAndParse(url, data);
  }

  Future<ApiResponse> deleteSleepCheck({
    required int id,
  }) async {
    final url = '$baseUrl/sleepcheck/delete?id=$id';

    return await postAndParse(url, {});
  }
}
