// ignore_for_file: deprecated_member_use

import 'package:carousel_view/starry_background.dart';
import 'package:flutter/material.dart';

class StarryHomePage extends StatefulWidget {
  const StarryHomePage({super.key});

  @override
  State<StarryHomePage> createState() => _StarryHomePageState();
}

class _StarryHomePageState extends State<StarryHomePage> {
  int _hoveredIndex = -1;

  final List<String> _imageURLs = [
    'https://images.pexels.com/photos/375885/pexels-photo-375885.jpeg?auto=compress&cs=tinysrgb&w=1260&h=750&dpr=1',
    'https://images.pexels.com/photos/2398356/pexels-photo-2398356.jpeg?auto=compress&cs=tinysrgb&w=1260&h=750&dpr=1',
    'https://images.pexels.com/photos/1264210/pexels-photo-1264210.jpeg?auto=compress&cs=tinysrgb&w=1260&h=750&dpr=1',
    'https://images.pexels.com/photos/19224454/pexels-photo-19224454/free-photo-of-hands-holding-clapperboard.jpeg?auto=compress&cs=tinysrgb&w=1260&h=750&dpr=1',
    'https://images.pexels.com/photos/6848798/pexels-photo-6848798.jpeg?auto=compress&cs=tinysrgb&w=1260&h=750&dpr=1',
  ];

  @override
  void initState() {
    super.initState();
    _hoveredIndex = -1;
  }

  @override
  Widget build(BuildContext context) {
    const double breakpoint = 600;

    const double borderRadius = 50;
    const Duration animationDuration = Duration(milliseconds: 1000);
    const Curve animationCurve = Curves.easeInOut;

    return Scaffold(
      body: Stack(
        children: [
          const StarryBackground(),

          Padding(
            padding: const EdgeInsets.all(8.0),
            child: LayoutBuilder(
              builder: (context, constraints) {
                final double width = constraints.maxWidth;
                final double height = constraints.maxHeight;
                final double smallContainerWidth = 0.8 * width / 8;

                final double largeContainerWidth = 0.8 * width / 2;

                final double containerHeight = 0.6 * height;

                if (width > breakpoint) {
                  return Center(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      spacing: 8,
                      children: List.generate(
                        5,
                        (index) => MouseRegion(
                          onEnter: (_) => setState(() => _hoveredIndex = index),
                          onExit: (_) => setState(() => _hoveredIndex = -1),
                          child: AnimatedContainer(
                            duration: animationDuration,
                            curve: animationCurve,
                            width:
                                _hoveredIndex == index
                                    ? largeContainerWidth
                                    : smallContainerWidth,
                            height: containerHeight,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(borderRadius),
                              image: DecorationImage(
                                fit: BoxFit.cover,
                                image: NetworkImage(_imageURLs[index]),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  );
                } else {
                  return SingleChildScrollView(
                    child: Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: List.generate(
                          5,
                          (index) => Padding(
                            padding: const EdgeInsets.symmetric(vertical: 8.0),
                            child: AspectRatio(
                              aspectRatio: 1.68,

                              child: Container(
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(
                                    borderRadius,
                                  ),
                                  image: DecorationImage(
                                    fit: BoxFit.cover,
                                    image: NetworkImage(_imageURLs[index]),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  );
                }
              },
            ),
          ),
        ],
      ),
    );
  }
}
