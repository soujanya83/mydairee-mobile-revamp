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
      // Map<String, dynamic> responseJson = {
      //   "status": true,
      //   "message": "Sleep checks list fetched successfully.",
      //   "centerid": 1,
      //   "date": "2025-04-30",
      //   "roomid": "298293519",
      //   "roomname": "New Room test new",
      //   "roomcolor": "##A51F83",
      //   "children": [
      //     {
      //       "id": 4,
      //       "name": "Julien",
      //       "lastname": "khan",
      //       "dob": "0000-00-00",
      //       "startDate": "0000-00-00",
      //       "room": 298293519,
      //       "imageUrl": "Julien.jpg",
      //       "gender": "Female",
      //       "status": "Active",
      //       "daysAttending": "11111",
      //       "centerid": 1,
      //       "createdBy": 1,
      //       "createdAt": "2025-05-14 00:20:02",
      //       "sleepchecks": []
      //     },
      //     {
      //       "id": 5,
      //       "name": "Maxy",
      //       "lastname": "Den",
      //       "dob": "2018-06-09",
      //       "startDate": "2021-10-01",
      //       "room": 298293519,
      //       "imageUrl": "Maxy.jpg",
      //       "gender": "Female",
      //       "status": "Active",
      //       "daysAttending": "11111",
      //       "centerid": 1,
      //       "createdBy": 1,
      //       "createdAt": "2024-11-20 11:32:56",
      //       "sleepchecks": [
      //         {
      //           "id": 41,
      //           "childid": 5,
      //           "roomid": 298293519,
      //           "diarydate": "2025-04-30",
      //           "time": "18:11",
      //           "breathing": "Fast",
      //           "body_temperature": "Warm",
      //           "notes": "testt",
      //           "createdBy": "1",
      //           "created_at": "2025-04-30 16:09:36"
      //         }
      //       ]
      //     },
      //     {
      //       "id": 6,
      //       "name": "Nayra",
      //       "lastname": "Muzzen",
      //       "dob": "2018-05-21",
      //       "startDate": "2021-10-01",
      //       "room": 298293519,
      //       "imageUrl": "Nayra.jpg",
      //       "gender": "Female",
      //       "status": "Active",
      //       "daysAttending": "11111",
      //       "centerid": 1,
      //       "createdBy": 1,
      //       "createdAt": "2024-11-20 11:32:56",
      //       "sleepchecks": []
      //     },
      //     {
      //       "id": 7,
      //       "name": "Samyon",
      //       "lastname": "Johan",
      //       "dob": "2018-03-28",
      //       "startDate": "2021-10-01",
      //       "room": 298293519,
      //       "imageUrl": "Samyon.jpg",
      //       "gender": "Male",
      //       "status": "Active",
      //       "daysAttending": "11111",
      //       "centerid": 1,
      //       "createdBy": 1,
      //       "createdAt": "2024-11-20 11:32:56",
      //       "sleepchecks": []
      //     }
      //   ],
      //   "rooms": [
      //     {
      //       "id": 298293519,
      //       "name": "New Room test new",
      //       "capacity": 12,
      //       "userId": 1,
      //       "color": "##A51F83",
      //       "ageFrom": 2,
      //       "ageTo": 2,
      //       "status": "Inactive",
      //       "centerid": 1,
      //       "created_by": null
      //     },
      //     {
      //       "id": 1452405015,
      //       "name": "Wonderers ",
      //       "capacity": 15,
      //       "userId": 1,
      //       "color": "##9C52C1",
      //       "ageFrom": 8,
      //       "ageTo": 15,
      //       "status": "Active",
      //       "centerid": 1,
      //       "created_by": null
      //     },
      //     {
      //       "id": 1147434776,
      //       "name": "Peace Makers",
      //       "capacity": 2,
      //       "userId": 1,
      //       "color": "##2F1140",
      //       "ageFrom": 15,
      //       "ageTo": 25,
      //       "status": "Active",
      //       "centerid": 1,
      //       "created_by": null
      //     },
      //     {
      //       "id": 1698919388,
      //       "name": "amir",
      //       "capacity": 2,
      //       "userId": 1,
      //       "color": "#a: 1.00",
      //       "ageFrom": 1,
      //       "ageTo": 3,
      //       "status": "Active",
      //       "centerid": 1,
      //       "created_by": null
      //     },
      //     {
      //       "id": 1013182027,
      //       "name": "test",
      //       "capacity": 10,
      //       "userId": 1,
      //       "color": "#a: 1.00",
      //       "ageFrom": 0,
      //       "ageTo": 5,
      //       "status": "Active",
      //       "centerid": 1,
      //       "created_by": null
      //     },
      //     {
      //       "id": 882472612,
      //       "name": "test by apk",
      //       "capacity": 10,
      //       "userId": 1,
      //       "color": "##000000",
      //       "ageFrom": 0,
      //       "ageTo": 8,
      //       "status": "Active",
      //       "centerid": 1,
      //       "created_by": null
      //     },
      //     {
      //       "id": 1797944727,
      //       "name": "new rimm test new2",
      //       "capacity": 5,
      //       "userId": 1,
      //       "color": "##9320CC",
      //       "ageFrom": 5,
      //       "ageTo": 5,
      //       "status": "Active",
      //       "centerid": 1,
      //       "created_by": null
      //     }
      //   ],
      //   "permissions": null,
      //   "centers": [
      //     {
      //       "id": 1,
      //       "user_id": null,
      //       "centerName": "Melbourne Center",
      //       "adressStreet": "Block 1, Near X Junction,  Australia",
      //       "addressCity": "Melbourne",
      //       "addressState": "Queensland",
      //       "addressZip": "373456",
      //       "created_at": "2025-06-03T13:02:10.000000Z",
      //       "updated_at": "2025-06-03T13:02:10.000000Z"
      //     },
      //     {
      //       "id": 2,
      //       "user_id": null,
      //       "centerName": "Carramar Center",
      //       "adressStreet": "126 The Horsley Dr",
      //       "addressCity": "Carramar",
      //       "addressState": "NSW",
      //       "addressZip": "2163",
      //       "created_at": "2025-06-03T13:02:10.000000Z",
      //       "updated_at": "2025-06-03T13:02:10.000000Z"
      //     },
      //     {
      //       "id": 3,
      //       "user_id": null,
      //       "centerName": "Brisbane Center",
      //       "adressStreet": "5 Boundary St, Brisbane",
      //       "addressCity": "Brisbane",
      //       "addressState": "Queensland2",
      //       "addressZip": "4001",
      //       "created_at": "2025-06-03T13:02:10.000000Z",
      //       "updated_at": "2025-06-06T10:23:16.000000Z"
      //     },
      //     {
      //       "id": 110,
      //       "user_id": 1,
      //       "centerName": "test",
      //       "adressStreet": "test",
      //       "addressCity": "test22",
      //       "addressState": "test22",
      //       "addressZip": "2514",
      //       "created_at": "2025-06-04T19:27:19.000000Z",
      //       "updated_at": "2025-06-04T20:02:33.000000Z"
      //     },
      //     {
      //       "id": 112,
      //       "user_id": 1,
      //       "centerName": "mytesting325",
      //       "adressStreet": "testig",
      //       "addressCity": "testtt12",
      //       "addressState": "testtt2",
      //       "addressZip": "12548",
      //       "created_at": "2025-06-04T19:29:00.000000Z",
      //       "updated_at": "2025-06-04T20:15:03.000000Z"
      //     },
      //     {
      //       "id": 117,
      //       "user_id": 1,
      //       "centerName": "Bright Minds Academy",
      //       "adressStreet": "123 Garden Street",
      //       "addressCity": "Lucknow",
      //       "addressState": "Uttar Pradesh",
      //       "addressZip": "226001",
      //       "created_at": "2025-07-11T00:36:51.000000Z",
      //       "updated_at": "2025-07-11T00:36:51.000000Z"
      //     }
      //   ]
      // };

      // return SleepCheckResponseModel.fromJson(responseJson);
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
