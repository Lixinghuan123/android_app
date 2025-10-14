import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/emotion.dart';

class EmotionDataService {
  static const String _todayRecordsKey = 'today_emotion_records';
  static const String _historyRecordsKey = 'history_emotion_records';
  static const String _lastDateKey = 'last_date';

  // 获取今日数据
  static Future<Map<String, List<EmotionRecord>>> getTodayRecords() async {
    final prefs = await SharedPreferences.getInstance();
    final today = _getTodayDateString();
    final lastDate = prefs.getString(_lastDateKey);

    // 检查是否需要重置（新的一天）
    if (lastDate != null && lastDate != today) {
      await _archiveTodayRecords();
      await _clearTodayRecords();
    }

    // 获取今日记录
    final recordsJson = prefs.getString(_todayRecordsKey);
    Map<String, List<EmotionRecord>> records = {};

    if (recordsJson != null) {
      final Map<String, dynamic> data = json.decode(recordsJson);
      data.forEach((emotionName, recordsList) {
        records[emotionName] = (recordsList as List)
            .map((record) => EmotionRecord.fromJson(record))
            .toList();
      });
    }

    // 更新最后访问日期
    await prefs.setString(_lastDateKey, today);

    return records;
  }

  // 保存今日数据
  static Future<void> saveTodayRecords(Map<String, List<EmotionRecord>> records) async {
    final prefs = await SharedPreferences.getInstance();
    
    Map<String, dynamic> data = {};
    records.forEach((emotionName, recordsList) {
      data[emotionName] = recordsList.map((record) => record.toJson()).toList();
    });

    await prefs.setString(_todayRecordsKey, json.encode(data));
    await prefs.setString(_lastDateKey, _getTodayDateString());
  }

  // 归档今日记录到历史
  static Future<void> _archiveTodayRecords() async {
    final prefs = await SharedPreferences.getInstance();
    final recordsJson = prefs.getString(_todayRecordsKey);
    
    if (recordsJson != null && recordsJson.isNotEmpty) {
      // 获取历史记录
      final historyJson = prefs.getString(_historyRecordsKey);
      Map<String, dynamic> history = {};
      
      if (historyJson != null) {
        history = json.decode(historyJson);
      }

      // 添加昨日记录到历史
      final lastDate = prefs.getString(_lastDateKey);
      if (lastDate != null) {
        history[lastDate] = json.decode(recordsJson);
      }

      // 保存历史记录
      await prefs.setString(_historyRecordsKey, json.encode(history));
    }
  }

  // 清空今日记录
  static Future<void> _clearTodayRecords() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_todayRecordsKey);
  }

  // 获取历史记录
  static Future<Map<String, Map<String, List<EmotionRecord>>>> getHistoryRecords() async {
    final prefs = await SharedPreferences.getInstance();
    final historyJson = prefs.getString(_historyRecordsKey);
    
    Map<String, Map<String, List<EmotionRecord>>> history = {};
    
    if (historyJson != null) {
      final Map<String, dynamic> data = json.decode(historyJson);
      data.forEach((date, dayRecords) {
        Map<String, List<EmotionRecord>> dayData = {};
        (dayRecords as Map<String, dynamic>).forEach((emotionName, recordsList) {
          dayData[emotionName] = (recordsList as List)
              .map((record) => EmotionRecord.fromJson(record))
              .toList();
        });
        history[date] = dayData;
      });
    }
    
    return history;
  }

  // 获取今日日期字符串
  static String _getTodayDateString() {
    final now = DateTime.now();
    return '${now.year}-${now.month.toString().padLeft(2, '0')}-${now.day.toString().padLeft(2, '0')}';
  }

  // 手动触发归档（用于测试或手动操作）
  static Future<void> manualArchive() async {
    await _archiveTodayRecords();
    await _clearTodayRecords();
  }

  // 获取今日统计信息
  static Map<String, int> getTodayStatistics(Map<String, List<EmotionRecord>> records) {
    Map<String, int> stats = {};
    records.forEach((emotionName, recordsList) {
      if (recordsList.isNotEmpty) {
        stats[emotionName] = recordsList.length;
      }
    });
    return stats;
  }

  // 格式化日期显示
  static String formatDateForDisplay(String dateString) {
    try {
      final date = DateTime.parse(dateString);
      final weekdays = ['周一', '周二', '周三', '周四', '周五', '周六', '周日'];
      final weekday = weekdays[date.weekday - 1];
      return '${date.month}月${date.day}日 $weekday';
    } catch (e) {
      return dateString;
    }
  }
}