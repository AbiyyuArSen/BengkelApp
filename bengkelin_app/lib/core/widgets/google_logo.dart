import 'dart:math' as math;
import 'package:flutter/material.dart';

class GoogleLogo extends StatelessWidget {
  final double size;

  const GoogleLogo({super.key, this.size = 24});

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      size: Size(size, size),
      painter: _GoogleLogoPainter(),
    );
  }
}

class _GoogleLogoPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final double w = size.width;
    final double r = w / 2;
    final center = Offset(r, r);

    final double thickness = r * 0.38;
    final double innerR = r - thickness;

    // Save canvas state
    canvas.save();

    // Create a path that covers the outer circle but has a hole for the inner circle
    final clipPath = Path()
      ..addOval(Rect.fromCircle(center: center, radius: r))
      ..addOval(Rect.fromCircle(center: center, radius: innerR))
      ..fillType = PathFillType.evenOdd;
    canvas.clipPath(clipPath);

    // Draw the 4 colored sectors
    // 1. Red (top sector)
    final redPaint = Paint()..color = const Color(0xFFEA4335)..style = PaintingStyle.fill;
    canvas.drawArc(
      Rect.fromCircle(center: center, radius: r * 1.2),
      -math.pi * 0.95,
      -math.pi * 0.55,
      true,
      redPaint,
    );

    // 2. Yellow (left sector)
    final yellowPaint = Paint()..color = const Color(0xFFFBBC05)..style = PaintingStyle.fill;
    canvas.drawArc(
      Rect.fromCircle(center: center, radius: r * 1.2),
      -math.pi * 1.5,
      -math.pi * 0.55,
      true,
      yellowPaint,
    );

    // 3. Green (bottom sector)
    final greenPaint = Paint()..color = const Color(0xFF34A853)..style = PaintingStyle.fill;
    canvas.drawArc(
      Rect.fromCircle(center: center, radius: r * 1.2),
      math.pi * 0.45,
      math.pi * 0.55,
      true,
      greenPaint,
    );

    // 4. Blue (right sector)
    final bluePaint = Paint()..color = const Color(0xFF4285F4)..style = PaintingStyle.fill;
    canvas.drawArc(
      Rect.fromCircle(center: center, radius: r * 1.2),
      -math.pi * 0.95,
      math.pi * 0.95,
      true,
      bluePaint,
    );

    // Restore canvas to remove the clip
    canvas.restore();

    // Now draw the horizontal blue bar
    final barRect = Rect.fromLTRB(r, r - thickness / 2, w, r + thickness / 2);
    canvas.drawRect(barRect, bluePaint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
