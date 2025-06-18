class CenterModel {
  final bool success;
  final List<CenterData> data;

  CenterModel({required this.success, required this.data});

  factory CenterModel.fromJson(Map<String, dynamic> json) {
    return CenterModel(
      success: json['success'] ?? false,
      data: (json['data'] as List<dynamic>)
          .map((e) => CenterData.fromJson(e))
          .toList(),
    );
  }
}

class CenterData {
  final String id;
  final String name;

  CenterData({required this.id, required this.name});

  factory CenterData.fromJson(Map<String, dynamic> json) {
    return CenterData(
      id: json['id'].toString(),
      name: json['name'] ?? '',
    );
  }
}
