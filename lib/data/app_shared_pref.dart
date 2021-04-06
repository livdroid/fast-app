import 'package:shared_preferences/shared_preferences.dart';

class AppSharedPreferences {
  //Fasting
  static const String IS_FASTING = 'is_fasting';

  static const String SELECTED_PROGRAM = 'selected_program';
  static const String PROGRAM_END_TIME = 'program_end_time';
  static const String PROGRAM_START_TIME = 'program_start_time';

  //Not Fasting
  static const String LAST_PROGRAM = 'last_program';
  static const String LAST_FAST_DAY = 'last_fast_day';
  //in seconds
  static const String TOTAL_FAST_TIME = 'total_fast_time';
  static const String TOTAL_FAST_COUNT = 'total_fast_count';

  static Future<void> saveData(String key, String value) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString(key, value);
  }

  static Future<String> getData(String key) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString(key) ?? "0";
  }

  static Future<void> setFastingStatus(String key, bool value) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setBool(key, value);
  }

  static Future<bool> getFastingStatus() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getBool(IS_FASTING) ?? false;
  }
}
