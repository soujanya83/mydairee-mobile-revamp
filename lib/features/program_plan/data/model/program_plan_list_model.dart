import 'dart:convert';

ProgramPlanListModel programPlanListModelFromJson(String str) =>
    ProgramPlanListModel.fromJson(json.decode(str) as Map<String, dynamic>?);

String programPlanListModelToJson(ProgramPlanListModel data) =>
    json.encode(data.toJson());

class ProgramPlanListModel {
  final bool success;
  final Data data;

  ProgramPlanListModel({
    this.success = false,
    Data? data,
  }) : data = data ?? Data();

  factory ProgramPlanListModel.fromJson(Map<String, dynamic>? json) {
    try {
      final rawSuccess = json?['success'];
      bool success = false;
      if (rawSuccess is bool) {
        success = rawSuccess;
      } else if (rawSuccess is int) {
        success = rawSuccess == 1;
      } else if (rawSuccess is String) {
        success = rawSuccess.toLowerCase() == 'true';
      }
      final dataJson = json?['data'] as Map<String, dynamic>? ?? {};
      return ProgramPlanListModel(
        success: success,
        data: Data.fromJson(dataJson),
      );
    } catch (_) {
      return ProgramPlanListModel();
    }
  }

  Map<String, dynamic> toJson() => {
        "success": success,
        "data": data.toJson(),
      };
}

class Data {
  final List<ProgramPlan> programPlans;
  final String userType;
  final int userId;
  final String centerId;
  final List<CenterModel> centers;
  final Map<String, String> getMonthName;

  Data({
    List<ProgramPlan>? programPlans,
    this.userType = '',
    this.userId = 0,
    this.centerId = '',
    List<CenterModel>? centers,
    Map<String, String>? getMonthName,
  })  : programPlans = programPlans ?? [],
        centers = centers ?? [],
        getMonthName = getMonthName ?? {};

  factory Data.fromJson(Map<String, dynamic>? json) {
    try {
      final plans = (json?['programPlans'] as List<dynamic>? ?? [])
          .map((e) => ProgramPlan.fromJson(e as Map<String, dynamic>?))
          .toList();
      final userType = json?['userType']?.toString() ?? '';
      final userId = int.tryParse(json?['userId']?.toString() ?? '') ?? 0;
      final centerId = json?['centerId']?.toString() ?? '';
      final centersList = (json?['centers'] as List<dynamic>? ?? [])
          .map((e) => CenterModel.fromJson(e as Map<String, dynamic>?))
          .toList();
      final monthMap = <String, String>{};
      (json?['getMonthName'] as Map<String, dynamic>? ?? {})
          .forEach((k, v) => monthMap[k] = v?.toString() ?? '');
      return Data(
        programPlans: plans,
        userType: userType,
        userId: userId,
        centerId: centerId,
        centers: centersList,
        getMonthName: monthMap,
      );
    } catch (_) {
      return Data();
    }
  }

  Map<String, dynamic> toJson() => {
        "programPlans": programPlans.map((x) => x.toJson()).toList(),
        "userType": userType,
        "userId": userId,
        "centerId": centerId,
        "centers": centers.map((x) => x.toJson()).toList(),
        "getMonthName": getMonthName,
      };
}

class CenterModel {
  final int id;
  final dynamic userId;
  final String centerName;
  final String adressStreet;
  final String addressCity;
  final String addressState;
  final String addressZip;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  CenterModel({
    this.id = 0,
    this.userId,
    this.centerName = '',
    this.adressStreet = '',
    this.addressCity = '',
    this.addressState = '',
    this.addressZip = '',
    this.createdAt,
    this.updatedAt,
  });

  factory CenterModel.fromJson(Map<String, dynamic>? json) {
    try {
      final id = int.tryParse(json?['id']?.toString() ?? '') ?? 0;
      final userId = json?['user_id'];
      final centerName = json?['centerName']?.toString() ?? '';
      final adressStreet = json?['adressStreet']?.toString() ?? '';
      final addressCity = json?['addressCity']?.toString() ?? '';
      final addressState = json?['addressState']?.toString() ?? '';
      final addressZip = json?['addressZip']?.toString() ?? '';
      final createdAt = DateTime.tryParse(json?['created_at']?.toString() ?? '');
      final updatedAt = DateTime.tryParse(json?['updated_at']?.toString() ?? '');
      return CenterModel(
        id: id,
        userId: userId,
        centerName: centerName,
        adressStreet: adressStreet,
        addressCity: addressCity,
        addressState: addressState,
        addressZip: addressZip,
        createdAt: createdAt,
        updatedAt: updatedAt,
      );
    } catch (_) {
      return CenterModel();
    }
  }

  Map<String, dynamic> toJson() => {
        "id": id,
        "user_id": userId,
        "centerName": centerName,
        "adressStreet": adressStreet,
        "addressCity": addressCity,
        "addressState": addressState,
        "addressZip": addressZip,
        "created_at": createdAt?.toIso8601String(),
        "updated_at": updatedAt?.toIso8601String(),
      };
}

enum ArtCraft { EMPTY, JFDNKJFDKKJFD }

final artCraftValues = EnumValues({
  "": ArtCraft.EMPTY,
  "jfdnkjfdkkjfd": ArtCraft.JFDNKJFDKKJFD,
});

class ProgramPlan {
  final int id;
  final int roomId;
  final int months;
  final String years;
  final String educators;
  final int centerid;
  final int createdBy;
  final String children;
  final String focusArea;
  final String practicalLife;
  final String practicalLifeExperiences;
  final String sensorial;
  final String sensorialExperiences;
  final String math;
  final String mathExperiences;
  final String language;
  final String languageExperiences;
  final String culture;
  final String cultureExperiences;
  final ArtCraft artCraft;
  final String artCraftExperiences;
  final String eylf;
  final String outdoorExperiences;
  final String inquiryTopic;
  final String sustainabilityTopic;
  final String specialEvents;
  final String childrenVoices;
  final String familiesInput;
  final String groupExperience;
  final String spontaneousExperience;
  final String mindfulnessExperiences;
  final DateTime? createdAt;
  final DateTime? updatedAt;
  final Creator creator;
  final Creator room;

  ProgramPlan({
    this.id = 0,
    this.roomId = 0,
    this.months = 0,
    this.years = '',
    this.educators = '',
    this.centerid = 0,
    this.createdBy = 0,
    this.children = '',
    this.focusArea = '',
    this.practicalLife = '',
    this.practicalLifeExperiences = '',
    this.sensorial = '',
    this.sensorialExperiences = '',
    this.math = '',
    this.mathExperiences = '',
    this.language = '',
    this.languageExperiences = '',
    this.culture = '',
    this.cultureExperiences = '',
    this.artCraft = ArtCraft.EMPTY,
    this.artCraftExperiences = '',
    this.eylf = '',
    this.outdoorExperiences = '',
    this.inquiryTopic = '',
    this.sustainabilityTopic = '',
    this.specialEvents = '',
    this.childrenVoices = '',
    this.familiesInput = '',
    this.groupExperience = '',
    this.spontaneousExperience = '',
    this.mindfulnessExperiences = '',
    this.createdAt,
    this.updatedAt,
    Creator? creator,
    Creator? room,
  })  : creator = creator ?? Creator(),
        room = room ?? Creator();

  factory ProgramPlan.fromJson(Map<String, dynamic>? json) {
    try {
      final id = int.tryParse(json?['id']?.toString() ?? '') ?? 0;
      final roomId = int.tryParse(json?['room_id']?.toString() ?? '') ?? 0;
      final months = int.tryParse(json?['months']?.toString() ?? '') ?? 0;
      final years = json?['years']?.toString() ?? '';
      final educators = json?['educators']?.toString() ?? '';
      final centerid = int.tryParse(json?['centerid']?.toString() ?? '') ?? 0;
      final createdBy =
          int.tryParse(json?['created_by']?.toString() ?? '') ?? 0;
      final children = json?['children']?.toString() ?? '';
      final focusArea = json?['focus_area']?.toString() ?? '';
      final practicalLife = json?['practical_life']?.toString() ?? '';
      final practicalLifeExperiences =
          json?['practical_life_experiences']?.toString() ?? '';
      final sensorial = json?['sensorial']?.toString() ?? '';
      final sensorialExperiences =
          json?['sensorial_experiences']?.toString() ?? '';
      final math = json?['math']?.toString() ?? '';
      final mathExperiences = json?['math_experiences']?.toString() ?? '';
      final language = json?['language']?.toString() ?? '';
      final languageExperiences =
          json?['language_experiences']?.toString() ?? '';
      final culture = json?['culture']?.toString() ?? '';
      final cultureExperiences =
          json?['culture_experiences']?.toString() ?? '';
      final artCraftRaw = json?['art_craft']?.toString() ?? '';
      final artCraft = artCraftValues.map[artCraftRaw] ?? ArtCraft.EMPTY;
      final artCraftExperiences =
          json?['art_craft_experiences']?.toString() ?? '';
      final eylf = json?['eylf']?.toString() ?? '';
      final outdoorExperiences =
          json?['outdoor_experiences']?.toString() ?? '';
      final inquiryTopic = json?['inquiry_topic']?.toString() ?? '';
      final sustainabilityTopic =
          json?['sustainability_topic']?.toString() ?? '';
      final specialEvents = json?['special_events']?.toString() ?? '';
      final childrenVoices = json?['children_voices']?.toString() ?? '';
      final familiesInput = json?['families_input']?.toString() ?? '';
      final groupExperience = json?['group_experience']?.toString() ?? '';
      final spontaneousExperience =
          json?['spontaneous_experience']?.toString() ?? '';
      final mindfulnessExperiences =
          json?['mindfulness_experiences']?.toString() ?? '';
      final createdAt =
          DateTime.tryParse(json?['created_at']?.toString() ?? '');
      final updatedAt =
          DateTime.tryParse(json?['updated_at']?.toString() ?? '');

      return ProgramPlan(
        id: id,
        roomId: roomId,
        months: months,
        years: years,
        educators: educators,
        centerid: centerid,
        createdBy: createdBy,
        children: children,
        focusArea: focusArea,
        practicalLife: practicalLife,
        practicalLifeExperiences: practicalLifeExperiences,
        sensorial: sensorial,
        sensorialExperiences: sensorialExperiences,
        math: math,
        mathExperiences: mathExperiences,
        language: language,
        languageExperiences: languageExperiences,
        culture: culture,
        cultureExperiences: cultureExperiences,
        artCraft: artCraft,
        artCraftExperiences: artCraftExperiences,
        eylf: eylf,
        outdoorExperiences: outdoorExperiences,
        inquiryTopic: inquiryTopic,
        sustainabilityTopic: sustainabilityTopic,
        specialEvents: specialEvents,
        childrenVoices: childrenVoices,
        familiesInput: familiesInput,
        groupExperience: groupExperience,
        spontaneousExperience: spontaneousExperience,
        mindfulnessExperiences: mindfulnessExperiences,
        createdAt: createdAt,
        updatedAt: updatedAt,
        creator: Creator.fromJson(
            json?['creator'] as Map<String, dynamic>?),
        room: Creator.fromJson(json?['room'] as Map<String, dynamic>?),
      );
    } catch (_) {
      return ProgramPlan();
    }
  }

  Map<String, dynamic> toJson() => {
        "id": id,
        "room_id": roomId,
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
        "art_craft": artCraftValues.reverse[artCraft],
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
        "creator": creator.toJson(),
        "room": room.toJson(),
      };
}

class Creator {
  final int id;
  final String name;

  Creator({this.id = 0, this.name = ''});

  factory Creator.fromJson(Map<String, dynamic>? json) {
    try {
      final id = int.tryParse(json?['id']?.toString() ?? '') ?? 0;
      final name = json?['name']?.toString() ?? '';
      return Creator(id: id, name: name);
    } catch (_) {
      return Creator();
    }
  }

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
      };
}

class EnumValues<T> {
  final Map<String, T> map;
  late final Map<T, String> reverseMap;

  EnumValues(this.map);

  Map<T, String> get reverse {
    reverseMap = map.map((k, v) => MapEntry(v, k));
    return reverseMap;
  }
}
