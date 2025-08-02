class AppUrls {
  static const String baseApiUrl = 'https://mydiaree.com.au';
  
  static const getCenters = "$baseApiUrl/api/centers";
  static const String login = '$baseApiUrl/api/login';
  static const String programPlan = '$baseApiUrl/api/programPlanList';
  static const String deletedataofprogramplan =
      '$baseApiUrl/api/LessonPlanList/deletedataofprogramplan';
  static const String programPlanCreate = '$baseApiUrl/api/programPlan/create';
  static const String getRoomUsers =
      '$baseApiUrl/api/LessonPlanList/get_room_users';
  static const String getRoomChildren =
      '$baseApiUrl/api/LessonPlanList/get_room_children';
  static const String addPlan =
      '$baseApiUrl/api/LessonPlanList/save_program_planinDB';
  static const String getReflections = '$baseApiUrl/api/reflection/index';
  static const String deleteReflection = '$baseApiUrl/api/reflection/delete';
  static const String addNewReflection = '$baseApiUrl/api/reflection/addnew';
  static const String getReflectionMeta = '$baseApiUrl/api/reflection/getMeta';
  static const String storeReflection = '$baseApiUrl/api/reflection/store';

  static const String getRooms = '$baseApiUrl/api/rooms';

  static const String addReflection = '$baseApiUrl/api/reflection/store';
  static const String bulkDeleteRooms = '$baseApiUrl/api/rooms/bulk-delete';
    static const String addRoom = '$baseApiUrl/api/room-create';
  ///////////////////////////////

  static const String signup = '$baseApiUrl/auth/signup';
  static const String otpVerify = '$baseApiUrl/auth/otp-verify';
  static const String forgotPassword = '$baseApiUrl/auth/forgot-password';

  static const String resetPassword = '$baseApiUrl/auth/resetPassword-password';


  static const String updateRoom = '$baseApiUrl/api/rooms/update';
  static const String deleteRoom = '$baseApiUrl/api/rooms/delete';
  static const String deleteMultipleRooms =
      '$baseApiUrl/api/rooms/delete-multiple';
  static const String getRoomDetails = '$baseApiUrl/api/rooms/details';
  static const getChildrenList = "$baseApiUrl/api/children";
  static const getEducators = "$baseApiUrl/api/educators";
  static const String addAnnouncement = '$baseApiUrl/api/announcement/add'; //
  static const String submitServiceDetails =
      '$baseApiUrl/api/submitServiceDetails';
  static const String getObservations = '$baseApiUrl/api/observations/list';
  static const String viewObservation = '$baseApiUrl/api/observations/view';
  static const String addOrEditObservation =
      '$baseApiUrl/api/observations/add-or-edit';
  static const String deleteObservations =
      '$baseApiUrl/api/observations/delete';

  ////

  static const String deleteReflections = '$baseApiUrl/reflection/delete';
  static const String addAccident = '$baseApiUrl/accident/add';
  static const String accidentList = '$baseApiUrl/accident/list';
  static const String deleteSleepChecklist =
      '$baseApiUrl/sleep-checklist/delete';
  static const String getSleepChecklist = '$baseApiUrl/sleep-checklist/list';
  static const String addSleepChecklist = '$baseApiUrl/sleep-addSleepChecklist';
  static const String getHeadChecks = '$baseApiUrl/head-getHeadChecks';
  static const String addHeadChecks = '$baseApiUrl/head-addHeadChecks';
  static const String addSnapshot = '$baseApiUrl/snapshot-addSnapshot';
  static const String addCenter = '$baseApiUrl/head-addCenter';
  static const String updateCenter = '$baseApiUrl/center-updateCenter';
  static const String deleteCenter = '$baseApiUrl/center-deleteCenter';
  static const String addSuperAdmin = '$baseApiUrl//settings/superadmin_store';
  static const String updateSuperAdmin = '$baseApiUrl/settings/superadmin';
  static const String deleteSuperAdmin = '$baseApiUrl/settings/superadmin';
  static const String staffStore = '$baseApiUrl/settings/staff/store';
  static const String staffUpdate = '$baseApiUrl/settings/staff';
  static const String staffDelete = '$baseApiUrl/settings/staff';
  static const String parentStore = '$baseApiUrl/settings/parent/store';
  static const String parentUpdate = '$baseApiUrl/settings/parent';
  static const String parentDelete = '$baseApiUrl/settings/parent';
  static const String addPermissions = '$baseApiUrl/settings/add_permissions';
  static const String getPermissions = '$baseApiUrl/settings/get_permissions';
}
