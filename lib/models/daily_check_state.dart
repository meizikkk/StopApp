import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

import 'daily_check_record.dart';

class DailyCheckState {
  static const String _checkRecordKey = 'daily_check_record';

  static Future<DailyCheckRecord?> getTodayRecord() async {
    final prefs = await SharedPreferences.getInstance();
    final recordStr = prefs.getString(_checkRecordKey);
    if (recordStr == null) return null;

    final record = DailyCheckRecord.fromJson(jsonDecode(recordStr));
    if (!_isToday(record.checkTime)) return null;
    return record;
  }

  static Future<void> saveRecord(DailyCheckRecord record) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_checkRecordKey, jsonEncode(record.toJson()));
  }

  static bool _isToday(DateTime date) {
    final now = DateTime.now();
    final today5AM = DateTime(now.year, now.month, now.day, 5);
    final tomorrow5AM = today5AM.add(const Duration(days: 1));
    return date.isAfter(today5AM) && date.isBefore(tomorrow5AM);
  }
}
