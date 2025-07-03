class SlipChecksChildListModel {
  final List<SlipChecksChildModel> children;

  SlipChecksChildListModel({required this.children});

  factory SlipChecksChildListModel.fromJson(List<dynamic> jsonList) {
    return SlipChecksChildListModel(
      children: jsonList
          .map((json) => SlipChecksChildModel.fromJson(json as Map<String, dynamic>))
          .toList(),
    );
  }

  List<Map<String, dynamic>> toJson() {
    return children.map((child) => child.toJson()).toList();
  }
}
class SlipChecksChildModel {
  final String id;
  final String name;
  final String lastname;
  final String dob;
  final String startDate;
  final String room;
  final String imageUrl;
  final String gender;
  final String status;
  final String daysAttending;
  final String createdBy;
  final String createdAt;
  final List<SleepCheckModel> sleepChecks;

  SlipChecksChildModel({
    required this.id,
    required this.name,
    required this.lastname,
    required this.dob,
    required this.startDate,
    required this.room,
    required this.imageUrl,
    required this.gender,
    required this.status,
    required this.daysAttending,
    required this.createdBy,
    required this.createdAt,
    required this.sleepChecks,
  });

  factory SlipChecksChildModel.fromJson(Map<String, dynamic> json) {
    var sleepChecksList = <SleepCheckModel>[];
    if (json['sleepChecks'] != null) {
      sleepChecksList = (json['sleepChecks'] as List)
          .map((e) => SleepCheckModel.fromJson(e))
          .toList();
    }

    return SlipChecksChildModel( 
      id: json['id'],
      name: json['name'],
      lastname: json['lastname'],
      dob: json['dob'],
      startDate: json['startDate'],
      room: json['room'],
      imageUrl: json['imageUrl'],
      gender: json['gender'],
      status: json['status'],
      daysAttending: json['daysAttending'],
      createdBy: json['createdBy'],
      createdAt: json['createdAt'],
      sleepChecks: sleepChecksList,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'lastname': lastname,
      'dob': dob,
      'startDate': startDate,
      'room': room,
      'imageUrl': imageUrl, 
      'gender': gender,
      'status': status,
      'daysAttending': daysAttending,
      'createdBy': createdBy,
      'createdAt': createdAt,
      'sleepChecks': sleepChecks.map((e) => e.toJson()).toList(),
    };
  }

  String get fullName => '$name $lastname';
}

class SleepCheckModel {
  String id;
  String childId;
  String roomId;
  String diaryDate;
  String time;
  String breathing;
  String bodyTemperature;
  String notes;
  String createdBy; 
  String createdAt;

  // New variables to track previous values
  String? previousBreathing;
  String? previousBodyTemperature;

  SleepCheckModel({
    required this.id,
    required this.childId,
    required this.roomId,
    required this.diaryDate,
    required this.time,
    required this.breathing,
    required this.bodyTemperature,
    required this.notes,
    required this.createdBy,
    required this.createdAt,
    this.previousBreathing,
    this.previousBodyTemperature,
  });

  factory SleepCheckModel.fromJson(Map<String, dynamic> json) {
    return SleepCheckModel(
      id: json['id'],
      childId: json['childId'],
      roomId: json['roomId'],
      diaryDate: json['diaryDate'],
      time: json['time'],
      breathing: json['breathing'],
      bodyTemperature: json['bodyTemperature'],
      notes: json['notes'],
      createdBy: json['createdBy'],
      createdAt: json['createdAt'],
      previousBreathing: json['previousBreathing'], // optional
      previousBodyTemperature: json['previousBodyTemperature'], // optional
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'childId': childId,
      'roomId': roomId,
      'diaryDate': diaryDate,
      'time': time,
      'breathing': breathing,
      'bodyTemperature': bodyTemperature,
      'notes': notes,
      'createdBy': createdBy,
      'createdAt': createdAt,
      'previousBreathing': previousBreathing,
      'previousBodyTemperature': previousBodyTemperature,
    };
  }

  /// Call this method before updating breathing/body temperature
  void trackChanges(String newBreathing, String newTemperature) {
    if (newBreathing != breathing) {
      previousBreathing = breathing;
    }
    if (newTemperature != bodyTemperature) {
      previousBodyTemperature = bodyTemperature;
    }
  }
}

