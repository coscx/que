import 'dart:ui';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_geen/views/component/radar_view.dart';
import 'package:radial_menu/radial_menu.dart';

import 'flow_circle.dart';


class FlowBottomSheet extends StatelessWidget {
  const FlowBottomSheet({Key key}) : super(key: key);


  @override
  Widget build(BuildContext context) {
    List<RadialMenuEntry> radialMenuEntries = [
      RadialMenuEntry(icon: Icons.restaurant, text: 'Restaurant'),
      RadialMenuEntry(icon: Icons.hotel,text: 'Hotel'),
      RadialMenuEntry(icon: Icons.pool, text: 'Pool'),
      RadialMenuEntry(icon: Icons.shopping_cart, text: 'Shop'),


    ];
    return BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 12, sigmaY: 12),
        child: Material(
            color: Colors.black12,
            child: Scaffold(
              backgroundColor: CupertinoTheme.of(context)
                  .scaffoldBackgroundColor
                  .withOpacity(0.9),
              extendBodyBehindAppBar: true,
              appBar: appBar(context),
              body: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,

                //physics: ClampingScrollPhysics(),
                //controller: ModalScrollController.of(context),
                children: <Widget>[
                  Container(

                    child: Container(
                        margin: EdgeInsets.only(top: 200.h,bottom: 200.h),

                        child: RadialMenu(entries: radialMenuEntries,)
                    )
                  ),

                ],
              ),
            )));
  }


  PreferredSizeWidget appBar(BuildContext context) {
    return PreferredSize(
      preferredSize: Size(double.infinity, 74.w),
      child: ClipRect(
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 12, sigmaY: 12),
          child: Container(
            color: CupertinoTheme.of(context)
                .scaffoldBackgroundColor
                .withOpacity(0.0),
            child: Column(
              children: <Widget>[
                Expanded(
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      SizedBox(width: 18.w),
                      GestureDetector(
                        onTap: () => Navigator.of(context).pop(),
                        child: Align(
                          alignment: Alignment.topCenter,
                          child: Container(
                            margin: EdgeInsets.only(top: 14.h),
                            padding: EdgeInsets.all(4.w),
                            decoration: BoxDecoration(
                              color: Colors.black.withOpacity(0.1),
                              shape: BoxShape.circle,
                            ),
                            child: Icon(
                              Icons.close,
                              size: 50.sp,
                              color: Colors.black.withAlpha(66),
                            ),
                          ),
                        ),
                      ),
                      SizedBox(width: 10.w),
                      Expanded(
                          child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: <Widget>[],
                      )),
                      SizedBox(width: 14.w),
                    ],
                  ),
                ),
                Container(height: 1.h),
              ],
            ),
          ),
        ),
      ),
    );
  }
}



class SimpleSliverDelegate extends SliverPersistentHeaderDelegate {
  final Widget child;
  final double height;

  SimpleSliverDelegate({
    this.child,
    this.height,
  });

  @override
  Widget build(
      BuildContext context, double shrinkOffset, bool overlapsContent) {
    return SizedBox(height: height, child: child);
  }

  @override
  double get minExtent => height;

  @override
  double get maxExtent => height;

  @override
  bool shouldRebuild(SliverPersistentHeaderDelegate oldDelegate) {
    return false;
  }
}


