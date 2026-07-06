import 'package:flutter/material.dart';

class PixelSpriteWidget extends StatelessWidget {
  final List<List<int>> grid;
  final Color skinColor;
  final Color hairColor;
  final Color eyeColor;
  final Color outfitColor;
  final Color auraColor;
  final double pixelSize;

  const PixelSpriteWidget({
    super.key,
    required this.grid,
    required this.skinColor,
    required this.hairColor,
    required this.eyeColor,
    required this.outfitColor,
    required this.auraColor,
    this.pixelSize = 1.0,
  });

  @override
  Widget build(BuildContext context) {
    final width = grid.isNotEmpty ? grid[0].length * pixelSize : 0.0;
    final height = grid.length * pixelSize;

    return CustomPaint(
      size: Size(width, height),
      painter: _PixelSpritePainter(
        grid: grid,
        skinColor: skinColor,
        hairColor: hairColor,
        eyeColor: eyeColor,
        outfitColor: outfitColor,
        auraColor: auraColor,
        pixelSize: pixelSize,
      ),
    );
  }
}

class _PixelSpritePainter extends CustomPainter {
  final List<List<int>> grid;
  final Color skinColor;
  final Color hairColor;
  final Color eyeColor;
  final Color outfitColor;
  final Color auraColor;
  final double pixelSize;

  _PixelSpritePainter({
    required this.grid,
    required this.skinColor,
    required this.hairColor,
    required this.eyeColor,
    required this.outfitColor,
    required this.auraColor,
    required this.pixelSize,
  });

  Color _colorForValue(int val) {
    switch (val) {
      case 1:
        return skinColor;
      case 2:
        return hairColor;
      case 3:
        return eyeColor;
      case 4:
        return outfitColor;
      case 5:
        return auraColor;
      default:
        return Colors.transparent;
    }
  }

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()..style = PaintingStyle.fill;

    for (int r = 0; r < grid.length; r++) {
      for (int c = 0; c < grid[r].length; c++) {
        final val = grid[r][c];
        if (val != 0) {
          paint.color = _colorForValue(val);
          canvas.drawRect(
            Rect.fromLTWH(c * pixelSize, r * pixelSize, pixelSize, pixelSize),
            paint,
          );
        }
      }
    }
  }

  @override
  bool shouldRepaint(covariant _PixelSpritePainter oldDelegate) {
    return oldDelegate.grid != grid ||
        oldDelegate.skinColor != skinColor ||
        oldDelegate.hairColor != hairColor ||
        oldDelegate.eyeColor != eyeColor ||
        oldDelegate.outfitColor != outfitColor ||
        oldDelegate.auraColor != auraColor ||
        oldDelegate.pixelSize != pixelSize;
  }
}
