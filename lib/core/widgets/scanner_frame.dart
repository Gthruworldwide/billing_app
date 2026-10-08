import 'package:flutter/material.dart';

/// Shared camera overlay frame used by all barcode scanner screens.
///
/// Draws a centered bounding box with corner markers and, optionally, a hint
/// below the box. Both the inline home scanner and the full-screen scanner
/// page use this widget so the overlay styling stays consistent and the corner
/// animation/logic is not duplicated.
class ScannerFrame extends StatelessWidget {
  /// Size of the square bounding box in logical pixels.
  final double size;

  /// Color of the box border.
  final Color frameColor;

  /// Color of the four corner markers.
  final Color cornerColor;

  /// Border width of the box.
  final double frameThickness;

  /// Corner radius of the box.
  final double radius;

  /// Optional hint text shown below the box.
  final String? hintText;

  const ScannerFrame({
    super.key,
    this.size = 250,
    this.frameColor = Colors.white24,
    this.cornerColor = Colors.greenAccent,
    this.frameThickness = 2,
    this.radius = 16,
    this.hintText,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: size,
          height: size,
          decoration: BoxDecoration(
            border:
                Border.all(color: frameColor, width: frameThickness),
            borderRadius: BorderRadius.circular(radius),
          ),
          child: Stack(
            children: [
              _corner(Alignment.topLeft),
              _corner(Alignment.topRight),
              _corner(Alignment.bottomLeft),
              _corner(Alignment.bottomRight),
            ],
          ),
        ),
        if (hintText != null) ...[
          const SizedBox(height: 24),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: Text(
              hintText!,
              textAlign: TextAlign.center,
              style: const TextStyle(color: Colors.white, fontSize: 16),
            ),
          ),
        ],
      ],
    );
  }

  Widget _corner(Alignment alignment) {
    final hasTop = alignment == Alignment.topLeft || alignment == Alignment.topRight;
    final hasBottom =
        alignment == Alignment.bottomLeft || alignment == Alignment.bottomRight;
    final hasLeft =
        alignment == Alignment.topLeft || alignment == Alignment.bottomLeft;
    final hasRight =
        alignment == Alignment.topRight || alignment == Alignment.bottomRight;

    return Align(
      alignment: alignment,
      child: Container(
        width: 28,
        height: 28,
        decoration: BoxDecoration(
          border: Border(
            top: hasTop
                ? BorderSide(color: cornerColor, width: 4)
                : BorderSide.none,
            bottom: hasBottom
                ? BorderSide(color: cornerColor, width: 4)
                : BorderSide.none,
            left: hasLeft
                ? BorderSide(color: cornerColor, width: 4)
                : BorderSide.none,
            right: hasRight
                ? BorderSide(color: cornerColor, width: 4)
                : BorderSide.none,
          ),
        ),
      ),
    );
  }
}