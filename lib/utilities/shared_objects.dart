import 'package:aulare/utilities/constants.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SharedObjects {
  static late CachedSharedPreferences preferences;
}

class CachedSharedPreferences {
  static SharedPreferences? sharedPreferences;
  static CachedSharedPreferences? instance;
  static final cachedKeyList = {
    Constants.firstRun,
    Constants.sessionUserId,
    Constants.sessionUsername,
    // Constants.sessionName,
    // Constants.sessionProfilePictureUrl,
    // Constants.configDarkMode,
    // Constants.configMessagePaging,
    // Constants.configMessagePeek,
  };
  static final sessionKeyList = {
    // Constants.sessionName,
    Constants.sessionUserId,
    Constants.sessionUsername,
    // Constants.sessionProfilePictureUrl
  };

  static Map<String, dynamic> map = {};

  static Future<CachedSharedPreferences?> getInstance() async {
    sharedPreferences = await SharedPreferences.getInstance();
    if (sharedPreferences!.getBool(Constants.firstRun) == null ||
        sharedPreferences!.get(Constants.firstRun) as bool) {
      // if first run, then set these values
      // await sharedPreferences!.setBool(Constants.configDarkMode, false);
      // await sharedPreferences!.setBool(Constants.configMessagePaging, false);
      // await sharedPreferences!.setBool(Constants.configImageCompression, true);
      // await sharedPreferences!.setBool(Constants.configMessagePeek, true);
      await sharedPreferences!.setBool(Constants.firstRun, false);
    }
    for (final key in cachedKeyList) {
      map[key] = sharedPreferences!.get(key);
    }

    instance ??= CachedSharedPreferences();
    return instance;
  }

  String? getString(String key) {
    if (cachedKeyList.contains(key)) {
      return map[key];
    }
    return sharedPreferences!.getString(key);
  }

  bool? getBool(String key) {
    if (cachedKeyList.contains(key)) {
      return map[key];
    }
    return sharedPreferences!.getBool(key);
  }

  Future<bool> setString(String key, String value) async {
    final result = await sharedPreferences!.setString(key, value);
    if (result) map[key] = value;
    return result;
  }

  Future<bool> setBool(String key, bool value) async {
    final bool result = await sharedPreferences!.setBool(key, value);
    if (result) map[key] = value;
    return result;
  }

  Future<void> clearAll() async {
    await sharedPreferences!.clear();
    map = {};
  }

  Future<void> clearSession() async {
    // await sharedPreferences!.remove(Constants.sessionProfilePictureUrl);
    await sharedPreferences!.remove(Constants.sessionUsername);
    await sharedPreferences!.remove(Constants.sessionUserId);
    // await sharedPreferences!.remove(Constants.sessionName);
    map.removeWhere((k, v) => sessionKeyList.contains(k));
  }
}
