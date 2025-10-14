import 'package:flutter/material.dart';

class NoteBubbleOverlay extends StatelessWidget {
  final LayerLink layerLink;
  final Widget child;
  final VoidCallback onDismiss;

  const NoteBubbleOverlay({
    super.key,
    required this.layerLink,
    required this.child,
    required this.onDismiss,
  });

  @override
  Widget build(BuildContext context) {
    return Positioned.fill(
      child: GestureDetector(
        onTap: onDismiss,
        behavior: HitTestBehavior.translucent,
        child: Stack(
          children: [
            CompositedTransformFollower(
              link: layerLink,
              targetAnchor: Alignment.centerRight,
              followerAnchor: Alignment.centerLeft,
              offset: const Offset(8, 0), // 气泡右移8像素
              child: GestureDetector(
                onTap: () {}, // 防止点击气泡时触发背景的onDismiss
                child: child,
              ),
            ),
          ],
        ),
      ),
    );
  }
}