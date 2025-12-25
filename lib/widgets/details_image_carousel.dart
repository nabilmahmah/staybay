import 'dart:developer';

import 'package:flutter/material.dart';
import '../app_theme.dart';

class DetailsImageCarousel extends StatefulWidget {
  final List<String> imagesPaths;

  const DetailsImageCarousel({super.key, required this.imagesPaths});

  @override
  State<DetailsImageCarousel> createState() => _DetailsImageCarouselState();
}

class _DetailsImageCarouselState extends State<DetailsImageCarousel> {
  final PageController _pageController = PageController(initialPage: 0);
  int _currentPage = 0;

  @override
  void initState() {
    super.initState();
    _pageController.addListener(() {
      if (_pageController.page != null) {
        setState(() {
          _currentPage = _pageController.page!.round();
        });
      }
    });
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  Widget _buildDot(int index) {
    return Container(
      width: 8.0,
      height: 8.0,
      margin: const EdgeInsets.symmetric(horizontal: 4.0),
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: _currentPage == index ? Colors.white : Colors.white54,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    log(widget.imagesPaths.toString());
    return Stack(
      children: <Widget>[
        PageView.builder(
          controller: _pageController,
          itemCount: widget.imagesPaths.length,
          itemBuilder: (context, index) {
            return Image.network(
              widget.imagesPaths[index],
              fit: BoxFit.cover,
              width: double.infinity,
              errorBuilder: (context, error, stackTrace) => Container(
                color: Colors.grey[300],
                alignment: Alignment.center,
                child: const Icon(
                  Icons.error_outline,
                  size: 50,
                  color: Colors.grey,
                ),
              ),
            );
          },
        ),

        Positioned(
          bottom: AppSizes.paddingMedium,
          left: 0,
          right: 0,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: List.generate(widget.imagesPaths.length, _buildDot),
          ),
        ),
      ],
    );
  }
}
