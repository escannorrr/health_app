import 'dart:convert';
import 'package:health_app/core/app/constants.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SharedPrefsManager {
  static Future<void> saveCompletedExercise(String exerciseId) async {
    final prefs = await SharedPreferences.getInstance();
    final String today = DateTime.now().toIso8601String().split('T')[0];

    // Get the map of dates to completed exercises
    Map<String, List<String>> dateToExercisesMap = await _getDateToExercisesMap();

    // Initialize today's list if it doesn't exist
    if (!dateToExercisesMap.containsKey(today)) {
      dateToExercisesMap[today] = [];
    }

    // Add exercise to today's list if not already there
    if (!dateToExercisesMap[today]!.contains(exerciseId)) {
      dateToExercisesMap[today]!.add(exerciseId);

      // Save updated map back to preferences
      await _saveDateToExercisesMap(dateToExercisesMap);

      // Also update the legacy list for backward compatibility
      final List<String> completedExercises =
          prefs.getStringList(AppConstants.completedExercisesKey) ?? [];
      if (!completedExercises.contains(exerciseId)) {
        completedExercises.add(exerciseId);
        await prefs.setStringList(
            AppConstants.completedExercisesKey, completedExercises);
      }
    }
  }

  static Future<bool> isExerciseCompleted(String exerciseId) async {
    final String today = DateTime.now().toIso8601String().split('T')[0];
    Map<String, List<String>> dateToExercisesMap = await _getDateToExercisesMap();

    return dateToExercisesMap.containsKey(today) &&
        dateToExercisesMap[today]!.contains(exerciseId);
  }

  static Future<List<String>> getCompletedExercises() async {
    final String today = DateTime.now().toIso8601String().split('T')[0];
    Map<String, List<String>> dateToExercisesMap = await _getDateToExercisesMap();

    return dateToExercisesMap[today] ?? [];
  }

  static Future<bool> saveCompletedDate() async {
    final prefs = await SharedPreferences.getInstance();
    final String today = DateTime.now().toIso8601String().split('T')[0];

    List<String> completedDates = prefs.getStringList(AppConstants.completedDatesKey) ?? [];

    if (!completedDates.contains(today)) {
      completedDates.add(today);
      await prefs.setStringList(AppConstants.completedDatesKey, completedDates);
      return true;
    }

    return false;
  }

  static Future<List<DateTime>> getCompletedDates() async {
    final prefs = await SharedPreferences.getInstance();
    final List<String> datesStrings = prefs.getStringList(AppConstants.completedDatesKey) ?? [];

    return datesStrings.map((dateStr) => DateTime.parse(dateStr)).toList();
  }

  static Future<Map<String, List<String>>> _getDateToExercisesMap() async {
    final prefs = await SharedPreferences.getInstance();
    final String? mapJson = prefs.getString(AppConstants.dateToExercisesMapKey);

    if (mapJson == null || mapJson.isEmpty) {
      return {};
    }

    try {
      Map<String, dynamic> decoded = jsonDecode(mapJson);
      Map<String, List<String>> result = {};

      decoded.forEach((key, value) {
        if (value is List) {
          result[key] = List<String>.from(value);
        }
      });

      return result;
    } catch (e) {
      return {};
    }
  }

  static Future<void> _saveDateToExercisesMap(Map<String, List<String>> map) async {
    final prefs = await SharedPreferences.getInstance();
    final String mapJson = jsonEncode(map);
    await prefs.setString(AppConstants.dateToExercisesMapKey, mapJson);
  }
}
