import 'dart:convert';

import 'package:intl/intl.dart';
import 'package:mydiaree/core/config/app_urls.dart';
import 'package:mydiaree/core/services/apiresoponse.dart';
import 'package:mydiaree/features/daily_journal/sleepchecks/data/model/sleep_check_model.dart';

// Dummy data for SlipChecksChildListModel
final dummySleepChecklistData = {
  "children": [
    {
      "id": "1",
      "name": "John",
      "lastname": "Doe",
      "dob": "2020-05-15",
      "startDate": "2023-01-10",
      "room": "1",
      "imageUrl": "child1.jpg",
      "gender": "Male",
      "status": "Active",
      "daysAttending": "Monday,Wednesday,Friday",
      "createdBy": "admin1",
      "createdAt": "2023-01-10T10:00:00Z",
      "sleepChecks": [
        {
          "id": "1",
          "childId": "1",
          "roomId": "1",
          "diaryDate": "04-07-2025",
          "time": "10:30",
          "breathing": "Regular",
          "bodyTemperature": "Warm",
          "notes": "Sleeping well",
          "createdBy": "educator1",
          "createdAt": "2025-07-04T10:30:00Z",
          "previousBreathing": null,
          "previousBodyTemperature": null
        },
        {
          "id": "2",
          "childId": "1",
          "roomId": "1",
          "diaryDate": "04-07-2025",
          "time": "11:00",
          "breathing": "Fast",
          "bodyTemperature": "Cool",
          "notes": "Restless",
          "createdBy": "educator1",
          "createdAt": "2025-07-04T11:00:00Z",
          "previousBreathing": "Regular",
          "previousBodyTemperature": "Warm"
        }
      ]
    },
    {
      "id": "2",
      "name": "Jane",
      "lastname": "Smith",
      "dob": "2021-03-20",
      "startDate": "2023-02-15",
      "room": "2",
      "imageUrl": "child2.jpg",
      "gender": "Female",
      "status": "Active",
      "daysAttending": "Tuesday,Thursday",
      "createdBy": "admin2",
      "createdAt": "2023-02-15T09:00:00Z",
      "sleepChecks": [
        {
          "id": "3",
          "childId": "2",
          "roomId": "2",
          "diaryDate": "04-07-2025",
          "time": "10:45",
          "breathing": "Difficult",
          "bodyTemperature": "Hot",
          "notes": "Needs attention",
          "createdBy": "educator2",
          "createdAt": "2025-07-04T10:45:00Z",
          "previousBreathing": null,
          "previousBodyTemperature": null
        }
      ]
    },
    {
      "id": "3",
      "name": "Alex",
      "lastname": "Johnson",
      "dob": "2019-11-10",
      "startDate": "2022-11-01",
      "room": "1",
      "imageUrl": "",
      "gender": "Male",
      "status": "Inactive",
      "daysAttending": "Monday,Tuesday,Wednesday",
      "createdBy": "admin1",
      "createdAt": "2022-11-01T08:00:00Z",
      "sleepChecks": []
    }
  ]
};

class SleepChecklistRepository {
  Future<ApiResponse<SlipChecksChildListModel?>> getSleepChecklist({
    required String userId,
    required String centerId,
    required String roomId,
    required DateTime date,
  }) async {
    return await postAndParse(
      AppUrls.getSleepChecklist,
      dummy: true,
      dummyData: dummySleepChecklistData,
      {
        'userid': userId,
        'centerid': centerId,
        'roomid': roomId,
        'date': DateFormat("yyyy-MM-dd").format(date),
      },
      fromJson: (json) {
        try {
          return SlipChecksChildListModel.fromJson(json);
        } catch (e, s) {
          print('====================');
          print(e.toString());
          print('----------');
          print(s.toString());
          print('----------');
          return SlipChecksChildListModel.fromJson(dummySleepChecklistData);
        }
      },
    );
  }

  Future<ApiResponse> addUpdateSleepCheck(
      {required String userId,
      required String childId,
      required String roomId,
      required DateTime diaryDate,
      required String time,
      required String breathing,
      required String bodyTemperature,
      required String notes,
      String? id}) async {
    return await postAndParse(
      AppUrls.addSleepChecklist,
      dummy: true,
      {
        if (id != null) 'id': id,
        'userid': userId,
        'childid': childId,
        'roomid': roomId,
        'diarydate': DateFormat("dd-MM-yyyy").format(diaryDate),
        'time': time,
        'breathing': breathing,
        'body_temperature': bodyTemperature,
        'notes': notes,
      },
    );
  }

  Future<ApiResponse> deleteSleepCheck({
    required String userId,
    required String id,
  }) async {
    return await postAndParse(
      AppUrls.deleteSleepChecklist,
      dummy: true,
      {
        'userid': userId,
        'id': id,
      },
    );
  }
}
