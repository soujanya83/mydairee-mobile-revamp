import 'package:mydiaree/core/config/app_urls.dart';
import 'package:mydiaree/core/services/apiresoponse.dart';
import 'package:mydiaree/features/daily_journal/daily_diaree/data/model/child_model.dart';
import 'package:mydiaree/features/daily_journal/daily_diaree/data/model/daily_diaree_model.dart';

class DailyTrackingRepository {

  Future<ApiResponse<DailyDiareeModel?>> getDailyDiaree({
    required String centerId,
    String? roomId,
    required DateTime? date,
  }) async {
    // return ApiResponse(success: true, message: '',data: DailyDiareeModel.fromJson(dummyData));
    final formattedDate = "${date?.year.toString().padLeft(4, '0')}-${date?.month.toString().padLeft(2, '0')}-${date?.day.toString().padLeft(2, '0')}";
    final url = '${AppUrls.baseUrl}/api/DailyDiary/list?center_id=$centerId&room_id=$roomId&selected_date=$formattedDate';
    print(url);
    print('=============');
    
    final ApiResponse<DailyDiareeModel?> response = await getAndParseData(
      url,
      // dummyData: dummyData,
      fromJson: (json) { 
        return DailyDiareeModel.fromJson(json);
      },
    );
    print('Response from DailyTrackingRepository: ${response.data}');
    return response;
  }

  final dummyData = {
    "status": true,
    "message": "Daily diary data fetched successfully.",
    "data": {
        "centers": [
            {
                "id": 1,
                "user_id": null,
                "centerName": "Melbourne Center",
                "adressStreet": "Block 1, Near X Junction,  Australia",
                "addressCity": "Melbourne",
                "addressState": "Queensland",
                "addressZip": "373456",
                "created_at": "2025-06-03T07:32:10.000000Z",
                "updated_at": "2025-06-03T07:32:10.000000Z"
            },
            {
                "id": 2,
                "user_id": null,
                "centerName": "Carramar Center",
                "adressStreet": "126 The Horsley Dr",
                "addressCity": "Carramar",
                "addressState": "NSW",
                "addressZip": "2163",
                "created_at": "2025-06-03T07:32:10.000000Z",
                "updated_at": "2025-06-03T07:32:10.000000Z"
            },
            {
                "id": 3,
                "user_id": null,
                "centerName": "Brisbane Center",
                "adressStreet": "5 Boundary St, Brisbane",
                "addressCity": "Brisbane",
                "addressState": "Queensland2",
                "addressZip": "4001",
                "created_at": "2025-06-03T07:32:10.000000Z",
                "updated_at": "2025-06-06T04:53:16.000000Z"
            }
        ],
        "rooms": [
            {
                "id": 339172374,
                "name": "Adventurers",
                "capacity": 15,
                "userId": 12,
                "color": "#912fac",
                "ageFrom": 1,
                "ageTo": 19,
                "status": "Active",
                "centerid": 2,
                "created_by": null
            },
            {
                "id": 943387862,
                "name": "Room no 1",
                "capacity": 11,
                "userId": 91,
                "color": "#25cc20",
                "ageFrom": 0,
                "ageTo": 2,
                "status": "Active",
                "centerid": 2,
                "created_by": 1
            },
            {
                "id": 1654474921,
                "name": "room test 2 new",
                "capacity": 3,
                "userId": 1,
                "color": "##B9181B",
                "ageFrom": 2,
                "ageTo": 5,
                "status": "Active",
                "centerid": 2,
                "created_by": null
            },
            {
                "id": 1969090687,
                "name": "room test 3",
                "capacity": 3,
                "userId": 1,
                "color": "##26162F",
                "ageFrom": 2,
                "ageTo": 5,
                "status": "Active",
                "centerid": 2,
                "created_by": null
            },
            {
                "id": 1481084350,
                "name": "room test 4",
                "capacity": 3,
                "userId": 1,
                "color": "##26162F",
                "ageFrom": 2,
                "ageTo": 5,
                "status": "Active",
                "centerid": 2,
                "created_by": null
            }
        ],
        "selectedRoom": {
            "id": 943387862,
            "name": "Room no 1",
            "capacity": 11,
            "userId": 91,
            "color": "#25cc20",
            "ageFrom": 0,
            "ageTo": 2,
            "status": "Active",
            "centerid": 2,
            "created_by": 1
        },
        "selectedDate": "2025-08-06",
        "children": [
            {
                "child": {
                    "id": 46,
                    "name": "Bikram",
                    "lastname": "Kesari",
                    "dob": "2015-01-14",
                    "startDate": "2022-02-14",
                    "room": 943387862,
                    "imageUrl": "uploads/olddata/child image1.jpeg",
                    "gender": "Male",
                    "status": "Active",
                    "daysAttending": "11111",
                    "centerid": 102,
                    "createdBy": 1,
                    "createdAt": "2025-08-02 19:29:04",
                    "created_at": "2025-08-02 19:28:00",
                    "updated_at": "2025-08-02 19:28:00"
                },
                "bottle": {
                    "id": 824,
                    "childid": 46,
                    "diarydate": "2025-08-06",
                    "startTime": "14:11",
                    "comments": null,
                    "createdBy": "1",
                    "createdAt": "2025-08-09 07:42:03",
                    "created_at": "2025-08-09 07:42:03",
                    "updated_at": "2025-08-09 07:42:03"
                },
                "toileting": {
                    "id": 13171,
                    "childid": 46,
                    "diarydate": "2025-08-06",
                    "startTime": "15:11",
                    "nappy": null,
                    "potty": null,
                    "toilet": null,
                    "signature": "test signature",
                    "comments": "test comment",
                    "status": "clean",
                    "createdBy": "1",
                    "createdAt": "2025-08-09 07:41:47",
                    "created_at": "2025-08-09 07:41:47",
                    "updated_at": "2025-08-09 07:41:47"
                },
                "sunscreen": {
                    "id": 649,
                    "childid": 46,
                    "diarydate": "2025-08-06",
                    "startTime": "14:10",
                    "comments": "test comment",
                    "signature": "test signature",
                    "createdBy": "1",
                    "createdAt": "2025-08-09 07:40:53",
                    "created_at": "2025-08-09 07:40:53",
                    "updated_at": "2025-08-09 07:40:53"
                },
                "snacks": {
                    "id": 775,
                    "childid": 46,
                    "diarydate": "2025-08-06",
                    "startTime": "14:10",
                    "item": "test item",
                    "comments": "test comment",
                    "createdBy": "1",
                    "createdAt": "2025-08-09 07:40:33",
                    "created_at": "2025-08-09T07:40:33.000000Z",
                    "updated_at": "2025-08-09T07:40:33.000000Z"
                },
                "afternoon_tea": {
                    "id": 3800,
                    "childid": 46,
                    "diarydate": "2025-08-06",
                    "startTime": "15:09",
                    "item": null,
                    "comments": "test comment",
                    "createdBy": "1",
                    "createdAt": "2025-08-09 07:40:07",
                    "created_at": "2025-08-09T07:40:07.000000Z",
                    "updated_at": "2025-08-09T07:40:07.000000Z"
                },
                "sleep": {
                    "id": 3336,
                    "childid": 46,
                    "diarydate": "2025-08-06",
                    "startTime": "15:09",
                    "endTime": "15:09",
                    "comments": "test comment",
                    "createdBy": "1",
                    "createdAt": "2025-08-09 07:39:31",
                    "created_at": "2025-08-09 07:39:31",
                    "updated_at": "2025-08-09 07:39:31"
                },
                "lunch": {
                    "id": 4624,
                    "childid": 46,
                    "diarydate": "2025-08-06",
                    "startTime": "15:08",
                    "item": "test item",
                    "comments": "comment item",
                    "createdBy": "1",
                    "createdAt": "2025-08-09 07:39:11",
                    "created_at": "2025-08-09T07:39:11.000000Z",
                    "updated_at": "2025-08-09T07:39:11.000000Z"
                },
                "morning_tea": {
                    "id": 5911,
                    "childid": 46,
                    "diarydate": "2025-08-06",
                    "startTime": "14:08",
                    "item": null,
                    "comments": "test comment",
                    "createdBy": "1",
                    "createdAt": "2025-08-09 07:38:05",
                    "created_at": "2025-08-09 07:38:05",
                    "updated_at": "2025-08-09 07:38:05"
                },
                "breakfast": {
                    "id": 926,
                    "childid": 46,
                    "diarydate": "2025-08-06",
                    "startTime": "14:06",
                    "item": "test item",
                    "comments": "test comment",
                    "createdBy": "1",
                    "createdAt": "2025-08-09 07:36:51",
                    "created_at": "2025-08-09 07:36:51",
                    "updated_at": "2025-08-09 07:36:51"
                }
            },
            {
                "child": {
                    "id": 47,
                    "name": "Sinzo ",
                    "lastname": "Suzukai",
                    "dob": "2017-06-15",
                    "startDate": "2022-02-14",
                    "room": 943387862,
                    "imageUrl": "uploads/olddata/japani child.jpeg",
                    "gender": "Male",
                    "status": "Active",
                    "daysAttending": "11111",
                    "centerid": 102,
                    "createdBy": 1,
                    "createdAt": "2025-08-02 19:29:04",
                    "created_at": "2025-08-02 19:28:00",
                    "updated_at": "2025-08-02 19:28:00"
                },
                "bottle": null,
                "toileting": null,
                "sunscreen": null,
                "snacks": null,
                "afternoon_tea": null,
                "sleep": null,
                "lunch": null,
                "morning_tea": null,
                "breakfast": null
            },
            {
                "child": {
                    "id": 48,
                    "name": "Donal",
                    "lastname": "Duker",
                    "dob": "2014-06-13",
                    "startDate": "2022-02-14",
                    "room": 943387862,
                    "imageUrl": "uploads/olddata/Child 2.jpeg",
                    "gender": "Female",
                    "status": "Active",
                    "daysAttending": "11111",
                    "centerid": 102,
                    "createdBy": 1,
                    "createdAt": "2025-08-02 19:29:04",
                    "created_at": "2025-08-02 19:28:00",
                    "updated_at": "2025-08-02 19:28:00"
                },
                "bottle": null,
                "toileting": null,
                "sunscreen": null,
                "snacks": null,
                "afternoon_tea": null,
                "sleep": null,
                "lunch": null,
                "morning_tea": null,
                "breakfast": null
            }
        ]
    }
};

  // Future<List<ChildModel>> getChildren()async {
  //   return [
  //     ChildModel(
  //       id: '4',
  //       name: 'Julien Khan',
  //       age: 7,
  //       avatarPath: 'assets/images/Julien.jpg',
  //       activities: _mockActivities(),
  //     ),
  //     ChildModel(
  //       id: '5',
  //       name: 'Maxy Den',
  //       age: 7,
  //       avatarPath: 'assets/images/Maxy.jpg',
  //       activities: _mockActivities(),
  //     ),
  //     ChildModel(
  //       id: '6',
  //       name: 'Nayra Muzzen',
  //       age: 7,
  //       avatarPath: 'assets/images/Nayra.jpg',
  //       activities: _mockActivities(),
  //     ),
  //     ChildModel(
  //       id: '7',
  //       name: 'Samyon Johan',
  //       age: 7,
  //       avatarPath: 'assets/images/Samyon.jpg',
  //       activities: _mockActivities(),
  //     ),
  //   ];
  // }

  // Future<void> saveActivity(List<String> childIds, ActivityModel activity) async {
  //   // Simulate API call
  //   await Future.delayed(const Duration(seconds: 1));
  //   // Mock success
  // }

  // List<ActivityModel> _mockActivities() {
  //   return [
  //     ActivityModel(type: 'breakfast', date: DateTime.now(), comments: 'Not-Update', status: 'Not Update', time: 'Not-Update', item: 'Not-Update'),
  //     ActivityModel(type: 'morning-tea', date: DateTime.now(), comments: 'Not-Update', status: 'Not Update', time: 'Not-Update'),
  //     ActivityModel(type: 'lunch', date: DateTime.now(), comments: 'Not-Update', status: 'In Progress', time: 'Not-Update', item: 'Not-Update'),
  //     ActivityModel(type: 'sleep', date: DateTime.now(), comments: 'Not-Update', status: '0 Entries', sleepTime: 'Not-Update', wakeTime: 'Not-Update'),
  //     ActivityModel(type: 'afternoon-tea', date: DateTime.now(), comments: 'Not-Update', status: 'Pending', time: 'Not-Update'),
  //     ActivityModel(type: 'snacks', date: DateTime.now(), comments: 'Not-Update', status: 'Pending', time: 'Not-Update', item: 'Not-Update'),
  //     ActivityModel(type: 'sunscreen', date: DateTime.now(), comments: 'Not-Update', status: '0 Applications', time: 'Not-Update'),
  //     ActivityModel(type: 'toileting', date: DateTime.now(), comments: 'Not-Update', status: 'Not Update', time: 'Not-Update'),
  //     ActivityModel(type: 'bottle', date: DateTime.now(), comments: 'Not-Update', status: 'Pending', time: 'Not-Update'),
  //   ];
  // }
}