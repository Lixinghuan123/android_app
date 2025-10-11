import 'package:flutter/material.dart';
import '../constants/emotion_constants.dart';
import '../models/emotion.dart';
import '../widgets/emotion_tube.dart';

class EmotiTubeScreen extends StatefulWidget {
  const EmotiTubeScreen({super.key});

  @override
  State<EmotiTubeScreen> createState() => _EmotiTubeScreenState();
}

class _EmotiTubeScreenState extends State<EmotiTubeScreen> {
  final PageController _pageController = PageController();
  
  // 当前日期的情绪记录
  Map<String, List<EmotionRecord>> todayRecords = {};

  @override
  void initState() {
    super.initState();
    // 为每种情绪初始化空的记录列表
    for (var emotion in EmotionConstants.defaultEmotions) {
      todayRecords[emotion.name] = [];
    }
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  // 自定义试管按钮 - 开发接口
  Widget _buildCustomTubeButton() {
    return Column(
      children: [
        // 添加按钮
        GestureDetector(
          onTap: () {
            // TODO: 打开自定义试管创建页面
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('自定义试管功能即将开发 🚀'),
                backgroundColor: Color(0xFF6B73FF),
              ),
            );
          },
          child: Container(
            width: 50,
            height: 50,
            decoration: BoxDecoration(
              color: Colors.grey.shade200,
              shape: BoxShape.circle,
              border: Border.all(
                color: Colors.grey.shade400,
                width: 2,
                style: BorderStyle.solid,
              ),
            ),
            child: const Icon(
              Icons.add,
              size: 30,
              color: Colors.grey,
            ),
          ),
        ),
        
        const SizedBox(height: 8),
        
        // 标签
        Text(
          '自定义',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: Colors.grey.shade600,
          ),
        ),
        
        const SizedBox(height: 16),
        
        // 占位试管
        Expanded(
          child: Container(
            width: 80,
            decoration: BoxDecoration(
              color: Colors.grey.shade100,
              borderRadius: BorderRadius.circular(40),
              border: Border.all(
                color: Colors.grey.shade300,
                width: 2,
                style: BorderStyle.solid,
              ),
            ),
            child: Center(
              child: Text(
                '即将\n开放',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Colors.grey.shade500,
                  fontSize: 12,
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F5),
      appBar: AppBar(
        title: const Text(
          'EmotiTube',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        backgroundColor: const Color(0xFF6B73FF),
        elevation: 0,
        centerTitle: true,
        actions: [
          // 情绪搜集箱入口
          IconButton(
            onPressed: () {
              // TODO: 导航到历史记录页面
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('历史记录功能即将开发')),
              );
            },
            icon: const Icon(
              Icons.archive_outlined,
              color: Colors.white,
            ),
            tooltip: '情绪搜集箱',
          ),
        ],
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
          
          // 主要内容区域 - 调整为屏幕的55%高度
          SizedBox(
            height: MediaQuery.of(context).size.height * 0.55,
            child: PageView.builder(
              controller: _pageController,
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
                    children: [
                      ...pageEmotions.map((emotion) {
                        return Expanded(
                          child: Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 8.0),
                            child: EmotionTube(
                              emotion: emotion,
                              records: todayRecords[emotion.name] ?? [],
                              onEmotionAdded: (record) {
                                setState(() {
                                  todayRecords[emotion.name]?.add(record);
                                });
                              },
                              onRecordRemoved: (recordId) {
                                setState(() {
                                  todayRecords[emotion.name]?.removeWhere(
                                    (record) => record.id == recordId,
                                  );
                                });
                              },
                            ),
                          ),
                        );
                      }).toList(),
                      
                      // 自定义试管添加按钮 - 开发接口预留
                      if (pageEmotions.length < 3) // 只在最后一页且不满3个时显示
                        Expanded(
                          child: Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 8.0),
                            child: _buildCustomTubeButton(),
                          ),
                        ),
                    ],
                  ),
                );
              },
            ),
          ),
          
          // 底部区域 - 预留空间
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
                  
                  // 底部信息展示区域（预留）
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
                      child: Center(
                        child: Text(
                          '今日情绪统计\n（后续功能）',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: Colors.grey.shade500,
                            fontSize: 14,
                          ),
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
}