import 'dart:math' as math;

import 'package:flutter/material.dart';

class CustomRoundSliderThumbShape extends RoundSliderThumbShape {
  final Color enabledBorderColor;

  final Color? disabledBorderColor;
  Color get _disabledBorderColor => disabledBorderColor ?? enabledBorderColor;

  final double enabledBorderWidth;

  final double? disableBorderWidth;
  double get _disableBorderWidth => disableBorderWidth ?? enabledBorderWidth;

  const CustomRoundSliderThumbShape({
    super.enabledThumbRadius,
    super.disabledThumbRadius,
    super.elevation = 1.0,
    super.pressedElevation = 6.0,
    required this.enabledBorderColor,
    this.disabledBorderColor,
    required this.enabledBorderWidth,
    this.disableBorderWidth,
  });

  @override
  void paint(PaintingContext context, Offset center,
      {required Animation<double> activationAnimation,
      required Animation<double> enableAnimation,
      required bool isDiscrete,
      required TextPainter labelPainter,
      required RenderBox parentBox,
      required SliderThemeData sliderTheme,
      required TextDirection textDirection,
      required double value,
      required double textScaleFactor,
      required Size sizeWithOverflow}) {
    assert(sliderTheme.disabledThumbColor != null);
    assert(sliderTheme.thumbColor != null);

    final Canvas canvas = context.canvas;
    final Tween<double> radiusTween = Tween<double>(
      begin: disabledThumbRadius ?? enabledThumbRadius,
      end: enabledThumbRadius,
    );
    final ColorTween colorTween = ColorTween(
      begin: sliderTheme.disabledThumbColor,
      end: sliderTheme.thumbColor,
    );
    final Tween<double> borderTween = Tween<double>(
      begin: _disableBorderWidth,
      end: enabledBorderWidth,
    );
    final ColorTween borderColorTween = ColorTween(
      begin: _disabledBorderColor,
      end: enabledBorderColor,
    );

    final Color color = colorTween.evaluate(enableAnimation)!;
    final double radius = radiusTween.evaluate(enableAnimation);

    final Color borderColor = borderColorTween.evaluate(enableAnimation)!;
    final double borderWidth = borderTween.evaluate(enableAnimation);

    final Tween<double> elevationTween = Tween<double>(
      begin: elevation,
      end: pressedElevation,
    );

    final double evaluatedElevation =
        elevationTween.evaluate(activationAnimation);
    final Path path = Path()
      ..addArc(
          Rect.fromCenter(
              center: center, width: 2 * radius, height: 2 * radius),
          0,
          math.pi * 2);

    bool paintShadows = true;
    assert(() {
      if (debugDisableShadows) {
        _debugDrawShadow(canvas, path, evaluatedElevation);
        paintShadows = false;
      }
      return true;
    }());

    if (paintShadows) {
      canvas.drawShadow(path, Colors.black, evaluatedElevation, true);
    }

    canvas.drawCircle(
      center,
      radius,
      Paint()..color = color,
    );
    canvas.drawCircle(
      center,
      radius,
      Paint()
        ..strokeWidth = borderWidth
        ..style = PaintingStyle.stroke
        ..color = borderColor,
    );
  }
}

class CustomTrackShape extends RoundedRectSliderTrackShape {
  @override
  Rect getPreferredRect({
    required RenderBox parentBox,
    Offset offset = Offset.zero,
    required SliderThemeData sliderTheme,
    bool isEnabled = false,
    bool isDiscrete = false,
  }) {
    final double trackHeight = sliderTheme.trackHeight ?? 0;
    final double trackLeft = offset.dx;
    final double trackTop =
        offset.dy + (parentBox.size.height - trackHeight) / 2;
    final double trackWidth = parentBox.size.width;
    return Rect.fromLTWH(trackLeft, trackTop, trackWidth, trackHeight);
  }
}

void _debugDrawShadow(Canvas canvas, Path path, double elevation) {
  if (elevation > 0.0) {
    canvas.drawPath(
      path,
      Paint()
        ..color = Colors.black
        ..style = PaintingStyle.stroke
        ..strokeWidth = elevation * 2.0,
    );
  }
}
