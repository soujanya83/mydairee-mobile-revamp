class AppUrls {
  // Base URLs
  static const String baseApiUrl = '';

  // Auth endpoints
  static const String login = '$baseApiUrl/auth/login';
  static const String signup = '$baseApiUrl/auth/signup';
  static const String otpVerify = '$baseApiUrl/auth/otp-verify';
  static const String forgotPassword = '$baseApiUrl/auth/forgot-password';

  static const String resetPassword = '$baseApiUrl/auth/resetPassword-password';

  static const String getRooms = '$baseApiUrl/api/rooms/list';
  static const String addRoom = '$baseApiUrl/api/rooms/add';
  static const String updateRoom = '$baseApiUrl/api/rooms/update';
  static const String deleteRoom = '$baseApiUrl/api/rooms/delete';
  static const String deleteMultipleRooms =
      '$baseApiUrl/api/rooms/delete-multiple';
  static const String getRoomDetails = '$baseApiUrl/api/rooms/details';
  static const getCenterList = "$baseApiUrl/api/centers";
  static const getChildrenList = "$baseApiUrl/api/children";
  static const getEducators = "$baseApiUrl/api/educators";
  static const String addPlan = '$baseApiUrl/api/plans/add';
  static const String addAnnouncement = '$baseApiUrl/api/announcement/add'; //
  static const String submitServiceDetails =
      '$baseApiUrl/api/submitServiceDetails';
  static const String getObservations = '$baseApiUrl/api/observations/list';
  static const String viewObservation = '$baseApiUrl/api/observations/view';
  static const String addOrEditObservation =
      '$baseApiUrl/api/observations/add-or-edit';
  static const String deleteObservations =
      '$baseApiUrl/api/observations/delete';

  static const String getReflections = '$baseApiUrl/reflection/list';
  static const String deleteReflections = '$baseApiUrl/reflection/delete';
  static const String addReflection = '$baseApiUrl/reflection/add';
  static const String addAccident = '$baseApiUrl/accident/add';
  static const String accidentList = '$baseApiUrl/accident/list';
  static const String deleteSleepChecklist = '$baseApiUrl/sleep-checklist/delete';
  static const String getSleepChecklist = '$baseApiUrl/sleep-checklist/list';
  static const String addSleepChecklist = '$baseApiUrl/sleep-addSleepChecklist';
  static const String getHeadChecks = '$baseApiUrl/head-getHeadChecks';
  static const String addHeadChecks = '$baseApiUrl/head-addHeadChecks';
  static const String addSnapshot = '$baseApiUrl/snapshot-addSnapshot';
}
