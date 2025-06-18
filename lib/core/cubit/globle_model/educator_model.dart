class EducatorModel {
  final bool success;
  final String? message;
  final List<EducatorItem> educators;

  EducatorModel({
    required this.success,
    this.message,
    required this.educators,
  });

  factory EducatorModel.fromJson(Map<String, dynamic> json) {
    return EducatorModel(
      success: json['success'] ?? false,
      message: json['message'],
      educators: (json['educators'] as List?)
          ?.map((educatorJson) => EducatorItem.fromJson(educatorJson))
          .toList() ?? [],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'success': success,
      'message': message,
      'educators': educators.map((educator) => educator.toJson()).toList(),
    };
  }
}

class EducatorItem {
  final String id;
  final String name;
  final String email;
  final String phone;
  final String status;

  EducatorItem({
    required this.id,
    required this.name,
    required this.email,
    required this.phone,
    required this.status,
  });

  factory EducatorItem.fromJson(Map<String, dynamic> json) {
    return EducatorItem(
      id: json['id'] ?? '',
      name: json['name'] ?? '',
      email: json['email'] ?? '',
      phone: json['phone'] ?? '',
      status: json['status'] ?? 'Active',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'email': email,
      'phone': phone,
      'status': status,
    };
  }
}
