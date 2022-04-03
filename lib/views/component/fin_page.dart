import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_geen/app/api/issues_api.dart';
import 'package:flutter_geen/views/component/refresh.dart';
import 'package:flutter_geen/views/pages/chat/utils/DyBehaviorNull.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:flutter_geen/views/component/MyScrollPhysics.dart';
import 'custom_dialog.dart';

class MyItem {
  final String icon;
  final String name;
  final String money;
  final String count;
  final String status;
  final String time;
  final Color color;

  const MyItem(
      {Key key,
      @required this.icon,
      @required this.name,
      @required this.money,
      @required this.count,
      @required this.status,
      @required this.time,
      @required this.color});
}

class FinPage extends StatefulWidget {
  @override
  _FinPageState createState() => _FinPageState();
}

class _FinPageState extends State<FinPage> {
  RefreshController _refreshController =
      RefreshController(initialRefresh: false);
  bool show = false;
  double heights = 140.h;
  Color cc = Colors.transparent;
  double opacity = 1.0;
  int groupValue = -1;
  String title = "请选择当前状态";
  var dm = <MyItem>[];
  var dm1 = <MyItem>[];
  String myName = "";
  bool myValue = false;

  @override
  void initState() {
    var de = MyItem(
      icon: 'assets/images/default/fine_success.png',
      name: '张庭耀',
      status: '已放款',
      money: '100',
      time: '2022-04-04 10:12:23',
      count: '60',
      color: Color(0xffD8AA0F),
    );
    dm.add(de);
    de = de = MyItem(
      icon: 'assets/images/default/fine_call.png',
      name: '张庭耀',
      status: '联系中',
      money: '100',
      time: '2022-04-04 10:12:23',
      count: '60',
      color: Color(0xff4DA1EE),
    );
    dm.add(de);
    de = MyItem(
      icon: 'assets/images/default/fine_lost.png',
      name: '张庭耀',
      status: '客户放弃',
      money: '100',
      time: '2022-04-04 10:12:23',
      count: '60',
      color: Color(0xff6360CA),
    );
    dm.add(de);
    de = MyItem(
      icon: 'assets/images/default/fine_no.png',
      name: '张庭耀',
      status: '资质不符',
      money: '100',
      time: '2022-04-04 10:12:23',
      count: '60',
      color: Color(0xff4CD070),
    );
    dm.add(de);
    de = MyItem(
      icon: 'assets/images/default/fine_fail.png',
      name: '张庭耀',
      status: '放款失败',
      money: '100',
      time: '2022-04-04 10:12:23',
      count: '60',
      color: Color(0xffFF6666),
    );
    dm.add(de);

    de = MyItem(
      icon: 'assets/images/default/fine_success.png',
      name: '张庭耀',
      status: '已放款',
      money: '100',
      time: '2022-04-04 10:12:23',
      count: '60',
      color: Color(0xffD8AA0F),
    );
    dm.add(de);
    de = MyItem(
      icon: 'assets/images/default/fine_call.png',
      name: '张庭耀',
      status: '联系中',
      money: '100',
      time: '2022-04-04 10:12:23',
      count: '60',
      color: Color(0xff4DA1EE),
    );
    dm.add(de);
    de = MyItem(
      icon: 'assets/images/default/fine_lost.png',
      name: '张庭耀',
      status: '客户放弃',
      money: '100',
      time: '2022-04-04 10:12:23',
      count: '60',
      color: Color(0xff6360CA),
    );
    dm.add(de);
    de = MyItem(
      icon: 'assets/images/default/fine_no.png',
      name: '张庭耀',
      status: '资质不符',
      money: '100',
      time: '2022-04-04 10:12:23',
      count: '60',
      color: Color(0xff4CD070),
    );
    dm.add(de);
    de = MyItem(
      icon: 'assets/images/default/fine_fail.png',
      name: '张庭耀',
      status: '放款失败',
      money: '100',
      time: '2022-04-04 10:12:23',
      count: '60',
      color: Color(0xffFF6666),
    );
    dm.add(de);

    de = MyItem(
      icon: 'assets/images/default/fine_success.png',
      name: '张庭耀',
      status: '已放款',
      money: '100',
      time: '2022-04-04 10:12:23',
      count: '60',
      color: Color(0xffD8AA0F),
    );
    dm.add(de);
    de = MyItem(
      icon: 'assets/images/default/fine_call.png',
      name: '张庭耀',
      status: '联系中',
      money: '100',
      time: '2022-04-04 10:12:23',
      count: '60',
      color: Color(0xff4DA1EE),
    );
    dm.add(de);
    de = MyItem(
      icon: 'assets/images/default/fine_lost.png',
      name: '张庭耀',
      status: '客户放弃',
      money: '100',
      time: '2022-04-04 10:12:23',
      count: '60',
      color: Color(0xff6360CA),
    );
    dm.add(de);
    de = MyItem(
      icon: 'assets/images/default/fine_no.png',
      name: '张庭耀',
      status: '资质不符',
      money: '100',
      time: '2022-04-04 10:12:23',
      count: '60',
      color: Color(0xff4CD070),
    );
    dm.add(de);
    de = MyItem(
      icon: 'assets/images/default/fine_fail.png',
      name: '张庭耀',
      status: '放款失败',
      money: '100',
      time: '2022-04-04 10:12:23',
      count: '60',
      color: Color(0xffFF6666),
    );
    dm.add(de);

    de = MyItem(
      icon: 'assets/images/default/fine_success.png',
      name: '张庭耀',
      status: '已放款',
      money: '100',
      time: '2022-04-04 10:12:23',
      count: '60',
      color: Color(0xffD8AA0F),
    );
    dm.add(de);
    de = MyItem(
      icon: 'assets/images/default/fine_call.png',
      name: '张庭耀',
      status: '联系中',
      money: '100',
      time: '2022-04-04 10:12:23',
      count: '60',
      color: Color(0xff4DA1EE),
    );
    dm.add(de);
    de = MyItem(
      icon: 'assets/images/default/fine_lost.png',
      name: '张庭耀',
      status: '客户放弃',
      money: '100',
      time: '2022-04-04 10:12:23',
      count: '60',
      color: Color(0xff6360CA),
    );
    dm.add(de);
    de = MyItem(
      icon: 'assets/images/default/fine_no.png',
      name: '张庭耀',
      status: '资质不符',
      money: '100',
      time: '2022-04-04 10:12:23',
      count: '60',
      color: Color(0xff4CD070),
    );
    dm.add(de);
    de = MyItem(
      icon: 'assets/images/default/fine_fail.png',
      name: '张庭耀',
      status: '放款失败',
      money: '100',
      time: '2022-04-04 10:12:23',
      count: '60',
      color: Color(0xffFF6666),
    );
    dm.add(de);

    de = MyItem(
      icon: 'assets/images/default/fine_success.png',
      name: '张庭耀',
      status: '已放款',
      money: '100',
      time: '2022-04-04 10:12:23',
      count: '60',
      color: Color(0xffD8AA0F),
    );
    dm.add(de);
    de = MyItem(
      icon: 'assets/images/default/fine_call.png',
      name: '张庭耀',
      status: '联系中',
      money: '100',
      time: '2022-04-04 10:12:23',
      count: '60',
      color: Color(0xff4DA1EE),
    );
    dm.add(de);
    de = MyItem(
      icon: 'assets/images/default/fine_lost.png',
      name: '张庭耀',
      status: '客户放弃',
      money: '100',
      time: '2022-04-04 10:12:23',
      count: '60',
      color: Color(0xff6360CA),
    );
    dm.add(de);
    de = MyItem(
      icon: 'assets/images/default/fine_no.png',
      name: '张庭耀',
      status: '资质不符',
      money: '100',
      time: '2022-04-04 10:12:23',
      count: '60',
      color: Color(0xff4CD070),
    );
    dm.add(de);
    de = MyItem(
      icon: 'assets/images/default/fine_fail.png',
      name: '张庭耀',
      status: '放款失败',
      money: '100',
      time: '2022-04-04 10:12:23',
      count: '60',
      color: Color(0xffFF6666),
    );
    dm.add(de);

    de = MyItem(
      icon: 'assets/images/default/fine_success.png',
      name: '张庭耀',
      status: '已放款',
      money: '100',
      time: '2022-04-04 10:12:23',
      count: '60',
      color: Color(0xffD8AA0F),
    );
    dm.add(de);
    de = MyItem(
      icon: 'assets/images/default/fine_call.png',
      name: '张庭耀',
      status: '联系中',
      money: '100',
      time: '2022-04-04 10:12:23',
      count: '60',
      color: Color(0xff4DA1EE),
    );
    dm.add(de);
    de = MyItem(
      icon: 'assets/images/default/fine_lost.png',
      name: '张庭耀',
      status: '客户放弃',
      money: '100',
      time: '2022-04-04 10:12:23',
      count: '60',
      color: Color(0xff6360CA),
    );
    dm.add(de);
    de = MyItem(
      icon: 'assets/images/default/fine_no.png',
      name: '张庭耀',
      status: '资质不符',
      money: '100',
      time: '2022-04-04 10:12:23',
      count: '60',
      color: Color(0xff4CD070),
    );
    dm.add(de);
    de = MyItem(
      icon: 'assets/images/default/fine_fail.png',
      name: '张庭耀',
      status: '放款失败',
      money: '100',
      time: '2022-04-04 10:12:23',
      count: '60',
      color: Color(0xffFF6666),
    );
    dm.add(de);

    de = MyItem(
      icon: 'assets/images/default/fine_success.png',
      name: '张庭耀',
      status: '已放款',
      money: '100',
      time: '2022-04-04 10:12:23',
      count: '60',
      color: Color(0xffD8AA0F),
    );
    dm.add(de);
    de = MyItem(
      icon: 'assets/images/default/fine_call.png',
      name: '张庭耀',
      status: '联系中',
      money: '100',
      time: '2022-04-04 10:12:23',
      count: '60',
      color: Color(0xff4DA1EE),
    );
    dm.add(de);
    de = MyItem(
      icon: 'assets/images/default/fine_lost.png',
      name: '张庭耀',
      status: '客户放弃',
      money: '100',
      time: '2022-04-04 10:12:23',
      count: '60',
      color: Color(0xff6360CA),
    );
    dm.add(de);
    de = MyItem(
      icon: 'assets/images/default/fine_no.png',
      name: '张庭耀',
      status: '资质不符',
      money: '100',
      time: '2022-04-04 10:12:23',
      count: '60',
      color: Color(0xff4CD070),
    );
    dm.add(de);
    de = MyItem(
      icon: 'assets/images/default/fine_fail.png',
      name: '张庭耀',
      status: '放款失败',
      money: '100',
      time: '2022-04-04 10:12:23',
      count: '60',
      color: Color(0xffFF6666),
    );
    dm.add(de);

    de = MyItem(
      icon: 'assets/images/default/fine_success.png',
      name: '张庭耀',
      status: '已放款',
      money: '100',
      time: '2022-04-04 10:12:23',
      count: '60',
      color: Color(0xffD8AA0F),
    );
    dm.add(de);
    de = MyItem(
      icon: 'assets/images/default/fine_call.png',
      name: '张庭耀',
      status: '联系中',
      money: '100',
      time: '2022-04-04 10:12:23',
      count: '60',
      color: Color(0xff4DA1EE),
    );
    dm.add(de);
    de = MyItem(
      icon: 'assets/images/default/fine_lost.png',
      name: '张庭耀',
      status: '客户放弃',
      money: '100',
      time: '2022-04-04 10:12:23',
      count: '60',
      color: Color(0xff6360CA),
    );
    dm.add(de);
    de = MyItem(
      icon: 'assets/images/default/fine_no.png',
      name: '张庭耀',
      status: '资质不符',
      money: '100',
      time: '2022-04-04 10:12:23',
      count: '60',
      color: Color(0xff4CD070),
    );
    dm.add(de);
    de = MyItem(
      icon: 'assets/images/default/fine_fail.png',
      name: '张庭耀',
      status: '放款失败',
      money: '100',
      time: '2022-04-04 10:12:23',
      count: '60',
      color: Color(0xffFF6666),
    );
    dm.add(de);

    de = MyItem(
      icon: 'assets/images/default/fine_success.png',
      name: '张庭耀',
      status: '已放款',
      money: '100',
      time: '2022-04-04 10:12:23',
      count: '60',
      color: Color(0xffD8AA0F),
    );
    dm.add(de);
    de = MyItem(
      icon: 'assets/images/default/fine_call.png',
      name: '张庭耀',
      status: '联系中',
      money: '100',
      time: '2022-04-04 10:12:23',
      count: '60',
      color: Color(0xff4DA1EE),
    );
    dm.add(de);
    de = MyItem(
      icon: 'assets/images/default/fine_lost.png',
      name: '张庭耀',
      status: '客户放弃',
      money: '100',
      time: '2022-04-04 10:12:23',
      count: '60',
      color: Color(0xff6360CA),
    );
    dm.add(de);
    de = MyItem(
      icon: 'assets/images/default/fine_no.png',
      name: '张庭耀',
      status: '资质不符',
      money: '100',
      time: '2022-04-04 10:12:23',
      count: '60',
      color: Color(0xff4CD070),
    );
    dm.add(de);
    de = MyItem(
      icon: 'assets/images/default/fine_fail.png',
      name: '张庭耀',
      status: '放款失败',
      money: '100',
      time: '2022-04-04 10:12:23',
      count: '60',
      color: Color(0xffFF6666),
    );
    dm.add(de);
    dm1 = dm;
    super.initState();
  }

  List<MyContent> _buildMyItem() {
    return dm
        .map((e) => MyContent(
              icon: e.icon,
              name: e.name,
              money: e.money,
              count: e.count,
              status: e.status,
              time: e.time,
              color: e.color,
            ))
        .toList();
  }

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
              titleSpacing: 170.w,
              title: Text("我的客户",
                  style: TextStyle(
                    fontSize: 38.sp,
                    decoration: TextDecoration.none,
                    color: Colors.black,
                  )),
              actions: <Widget>[
                GestureDetector(
                  onTap: () {
                    showDialog(
                        context: context,
                        barrierDismissible: false,
                        builder: (BuildContext context) {
                          return LoginDialog();
                        });
                  },
                  child: Container(
                    margin: EdgeInsets.only(right: 40.w),
                    child: Image.asset(
                      'assets/images/default/qrcode.png',
                      color: Colors.blue,
                      width: 40.w,
                      height: 40.h,
                    ),
                  ),
                ),
              ],
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
              child: Container(
                margin: EdgeInsets.only(top: 30.h),
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
                    _buildHeader(context, groupValue,
                        (int index, bool value, String name) {
                      print(index);
                      print(value);
                      print(name);
                      title = name;
                      setState(() {

                        myName = name;
                        myValue = value;
                        groupValue = index;
                        if (!value) {
                          title = "请选择当前状态";
                          groupValue = -1;
                        }
                      });
                    }, title),
                  ],
                ),
              ),
            )));
  }

  Future<bool> _whenPop(BuildContext context) async {
    return true;
  }

// 下拉刷新
  void _onRefresh() async {
    dm = dm1.reversed.toList();
    _refreshController.refreshCompleted();
    setState(() {});
  }

// 上拉加载
  void _onLoading() async {
    var result = await IssuesApi.getErpUser();

    var de = MyItem(
      icon: 'assets/images/default/fine_success.png',
      name: '张庭耀',
      status: '已放款',
      money: '100',
      time: '2022-04-04 10:12:23',
      count: '60',
      color: Color(0xffD8AA0F),
    );
    dm.add(de);
    de = de = MyItem(
      icon: 'assets/images/default/fine_call.png',
      name: '张庭耀',
      status: '联系中',
      money: '100',
      time: '2022-04-04 10:12:23',
      count: '60',
      color: Color(0xff4DA1EE),
    );
    dm.add(de);
    de = MyItem(
      icon: 'assets/images/default/fine_lost.png',
      name: '张庭耀',
      status: '客户放弃',
      money: '100',
      time: '2022-04-04 10:12:23',
      count: '60',
      color: Color(0xff6360CA),
    );
    dm.add(de);
    de = MyItem(
      icon: 'assets/images/default/fine_no.png',
      name: '张庭耀',
      status: '资质不符',
      money: '100',
      time: '2022-04-04 10:12:23',
      count: '60',
      color: Color(0xff4CD070),
    );
    dm.add(de);
    de = MyItem(
      icon: 'assets/images/default/fine_fail.png',
      name: '张庭耀',
      status: '放款失败',
      money: '100',
      time: '2022-04-04 10:12:23',
      count: '60',
      color: Color(0xffFF6666),
    );
    dm.add(de);

    de = MyItem(
      icon: 'assets/images/default/fine_success.png',
      name: '张庭耀',
      status: '已放款',
      money: '100',
      time: '2022-04-04 10:12:23',
      count: '60',
      color: Color(0xffD8AA0F),
    );
    dm.add(de);
    de = MyItem(
      icon: 'assets/images/default/fine_call.png',
      name: '张庭耀',
      status: '联系中',
      money: '100',
      time: '2022-04-04 10:12:23',
      count: '60',
      color: Color(0xff4DA1EE),
    );

    _refreshController.loadComplete();
    setState(() {});
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
              margin: EdgeInsets.only(top: 200.h),
              child: Container(
                margin: EdgeInsets.only(top: 60.h),
                child: SmartRefresher(
                    physics: MyScrollPhysics(),
                    enablePullDown: true,
                    enablePullUp: true,
                    header: DYrefreshHeader(),
                    footer: DYrefreshFooter(),
                    controller: _refreshController,
                    onRefresh: _onRefresh,
                    onLoading: _onLoading,
                    child: Container(
                      child: SingleChildScrollView(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: <Widget>[..._buildMyItem()],
                        ),
                      ),
                    )),
              ),
            ),
          )));

  Widget _buildHeader(BuildContext context, int groupValues,
          ChangeCallback callback, titles) =>
      Stack(
        children: [
          Container(
            decoration: show?BoxDecoration(boxShadow: [
              BoxShadow(
                color: Color.fromRGBO(218, 218, 218, 0.4),
                //阴影默认颜色,不能与父容器同时设置color
                offset: Offset(0, 470.h),
                //延伸的阴影，向右下偏移的距离
                blurRadius: 0.h, //延伸距离,会有模糊效果
              )
            ],
            ):null,
            margin: EdgeInsets.only(top: 200.h),
            child: Container(
              height: heights,
              decoration: BoxDecoration(
                  color: cc,
                  borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(40.w),
                      topRight: Radius.circular(40.w))),
              child: Container(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    Container(
                      child: Row(
                        children: [
                          Container(
                            padding: EdgeInsets.only(left: 40.h),
                            child: Text(
                              titles,
                              style:
                                  TextStyle(fontSize: 30.sp, color: Colors.black),
                            ),
                          ),
                          Container(
                            child: IconButton(
                              icon: Icon(show
                                  ? Icons.keyboard_arrow_up_outlined
                                  : Icons.keyboard_arrow_down_outlined),
                              onPressed: () {
                                print(1);
                                setState(() {
                                  show = !show;
                                  if (show) {
                                    heights = 486.h;
                                    cc = Colors.white;
                                    opacity = 1;
                                  } else {
                                    heights = 140.h;
                                    cc = Colors.transparent;
                                    opacity = 1.0;
                                  }
                                });
                              },
                            ),
                          ),
                        ],
                      ),
                    ),
                    Visibility(
                      visible: show,
                      child: Stack(
                        children: [

                          Container(
                            child: Container(
                              padding: EdgeInsets.only(left: 40.h,top: 20.h),
                              child: Column(
                                children: [
                                  buildButton(context, groupValues, callback),
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
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: <Widget>[
                                              GestureDetector(
                                                onTap: () {
                                                  setState(() {
                                                    show = !show;
                                                    if (show) {
                                                      heights = 450.h;
                                                      cc = Colors.white;
                                                      opacity = 0.1;
                                                    } else {
                                                      heights = 140.h;
                                                      cc = Colors.transparent;
                                                      opacity = 1.0;
                                                    }
                                                    dm = dm1.reversed.toList();
                                                    groupValue = -1;
                                                    myValue = false;
                                                    myName = "";
                                                    title = "请选择当前状态";
                                                  });
                                                },
                                                child: Container(
                                                  padding: EdgeInsets.only(
                                                      left: 130.w,
                                                      top: 6.h,
                                                      right: 130.w,
                                                      bottom: 6.h),
                                                  height: 80.h,
                                                  decoration: BoxDecoration(
                                                    border: Border(
                                                      left: BorderSide(
                                                          color: Colors.grey,
                                                          width: 2.w),
                                                      top: BorderSide(
                                                          color: Colors.grey,
                                                          width: 2.w),
                                                      right: BorderSide(
                                                          color: Colors.grey,
                                                          width: 2.w),
                                                      bottom: BorderSide(
                                                          color: Colors.grey,
                                                          width: 2.w),
                                                    ),
                                                    color: Colors.white,
                                                    borderRadius: BorderRadius.only(
                                                      topLeft:
                                                          Radius.circular(34.w),
                                                      bottomLeft:
                                                          Radius.circular(34.w),
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
                                                      opacity = 0.1;
                                                    } else {
                                                      heights = 140.h;
                                                      cc = Colors.transparent;
                                                      opacity = 1.0;
                                                    }
                                                    var fg = dm1.reversed.toList();
                                                    fg.removeWhere(
                                                        (e) => e.status != myName);
                                                    dm = fg;
                                                    if (groupValue == -1) {
                                                      dm = dm1.reversed.toList();
                                                    }
                                                  });
                                                },
                                                child: Container(
                                                  padding: EdgeInsets.only(
                                                      left: 130.w,
                                                      top: 12.h,
                                                      right: 130.w,
                                                      bottom: 12.h),
                                                  height: 80.h,
                                                  decoration: BoxDecoration(
                                                    color: Colors.blue,
                                                    borderRadius:
                                                        BorderRadius.horizontal(
                                                            right: Radius.circular(
                                                                34.w)),
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
                            ),
                          ),
                        ],
                      ),
                    )
                  ],
                ),
              ),
            ),
          ),
        ],
      );
}

Widget buildButton(
    BuildContext context, int groupValue, ChangeCallback callback) {
  bool v1 = false;

  return Container(
    padding: EdgeInsets.only(left: 0.w, right: 0.w),
    alignment: Alignment.centerLeft,
    child: Wrap(runSpacing: 30.w, spacing: 30.w, children: [
      MButton(
        name: "已放款",
        index: 0,
        groupValue: groupValue,
        callback: callback,
      ),
      MButton(
        name: "放款失败",
        index: 1,
        groupValue: groupValue,
        callback: callback,
      ),
      MButton(
        name: "客户放弃",
        index: 2,
        groupValue: groupValue,
        callback: callback,
      ),
      MButton(
        name: "资质不符",
        index: 3,
        groupValue: groupValue,
        callback: callback,
      ),
      MButton(
        name: "联系中",
        index: 4,
        groupValue: groupValue,
        callback: callback,
      ),
    ]),
  );
}

typedef ChangeCallback = void Function(int index, bool value, String name);

class MButton extends StatefulWidget {
  final String name;
  final int index;

  final int groupValue;
  final ChangeCallback callback;

  const MButton(
      {Key key,
      @required this.name,
      @required this.index,
      @required this.groupValue,
      @required this.callback})
      : super(key: key);

  @override
  _MButtonState createState() => _MButtonState();
}

class _MButtonState extends State<MButton> {
  @override
  Widget build(BuildContext context) {
    bool selected = widget.groupValue == widget.index;
    return ChoiceChip(
      backgroundColor: selected ? Colors.white : Color(0xffF5F6F9),
      selectedColor: selected ? Colors.transparent : Color(0xffF5F6F9),
      side: BorderSide(
          width: 2.w, color: selected ? Colors.blue : Colors.transparent),
      padding:
          EdgeInsets.only(left: 40.w, right: 40.w, top: 15.h, bottom: 15.h),
      labelPadding: EdgeInsets.only(left: 0.w, right: 0.w),
      selectedShadowColor: Colors.transparent,
      shadowColor: Colors.transparent,
      pressElevation: 0,
      elevation: 0,
      label: Text(
        widget.name,
        style: TextStyle(
            color: selected ? Colors.blue : Colors.black,
            fontSize: 30.sp,
            fontWeight: FontWeight.normal),
        overflow: TextOverflow.ellipsis,
      ),
      selected: selected,
      onSelected: (bool value) {
        setState(() {
          widget.callback(widget.index, !selected, widget.name);
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
                        child: Text("共获取客户",
                            style: TextStyle(
                                color: Colors.white, fontSize: 30.sp))),
                    Container(
                        child: Text("4人",
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
                        child: Text("已放款",
                            style: TextStyle(
                                color: Colors.white, fontSize: 30.sp))),
                    Container(
                        child: Text("8人",
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
  final String icon;
  final String name;
  final String money;
  final String count;
  final String status;
  final String time;
  final Color color;

  const MyContent(
      {Key key,
      @required this.icon,
      @required this.name,
      @required this.money,
      @required this.count,
      @required this.status,
      @required this.time,
      @required this.color})
      : super(key: key);

  @override
  _MyContentState createState() => _MyContentState();
}

class _MyContentState extends State<MyContent> {
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(top: 20.h, left: 40.w),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Column(
                children: [
                  Container(
                      width: 90.w,
                      height: 90.h,
                      child: Image.asset(widget.icon))
                ],
              ),
              Container(
                margin: EdgeInsets.only(top: 0.h, left: 30.w),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                        margin: EdgeInsets.only(bottom: 0.h),
                        child: Text(widget.name,
                            style: TextStyle(
                                color: Colors.black,
                                fontSize: 30.sp,
                                fontWeight: FontWeight.w600))),
                    Container(
                        child: Text(
                            "贷款金额:  " +
                                widget.money +
                                "万 期数:  " +
                                widget.count +
                                "期",
                            style: TextStyle(
                                color: Colors.black, fontSize: 30.sp))),
                    Container(
                        child: Text(widget.time,
                            style: TextStyle(
                                color: Colors.grey, fontSize: 25.sp))),
                  ],
                ),
              ),
            ],
          ),
          Column(
            children: [
              Container(
                  margin: EdgeInsets.only(
                    right: 40.w,
                  ),
                  child: Text(widget.status,
                      style: TextStyle(color: widget.color, fontSize: 26.sp))),
            ],
          ),
        ],
      ),
    );
  }
}
