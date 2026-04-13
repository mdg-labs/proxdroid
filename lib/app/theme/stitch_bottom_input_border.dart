import 'package:flutter/material.dart';

/// Filled-field underline: single bottom edge with optional soft glow (Stitch §4).
///
/// Used by [InputDecorationTheme] for Obsidian-style wells instead of full
/// rectangular outlines.
class StitchBottomInputBorder extends InputBorder {
  const StitchBottomInputBorder({
    required this.borderRadius,
    required super.borderSide,
    this.glow = false,
  });

  final BorderRadius borderRadius;
  final bool glow;

  @override
  bool get isOutline => false;

  @override
  EdgeInsetsGeometry get dimensions =>
      EdgeInsets.only(bottom: glow ? 6 + borderSide.width : borderSide.width);

  @override
  StitchBottomInputBorder copyWith({
    BorderSide? borderSide,
    BorderRadius? borderRadius,
    bool? glow,
  }) => StitchBottomInputBorder(
    borderRadius: borderRadius ?? this.borderRadius,
    borderSide: borderSide ?? this.borderSide,
    glow: glow ?? this.glow,
  );

  @override
  ShapeBorder scale(double t) => copyWith(
    borderSide: BorderSide(
      color: borderSide.color,
      width: borderSide.width * t,
    ),
  );

  @override
  Path getOuterPath(Rect rect, {TextDirection? textDirection}) {
    return Path()..addRRect(borderRadius.resolve(textDirection).toRRect(rect));
  }

  @override
  Path getInnerPath(Rect rect, {TextDirection? textDirection}) {
    return Path()..addRRect(
      borderRadius
          .resolve(textDirection)
          .toRRect(rect)
          .deflate(borderSide.width),
    );
  }

  @override
  void paint(
    Canvas canvas,
    Rect rect, {
    double? gapStart,
    double? gapExtent,
    double? gapPercentage,
    TextDirection? textDirection,
  }) {
    final rrect = borderRadius.resolve(textDirection).toRRect(rect);
    final y = rrect.bottom - borderSide.width / 2;
    final x0 = rrect.left + borderRadius.bottomLeft.x;
    final x1 = rrect.right - borderRadius.bottomRight.x;
    if (glow && borderSide.color.a > 0 && borderSide.width > 0) {
      final glowPaint =
          Paint()
            ..color = borderSide.color.withValues(alpha: 0.42)
            ..strokeWidth = borderSide.width + 10
            ..style = PaintingStyle.stroke
            ..strokeCap = StrokeCap.round
            ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 5);
      canvas.drawLine(Offset(x0, y), Offset(x1, y), glowPaint);
    }
    final line =
        Paint()
          ..color = borderSide.color
          ..strokeWidth = borderSide.width
          ..style = PaintingStyle.stroke
          ..strokeCap = StrokeCap.round;
    canvas.drawLine(Offset(x0, y), Offset(x1, y), line);
  }
}
