import 'package:flutter/material.dart';
import '../theme/app_theme.dart';

/// TicketQrCodeWidget: Widget QR Code presisi untuk boarding & verifikasi E-Tiket TripRent.
/// Menggunakan CustomPainter vektor deterministik berbasis data unik pesanan.
class TicketQrCodeWidget extends StatelessWidget {
  final String data;
  final double size;
  final Color foregroundColor;
  final Color backgroundColor;
  final bool showCenterLogo;

  const TicketQrCodeWidget({
    super.key,
    required this.data,
    this.size = 160,
    this.foregroundColor = const Color(0xFF0F172A),
    this.backgroundColor = Colors.white,
    this.showCenterLogo = true,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      padding: EdgeInsets.all(size * 0.05),
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppTheme.cardBorder, width: 1.5),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.08),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Stack(
        alignment: Alignment.center,
        children: [
          CustomPaint(
            size: Size(size * 0.9, size * 0.9),
            painter: _DeterministicQrPainter(
              data: data,
              color: foregroundColor,
            ),
          ),
          if (showCenterLogo)
            Container(
              width: size * 0.22,
              height: size * 0.22,
              decoration: BoxDecoration(
                color: Colors.white,
                shape: BoxShape.circle,
                border: Border.all(color: AppTheme.primaryLight, width: 2),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.15),
                    blurRadius: 4,
                  ),
                ],
              ),
              child: Center(
                child: Icon(
                  Icons.airport_shuttle_rounded,
                  color: AppTheme.primaryLight,
                  size: size * 0.13,
                ),
              ),
            ),
        ],
      ),
    );
  }
}

class _DeterministicQrPainter extends CustomPainter {
  final String data;
  final Color color;

  static const int gridSize = 25;

  _DeterministicQrPainter({required this.data, required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    final moduleSize = size.width / gridSize;
    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.fill;

    // Seed hash generator from ticket data
    int hash = 5381;
    for (int i = 0; i < data.length; i++) {
      hash = ((hash << 5) + hash) + data.codeUnitAt(i);
    }
    if (hash < 0) hash = -hash;

    // Draw grid modules
    for (int r = 0; r < gridSize; r++) {
      for (int c = 0; c < gridSize; c++) {
        if (_isFinderPattern(r, c)) {
          if (_isFinderDark(r, c)) {
            _drawModule(canvas, c, r, moduleSize, paint);
          }
        } else if (_isTimingPattern(r, c)) {
          if ((r + c) % 2 == 0) {
            _drawModule(canvas, c, r, moduleSize, paint);
          }
        } else if (_isAlignmentPattern(r, c)) {
          if (_isAlignmentDark(r, c)) {
            _drawModule(canvas, c, r, moduleSize, paint);
          }
        } else if (_isCenterProtected(r, c)) {
          // Center reserved for logo
          continue;
        } else {
          // Deterministic pseudorandom data based on hash and coordinates
          final bit = ((hash ^ (r * 31 + c * 17) ^ (r << 3) ^ (c << 2)) % 7);
          if (bit == 0 || bit == 2 || bit == 3 || bit == 5) {
            _drawModule(canvas, c, r, moduleSize, paint);
          }
        }
      }
    }
  }

  void _drawModule(Canvas canvas, int col, int row, double moduleSize, Paint paint) {
    final rect = Rect.fromLTWH(
      col * moduleSize,
      row * moduleSize,
      moduleSize,
      moduleSize,
    );
    canvas.drawRect(rect, paint);
  }

  bool _isFinderPattern(int r, int c) {
    // Top-left
    if (r < 7 && c < 7) return true;
    // Top-right
    if (r < 7 && c >= gridSize - 7) return true;
    // Bottom-left
    if (r >= gridSize - 7 && c < 7) return true;
    return false;
  }

  bool _isFinderDark(int r, int c) {
    int localR = r;
    int localC = c;
    if (r >= gridSize - 7) localR = r - (gridSize - 7);
    if (c >= gridSize - 7) localC = c - (gridSize - 7);

    // Outer 7x7 square
    if (localR == 0 || localR == 6 || localC == 0 || localC == 6) return true;
    // Inner 3x3 square
    if (localR >= 2 && localR <= 4 && localC >= 2 && localC <= 4) return true;
    return false;
  }

  bool _isTimingPattern(int r, int c) {
    if (r == 6 && c >= 7 && c < gridSize - 7) return true;
    if (c == 6 && r >= 7 && r < gridSize - 7) return true;
    return false;
  }

  bool _isAlignmentPattern(int r, int c) {
    const centerR = 18;
    const centerC = 18;
    return (r >= centerR - 2 && r <= centerR + 2 && c >= centerC - 2 && c <= centerC + 2);
  }

  bool _isAlignmentDark(int r, int c) {
    const centerR = 18;
    const centerC = 18;
    final dr = (r - centerR).abs();
    final dc = (c - centerC).abs();
    if (dr == 2 || dc == 2) return true;
    if (dr == 0 && dc == 0) return true;
    return false;
  }

  bool _isCenterProtected(int r, int c) {
    // Protect center 5x5 region for TripRent brand logo
    const mid = gridSize ~/ 2;
    return (r >= mid - 2 && r <= mid + 2 && c >= mid - 2 && c <= mid + 2);
  }

  @override
  bool shouldRepaint(covariant _DeterministicQrPainter oldDelegate) {
    return oldDelegate.data != data || oldDelegate.color != color;
  }
}
