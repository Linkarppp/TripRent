import 'package:flutter/material.dart';
import '../theme/app_theme.dart';

class BrandLogo extends StatelessWidget {
  final double fontSize;
  final bool showTagline;
  final bool isLightOnDark;

  const BrandLogo({
    super.key,
    this.fontSize = 28,
    this.showTagline = false,
    this.isLightOnDark = false,
  });

  @override
  Widget build(BuildContext context) {
    final textColor = isLightOnDark ? Colors.white : AppTheme.textPrimary;
    final blueColor = AppTheme.primaryLight;

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        // Stylized Car Roofline Arc
        CustomPaint(
          size: Size(fontSize * 2.2, fontSize * 0.55),
          painter: _CarRooflinePainter(color: isLightOnDark ? Colors.white : AppTheme.primary),
        ),
        const SizedBox(height: 2),
        RichText(
          text: TextSpan(
            style: TextStyle(
              fontSize: fontSize,
              fontWeight: FontWeight.w900,
              letterSpacing: -0.8,
              fontFamily: 'Montserrat',
            ),
            children: [
              TextSpan(text: 'Trip', style: TextStyle(color: textColor)),
              TextSpan(text: 'Rent', style: TextStyle(color: blueColor)),
            ],
          ),
        ),
        if (showTagline) ...[
          const SizedBox(height: 6),
          Text(
            'Sewa Mobil, Jelajahi Perjalananmu',
            style: TextStyle(
              fontSize: fontSize * 0.42,
              color: isLightOnDark ? Colors.white.withValues(alpha: 0.85) : AppTheme.textSecondary,
              fontWeight: FontWeight.w500,
              letterSpacing: 0.2,
            ),
          ),
        ],
      ],
    );
  }
}

class _CarRooflinePainter extends CustomPainter {
  final Color color;

  _CarRooflinePainter({required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeWidth = size.height * 0.26
      ..strokeCap = StrokeCap.round;

    final path = Path();
    // Smooth aerodynamic car roofline
    path.moveTo(size.width * 0.05, size.height * 0.95);
    path.cubicTo(
      size.width * 0.25,
      size.height * 0.1,
      size.width * 0.75,
      size.height * 0.1,
      size.width * 0.95,
      size.height * 0.95,
    );

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant _CarRooflinePainter oldDelegate) => oldDelegate.color != color;
}
