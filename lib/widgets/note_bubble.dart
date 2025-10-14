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
    String displayText = note.length > 20 ? '${note.substring(0, 20)}...' : note;
    
    return GestureDetector(
      onTap: () {
        onDismiss();
        onTap();
      },
      child: Container(
        constraints: const BoxConstraints(maxWidth: 200, minWidth: 120),
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.15),
              blurRadius: 12,
              offset: const Offset(0, 4),
            ),
          ],
          border: Border.all(
            color: Colors.grey.shade200,
            width: 1,
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: Text(
                displayText,
                style: const TextStyle(
                  fontSize: 14,
                  color: Colors.black87,
                  height: 1.3,
                ),
                maxLines: 3,
                overflow: TextOverflow.ellipsis,
              ),
            ),
            const SizedBox(width: 8),
            GestureDetector(
              onTap: onDismiss,
              child: Container(
                padding: const EdgeInsets.all(2),
                child: Icon(
                  Icons.close,
                  size: 14,
                  color: Colors.grey.shade500,
                ),
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
    return Stack(
      children: [
        Positioned(
          left: position.dx + 45, // 气泡在emoji球右侧
          top: position.dy - 5, // 稍微向上偏移
          child: GestureDetector(
            onTap: () {}, // 阻止事件冒泡
            child: child,
          ),
        ),
      ],
    );
  }
}