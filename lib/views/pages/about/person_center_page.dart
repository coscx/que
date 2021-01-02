import 'package:flutter/material.dart';
import 'package:flutter_geen/app/router.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';


class MinePage extends StatefulWidget {
  @override
  _MinePageState createState() => _MinePageState();
}

class _MinePageState extends State<MinePage> with AutomaticKeepAliveClientMixin<MinePage> {
  final double _appBarHeight = 180.0;
  final String _userHead =
      'https://img.bosszhipin.com/beijin/mcs/useravatar/20171211/4d147d8bb3e2a3478e20b50ad614f4d02062e3aec7ce2519b427d24a3f300d68_s.jpg';

  @override
  bool get wantKeepAlive => true;

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
          new SliverAppBar(
            backgroundColor: Colors.white,
            expandedHeight: _appBarHeight,
            flexibleSpace: new FlexibleSpaceBar(
              collapseMode: CollapseMode.parallax,
              background: new Stack(
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
                    height: ScreenUtil().setHeight(120),
                    width: ScreenUtil().setWidth(120),
                    alignment: FractionalOffset.topLeft,
                    child: Image.asset("assets/packages/images/friend_card_bg.png"),
                  ),
                   Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      SizedBox(
                        width: ScreenUtil().setWidth(50),
                      ),
                      Expanded(
                        flex: 1,
                        child: new Padding(
                          padding: const EdgeInsets.only(
                            top: 40.0,
                            right: 30.0,
                          ),
                          child: new CircleAvatar(
                            radius: 35.0,
                            backgroundImage: new NetworkImage(_userHead),
                          ),
                        ),
                      ),
                       Expanded(
                        flex: 3,
                        child: new Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            new Padding(
                              padding: const EdgeInsets.only(
                                top: 40.0,
                                left: 3.0,
                                bottom: 5.0,
                              ),
                              child: new Text(
                                'MSTAR',
                                style: new TextStyle(
                                    color: Colors.black,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 20.0),
                              ),
                            ),

                              Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                SvgPicture.asset(
                                  "assets/packages/images/bb_id.svg",
                                  //color: Colors.black87,
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(
                                    left: 3.0,
                                  ),
                                  child: new Text(
                                    '121.423.199',
                                    style: new TextStyle(
                                        color: Colors.grey, fontSize: 15.0),
                                  ),
                                ),
                                ]),



                          ],
                        ),
                      ),
                      Padding(
                          padding: const EdgeInsets.only(
                            left: 0.0,
                            right: 20,
                            top: 40
                          ),
                          child:new Icon(
                            Icons.chevron_right,
                            color: Colors.grey,
                          )
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
          new SliverList(
            delegate: new SliverChildListDelegate(
              <Widget>[
                new Container(
                  color: Colors.white,
                  child: new Padding(
                    padding: const EdgeInsets.only(
                      top: 0.0,
                      bottom: 10.0,
                      left: 20,
                      right: 20
                    ),
                    child: new Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        new ContactItem(
                          count: '696',
                          title: '好友',
                        ),
                        new ContactItem(
                          count: '0',
                          title: '关注',
                        ),
                        new ContactItem(
                          count: '71',
                          title: '粉丝',
                        ),
                        new ContactItem(
                          count: '53',
                          title: '陪伴榜',
                        ),
                      ],
                    ),
                  ),
                ),



                Container(
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10.0),
                        color: Colors.white,
                        boxShadow: [BoxShadow(color: Color(0x19000000), offset: Offset(0.5, 0.5),  blurRadius: 1.5, spreadRadius: 1.5),  BoxShadow(color: Colors.white)],
                    ),
                    margin: EdgeInsets.fromLTRB(30,20,30,0),
                    child: ClipRRect(
                        borderRadius: BorderRadius.circular(10.0),
                        child: Row(
                          children: <Widget>[
                            SizedBox(
                              width: ScreenUtil().setWidth(10),
                            ),
                            GestureDetector(
                              onTap: (){
                                Navigator.pushNamed(context, UnitRouter.create_user_page);
                              },
                                child: Container(
                              padding: const EdgeInsets.only(
                                  top: 15.0,
                                  bottom: 15.0,
                                  left: 20,
                                  right: 20
                              ),
                              child:  Column(children: <Widget>[
                                Container(
                                  height: ScreenUtil().setHeight(60),
                                  width: ScreenUtil().setWidth(60),
                                  alignment: FractionalOffset.topLeft,
                                  child: Image.asset("assets/packages/images/tab_match.webp"),
                                ),
                                Text(
                                  "任务中心",
                                  style: new TextStyle(color: Colors.black54, fontSize: 12.0),
                                ),

                              ]),
                            )),


                        GestureDetector(
                          onTap: (){
                            Navigator.pushNamed(context, UnitRouter.select_page);
                          },
                          child:Container(
                              padding: const EdgeInsets.only(
                                  top: 10.0,
                                  bottom: 10.0,
                                  left: 20,
                                  right: 20
                              ),
                              child:  Column(children: <Widget>[
                                Container(
                                  height: ScreenUtil().setHeight(60),
                                  width: ScreenUtil().setWidth(60),
                                  alignment: FractionalOffset.topLeft,
                                  child: Image.asset("assets/packages/images/tab_match.webp"),
                                ),
                                Text(
                                  "钱包",
                                  style: new TextStyle(color: Colors.black54, fontSize: 12.0),
                                ),

                              ]),
                            )),

                            Container(
                              padding: const EdgeInsets.only(
                                  top: 10.0,
                                  bottom: 10.0,
                                  left: 20,
                                  right: 20
                              ),
                              child:  Column(children: <Widget>[
                                Container(
                                  height: ScreenUtil().setHeight(60),
                                  width: ScreenUtil().setWidth(60),
                                  alignment: FractionalOffset.topLeft,
                                  child: Image.asset("assets/packages/images/tab_match.webp"),
                                ),
                                Text(
                                  "商城",
                                  style: new TextStyle(color: Colors.black54, fontSize: 12.0),
                                ),

                              ]),
                            ),

                            Container(
                              padding: const EdgeInsets.only(
                                  top: 10.0,
                                  bottom: 10.0,
                                  left: 20,
                                  right: 20
                              ),
                              child:  Column(children: <Widget>[
                                Container(
                                  height: ScreenUtil().setHeight(60),
                                  width: ScreenUtil().setWidth(60),
                                  alignment: FractionalOffset.topLeft,
                                  child: Image.asset("assets/packages/images/tab_match.webp"),
                                ),
                                Text(
                                  "我的等级",
                                  style: new TextStyle(color: Colors.black54, fontSize: 12.0),
                                ),

                              ]),
                            ),



                          ],
                        ))),


                new Container(
                  color: Colors.white,
                  margin: const EdgeInsets.only(top: 20.0),
                  child: Column(
                    children: <Widget>[
                      new MenuItem(
                        icon: "assets/packages/images/ic_god.svg",
                        title: '申请大神',
                      ),
                      new MenuItem(
                        icon: "assets/packages/images/ic_profile_mentor_ship.svg",
                        title: '师徒关系',
                      ),

                      new MenuItem(
                        icon: "assets/packages/images/ic_my_bag.svg",
                        title: '我的背包',
                      ),
                      new MenuItem(
                        icon: "assets/packages/images/ic_activity.svg",
                        title: '订单',
                      ),
                      new MenuItem(
                        icon: "assets/packages/images/ic_app_review.svg",
                        title: '去好评',
                      ),
                      new MenuItem(
                        icon: "assets/packages/images/ic_contribute.svg",
                        title: '贡献题目',
                      ),
                      new MenuItem(
                        icon: "assets/packages/images/ic_invite.svg",
                        title: '邀请有礼',
                      ),
                      new MenuItem(
                        icon: "assets/packages/images/ic_activity.svg",
                        title: '活动',
                      ),
                      new MenuItem(
                        icon: "assets/packages/images/ic_settings.svg",
                        title: '账号设置',
                      ),
                      new MenuItem(
                        icon: "assets/packages/images/ic_service.svg",
                        title: '在线客服',
                      ),
                      new MenuItem(
                        icon: "assets/packages/images/ic_help.svg",
                        title: '帮助',
                      ),
                      new MenuItem(
                        icon: "assets/packages/images/ic_contact.svg",
                        title: '联系我们',
                      ),

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
}
class ContactItem extends StatelessWidget {
  ContactItem({Key key, this.count, this.title, this.onPressed})
      : super(key: key);

  final String count;
  final String title;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return new GestureDetector(
      onTap: onPressed,
      child: new Column(
        children: [
          new Padding(
            padding: const EdgeInsets.only(
              bottom: 4.0,
            ),
            child: new Text(count, style: new TextStyle(fontSize: 18.0)),
          ),
          new Text(title,
              style: new TextStyle(color: Colors.black54, fontSize: 12.0)),
        ],
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
    return new GestureDetector(
      onTap: onPressed,
      child: new Column(
        children: <Widget>[
          new Padding(
            padding: const EdgeInsets.only(
              left: 20.0,
              top: 12.0,
              right: 20.0,
              bottom: 10.0,
            ),
            child: new Row(
              children: [
                new Padding(
                  padding: const EdgeInsets.only(
                    right: 12.0,
                  ),
                  child: new SvgPicture.asset(
                    icon,
                   // color: Colors.black54,
                  ),
                ),
                new Expanded(
                  child: new Text(
                    title,
                    style: new TextStyle(color: Colors.black87, fontSize: 16.0),
                  ),
                ),
                new Icon(
                  Icons.chevron_right,
                  color: Colors.black12,
                )
              ],
            ),
          ),
          new Padding(
            padding: const EdgeInsets.only(left: 20.0, right: 20.0,top: 13),
            child: new Container(),
          )
        ],
      ),
    );
  }
}