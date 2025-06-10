import 'package:dio/dio.dart';

bool validApiResponse(Response response) {
  if ((response.statusCode == 200) || (response.statusCode == 201)) {
    return true;
  } else {
    false;
  }
  return false;
}
