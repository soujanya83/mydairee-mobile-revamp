import 'package:mydiaree/features/observation/data/model/add_new_observation_response.dart';

class ObservationListResponse {
  final bool success;
  final List<ObservationListItem> observations;
  final List<Center> centers;

  ObservationListResponse({
    this.success = false,
    List<ObservationListItem>? observations,
    List<Center>? centers,
  })  : observations = observations ?? [],
        centers = centers ?? [];

  factory ObservationListResponse.fromJson(Map<String, dynamic>? json) {
    try {
      // parse success (bool, int or String)
      final rawSuccess = json?['success'];
      bool success = false;
      if (rawSuccess is bool) {
        success = rawSuccess;
      } else if (rawSuccess is num) {
        success = rawSuccess.toInt() == 1;
      } else if (rawSuccess is String) {
        success = rawSuccess.toLowerCase() == 'true' || rawSuccess == '1';
      }

      // parse observations list (nested under observations.data)
      final obsList = <ObservationListItem>[];
      final rawObs = json?['observations'];
      final dataJson = rawObs is Map<String, dynamic> ? rawObs['data'] : rawObs;
      if (dataJson is List) {
        for (var item in dataJson) {
          if (item is Map<String, dynamic>) {
            obsList.add(ObservationListItem.fromJson(item));
          }
        }
      }

      // parse centers list
      final centerList = <Center>[];
      final centerJson = json?['centers'];
      if (centerJson is List) {
        for (var item in centerJson) {
          if (item is Map<String, dynamic>) {
            centerList.add(Center.fromJson(item));
          }
        }
      }

      return ObservationListResponse(
        success: success,
        observations: obsList,
        centers: centerList,
      );
    } catch (_) {
      return ObservationListResponse();
    }
  }
}

class ObservationListItem {
  final int id;
  final int userId;
  final String obestitle;
  final String title;
  final String notes;
  final String? room;
  final String reflection;
  final String? futurePlan;
  final String? childVoice;
  final String status;
  final int? approver;
  final int centerId;
  final String dateAdded;
  final String? dateModified;
  final String createdAt;
  final String updatedAt;
  final User user;
  final List<ChildObservation> children;
  final List<Media> media;

  ObservationListItem({
    this.id = 0,
    this.userId = 0,
    this.obestitle = '',
    this.title = '',
    this.notes = '',
    this.room,
    this.reflection = '',
    this.futurePlan,
    this.childVoice,
    this.status = '',
    this.approver,
    this.centerId = 0,
    this.dateAdded = '',
    this.dateModified,
    this.createdAt = '',
    this.updatedAt = '',
    User? user,
    List<ChildObservation>? children,
    List<Media>? media,
  })  : user = user ?? User(),
        children = children ?? [],
        media = media ?? [];

  factory ObservationListItem.fromJson(Map<String, dynamic>? json) {
    try {
      if (json == null) return ObservationListItem();

      final id = int.tryParse(json['id']?.toString() ?? '') ?? 0;
      final userId = int.tryParse(json['userId']?.toString() ?? '') ?? 0;
      final obestitle = json['obestitle']?.toString() ?? '';
      final title = json['title']?.toString() ?? '';
      final notes = json['notes']?.toString() ?? '';
      final room = json['room']?.toString();
      final reflection = json['reflection']?.toString() ?? '';
      final futurePlan = json['future_plan']?.toString();
      final childVoice = json['child_voice']?.toString();
      final status = json['status']?.toString() ?? '';
      final approver = int.tryParse(json['approver']?.toString() ?? '');
      final centerId = int.tryParse(json['centerid']?.toString() ?? '') ?? 0;
      final dateAdded = json['date_added']?.toString() ?? '';
      final dateModified = json['date_modified']?.toString();
      final createdAt = json['created_at']?.toString() ?? '';
      final updatedAt = json['updated_at']?.toString() ?? '';

      // parse nested user object
      final userJson = json['user'];
      final user = userJson is Map<String, dynamic>
          ? User.fromJson(userJson)
          : User();

      // parse child list
      final childList = <ChildObservation>[];
      final childJson = json['child'];
      if (childJson is List) {
        for (var c in childJson) {
          if (c is Map<String, dynamic>) {
            childList.add(ChildObservation.fromJson(c));
          }
        }
      }

      // parse media list
      final mediaList = <Media>[];
      final mediaJson = json['media'];
      if (mediaJson is List) {
        for (var m in mediaJson) {
          if (m is Map<String, dynamic>) {
            mediaList.add(Media.fromJson(m));
          }
        }
      }

      return ObservationListItem(
        id: id,
        userId: userId,
        obestitle: obestitle,
        title: title,
        notes: notes,
        room: room,
        reflection: reflection,
        futurePlan: futurePlan,
        childVoice: childVoice,
        status: status,
        approver: approver,
        centerId: centerId,
        dateAdded: dateAdded,
        dateModified: dateModified,
        createdAt: createdAt,
        updatedAt: updatedAt,
        user: user,
        children: childList,
        media: mediaList,
      );
    } catch (_) {
      return ObservationListItem();
    }
  }

  /// Helper to strip HTML tags/entities for display
  String get cleanTitle => stripHtmlTags(title);

  /// Preview image URL from first media item
  String get previewImage => media.isNotEmpty ? media.first.mediaUrl : '';
}

class User {
  final int id;
  final String name;
  final String imageUrl;

  User({
    this.id = 0,
    this.name = '',
    this.imageUrl = '',
  });

  factory User.fromJson(Map<String, dynamic>? json) {
    try {
      final id = int.tryParse(json?['id']?.toString() ?? '') ?? 0;
      final name = json?['name']?.toString() ?? '';
      final imageUrl = json?['imageUrl']?.toString() ?? '';
      return User(id: id, name: name, imageUrl: imageUrl);
    } catch (_) {
      return User();
    }
  }
}

class ChildObservation {
  final int id;
  final int observationId;
  final int childId;

  ChildObservation({
    this.id = 0,
    this.observationId = 0,
    this.childId = 0,
  });

  factory ChildObservation.fromJson(Map<String, dynamic>? json) {
    try {
      final id = int.tryParse(json?['id']?.toString() ?? '') ?? 0;
      final observationId =
          int.tryParse(json?['observationId']?.toString() ?? '') ?? 0;
      final childId =
          int.tryParse(json?['childId']?.toString() ?? '') ?? 0;
      return ChildObservation(
        id: id,
        observationId: observationId,
        childId: childId,
      );
    } catch (_) {
      return ChildObservation();
    }
  }
}

class Media {
  final int id;
  final int observationId;
  final String mediaUrl;
  final String mediaType;
  final String? caption;
  final dynamic priority;

  Media({
    this.id = 0,
    this.observationId = 0,
    this.mediaUrl = '',
    this.mediaType = '',
    this.caption,
    this.priority,
  });

  factory Media.fromJson(Map<String, dynamic>? json) {
    try {
      final id = int.tryParse(json?['id']?.toString() ?? '') ?? 0;
      final observationId =
          int.tryParse(json?['observationId']?.toString() ?? '') ?? 0;
      final mediaUrl = json?['mediaUrl']?.toString() ?? '';
      final mediaType = json?['mediaType']?.toString() ?? '';
      final caption = json?['caption']?.toString();
      final rawPriority = json?['priority'];
      dynamic priority;
      if (rawPriority is num) {
        priority = rawPriority;
      } else if (rawPriority is String) {
        priority = int.tryParse(rawPriority) ?? rawPriority;
      } else {
        priority = rawPriority;
      }
      return Media(
        id: id,
        observationId: observationId,
        mediaUrl: mediaUrl,
        mediaType: mediaType,
        caption: caption,
        priority: priority,
      );
    } catch (_) {
      return Media();
    }
  }
}

String stripHtmlTags(String htmlString) {
  if (htmlString.isEmpty) return '';
  return htmlString
      .replaceAll(RegExp(r'<[^>]*>'), '')
      .replaceAll('&lt;', '<')
      .replaceAll('&gt;', '>')
      .replaceAll('&amp;', '&')
      .replaceAll('\n', ' ')
      .trim();
}