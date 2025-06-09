import 'package:dio/dio.dart';
class ApiServices{

 static  Future<dynamic> fetchData(String url) async {
    final dio = Dio();
    try {
      final response = await dio.get(url);
      if (response.statusCode != 200) {
        return {'error': 'Failed to load data', 'statusCode': response.statusCode};
      }
      return response.data;
    } catch (e) {
      return {'error': e.toString()};
    }
  }

 static Future<dynamic> postData(
    String url,
    dynamic data, {
    Map<String, dynamic>? headers,
    List<MultipartFile>? files,
    String? fileField = 'file',
  }) async {
    final dio = Dio();
    try {
      Options? options;
      if (headers != null) {
        options = Options(headers: headers);
      }

      dynamic body = data;

      // If files are provided, use FormData
      if (files != null && files.isNotEmpty) {
        final formData = FormData();
        // Add fields from data if it's a Map
        if (data is Map<String, dynamic>) {
          formData.fields.addAll(
            data.entries.map((e) => MapEntry(e.key, e.value.toString())),
          );
        }
        // Add files
        for (var file in files) {
          formData.files.add(MapEntry(fileField!, file));
        }
        body = formData;
      }

      final response = await dio.post(
        url,
        data: body,
        options: options,
      );
      if (response.statusCode != 200 && response.statusCode != 201) {
        return {
          'error': 'Failed to post data',
          'statusCode': response.statusCode
        };
      }
      return response.data;
    } catch (e) {
      return {'error': e.toString()};
    }
  }
}