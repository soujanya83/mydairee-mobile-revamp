class ChildModel {
  final bool success;
  final List<ChildIten> data;

  ChildModel({required this.success, required this.data});

  factory ChildModel.fromJson(Map<String, dynamic> json) {
    return ChildModel(
      success: json['success'] ?? false,
      data: (json['data'] != null
          ? (json['data'] as List<dynamic>).map((e) => ChildIten.fromJson(e)).toList()
          : []),
    );
  }
}

class ChildIten {
  final String id;
  final String name;

  ChildIten({required this.id, required this.name});

  factory ChildIten.fromJson(Map<String, dynamic> json) {
    return ChildIten(
      id: json['id'].toString(),
      name: json['name'] ?? '',
    );
  }
}
