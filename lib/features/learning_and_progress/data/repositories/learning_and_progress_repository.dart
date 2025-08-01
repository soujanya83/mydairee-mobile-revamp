import 'package:mydiaree/features/learning_and_progress/data/model/child_model.dart';

class LearningAndProgressRepository {
  // Mock data (replace with API calls)
  final List<ChildModel> _mockChildren = [
    ChildModel(
      id: '4',
      name: 'Julien Khan',
      dob: '2018-11-30',
      gender: 'Female',
      imageUrl: 'https://images.unsplash.com/photo-1503454537195-1dcabb73ffb9?w=300&h=300&fit=crop&crop=face',
    ),
    ChildModel(
      id: '5',
      name: 'Maxy Den',
      dob: '2018-06-09',
      gender: 'Female',
      imageUrl: 'https://images.unsplash.com/photo-1503454537195-1dcabb73ffb9?w=300&h=300&fit=crop&crop=face',
    ),
    ChildModel(
      id: '6',
      name: 'Nayra Muzzen',
      dob: '2018-05-21',
      gender: 'Female',
      imageUrl: 'https://images.unsplash.com/photo-1503454537195-1dcabb73ffb9?w=300&h=300&fit=crop&crop=face',
    ),
    ChildModel(
      id: '7',
      name: 'Samyon Johan',
      dob: '2018-03-28',
      gender: 'Male',
      imageUrl: 'https://images.unsplash.com/photo-1503454537195-1dcabb73ffb9?w=300&h=300&fit=crop&crop=face',
    ),
  ];

  Future<List<ChildModel>> fetchChildren(String centerId) async {
    // Simulate API call
    await Future.delayed(const Duration(seconds: 1));
    return _mockChildren;
  }

  Future<void> deleteChildren(List<String> childIds, String centerId) async {
    // Simulate API call
    await Future.delayed(const Duration(seconds: 1));
    _mockChildren.removeWhere((child) => childIds.contains(child.id));
  }
}