import 'package:mydiaree/core/config/app_colors.dart';

class RoomListModel {
  final List<RoomItem> rooms;

  RoomListModel({
    required this.rooms,
  });

  factory RoomListModel.fromJson(Map<String, dynamic> json) {
    return RoomListModel(
      rooms: (json['rooms'] as List)
          .map((roomJson) => RoomItem.fromJson(roomJson))
          .toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'rooms': rooms.map((room) => room.toJson()).toList(),
    };
  }
}

class RoomItem {
  final String id;
  final String name;
  final int capacity;
  final int ageFrom;
  final int ageTo;
  final String status;
  final int color;
  final List<String> educatorIds;
  final String userName;

  RoomItem({
    required this.id,
    required this.name,
    required this.capacity,
    required this.ageFrom,
    required this.ageTo,
    required this.status,
    required this.color,
    required this.educatorIds,
    required this.userName,
  });

  factory RoomItem.fromJson(Map<String, dynamic> json) {
    // Convert hex color string to integer if needed
    final colorValue = json['color'] is String
        ? int.tryParse(json['color'].replaceFirst('#', '0xff')) ??
            AppColors.primaryColor.value
        : json['color'] ?? AppColors.primaryColor.value;

    return RoomItem(
      id: json['id'] ?? '',
      name: json['name'] ?? '',
      capacity: json['capacity'] ?? 0,
      ageFrom: json['ageFrom'] ?? 0,
      ageTo: json['ageTo'] ?? 0,
      status: json['status'] ?? 'Active',
      color: colorValue,
      educatorIds: (json['educatorIds'] as List?)?.cast<String>() ?? [],
      userName: json['userName'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'capacity': capacity,
      'ageFrom': ageFrom,
      'ageTo': ageTo,
      'status': status,
      'color': color,
      'educatorIds': educatorIds,
      'userName': userName,
    };
  }
}
