// ignore_for_file: deprecated_member_use

import 'dart:math';
import 'package:carousel_view/star.dart';
import 'package:flutter/material.dart';

class StarPainter extends CustomPainter {
  final List<Star> stars;
  final double animationValue;
  final Offset? mousePosition;

  StarPainter({
    required this.stars,
    required this.animationValue,
    this.mousePosition,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final Paint backgroundPaint =
        Paint()
          ..shader = RadialGradient(
            colors: [
              const Color(0xFF050515),

              const Color(0xFF101030),
              const Color(0xFF202050),

              Colors.black87,
            ],
            center: const Alignment(0.7, -0.6),

            radius: 1.2,
            tileMode: TileMode.clamp,
          ).createShader(Rect.fromLTWH(0, 0, size.width, size.height));

    canvas.drawRect(
      Rect.fromLTWH(0, 0, size.width, size.height),
      backgroundPaint,
    );

    for (var star in stars) {
      final brightness =
          (sin(animationValue * 2 * pi * star.blinkSpeed + star.x * 100) + 1) /
          2;
      final opacity = 0.4 + brightness * 0.6;

      final starPaint =
          Paint()
            ..color = star.color.withOpacity(opacity)
            ..style = PaintingStyle.fill;

      canvas.drawCircle(
        Offset(star.displayX * size.width, star.displayY * size.height),
        star.size * (0.6 + brightness * 0.4),

        starPaint,
      );

      if (brightness > 0.8 && star.size > 1) {
        final glowPaint =
            Paint()
              ..color = star.color.withOpacity(0.15 + brightness * 0.15)
              ..style = PaintingStyle.fill
              ..maskFilter = MaskFilter.blur(BlurStyle.normal, star.size * 1.5);

        canvas.drawCircle(
          Offset(star.displayX * size.width, star.displayY * size.height),
          star.size * 2,
          glowPaint,
        );
      }

      if (star.size > 0.8 && opacity > 0.7) {
        final trailPaint =
            Paint()
              ..color = star.color.withOpacity(0.03 + brightness * 0.07)
              ..style = PaintingStyle.stroke
              ..strokeWidth = star.size * 0.3;

        final trailStartX =
            star.displayX * size.width -
            star.speedX * size.width * 100 * star.size;
        final trailStartY =
            star.displayY * size.height -
            star.speedY * size.height * 100 * star.size;
        canvas.drawLine(
          Offset(trailStartX, trailStartY),
          Offset(star.displayX * size.width, star.displayY * size.height),
          trailPaint,
        );
      }
    }

    if (mousePosition != null) {
      final mousePaint =
          Paint()
            ..color = Colors.white.withOpacity(0.08)
            ..style = PaintingStyle.fill
            ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 20);

      canvas.drawCircle(mousePosition!, 40, mousePaint);
    }
  }

  @override
  bool shouldRepaint(covariant StarPainter oldDelegate) {
    return oldDelegate.animationValue != animationValue ||
        oldDelegate.mousePosition != mousePosition;
  }
}
