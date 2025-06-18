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
}
