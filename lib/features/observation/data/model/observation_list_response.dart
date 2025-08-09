import 'package:mydiaree/features/observation/data/model/add_new_observation_response.dart';

class ObservationListResponse {
  final bool success;
  final List<ObservationListItem> observations;
  final List<Center> centers;

  ObservationListResponse({
    required this.success,
    required this.observations,
    required this.centers,
  });

  factory ObservationListResponse.fromJson(Map<String, dynamic> json) {
    return ObservationListResponse(
      success: json['success'] ?? false,
      observations: (json['observations'] as List?)
          ?.map((e) => ObservationListItem.fromJson(e))
          .where((obs) => obs.id > 0) // Filter out incomplete items
          .toList() ?? [],
      centers: (json['centers'] as List?)
          ?.map((e) => Center.fromJson(e))
          .toList() ?? [],
    );
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
    required this.id,
    required this.userId,
    required this.obestitle,
    required this.title,
    required this.notes,
    required this.room,
    required this.reflection,
    required this.futurePlan,
    required this.childVoice,
    required this.status,
    this.approver,
    required this.centerId,
    required this.dateAdded,
    this.dateModified,
    required this.createdAt,
    required this.updatedAt,
    required this.user,
    required this.children,
    required this.media,
  });

  factory ObservationListItem.fromJson(Map<String, dynamic> json) {
    if (json['seen'] != null && json['id'] == null) {
      // This is an incomplete item, return with default id 0
      return ObservationListItem(
        id: 0,
        userId: 0,
        obestitle: '',
        title: '',
        notes: '',
        room: null,
        reflection: '',
        futurePlan: null,
        childVoice: null,
        status: '',
        approver: null,
        centerId: 0,
        dateAdded: '',
        dateModified: null,
        createdAt: '',
        updatedAt: '',
        user: User.fromJson({}),
        children: [],
        media: [],
      );
    }
    
    return ObservationListItem(
      id: json['id'] ?? 0,
      userId: json['userId'] ?? 0,
      obestitle: json['obestitle'] ?? '',
      title: json['title'] ?? '',
      notes: json['notes'] ?? '',
      room: json['room'],
      reflection: json['reflection'] ?? '',
      futurePlan: json['future_plan'],
      childVoice: json['child_voice'],
      status: json['status'] ?? '',
      approver: json['approver'],
      centerId: json['centerid'] ?? 0,
      dateAdded: json['date_added'] ?? '',
      dateModified: json['date_modified'],
      createdAt: json['created_at'] ?? '',
      updatedAt: json['updated_at'] ?? '',
      user: User.fromJson(json['user'] ?? {}),
      children: (json['child'] as List?)
          ?.map((e) => ChildObservation.fromJson(e))
          .toList() ?? [],
      media: (json['media'] as List?)
          ?.map((e) => Media.fromJson(e))
          .toList() ?? [],
    );
  }

  // Helper method to get clean title
  String get cleanTitle {
    return stripHtmlTags(title);
  }

  // Helper method to get preview image
  String get previewImage {
    if (media.isNotEmpty) {
      return media.first.mediaUrl;
    }
    return '';
  }
}

class User {
  final int id;
  final String name;
  final String imageUrl;

  User({
    required this.id,
    required this.name,
    required this.imageUrl,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'] ?? 0,
      name: json['name'] ?? '',
      imageUrl: json['imageUrl'] ?? '',
    );
  }
}

class ChildObservation {
  final int id;
  final int observationId;
  final int childId;

  ChildObservation({
    required this.id,
    required this.observationId,
    required this.childId,
  });

  factory ChildObservation.fromJson(Map<String, dynamic> json) {
    return ChildObservation(
      id: json['id'] ?? 0,
      observationId: json['observationId'] ?? 0,
      childId: json['childId'] ?? 0,
    );
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
    required this.id,
    required this.observationId,
    required this.mediaUrl,
    required this.mediaType,
    this.caption,
    this.priority,
  });

  factory Media.fromJson(Map<String, dynamic> json) {
    return Media(
      id: json['id'] ?? 0,
      observationId: json['observationId'] ?? 0,
      mediaUrl: json['mediaUrl'] ?? '',
      mediaType: json['mediaType'] ?? '',
      caption: json['caption'],
      priority: json['priority'],
    );
  }
}

// Helper function to strip HTML tags
String stripHtmlTags(String htmlString) {
  if (htmlString.isEmpty) return '';
  
  // Remove HTML tags and clean up the string
  return htmlString
      .replaceAll(RegExp(r'<[^>]*>'), '') // Remove all HTML tags
      .replaceAll('&lt;', '<')  // Replace HTML entities
      .replaceAll('&gt;', '>')
      .replaceAll('&amp;', '&')
      .replaceAll('\n', ' ')  // Replace newlines with spaces
      .trim();  // Remove extra whitespace
}