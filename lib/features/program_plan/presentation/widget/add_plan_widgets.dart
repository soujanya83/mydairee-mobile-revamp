import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:mydiaree/core/config/app_colors.dart';
import 'package:mydiaree/core/widgets/custom_buton.dart';

Widget montessoriExpansionTile(
  BuildContext context,
  int parentIndex,
  MontessariSubjectModel? data,
  void Function(void Function()) setState,
  Function assignController,
) {
  return Container(
    margin: const EdgeInsets.symmetric(vertical: 6),
    decoration: BoxDecoration(
        border: Border.all(color: AppColors.primaryColor),
        borderRadius: const BorderRadius.all(Radius.circular(6)),
        color: AppColors.white),
    child: Theme(
      data: Theme.of(context).copyWith(dividerColor: Colors.transparent),
      child: ExpansionTile(
        iconColor: AppColors.primaryColor,
        tilePadding: const EdgeInsets.symmetric(horizontal: 16),
        childrenPadding: const EdgeInsets.only(left: 12, right: 12, bottom: 12),
        title: Text(
          data?.activity[parentIndex].title ?? '',
          style: const TextStyle(fontSize: 15),
        ),
        trailing: null,
        onExpansionChanged: (val) {
          setState(() {});
        },
        children: List.generate(
          data?.activity[parentIndex].subActivity.length ?? 0,
          (childIndex) {
            return CheckboxListTile(
              fillColor: WidgetStatePropertyAll(AppColors.primaryColor),
              checkColor: AppColors.white,
              title: Text(
                data?.activity[parentIndex].subActivity[childIndex].title ?? '',
              ),
              value:
                  data?.activity[parentIndex].subActivity[childIndex].choosen ??
                      false,
              onChanged: (val) {
                setState(() {
                  data?.activity[parentIndex].subActivity[childIndex].choosen =
                      val ?? false;
                  assignController();
                });
              },
            );
          },
        ),
      ),
    ),
  );
}

MontessariSubjectModel? practicalLifeData;

assignPracticalLifeData() {
  final jsonStr = json.encode({
    "idSubject": "subject_1",
    "name": "Practical Life",
    "activity": [
      {
        "idActivity": "activity_1",
        "idSubject": "subject_1",
        "title": "Pouring Water",
        "added_by": "teacher_1",
        "added_at": "2025-06-19T10:00:00.000Z",
        "SubActivity": [
          {
            "idSubActivity": "subactivity_1",
            "idActivity": "activity_1",
            "title": "Pour with jug",
            "subject": "Fine Motor Skills",
            "imageUrl": "https://example.com/image1.jpg",
            "added_by": "teacher_1",
            "added_at": "2025-06-19T10:10:00.000Z",
            "extras": ["step1", "step2"]
          },
          {
            "idSubActivity": "subactivity_2",
            "idActivity": "activity_1",
            "title": "Pour with funnel",
            "subject": "Fine Motor Skills",
            "imageUrl": "https://example.com/image2.jpg",
            "added_by": "teacher_1",
            "added_at": "2025-06-19T10:20:00.000Z",
            "extras": []
          }
        ]
      },
      {
        "idActivity": "activity_2",
        "idSubject": "subject_1",
        "title": "Sweeping",
        "added_by": "teacher_2",
        "added_at": "2025-06-18T09:00:00.000Z",
        "SubActivity": [
          {
            "idSubActivity": "subactivity_3",
            "idActivity": "activity_2",
            "title": "Using dustpan",
            "subject": "Practical Skills",
            "imageUrl": "https://example.com/image3.jpg",
            "added_by": "teacher_2",
            "added_at": "2025-06-18T09:15:00.000Z",
            "extras": ["dust", "pan"]
          }
        ]
      }
    ]
  });
  practicalLifeData = montessariSubjectModelFromJson(jsonStr);
}

MontessariSubjectModel montessariSubjectModelFromJson(String str) =>
    MontessariSubjectModel.fromJson(json.decode(str));

String montessariSubjectModelToJson(MontessariSubjectModel data) =>
    json.encode(data.toJson());

class MontessariSubjectModel {
  String idSubject;
  String name;
  List<Activity> activity;

  MontessariSubjectModel({
    required this.idSubject,
    required this.name,
    required this.activity,
  });

  factory MontessariSubjectModel.fromJson(Map<String, dynamic> json) =>
      MontessariSubjectModel(
        idSubject: json["idSubject"],
        name: json["name"],
        activity: List<Activity>.from(
            json["activity"].map((x) => Activity.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "idSubject": idSubject,
        "name": name,
        "activity": List<dynamic>.from(activity.map((x) => x.toJson())),
      };
}

class Activity {
  String idActivity;
  String idSubject;
  String title;
  dynamic addedBy;
  DateTime addedAt;
  List<SubActivity> subActivity;
  bool choosen;
  Activity({
    required this.idActivity,
    required this.idSubject,
    required this.title,
    required this.addedBy,
    required this.addedAt,
    required this.subActivity,
    required this.choosen,
  });

  factory Activity.fromJson(Map<String, dynamic> json) => Activity(
        choosen: false, //Default
        idActivity: json["idActivity"],
        idSubject: json["idSubject"],
        title: json["title"],
        addedBy: json["added_by"],
        addedAt: DateTime.parse(json["added_at"]),
        subActivity: List<SubActivity>.from(
            json["SubActivity"].map((x) => SubActivity.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "idActivity": idActivity,
        "idSubject": idSubject,
        "title": title,
        "added_by": addedBy,
        "added_at": addedAt.toIso8601String(),
        "SubActivity": List<dynamic>.from(subActivity.map((x) => x.toJson())),
      };
}

class SubActivity {
  String idSubActivity;
  String idActivity;
  String title;
  String subject;
  String imageUrl;
  dynamic addedBy;
  DateTime addedAt;
  List<dynamic> extras;

  bool choosen;
  SubActivity({
    required this.idSubActivity,
    required this.idActivity,
    required this.title,
    required this.subject,
    required this.imageUrl,
    required this.addedBy,
    required this.addedAt,
    required this.extras,
    required this.choosen,
  });

  factory SubActivity.fromJson(Map<String, dynamic> json) => SubActivity(
        idSubActivity: json["idSubActivity"],
        idActivity: json["idActivity"],
        title: json["title"],
        subject: json["subject"],
        imageUrl: json["imageUrl"],
        addedBy: json["added_by"],
        addedAt: DateTime.parse(json["added_at"]),
        extras: List<dynamic>.from(json["extras"].map((x) => x)),
        choosen: false, //Default
      );

  Map<String, dynamic> toJson() => {
        "idSubActivity": idSubActivity,
        "idActivity": idActivity,
        "title": title,
        "subject": subject,
        "imageUrl": imageUrl,
        "added_by": addedBy,
        "added_at": addedAt.toIso8601String(),
        "extras": List<dynamic>.from(extras.map((x) => x)),
      };
}

void showPracticalLifeDialog(
    BuildContext context,
    MontessariSubjectModel? practicalLifeData,
    Function() assignPracticalLifeInController) {
  showDialog(
    context: context,
    builder: (ctx) {
      return StatefulBuilder(
        builder: (context, setState) {
          return AlertDialog(
            contentPadding: EdgeInsets.all(20),
            backgroundColor: AppColors.white,
            insetPadding: EdgeInsets.zero,
            title: Text(
              'Select Practical Life',
              style: Theme.of(context).textTheme.bodyLarge,
            ),
            content: Container(
              color: AppColors.white,
              width: double.maxFinite,
              height: 500,
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    SingleChildScrollView(
                      child: Column(
                        children: List.generate(
                          practicalLifeData?.activity.length ?? 0,
                          (parentIndex) {
                            return montessoriExpansionTile(
                              context,
                              parentIndex,
                              practicalLifeData,
                              setState,
                              assignPracticalLifeInController,
                            );
                          },
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            actions: [
              CustomButton(
                  height: 45,
                  width: 100,
                  text: 'SAVE',
                  isLoading: false, // TODO: Add loading state
                  ontap: () {
                    Navigator.pop(context);
                  })
            ],
          );
        },
      );
    },
  );
}
