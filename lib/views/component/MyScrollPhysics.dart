import 'package:flutter/cupertino.dart';

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