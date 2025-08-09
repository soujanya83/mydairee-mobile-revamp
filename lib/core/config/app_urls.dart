class AppUrls {
  static const String baseUrl = 'https://mydiaree.com.au';
  
  static const getCenters = "$baseUrl/api/centers";
  static const String login = '$baseUrl/api/login';
  static const String programPlan = '$baseUrl/api/programPlanList';
  static const String deletedataofprogramplan =
      '$baseUrl/api/LessonPlanList/deletedataofprogramplan';
  static const String programPlanCreate = '$baseUrl/api/programPlan/create';
  static const String getRoomUsers =
      '$baseUrl/api/LessonPlanList/get_room_users';
  static const String getRoomChildren =
      '$baseUrl/api/LessonPlanList/get_room_children';
  static const String addPlan =
      '$baseUrl/api/LessonPlanList/save_program_planinDB';
  static const String getReflections = '$baseUrl/api/reflection/index';
  static const String deleteReflection = '$baseUrl/api/reflection/delete';
  static const String addNewReflection = '$baseUrl/api/reflection/addnew';
  static const String getReflectionMeta = '$baseUrl/api/reflection/getMeta';
  static const String storeReflection = '$baseUrl/api/reflection/store';

  static const String getRooms = '$baseUrl/api/rooms';

  static const String addReflection = '$baseUrl/api/reflection/store';
  static const String bulkDeleteRooms = '$baseUrl/api/rooms/bulk-delete';
    static const String addRoom = '$baseUrl/api/room-create';
  ///////////////////////////////

  static const String signup = '$baseUrl/auth/signup';
  static const String otpVerify = '$baseUrl/auth/otp-verify';
  static const String forgotPassword = '$baseUrl/auth/forgot-password';

  static const String resetPassword = '$baseUrl/auth/resetPassword-password';


  static const String updateRoom = '$baseUrl/api/rooms/update';
  static const String deleteRoom = '$baseUrl/api/rooms/delete';
  static const String deleteMultipleRooms =
      '$baseUrl/api/rooms/delete-multiple';
  static const String getRoomDetails = '$baseUrl/api/rooms/details';
  static const getChildrenList = "$baseUrl/api/children";
  static const getEducators = "$baseUrl/api/educators";
  static const String addAnnouncement = '$baseUrl/api/announcement/add'; //
  static const String submitServiceDetails =
      '$baseUrl/api/submitServiceDetails';
  static const String getObservations = '$baseUrl/api/observations/list';
  static const String viewObservation = '$baseUrl/api/observations/view';
  static const String addOrEditObservation =
      '$baseUrl/api/observations/add-or-edit';
  static const String deleteObservations =
      '$baseUrl/api/observations/delete';

  ////

  static const String deleteReflections = '$baseUrl/reflection/delete';
  static const String addAccident = '$baseUrl/accident/add';
  static const String accidentList = '$baseUrl/accident/list';
  static const String deleteSleepChecklist =
      '$baseUrl/sleep-checklist/delete';
  static const String getSleepChecklist = '$baseUrl/sleep-checklist/list';
  static const String addSleepChecklist = '$baseUrl/sleep-addSleepChecklist';
  static const String getHeadChecks = '$baseUrl/head-getHeadChecks';
  static const String addHeadChecks = '$baseUrl/head-addHeadChecks';
  static const String addSnapshot = '$baseUrl/snapshot-addSnapshot';
  static const String addCenter = '$baseUrl/head-addCenter';
  static const String updateCenter = '$baseUrl/center-updateCenter';
  static const String deleteCenter = '$baseUrl/center-deleteCenter';
  static const String addSuperAdmin = '$baseUrl//settings/superadmin_store';
  static const String updateSuperAdmin = '$baseUrl/settings/superadmin';
  static const String deleteSuperAdmin = '$baseUrl/settings/superadmin';
  static const String staffStore = '$baseUrl/settings/staff/store';
  static const String staffUpdate = '$baseUrl/settings/staff';
  static const String staffDelete = '$baseUrl/settings/staff';
  static const String parentStore = '$baseUrl/settings/parent/store';
  static const String parentUpdate = '$baseUrl/settings/parent';
  static const String parentDelete = '$baseUrl/settings/parent';
  static const String addPermissions = '$baseUrl/settings/add_permissions';
  static const String getPermissions = '$baseUrl/settings/get_permissions';
}
