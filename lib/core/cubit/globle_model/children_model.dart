class ChildModel {
  final bool success;
  final List<ChildData> data;

  ChildModel({required this.success, required this.data});

  factory ChildModel.fromJson(Map<String, dynamic> json) {
    return ChildModel(
      success: json['success'] ?? false,
      data: (json['data'] as List<dynamic>)
          .map((e) => ChildData.fromJson(e))
          .toList(),
    );
  }
}

class ChildData {
  final String id;
  final String name;

  ChildData({required this.id, required this.name});

  factory ChildData.fromJson(Map<String, dynamic> json) {
    return ChildData(
      id: json['id'].toString(),
      name: json['name'] ?? '',
    );
  }
}
