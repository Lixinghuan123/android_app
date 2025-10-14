import 'package:flutter/material.dart';

class NoteEditDialog extends StatefulWidget {
  final String? initialNote;
  final String emoji;
  final String emotionName;

  const NoteEditDialog({
    super.key,
    this.initialNote,
    required this.emoji,
    required this.emotionName,
  });

  @override
  State<NoteEditDialog> createState() => _NoteEditDialogState();
}

class _NoteEditDialogState extends State<NoteEditDialog> {
  late TextEditingController _controller;
  int _currentLength = 0;
  static const int _maxLength = 300;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(text: widget.initialNote ?? '');
    _currentLength = _controller.text.length;
    
    _controller.addListener(() {
      setState(() {
        _currentLength = _controller.text.length;
      });
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      child: Container(
        padding: const EdgeInsets.all(20),
        constraints: const BoxConstraints(maxHeight: 400),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 标题
            Row(
              children: [
                Text(
                  widget.emoji,
                  style: const TextStyle(fontSize: 24),
                ),
                const SizedBox(width: 8),
                Text(
                  '${widget.emotionName} 备注',
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            
            const SizedBox(height: 16),
            
            // 文本输入框
            Expanded(
              child: TextField(
                controller: _controller,
                maxLines: null,
                expands: true,
                maxLength: _maxLength,
                textAlignVertical: TextAlignVertical.top,
                decoration: InputDecoration(
                  hintText: '写下此刻的感受...',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: BorderSide(color: Colors.grey.shade300),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: const BorderSide(color: Color(0xFF6B73FF)),
                  ),
                  contentPadding: const EdgeInsets.all(12),
                  counterText: '', // 隐藏默认计数器
                ),
              ),
            ),
            
            const SizedBox(height: 8),
            
            // 字数统计
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  '$_currentLength/$_maxLength',
                  style: TextStyle(
                    fontSize: 12,
                    color: _currentLength > _maxLength 
                        ? Colors.red 
                        : Colors.grey.shade600,
                  ),
                ),
                if (_currentLength > _maxLength)
                  Text(
                    '超出字数限制',
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.red.shade600,
                    ),
                  ),
              ],
            ),
            
            const SizedBox(height: 16),
            
            // 按钮
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                TextButton(
                  onPressed: () => Navigator.of(context).pop(),
                  child: Text(
                    '取消',
                    style: TextStyle(
                      color: Colors.grey.shade600,
                    ),
                  ),
                ),
                
                const SizedBox(width: 12),
                
                ElevatedButton(
                  onPressed: _currentLength > _maxLength 
                      ? null 
                      : () {
                          Navigator.of(context).pop(_controller.text.trim());
                        },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF6B73FF),
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  child: const Text('保存'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}