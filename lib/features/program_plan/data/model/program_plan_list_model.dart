import 'dart:convert';

ProgramPlanListModel programPlanListModelFromJson(String str) =>
    ProgramPlanListModel.fromJson(json.decode(str));

String programPlanListModelToJson(ProgramPlanListModel data) =>
    json.encode(data.toJson());

class ProgramPlanListModel {
  bool? success;
  Data? data;

  ProgramPlanListModel({
    this.success,
    this.data,
  });

  factory ProgramPlanListModel.fromJson(Map<String, dynamic> json) =>
      ProgramPlanListModel(
        success: json["success"],
        data: json["data"] == null ? null : Data.fromJson(json["data"]),
      );

  Map<String, dynamic> toJson() => {
        "success": success,
        "data": data?.toJson(),
      };
}

class Data {
  List<ProgramPlan>? programPlans;
  String? userType;
  int? userId;
  String? centerId;
  List<CenterModel>? centers;
  Map<String, String>? getMonthName;

  Data({
    this.programPlans,
    this.userType,
    this.userId,
    this.centerId,
    this.centers,
    this.getMonthName,
  });

  factory Data.fromJson(Map<String, dynamic> json) => Data(
        programPlans: json["programPlans"] == null
            ? []
            : List<ProgramPlan>.from(
                json["programPlans"]!.map((x) => ProgramPlan.fromJson(x))),
        userType: json["userType"],
        userId: json["userId"],
        centerId: json["centerId"],
        centers: json["centers"] == null
            ? []
            : List<CenterModel>.from(json["centers"]!.map((x) => CenterModel.fromJson(x))),
        getMonthName: json["getMonthName"] == null
            ? {}
            : Map<String, String>.from(json["getMonthName"]),
      );

  Map<String, dynamic> toJson() => {
        "programPlans": programPlans == null
            ? []
            : List<dynamic>.from(programPlans!.map((x) => x.toJson())),
        "userType": userType,
        "userId": userId,
        "centerId": centerId,
        "centers": centers == null
            ? []
            : List<dynamic>.from(centers!.map((x) => x.toJson())),
        "getMonthName": getMonthName == null
            ? {}
            : Map<String, dynamic>.from(getMonthName!),
      };
}

class CenterModel {
  int? id;
  dynamic userId;
  String? centerName;
  String? adressStreet;
  String? addressCity;
  String? addressState;
  String? addressZip;
  DateTime? createdAt;
  DateTime? updatedAt;

  CenterModel({
    this.id,
    this.userId,
    this.centerName,
    this.adressStreet,
    this.addressCity,
    this.addressState,
    this.addressZip,
    this.createdAt,
    this.updatedAt,
  });

  factory CenterModel.fromJson(Map<String, dynamic> json) => CenterModel(
        id: json["id"],
        userId: json["user_id"],
        centerName: json["centerName"],
        adressStreet: json["adressStreet"],
        addressCity: json["addressCity"],
        addressState: json["addressState"],
        addressZip: json["addressZip"],
        createdAt: json["created_at"] == null
            ? null
            : DateTime.parse(json["created_at"]),
        updatedAt: json["updated_at"] == null
            ? null
            : DateTime.parse(json["updated_at"]),
      );

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

class ProgramPlan {
  int? id;
  int? roomId;
  int? months;
  String? years;
  String? educators;
  int? centerid;
  int? createdBy;
  String? children;
  String? focusArea;
  String? practicalLife;
  String? practicalLifeExperiences;
  String? sensorial;
  String? sensorialExperiences;
  String? math;
  String? mathExperiences;
  String? language;
  String? languageExperiences;
  String? culture;
  String? cultureExperiences;
  ArtCraft? artCraft;
  String? artCraftExperiences;
  String? eylf;
  String? outdoorExperiences;
  String? inquiryTopic;
  String? sustainabilityTopic;
  String? specialEvents;
  String? childrenVoices;
  String? familiesInput;
  String? groupExperience;
  String? spontaneousExperience;
  String? mindfulnessExperiences;
  DateTime? createdAt;
  DateTime? updatedAt;
  Creator? creator;
  Creator? room;

  ProgramPlan({
    this.id,
    this.roomId,
    this.months,
    this.years,
    this.educators,
    this.centerid,
    this.createdBy,
    this.children,
    this.focusArea,
    this.practicalLife,
    this.practicalLifeExperiences,
    this.sensorial,
    this.sensorialExperiences,
    this.math,
    this.mathExperiences,
    this.language,
    this.languageExperiences,
    this.culture,
    this.cultureExperiences,
    this.artCraft,
    this.artCraftExperiences,
    this.eylf,
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
    this.creator,
    this.room,
  });

  factory ProgramPlan.fromJson(Map<String, dynamic> json) => ProgramPlan(
        id: json["id"],
        roomId: json["room_id"],
        months: json["months"],
        years: json["years"],
        educators: json["educators"],
        centerid: json["centerid"],
        createdBy: json["created_by"],
        children: json["children"],
        focusArea: json["focus_area"],
        practicalLife: json["practical_life"],
        practicalLifeExperiences: json["practical_life_experiences"],
        sensorial: json["sensorial"],
        sensorialExperiences: json["sensorial_experiences"],
        math: json["math"],
        mathExperiences: json["math_experiences"],
        language: json["language"],
        languageExperiences: json["language_experiences"],
        culture: json["culture"],
        cultureExperiences: json["culture_experiences"],
        artCraft: json["art_craft"] != null
            ? artCraftValues.map[json["art_craft"]] ?? ArtCraft.EMPTY
            : null,
        artCraftExperiences: json["art_craft_experiences"],
        eylf: json["eylf"],
        outdoorExperiences: json["outdoor_experiences"],
        inquiryTopic: json["inquiry_topic"],
        sustainabilityTopic: json["sustainability_topic"],
        specialEvents: json["special_events"],
        childrenVoices: json["children_voices"],
        familiesInput: json["families_input"],
        groupExperience: json["group_experience"],
        spontaneousExperience: json["spontaneous_experience"],
        mindfulnessExperiences: json["mindfulness_experiences"],
        createdAt: json["created_at"] == null
            ? null
            : DateTime.parse(json["created_at"]),
        updatedAt: json["updated_at"] == null
            ? null
            : DateTime.parse(json["updated_at"]),
        creator:
            json["creator"] == null ? null : Creator.fromJson(json["creator"]),
        room: json["room"] == null ? null : Creator.fromJson(json["room"]),
      );

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
        "creator": creator?.toJson(),
        "room": room?.toJson(),
      };
}

enum ArtCraft { EMPTY, JFDNKJFDKKJFD }

final artCraftValues = EnumValues({
  "": ArtCraft.EMPTY,
  "jfdnkjfdkkjfd": ArtCraft.JFDNKJFDKKJFD,
});

class Creator {
  int? id;
  Name? name;

  Creator({
    this.id,
    this.name,
  });

  factory Creator.fromJson(Map<String, dynamic> json) => Creator(
        id: json["id"],
        name: json["name"] != null ? nameValues.map[json["name"]] : null,
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": nameValues.reverse[name],
      };
}

enum Name {
  AMIR,
  DEEPTI,
  NEW_ROOM_TEST_NEW,
  WONDERERS,
}

final nameValues = EnumValues({
  "amir": Name.AMIR,
  "Deepti": Name.DEEPTI,
  "New Room test new": Name.NEW_ROOM_TEST_NEW,
  "Wonderers ": Name.WONDERERS,
});

class EnumValues<T> {
  Map<String, T> map;
  late Map<T, String> reverseMap;

  EnumValues(this.map);

  Map<T, String> get reverse {
    reverseMap = map.map((k, v) => MapEntry(v, k));
    return reverseMap;
  }
}
