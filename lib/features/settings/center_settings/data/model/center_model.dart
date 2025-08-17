class CenterModel {
  final int id;
  final int? userId;
  final String centerName;
  final String streetAddress;
  final String city;
  final String state;
  final String zip;
  final String? createdAt;
  final String? updatedAt;

  CenterModel({
    required this.id,
    this.userId,
    required this.centerName,
    required this.streetAddress,
    required this.city,
    required this.state,
    required this.zip,
    this.createdAt,
    this.updatedAt,
  });

  factory CenterModel.fromJson(Map<String, dynamic> json) {
    return CenterModel(
      id: json['id'] is int ? json['id'] : int.tryParse(json['id'].toString()) ?? 0,
      userId: json['user_id'] is int ? json['user_id'] : int.tryParse(json['user_id']?.toString() ?? ''),
      centerName: json['centerName'] ?? '',
      streetAddress: json['adressStreet'] ?? '',
      city: json['addressCity'] ?? '',
      state: json['addressState'] ?? '',
      zip: json['addressZip'] ?? '',
      createdAt: json['created_at'],
      updatedAt: json['updated_at'],
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'user_id': userId,
        'centerName': centerName,
        'adressStreet': streetAddress,
        'addressCity': city,
        'addressState': state,
        'addressZip': zip,
        'created_at': createdAt,
        'updated_at': updatedAt,
      };
}