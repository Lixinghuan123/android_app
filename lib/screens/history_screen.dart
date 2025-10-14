import 'package:flutter/material.dart';
import '../services/emotion_data_service.dart';
import '../models/emotion.dart';
import '../constants/emotion_constants.dart';
import 'history_detail_screen.dart';

class HistoryScreen extends StatefulWidget {
  const HistoryScreen({super.key});

  @override
  State<HistoryScreen> createState() => _HistoryScreenState();
}

class _HistoryScreenState extends State<HistoryScreen> {
  Map<String, Map<String, List<EmotionRecord>>> historyRecords = {};
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadHistoryRecords();
  }

  Future<void> _loadHistoryRecords() async {
    final records = await EmotionDataService.getHistoryRecords();
    setState(() {
      historyRecords = records;
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F5),
      appBar: AppBar(
        title: const Text(
          '情绪搜集箱',
          style: TextStyle(
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
          
          // 历史记录列表
          Expanded(
            child: isLoading
                ? const Center(child: CircularProgressIndicator())
                : historyRecords.isEmpty
                    ? Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.archive_outlined,
                              size: 64,
                              color: Colors.grey.shade400,
                            ),
                            const SizedBox(height: 16),
                            Text(
                              '还没有历史记录',
                              style: TextStyle(
                                fontSize: 18,
                                color: Colors.grey.shade600,
                              ),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              '记录的情绪会在第二天自动归档到这里',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontSize: 14,
                                color: Colors.grey.shade500,
                              ),
                            ),
                          ],
                        ),
                      )
                    : ListView.builder(
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        itemCount: historyRecords.length,
                        itemBuilder: (context, index) {
                          final dateString = historyRecords.keys.elementAt(historyRecords.length - 1 - index);
                          final dayRecords = historyRecords[dateString]!;
                          
                          return _buildHistoryItem(dateString, dayRecords);
                        },
                      ),
          ),
        ],
      ),
    );
  }

  Widget _buildHistoryItem(String dateString, Map<String, List<EmotionRecord>> dayRecords) {
    // 计算当天的情绪统计
    Map<String, int> stats = {};
    int totalCount = 0;
    
    dayRecords.forEach((emotionName, records) {
      if (records.isNotEmpty) {
        stats[emotionName] = records.length;
        totalCount += records.length;
      }
    });

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: ListTile(
        contentPadding: const EdgeInsets.all(16),
        title: Text(
          EmotionDataService.formatDateForDisplay(dateString),
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 16,
          ),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 8),
            if (stats.isNotEmpty)
              Wrap(
                spacing: 8,
                runSpacing: 4,
                children: stats.entries.map((entry) {
                  final emotion = EmotionConstants.defaultEmotions
                      .firstWhere((e) => e.name == entry.key);
                  return Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                    decoration: BoxDecoration(
                      color: emotion.color.withOpacity(0.2),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Text(
                      '${emotion.emoji}×${entry.value}',
                      style: const TextStyle(fontSize: 12),
                    ),
                  );
                }).toList(),
              )
            else
              Text(
                '暂无记录',
                style: TextStyle(
                  color: Colors.grey.shade500,
                  fontSize: 12,
                ),
              ),
            const SizedBox(height: 4),
            Text(
              '共 $totalCount 条记录',
              style: TextStyle(
                color: Colors.grey.shade600,
                fontSize: 12,
              ),
            ),
          ],
        ),
        trailing: const Icon(
          Icons.chevron_right,
          color: Color(0xFF6B73FF),
        ),
        onTap: () {
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (context) => HistoryDetailScreen(
                dateString: dateString,
                dayRecords: dayRecords,
              ),
            ),
          );
        },
      ),
    );
  }
}