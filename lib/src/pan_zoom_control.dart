import 'package:flutter/material.dart';
import 'package:pan_zoom_control/src/pan_control.dart';
import 'package:pan_zoom_control/src/zoom_control.dart';

/// A convenience widget that combines a [ZoomControl] and a [PanControl] to
/// interact with an [InteractiveViewer].
class PanZoomControl extends StatelessWidget {
  /// The initial visible area, will also be used to update the area if changed
  /// externally.
  final Size viewportSize;

  /// The size of the canvas that is being controlled.
  final Size contentSize;

  /// The [TransformationController] that is connected to the
  /// [InteractiveViewer] linked with the control.
  final TransformationController controller;

  /// The [BoxDecoration] for the entire pan control.
  final BoxDecoration? decoration;

  /// The [BoxDecoration] for the drag handle.
  final BoxDecoration handleDecoration;

  /// The [BoxDecoration] for the foreground of the drag handle.
  final BoxDecoration? handleForegroundDecoration;

  /// The child [Widget] to display
  final Widget child;

  /// The minimum scale allowed.
  final double minScale;

  /// The maximum scale allowed.
  final double maxScale;

  /// The space between the slider and text widget displaying the value.
  final double columnSpacing;

  /// The space between the zoom and the pan control.
  final double rowSpacing;

  /// The width of the label.
  final double labelWidth;

  /// The [TextStyle] to apply to the label text.
  final TextStyle? textStyle;

  /// The [SliderTheme] applied to the zoom slider.
  final SliderThemeData? sliderThemeData;

  const PanZoomControl({
    Key? key,
    required this.viewportSize,
    required this.contentSize,
    required this.controller,
    this.decoration,
    required this.handleDecoration,
    this.handleForegroundDecoration,
    required this.child,
    required this.minScale,
    required this.maxScale,
    this.columnSpacing = 8,
    this.labelWidth = 40,
    this.textStyle,
    this.sliderThemeData,
    this.rowSpacing = 15,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        ZoomControl(
          key: const Key('panZoomControl_zoomControl'),
          controller: controller,
          minScale: minScale,
          maxScale: maxScale,
          columnSpacing: columnSpacing,
          textStyle: textStyle,
          sliderThemeData: sliderThemeData,
          labelWidth: labelWidth,
        ),
        SizedBox(
          height: rowSpacing,
        ),
        PanControl(
          key: const Key('panZoomControl_panControl'),
          contentSize: contentSize,
          viewportSize: viewportSize,
          controller: controller,
          decoration: decoration,
          handleDecoration: handleDecoration,
          handleForegroundDecoration: handleForegroundDecoration,
          child: child,
        ),
      ],
    );
  }
}
