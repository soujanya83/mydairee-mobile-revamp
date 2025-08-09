class EventsResponse {
  final bool status;
  final String message;
  final List<Event> events;

  EventsResponse({
    required this.status,
    required this.message,
    required this.events,
  });

  factory EventsResponse.fromJson(Map<String, dynamic> j) => EventsResponse(
        status: j['status'] as bool,
        message: j['message'] as String,
        events: (j['events'] as List)
            .map((e) => Event.fromJson(e))
            .toList(),
      );
}

class Event {
  final int id;
  final String title;
  final String text;
  final String status;
  final String announcementMedia;
  final String eventDate;
  final String createdAt;
  final String start;

  Event({
    required this.id,
    required this.title,
    required this.text,
    required this.status,
    required this.announcementMedia,
    required this.eventDate,
    required this.createdAt,
    required this.start,
  });

  factory Event.fromJson(Map<String, dynamic> j) => Event(
        id: j['id'],
        title: j['title'],
        text: j['text'],
        status: j['status'],
        announcementMedia: j['announcementMedia'] ?? '',
        eventDate: j['eventDate'],
        createdAt: j['createdAt'],
        start: j['start'],
      );
}