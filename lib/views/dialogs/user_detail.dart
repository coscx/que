/*
 * @discripe: 登录弹窗弹窗
 */
import 'package:fbutton/fbutton.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
class UserDetailDialog extends Dialog  {
  UserDetailDialog({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Material(
      type: MaterialType.transparency,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Container(
            width: 600.w,
            height: 600.h,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.all(Radius.circular(6.w)),
            ),
            child: OverflowBox(
              alignment: Alignment.bottomCenter,
              maxHeight: 600.h,
              child: Stack(
                alignment: AlignmentDirectional.topCenter,
                children: <Widget>[
                  Positioned(
                    top: 50.h,
                    child: Image.asset(
                      'assets/images/login_top.png',
                      width: 220.w,
                    ),
                  ),

                  Positioned(
                    top: 30.h,
                    right: 30.h,
                    child: GestureDetector(
                      onTap: () => Navigator.of(context).pop(),
                      child: Image.asset('assets/images/btn_close_black.png',
                        color: Colors.black,
                        width: 30.w,
                      ),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(
                      left: 20.w,
                      right: 20.w,
                      top: 80.h,
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: <Widget>[
                        SizedBox(
                          height: 50.h,
                        ),

                         Container(
                            width: 480.w,
                            height: 300.h,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.all(Radius.circular(30.w)),
                              image: new DecorationImage(
                                image: Image.asset(
                                  "assets/images/credit.png",
                                  fit: BoxFit.cover,
                                  //width: 520.w,
                                  //height: 600.h,
                                  //: 240,
                                ).image,

                              ),
                            ),
                            child:  Stack(
                                children: <Widget>[


                                  Positioned(
                                    top: 45.h,
                                    left: 117.w,
                                    child:Text("王永",
                                        style: TextStyle(color: Colors.black, fontSize: 12)),

                                  ),

                                  Positioned(
                                    top: 80.h,
                                    left: 122.w,
                                    child:Text("女",
                                        style: TextStyle(color: Colors.black, fontSize: 12)),

                                  ),
                                  Positioned(
                                    top: 80.h,
                                    left: 230.w,
                                    child:Text("汉",
                                        style: TextStyle(color: Colors.black, fontSize: 12)),

                                  ),
                                  Positioned(
                                    top: 118.h,
                                    left: 122.w,
                                    child:Text("1988",
                                        style: TextStyle(color: Colors.black, fontSize: 12)),

                                  ),
                                  Positioned(
                                    top: 118.h,
                                    left: 207.w,
                                    child:Text("6",
                                        style: TextStyle(color: Colors.black, fontSize: 12)),

                                  ),
                                  Positioned(
                                    top: 118.h,
                                    left: 250.w,
                                    child:Text("18",
                                        style: TextStyle(color: Colors.black, fontSize: 12)),

                                  ),

                                  Positioned(
                                      top: 150.h,
                                      left: 120.w,
                                      child:
                                      Container(
                                        width: 230.w,
                                        height: 100.h,
                                        child: Container(
                                            child:Text("江苏省苏州市虎丘区枫桥街道康佳花园96号",
                                                maxLines: 2,
                                                style: TextStyle(color: Colors.black, fontSize: 11))),
                                      )
                                  ),

                                  Positioned(
                                    top: 245.h,
                                    left: 175.w,
                                    child:Text("371327198611235566",
                                        style: TextStyle(
                                            color: Colors.black,
                                            fontSize: 12,
                                          fontWeight: FontWeight.w600,
                                          letterSpacing: 6.w,
                                        )),

                                  ),
                                  Positioned(
                                    top: 210.h,
                                    left: 75.w,
                                    child:Text("会员到期:2021-12-25 15:20:30",
                                        style: TextStyle(
                                          color: Colors.black,
                                          fontSize: 11,
                                          fontWeight: FontWeight.w100,
                                          letterSpacing: 0.w,
                                        )),

                                  ),
                                  Positioned(
                                    top: 20.h,
                                    left: 349.w,
                                    child: Container(
                                      decoration: new BoxDecoration(
                                        //背景
                                        color: Colors.transparent,
                                        //设置四周圆角 角度
                                        //borderRadius: BorderRadius.all(Radius.circular(10.w)),
                                      ),
                                      child: ClipRRect	(
                                        borderRadius: BorderRadius.all(Radius.circular(2.w)),
                                        child: Image.network(
                                          "https://ss3.bdstatic.com/70cFv8Sh_Q1YnxGkpoWK1HF6hhy/it/u=1848508249,613692992&fm=26&gp=0.jpg",
                                          fit: BoxFit.cover,
                                          width: 160.w,
                                          height: 200.h,
                                        ),
                                      ),

                                    ),

                                  ),

                                  Positioned(
                                    top: 0.h,
                                    left: 316.w,
                                    child: Container(
                                      decoration: new BoxDecoration(
                                        //背景
                                        color: Colors.transparent,
                                        //设置四周圆角 角度
                                        borderRadius: BorderRadius.all(Radius.circular(10.0)),
                                      ),
                                      child: ClipRRect	(
                                        borderRadius: BorderRadius.all(Radius.circular(2.0)),
                                        child: Image.asset(
                                          "assets/images/rank1.png",
                                          //fit: BoxFit.cover,
                                          width: 60.w,
                                          height: 60.h,
                                        ),
                                      ),

                                    ),

                                  ),
                                ]),




                          ),




                        Padding(
                          padding: EdgeInsets.only(top: 20.h, bottom: 15.h),
                          child: RaisedButton(
                            elevation: 0,
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.all(Radius.circular(20))),
                            color: Colors.lightBlue,
                            onPressed: (){

                              Navigator.of(context).pop();
                            },
                            child: Text("查看用户详情",
                                style: TextStyle(color: Colors.white, fontSize: 18)),
                          ),
                        ),

                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
