class ObservationListModel {
  final List<ObservationItem> observations;

  ObservationListModel({
    required this.observations,
  });

  factory ObservationListModel.fromJson(Map<String, dynamic> json) {
    return ObservationListModel(
      observations: (json['observations'] as List)
          .map((obsJson) => ObservationItem.fromJson(obsJson))
          .toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'observations': observations.map((obs) => obs.toJson()).toList(),
    };
  }
}

class ObservationItem {
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

  ObservationItem({
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
  });

  factory ObservationItem.fromJson(Map<String, dynamic> json) {
    return ObservationItem(
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
