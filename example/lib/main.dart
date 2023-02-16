import 'dart:math';

import 'package:flutter/material.dart';
import 'package:pan_zoom_control/pan_zoom_control.dart';

import 'custom_slider_theme.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  MyApp({super.key});
  final TransformationController controller = TransformationController();

  @override
  Widget build(BuildContext context) {
    // final image = Image.asset('assets/landscape.jpeg');
    return MaterialApp(
      home: Scaffold(
        body: LayoutBuilder(
          builder: (context, constraints) {
            final Size viewportSize =
            Size(constraints.maxWidth, constraints.maxHeight);
            const Size contentSize = Size(1500, 1000);
            const double minScale = 0.1;
            const double maxScale = 2.0;
            return Stack(
              children: <Widget>[
                InteractiveViewer(
                  boundaryMargin: EdgeInsets.all(min(
                      viewportSize.width.toDouble(),
                      viewportSize.height.toDouble()) /
                      2),
                  constrained: false,
                  minScale: minScale,
                  maxScale: maxScale,
                  transformationController: controller,
                  child: Image.asset('assets/landscape.jpeg'),
                ),
                Positioned(
                  left: 10,
                  top: 10,
                  child: Container(
                    width: 250,
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(8),
                      boxShadow: const [
                        BoxShadow(
                            blurRadius: 40,
                            spreadRadius: 0,
                            offset: Offset(0, 15),
                            color: Color(
                              0x406F7B8D,
                            ))
                      ],
                    ),
                    child: PanZoomControl(
                      controller: controller,
                      minScale: minScale,
                      maxScale: maxScale,
                      sliderThemeData: SliderThemeData(
                        trackHeight: 3.0,
                        // trackShape: const RoundedRectSliderTrackShape(),
                        activeTrackColor: const Color(0xff9CA0B6),
                        inactiveTrackColor: const Color(0xffE0E9F4),
                        thumbShape: const CustomRoundSliderThumbShape(
                          enabledThumbRadius: 7.5,
                          elevation: 3,
                          pressedElevation: 0,
                          enabledBorderColor: Colors.white,
                          enabledBorderWidth: 3,
                        ),
                        trackShape: CustomTrackShape(),
                        overlayShape: SliderComponentShape.noOverlay,
                        thumbColor: const Color(0xff9CA0B6),
                      ),
                      contentSize: contentSize,
                      viewportSize: viewportSize,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(8),
                      ),
                      handleDecoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(
                          color: Colors.white70,
                          width: 3000,
                          strokeAlign: BorderSide.strokeAlignOutside,
                        ),
                        // color: Colors.black38,
                      ),
                      handleForegroundDecoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(
                          color: const Color(0xff727897),
                          width: 2,
                          strokeAlign: BorderSide.strokeAlignCenter,
                        ),
                      ),
                      child: Container(
                        width: contentSize.width,
                        height: contentSize.height,
                        color: Colors.black12,
                        child: Image.asset('assets/landscape.jpeg'),
                      ),
                    ),
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}