import 'package:mydiaree/core/config/app_urls.dart';
import 'package:mydiaree/core/services/apiresoponse.dart';
import 'package:mydiaree/features/snapshot/data/model/snapshot_model.dart';

class SnapshotRepository {
  final List<SnapshotModel> _snapshots = [
    SnapshotModel(
      id: 9,
      title: 'Title Test 23',
      status: 'published',
      images: [
        'https://mydiaree.com.au/Uploads/Snapshots/1752009635_686d8ba379fd5.jpeg',
        'https://mydiaree.com.au/Uploads/Snapshots/1752009635_686d8ba37a5aa.jpg',
        'https://mydiaree.com.au/Uploads/Snapshots/1752009635_686d8ba37aca0.jpeg',
        'https://mydiaree.com.au/Uploads/Snapshots/1752009635_686d8ba37aff8.jpg',
        'https://mydiaree.com.au/Uploads/Snapshots/1752009635_686d8ba37b42c.webp',
      ],
      details: 'Details Test 2',
      children: [
        Child(
            name: 'Izabella Mathews', avatarUrl: 'assets/images/Izabella.jpg'),
        Child(name: 'Julien khan', avatarUrl: 'assets/images/Julien.jpg'),
      ],
      rooms: ['Wonderers', 'Peace Makers'],
    ),
    SnapshotModel(
      id: 8,
      title: 'Title Test',
      status: 'draft',
      images: [
        'https://mydiaree.com.au/Uploads/Snapshots/1752009519_686d8b2fbe5ca.jpg',
        'https://mydiaree.com.au/Uploads/Snapshots/1752009519_686d8b2fbf0b9.png',
        'https://mydiaree.com.au/Uploads/Snapshots/1752009519_686d8b2fbf3ac.jpeg',
        'https://mydiaree.com.au/Uploads/Snapshots/1752009519_686d8b2fbf92c.jpeg',
        'https://mydiaree.com.au/Uploads/Snapshots/1752009519_686d8b2fbfd89.jpeg',
      ],
      details: 'Snapshot Details Test',
      children: [
        Child(name: 'David Meklyn', avatarUrl: 'assets/images/David.jpg'),
        Child(name: 'Maxy Den', avatarUrl: 'assets/images/Maxy.jpg'),
      ],
      rooms: ['Wonderers', 'Peace Makers'],
    ),
  ];

  Future<ApiResponse> addOrEditSnapshot({
    String? snapshotId,
    required String title,
    required String about,
    required String roomId,
    required List<String> children,
    required List<String> media,
  }) async {
    return await postAndParse(
      AppUrls.addSnapshot,
      dummy: true,
      {
        if (snapshotId != null) 'id': snapshotId,
        'title': title,
        'about': about,
        'room_id': roomId,
        'children': children,
        'media': media,
      },
    );
  }

  Future<List<SnapshotModel>> getSnapshots(String centerId) async {
    print('Fetching snapshots for center: $centerId');
    await Future.delayed(const Duration(seconds: 1)); // Simulate network delay
    return _snapshots;
  }

  Future<void> deleteSnapshot(int id) async {
    print('Deleting snapshot with id: $id');
    await Future.delayed(const Duration(seconds: 1)); // Simulate network delay
    _snapshots.removeWhere((snapshot) => snapshot.id == id);
  }
}
