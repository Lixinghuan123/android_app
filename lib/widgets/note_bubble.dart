import 'package:flutter/material.dart';

class NoteBubble extends StatelessWidget {
  final String note;
  final VoidCallback onTap;
  final VoidCallback onDismiss;

  const NoteBubble({
    super.key,
    required this.note,
    required this.onTap,
    required this.onDismiss,
  });

  @override
  Widget build(BuildContext context) {
    // 显示前20个字符
    String displayText = note.length > 20 ? '${note.substring(0, 20)}...' : note;
    
    return GestureDetector(
      onTap: () {
        onDismiss(); // 先关闭气泡
        onTap(); // 然后执行点击操作
      },
      child: Container(
        constraints: const BoxConstraints(maxWidth: 200),
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
          border: Border.all(
            color: const Color(0xFF6B73FF).withOpacity(0.3),
            width: 1,
          ),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              displayText,
              style: const TextStyle(
                fontSize: 14,
                color: Colors.black87,
              ),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
            const SizedBox(height: 4),
            Text(
              '点击编辑',
              style: TextStyle(
                fontSize: 12,
                color: Colors.grey.shade600,
                fontStyle: FontStyle.italic,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// 气泡式覆盖层组件
class BubbleOverlay extends StatelessWidget {
  final Widget child;
  final Offset position;
  final VoidCallback onDismiss;

  const BubbleOverlay({
    super.key,
    required this.child,
    required this.position,
    required this.onDismiss,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onDismiss,
      child: Container(
        color: Colors.transparent,
        child: Stack(
          children: [
            Positioned(
              left: position.dx,
              top: position.dy,
              child: child,
            ),
          ],
        ),
      ),
    );
  }
}