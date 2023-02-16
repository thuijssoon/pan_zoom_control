import 'package:flutter/material.dart';

/// A widget which allows a user to pan an [InteractiveViewer].
class PanControl extends StatefulWidget {
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

  const PanControl({
    Key? key,
    required this.viewportSize,
    required this.contentSize,
    required this.controller,
    this.decoration,
    required this.handleDecoration,
    this.handleForegroundDecoration,
    required this.child,
  }) : super(key: key);

  @override
  State<PanControl> createState() => _PanControlState();
}

class _PanControlState extends State<PanControl> {
  /// The [TransformationController] connected to the [InteraactiveViewer].
  late final TransformationController _controller;

  /// The relative height of the drag handle.
  double _relativeHeight = 0;

  /// The relative width of the drag handle.
  double _relativeWidth = 0;

  /// The relative top of the drag handle.
  double _relativeTop = 0;

  /// The relative left of the drag handle.
  double _relativeLeft = 0;

  /// Whether the user is currently panning. Used to change the cursor.
  bool _panning = false;

  @override
  void initState() {
    super.initState();
    _controller = widget.controller;
    _updateState();
    _controller.addListener(_updateState);
  }

  @override
  Widget build(BuildContext context) {
    final aspectRatio = widget.contentSize.width / widget.contentSize.height;
    return LayoutBuilder(
      builder: (context, constraints) {
        final double width = constraints.maxWidth;
        final double height = width / aspectRatio;
        final double top = _relativeTop * height;
        final double left = _relativeLeft * width;
        final dragHandle = GestureDetector(
          key: const Key('panControl_gestureDetector'),
          onPanStart: (details) {
            setState(() {
              _panning = true;
            });
          },
          onPanEnd: (details) {
            setState(() {
              _panning = false;
            });
          },
          onPanUpdate: (details) {
            final rLeft = ((details.delta.dx) / width).clamp(-1.0, 1.0);
            final rTop = ((details.delta.dy) / height).clamp(-1.0, 1.0);
            _updateController(rLeft, rTop);
          },
          child: MouseRegion(
            cursor:
                _panning ? SystemMouseCursors.grabbing : SystemMouseCursors.grab,
            child: Container(
              decoration: widget.handleDecoration,
              foregroundDecoration: widget.handleForegroundDecoration,
            ),
          ),
        );

        return Container(
          decoration: widget.decoration,
          clipBehavior: Clip.antiAlias,
          height: height,
          child: Stack(
            children: [
              FittedBox(
                key: const Key('panControl_fittedBox'),
                fit: BoxFit.fitWidth,
                child: widget.child,
              ),
              Positioned(
                key: const Key('panControl_positioned'),
                left: left,
                top: top,
                width: _relativeWidth * width,
                height: _relativeHeight * height,
                child: dragHandle,
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  void didUpdateWidget(PanControl oldWidget) {
    super.didUpdateWidget(oldWidget);
    _updateState();
  }

  /// Update [_relativeLeft], [_relativeTop], [_relativeWidth] and
  /// [_relativeHeight] when the value of the [_controller] is changed.
  void _updateState() {
    final double scale = _controller.value.getMaxScaleOnAxis();
    final double left = _controller.value.getTranslation()[0] / scale;
    final double top = _controller.value.getTranslation()[1] / scale;
    final viewportWidth = widget.viewportSize.width / scale;
    final viewportHeight = widget.viewportSize.height / scale;
    final contentWidth = widget.contentSize.width;
    final contentHeight = widget.contentSize.height;

    double rLeft, rTop, rWidth, rHeight;

    // Calculate relative width / left
    if (left <= 0) {
      rLeft = left.abs() / contentWidth;
      rWidth = (contentWidth + left).clamp(0, viewportWidth) / contentWidth;
    } else {
      rLeft = 0;
      rWidth = (viewportWidth - left).clamp(0, contentWidth) / contentWidth;
    }

    // Calculate relative width / left
    if (top <= 0) {
      rTop = top.abs() / contentHeight;
      rHeight = (contentHeight + top).clamp(0, viewportHeight) / contentHeight;
    } else {
      rTop = 0;
      rHeight = (viewportHeight - top).clamp(0, contentHeight) / contentHeight;
    }

    setState(() {
      if (_relativeLeft != rLeft) {
        _relativeLeft = rLeft;
      }
      if (_relativeTop != rTop) {
        _relativeTop = rTop;
      }
      if (_relativeWidth != rWidth) {
        _relativeWidth = rWidth;
      }
      if (_relativeHeight != rHeight) {
        _relativeHeight = rHeight;
      }
    });
  }

  /// Update the [_controller] with the new [left] and [top] of the drag handle.
  _updateController(double left, double top) {
    final matrix = _controller.value.clone();
    final x = (widget.contentSize.width * -left);
    final y = (widget.contentSize.height * -top);
    matrix.translate(x, y);
    setState(() {
      _controller.value = matrix;
    });
  }
}
