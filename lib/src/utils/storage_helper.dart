import 'package:shared_preferences/shared_preferences.dart';

class StorageHelper {
  static const String keyUserId = "userId";
  static const String keyAccessToken = "accessToken";
  static const String keyRefreshToken = "refreshToken";
  static const String keyStaffType = "staffType";
  static const String keyIsLoggedIn = "isLoggedIn";
  static const String keyPocId = "pocId";

  ///  Save Login Response Data
  static Future<void> saveLoginData({
    required int userId,
    required String accessToken,
    required String refreshToken,
    required String staffType,
    required int pocId,
  }) async {
    final prefs = await SharedPreferences.getInstance();

    await prefs.setInt(keyUserId, userId);
    await prefs.setInt(keyPocId, pocId);
    await prefs.setString(keyAccessToken, accessToken);
    await prefs.setString(keyRefreshToken, refreshToken);
    await prefs.setString(keyStaffType, staffType);
    await prefs.setBool(keyIsLoggedIn, true);

    print(" Login data saved successfully!");
  }

  ///  Getters
  static Future<int?> getUserId() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getInt(keyUserId);
  }

  static Future<int?> getPocId() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getInt(keyPocId);
  }

  static Future<String?> getAccessToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(keyAccessToken);
  }

  static Future<String?> getRefreshToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(keyRefreshToken);
  }

  static Future<String?> getStaffType() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(keyStaffType);
  }

  static Future<bool> isLoggedIn() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(keyIsLoggedIn) ?? false;
  }

  ///  Logout and clear data
  static Future<void> clearData() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.clear();
    print(" Cleared user session data");
  }
}
