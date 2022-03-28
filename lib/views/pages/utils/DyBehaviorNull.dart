import 'dart:io';
import 'package:flutter/material.dart';

class DyBehaviorNull extends ScrollBehavior {
  @override
  Widget buildViewportChrome(BuildContext context, Widget child, AxisDirection axisDirection) {
    if (Platform.isAndroid || Platform.isFuchsia) {
      return child;
    } else {
      return super.buildViewportChrome(context,child,axisDirection);
    }
  }
}


class MyScrollPhysics extends BouncingScrollPhysics {
  const MyScrollPhysics({ScrollPhysics parent}) : super(parent: parent);
  @override
  MyScrollPhysics applyTo(ScrollPhysics ancestor) {
    return MyScrollPhysics(parent: buildParent(ancestor));
  }

  @override
  double adjustPositionForNewDimensions({
    ScrollMetrics oldPosition,
    ScrollMetrics newPosition,
    bool isScrolling,
    double velocity,
  }) {
    return newPosition.pixels;
  }
}