import 'package:flutter/material.dart';

// 情绪数据模型
class Emotion {
  final String name;
  final String emoji;
  final Color color;

  const Emotion({
    required this.name,
    required this.emoji,
    required this.color,
  });
}

class EmotionRecord {
  final String id;
  final String emotionName;
  final String emoji;
  final DateTime createdAt;
  String? note;

  EmotionRecord({
    required this.id,
    required this.emotionName,
    required this.emoji,
    required this.createdAt,
    this.note,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'emotionName': emotionName,
      'emoji': emoji,
      'createdAt': createdAt.millisecondsSinceEpoch,
      'note': note,
    };
  }

  factory EmotionRecord.fromJson(Map<String, dynamic> json) {
    return EmotionRecord(
      id: json['id'],
      emotionName: json['emotionName'],
      emoji: json['emoji'],
      createdAt: DateTime.fromMillisecondsSinceEpoch(json['createdAt']),
      note: json['note'],
    );
  }
}