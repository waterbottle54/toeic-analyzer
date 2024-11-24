import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import 'package:toeic_percent/models/user_result.dart';

class PreferencesService {

  static const String KEY_USER_RESULTS = "com.davidjo.toeic_percent.user_results";

  static Future<bool> saveUserResult(UserResult userResult) async {

    // Retrieve user results from shared preferences
    SharedPreferences pref = await SharedPreferences.getInstance();
    List<String> jsons = pref.getStringList(KEY_USER_RESULTS) ?? [];
    List<UserResult> results = jsons
        .map((json) => UserResult.fromMap(jsonDecode(json)))
        .toList();

    // Check if there is an existing user result
    int existing = results.indexWhere(
        (result) => result.referenceId == userResult.referenceId);

    // Add new user result or update existing one
    if (existing == -1) {
      results.add(userResult);
    } else {
      results[existing] = userResult;
    }

    // Save the modified user results to shared preferences
    List<String> modifiedJsonList =
        results.map((result) => jsonEncode(result.toMap())).toList();

    pref.setStringList(KEY_USER_RESULTS, modifiedJsonList);
    return (existing != -1);
  }

  static Future<void> deleteUserResult(String refId) async {
    // Retrieve user results from shared preferences
    SharedPreferences pref = await SharedPreferences.getInstance();
    List<String> jsons = pref.getStringList(KEY_USER_RESULTS) ?? [];
    List<UserResult> results = jsons
        .map((json) => UserResult.fromMap(jsonDecode(json)))
        .toList();

    // Remove any user result that has given id
    results.removeWhere((result) => result.referenceId == refId);

    // Save the modified user results to shared preferences
    List<String> modifiedJsonList =
    results.map((result) => jsonEncode(result.toMap())).toList();

    pref.setStringList(KEY_USER_RESULTS, modifiedJsonList);
  }

  static Future<List<UserResult>> getUserResult() async {

    // Retrieve user result lists from shared preferences
    SharedPreferences pref = await SharedPreferences.getInstance();
    List<String> jsons = pref.getStringList(KEY_USER_RESULTS) ?? [];
    List<UserResult> results = jsons
        .map((json) => UserResult.fromMap(jsonDecode(json)))
        .toList();

    results.sort((a, b) => a.date.compareTo(b.date));

    return results;
  }

}
