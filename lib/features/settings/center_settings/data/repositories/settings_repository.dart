import 'package:mydiaree/core/config/app_urls.dart';
import 'package:mydiaree/core/services/apiresoponse.dart';
import 'package:mydiaree/features/settings/center_settings/data/model/center_model.dart';

class CentersRepository {
  static List<Map<String, dynamic>> dummyCentersData = [
    {
      'id': '1',
      'centerName': 'Melbourne Center',
      'streetAddress': 'Block 1, Near X Junction, Australia',
      'city': 'Melbourne',
      'state': 'Queensland',
      'zip': '373456',
    },
    {
      'id': '2',
      'centerName': 'Carramar Center',
      'streetAddress': '126 The Horsley Dr',
      'city': 'Carramar',
      'state': 'NSW',
      'zip': '2163',
    },
    {
      'id': '3',
      'centerName': 'Brisbane Center',
      'streetAddress': '5 Boundary St, Brisbane',
      'city': 'Brisbane',
      'state': 'Queensland2',
      'zip': '4001',
    },
    {
      'id': '110',
      'centerName': 'test',
      'streetAddress': 'test',
      'city': 'test22',
      'state': 'test22',
      'zip': '2514',
    },
    {
      'id': '112',
      'centerName': 'mytesting325',
      'streetAddress': 'testig',
      'city': 'testtt12',
      'state': 'testtt2',
      'zip': '12548',
    },
  ];

  Future<List<CenterModel>> getCenters() async {
    // Simulate API call with dummy data
    return dummyCentersData.map((data) => CenterModel.fromJson(data)).toList();
  }

  Future<ApiResponse> addCenter(CenterModel center) async {
    return await postAndParse(
      AppUrls.addCenter,
      dummy: true,
      {
        'centerName': center.centerName,
        'adressStreet': center.streetAddress,
        'addressCity': center.city,
        'addressState': center.state,
        'addressZip': center.zip,
      },
    );
  }

  Future<ApiResponse> updateCenter(CenterModel center) async {
    return await postAndParse(
      '${AppUrls.updateCenter}/${center.id}',
      dummy: true,
      {
        'id': center.id,
        'centerName': center.centerName,
        'adressStreet': center.streetAddress,
        'addressCity': center.city,
        'addressState': center.state,
        'addressZip': center.zip,
      },
    );
  }

  Future<ApiResponse> deleteCenter(String centerId) async {
    return await postAndParse(
      '${AppUrls.deleteCenter}/$centerId',
      dummy: true,
      {
        '_method': 'DELETE',
      },
    );
  }
}