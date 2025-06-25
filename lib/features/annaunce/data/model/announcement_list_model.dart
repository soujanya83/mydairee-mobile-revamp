class AnnouncementListModel {
  final List<AnnouncementModel> announcements;

  AnnouncementListModel({
    required this.announcements,
  });

  factory AnnouncementListModel.fromJson(Map<String, dynamic> json) {
    return AnnouncementListModel(
      announcements: (json['announcements'] as List)
          .map((e) => AnnouncementModel.fromJson(e))
          .toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'announcements': announcements.map((e) => e.toJson()).toList(),
    };
  }
}

class AnnouncementModel {
  String id;
  String title;
  String text;
  String eventDate;
  String status;
  String createdBy;
  String createdAt;
  String aid;

  AnnouncementModel({
    required this.id,
    required this.title,
    required this.text,
    required this.eventDate,
    required this.status,
    required this.createdBy,
    required this.createdAt,
    required this.aid,
  });

  factory AnnouncementModel.fromJson(Map<String, dynamic> json) {
    return AnnouncementModel(
      id: json['id'] ?? '',
      title: json['title'] ?? '',
      text: json['text'] ?? '',
      eventDate: json['eventDate'] ?? '',
      status: json['status'] ?? '',
      createdBy: json['createdBy'] ?? '',
      createdAt: json['createdAt'] ?? '',
      aid: json['aid'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'text': text,
      'eventDate': eventDate,
      'status': status,
      'createdBy': createdBy,
      'createdAt': createdAt,
      'aid': aid,
    };
  }
}
