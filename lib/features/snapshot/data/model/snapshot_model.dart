// filepath: f:/Flutter [snapshot_model.dart](http://_vscodecontentref_/0)
import 'package:equatable/equatable.dart';
import 'package:mydiaree/core/config/app_urls.dart';

class SnapshotModel extends Equatable {
  final int id;
  final String title;
  final String status;
  final List<String> images;
  final String details;
  final List<Child> children;
  final List<SnapshotRoom> rooms;   // changed

  const SnapshotModel({
    required this.id,
    required this.title,
    required this.status,
    required this.images,
    required this.details,
    required this.children,
    required this.rooms,
  });

  factory SnapshotModel.fromJson(Map<String, dynamic> json) {
    final childrenJson = (json['children'] as List<dynamic>?) ?? [];
    final mediaJson    = (json['media']    as List<dynamic>?) ?? [];
    final roomsJson    = (json['rooms']    as List<dynamic>?) ?? [];

    return SnapshotModel(
      id:      json['id']     as int,
      title:   json['title']  as String?  ?? '',
      status:  json['status'] as String?  ?? '',
      details: json['about']  as String?  ?? '',
      images: mediaJson.map((m) => (m as Map<String, dynamic>)['mediaUrl'] as String).toList(),
      children: childrenJson
        .map((c) => Child.fromJson((c as Map<String, dynamic>)['child'] as Map<String, dynamic>))
        .toList(),
      rooms: roomsJson
        .map((r) => SnapshotRoom.fromJson(r as Map<String, dynamic>))
        .toList(),
    );
  }

  @override
  List<Object?> get props => [id, title, status, images, details, children, rooms];
}

class SnapshotRoom extends Equatable {
  final int    id;
  final String name;

  const SnapshotRoom({
    required this.id,
    required this.name,
  });

  factory SnapshotRoom.fromJson(Map<String, dynamic> json) {
    return SnapshotRoom(
      id:   json['id']   as int,
      name: json['name'] as String? ?? '',
    );
  }

  @override
  List<Object?> get props => [id, name];
}

class Child extends Equatable {
  final int    id;
  final String name;
  final String avatarUrl;

  const Child({
    required this.id,
    required this.name,
    required this.avatarUrl,
  });

  factory Child.fromJson(Map<String, dynamic> json) {
    final raw = json['imageUrl'] as String? ?? '';
    final avatar = raw.startsWith('http')
      ? raw
      : '${AppUrls.baseUrl}/$raw';
    return Child(
      id:        json['id']   as int,
      name:      json['name'] as String? ?? '',
      avatarUrl: avatar,
    );
  }

  @override
  List<Object?> get props => [id, name, avatarUrl];
}