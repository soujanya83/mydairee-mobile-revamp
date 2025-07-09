import 'package:mydiaree/features/daily_journal/daily_diaree/data/model/child_model.dart';

class DailyTrackingRepository {
  Future<List<ChildModel>> getChildren() async {
    // Mock data
    return [
      ChildModel(
        id: '4',
        name: 'Julien Khan',
        age: 7,
        avatarPath: 'assets/images/Julien.jpg',
        activities: _mockActivities(),
      ),
      ChildModel(
        id: '5',
        name: 'Maxy Den',
        age: 7,
        avatarPath: 'assets/images/Maxy.jpg',
        activities: _mockActivities(),
      ),
      ChildModel(
        id: '6',
        name: 'Nayra Muzzen',
        age: 7,
        avatarPath: 'assets/images/Nayra.jpg',
        activities: _mockActivities(),
      ),
      ChildModel(
        id: '7',
        name: 'Samyon Johan',
        age: 7,
        avatarPath: 'assets/images/Samyon.jpg',
        activities: _mockActivities(),
      ),
    ];
  }

  Future<void> saveActivity(List<String> childIds, ActivityModel activity) async {
    // Simulate API call
    await Future.delayed(const Duration(seconds: 1));
    // Mock success
  }

  List<ActivityModel> _mockActivities() {
    return [
      ActivityModel(type: 'breakfast', date: DateTime.now(), comments: 'Not-Update', status: 'Not Update', time: 'Not-Update', item: 'Not-Update'),
      ActivityModel(type: 'morning-tea', date: DateTime.now(), comments: 'Not-Update', status: 'Not Update', time: 'Not-Update'),
      ActivityModel(type: 'lunch', date: DateTime.now(), comments: 'Not-Update', status: 'In Progress', time: 'Not-Update', item: 'Not-Update'),
      ActivityModel(type: 'sleep', date: DateTime.now(), comments: 'Not-Update', status: '0 Entries', sleepTime: 'Not-Update', wakeTime: 'Not-Update'),
      ActivityModel(type: 'afternoon-tea', date: DateTime.now(), comments: 'Not-Update', status: 'Pending', time: 'Not-Update'),
      ActivityModel(type: 'snacks', date: DateTime.now(), comments: 'Not-Update', status: 'Pending', time: 'Not-Update', item: 'Not-Update'),
      ActivityModel(type: 'sunscreen', date: DateTime.now(), comments: 'Not-Update', status: '0 Applications', time: 'Not-Update'),
      ActivityModel(type: 'toileting', date: DateTime.now(), comments: 'Not-Update', status: 'Not Update', time: 'Not-Update'),
      ActivityModel(type: 'bottle', date: DateTime.now(), comments: 'Not-Update', status: 'Pending', time: 'Not-Update'),
    ];
  }
}