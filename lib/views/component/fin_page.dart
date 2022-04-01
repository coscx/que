import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_geen/views/component/refresh.dart';
import 'package:flutter_geen/views/pages/chat/utils/DyBehaviorNull.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

class FinPage extends StatefulWidget {
  @override
  _FinPageState createState() => _FinPageState();
}

class _FinPageState extends State<FinPage> {
  RefreshController _refreshController =
      RefreshController(initialRefresh: false);
  bool show = false;
  double heights = 70;
  Color cc = Colors.transparent;
  double opacity =1.0;
  @override
  Widget build(BuildContext context) {
    return Theme(
        data: ThemeData(
          appBarTheme: AppBarTheme.of(context).copyWith(
            brightness: Brightness.light,
          ),
        ),
        child: Scaffold(
            //endDrawer: CategoryEndDrawer(),
            appBar: AppBar(
              backgroundColor: Colors.white,
              elevation: 0,
              //去掉Appbar底部阴影
              leading: IconButton(
                icon: Icon(Icons.arrow_back, color: Colors.black),
                onPressed: () => Navigator.of(context).pop(),
              ),
              title: Text("",
                  style: TextStyle(
                    fontFamily: "Quicksand",
                    fontWeight: FontWeight.w900,
                    fontStyle: FontStyle.italic,
                    fontSize: 38.sp,
                    decoration: TextDecoration.none,
                    color: Colors.black,
                  )),
              actions: <Widget>[],
            ),
            body: Container(
              height: ScreenUtil().screenHeight,
              decoration: BoxDecoration(
                  gradient: LinearGradient(
                stops: [0, 0.5, 1],
                colors: [
                  Color(0xffE2F1FF),
                  Color(0xffF9FBEB),
                  Color(0xffFFF4FA)
                ],
                begin: Alignment(2, 1),
                end: Alignment(-2, -1),
              )),
              child: Stack(
                children: [
                  _buildContent(context),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      SizedBox(
                        width: 10.w,
                      ),
                      MyCard(),
                      MyCard1(),
                      SizedBox(
                        width: 10.w,
                      ),
                    ],
                  ),
                  _buildHeader(context),
                ],
              ),
            )));
  }

  Future<bool> _whenPop(BuildContext context) async {
    if (Scaffold.of(context).isEndDrawerOpen) return true;
    return true;
  }

// 下拉刷新
  void _onRefresh() async {
    _refreshController.refreshCompleted();
  }

// 上拉加载
  void _onLoading() async {
    _refreshController.loadComplete();
  }

  Widget _buildContent(BuildContext context) => WillPopScope(
      onWillPop: () => _whenPop(context),
      child: ScrollConfiguration(
          behavior: DyBehaviorNull(),
          child: Opacity(
            opacity: opacity,
            child: Container(
              decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(40.w),
                      topRight: Radius.circular(40.w))),
              margin: EdgeInsets.only(top: 160.h),
              child: Container(
                margin: EdgeInsets.only(top: 60.h),
                child: SmartRefresher(
                    enablePullDown: true,
                    enablePullUp: false,
                    header: DYrefreshHeader(),
                    footer: DYrefreshFooter(),
                    controller: _refreshController,
                    onRefresh: _onRefresh,
                    onLoading: _onLoading,
                    child: Container(
                      child: SingleChildScrollView(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: <Widget>[
                            MyContent(),
                            MyContent(),
                            MyContent(),
                            MyContent(),
                            MyContent(),
                          ],
                        ),
                      ),
                    )),
              ),
            ),
          )));

  Widget _buildHeader(BuildContext context) => Container(
        margin: EdgeInsets.only(top: 160.h),
        child: Container(
          height: heights,
          decoration: BoxDecoration(
              color: cc,
              borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(40.w),
                  topRight: Radius.circular(40.w))),
          child: Container(
            padding: EdgeInsets.only(left: 40.h),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Row(
                  children: [
                    Container(
                      child: Text(
                        "请选择当前状态",
                        style: TextStyle(fontSize: 30.sp, color: Colors.black),
                      ),
                    ),
                    Container(
                      child: IconButton(
                        icon: Icon(show?Icons.keyboard_arrow_up_outlined:Icons.keyboard_arrow_down_outlined),
                        onPressed: () {
                          print(1);
                          setState(() {
                            show = !show;
                            if (show) {
                              heights = 450.h;
                              cc = Colors.white;
                              opacity= 0.1;
                            } else {
                              heights = 80.h;
                              cc = Colors.transparent;
                              opacity= 1.0;
                            }
                          });
                        },
                      ),
                    ),
                  ],
                ),
                Visibility(
                  visible: show,
                  child: Column(
                    children: [
                      buildButton(context),
                      Container(
                        padding: EdgeInsets.only(top: 60.h),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Container(
                              padding: EdgeInsets.only(
                                  left: 0.w,
                                  top: 6.h,
                                  right: 25.w,
                                  bottom: 16.h),
                              height: 88.h,
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: <Widget>[
                                  GestureDetector(
                                    onTap: () {
                                      setState(() {
                                        show = !show;
                                        if (show) {
                                          heights = 450.h;
                                          cc = Colors.white;
                                          opacity= 0.1;
                                        } else {
                                          heights = 80.h;
                                          cc = Colors.transparent;
                                          opacity= 1.0;
                                        }
                                      });
                                    },
                                    child: Container(
                                      padding: EdgeInsets.only(
                                          left: 100.w,
                                          top: 6.h,
                                          right: 100.w,
                                          bottom: 6.h),
                                      height: 68.h,
                                      decoration: BoxDecoration(
                                        border: Border(
                                          left: BorderSide(
                                              color: Colors.grey, width: 2.w),
                                          top: BorderSide(
                                              color: Colors.grey, width: 2.w),
                                          right: BorderSide(
                                              color: Colors.grey, width: 2.w),
                                          bottom: BorderSide(
                                              color: Colors.grey, width: 2.w),
                                        ),
                                        color: Colors.white,
                                        borderRadius: BorderRadius.only(
                                          topLeft: Radius.circular(34.w),
                                          bottomLeft: Radius.circular(34.w),
                                        ),
                                      ),
                                      child: Container(
                                        child: Text(
                                          '重置',
                                          style: TextStyle(
                                              color: Colors.black,
                                              fontSize: 30.sp),
                                          textAlign: TextAlign.center,
                                        ),
                                      ),
                                      alignment: Alignment.centerLeft,
                                    ),
                                  ),
                                  GestureDetector(
                                    onTap: () {
                                      setState(() {
                                        show = !show;
                                        if (show) {
                                          heights = 450.h;
                                          cc = Colors.white;
                                          opacity= 0.1;
                                        } else {
                                          heights = 80.h;
                                          cc = Colors.transparent;
                                          opacity= 1.0;
                                        }
                                      });
                                    },
                                    child: Container(
                                      padding: EdgeInsets.only(
                                          left: 98.w,
                                          top: 6.h,
                                          right: 100.w,
                                          bottom: 6.h),
                                      height: 68.h,
                                      decoration: BoxDecoration(
                                        color: Colors.blue,
                                        borderRadius: BorderRadius.horizontal(
                                            right: Radius.circular(34.w)),
                                      ),
                                      child: Container(
                                        child: Text('确定',
                                            style: TextStyle(
                                                fontSize: 30.sp,
                                                color: Colors.white)),
                                      ),
                                      alignment: Alignment.centerLeft,
                                    ),
                                  ),
                                ],
                              ),
                            )
                          ],
                        ),
                      ),
                    ],
                  ),
                )
              ],
            ),
          ),
        ),
      );
}

Widget buildButton(BuildContext context) {
  bool v1 = false;
  return Container(
    padding: EdgeInsets.only(left: 0.w, right: 0.w),
    alignment: Alignment.centerLeft,
    child: Wrap(runSpacing: 30.w, spacing: 20.w, children: [
      MButton(),
      MButton(),
      MButton(),
      MButton(),
      MButton(),
    ]),
  );
}

class MButton extends StatefulWidget {
  @override
  _MButtonState createState() => _MButtonState();
}

class _MButtonState extends State<MButton> {
  bool selected = false;

  @override
  Widget build(BuildContext context) {
    return ChoiceChip(
      backgroundColor: selected ? Colors.white : Colors.grey.withAlpha(33),
      selectedColor: selected ? Colors.transparent : Colors.grey.withAlpha(33),
      side: BorderSide(
          width: 2.w, color: selected ? Colors.blue : Colors.transparent),
      padding:
          EdgeInsets.only(left: 50.w, right: 50.w, top: 20.h, bottom: 20.h),
      labelPadding: EdgeInsets.only(left: 0.w, right: 0.w),
      selectedShadowColor: Colors.transparent,
      shadowColor: Colors.transparent,
      pressElevation: 0,
      elevation: 0,
      label: Text(
        "中国话",
        style: TextStyle(
            color: selected ? Colors.blue : Colors.black,
            fontSize: 35.sp,
            fontWeight: FontWeight.normal),
        overflow: TextOverflow.ellipsis,
      ),
      selected: selected,
      onSelected: (bool value) {
        setState(() {
          selected = value;
        });
      },
    );
  }
}

class MyCard extends StatefulWidget {
  @override
  _MyCardState createState() => _MyCardState();
}

class _MyCardState extends State<MyCard> {
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(top: 20.h),
      decoration: BoxDecoration(
          gradient: LinearGradient(
            stops: [0, 1],
            colors: [Color(0xffA4D3FF), Color(0xff1890FF)],
            begin: Alignment(1, -1),
            end: Alignment(-1, -1),
          ),
          borderRadius: BorderRadius.all(Radius.circular(20.w))),
      width: 320.w,
      height: 120.h,
      child: Stack(
        children: [
          Row(
            children: [
              Container(
                margin: EdgeInsets.only(top: 20.h, left: 30.w),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                        margin: EdgeInsets.only(bottom: 10.h),
                        child: Text("哈哈哈哈哈",
                            style: TextStyle(
                                color: Colors.white, fontSize: 30.sp))),
                    Container(
                        child: Text("20",
                            style: TextStyle(
                                color: Colors.white, fontSize: 30.sp))),
                  ],
                ),
              ),
              Column(
                children: [
                  Container(),
                ],
              ),
            ],
          ),
          Positioned(
              bottom: 0,
              right: 10.w,
              child: Container(
                  width: 110.w,
                  height: 110.h,
                  child: Image.asset("assets/images/default/customer.png")))
        ],
      ),
    );
  }
}

class MyCard1 extends StatefulWidget {
  @override
  _MyCard1State createState() => _MyCard1State();
}

class _MyCard1State extends State<MyCard1> {
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(top: 20.h),
      decoration: BoxDecoration(
          gradient: LinearGradient(
            stops: [0, 1],
            colors: [Color(0xffFFB83A), Color(0xffFFD58A)],
            begin: Alignment(-1, -1),
            end: Alignment(1, -1),
          ),
          borderRadius: BorderRadius.all(Radius.circular(20.w))),
      width: 320.w,
      height: 120.h,
      child: Stack(
        children: [
          Row(
            children: [
              Container(
                margin: EdgeInsets.only(top: 20.h, left: 30.w),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                        margin: EdgeInsets.only(bottom: 10.h),
                        child: Text("哈哈哈哈哈",
                            style: TextStyle(
                                color: Colors.white, fontSize: 30.sp))),
                    Container(
                        child: Text("20",
                            style: TextStyle(
                                color: Colors.white, fontSize: 30.sp))),
                  ],
                ),
              ),
              Column(
                children: [
                  Container(),
                ],
              ),
            ],
          ),
          Positioned(
              bottom: 0,
              right: 10.w,
              child: Container(
                  width: 110.w,
                  height: 110.h,
                  child: Image.asset("assets/images/default/money.png")))
        ],
      ),
    );
  }
}
class MyContent extends StatefulWidget {
  @override
  _MyContentState createState() => _MyContentState();
}

class _MyContentState extends State<MyContent> {
  @override
  Widget build(BuildContext context) {
    return   Container(
      margin: EdgeInsets.only(top: 10.h, left: 40.w),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Column(
            children: [
              Container(
                  width: 110.w,
                  height: 110.h,
                  child: Image.asset("assets/images/default/select.png"))
            ],
          ),
          Container(
            margin: EdgeInsets.only(top: 20.h, left: 30.w),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                    margin: EdgeInsets.only(bottom: 10.h),
                    child: Text("哈哈哈哈哈",
                        style: TextStyle(
                            color: Colors.black, fontSize: 30.sp))),
                Container(
                    child: Text("20",
                        style: TextStyle(
                            color: Colors.black, fontSize: 30.sp))),
              ],
            ),
          ),
          Column(
            children: [
              Container(),
            ],
          ),
        ],
      ),
    );
  }
}
