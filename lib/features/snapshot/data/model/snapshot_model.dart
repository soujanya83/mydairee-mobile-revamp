// filepath: f:/Flutter [snapshot_model.dart](http://_vscodecontentref_/0)
import 'package:equatable/equatable.dart';
import 'package:mydiaree/core/config/app_urls.dart';

// Top-level response
class SnapshotsResponse {
  final bool status;
  final String message;
  final List<SnapshotModel> snapshots;

  SnapshotsResponse({
    required this.status,
    required this.message,
    required this.snapshots,
  });

  factory SnapshotsResponse.fromJson(Map<String, dynamic> json) {
    return SnapshotsResponse(
      status: json['status'] as bool? ?? false,
      message: json['message'] as String? ?? '',
      snapshots: (json['snapshots'] as List<dynamic>? ?? [])
          .map((e) => SnapshotModel.fromJson(e as Map<String, dynamic>))
          .toList(),
    );
  }
}

class SnapshotModel extends Equatable {
  final int id;
  final String title;
  final String about;
  final String roomids;
  final int createdBy;
  final int centerid;
  final String status;
  final String createdAt;
  final String updatedAt;
  final List<SnapshotRoom> rooms;
  final List<SnapshotChild> children;
  final List<SnapshotMedia> media;
  final SnapshotCreator? creator;
  final SnapshotCenter? center;

  const SnapshotModel({
    required this.id,
    required this.title,
    required this.about,
    required this.roomids,
    required this.createdBy,
    required this.centerid,
    required this.status,
    required this.createdAt,
    required this.updatedAt,
    required this.rooms,
    required this.children,
    required this.media,
    this.creator,
    this.center,
  });

  factory SnapshotModel.fromJson(Map<String, dynamic> json) {
    return SnapshotModel(
      id: json['id'] as int,
      title: json['title'] as String? ?? '',
      about: json['about'] as String? ?? '',
      roomids: json['roomids'] as String? ?? '',
      createdBy: json['createdBy'] as int? ?? 0,
      centerid: json['centerid'] as int? ?? 0,
      status: json['status'] as String? ?? '',
      createdAt: json['created_at'] as String? ?? '',
      updatedAt: json['updated_at'] as String? ?? '',
      rooms: (json['rooms'] as List<dynamic>? ?? [])
          .map((e) => SnapshotRoom.fromJson(e as Map<String, dynamic>))
          .toList(),
      children: (json['children'] as List<dynamic>? ?? [])
          .map((e) => SnapshotChild.fromJson(e as Map<String, dynamic>))
          .toList(),
      media: (json['media'] as List<dynamic>? ?? [])
          .map((e) => SnapshotMedia.fromJson(e as Map<String, dynamic>))
          .toList(),
      creator: json['creator'] != null
          ? SnapshotCreator.fromJson(json['creator'] as Map<String, dynamic>)
          : null,
      center: json['center'] != null
          ? SnapshotCenter.fromJson(json['center'] as Map<String, dynamic>)
          : null,
    );
  }

  @override
  List<Object?> get props => [
        id,
        title,
        about,
        roomids,
        createdBy,
        centerid,
        status,
        createdAt,
        updatedAt,
        rooms,
        children,
        media,
        creator,
        center,
      ];
}

class SnapshotRoom extends Equatable {
  final int id;
  final String name;

  const SnapshotRoom({
    required this.id,
    required this.name,
  });

  factory SnapshotRoom.fromJson(Map<String, dynamic> json) {
    return SnapshotRoom(
      id: json['id'] as int,
      name: json['name'] as String? ?? '',
    );
  }

  @override
  List<Object?> get props => [id, name];
}

class SnapshotChild extends Equatable {
  final int id;
  final int snapshotid;
  final int childid;
  final SnapshotChildDetail child;

  const SnapshotChild({
    required this.id,
    required this.snapshotid,
    required this.childid,
    required this.child,
  });

  factory SnapshotChild.fromJson(Map<String, dynamic> json) {
    return SnapshotChild(
      id: json['id'] as int,
      snapshotid: json['snapshotid'] as int,
      childid: json['childid'] as int,
      child: SnapshotChildDetail.fromJson(json['child'] as Map<String, dynamic>),
    );
  }

  @override
  List<Object?> get props => [id, snapshotid, childid, child];
}

class SnapshotChildDetail extends Equatable {
  final int id;
  final String name;
  final String lastname;
  final String imageUrl;

  const SnapshotChildDetail({
    required this.id,
    required this.name,
    required this.lastname,
    required this.imageUrl,
  });

  factory SnapshotChildDetail.fromJson(Map<String, dynamic> json) {
    final raw = json['imageUrl'] as String? ?? '';
    final avatar = raw.startsWith('http') ? raw : '${AppUrls.baseUrl}/$raw';
    return SnapshotChildDetail(
      id: json['id'] as int,
      name: json['name'] as String? ?? '',
      lastname: json['lastname'] as String? ?? '',
      imageUrl: avatar,
    );
  }

  @override
  List<Object?> get props => [id, name, lastname, imageUrl];
}

class SnapshotMedia extends Equatable {
  final int id;
  final int snapshotid;
  final String mediaUrl;
  final String mediaType;

  const SnapshotMedia({
    required this.id,
    required this.snapshotid,
    required this.mediaUrl,
    required this.mediaType,
  });

  factory SnapshotMedia.fromJson(Map<String, dynamic> json) {
    final raw = json['mediaUrl'] as String? ?? '';
    final url = raw.startsWith('http') ? raw : '${AppUrls.baseUrl}/$raw';
    return SnapshotMedia(
      id: json['id'] as int,
      snapshotid: json['snapshotid'] as int,
      mediaUrl: url,
      mediaType: json['mediaType'] as String? ?? '',
    );
  }

  @override
  List<Object?> get props => [id, snapshotid, mediaUrl, mediaType];
}

class SnapshotCreator extends Equatable {
  final int id;
  final String name;
  final String email;
  final String? imageUrl;

  const SnapshotCreator({
    required this.id,
    required this.name,
    required this.email,
    this.imageUrl,
  });

  factory SnapshotCreator.fromJson(Map<String, dynamic> json) {
    final raw = json['imageUrl'] as String? ?? '';
    final avatar = raw.startsWith('http') ? raw : '${AppUrls.baseUrl}/$raw';
    return SnapshotCreator(
      id: json['id'] as int,
      name: json['name'] as String? ?? '',
      email: json['email'] as String? ?? '',
      imageUrl: avatar,
    );
  }

  @override
  List<Object?> get props => [id, name, email, imageUrl];
}

class SnapshotCenter extends Equatable {
  final int id;
  final String centerName;

  const SnapshotCenter({
    required this.id,
    required this.centerName,
  });

  factory SnapshotCenter.fromJson(Map<String, dynamic> json) {
    return SnapshotCenter(
      id: json['id'] as int,
      centerName: json['centerName'] as String? ?? '',
    );
  }

  @override
  List<Object?> get props => [id, centerName];
}