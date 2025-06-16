class RoomListModel {
  final List<RoomItem> rooms;
  final List<CenterItem> centers;

  RoomListModel({
    required this.rooms,
    required this.centers,
  });

  factory RoomListModel.fromJson(Map<String, dynamic> json) {
    return RoomListModel(
      rooms: (json['rooms'] as List)
          .map((roomJson) => RoomItem.fromJson(roomJson))
          .toList(),
      centers: (json['centers'] as List)
          .map((centerJson) => CenterItem.fromJson(centerJson))
          .toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'rooms': rooms.map((room) => room.toJson()).toList(),
      'centers': centers.map((center) => center.toJson()).toList(),
    };
  }
}

class RoomItem {
  final String id;
  final String name;
  final String color;
  final String userName;
  final String status;
  final List<ChildItem> children;

  RoomItem({
    required this.id,
    required this.name,
    required this.color,
    required this.userName,
    required this.status,
    required this.children,
  });

  factory RoomItem.fromJson(Map<String, dynamic> json) {
    return RoomItem(
      id: json['id'] ?? '',
      name: json['name'] ?? '',
      color: json['color'] ?? '#FFFFFF',
      userName: json['userName'] ?? '',
      status: json['status'] ?? 'Active',
      children: (json['child'] as List?)
          ?.map((childJson) => ChildItem.fromJson(childJson))
          .toList() ?? [],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'color': color,
      'userName': userName,
      'status': status,
      'child': children.map((child) => child.toJson()).toList(),
    };
  }
}

class ChildItem {
  final String name;

  ChildItem({required this.name});

  factory ChildItem.fromJson(Map<String, dynamic> json) {
    return ChildItem(
      name: json['name'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
    };
  }
}

class CenterItem {
  final String id;
  final String centerName;

  CenterItem({
    required this.id,
    required this.centerName,
  });

  factory CenterItem.fromJson(Map<String, dynamic> json) {
    return CenterItem(
      id: json['id'] ?? '',
      centerName: json['centerName'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'centerName': centerName,
    };
  }
}