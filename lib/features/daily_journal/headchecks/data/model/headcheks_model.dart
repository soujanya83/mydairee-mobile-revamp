import 'package:equatable/equatable.dart';

class HeadCheckModel   {
  final String? id;
  final String roomId;
  final String diaryDate;
  final String time;
  final String headCount;
  final String signature;
  final String comments;
  final String createdBy;
  final String createdAt;

  const HeadCheckModel({
    this.id,
    required this.roomId,
    required this.diaryDate,
    required this.time,
    required this.headCount,
    required this.signature,
    required this.comments,
    required this.createdBy,
    required this.createdAt,
  });

  // Add this to your HeadCheckModel class
HeadCheckModel copyWith({
  String? id,
  String? roomId,
  String? diaryDate,
  String? time,
  String? headCount,
  String? signature,
  String? comments,
  String? createdBy,
  String? createdAt,
}) {
  return HeadCheckModel(
    id: id ?? this.id,
    roomId: roomId ?? this.roomId,
    diaryDate: diaryDate ?? this.diaryDate,
    time: time ?? this.time,
    headCount: headCount ?? this.headCount,
    signature: signature ?? this.signature,
    comments: comments ?? this.comments,
    createdBy: createdBy ?? this.createdBy,
    createdAt: createdAt ?? this.createdAt,
  );
}

  factory HeadCheckModel.fromJson(Map<String, dynamic> json) {
    return HeadCheckModel(
      id: json['id']?.toString(),
      roomId: json['roomid'].toString(),
      diaryDate: json['diarydate'].toString(),
      time: json['time'].toString(),
      headCount: json['headcount'].toString(),
      signature: json['signature'].toString(),
      comments: json['comments'].toString(),
      createdBy: json['createdBy'].toString(),
      createdAt: json['createdAt'].toString(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      if (id != null) 'id': id,
      'roomid': roomId,
      'diarydate': diaryDate,
      'time': time,
      'headcount': headCount,
      'signature': signature,
      'comments': comments,
      'createdBy': createdBy,
      'createdAt': createdAt,
    };
  }

  @override
  List<Object?> get props => [
        id,
        roomId,
        diaryDate,
        time,
        headCount,
        signature,
        comments,
        createdBy,
        createdAt,
      ];
}

class HeadCheckListModel extends Equatable {
  final List<HeadCheckModel> headChecks;
  final List<Map<String, dynamic>> rooms;

  const HeadCheckListModel({
    required this.headChecks,
    required this.rooms,
  });

  factory HeadCheckListModel.fromJson(Map<String, dynamic> json) {
    return HeadCheckListModel(
      headChecks: (json['headChecks'] as List<dynamic>?)
              ?.map((item) => HeadCheckModel.fromJson(item as Map<String, dynamic>))
              .toList() ??
          [],
      rooms: (json['rooms'] as List<dynamic>?)?.cast<Map<String, dynamic>>() ?? [],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'headChecks': headChecks.map((check) => check.toJson()).toList(),
      'rooms': rooms,
    };
  }

  @override
  List<Object> get props => [headChecks, rooms];
}

// Dummy data for HeadCheckListModel
final dummyHeadCheckListData = {
  'headChecks': [
    {
      'id': '1',
      'roomid': '1',
      'diarydate': '04-07-2025',
      'time': '10:30',
      'headcount': '15',
      'signature': 'John Doe',
      'comments': 'All children present',
      'createdBy': 'educator1',
      'createdAt': '2025-07-04T10:30:00Z',
    },
    {
      'id': '2',
      'roomid': '1',
      'diarydate': '04-07-2025',
      'time': '11:00',
      'headcount': '14',
      'signature': 'John Doe',
      'comments': 'One child absent',
      'createdBy': 'educator1',
      'createdAt': '2025-07-04T11:00:00Z',
    },
  ],
  'rooms': [
    {
      'id': '1',
      'name': 'Room A',
    },
    {
      'id': '2',
      'name': 'Room B',
    },
  ],
};