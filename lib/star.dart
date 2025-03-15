import 'package:flutter/material.dart';

class Star {
  double x;
  double y;
  final double size;
  final double blinkSpeed;
  final double speedX;
  final double speedY;
  double offsetX = 0;
  double offsetY = 0;
  final Color color;

  Star({
    required this.x,
    required this.y,
    required this.size,
    required this.blinkSpeed,
    required this.speedX,
    required this.speedY,
    required this.color,
  });

  double get displayX => x + offsetX;
  double get displayY => y + offsetY;
}
