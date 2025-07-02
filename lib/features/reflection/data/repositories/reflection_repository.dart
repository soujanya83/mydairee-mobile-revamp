import 'package:mydiaree/core/config/app_urls.dart';
import 'package:mydiaree/core/services/apiresoponse.dart';
import 'package:mydiaree/features/reflection/data/model/reflection_list_model_screen.dart';

/// Dummy API-like structure
Map<String, dynamic> dummyReflectionListData = {
  "data": [
    {
      "id": "220",
      "title": "test",
      "date": "Jul 01, 2025",
      "images": [
        "https://mydiaree.com.au/uploads/Reflections/1751369659_6863c7bb78ced.jpg",
        "https://mydiaree.com.au/uploads/Reflections/1751369659_6863c7bb79113.png"
      ],
      "children": [
        {"id": "1", "name": "Iron Man"},
        {"id": "2", "name": "Rajat"},
      ],
      "educators": [
        {"id": "11", "name": "Sagar Sutar"},
        {"id": "12", "name": "Aman"},
      ],
      "editUrl": "https://mydiaree.com.au/reflection/addnew/220",
      "printUrl": "https://mydiaree.com.au/reflection/addnew/220",
      "status": "Published"
    },
    {
      "id": "199",
      "title": "test by me",
      "date": "Jul 01, 2025",
      "images": ["https://mydiaree.com.au/682c7eeac57db.jpg"],
      "children": [
        {"id": "3", "name": "David"},
        {"id": "4", "name": "Izabella"},
        {"id": "5", "name": "Nayra"}
      ],
      "educators": [
        {"id": "13", "name": "Kailash Sahu"},
        {"id": "11", "name": "Sagar Sutar"}
      ],
      "editUrl": "https://mydiaree.com.au/reflection/addnew/199",
      "printUrl": "https://mydiaree.com.au/reflection/addnew/199",
      "status": "Published"
    }
  ]
};

class ReflectionRepository {
  /// Fetch all reflections
  Future<ApiResponse<ReflectionListModel?>> getReflections({
    required String centerId,
    String? search,
    String? status,
    List<String>? children,
    List<String>? authors,
    int? page,
  }) async {
    return await postAndParse(
      AppUrls.getReflections, // Add this to AppUrls.dart
      dummy: true,
      dummyData: dummyReflectionListData,
      {
        'center_id': centerId,
        if (search != null && search.isNotEmpty) 'search': search,
        if (status != null && status != 'All') 'status': status,
        if (children != null && children.isNotEmpty) 'children': children,
        if (authors != null && authors.isNotEmpty) 'authors': authors,
        if (page != null) 'page': page.toString(),
      },
      fromJson: (json) => ReflectionListModel.fromJson(json),
    );
  }

  
  Future<ApiResponse> addOrEditReflection({
    String? reflectionId,
    required String title,
    required String about,
    required String eylf,
    required String roomId,
    required List<String> children,
    required List<String> educators,
    required List<String> media,
  }) async {
    return await postAndParse(
      AppUrls.addReflection,
      dummy: true,
      {
        if (reflectionId != null) 'id': reflectionId,
        'title': title,
        'about': about,
        'eylf': eylf,
        'room_id': roomId,
        'children': children,
        'educators': educators,
        'media': media,
      },
    );
  }


  /// Delete multiple reflections
  Future<ApiResponse> deleteReflections(List<String> reflectionIds) async {
    return await postAndParse(
      AppUrls.deleteReflections, // Add to AppUrls.dart
      dummy: true,
      {
        'reflection_ids': reflectionIds,
      },
    );
  }
}
