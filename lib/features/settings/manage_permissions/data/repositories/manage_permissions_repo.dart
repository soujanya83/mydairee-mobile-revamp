import 'package:mydiaree/core/config/app_urls.dart';
import 'package:mydiaree/core/services/apiresoponse.dart';
import 'package:mydiaree/features/settings/manage_permissions/data/model/permission_model.dart';
import 'package:mydiaree/features/settings/manage_permissions/data/model/user_model.dart';

class ManagePermissionsRepository {
  // Dummy data for permissions
  final Map<String, dynamic> _dummyPermissions = {
    "success": true,
    "data": [
      {"key": "addObservation", "label": "Add Observation"},
      {"key": "approveObservation", "label": "Approve Observation"},
      {"key": "deleteObservation", "label": "Delete Observation"},
      {"key": "updateObservation", "label": "Update Observation"},
      {"key": "viewAllObservation", "label": "View All Observation"},
      {"key": "addReflection", "label": "Add Reflection"},
      {"key": "approveReflection", "label": "Approve Reflection"},
      {"key": "updatereflection", "label": "Updatereflection"},
      {"key": "deletereflection", "label": "Deletereflection"},
      {"key": "viewAllReflection", "label": "View All Reflection"},
      {"key": "addQIP", "label": "Add Q I P"},
      {"key": "editQIP", "label": "Edit Q I P"},
      {"key": "deleteQIP", "label": "Delete Q I P"},
      {"key": "downloadQIP", "label": "Download Q I P"},
      {"key": "printQIP", "label": "Print Q I P"},
      {"key": "mailQIP", "label": "Mail Q I P"},
      {"key": "viewQip", "label": "View Qip"},
      {"key": "viewRoom", "label": "View Room"},
      {"key": "addRoom", "label": "Add Room"},
      {"key": "editRoom", "label": "Edit Room"},
      {"key": "deleteRoom", "label": "Delete Room"},
      {"key": "addProgramPlan", "label": "Add Program Plan"},
      {"key": "editProgramPlan", "label": "Edit Program Plan"},
      {"key": "viewProgramPlan", "label": "View Program Plan"},
      {"key": "deleteProgramPlan", "label": "Delete Program Plan"},
      {"key": "addAnnouncement", "label": "Add Announcement"},
      {"key": "approveAnnouncement", "label": "Approve Announcement"},
      {"key": "deleteAnnouncement", "label": "Delete Announcement"},
      {"key": "updateAnnouncement", "label": "Update Announcement"},
      {"key": "viewAllAnnouncement", "label": "View All Announcement"},
      {"key": "addSurvey", "label": "Add Survey"},
      {"key": "approveSurvey", "label": "Approve Survey"},
      {"key": "deleteSurvey", "label": "Delete Survey"},
      {"key": "updateSurvey", "label": "Update Survey"},
      {"key": "viewAllSurvey", "label": "View All Survey"},
      {"key": "addRecipe", "label": "Add Recipe"},
      {"key": "approveRecipe", "label": "Approve Recipe"},
      {"key": "deleteRecipe", "label": "Delete Recipe"},
      {"key": "updateRecipe", "label": "Update Recipe"},
      {"key": "addMenu", "label": "Add Menu"},
      {"key": "approveMenu", "label": "Approve Menu"},
      {"key": "deleteMenu", "label": "Delete Menu"},
      {"key": "updateMenu", "label": "Update Menu"},
      {"key": "viewDailyDiary", "label": "View Daily Diary"},
      {"key": "updateDailyDiary", "label": "Update Daily Diary"},
      {"key": "updateHeadChecks", "label": "Update Head Checks"},
      {"key": "updateAccidents", "label": "Update Accidents"},
      {"key": "updateModules", "label": "Update Modules"},
      {"key": "addUsers", "label": "Add Users"},
      {"key": "viewUsers", "label": "View Users"},
      {"key": "updateUsers", "label": "Update Users"},
      {"key": "addCenters", "label": "Add Centers"},
      {"key": "viewCenters", "label": "View Centers"},
      {"key": "updateCenters", "label": "Update Centers"},
      {"key": "addParent", "label": "Add Parent"},
      {"key": "viewParent", "label": "View Parent"},
      {"key": "updateParent", "label": "Update Parent"},
      {"key": "addChildGroup", "label": "Add Child Group"},
      {"key": "viewChildGroup", "label": "View Child Group"},
      {"key": "updateChildGroup", "label": "Update Child Group"},
      {"key": "updatePermission", "label": "Update Permission"},
      {"key": "addprogress", "label": "Addprogress"},
      {"key": "editprogress", "label": "Editprogress"},
      {"key": "viewprogress", "label": "Viewprogress"},
      {"key": "editlesson", "label": "Editlesson"},
      {"key": "viewlesson", "label": "Viewlesson"},
      {"key": "printpdflesson", "label": "Printpdflesson"},
      {"key": "assessment", "label": "Assessment"},
      {"key": "addSelfAssessment", "label": "Add Self Assessment"},
      {"key": "editSelfAssessment", "label": "Edit Self Assessment"},
      {"key": "deleteSelfAssessment", "label": "Delete Self Assessment"},
      {"key": "viewSelfAssessment", "label": "View Self Assessment"}
    ]
  };

  Future<ApiResponse> addPermissions({
    List<String> permissions = const [],
    String userId = '',
    bool dummy = false,
  }) async {
    return postAndParse(
      dummy: true,
      AppUrls.addPermissions,
      {
        'user_id': userId,
        'permissions': permissions,
      },
    );
  }

  Future<ApiResponse<PermissionListModel?>> getPermissions(
      {bool dummy = false}) async {
    return getAndParseData<PermissionListModel>(
      dummyData: _dummyPermissions,
      dummy: true,
      AppUrls.getPermissions,
      fromJson: (json) =>
          PermissionListModel.fromJson(json as Map<String, dynamic>),
    );
  }

  Future<List<UserModel>> fetchUsers() async {
    await Future.delayed(Duration(seconds: 1)); // Simulate network delay
    final response = {
      'users': [
        {
          'id': 1,
          'name': 'John Doe',
          'permissions': ['read', 'write']
        },
        {
          'id': 2,
          'name': 'Jane Smith',
          'permissions': ['read', 'admin']
        },
      ]
    };
    return (response['users'] as List)
        .map((json) => UserModel.fromJson(json))
        .toList();
  }

  Future<List<PermissionModel>> fetchPermissions() async {
    await Future.delayed(Duration(seconds: 1)); // Simulate network delay
    final response = {
      'permissions': [
        {'id': 'read', 'name': 'Read Access'},
        {'id': 'write', 'name': 'Write Access'},
        {'id': 'admin', 'name': 'Admin Access'},
        {'id': 'delete', 'name': 'Delete Access'},
      ]
    };
    return (response['permissions'] as List)
        .map((json) => PermissionModel.fromJson(json))
        .toList();
  }

  Future<void> updateUserPermissions(
      int userId, List<String> permissions) async {
    await Future.delayed(Duration(seconds: 1)); // Simulate network delay
    print('Updated permissions for user $userId: $permissions');
  }
}
