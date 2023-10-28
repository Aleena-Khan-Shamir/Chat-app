import 'package:shared_preferences/shared_preferences.dart';

class LocalStorage {
  static late SharedPreferences _sharedPreferences;

  // to write data local storage
  static Future<void> saveUserInfo({
    required String uid,
    required String email,
    required String displayName,
    required String photoUrl,
  }) async {
    await _sharedPreferences.setStringList(
      'userInfo',
      [uid, email, displayName, photoUrl],
    );
  }

  // to remove data from local storage
  static Future<void> removeUserInfo() async {
    await _sharedPreferences.remove('userInfo');
  }

  static Future<void> init() async {
    _sharedPreferences = await SharedPreferences.getInstance();
  }
}
