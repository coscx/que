import 'package:flui/flui.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_geen/components/permanent/circle.dart';
import 'package:flutter_geen/views/dialogs/common_dialog.dart';
import 'package:flutter_geen/views/pages/chat/utils/DyBehaviorNull.dart';
import 'package:flutter_geen/views/pages/utils/common.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'detail_dialog.dart';
import 'detail_item.dart';

Widget item_photo(BuildContext context) {
  bool isDark = false;

  return Container(
    padding: EdgeInsets.only(top: 10.h, bottom: 0),
    width: double.infinity,
    height: 80.h,
    child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () {},
          child: Container(
            margin: EdgeInsets.only(left: 10.w, right: 20.w),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Row(children: <Widget>[
                  Icon(
                    Icons.account_circle_outlined,
                    size: 18,
                    color: Colors.black54,
                  ),
                  Container(
                    margin: EdgeInsets.only(left: 15.w),
                    child: Text(
                      "姓名",
                      style: TextStyle(fontSize: 30.sp, color: Colors.grey),
                    ),
                  ),
                  SizedBox(
                    width: ScreenUtil().setWidth(10),
                  ),
                  Visibility(
                      visible: true,
                      child: Text(
                        "用户已接待，有意愿继续服务",
                        style: TextStyle(fontSize: 12.sp, color: Colors.black),
                      )),
                ]),
                //Visibility是控制子组件隐藏/可见的组件
                Visibility(
                  visible: true,
                  child: Row(children: <Widget>[
                    Container(
                      margin: EdgeInsets.only(right: 10.w),
                      child: Row(children: <Widget>[
                        SizedBox(
                          width: ScreenUtil().setWidth(10),
                        ),
                        Visibility(
                            visible: true,
                            child: Text(
                              "2021-01-12 15:35:30",
                              style:
                                  TextStyle(fontSize: 7.sp, color: Colors.grey),
                            )),
                        Visibility(
                            visible: false,
                            child: CircleAvatar(
                              backgroundImage: AssetImage("rightImageUri"),
                            ))
                      ]),
                    ),
                    Icon(
                      Icons.arrow_forward_ios_outlined,
                      size: 15,
                      color: Colors.black54,
                    )
                  ]),
                )
              ],
            ),
          ),
        )),
  );
}

getStatusIndex(info) {
  try {
    return goals[info];
  } catch (e) {
    return "4.可继续沟通";
  }
}

getServeStatusIndex(info) {
  info = info - 19;
  try {
    return goalsAppoint[info];
  } catch (e) {
    return "21.新分VIP";
  }
}

getAllStatusIndex(info) {
  try {
    return goalAll[info];
  } catch (e) {
    return "4.可继续沟通";
  }
}

Widget item_connect(
    BuildContext context,
    String name,
    String connectTime,
    String content,
    String subscribeTime,
    String connectStatus,
    String connectType,
    int roleId) {
  bool isDark = false;

  return Container(
    height: 70.h,
    padding: EdgeInsets.only(top: 10.h, bottom: 0.h),
    //width: double.infinity,
    //height: 180.h,
    child: Container(
        color: Colors.transparent,
        child: GestureDetector(
          onTap: () {
            _showBottom(context, content,
                getAllStatusIndex(int.parse(connectStatus)), connectType);
          },
          child: Container(
            padding: EdgeInsets.only(left: 15.w, right: 20.w),
            child: Column(
              children: [
                Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Container(
                          height: 30.h,
                          child: Row(children: <Widget>[
                            Circle(
                              //connectType 沟通类型 1-线上沟通 2-到店沟通
                              color: connectType == "1"
                                  ? Colors.green
                                  : Colors.redAccent,
                              radius: 5,
                            ),
                            Container(
                              // width: ScreenUtil().screenWidth * 0.15,
                              constraints: BoxConstraints(
                                maxWidth: 120.w,
                              ),
                              margin: EdgeInsets.only(left: 15.w),
                              child: Text(
                                name == null ? "" : name,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: TextStyle(
                                    fontSize: 30.sp, color: Colors.black54),
                              ),
                            ),
                            Visibility(
                                visible: true,
                                child: Container(
                                    margin:
                                        EdgeInsets.only(top: 3.w, left: 5.w),
                                    //width: ScreenUtil().screenWidth*0.71,
                                    // height: 30.h,
                                    child: Row(
                                      children: [
                                        Container(
                                          child: Container(
                                            width:
                                                ScreenUtil().screenWidth * 0.68,
                                            child: Text(
                                              content,
                                              maxLines: 1,
                                              overflow: TextOverflow.ellipsis,
                                              style: TextStyle(
                                                  fontSize: 25.sp,
                                                  color: Colors.black,
                                                  fontWeight: FontWeight.w900),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ))),
                          ]),
                        ),
                        //Visibility是控制子组件隐藏/可见的组件
                        Visibility(
                          visible: true,
                          child: Container(
                            margin: EdgeInsets.only(top: 3.w),
                            child: Row(children: <Widget>[
                              Icon(
                                Icons.arrow_forward_ios_outlined,
                                size: 25.sp,
                                color: Colors.black54,
                              )
                            ]),
                          ),
                        )
                      ],
                    ),
                  ],
                ),
                Container(
                  margin: EdgeInsets.only(left: 0.w, top: 10.h),
                  child: Row(children: <Widget>[
                    SizedBox(
                      width: ScreenUtil().setWidth(10.w),
                    ),
                    Visibility(
                        visible: true,
                        child: Text(
                          "沟通时间:" + (connectTime == null ? "" : connectTime),
                          style:
                              TextStyle(fontSize: 20.sp, color: Colors.black54),
                        )),
                    SizedBox(
                      width: ScreenUtil().setWidth(10.w),
                    ),
                    Visibility(
                        visible: true,
                        child: Text(
                          "预约时间:" +
                              (subscribeTime == null ? "" : subscribeTime),
                          style:
                              TextStyle(fontSize: 20.sp, color: Colors.black54),
                        )),
                  ]),
                ),
              ],
            ),
          ),
        )),
  );
}

Widget item_appoint(
    BuildContext context,
    String name,
    String other_name,
    String appointment_address,
    String appointment_time,
    String can_write,
    String remark,
    String feedback1,
    String customerId,int id,String uuid,int canEdit) {
  bool isDark = false;

  return Container(
    padding: EdgeInsets.only(top: 10.h, bottom: 0),
    //width: double.infinity,
    height: 70.h,
    child: Material(
        color: Colors.transparent,
        child: GestureDetector(
          onTap: () {
            _showAppointBottom(context, name, other_name, appointment_time,
                appointment_address, remark, feedback1, customerId,id,uuid,canEdit);
          },
          child: Container(
            margin: EdgeInsets.only(left: 15.w, right: 20.w),
            child: Column(
              children: [
                Wrap(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Row(children: <Widget>[
                          Circle(
                            //connectType 沟通类型 1-线上沟通 2-到店沟通
                            color: Colors.redAccent,
                            radius: 5,
                          ),
                          Container(
                            // width: ScreenUtil().screenWidth * 0.15,
                            constraints: BoxConstraints(
                              maxWidth: 120.w,
                            ),
                            margin: EdgeInsets.only(left: 10.w),
                            child: Text(
                              name == null ? "" : name,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                                  fontSize: 30.sp, color: Colors.black54),
                            ),
                          ),
                          SizedBox(
                            width: 2.w,
                          ),
                          Container(
                            child: Icon(
                              Icons.account_tree_outlined,
                              size: 32.sp,
                              color: Colors.grey,
                            ),
                          ),
                          Container(
                            constraints: BoxConstraints(
                              maxWidth: 120.w,
                            ),
                            margin: EdgeInsets.only(left: 5.w),
                            child: Text(
                              other_name == null ? "" : other_name,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                                  fontSize: 30.sp, color: Colors.black54),
                            ),
                          ),
                          SizedBox(
                            width: 2.w,
                          ),
                          Visibility(
                              visible: true,
                              child: Container(
                                margin: EdgeInsets.only(top: 2.w),
                                width: ScreenUtil().screenWidth * 0.54,
                                child: Text(
                                  remark,
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  style: TextStyle(
                                      fontSize: 25.sp,
                                      color: Colors.black,
                                      fontWeight: FontWeight.w900),
                                ),
                              )),
                        ]),
                        //Visibility是控制子组件隐藏/可见的组件
                        Visibility(
                          visible: true,
                          child: Row(children: <Widget>[
                            Icon(
                              Icons.arrow_forward_ios_outlined,
                              size: 25.sp,
                              color: Colors.black54,
                            )
                          ]),
                        )
                      ],
                    ),
                  ],
                ),
                Container(
                  margin: EdgeInsets.only(left: 10.w, top: 10.h),
                  child: Row(children: <Widget>[
                    SizedBox(
                      width: ScreenUtil().setWidth(10.w),
                    ),
                    Visibility(
                        visible: true,
                        child: Text(
                          "约会时间:" +
                              (appointment_time == null
                                  ? ""
                                  : appointment_time),
                          style:
                              TextStyle(fontSize: 20.sp, color: Colors.black54),
                        )),
                    SizedBox(
                      width: ScreenUtil().setWidth(10.w),
                    ),
                    Visibility(
                        visible: true,
                        child: Container(
                          width: ScreenUtil().screenWidth * 0.51,
                          child: Text(
                            "约会地点:" +
                                (appointment_address == null
                                    ? ""
                                    : appointment_address),
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                                fontSize: 20.sp, color: Colors.black54),
                          ),
                        )),
                  ]),
                ),
              ],
            ),
          ),
        )),
  );
}

Widget itemAction(BuildContext context, String name, String title,
    String content, String time) {
  return Container(
    padding: EdgeInsets.only(top: 10.h, bottom: 0),
    width: double.infinity,
    //height: 180.h,
    child: Material(
        color: Colors.transparent,
        child: GestureDetector(
          onTap: () {
            _showActionBottom(context, name, "", time, title, content, "");
          },
          child: Container(
            margin: EdgeInsets.only(left: 15.w, right: 20.w),
            child: Column(
              children: [
                Wrap(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Row(children: <Widget>[
                          Circle(
                            //connectType 沟通类型 1-线上沟通 2-到店沟通
                            color: Colors.grey,
                            radius: 5,
                          ),
                          Container(
                            constraints: BoxConstraints(
                              maxWidth: 120.w,
                            ),
                            margin: EdgeInsets.only(left: 15.w),
                            child: Text(
                              name == null ? "" : name,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                                  fontSize: 30.sp, color: Colors.black),
                            ),
                          ),
                          Visibility(
                              visible: true,
                              child: Container(
                                  margin: EdgeInsets.only(top: 0.w, left: 5.w),
                                  //width: ScreenUtil().screenWidth*0.71,
                                  height: 30.h,
                                  child: Row(
                                    children: [
                                      Container(
                                        child: Container(
                                          width:
                                              ScreenUtil().screenWidth * 0.63,
                                          child: Text(
                                            content,
                                            maxLines: 1,
                                            overflow: TextOverflow.ellipsis,
                                            style: TextStyle(
                                                fontSize: 25.sp,
                                                color: Colors.black,
                                                fontWeight: FontWeight.w900),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ))),
                        ]),
                        //Visibility是控制子组件隐藏/可见的组件
                        Visibility(
                          visible: true,
                          child: Row(children: <Widget>[
                            Icon(
                              Icons.arrow_forward_ios_outlined,
                              size: 25.sp,
                              color: Colors.black54,
                            )
                          ]),
                        )
                      ],
                    ),
                  ],
                ),
                Container(
                  margin: EdgeInsets.only(left: 0.w, top: 10.h),
                  child: Row(children: <Widget>[
                    SizedBox(
                      width: ScreenUtil().setWidth(10.w),
                    ),
                    Visibility(
                        visible: true,
                        child: Text(
                          "操作类型:" + (title == null ? "" : title),
                          style:
                              TextStyle(fontSize: 20.sp, color: Colors.black54),
                        )),
                    SizedBox(
                      width: ScreenUtil().setWidth(10.w),
                    ),
                    Visibility(
                        visible: true,
                        child: Text(
                          "操作时间:" + (time == null ? "" : time),
                          style:
                              TextStyle(fontSize: 20.sp, color: Colors.black54),
                        )),
                  ]),
                ),
              ],
            ),
          ),
        )),
  );
}

Widget itemCall(BuildContext context, String name, String count, String time) {
  bool isDark = false;

  return Container(
    padding: EdgeInsets.only(top: 10.h, bottom: 0),
    width: double.infinity,
    //height: 180.h,
    child: Material(
        color: Colors.transparent,
        child: GestureDetector(
          onTap: () {},
          child: Container(
            margin: EdgeInsets.only(left: 15.w, right: 20.w),
            child: Column(
              children: [
                Wrap(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Row(children: <Widget>[
                          Circle(
                            //connectType 沟通类型 1-线上沟通 2-到店沟通
                            color: Colors.grey,
                            radius: 5,
                          ),
                          Container(
                            margin: EdgeInsets.only(left: 15.w),
                            child: Text(
                              name == null ? "" : name,
                              style: TextStyle(
                                  fontSize: 30.sp, color: Colors.black),
                            ),
                          ),
                          Visibility(
                              visible: true,
                              child: Container(
                                  margin: EdgeInsets.only(top: 0.w, left: 5.w),
                                  // width: ScreenUtil().screenWidth*0.6,
                                  height: 30.h,
                                  child: Row(
                                    children: [
                                      Container(
                                        child: Container(
                                          //width: ScreenUtil().screenWidth * 0.63,
                                          child: Text(
                                            "查看" + count + "次",
                                            maxLines: 1,
                                            overflow: TextOverflow.ellipsis,
                                            style: TextStyle(
                                                fontSize: 25.sp,
                                                color: Colors.black,
                                                fontWeight: FontWeight.w900),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ))),
                        ]),
                        //Visibility是控制子组件隐藏/可见的组件
                        Visibility(
                          visible: false,
                          child: Row(children: <Widget>[
                            Icon(
                              Icons.arrow_forward_ios_outlined,
                              size: 25.sp,
                              color: Colors.black54,
                            )
                          ]),
                        )
                      ],
                    ),
                  ],
                ),
                Container(
                  margin: EdgeInsets.only(left: 0.w, top: 10.h),
                  child: Row(children: <Widget>[
                    Visibility(
                        visible: true,
                        child: Text(
                          "最后查看时间:" + (time == null ? "" : time),
                          style:
                              TextStyle(fontSize: 22.sp, color: Colors.black),
                        )),
                  ]),
                ),
              ],
            ),
          ),
        )),
  );
}

_showAppointBottom(
    BuildContext context,
    String userName,
    String otherName,
    String time,
    String address,
    String remark,
    String feedback,
    String customerId,int id,String uuid,int canEdit) {
  showFLBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return ScrollConfiguration(
            behavior: DyBehaviorNull(),
            child: FLCupertinoActionSheet(
              child: Container(
                color: Colors.white,
                constraints: BoxConstraints(
                  minHeight: 450.h,
                  // minWidth: double.infinity, // //宽度尽可能大
                ),
                padding: EdgeInsets.only(
                    left: 25.w, right: 25.w, top: 25.h, bottom: 20.h),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    Container(
                      child: Text(
                        "服务红娘:" + userName,
                        textAlign: TextAlign.left,
                        style: TextStyle(
                            fontSize: 28.sp,
                            color: Colors.black,
                            fontWeight: FontWeight.w800),
                      ),
                    ),
                    SizedBox(
                      height: 10.h,
                    ),
                    Container(
                      child: Text(
                        "约会对象:" + otherName + "(id:" + customerId + ")",
                        textAlign: TextAlign.left,
                        style: TextStyle(
                            fontSize: 28.sp,
                            color: Colors.black,
                            fontWeight: FontWeight.w800),
                      ),
                    ),
                    SizedBox(
                      height: 10.h,
                    ),
                    Container(
                      child: Text(
                        "约会时间:" + time,
                        textAlign: TextAlign.left,
                        style: TextStyle(
                            fontSize: 28.sp,
                            color: Colors.black,
                            fontWeight: FontWeight.w800),
                      ),
                    ),
                    SizedBox(
                      height: 10.h,
                    ),
                    Container(
                      child: Text(
                        "约会地点:" + (address == null ? "" : address),
                        textAlign: TextAlign.left,
                        style: TextStyle(
                            fontSize: 28.sp,
                            color: Colors.black,
                            fontWeight: FontWeight.w800),
                      ),
                    ),
                    SizedBox(
                      height: 10.h,
                    ),
                    Container(
                      child: Text(
                        "约会备注:" + remark,
                        textAlign: TextAlign.left,
                        style: TextStyle(
                            fontSize: 28.sp,
                            color: Colors.black,
                            fontWeight: FontWeight.w800),
                      ),
                    ),
                    SizedBox(
                      height: 10.h,
                    ),
                    Container(
                      child: Text(
                        "回访记录:" +
                            (feedback == null || feedback == "null"
                                ? ""
                                : feedback),
                        textAlign: TextAlign.left,
                        style: TextStyle(
                            fontSize: 28.sp,
                            color: Colors.black,
                            fontWeight: FontWeight.w800),
                      ),
                    ),
                    feedback == null || feedback == "null" || feedback == ""
                        ? (canEdit ==0 ?Container() :buildBackSubmit(context,id,uuid,canEdit))
                        : Container()
                  ],
                ),
              ),
              cancelButton: CupertinoActionSheetAction(
                child: const Text('关闭'),
                isDefaultAction: true,
                onPressed: () {
                  Navigator.pop(context, 'Cancel');
                },
              ),
            ));
      }).then((value) {
    //print(value);
  });
}

Widget buildBackSubmit(BuildContext context,int id,String uuid,int canEdit) {
  return Padding(
    padding: EdgeInsets.only(top: 50.h, bottom: 0.h, left: 30.h, right: 30.h),
    child: Container(
      width: ScreenUtil().screenWidth * 0.4,
      height: 60.h,
      child: RaisedButton(
        elevation: 0,
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(40.w))),
        color: Colors.lightBlue,
        onPressed: () async {
          if(canEdit ==0){
            showToastRed(context, "暂无权限", false);
            Navigator.pop(context, 'Cancel');
            return;
          }
          Navigator.pop(context, 'Cancel');
          var result = await showBackDialog(context, "请输入回访记录",
              "", "", "name", 3,
              id,uuid);
        },
        child: Text("填写回访记录",
            style: TextStyle(color: Colors.white, fontSize: 35.sp)),
      ),
    ),
  );
}

_showActionBottom(BuildContext context, String userName, String otherName,
    String time, String address, String remark, String feedback) {
  showFLBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return ScrollConfiguration(
            behavior: DyBehaviorNull(),
            child: FLCupertinoActionSheet(
              child: Container(
                color: Colors.white,
                constraints: BoxConstraints(
                  minHeight: 450.h,
                  // minWidth: double.infinity, // //宽度尽可能大
                ),
                padding: EdgeInsets.only(
                    left: 25.w, right: 25.w, top: 25.h, bottom: 20.h),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    Container(
                      child: Text(
                        "操作人:" + userName,
                        textAlign: TextAlign.left,
                        style: TextStyle(
                            fontSize: 28.sp,
                            color: Colors.black,
                            fontWeight: FontWeight.w800),
                      ),
                    ),
                    SizedBox(
                      height: 10.h,
                    ),
                    Container(
                      child: Text(
                        "操作时间:" + time,
                        textAlign: TextAlign.left,
                        style: TextStyle(
                            fontSize: 28.sp,
                            color: Colors.black,
                            fontWeight: FontWeight.w800),
                      ),
                    ),
                    SizedBox(
                      height: 10.h,
                    ),
                    Container(
                      child: Text(
                        "操作类型:" + (address == null ? "" : address),
                        textAlign: TextAlign.left,
                        style: TextStyle(
                            fontSize: 28.sp,
                            color: Colors.black,
                            fontWeight: FontWeight.w800),
                      ),
                    ),
                    SizedBox(
                      height: 10.h,
                    ),
                    Container(
                      child: Text(
                        "操作内容:" + remark,
                        textAlign: TextAlign.left,
                        style: TextStyle(
                            fontSize: 28.sp,
                            color: Colors.black,
                            fontWeight: FontWeight.w800),
                      ),
                    ),
                  ],
                ),
              ),
              cancelButton: CupertinoActionSheetAction(
                child: const Text('关闭'),
                isDefaultAction: true,
                onPressed: () {
                  Navigator.pop(context, 'Cancel');
                },
              ),
            ));
      }).then((value) {
    //print(value);
  });
}

_showBottom(BuildContext context, String text, String status, String type) {
  showFLBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return ScrollConfiguration(
            behavior: DyBehaviorNull(),
            child: FLCupertinoActionSheet(
              child: Container(
                color: Colors.white,
                constraints: BoxConstraints(
                  minHeight: 450.h,
                  // minWidth: double.infinity, // //宽度尽可能大
                ),
                padding: EdgeInsets.only(
                    left: 25.w, right: 25.w, top: 25.h, bottom: 20.h),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Opacity(
                            opacity: 0.2,
                            child: Container(
                              child: Text(
                                "沟通方式:" + (type == "1" ? "电话" : "到店"),
                                textAlign: TextAlign.left,
                                style: TextStyle(
                                    fontSize: 24.sp,
                                    color: type == "2"
                                        ? Colors.redAccent
                                        : Colors.green,
                                    fontWeight: FontWeight.w300),
                              ),
                            )),
                        Opacity(
                            opacity: 0.2,
                            child: Container(
                              child: Text(
                                "沟通状态:" + status,
                                textAlign: TextAlign.left,
                                style: TextStyle(
                                    fontSize: 24.sp,
                                    color: Colors.black54,
                                    fontWeight: FontWeight.w300),
                              ),
                            )),
                      ],
                    ),
                    SizedBox(
                      height: 10.h,
                    ),
                    Container(
                      child: Text(
                        text,
                        textAlign: TextAlign.left,
                        style: TextStyle(
                            fontSize: 32.sp, fontWeight: FontWeight.w900),
                      ),
                    )
                  ],
                ),
              ),
              cancelButton: CupertinoActionSheetAction(
                child: const Text('关闭'),
                isDefaultAction: true,
                onPressed: () {
                  Navigator.pop(context, 'Cancel');
                },
              ),
            ));
      }).then((value) {
    //print(value);
  });
}
