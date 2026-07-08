import 'package:flutter/material.dart';

class VCreationsLogo extends StatelessWidget {
  final double size;
  // darkBackground and showSubtitle kept for API compatibility
  final bool darkBackground;
  final bool showSubtitle;

  const VCreationsLogo({
    super.key,
    this.size = 120,
    this.darkBackground = true,
    this.showSubtitle = true,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(size * 0.12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.18),
            blurRadius: 24,
            spreadRadius: 0,
          ),
        ],
      ),
      clipBehavior: Clip.antiAlias,
      child: Image.asset(
        'assets/images/logo.jpg',
        fit: BoxFit.contain,
      ),
    );
  }
}

/// Compact inline logo for app bars
class VCreationsLogoSmall extends StatelessWidget {
  final double height;
  const VCreationsLogoSmall({super.key, this.height = 36});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: height,
      width: height,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(height * 0.15),
      ),
      clipBehavior: Clip.antiAlias,
      child: Image.asset(
        'assets/images/logo.jpg',
        fit: BoxFit.contain,
      ),
    );
  }
}
