import 'package:flutter/material.dart';
import '../core/constants/app_colors.dart';

class VCreationsLogo extends StatelessWidget {
  final double size;
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
    final vColor = darkBackground ? AppColors.white : Colors.black;
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        SizedBox(
          width: size,
          height: size * 0.85,
          child: Stack(
            alignment: Alignment.center,
            children: [
              // Large V
              Positioned(
                top: 0,
                left: 0,
                right: 0,
                child: Center(
                  child: Text(
                    'V',
                    style: TextStyle(
                      fontSize: size * 0.82,
                      fontWeight: FontWeight.w900,
                      color: vColor,
                      height: 1.0,
                      fontFamily: 'serif',
                    ),
                  ),
                ),
              ),
              // Gold dress shape (ellipse representing the silhouette)
              Positioned(
                bottom: 0,
                child: _DressShape(size: size),
              ),
            ],
          ),
        ),
        const SizedBox(height: 4),
        // "Créations" in gold italic
        Text(
          'Créations',
          style: TextStyle(
            fontSize: size * 0.28,
            color: AppColors.gold,
            fontStyle: FontStyle.italic,
            fontWeight: FontWeight.w700,
            letterSpacing: 1,
          ),
        ),
        if (showSubtitle) ...[
          const SizedBox(height: 2),
          Text(
            'Haute-couture',
            style: TextStyle(
              fontSize: size * 0.11,
              color: darkBackground ? AppColors.textSecondary : Colors.black54,
              letterSpacing: 3,
              fontWeight: FontWeight.w300,
            ),
          ),
        ],
      ],
    );
  }
}

class _DressShape extends StatelessWidget {
  final double size;
  const _DressShape({required this.size});

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      size: Size(size * 0.38, size * 0.58),
      painter: _DressPainter(),
    );
  }
}

class _DressPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = AppColors.gold
      ..style = PaintingStyle.fill;

    final path = Path();
    final cx = size.width / 2;

    // Dress silhouette: narrow top (shoulders), wider middle (bust),
    // narrow waist, flared skirt
    path.moveTo(cx * 0.5, 0); // left shoulder
    path.lineTo(cx * 1.5, 0); // right shoulder
    path.cubicTo(
      cx * 1.8, size.height * 0.15,
      cx * 1.9, size.height * 0.25,
      cx * 1.7, size.height * 0.4,
    ); // right bust curve
    path.cubicTo(
      cx * 1.5, size.height * 0.52,
      cx * 1.4, size.height * 0.58,
      cx * 1.65, size.height * 0.75,
    ); // right waist to skirt
    path.cubicTo(
      cx * 1.85, size.height * 0.88,
      cx * 1.9, size.height * 0.95,
      cx * 1.7, size.height,
    ); // right skirt hem
    path.lineTo(cx * 0.3, size.height); // hem
    path.cubicTo(
      cx * 0.1, size.height * 0.95,
      cx * 0.15, size.height * 0.88,
      cx * 0.35, size.height * 0.75,
    ); // left skirt
    path.cubicTo(
      cx * 0.6, size.height * 0.58,
      cx * 0.5, size.height * 0.52,
      cx * 0.3, size.height * 0.4,
    ); // left waist
    path.cubicTo(
      cx * 0.1, size.height * 0.25,
      cx * 0.2, size.height * 0.15,
      cx * 0.5, 0,
    ); // left bust

    path.close();
    canvas.drawPath(path, paint);

    // Hanger dot at top
    final dotPaint = Paint()..color = AppColors.gold;
    canvas.drawCircle(Offset(cx, -size.height * 0.06), size.width * 0.07, dotPaint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

/// Compact logo (icon only) for the app bar
class VCreationsLogoSmall extends StatelessWidget {
  final double height;
  const VCreationsLogoSmall({super.key, this.height = 36});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        SizedBox(
          height: height,
          width: height * 0.7,
          child: Stack(
            alignment: Alignment.center,
            children: [
              Text(
                'V',
                style: TextStyle(
                  fontSize: height * 0.9,
                  fontWeight: FontWeight.w900,
                  color: AppColors.white,
                  height: 1,
                ),
              ),
              Positioned(
                bottom: 0,
                child: CustomPaint(
                  size: Size(height * 0.28, height * 0.45),
                  painter: _DressPainter(),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(width: 6),
        Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Créations',
              style: TextStyle(
                fontSize: height * 0.34,
                color: AppColors.gold,
                fontStyle: FontStyle.italic,
                fontWeight: FontWeight.w700,
              ),
            ),
            Text(
              'Haute-couture',
              style: TextStyle(
                fontSize: height * 0.14,
                color: AppColors.textMuted,
                letterSpacing: 1.5,
              ),
            ),
          ],
        ),
      ],
    );
  }
}
