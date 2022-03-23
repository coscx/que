import 'package:bot_toast/bot_toast.dart';
import 'package:flutter/material.dart';
import 'package:flutter_geen/app/router.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:flutter_geen/views/dialogs/user_detail.dart';
import 'package:flutter_geen/app/api/issues_api.dart';
import 'package:fluwx/fluwx.dart' as fluwx;
import 'package:flutter_geen/views/component/flow_bottom_sheet.dart';
import 'package:lottie/lottie.dart';
import 'package:flutter_geen/storage/dao/local_storage.dart';
import 'package:flutter_geen/views/dialogs/delete_category_dialog.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
class MinePage extends StatefulWidget {
  @override
  _MinePageState createState() => _MinePageState();
}

class _MinePageState extends State<MinePage> with AutomaticKeepAliveClientMixin<MinePage> {
  final double _appBarHeight = 220.h;
  String name ="MSTAR";
  String bind="微信绑定";
  String memberId="0";
   String _userHead =
      'https://img.bosszhipin.com/beijin/mcs/useravatar/20171211/4d147d8bb3e2a3478e20b50ad614f4d02062e3aec7ce2519b427d24a3f300d68_s.jpg';
   String lost="0";
  String join="0";
  String connect="0";

  @override
  bool get wantKeepAlive => true;
  @override
   initState()  {
    super.initState();
    fluwx.weChatResponseEventHandler.distinct((a, b) => a == b).listen((res) async {
      if (res is fluwx.WeChatAuthResponse) {
        if(res.state =="wechat_sdk_demo_bind") {
          var result = await IssuesApi.bindAppWeChat(res.code);
          if (result['code'] == 200) {
            await LocalStorage.save("openid",result['data']['openid']);
            setState(() {
              bind="已绑定微信";
            });
            _showToast(context, "绑定成功", false);

          } else {
            _showToast(context, result['message'], false);
          }
        }
      }
    });
    Future.delayed(Duration(milliseconds: 1)).then((e) async {
      var ss =  await LocalStorage.get("name");
      var openidF=  await LocalStorage.get("openid");
      var sss =ss.toString();
      var openids =openidF.toString();
      var id=  await LocalStorage.get("memberId");
     String  memberIds = id.toString();
      setState(() {
        memberId=memberIds;
      });

      var avatar=  await LocalStorage.get("avatar");
      String  avatars = avatar.toString();
      setState(() {
        _userHead=avatars;
      });

      if(sss == "" || ss == null || ss == "null"){

      }else{
       setState(() {
         name=ss;
       });
      }
      if(openids == "" || openids == null || openids == "null"){
      }else{
        setState(() {
          bind="已绑定微信";
        });
      }
      var result = await IssuesApi.getDashBord();
      if (result['code'] == 200) {
        var d = result['data']['top'];

        setState(() {
          lost = d['yesterday_lost'].toString();
          join = d['yesterday_create'].toString();
          connect = d['yesterday_connect'].toString();
        });


      } else {}

    });

  }

  _bindWx(BuildContext context,String img) {
    showDialog(
        context: context,
        builder: (ctx) => Dialog(
          elevation: 5,
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(10.w))),
          child: Container(
            width: 50.w,
            child: DeleteCategoryDialog(
              title: '此账号已绑定微信',
              content: '是否确定重新绑定?',
              onSubmit: () {
                fluwx
                    .sendWeChatAuth(
                    scope: "snsapi_userinfo", state: "wechat_sdk_demo_bind")
                    .then((data) {});
                Navigator.of(context).pop();
              },
            ),
          ),
        ));
  }
  _showToast(BuildContext ctx, String msg, bool collected) {
    // Toasts.toast(
    //   ctx,
    //   msg,
    //   duration: Duration(milliseconds:  5000 ),
    //   action: collected
    //       ? SnackBarAction(
    //       textColor: Colors.white,
    //       label: '收藏夹管理',
    //       onPressed: () => Scaffold.of(ctx).openEndDrawer())
    //       : null,
    // );
    BotToast.showNotification(

      leading: (cancel) => Container(
          child: IconButton(
            icon: Icon(Icons.error, color: Colors.redAccent),
            onPressed: cancel,
          )),
      title: (text)=>Container(
        child: Text(msg,style:  TextStyle(
            color: Colors.black, fontSize: 40.sp)),
      ),
      duration: const Duration(seconds: 5),

      trailing: (cancel) => Container(
        child: IconButton(
          icon: Icon(Icons.cancel),
          onPressed: cancel,
        ),
      ),
      onTap: () {
        BotToast.showText(text: 'Tap toast');
      },); //弹出简单通知Toast
  }
  @override
  Widget build(BuildContext context) {
    return Theme(
      data: ThemeData(
        appBarTheme: AppBarTheme.of(context).copyWith(
          brightness: Brightness.light,
        ),
      ),
      child:Scaffold(

      backgroundColor:  Colors.white,
        body:  CustomScrollView(
        physics:const BouncingScrollPhysics() ,
        slivers: <Widget>[
           SliverAppBar(
            backgroundColor: Colors.white,
            expandedHeight: 220.h,
            flexibleSpace:  FlexibleSpaceBar(
              collapseMode: CollapseMode.parallax,
              background:  Stack(
                fit: StackFit.expand,
                children: <Widget>[
                  const DecoratedBox(
                    decoration: const BoxDecoration(
                      gradient: const LinearGradient(
                        begin: const Alignment(0.0, -1.0),
                        end: const Alignment(0.0, -0.4),
                        colors: const <Color>[
                          const Color(0x00000000),
                          const Color(0x00000000)
                        ],
                      ),
                    ),
                  ),

                  Container(
                    height:120.h,
                    width: 120.w,
                    alignment: FractionalOffset.topLeft,
                    child: Image.asset("assets/packages/images/friend_card_bg.png"),
                  ),
                   Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Container(
                          margin: EdgeInsets.only(left: 20.w),
                          width: 150.w,
                          child: Stack(
                            children: [
                              _userHead==null? Container():(_userHead=="" || _userHead=="null"? Container():
                              Positioned(
                                left: 25.w,
                                top: 120.h,
                                child: Container(
                                  width: 90.h,
                                  height: 90.h,
                                  child: ClipOval(
                                    child: Image.network(
                                      _userHead,
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                  //backgroundColor: Colors.white,
                                ),
                              ))
                              ,
                              Positioned(
                                left: 10.w,
                                top: 100.h,
                                child: Container(
                                  width: 120.h,
                                  height: 120.h,
                                  //margin: EdgeInsets.fromLTRB(1.w, 5.h, 5.w, 0.h),
                                  child:Lottie.asset('assets/packages/lottie_flutter/36535-avatar-pendant.json'),
                                ),
                              ),
                            ],
                          ),
                        ),

                      Container(
                        padding:  EdgeInsets.only(
                          top: 60.h,
                          left: 20.w,
                          bottom: 0.h,
                        ),
                        child:  Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                             Padding(
                              padding:  EdgeInsets.only(
                                top: 0.h,
                                left: 30.w,
                                bottom: 5.h,
                              ),
                              child:  Text(
                                name,
                                style:  TextStyle(
                                    color: Colors.black,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 20.0),
                              ),
                            ),

                              Container(

                                padding:  EdgeInsets.only(
                                  top: 0.h,
                                  left: 30.w,
                                  bottom: 0.h,
                                ),

                                child: Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  SvgPicture.asset(
                                    "assets/packages/images/bb_id.svg",
                                    //color: Colors.black87,
                                  ),
                                  Container(
                                    padding:  EdgeInsets.only(
                                      top: 0.h,
                                      left: 10.w,
                                      bottom: 0.h,
                                    ),
                                    child:  Text(
                                     "S001M00"+ memberId,
                                      style:  TextStyle(
                                          color: Colors.black, fontSize: 28.sp,fontWeight: FontWeight.bold,),
                                    ),
                                  ),
                                  ]),
                              ),



                          ],
                        ),
                      ),

                    ],
                  ),
                  Positioned(
                    right: 40.w,
                    top: 80.w,
                    child: Container(
                      padding:  EdgeInsets.only(
                          left: 0.w,
                          right: 0.w,
                          top: 0.h,
                          bottom: 70.h
                      ),
                      child: GestureDetector(
                        onTap: (){
                          Navigator.pushNamed(context, UnitRouter.setting);
                        },
                        child: Container(
                          width: 50.h,
                          height: 50.h,
                          //margin: EdgeInsets.fromLTRB(1.w, 5.h, 5.w, 0.h),
                          child:Lottie.asset('assets/packages/lottie_flutter/6547-gear.json'),
                        ),
                      ),

                    ),
                  ),
                ],
              ),
            ),
          ),
           SliverList(
            delegate:  SliverChildListDelegate(
              <Widget>[
                 Container(
                  color: Colors.white,
                  child:  Padding(
                    padding:  EdgeInsets.only(
                      top: 0.h,
                      bottom: 20.h,
                      left: 20.w,
                      right: 20.w
                    ),
                    child:  Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        TopCard(
                          url: 'assets/images/default/lost.png',
                          title: '昨日流失',
                          content: lost,
                          colorStart:  Color(0xff0CDAC5),
                          colorEnd: Color(0xff3BBFF9),
                        ),TopCard(
                          url: 'assets/images/default/join.png',
                          title: '昨日入库',
                          content: join,
                          colorStart:  Color(0xffF6A681),
                          colorEnd: Color(0xffF86CA0),
                        ),
                        TopCard(
                          url: 'assets/images/default/connect.png',
                          title: '昨日沟通',
                          content: connect,
                          colorStart:  Color(0xff9A7FF6),
                          colorEnd: Color(0xffEA76EE),
                        )
                      ],
                    ),
                  ),
                ),

                Container(
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10.w),
                        color: Colors.white,
                        boxShadow: [BoxShadow(color: Color(0x19000000), offset: Offset(0.5, 0.5),  blurRadius: 1.5, spreadRadius: 1.5),  BoxShadow(color: Colors.white)],
                    ),
                    margin: EdgeInsets.fromLTRB(30.w,40.h,30.w,0),
                    child: ClipRRect(
                        borderRadius: BorderRadius.circular(10.w),
                        child: Container(

                          margin: EdgeInsets.fromLTRB(30.w,0.h,30.w,0),

                          child: Row(

                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            mainAxisSize: MainAxisSize.max,
//                交叉轴的布局方式，对于column来说就是水平方向的布局方式
                            crossAxisAlignment: CrossAxisAlignment.center,
                            //就是字child的垂直布局方向，向上还是向下
                            verticalDirection: VerticalDirection.down,
                            children: <Widget>[
                              // SizedBox(
                              //   width: ScreenUtil().setWidth(10.w),
                              // ),
                              GestureDetector(
                                onTap: (){
                                  Navigator.pushNamed(context, UnitRouter.create_user_page);
                                },
                                  child: Container(
                                padding:  EdgeInsets.only(
                                     //top: 20.h,
                                    // bottom: 15.h,

                                ),
                                child:  Column(children: <Widget>[
                                  Container(
                                    height: 150.h,
                                    width: 150.w,
                                    alignment: FractionalOffset.topLeft,
                                    child: Lottie.asset('assets/packages/lottie_flutter/85263-plus-sky-theme.json'),
                                  ),
                                  // Text(
                                  //   "客户录入",
                                  //   style:  TextStyle(color: Colors.black54, fontSize: 28.sp),
                                  // ),

                                ]),
                              )),


                          GestureDetector(
                            onTap: (){
                              //Navigator.pushNamed(context, UnitRouter.select_page);
                            },
                            child:Container(
                                padding:  EdgeInsets.only(


                                ),
                                child:  Column(children: <Widget>[
                                  Container(
                                    height: 150.h,
                                    width: 150.w,
                                    alignment: FractionalOffset.topLeft,
                                    child: Lottie.asset('assets/packages/lottie_flutter/98042-robot.json'),
                                  ),
                                  // Text(
                                  //   "已提交",
                                  //   style:  TextStyle(color: Colors.black54, fontSize: 24.sp),
                                  // ),

                                ]),
                              )),

                    GestureDetector(
                    onTap: (){

                    },
                      child:Container(
                                padding:  EdgeInsets.only(
                                    top: 0.h,
                                    bottom: 0.h,

                                ),
                                child:  Column(children: <Widget>[
                                  Container(
                                    height: 150.h,
                                    width: 150.w,
                                    alignment: FractionalOffset.topLeft,
                                    child: Lottie.asset('assets/packages/lottie_flutter/97568-graph.json'),
                                  ),
                                  // Text(
                                  //   "用户管理",
                                  //   style:  TextStyle(color: Colors.black54, fontSize: 24.sp),
                                  // ),

                                ]),
                              )

                    ),

                              GestureDetector(
                                onTap: (){
                                  //Navigator.pushNamed(context, UnitRouter.game);
                                  // _userDetail(context);
                                  // showCupertinoModalBottomSheet(
                                  //   expand: true,
                                  //   bounce: false,
                                  //   context: context,
                                  //   duration: const Duration(milliseconds: 200),
                                  //   backgroundColor: Colors.white,
                                  //   builder: (context) => FlowBottomSheet(),
                                  // );

                                },
                                child: Container(
                                  padding:  EdgeInsets.only(
                                      // top: 10.h,
                                      // bottom: 10.h,

                                  ),
                                  child:  Column(children: <Widget>[
                                    Container(
                                      height: 150.h,
                                      width: 150.w,
                                      alignment: FractionalOffset.topLeft,
                                      child: Lottie.asset('assets/packages/lottie_flutter/97577-instagram.json'),
                                    ),
                                    // Text(
                                    //   "权限管理",
                                    //   style:  TextStyle(color: Colors.black54, fontSize: 24.sp),
                                    // ),

                                  ]),
                                ),
                              ),

                              // SizedBox(
                              //   width: ScreenUtil().setWidth(10.w),
                              // ),

                            ],
                          ),
                        ))),


                 Container(
                  color: Colors.white,
                  margin:  EdgeInsets.only(top: 40.h),
                  child: Column(
                    children: <Widget>[
                      GestureDetector(
                        onTap: () async {

                          var ss =  await LocalStorage.get("openid");
                          var sss =ss.toString();
                          if(sss == "" || ss == null || ss == "null"){
                            fluwx
                                .sendWeChatAuth(
                                scope: "snsapi_userinfo", state: "wechat_sdk_demo_bind")
                                .then((data) {});
                          }else{
                            _bindWx(context,"");
                          }


                        },
                         child: MenuItem(
                          icon: "assets/packages/images/login_wechat.svg",
                          title: bind,
                          ),
                       ),
                      //  MenuItem(
                      //   icon: "assets/packages/images/ic_profile_mentor_ship.svg",
                      //   title: '师徒关系',
                      // ),
                      //
                      //  MenuItem(
                      //   icon: "assets/packages/images/ic_my_bag.svg",
                      //   title: '我的背包',
                      // ),
                      //  MenuItem(
                      //   icon: "assets/packages/images/ic_activity.svg",
                      //   title: '订单',
                      // ),
                      //  MenuItem(
                      //   icon: "assets/packages/images/ic_app_review.svg",
                      //   title: '去好评',
                      // ),
                      //  MenuItem(
                      //   icon: "assets/packages/images/ic_contribute.svg",
                      //   title: '贡献题目',
                      // ),
                      //  MenuItem(
                      //   icon: "assets/packages/images/ic_invite.svg",
                      //   title: '邀请有礼',
                      // ),
                      //  MenuItem(
                      //   icon: "assets/packages/images/ic_activity.svg",
                      //   title: '活动',
                      // ),
                      //  MenuItem(
                      //   icon: "assets/packages/images/ic_settings.svg",
                      //   title: '账号设置',
                      // ),
                      //  MenuItem(
                      //   icon: "assets/packages/images/ic_service.svg",
                      //   title: '在线客服',
                      // ),
                      //  MenuItem(
                      //   icon: "assets/packages/images/ic_help.svg",
                      //   title: '帮助',
                      // ),
                      //  MenuItem(
                      //   icon: "assets/packages/images/ic_contact.svg",
                      //   title: '联系我们',
                      // ),

                    ],
                  ),
                ),
              ],
            ),
          )
        ],
      ),
    )
    );
  }

  _userDetail(BuildContext context) async {
    BotToast.showLoading();

    var result= await IssuesApi.getUserDetail('a87ca69e-7092-493e-9f13-2955aeaf2d0f');
    if  (result['code']==200){
      showDialog(
          context: context,
          builder: (ctx) => UserDetailDialog(result['data'])

      );
    } else{

    }
    BotToast.closeAllLoading();
  }
}

class ContactItem extends StatelessWidget {
  ContactItem({Key key, this.count, this.title, this.onPressed})
      : super(key: key);

  final String count;
  final String title;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return  GestureDetector(
      onTap: onPressed,
      child:  Column(
        children: [
           Padding(
            padding:  EdgeInsets.only(
              bottom: 4.h,
            ),
            child:  Text(count, style:  TextStyle(fontSize: 36.sp)),
          ),
           Text(title,
              style:  TextStyle(color: Colors.black54, fontSize: 22.sp)),
        ],
      ),
    );
  }
}
class TopCard extends StatelessWidget {
  TopCard({Key key, this.url, this.title, this.onPressed, this.content, this.colorStart, this.colorEnd})
      : super(key: key);

  final String url;
  final String title;
  final String content;
  final Color colorStart;
  final Color colorEnd;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return  GestureDetector(
      onTap: onPressed,
      child:  Container(
        decoration:  BoxDecoration(
          //设置四周圆角 角度
          borderRadius: BorderRadius.all(Radius.circular(8.h)),
          //设置四周边框
          //border:  Border.all(width: 1, color: Colors.red),
            gradient: LinearGradient(
              begin: Alignment.centerLeft,
              end: Alignment.centerRight,
              colors: [
                colorStart,
                colorEnd
              ],
            ),

        ),
        child: Container(
          child: Stack(
            children: [
              Container(
                width: 220.w,
                child: Row(
                  children: [
                    Container(
                      padding: EdgeInsets.only(left: 20.w, top: 20.h,bottom: 10.h),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            padding: EdgeInsets.only(left: 0.w, bottom: 5.h),

                            child: Text(title,
                                style:  TextStyle(color: Colors.white, fontSize: 25.sp)),
                          ),
                           Container(
                             padding: EdgeInsets.only(left: 0.w, bottom: 5.h),
                             child: Text(content,
                                style:  TextStyle(color: Colors.white, fontSize: 25.sp)),
                           ),
                        ],
                      ),
                    ),

                  ],
                ),
              ),
              Positioned(
                bottom: -16.w,
                right: 10.w,
                //margin: EdgeInsets.only( bottom: 0.h,right: 10.w),
                width: 80.w,
                height: 80.h,
                child: Image.asset(
                    url),
              ),
            ],
          ),
        ),
      ),
    );
  }
}


class MenuItem extends StatelessWidget {
  MenuItem({Key key, this.icon, this.title, this.onPressed}) : super(key: key);

  final String icon;
  final String title;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return  GestureDetector(
      onTap: onPressed,
      child:  Column(
        children: <Widget>[
           Padding(
            padding: const EdgeInsets.only(
              left: 20.0,
              top: 12.0,
              right: 20.0,
              bottom: 10.0,
            ),
            child:  Row(
              children: [
                 Padding(
                  padding: const EdgeInsets.only(
                    right: 12.0,
                  ),
                  child:  SvgPicture.asset(
                    icon,
                   // color: Colors.black54,
                  ),
                ),
                 Expanded(
                  child:  Text(
                    title,
                    style:  TextStyle(color: Colors.black87, fontSize: 16.0),
                  ),
                ),
                 Icon(
                  Icons.chevron_right,
                  color: Colors.black12,
                )
              ],
            ),
          ),
           Padding(
            padding: const EdgeInsets.only(left: 20.0, right: 20.0,top: 13),
            child:  Container(),
          )
        ],
      ),
    );
  }
}