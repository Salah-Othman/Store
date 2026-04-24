import 'package:flutter/material.dart';

extension ResponsiveExtension on BuildContext {
  double get screenWidth => MediaQuery.of(this).size.width;
  double get screenHeight => MediaQuery.of(this).size.height;
  
  bool get isMobile => screenWidth < 600;
  bool get isTablet => screenWidth >= 600 && screenWidth < 900;
  bool get isDesktop => screenWidth >= 900;
  
  int get gridCrossAxisCount {
    if (isDesktop) return 4;
    if (isTablet) return 3;
    return 2;
  }
  
  double get gridChildAspectRatio {
    if (isDesktop) return 0.9;
    if (isTablet) return 0.85;
    return 0.75;
  }
  
  EdgeInsets get screenPadding {
    if (isDesktop) return EdgeInsets.symmetric(horizontal: screenWidth * 0.15);
    if (isTablet) return EdgeInsets.symmetric(horizontal: screenWidth * 0.08);
    return EdgeInsets.symmetric(horizontal: 16);
  }
}

class ResponsiveBuilder extends StatelessWidget {
  final Widget Function(BuildContext context, bool isMobile, bool isTablet, bool isDesktop) builder;

  const ResponsiveBuilder({super.key, required this.builder});

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final isMobile = width < 600;
    final isTablet = width >= 600 && width < 900;
    final isDesktop = width >= 900;
    
    return Builder(
      builder: (context) => builder(context, isMobile, isTablet, isDesktop),
    );
  }
}