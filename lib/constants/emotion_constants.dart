import 'package:flutter/material.dart';
import '../models/emotion.dart';

// 预定义的7种情绪
class EmotionConstants {
  static final List<Emotion> defaultEmotions = [
    Emotion(
      name: '开心',
      emoji: '😊',
      color: Color(0xFFFFE082), // 温暖黄色
    ),
    Emotion(
      name: '难过',
      emoji: '😢',
      color: Color(0xFF81D4FA), // 淡蓝色
    ),
    Emotion(
      name: '愤怒',
      emoji: '😠',
      color: Color(0xFFFFAB91), // 淡红色
    ),
    Emotion(
      name: '平静',
      emoji: '😌',
      color: Color(0xFFC8E6C9), // 淡绿色
    ),
    Emotion(
      name: '焦虑',
      emoji: '😰',
      color: Color(0xFFD1C4E9), // 淡紫色
    ),
    Emotion(
      name: '疲惫',
      emoji: '😴',
      color: Color(0xFFBCAAA4), // 淡棕色
    ),
    Emotion(
      name: '惊喜',
      emoji: '😲',
      color: Color(0xFFF8BBD9), // 淡粉色
    ),
  ];
}