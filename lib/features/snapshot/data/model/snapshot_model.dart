
class SnapshotModel  {
  final int id;
  final String title;
  final String status; // 'published' or 'draft'
  final List<String> images; // URLs or asset paths
  final String details;
  final List<Child> children;
  final List<String> rooms;

  const SnapshotModel({
    required this.id,
    required this.title,
    required this.status,
    required this.images,
    required this.details,
    required this.children,
    required this.rooms,
  });

  @override
  List<Object> get props => [id, title, status, images, details, children, rooms];
}

class Child {
  final String name;
  final String avatarUrl;

  Child({required this.name, required this.avatarUrl});
}