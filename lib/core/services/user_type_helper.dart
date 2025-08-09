import 'package:shared_preferences/shared_preferences.dart';

class UserTypeHelper {
  static const _userTypeKey = 'user_type';

  static String? _userType;  
  static Future<void> init() async {
    final prefs = await SharedPreferences.getInstance();
    _userType = prefs.getString(_userTypeKey);
  }
 
  static Future<void> saveUserType(String userType) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_userTypeKey, userType);
    _userType = userType;
  }
  
  static Future<void> clearUserType() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_userTypeKey);
    _userType = null;
  }
 
  static bool get isSuperAdmin =>
      _userType?.toLowerCase() == 'superadmin';

  static bool get isParent =>
      _userType?.toLowerCase() == 'parent';

  static bool get isUser =>
      _userType?.toLowerCase() == 'user';

  static String? get userType => _userType;
}
