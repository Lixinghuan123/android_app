import 'package:flutter/material.dart';
import '../models/emotion.dart';
import '../screens/note_edit_screen.dart';
import 'note_bubble.dart';
import 'note_bubble_overlay.dart';

class EmotionTube extends StatefulWidget {
  final Emotion emotion;
  final List<EmotionRecord> records;
  final Function(EmotionRecord) onEmotionAdded;
  final Function(String) onRecordRemoved;
  final Function(EmotionRecord) onRecordUpdated;

  const EmotionTube({
    super.key,
    required this.emotion,
    required this.records,
    required this.onEmotionAdded,
    required this.onRecordRemoved,
    required this.onRecordUpdated,
  });

  @override
  State<EmotionTube> createState() => _EmotionTubeState();
}

class _EmotionTubeState extends State<EmotionTube>
    with TickerProviderStateMixin {
  late AnimationController _dropController;
  late Animation<double> _dropAnimation;
  bool _isDropping = false;
  
  // 气泡显示相关状态 - 支持多个气泡
  Map<String, OverlayEntry> _overlayEntries = {};
  Set<String> _showingBubbleForRecords = {};
  Map<String, LayerLink> _layerLinks = {};

  @override
  void initState() {
    super.initState();
    _dropController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );
    
    _dropAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _dropController,
      curve: Curves.bounceOut,
    ));
  }

  @override
  void dispose() {
    _dropController.dispose();
    _dismissBubble();
    _layerLinks.clear();
    super.dispose();
  }
  
  void _dismissBubble([String? recordId]) {
    if (recordId != null) {
      // 关闭特定气泡
      _overlayEntries[recordId]?.remove();
      _overlayEntries.remove(recordId);
      _showingBubbleForRecords.remove(recordId);
    } else {
      // 关闭所有气泡
      for (var entry in _overlayEntries.values) {
        entry.remove();
      }
      _overlayEntries.clear();
      _showingBubbleForRecords.clear();
    }
  }

  void _addEmotion() async {
    if (_isDropping) return;
    
    setState(() {
      _isDropping = true;
    });

    // 播放掉落动画
    await _dropController.forward();

    // 创建新的情绪记录
    final record = EmotionRecord(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      emotionName: widget.emotion.name,
      emoji: widget.emotion.emoji,
      createdAt: DateTime.now(),
    );
    
    // 添加记录
    widget.onEmotionAdded(record);
    
    // 重置动画
    _dropController.reset();
    
    setState(() {
      _isDropping = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Emoji源头（可点击）
        GestureDetector(
          onTap: _addEmotion,
          child: Container(
            width: 50,
            height: 50,
            decoration: BoxDecoration(
              color: Colors.white,
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                  color: widget.emotion.color.withOpacity(0.3),
                  blurRadius: 8,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Center(
              child: Text(
                widget.emotion.emoji,
                style: const TextStyle(fontSize: 24),
              ),
            ),
          ),
        ),
        
        const SizedBox(height: 8),
        
        // 情绪名称
        Text(
          widget.emotion.name,
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: Colors.black87,
          ),
        ),
        
        const SizedBox(height: 16),
        
        // 试管容器
        Expanded(
          child: Container(
            width: 80,
            decoration: BoxDecoration(
              color: widget.emotion.color.withOpacity(0.1),
              borderRadius: BorderRadius.circular(40),
              border: Border.all(
                color: widget.emotion.color.withOpacity(0.3),
                width: 2,
              ),
            ),
            child: Stack(
              children: [
                // 试管内的emoji球
                Positioned.fill(
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: SingleChildScrollView(
                      reverse: true,
                      child: Column(                
                        verticalDirection: VerticalDirection.up,// 从下往上排列
                        children: widget.records.asMap().entries.map((entry) {
                          int index = entry.key;
                          EmotionRecord record = entry.value;
                          
                          return Padding(
                            padding: EdgeInsets.only(
                              bottom: index < widget.records.length - 1 ? 4 : 0,
                            ),
                            child: GestureDetector(
                              onTap: () => _onEmojiTap(record),
                              onDoubleTap: () => _onEmojiDoubleTap(record),
                              onLongPress: () => _onEmojiLongPress(record),
                              child: Stack(
                                children: [
                                  CompositedTransformTarget(
                                    link: _layerLinks.putIfAbsent(record.id, () => LayerLink()),
                                    child: Container(
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
                
                // 掉落动画中的emoji
                if (_isDropping)
                  AnimatedBuilder(
                    animation: _dropAnimation,
                    builder: (context, child) {
                      // 计算最终落点：试管底部减去已有emoji的高度
                      double containerHeight = MediaQuery.of(context).size.height * 0.55 - 120; // 试管可用高度
                      double finalPosition = containerHeight - 16 - (widget.records.length * 40); // 8px padding + 每个emoji 40px高度
                      
                      return Positioned(
                        top: _dropAnimation.value * finalPosition,
                        left: 22, // 居中位置
                        child: Container(
                          width: 36,
                          height: 36,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            shape: BoxShape.circle,
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.2),
                                blurRadius: 6,
                                offset: const Offset(0, 3),
                              ),
                            ],
                          ),
                          child: Center(
                            child: Text(
                              widget.emotion.emoji,
                              style: const TextStyle(fontSize: 20),
                            ),
                          ),
                        ),
                      );
                    },
                  ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  void _onEmojiTap(EmotionRecord record) {
    if (record.note != null && record.note!.isNotEmpty) {
      // 如果已经显示了这个记录的气泡，则直接进入编辑页面
      if (_showingBubbleForRecords.contains(record.id)) {
        _openNoteEditScreen(record);
        return;
      }
      
      // 显示新的气泡（不关闭其他气泡）
      _showNoteBubble(record);
    } else {
      // 显示提示
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('暂无备注，双击可添加'),
          duration: Duration(seconds: 1),
        ),
      );
    }
  }
  
  void _showNoteBubble(EmotionRecord record) {
    _showingBubbleForRecords.add(record.id);
    
    final overlayEntry = OverlayEntry(
      builder: (context) => NoteBubbleOverlay(
        layerLink: _layerLinks[record.id]!,
        onDismiss: () => _dismissBubble(record.id),
        child: NoteBubble(
          note: record.note!,
          onTap: () => _openNoteEditScreen(record),
          onDismiss: () => _dismissBubble(record.id),
        ),
      ),
    );
    
    _overlayEntries[record.id] = overlayEntry;
    Overlay.of(context).insert(overlayEntry);
  }

  void _onEmojiDoubleTap(EmotionRecord record) {
    _openNoteEditScreen(record);
  }
  
  void _openNoteEditScreen(EmotionRecord record) {
    _dismissBubble(record.id); // 关闭对应的气泡
    
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => NoteEditScreen(
          record: record,
          onSave: (updatedRecord) {
            widget.onRecordUpdated(updatedRecord);
          },
        ),
      ),
    );
  }

  void _onEmojiLongPress(EmotionRecord record) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('删除确认'),
        content: const Text('确认删除这条情绪记录吗？此操作不可撤销。'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('取消'),
          ),
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
              widget.onRecordRemoved(record.id);
            },
            style: TextButton.styleFrom(foregroundColor: Colors.red),
            child: const Text('确认删除'),
          ),
        ],
      ),
    );
  }
}