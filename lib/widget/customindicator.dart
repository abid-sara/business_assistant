import 'package:flutter/material.dart';

class CustomTabIndicator extends Decoration {
  final Color color;
  final double radius;
  final double horizontalPadding;

  const CustomTabIndicator({
    required this.color,
    required this.radius,
    required this.horizontalPadding,
  });

  @override
  BoxPainter createBoxPainter([VoidCallback? onChanged]) {
    return _FullBackgroundTabIndicatorPainter(
      color: color,
      radius: radius,
      horizontalPadding: horizontalPadding,
    );
  }
}

class _FullBackgroundTabIndicatorPainter extends BoxPainter {
  final Color color;
  final double radius;
  final double horizontalPadding;

  _FullBackgroundTabIndicatorPainter({
    required this.color,
    required this.radius,
    required this.horizontalPadding,
  });

  @override
  void paint(Canvas canvas, Offset offset, ImageConfiguration configuration) {
    final Rect rect = Rect.fromLTWH(
      offset.dx - horizontalPadding, // Extra width on both sides
      offset.dy + 2,                 // Top padding (adjust as needed)
      configuration.size!.width + 2 * horizontalPadding,
      configuration.size!.height - 4, // Height with a bit of margin
    );
    final RRect rRect = RRect.fromRectAndRadius(rect, Radius.circular(radius));
    final Paint paint = Paint()..color = color;
    canvas.drawRRect(rRect, paint);
  }
}
