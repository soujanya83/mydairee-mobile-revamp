import 'package:mydiaree/features/reflection/presentation/pages/reflection_list_screen.dart';

class ReflectionListModel {
  final List<Reflection> reflections;

  ReflectionListModel({required this.reflections});

  factory ReflectionListModel.fromJson(Map<String, dynamic> json) {
    return ReflectionListModel(
      reflections: (json['data'] as List)
          .map((item) => Reflection.fromJson(item))
          .toList(),
    );
  }

  Map<String, dynamic> toJson() => {
        'data': reflections.map((e) => e.toJson()).toList(),
      };
}

class Person {
  final String id;
  final String name;

  Person({required this.id, required this.name});

  factory Person.fromJson(Map<String, dynamic> json) {
    return Person(
      id: json['id'],
      name: json['name'],
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
      };
}

class Reflection {
  final String id;
  final String title;
  final String date;
  final List<String> images;
  final List<Person> children;
  final List<Person> educators;
  final String editUrl;
  final String printUrl;
  final String status;

  Reflection({
    required this.id,
    required this.title,
    required this.date,
    required this.images,
    required this.children,
    required this.educators,
    required this.editUrl,
    required this.printUrl,
    this.status = 'Published',
  });

  factory Reflection.fromJson(Map<String, dynamic> json) {
    return Reflection(
      id: json['id'],
      title: json['title'],
      date: json['date'],
      images: List<String>.from(json['images']),
      children: (json['children'] as List)
          .map((child) => Person.fromJson(child))
          .toList(),
      educators: (json['educators'] as List)
          .map((edu) => Person.fromJson(edu))
          .toList(),
      editUrl: json['editUrl'],
      printUrl: json['printUrl'],
      status: json['status'] ?? 'Published',
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'title': title,
        'date': date,
        'images': images,
        'children': children.map((e) => e.toJson()).toList(),
        'educators': educators.map((e) => e.toJson()).toList(),
        'editUrl': editUrl,
        'printUrl': printUrl,
        'status': status,
      };
}
