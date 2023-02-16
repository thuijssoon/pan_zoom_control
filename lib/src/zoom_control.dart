import 'package:flutter/material.dart';

/// A widget which allows a user to zoom an [InteractiveViewer].
class ZoomControl extends StatefulWidget {
  /// The [TransformationController] that is connected to the
  /// [InteractiveViewer] linked with the control.
  final TransformationController controller;

  /// The minimum scale allowed.
  final double minScale;

  /// The maximum scale allowed.
  final double maxScale;

  /// The space between the slider and text widget displaying the value.
  final double columnSpacing;

  /// The width of the label.
  final double labelWidth;

  /// The [TextStyle] to apply to the label text.
  final TextStyle? textStyle;

  /// The [SliderTheme] applied to the zoom slider.
  final SliderThemeData? sliderThemeData;

  const ZoomControl({
    Key? key,
    required this.controller,
    required this.minScale,
    required this.maxScale,
    this.columnSpacing = 8,
    this.textStyle,
    this.sliderThemeData,
    this.labelWidth = 40,
  }) : super(key: key);

  @override
  State<ZoomControl> createState() => _ZoomControlState();
}

class _ZoomControlState extends State<ZoomControl> {
  late final TransformationController _controller;
  double _scale = 1;

  @override
  void initState() {
    super.initState();
    _controller = widget.controller;
    _updateState();
    _controller.addListener(_updateState);
  }

  @override
  Widget build(BuildContext context) {
    final SliderThemeData themeData =
        widget.sliderThemeData ?? SliderTheme.of(context);
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Expanded(
          child: SliderTheme(
            data: themeData,
            child: Slider(
              key: const Key('zoomControl_slider'),
              value: _scale,
              min: widget.minScale,
              max: widget.maxScale,
              onChanged: _updateController,
            ),
          ),
        ),
        SizedBox(
          width: widget.columnSpacing,
        ),
        SizedBox(
          width: widget.labelWidth,
          child: Text(
            key: const Key('zoomControl_text'),
            '${(_scale * 100).round()}%',
            textAlign: TextAlign.right,
            style: widget.textStyle,
          ),
        )
      ],
    );
  }

  /// Update [_scale] when the value of the [_controller] is changed.
  void _updateState() {
    final double scale = _controller.value.getMaxScaleOnAxis();
    if (_scale != scale) {
      setState(() {
        _scale = scale;
      });
    }
  }

  /// Update the [_controller] with the new [scale] from the slider.
  void _updateController(double scale) {
    final matrix = _controller.value.clone();
    // The scale needs to be done proportionally.
    matrix.scale(scale / _scale);
    setState(() {
      _controller.value = matrix;
    });
  }
}
