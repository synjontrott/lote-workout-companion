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
    this.pixelSize = 4.5,
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
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: List.generate(grid.length, (r) {
        return Row(
          mainAxisSize: MainAxisSize.min,
          children: List.generate(grid[r].length, (c) {
            final val = grid[r][c];
            return Container(
              width: pixelSize,
              height: pixelSize,
              color: _colorForValue(val),
            );
          }),
        );
      }),
    );
  }
}
