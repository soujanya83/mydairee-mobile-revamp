import 'package:mydiaree/core/config/app_urls.dart';
import 'package:mydiaree/core/cubit/globle_model/center_model.dart';
import 'package:mydiaree/core/cubit/globle_model/children_model.dart';
import 'package:mydiaree/core/cubit/globle_model/educator_model.dart';
import 'package:mydiaree/core/services/apiresoponse.dart';

class GlobleRepository {
  Future<ApiResponse<CenterModel?>> getCenters() async {
    return postAndParse<CenterModel>(
      AppUrls.getCenterList,
      {},
      dummyData: centeresJson,
      dummy: true,
      fromJson: (json) => CenterModel.fromJson(json),
    );
  }

  Future<ApiResponse<ChildModel?>> getChildren() async {
    return postAndParse<ChildModel>(
      AppUrls.getChildrenList,
      {},
      dummyData: childrensJson,
      dummy: true,
      fromJson: (json) => ChildModel.fromJson(json),
    );
  }

  Future<ApiResponse<EducatorModel?>> getEducators() async {
    return postAndParse<EducatorModel>(
      AppUrls.getEducators,
      {},
      dummyData: dummyEducatorData,
      dummy: true,
      fromJson: (json) => EducatorModel.fromJson(json),
    );
  }
}

final childrensJson = {
  "success": true,
  "data": [
    {"id": "101", "name": "Child A"},
    {"id": "102", "name": "Child B"}
  ]
};

final centeresJson = {
  "success": true,
  "data": [
    {"id": "1", "name": "Center A"},
    {"id": "2", "name": "Center B"}
  ]
};

Map<String, dynamic> dummyEducatorData = {
  "success": true,
  "message": "Educators fetched successfully",
  "educators": [
    {
      "id": "1",
      "name": "John Doe",
      "email": "john@example.com",
      "phone": "555-0101",
      "status": "Active"
    },
    {
      "id": "2",
      "name": "Jane Smith",
      "email": "jane@example.com",
      "phone": "555-0102",
      "status": "Active"
    },
    {
      "id": "3",
      "name": "Mike Johnson",
      "email": "mike@example.com",
      "phone": "555-0103",
      "status": "Inactive"
    }
  ]
};
