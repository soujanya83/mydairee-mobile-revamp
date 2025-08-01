class ChildModel {
  final String id;
  final String name;
  final String dob;
  final String gender;
  final String imageUrl;

  ChildModel({
    required this.id,
    required this.name,
    required this.dob,
    required this.gender,
    required this.imageUrl,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'dob': dob,
      'gender': gender,
      'imageUrl': imageUrl,
    };
  }

  factory ChildModel.fromMap(Map<String, dynamic> map) {
    return ChildModel(
      id: map['id'] as String,
      name: map['name'] as String,
      dob: map['dob'] as String,
      gender: map['gender'] as String,
      imageUrl: map['imageUrl'] as String,
    );
  }

  int getAge() {
    try {
      final dobDate = DateTime.parse(dob);
      final now = DateTime.now();
      int age = now.year - dobDate.year;
      if (now.month < dobDate.month || (now.month == dobDate.month && now.day < dobDate.day)) {
        age--;
      }
      return age;
    } catch (e) {
      return 0;
    }
  }
}