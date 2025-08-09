class BirthdaysResponse {
  final bool status;
  final String message;
  final List<ChildBirthday> data;

  BirthdaysResponse({
    required this.status,
    required this.message,
    required this.data,
  });

  factory BirthdaysResponse.fromJson(Map<String, dynamic> j) =>
      BirthdaysResponse(
        status: j['status'] as bool,
        message: j['message'] as String,
        data: (j['data'] as List)
            .map((e) => ChildBirthday.fromJson(e))
            .toList(),
      );
}

class ChildBirthday {
  final int id;
  final String name;
  final String lastname;
  final String dob;
  final String startDate;
  final int room;
  final String imageUrl;
  final String gender;
  final String status;
  final String daysAttending;
  final int centerid;
  final int createdBy;
  final String createdAt;
  final String created_at;
  final String updated_at;

  ChildBirthday({
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
    required this.centerid,
    required this.createdBy,
    required this.createdAt,
    required this.created_at,
    required this.updated_at,
  });

  factory ChildBirthday.fromJson(Map<String, dynamic> j) => ChildBirthday(
        id: j['id'],
        name: j['name'],
        lastname: j['lastname'],
        dob: j['dob'],
        startDate: j['startDate'],
        room: j['room'],
        imageUrl: j['imageUrl'],
        gender: j['gender'],
        status: j['status'],
        daysAttending: j['daysAttending'],
        centerid: j['centerid'],
        createdBy: j['createdBy'],
        createdAt: j['createdAt'],
        created_at: j['created_at'],
        updated_at: j['updated_at'],
      );
}