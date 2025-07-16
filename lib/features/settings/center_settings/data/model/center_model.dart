class CenterModel {
  final String id;
  final String centerName;
  final String streetAddress;
  final String city;
  final String state;
  final String zip;

  CenterModel({
    required this.id,
    required this.centerName,
    required this.streetAddress,
    required this.city,
    required this.state,
    required this.zip,
  });

  factory CenterModel.fromJson(Map<String, dynamic> json) {
    return CenterModel(
      id: json['id'] ?? '',
      centerName: json['centerName'] ?? '',
      streetAddress: json['streetAddress'] ?? '',
      city: json['city'] ?? '',
      state: json['state'] ?? '',
      zip: json['zip'] ?? '',
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'centerName': centerName,
        'streetAddress': streetAddress,
        'city': city,
        'state': state,
        'zip': zip,
      };
}