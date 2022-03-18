import 'dart:ui';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_geen/views/component/radar_view.dart';


class PhotoShareBottomSheet extends StatelessWidget {
  const PhotoShareBottomSheet({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
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

                    child: Stack(
                      children: [


                        Container(
                            padding:  EdgeInsets.only(
                                top: 80.h,
                                left: 100.w,
                                right: 100.w,
                                bottom: 0.w
                            ),
                          child: Container(
                            height: 600.h,
                            width: 600.w,

                            child: Image.asset(
                                "assets/images/main_page/chat_matching_radar.png"),
                          )
                        ),
                        Container(
                            padding:  EdgeInsets.only(
                                top: 80.h,
                                left: 100.w,
                                right: 100.w,
                                bottom: 0.w
                            ),
                            //height: 500.h,
                            child: Container(
                              height: 600.h,
                              width: 600.w,
                              //alignment: FractionalOffset.topLeft,
                              child:    RadarView(),
                            )
                        ),

                      ],
                    ),
                  ),
                  Container(
                    child: Container(
                      //height: 700.h,
                      //color: Colors.red,
                      decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(20.w),
                              topRight: Radius.circular(20.w))),
                      margin: EdgeInsets.fromLTRB(10.w, 10.w, 10.w, 0),
                      child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: <Widget>[
                            SizedBox(
                              height: 15.h,
                            ),
                            Row(
                              children: <Widget>[
                                SizedBox(
                                  width: 30.w,
                                ),
                                Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: <Widget>[
                                      Container(
                                        height: 160.h,
                                        width: 160.w,
                                        alignment: FractionalOffset.topLeft,
                                        child: Image.asset(
                                            "assets/packages/images/tab_match.webp"),
                                      ),
                                    ]),
                              ],
                            ),
                            Container(
                              height: 350.h,
                              //color: Colors.red,
                              decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(5.w)),
                              margin: EdgeInsets.fromLTRB(10.w, 5.h, 10.w, 0),
                              child: SingleChildScrollView(
                                  physics: const BouncingScrollPhysics(),
                                  child: Column(children: <Widget>[

                                    Wrap(
                                      spacing: 40.w,
                                      runSpacing: 0.w,
                                      children: <Widget>[
                                        buildButton("...",
                                            "assets/images/main_page/home_entry_icon_under.png","assets/images/main_page/home_entry_bg_under.png"),
                                        buildButton("...",
                                            "assets/images/main_page/home_entry_icon_wolf.png","assets/images/main_page/home_entry_bg_wolf.png"),
                                        buildButton("...",
                                            "assets/images/main_page/home_entry_icon_team.png","assets/images/main_page/home_entry_bg_team.png"),
                                        buildButton("...",
                                            "assets/images/main_page/home_entry_icon_radio.png","assets/images/main_page/home_entry_bg_under.png"),
                                        buildButton("...",
                                            "assets/images/main_page/home_entry_icon_party.png","assets/images/main_page/home_entry_bg_party.png"),
                                        buildButton("...",
                                            "assets/images/main_page/home_entry_icon_guess.png","assets/images/main_page/home_entry_bg_guess.png"),
                                        buildButton("...",
                                            "assets/images/main_page/home_entry_icon_juben.png","assets/images/main_page/home_entry_bg_juben.png"),
                                        buildButton("...",
                                            "assets/images/main_page/home_entry_icon_game.png","assets/images/main_page/home_entry_bg_game.png"),
                                      ],
                                    ),
                                    // SizedBox(
                                    //   height: 100.h,
                                    // ),
                                  ])),
                            ),
                          ]),
                    ),
                  ),
                ],
              ),
            )));
  }

  Widget buildButton(String name, String url,String bg) {
    return Stack(
      children: [
        Container(
            color: Colors.white,
            height: 160.h,
            width: 130.w,
            child: Column(children: <Widget>[
              SizedBox(
                height: 2.h,
              ),
              Image.asset(bg),
              SizedBox(
                height: 8.h,
              ),
              Text(name,
                  style: TextStyle(
                      color: Colors.black.withAlpha(88),
                      fontSize: 25.sp,
                      fontWeight: FontWeight.w400)),
              SizedBox(
                height: 0.h,
              )
            ])),
        Container(
            color: Colors.white,
            height: 160.h,
            width: 130.w,
            child: Column(children: <Widget>[
              SizedBox(
                height: 2.h,
              ),
              Image.asset(url),
              SizedBox(
                height: 8.h,
              ),
              Text(name,
                  style: TextStyle(
                      color: Colors.black.withAlpha(88),
                      fontSize: 25.sp,
                      fontWeight: FontWeight.w400)),
              SizedBox(
                height: 0.h,
              )
            ])),


      ],
    );
  }

  Widget sliverContactsSection(BuildContext context) {
    return SliverToBoxAdapter(
      child: Container(
        height: 132.h,
        padding: EdgeInsets.only(top: 12.h),
        child: ListView.builder(
          padding: EdgeInsets.all(10),
          scrollDirection: Axis.horizontal,
          itemBuilder: (context, index) {
            final person = people[index];
            return Container(
              width: 72.w,
              margin: EdgeInsets.symmetric(horizontal: 4.w),
              child: Column(
                children: <Widget>[
                  SizedBox(height: 8.h),
                  Text(
                    person.title,
                    maxLines: 2,
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 11.sp),
                  )
                ],
              ),
            );
          },
          itemCount: people.length,
        ),
      ),
    );
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

class Item {
  final String title;
  final String imageUrl;

  Item(this.title, this.imageUrl);
}

final people = [
  Item('MacBook Pro', 'assets/MacBook.jpg'),
  Item('Jaime Blasco', 'assets/jaimeblasco.jpeg'),
  Item('Mya Johnston', 'assets/person1.jpeg'),
  // https://images.unsplash.com/photo-1520813792240-56fc4a3765a7'
  Item('Maxime Nicholls', 'assets/person4.jpeg'),
  //https://images.unsplash.com/photo-1568707043650-eb03f2536825'
  Item('Susanna Thorne', 'assets/person2.jpeg'),
  //https://images.unsplash.com/photo-1520719627573-5e2c1a6610f0
  Item('Jarod Aguilar', 'assets/person3.jpeg')
  //https://images.unsplash.com/photo-1547106634-56dcd53ae883
];

final apps = [
  Item('Messages', 'assets/message.png'),
  Item('Github', 'assets/github_app.png'),
  Item('Slack', 'assets/slack.png'),
  Item('Twitter', 'assets/twitter.png'),
  Item('Mail', 'assets/mail.png'),
];

final actions = [
  Item('Copy Photo', null),
];
final actions1 = [
  Item('Add to Shared Album', null),
  Item('Add to Album', null),
  Item('Duplicate', null),
  Item('Hide', null),
  Item('Slideshow', null),
  Item('AirPlay', null),
  Item('Use as Wallpaper', null),
];

final actions2 = [
  Item('Create Watch', null),
  Item('Save to Files', null),
  Item('Asign to Contact', null),
  Item('Print', null),
];

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



// class BottomSheet extends StatefulWidget {
//   @override
//   _BottomSheetState createState() => _BottomSheetState();
// }
//
// class _BottomSheetState extends State<BottomSheet> {
//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       child: GestureDetector(
//         child: Container(),
//         onTap: () {
//           showBottomPop(context);
//         },
//       ),
//     );
//   }
// }
//
// showBottomPop(BuildContext context) {
//   return showModalBottomSheet(
//       context: context,
//       isScrollControlled: true, //可滚动 解除showModalBottomSheet最大显示屏幕一半的限制
//       shape: RoundedRectangleBorder(
//           //圆角
//           //borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
//           ),
//       builder: (BuildContext context) {
//         return AnimatedPadding(
//           //showModalBottomSheet 键盘弹出时自适应
//           padding: MediaQuery.of(context).viewInsets, //边距（必要）
//           duration: const Duration(milliseconds: 100), //时常 （必要）
//           child: Container(
//             height: 1080.h,
//             constraints: BoxConstraints(
//               minHeight: 90.h, //设置最小高度（必要）
//               maxHeight: MediaQuery.of(context).size.height / 1, //设置最大高度（必要）
//             ),
//             padding: EdgeInsets.only(top: 34.h, bottom: 48.h),
//             decoration: BoxDecoration(
//                 borderRadius: BorderRadius.vertical(top: Radius.circular(20.w)),
//                 color: Colors.white),
//             //圆角
//             child: ListView(
//               shrinkWrap: true, //防止状态溢出 自适应大小
//               physics: const NeverScrollableScrollPhysics(),
//               children: <Widget>[
//                 Column(
//                   mainAxisSize: MainAxisSize.min,
//                   mainAxisAlignment: MainAxisAlignment.start,
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: <Widget>[
//                     //widget组件
//                     Container(
//                       height: 50,
//                       child: Text("123"),
//                     ),
//
//                     Container(
//                       height: 50,
//                       child: Text("456"),
//                     ),
//                     Container(
//                       height: 50,
//                       child: Text("789"),
//                     ),
//
//                     ListView(
//                       shrinkWrap: true, //防止状态溢出 自适应大小
//                       physics: BouncingScrollPhysics(),
//                       children: <Widget>[
//                         Column(
//                           mainAxisSize: MainAxisSize.min,
//                           mainAxisAlignment: MainAxisAlignment.start,
//                           crossAxisAlignment: CrossAxisAlignment.start,
//                           children: <Widget>[
//                             //widget组件
//                             Container(
//                               height: 50,
//                               child: Text("1111"),
//                             ),
//
//                             Container(
//                               height: 50,
//                               child: Text("2222"),
//                             ),
//                             Container(
//                               height: 50,
//                               child: Text("3333"),
//                             ),
//                             Container(
//                               height: 50,
//                               child: Text("2222"),
//                             ),
//                             Container(
//                               height: 50,
//                               child: Text("2222"),
//                             ),
//                             Container(
//                               height: 50,
//                               child: Text("2222"),
//                             ),
//                             Container(
//                               height: 50,
//                               child: Text("2222"),
//                             ),
//                             Container(
//                               height: 50,
//                               child: Text("2222"),
//                             ),
//                             Container(
//                               height: 50,
//                               child: Text("2222"),
//                             ),
//                             Container(
//                               height: 50,
//                               child: Text("2222"),
//                             ),
//                             Container(
//                               height: 50,
//                               child: Text("2222"),
//                             ),
//                             Container(
//                               height: 50,
//                               child: Text("2222"),
//                             ),
//                             Container(
//                               height: 50,
//                               child: Text("2222"),
//                             ),
//                             Container(
//                               height: 50,
//                               child: Text("2222"),
//                             ),
//                             Container(
//                               height: 50,
//                               child: Text("2222"),
//                             ),
//                             Container(
//                               height: 50,
//                               child: Text("2222"),
//                             ),
//                             Container(
//                               height: 50,
//                               child: Text("2222"),
//                             ),
//                             Container(
//                               height: 50,
//                               child: Text("2222"),
//                             ),
//                           ],
//                         )
//                       ],
//                     ),
//                   ],
//                 )
//               ],
//             ),
//           ),
//         );
//       });
// }
