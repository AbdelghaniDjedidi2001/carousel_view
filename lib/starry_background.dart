// ignore_for_file: deprecated_member_use

import 'dart:math';

import 'package:carousel_view/star.dart';
import 'package:carousel_view/star_painter.dart';
import 'package:flutter/material.dart';

class StarryBackground extends StatefulWidget {
  const StarryBackground({super.key});

  @override
  State<StarryBackground> createState() => _StarryBackgroundState();
}

class _StarryBackgroundState extends State<StarryBackground>
    with TickerProviderStateMixin {
  late AnimationController _controller;
  late AnimationController _mouseController;
  final int starCount = 700;

  final List<Star> stars = [];
  final Random random = Random();

  Offset mousePosition = Offset.zero;
  bool isMouseActive = false;
  double mouseInfluence = 1.8;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 60),
    )..repeat();

    _mouseController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 16),
    )..repeat();

    _mouseController.addListener(_updateStarPositions);

    for (int i = 0; i < starCount; i++) {
      stars.add(
        Star(
          x: random.nextDouble(),
          y: random.nextDouble(),
          size: random.nextDouble() * 1.5 + 0.5,

          blinkSpeed: random.nextDouble() * 1.5 + 0.3,

          speedX: (random.nextDouble() - 0.5) * 0.0002,

          speedY: (random.nextDouble() - 0.5) * 0.0002,
          color: _getRandomStarColor(),
        ),
      );
    }
  }

  Color _getRandomStarColor() {
    final int type = random.nextInt(4);
    if (type == 0) {
      return Colors.white.withOpacity(0.7 + random.nextDouble() * 0.3);
    } else if (type == 1) {
      return Colors.yellow.shade100.withOpacity(
        0.6 + random.nextDouble() * 0.4,
      );
    } else if (type == 2) {
      return Colors.blue.shade100.withOpacity(0.5 + random.nextDouble() * 0.3);
    } else {
      return Colors.white.withOpacity(0.5 + random.nextDouble() * 0.2);
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    _mouseController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onHover: (event) {
        setState(() {
          mousePosition = event.localPosition;
          isMouseActive = true;
        });
      },
      onExit: (event) {
        setState(() {
          isMouseActive = false;
        });
      },
      child: GestureDetector(
        onPanUpdate: (details) {
          setState(() {
            mousePosition = details.localPosition;
            isMouseActive = true;
          });
        },
        onPanEnd: (details) {
          setState(() {
            isMouseActive = false;
          });
        },
        child: AnimatedBuilder(
          animation: _controller,
          builder: (context, child) {
            return CustomPaint(
              painter: StarPainter(
                stars: stars,
                animationValue: _controller.value,
                mousePosition: isMouseActive ? mousePosition : null,
              ),
              size: Size.infinite,
            );
          },
        ),
      ),
    );
  }

  void _updateStarPositions() {
    if (!mounted) return;
    final screenSize = MediaQuery.of(context).size;

    for (var star in stars) {
      star.x += star.speedX;
      star.y += star.speedY;

      if (star.x < 0) star.x = 1;
      if (star.x > 1) star.x = 0;
      if (star.y < 0) star.y = 1;
      if (star.y > 1) star.y = 0;

      if (isMouseActive) {
        final mouseX = mousePosition.dx / screenSize.width;
        final mouseY = mousePosition.dy / screenSize.height;
        final dx = star.x - mouseX;
        final dy = star.y - mouseY;
        final distance = sqrt(dx * dx + dy * dy);

        if (distance < 0.2) {
          final influence = (1 - distance / 0.2) * mouseInfluence;
          star.offsetX = dx * influence * 0.2;
          star.offsetY = dy * influence * 0.2;
        } else {
          star.offsetX *= 0.97;
          star.offsetY *= 0.97;
        }
      } else {
        star.offsetX *= 0.98;
        star.offsetY *= 0.98;
      }
    }

    if (isMouseActive) {
      setState(() {});
    }
  }
}
