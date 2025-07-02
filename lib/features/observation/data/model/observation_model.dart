class ObservationModel {
  final String id;
  final String? title;
  final String? notes;
  final String? reflection;
  final String? childVoice;
  final String? futurePlan;
  final String dateAdded;
  final String userName;
  final String? approverName;
  final String status;
  final List<ChildSubModel> children;
  final List<String> mediaFiles;

  ObservationModel({

    required this.id,
    this.title,
    this.notes,
    this.reflection,
    this.childVoice,
    this.futurePlan,
    required this.dateAdded,
    required this.userName,
    this.approverName,
    required this.status,
    required this.children,
    this.mediaFiles =const [],
  });

  factory ObservationModel.fromJson(Map<String, dynamic> json) {
    return ObservationModel(
      id: json['id'] ?? '',
      title: json['title'],
      notes: json['notes'],
      reflection: json['reflection'],
      childVoice: json['childVoice'],
      futurePlan: json['futurePlan'],
      dateAdded: json['dateAdded'] ?? '',
      userName: json['userName'] ?? '',
      approverName: json['approverName'],
      status: json['status'] ?? '',
      children: (json['children'] as List?)
              ?.map((child) => ChildSubModel.fromJson(child))
              .toList() ??
          [],
      mediaFiles: (json['mediaFiles'] as List?)
              ?.map((file) => file.toString())
              .toList() ??
          [],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'notes': notes,
      'reflection': reflection,
      'childVoice': childVoice,
      'futurePlan': futurePlan,
      'dateAdded': dateAdded,
      'userName': userName,
      'approverName': approverName,
      'status': status,
      'children': children.map((c) => c.toJson()).toList(),
      'mediaFiles': mediaFiles,
    };
  }
}

class ChildSubModel {
  final String childId;
  final String childName;
  final String imageUrl;

  ChildSubModel({
    required this.childId,
    required this.childName,
  required this.imageUrl, 
  });

  factory ChildSubModel.fromJson(Map<String, dynamic> json) {
    return ChildSubModel(
      childId: json['childId'] ?? '',
      childName: json['childName'] ?? '',
      imageUrl: json['imageUrl'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'childId': childId,
      'childName': childName,
      'imageUrl': imageUrl,
    };
  }
}
