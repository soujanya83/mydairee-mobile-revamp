import 'package:equatable/equatable.dart'; 

class ChildModel extends Equatable {
  final String id;
  final String name;
  final int age;
  final String avatarPath;
  final List<ActivityModel> activities;

  const ChildModel({
    required this.id,
    required this.name,
    required this.age,
    required this.avatarPath,
    required this.activities,
  });

  @override
  List<Object> get props => [id, name, age, avatarPath, activities];
}
 

class ActivityModel extends Equatable {
  final String type;
  final DateTime? date;
  final String? time;
  final String? item;
  final String? sleepTime;
  final String? wakeTime;
  final String? status;
  final String comments;
  final String? signature;

  const ActivityModel({
    required this.type,
      this.date,
    this.time,
    this.item,
    this.sleepTime,
    this.wakeTime,
    this.status,
    required this.comments,
    this.signature,
  });

  @override
  List<Object?> get props => [type, date, time, item, sleepTime, wakeTime, status, comments, signature];
}