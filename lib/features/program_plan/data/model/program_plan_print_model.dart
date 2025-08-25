import 'dart:convert';

ProgramPlanPrintResponse programPlanPrintResponseFromJson(String str) =>
    ProgramPlanPrintResponse.fromJson(json.decode(str) as Map<String, dynamic>?);

String programPlanPrintResponseToJson(ProgramPlanPrintResponse data) =>
    json.encode(data.toJson());

class ProgramPlanPrintResponse {
  final String status;
  final String message;
  final ProgramPlanPrintData plan;
  final String roomName;
  final String educatorNames;
  final String childrenNames;
  final String monthName;

  ProgramPlanPrintResponse({
    required this.status,
    required this.message,
    required this.plan,
    required this.roomName,
    required this.educatorNames,
    required this.childrenNames,
    required this.monthName,
  });

  factory ProgramPlanPrintResponse.fromJson(Map<String, dynamic>? json) {
    try {
      return ProgramPlanPrintResponse(
        status: json?['status']?.toString() ?? '',
        message: json?['message']?.toString() ?? '',
        plan: ProgramPlanPrintData.fromJson(json?['plan'] as Map<String, dynamic>? ?? {}),
        roomName: json?['room_name']?.toString() ?? '',
        educatorNames: json?['educator_names']?.toString() ?? '',
        childrenNames: json?['children_names']?.toString() ?? '',
        monthName: json?['month_name']?.toString() ?? '',
      );
    } catch (_) {
      return ProgramPlanPrintResponse(
        status: '',
        message: '',
        plan: ProgramPlanPrintData(),
        roomName: '',
        educatorNames: '',
        childrenNames: '',
        monthName: '',
      );
    }
  }

  Map<String, dynamic> toJson() => {
        "status": status,
        "message": message,
        "plan": plan.toJson(),
        "room_name": roomName,
        "educator_names": educatorNames,
        "children_names": childrenNames,
        "month_name": monthName,
      };
}

class ProgramPlanPrintData {
  final int id;
  final int roomId;
  final String status;
  final int months;
  final String years;
  final String educators;
  final int centerid;
  final int createdBy;
  final String children;
  final String? focusArea;
  final String practicalLife;
  final String? practicalLifeExperiences;
  final String sensorial;
  final String? sensorialExperiences;
  final String math;
  final String? mathExperiences;
  final String language;
  final String? languageExperiences;
  final String culture;
  final String? cultureExperiences;
  final String? artCraft;
  final String? artCraftExperiences;
  final String eylf;
  final String? outdoorExperiences;
  final String? inquiryTopic;
  final String? sustainabilityTopic;
  final String? specialEvents;
  final String? childrenVoices;
  final String? familiesInput;
  final String? groupExperience;
  final String? spontaneousExperience;
  final String? mindfulnessExperiences;
  final DateTime? createdAt;
  final DateTime? updatedAt;
  final RoomPrintData? room;

  ProgramPlanPrintData({
    this.id = 0,
    this.roomId = 0,
    this.status = '',
    this.months = 0,
    this.years = '',
    this.educators = '',
    this.centerid = 0,
    this.createdBy = 0,
    this.children = '',
    this.focusArea,
    this.practicalLife = '',
    this.practicalLifeExperiences,
    this.sensorial = '',
    this.sensorialExperiences,
    this.math = '',
    this.mathExperiences,
    this.language = '',
    this.languageExperiences,
    this.culture = '',
    this.cultureExperiences,
    this.artCraft,
    this.artCraftExperiences,
    this.eylf = '',
    this.outdoorExperiences,
    this.inquiryTopic,
    this.sustainabilityTopic,
    this.specialEvents,
    this.childrenVoices,
    this.familiesInput,
    this.groupExperience,
    this.spontaneousExperience,
    this.mindfulnessExperiences,
    this.createdAt,
    this.updatedAt,
    this.room,
  });

  factory ProgramPlanPrintData.fromJson(Map<String, dynamic>? json) {
    try {
      return ProgramPlanPrintData(
        id: int.tryParse(json?['id']?.toString() ?? '') ?? 0,
        roomId: int.tryParse(json?['room_id']?.toString() ?? '') ?? 0,
        status: json?['status']?.toString() ?? '',
        months: int.tryParse(json?['months']?.toString() ?? '') ?? 0,
        years: json?['years']?.toString() ?? '',
        educators: json?['educators']?.toString() ?? '',
        centerid: int.tryParse(json?['centerid']?.toString() ?? '') ?? 0,
        createdBy: int.tryParse(json?['created_by']?.toString() ?? '') ?? 0,
        children: json?['children']?.toString() ?? '',
        focusArea: json?['focus_area']?.toString(),
        practicalLife: json?['practical_life']?.toString() ?? '',
        practicalLifeExperiences: json?['practical_life_experiences']?.toString(),
        sensorial: json?['sensorial']?.toString() ?? '',
        sensorialExperiences: json?['sensorial_experiences']?.toString(),
        math: json?['math']?.toString() ?? '',
        mathExperiences: json?['math_experiences']?.toString(),
        language: json?['language']?.toString() ?? '',
        languageExperiences: json?['language_experiences']?.toString(),
        culture: json?['culture']?.toString() ?? '',
        cultureExperiences: json?['culture_experiences']?.toString(),
        artCraft: json?['art_craft']?.toString(),
        artCraftExperiences: json?['art_craft_experiences']?.toString(),
        eylf: json?['eylf']?.toString() ?? '',
        outdoorExperiences: json?['outdoor_experiences']?.toString(),
        inquiryTopic: json?['inquiry_topic']?.toString(),
        sustainabilityTopic: json?['sustainability_topic']?.toString(),
        specialEvents: json?['special_events']?.toString(),
        childrenVoices: json?['children_voices']?.toString(),
        familiesInput: json?['families_input']?.toString(),
        groupExperience: json?['group_experience']?.toString(),
        spontaneousExperience: json?['spontaneous_experience']?.toString(),
        mindfulnessExperiences: json?['mindfulness_experiences']?.toString(),
        createdAt: DateTime.tryParse(json?['created_at']?.toString() ?? ''),
        updatedAt: DateTime.tryParse(json?['updated_at']?.toString() ?? ''),
        room: json?['room'] != null ? RoomPrintData.fromJson(json!['room'] as Map<String, dynamic>) : null,
      );
    } catch (_) {
      return ProgramPlanPrintData();
    }
  }

  Map<String, dynamic> toJson() => {
        "id": id,
        "room_id": roomId,
        "status": status,
        "months": months,
        "years": years,
        "educators": educators,
        "centerid": centerid,
        "created_by": createdBy,
        "children": children,
        "focus_area": focusArea,
        "practical_life": practicalLife,
        "practical_life_experiences": practicalLifeExperiences,
        "sensorial": sensorial,
        "sensorial_experiences": sensorialExperiences,
        "math": math,
        "math_experiences": mathExperiences,
        "language": language,
        "language_experiences": languageExperiences,
        "culture": culture,
        "culture_experiences": cultureExperiences,
        "art_craft": artCraft,
        "art_craft_experiences": artCraftExperiences,
        "eylf": eylf,
        "outdoor_experiences": outdoorExperiences,
        "inquiry_topic": inquiryTopic,
        "sustainability_topic": sustainabilityTopic,
        "special_events": specialEvents,
        "children_voices": childrenVoices,
        "families_input": familiesInput,
        "group_experience": groupExperience,
        "spontaneous_experience": spontaneousExperience,
        "mindfulness_experiences": mindfulnessExperiences,
        "created_at": createdAt?.toIso8601String(),
        "updated_at": updatedAt?.toIso8601String(),
        "room": room?.toJson(),
      };
}

class RoomPrintData {
  final int id;
  final String name;
  final int capacity;
  final int userId;
  final String color;
  final int ageFrom;
  final int ageTo;
  final String status;
  final int centerid;
  final int? createdBy;

  RoomPrintData({
    this.id = 0,
    this.name = '',
    this.capacity = 0,
    this.userId = 0,
    this.color = '',
    this.ageFrom = 0,
    this.ageTo = 0,
    this.status = '',
    this.centerid = 0,
    this.createdBy,
  });

  factory RoomPrintData.fromJson(Map<String, dynamic>? json) {
    try {
      return RoomPrintData(
        id: int.tryParse(json?['id']?.toString() ?? '') ?? 0,
        name: json?['name']?.toString() ?? '',
        capacity: int.tryParse(json?['capacity']?.toString() ?? '') ?? 0,
        userId: int.tryParse(json?['userId']?.toString() ?? '') ?? 0,
        color: json?['color']?.toString() ?? '',
        ageFrom: int.tryParse(json?['ageFrom']?.toString() ?? '') ?? 0,
        ageTo: int.tryParse(json?['ageTo']?.toString() ?? '') ?? 0,
        status: json?['status']?.toString() ?? '',
        centerid: int.tryParse(json?['centerid']?.toString() ?? '') ?? 0,
        createdBy: int.tryParse(json?['created_by']?.toString() ?? ''),
      );
    } catch (_) {
      return RoomPrintData();
    }
  }

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "capacity": capacity,
        "userId": userId,
        "color": color,
        "ageFrom": ageFrom,
        "ageTo": ageTo,
        "status": status,
        "centerid": centerid,
        "created_by": createdBy,
      };
}
