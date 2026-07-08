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
    final vColor = darkBackground ? AppColors.white : const Color(0xFF111111);
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        SizedBox(
          width: size,
          height: size,
          child: CustomPaint(
            painter: _VLogoFullPainter(
              vColor: vColor,
              dressColor: AppColors.gold,
            ),
          ),
        ),
        const SizedBox(height: 6),
        Text(
          'Créations',
          style: TextStyle(
            fontSize: size * 0.26,
            color: AppColors.gold,
            fontStyle: FontStyle.italic,
            fontWeight: FontWeight.w700,
            letterSpacing: 0.5,
          ),
        ),
        if (showSubtitle) ...[
          const SizedBox(height: 3),
          Text(
            'Haute-couture',
            style: TextStyle(
              fontSize: size * 0.10,
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

class _VLogoFullPainter extends CustomPainter {
  final Color vColor;
  final Color dressColor;

  const _VLogoFullPainter({required this.vColor, required this.dressColor});

  @override
  void paint(Canvas canvas, Size size) {
    final W = size.width;
    final H = size.height;
    final cx = W / 2;

    final vPaint = Paint()
      ..color = vColor
      ..style = PaintingStyle.fill;

    final dressPaint = Paint()
      ..color = dressColor
      ..style = PaintingStyle.fill;

    // ── V shape: two angular filled arms ──────────────────────────────────
    // Left arm: wide triangle from top-left area to center-bottom
    final vPath = Path();
    // Left arm
    vPath.moveTo(0, 0);
    vPath.lineTo(W * 0.32, 0);
    vPath.lineTo(cx, H * 0.98);
    vPath.close();

    // Right arm
    vPath.moveTo(W * 0.68, 0);
    vPath.lineTo(W, 0);
    vPath.lineTo(cx, H * 0.98);
    vPath.close();

    canvas.drawPath(vPath, vPaint);

    // ── Decorative curved strokes (calligraphic lines around dress) ────────
    final strokePaint = Paint()
      ..color = vColor
      ..style = PaintingStyle.stroke
      ..strokeWidth = W * 0.016
      ..strokeCap = StrokeCap.round;

    // Left sweep
    final leftSweep = Path();
    leftSweep.moveTo(W * 0.36, H * 0.14);
    leftSweep.cubicTo(
      W * 0.22, H * 0.25,
      W * 0.18, H * 0.45,
      W * 0.30, H * 0.68,
    );
    canvas.drawPath(leftSweep, strokePaint);

    // Right sweep (mirror)
    final rightSweep = Path();
    rightSweep.moveTo(W * 0.64, H * 0.14);
    rightSweep.cubicTo(
      W * 0.78, H * 0.25,
      W * 0.82, H * 0.45,
      W * 0.70, H * 0.68,
    );
    canvas.drawPath(rightSweep, strokePaint);

    // ── Gold dress / mannequin figure (centered, inside the V) ─────────────
    final dressTop = H * 0.20;
    final dressBot = H * 0.86;
    final dressH = dressBot - dressTop;
    final dw = W * 0.19; // half-width of widest part

    final dressPath = Path();
    // Start at top-center (neck/top)
    dressPath.moveTo(cx - W * 0.05, dressTop);
    // Left shoulder → bust
    dressPath.cubicTo(
      cx - dw * 0.5, dressTop + dressH * 0.08,
      cx - dw * 1.0, dressTop + dressH * 0.25,
      cx - dw * 0.75, dressTop + dressH * 0.48, // waist
    );
    // Left waist → skirt hem
    dressPath.cubicTo(
      cx - dw * 0.90, dressTop + dressH * 0.68,
      cx - dw * 1.10, dressTop + dressH * 0.85,
      cx - dw * 0.80, dressBot,
    );
    // Bottom
    dressPath.lineTo(cx + dw * 0.80, dressBot);
    // Right skirt → waist
    dressPath.cubicTo(
      cx + dw * 1.10, dressTop + dressH * 0.85,
      cx + dw * 0.90, dressTop + dressH * 0.68,
      cx + dw * 0.75, dressTop + dressH * 0.48, // waist
    );
    // Right bust → shoulder
    dressPath.cubicTo(
      cx + dw * 1.0, dressTop + dressH * 0.25,
      cx + dw * 0.5, dressTop + dressH * 0.08,
      cx + W * 0.05, dressTop,
    );
    dressPath.close();

    canvas.drawPath(dressPath, dressPaint);

    // ── Head circle ───────────────────────────────────────────────────────
    final headR = W * 0.058;
    canvas.drawCircle(Offset(cx, dressTop - headR * 0.6), headR, dressPaint);

    // ── Neck connector (thin rectangle) ──────────────────────────────────
    final neckPaint = Paint()..color = dressColor..style = PaintingStyle.fill;
    canvas.drawRect(
      Rect.fromCenter(
        center: Offset(cx, dressTop - headR * 0.05),
        width: W * 0.04,
        height: headR * 1.4,
      ),
      neckPaint,
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

/// Compact inline logo for app bars
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
          width: height,
          child: CustomPaint(
            painter: _VLogoFullPainter(
              vColor: AppColors.white,
              dressColor: AppColors.gold,
            ),
          ),
        ),
        const SizedBox(width: 8),
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

