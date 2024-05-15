import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

class StorageService {
  static const String _keyDiaries = 'diaries';

  Future<void> saveDiary(String dateTime, String content) async {
    final prefs = await SharedPreferences.getInstance();
    final List<String> diaries = prefs.getStringList(_keyDiaries) ?? [];
    final String diaryEntry =
        jsonEncode({'dateTime': dateTime, 'content': content});
    diaries.insert(0, diaryEntry); // 최신글을 위로
    await prefs.setStringList(_keyDiaries, diaries);
  }

  Future<void> saveDiaries(List<Map<String, String>> diaries) async {
    final prefs = await SharedPreferences.getInstance();
    final List<String> diaryStrings =
        diaries.map((diary) => jsonEncode(diary)).toList();
    await prefs.setStringList(_keyDiaries, diaryStrings);
  }

  Future<List<Map<String, String>>> loadDiaries() async {
    final prefs = await SharedPreferences.getInstance();
    final List<String> diaries = prefs.getStringList(_keyDiaries) ?? [];
    return diaries
        .map((diary) => Map<String, String>.from(jsonDecode(diary)))
        .toList();
  }
}
