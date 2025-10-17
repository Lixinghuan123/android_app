import 'package:flutter/material.dart';
import '../models/emotion.dart';
import '../constants/emotion_constants.dart';
import '../services/emotion_data_service.dart';

class HistoryDetailScreen extends StatelessWidget {
  final String dateString;
  final Map<String, List<EmotionRecord>> dayRecords;

  const HistoryDetailScreen({
    super.key,
    required this.dateString,
    required this.dayRecords,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F5),
      appBar: AppBar(
        title: Text(
          EmotionDataService.formatDateForDisplay(dateString),
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        backgroundColor: const Color(0xFF6B73FF),
        elevation: 0,
        centerTitle: true,
        leading: IconButton(
          onPressed: () => Navigator.of(context).pop(),
          icon: const Icon(
            Icons.arrow_back,
            color: Colors.white,
          ),
        ),
      ),
      body: Column(
        children: [
          // 顶部装饰
          Container(
            height: 20,
            decoration: const BoxDecoration(
              color: Color(0xFF6B73FF),
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(20),
                bottomRight: Radius.circular(20),
              ),
            ),
          ),
          const SizedBox(height: 20),
          
          // 主要内容区域 - 复用主界面布局（只读模式）
          SizedBox(
            height: MediaQuery.of(context).size.height * 0.55,
            child: PageView.builder(
              itemCount: (EmotionConstants.defaultEmotions.length / 3).ceil(),
              itemBuilder: (context, pageIndex) {
                int startIndex = pageIndex * 3;
                int endIndex = (startIndex + 3).clamp(0, EmotionConstants.defaultEmotions.length);
                
                List<Emotion> pageEmotions = EmotionConstants.defaultEmotions
                    .sublist(startIndex, endIndex);
                
                return Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: pageEmotions.map((emotion) {
                      return Expanded(
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 8.0),
                          child: _ReadOnlyEmotionTube(
                            emotion: emotion,
                            records: dayRecords[emotion.name] ?? [],
                          ),
                        ),
                      );
                    }).toList(),
                  ),
                );
              },
            ),
          ),
          
          // 底部统计区域
          Expanded(
            child: Container(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  // 页面指示器
                  if (EmotionConstants.defaultEmotions.length > 3)
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: List.generate(
                        (EmotionConstants.defaultEmotions.length / 3).ceil(),
                        (index) => Container(
                          margin: const EdgeInsets.symmetric(horizontal: 4),
                          width: 8,
                          height: 8,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: Colors.grey.withOpacity(0.5),
                          ),
                        ),
                      ),
                    ),
                  
                  const SizedBox(height: 20),
                  
                  // 当日统计信息
                  Expanded(
                    child: Container(
                      width: double.infinity,
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.8),
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                          color: Colors.grey.shade200,
                        ),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Column(
                          children: [
                            Text(
                              '当日情绪统计',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                                color: Colors.grey.shade700,
                              ),
                            ),
                            const SizedBox(height: 12),
                            Expanded(
                              child: _buildDayStatistics(),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDayStatistics() {
    final stats = EmotionDataService.getTodayStatistics(dayRecords);
    
    if (stats.isEmpty) {
      return Center(
        child: Text(
          '当天没有情绪记录',
          textAlign: TextAlign.center,
          style: TextStyle(
            color: Colors.grey.shade500,
            fontSize: 14,
          ),
        ),
      );
    }

    return ListView.builder(
      itemCount: stats.length,
      itemBuilder: (context, index) {
        final emotionName = stats.keys.elementAt(index);
        final count = stats[emotionName]!;
        final emotion = EmotionConstants.defaultEmotions
            .firstWhere((e) => e.name == emotionName);

        return Padding(
          padding: const EdgeInsets.symmetric(vertical: 4.0),
          child: Row(
            children: [
              Text(
                emotion.emoji,
                style: const TextStyle(fontSize: 20),
              ),
              const SizedBox(width: 8),
              Text(
                emotionName,
                style: const TextStyle(fontSize: 14),
              ),
              const Spacer(),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                decoration: BoxDecoration(
                  color: emotion.color.withOpacity(0.3),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  '$count次',
                  style: const TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

// 只读版本的情绪试管
class _ReadOnlyEmotionTube extends StatelessWidget {
  final Emotion emotion;
  final List<EmotionRecord> records;

  const _ReadOnlyEmotionTube({
    required this.emotion,
    required this.records,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Emoji源头（不可点击，灰化）
        Container(
          width: 50,
          height: 50,
          decoration: BoxDecoration(
            color: Colors.grey.shade200,
            shape: BoxShape.circle,
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.2),
                blurRadius: 4,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Center(
            child: Text(
              emotion.emoji,
              style: TextStyle(
                fontSize: 24,
                color: Colors.grey.shade500,
              ),
            ),
          ),
        ),
        
        const SizedBox(height: 8),
        
        // 情绪名称
        Text(
          emotion.name,
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: Colors.grey.shade600,
          ),
        ),
        
        const SizedBox(height: 16),
        
        // 试管容器（只读）
        Expanded(
          child: Container(
            width: 80,
            decoration: BoxDecoration(
              color: emotion.color.withOpacity(0.1),
              borderRadius: BorderRadius.circular(40),
              border: Border.all(
                color: emotion.color.withOpacity(0.3),
                width: 2,
              ),
            ),
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.end,
                children: records.asMap().entries.map((entry) {
                  int index = entry.key;
                  EmotionRecord record = entry.value;
                  
                  return Padding(
                    padding: EdgeInsets.only(
                      bottom: index < records.length - 1 ? 4 : 0,
                    ),
                    child: GestureDetector(
                      onTap: () => _onEmojiTap(context, record),
                      child: Stack(
                        children: [
                          Container(
                            width: 36,
                            height: 36,
                            decoration: BoxDecoration(
                              color: Colors.white,
                              shape: BoxShape.circle,
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withOpacity(0.1),
                                  blurRadius: 4,
                                  offset: const Offset(0, 2),
                                ),
                              ],
                            ),
                            child: Center(
                              child: Text(
                                record.emoji,
                                style: const TextStyle(fontSize: 20),
                              ),
                            ),
                          ),
                          // 备注标记
                          if (record.note != null && record.note!.isNotEmpty)
                            Positioned(
                              right: 2,
                              top: 2,
                              child: Container(
                                width: 8,
                                height: 8,
                                decoration: const BoxDecoration(
                                  color: Color(0xFF6B73FF),
                                  shape: BoxShape.circle,
                                ),
                              ),
                            ),
                        ],
                      ),
                    ),
                  );
                }).toList(),
              ),
            ),
          ),
        ),
      ],
    );
  }

  void _onEmojiTap(BuildContext context, EmotionRecord record) {
    if (record.note != null && record.note!.isNotEmpty) {
      // 显示备注（只读）
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: Text('${record.emoji} 备注'),
          content: Text(record.note!),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('关闭'),
            ),
          ],
        ),
      );
    } else {
      // 显示提示
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('此记录暂无备注'),
          duration: Duration(seconds: 1),
        ),
      );
    }
  }
}