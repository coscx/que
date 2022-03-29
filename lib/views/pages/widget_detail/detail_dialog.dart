import 'package:bot_toast/bot_toast.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_geen/app/router.dart';
import 'package:flutter_geen/blocs/detail/detail_bloc.dart';
import 'package:flutter_geen/blocs/detail/detail_event.dart';
import 'package:flutter_geen/views/dialogs/common_dialog.dart';
import 'package:flutter_geen/views/pages/utils/common.dart';
import 'package:flutter_my_picker/flutter_my_picker.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:menu_button/menu_button.dart';

import 'detail_common.dart';

final _Controller = TextEditingController(text: '');
final _appointController = TextEditingController(text: '');
FocusNode _textFieldNode = FocusNode();
FocusNode _remarkFieldNode = FocusNode();
FocusNode _connectFieldNode = FocusNode();
final _usernameController = TextEditingController(text: '');
FocusNode _textPlaceFieldNode = FocusNode();
final _placeController = TextEditingController(text: '');

String goalValue = '4.可继续沟通';
String goalValueAppoint = '21.新分VIP';
DateTime _date = new DateTime.now();
DateTime _date1 = _date.add(new Duration(days: 3));
int connect_type = 1;
var time1s = _date.toString();
var time2s = _date.add(new Duration(days: 3)).toString();
String time1 = time1s.substring(0, 19), time2 = time2s.substring(0, 19);

String other_uuid;
String appointment_time = _date.toString().substring(0, 19);
String appointment_address;
String remark;
String address_lng;
String address_lat;
String customer_uuid;

Future<bool> appointDialog(
    BuildContext context, Map<String, dynamic> detail) async {
  var result = await showDialog(
      barrierDismissible: false,
      context: context,
      builder: (ctx) => StatefulBuilder(builder: (context, state) {
            return GestureDetector(
              onTap: () {
                _textPlaceFieldNode.unfocus();
                _textFieldNode.unfocus();
                _remarkFieldNode.unfocus();
              },
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Container(
                    width: ScreenUtil().screenWidth * 0.95,
                    height: ScreenUtil().screenHeight * 0.55,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.all(Radius.circular(12.w)),
                    ),
                    child: SingleChildScrollView(
                      //alignment: Alignment.bottomCenter,
                      //maxHeight: 700.h,
                      child: Stack(
                        alignment: AlignmentDirectional.topCenter,
                        children: <Widget>[
                          // Positioned(
                          //   top: 20.h,
                          //   child: Image.asset(
                          //     'assets/images/login_top.png',
                          //     width: 220.w,
                          //   ),
                          // ),

                          Positioned(
                            top: 30.h,
                            right: 30.h,
                            child: GestureDetector(
                              onTap: () {
                                goalValue = '1.新分未联系';
                                goalValueAppoint = '21.新分VIP';
                                _date = new DateTime.now();
                                connect_type = 1;
                                var time1s = _date.toString();
                                var time2s =
                                    _date.add(new Duration(days: 3)).toString();
                                time1 = time1s.substring(0, 19);
                                time2 = time2s.substring(0, 19);
                                _Controller.clear();
                                _usernameController.clear();
                                _placeController.clear();
                                other_uuid = "";
                                Navigator.of(context).pop();
                              },
                              child: Image.asset(
                                'assets/images/btn_close_black.png',
                                width: 40.w,
                              ),
                            ),
                          ),
                          Padding(
                            padding: EdgeInsets.only(
                              left: 30.w,
                              right: 30.w,
                              top: 0.h,
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.stretch,
                              children: <Widget>[
                                SizedBox(
                                  height: 20.h,
                                ),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    GestureDetector(
                                      onTap: () {
                                        MyPicker.showPicker(
                                            context: context,
                                            current: _date,
                                            squeeze: 1.45,
                                            magnification: 1.2,
                                            offAxisFraction: 0.2,
                                            mode: MyPickerMode.dateTime,
                                            onConfirm: (v) {
                                              //_change('yyyy-MM-dd HH:mm'),
                                              print(v);
                                              state(() {
                                                _date = v;
                                                appointment_time = v
                                                    .toString()
                                                    .substring(0, 19);
                                              });
                                            });
                                      },
                                      child: Row(
                                        children: [
                                          Text("排约时间",
                                              style: TextStyle(
                                                  fontSize: 30.sp,
                                                  color: Colors.blue)),
                                          Icon(
                                            Icons.keyboard_arrow_down_outlined,
                                            color: Colors.blue,
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                                SizedBox(
                                  height: 10.h,
                                ),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    GestureDetector(
                                      onTap: () {},
                                      child: Container(
                                        child: Row(
                                          children: [
                                            Text(appointment_time,
                                                style: TextStyle(
                                                    fontSize: 40.sp,
                                                    color: Colors.redAccent,
                                                    fontWeight:
                                                        FontWeight.w800)),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                SizedBox(
                                  height: 10.w,
                                ),
                                Row(
                                  children: [
                                    Expanded(
                                      child: Container(
                                        height: 100.h,
                                        child: TextField(
                                            focusNode: _textFieldNode,
                                            autofocus: false,
                                            style: TextStyle(
                                                color: Colors.black,
                                                fontSize: 28.sp),
                                            //scrollPadding:   EdgeInsets.only(top: 10.h, left: 35.w, bottom: 5.h),
                                            controller: _usernameController,
                                            keyboardType: TextInputType.text,
                                            decoration: InputDecoration(
                                                labelText: "排约对象",
                                                labelStyle: TextStyle(
                                                    color: Colors.blue),
                                                hintText: "请点击右侧选择>>>",
                                                enabledBorder:
                                                    const OutlineInputBorder(
                                                  borderSide: const BorderSide(
                                                      color: Colors.blue,
                                                      width: 1),
                                                ),
                                                border: OutlineInputBorder(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            5.0)))),
                                      ),
                                    ),
                                    SizedBox(
                                      height: 10.w,
                                    ),
                                    Container(
                                      height: 70.h,
                                      padding: EdgeInsets.only(
                                          top: 0.h, left: 15.w, bottom: 0.h),
                                      child: OutlineButton(
                                        onPressed: () {
                                          Navigator.pushNamed(
                                                  context,
                                                  UnitRouter
                                                      .search_page_appoint)
                                              .then((value) {
                                            List<String> data =
                                                value.toString().split("#");
                                            other_uuid = data.elementAt(0);
                                            _usernameController.text =
                                                data.elementAt(1);
                                            _textPlaceFieldNode.unfocus();
                                            _textFieldNode.unfocus();
                                          });
                                        },
                                        child: Text("搜索用户"),
                                        textColor: Colors.blue,
                                        splashColor: Colors.green,
                                        highlightColor: Colors.black,
                                        shape: BeveledRectangleBorder(
                                          side: BorderSide(
                                            color: Colors.red,
                                            width: 2.w,
                                          ),
                                          borderRadius:
                                              BorderRadius.circular(10.w),
                                        ),
                                      ),
                                    )
                                  ],
                                ),
                                SizedBox(
                                  height: 10.w,
                                ),
                                Row(
                                  children: [
                                    Expanded(
                                      child: Container(
                                        height: 100.h,
                                        child: TextField(
                                            focusNode: _textPlaceFieldNode,
                                            autofocus: false,
                                            style: TextStyle(
                                                color: Colors.black,
                                                fontSize: 28.sp),
                                            controller: _placeController,
                                            keyboardType: TextInputType.text,
                                            decoration: InputDecoration(
                                                labelText: "排约地点",
                                                labelStyle: TextStyle(
                                                    color: Colors.blue),
                                                hintText: "请点击右侧选择>>>",
                                                enabledBorder:
                                                    const OutlineInputBorder(
                                                  borderSide: const BorderSide(
                                                      color: Colors.blue,
                                                      width: 1),
                                                ),
                                                border: OutlineInputBorder(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            5.0)))),
                                      ),
                                    ),
                                    SizedBox(
                                      height: 5.w,
                                    ),
                                    Container(
                                      height: 70.h,
                                      padding: EdgeInsets.only(
                                          top: 0.h, left: 15.w, bottom: 0.h),
                                      child: OutlineButton(
                                        onPressed: () {
                                          Navigator.pushNamed(
                                                  context, UnitRouter.baidu_map)
                                              .then((value) {
                                            List<String> data =
                                                value.toString().split("#");
                                            appointment_address =
                                                data.elementAt(1) + "";
                                            address_lng = data.elementAt(2);
                                            address_lat = data.elementAt(3);

                                            _placeController.text =
                                                appointment_address;
                                          });
                                        },
                                        child: Text("搜索地点"),
                                        textColor: Colors.blue,
                                        splashColor: Colors.green,
                                        highlightColor: Colors.black,
                                        shape: BeveledRectangleBorder(
                                          side: BorderSide(
                                            color: Colors.red,
                                            width: 2.w,
                                          ),
                                          borderRadius:
                                              BorderRadius.circular(10.w),
                                        ),
                                      ),
                                    )
                                  ],
                                ),
                                SizedBox(
                                  height: 10.w,
                                ),
                                SizedBox(
                                  height: 20.w,
                                ),
                                Container(
                                  width: 300.w,
                                  child: TextField(
                                    controller: _appointController,
                                    focusNode: _remarkFieldNode,
                                    style: TextStyle(color: Colors.black),
                                    minLines: 7,
                                    maxLines: 7,
                                    cursorColor: Colors.blue,
                                    cursorRadius: Radius.circular(3.w),
                                    cursorWidth: 3.w,
                                    showCursor: true,
                                    decoration: InputDecoration(
                                      contentPadding: EdgeInsets.all(10.w),
                                      hintText: "请输入...",
                                      hintStyle: TextStyle(color: Colors.blue),
                                      border: OutlineInputBorder(),
                                      enabledBorder: OutlineInputBorder(
                                          borderSide:
                                              BorderSide(color: Colors.blue)),
                                    ),
                                    onChanged: (v) {},
                                  ),
                                ),
                                Padding(
                                  padding:
                                      EdgeInsets.only(top: 20.h, bottom: 5.h),
                                  child: RaisedButton(
                                    elevation: 0,
                                    shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(20))),
                                    color: Colors.lightBlue,
                                    onPressed: () {
                                      customer_uuid = detail['uuid'];
                                      if (_usernameController.text.isEmpty) {
                                        BotToast.showSimpleNotification(
                                            title: "请选择排约用户");
                                        return;
                                      }
                                      if (other_uuid == "") {
                                        BotToast.showSimpleNotification(
                                            title: "请选择排约用户");
                                        return;
                                      }
                                      if (_placeController.text.isEmpty) {
                                        BotToast.showSimpleNotification(
                                            title: "请选择排约地点");
                                        return;
                                      }
                                      if (_appointController.text.isEmpty) {
                                        BotToast.showSimpleNotification(
                                            title: "请输入约会记录");
                                        return;
                                      }

                                      if (appointment_time == "") {
                                        BotToast.showSimpleNotification(
                                            title: "请选择排约时间");
                                        return;
                                      }
                                      if (appointment_address == "") {
                                        BotToast.showSimpleNotification(
                                            title: "请选择排约地点");
                                        return;
                                      }
                                      if (address_lng == "") {
                                        BotToast.showSimpleNotification(
                                            title: "请选择排约地点");
                                        return;
                                      }
                                      if (address_lat == "") {
                                        BotToast.showSimpleNotification(
                                            title: "请选择排约地点");
                                        return;
                                      }
                                      remark = _appointController.text;
                                      if (other_uuid != null)
                                        BlocProvider.of<DetailBloc>(context)
                                            .add(AddAppointEvent(
                                                detail,
                                                other_uuid,
                                                appointment_time,
                                                appointment_address,
                                                remark,
                                                address_lng,
                                                address_lat,
                                                _usernameController.text));
                                      _usernameController.clear();
                                      _placeController.clear();
                                      _appointController.clear();
                                      other_uuid = "";

                                      appointment_time = "";

                                      appointment_address = "";

                                      address_lng = "";

                                      address_lat = "";
                                      appointment_time =
                                          _date.toString().substring(0, 19);
                                      showToast(context, "创建成功", false);
                                      Navigator.of(context).pop(true);
                                    },
                                    child: Text("提交",
                                        style: TextStyle(
                                            color: Colors.white, fontSize: 18)),
                                  ),
                                ),
                                SizedBox(
                                  height: 80.w,
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 20.h,
                  ),
                ],
              ),
            );
          }));
  return result;
}

Widget normalChildButton(String selectedKey) {
  return SizedBox(
    width: 140.w,
    height: 60.h,
    child: Padding(
      padding: EdgeInsets.only(left: 16.w, right: 11.w),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Flexible(child: Text(selectedKey, overflow: TextOverflow.ellipsis)),
          SizedBox(
            width: 24.w,
            height: 34.h,
            child: FittedBox(
              fit: BoxFit.fill,
              child: Icon(
                Icons.arrow_drop_down,
                color: Colors.grey,
              ),
            ),
          ),
        ],
      ),
    ),
  );
}

Future<bool> commentDialog(BuildContext context, int connectStatus,
    Map<String, dynamic> detail) async {
  var roleId = detail['role_id'];
  if (roleId == 7 || roleId == 9) {
    goals = goalsAppoint;
    goalValue = getServeStatusIndex(connectStatus);
  } else {
    goalValue = getStatusIndex(connectStatus);
  }
  var result = await showDialog(
      barrierDismissible: false,
      context: context,
      builder: (ctx) => StatefulBuilder(builder: (context, state) {
            return GestureDetector(
              onTap: () {
                _connectFieldNode.unfocus();
              },
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Container(
                    width: ScreenUtil().screenWidth * 0.95,
                    height: ScreenUtil().screenHeight * 0.55,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.all(Radius.circular(12.w)),
                    ),
                    child: SingleChildScrollView(
                      //alignment: Alignment.bottomCenter,
                      //maxHeight: 700.h,
                      child: Stack(
                        alignment: AlignmentDirectional.topCenter,
                        children: <Widget>[
                          // Positioned(
                          //   top: 20.h,
                          //   child: Image.asset(
                          //     'assets/images/login_top.png',
                          //     width: 220.w,
                          //   ),
                          // ),

                          Positioned(
                            top: 30.h,
                            right: 30.h,
                            child: GestureDetector(
                              onTap: () {
                                goalValue = '1.新分未联系';

                                _date = new DateTime.now();
                                connect_type = 1;
                                var time1s = _date.toString();
                                var time2s =
                                    _date.add(new Duration(days: 3)).toString();
                                time1 = time1s.substring(0, 19);
                                time2 = time2s.substring(0, 19);
                                _Controller.clear();
                                Navigator.of(context).pop();
                              },
                              child: Image.asset(
                                'assets/images/btn_close_black.png',
                                width: 40.w,
                              ),
                            ),
                          ),
                          Padding(
                            padding: EdgeInsets.only(
                              left: 30.w,
                              right: 30.w,
                              top: 0.h,
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.stretch,
                              children: <Widget>[
                                SizedBox(
                                  height: 0.h,
                                ),
                                Row(
                                  children: [
                                    Text("沟通方式: ",
                                        style: TextStyle(
                                            fontSize: 28.sp,
                                            color: Colors.grey)),
                                    Text("电话",
                                        style: TextStyle(
                                            fontSize: 28.sp,
                                            color: Colors.black)),
                                    Radio(
                                      activeColor: Colors.deepOrangeAccent,

                                      ///此单选框绑定的值 必选参数
                                      value: 1,

                                      ///当前组中这选定的值  必选参数
                                      groupValue: connect_type,

                                      ///点击状态改变时的回调 必选参数
                                      onChanged: (v) {
                                        state(() {
                                          connect_type = v;
                                        });
                                      },
                                    ),
                                    Text("到店",
                                        style: TextStyle(
                                            fontSize: 28.sp,
                                            color: Colors.black)),
                                    Radio(
                                      activeColor: Colors.deepOrangeAccent,

                                      ///此单选框绑定的值 必选参数
                                      value: 2,

                                      ///当前组中这选定的值  必选参数
                                      groupValue: connect_type,

                                      ///点击状态改变时的回调 必选参数
                                      onChanged: (v) {
                                        state(() {
                                          connect_type = v;
                                        });
                                      },
                                    ),
                                  ],
                                ),
                                SingleChildScrollView(
                                    //设置水平方向排列
                                    scrollDirection: Axis.horizontal,
                                    child: Row(
                                      children: [
                                        Container(
                                          padding: EdgeInsets.only(
                                              left: 0.w, bottom: 10.h),
                                          child: Text("沟通状态: ",
                                              style: TextStyle(
                                                  fontSize: 14,
                                                  color: Colors.grey)),
                                        ),
                                        Padding(
                                          padding: EdgeInsets.only(
                                              left: 0.w, bottom: 10.h),
                                          child: Container(
                                              width: ScreenUtil().screenWidth *
                                                  0.6,
                                              child:
                                                  // child: DropdownButton<String>(
                                                  //   value: goalValue,
                                                  //   icon: Icon(Icons
                                                  //       .keyboard_arrow_down_outlined),
                                                  //   iconSize: 30.sp,
                                                  //   elevation: 4,
                                                  //   underline: Container(
                                                  //     height: 3.h,
                                                  //     color: Colors.redAccent,
                                                  //   ),
                                                  //   onChanged: (String newValue) {
                                                  //     state(() {
                                                  //       goalValue = newValue;
                                                  //       connectStatus =
                                                  //           getIndexOfList(
                                                  //               goals, newValue);
                                                  //        if (roleId==7 || roleId==9){
                                                  //          connectStatus =connectStatus + 20;
                                                  //        }
                                                  //     });
                                                  //   },
                                                  //   items: goals.map<
                                                  //           DropdownMenuItem<String>>(
                                                  //       (String value) {
                                                  //     return DropdownMenuItem<String>(
                                                  //       value: value,
                                                  //       child: Text(value,
                                                  //           maxLines: 1,
                                                  //           overflow:
                                                  //               TextOverflow.ellipsis,
                                                  //           style: TextStyle(
                                                  //               fontSize: 32.sp,
                                                  //               color: Colors.black)),
                                                  //     );
                                                  //   }).toList(),
                                                  // ),

                                                  MenuButton<String>(
                                                scrollPhysics:
                                                    AlwaysScrollableScrollPhysics(),
                                                child: normalChildButton(
                                                    goalValue),
                                                items: goals,
                                                itemBuilder: (String value) =>
                                                    Container(
                                                  height: 40,
                                                  alignment:
                                                      Alignment.centerLeft,
                                                  padding: const EdgeInsets
                                                          .symmetric(
                                                      vertical: 0.0,
                                                      horizontal: 16),
                                                  child: Text(value),
                                                ),
                                                toggledChild: Container(
                                                  child: normalChildButton(
                                                      goalValue),
                                                ),
                                                onItemSelected: (String value) {
                                                  state(() {
                                                    goalValue = value;
                                                    connectStatus =
                                                        getIndexOfList(
                                                            goals, value);
                                                    if (roleId == 7 ||
                                                        roleId == 9) {
                                                      connectStatus =
                                                          connectStatus + 20;
                                                    }
                                                  });
                                                },
                                                onMenuButtonToggle:
                                                    (bool isToggle) {
                                                  print(isToggle);
                                                },
                                              )),
                                        ),
                                      ],
                                    )),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    GestureDetector(
                                      onTap: () {
                                        MyPicker.showPicker(
                                            context: context,
                                            current: _date,
                                            mode: MyPickerMode.dateTime,
                                            squeeze: 1.45,
                                            magnification: 1.2,
                                            offAxisFraction: 0.2,
                                            onConfirm: (v) {
                                              //_change('yyyy-MM-dd HH:mm'),
                                              print(v);
                                              state(() {
                                                _date = v;
                                                time1 = v
                                                    .toString()
                                                    .substring(0, 19);
                                              });
                                            });
                                      },
                                      child: Row(
                                        children: [
                                          Text("沟通时间",
                                              style: TextStyle(
                                                  fontSize: 30.sp,
                                                  color: Colors.grey)),
                                          Icon(Icons
                                              .keyboard_arrow_down_outlined),
                                        ],
                                      ),
                                    ),
                                    GestureDetector(
                                      onTap: () {
                                        MyPicker.showPicker(
                                            context: context,
                                            current: _date1,
                                            squeeze: 1.45,
                                            magnification: 1.2,
                                            offAxisFraction: 0.2,
                                            mode: MyPickerMode.dateTime,
                                            onConfirm: (v) {
                                              //_change('yyyy-MM-dd HH:mm'),
                                              print(v);
                                              state(() {
                                                _date1 = v;
                                                time2 = v
                                                    .toString()
                                                    .substring(0, 19);
                                              });
                                            });
                                      },
                                      child: Row(
                                        children: [
                                          Text("下次沟通时间 ",
                                              style: TextStyle(
                                                  fontSize: 30.sp,
                                                  color: Colors.grey)),
                                          Icon(Icons
                                              .keyboard_arrow_down_outlined),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                                SizedBox(
                                  height: 10.w,
                                ),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    GestureDetector(
                                      onTap: () {},
                                      child: Container(
                                        child: Row(
                                          children: [
                                            Text(time1,
                                                style: TextStyle(
                                                    fontSize: 28.sp,
                                                    color: Colors.redAccent,
                                                    fontWeight:
                                                        FontWeight.w800)),
                                          ],
                                        ),
                                      ),
                                    ),
                                    GestureDetector(
                                      onTap: () {},
                                      child: Row(
                                        children: [
                                          Text(time2,
                                              style: TextStyle(
                                                  fontSize: 28.sp,
                                                  color: Colors.redAccent,
                                                  fontWeight: FontWeight.w800)),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                                SizedBox(
                                  height: 20.w,
                                ),
                                Container(
                                  width: 300.w,
                                  child: TextField(
                                    focusNode: _connectFieldNode,
                                    controller: _Controller,
                                    style: TextStyle(color: Colors.black),
                                    minLines: 7,
                                    maxLines: 7,
                                    cursorColor: Colors.green,
                                    cursorRadius: Radius.circular(3.w),
                                    cursorWidth: 5.w,
                                    showCursor: true,
                                    decoration: InputDecoration(
                                      contentPadding: EdgeInsets.all(10.w),
                                      hintText: "请输入...",
                                      border: OutlineInputBorder(),
                                    ),
                                    onChanged: (v) {},
                                  ),
                                ),
                                Padding(
                                  padding:
                                      EdgeInsets.only(top: 20.h, bottom: 5.h),
                                  child: RaisedButton(
                                    elevation: 0,
                                    shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(20))),
                                    color: Colors.lightBlue,
                                    onPressed: () {
                                      if (_Controller.text.isEmpty) {
                                        BotToast.showSimpleNotification(
                                            title: "请填写沟通内容");
                                        return;
                                      }
                                      if (time1 == "") {
                                        BotToast.showSimpleNotification(
                                            title: "请选择排约时间");
                                        return;
                                      }
                                      if (time2 == "") {
                                        BotToast.showSimpleNotification(
                                            title: "请选择排约时间");
                                        return;
                                      }

                                      if (detail != null) {
                                        // if (connectStatus == 12 ||
                                        //     connectStatus == 13) {
                                        //   Map<String, dynamic> photo = Map();
                                        //   photo['uuid'] = detail["uuid"];
                                        //   showToast(context, '操作成功', true);
                                        //   BlocProvider.of<DetailBloc>(context)
                                        //       .add(AddConnectEventFresh(
                                        //           detail,
                                        //           _Controller.text,
                                        //           connectStatus,
                                        //           time1,
                                        //           connect_type,
                                        //           time2));
                                        // } else {
                                        showToast(context, '操作成功', true);
                                        BlocProvider.of<DetailBloc>(context)
                                            .add(AddConnectEvent(
                                                detail,
                                                _Controller.text,
                                                connectStatus,
                                                time1,
                                                connect_type,
                                                time2));
                                        // }
                                      }

                                      goalValue = '1.新分未联系';
                                      _date = new DateTime.now();
                                      connect_type = 1;
                                      time1 = "";
                                      time2 = "";
                                      _date = new DateTime.now();
                                      connect_type = 1;
                                      var time1s = _date.toString();
                                      var time2s = _date
                                          .add(new Duration(days: 3))
                                          .toString();
                                      time1 = time1s.substring(0, 19);
                                      time2 = time2s.substring(0, 19);
                                      _Controller.clear();
                                      Navigator.of(context).pop(true);
                                    },
                                    child: Text("提交",
                                        style: TextStyle(
                                            color: Colors.white, fontSize: 18)),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 20.h,
                  ),
                ],
              ),
            );
          }));
  return result;
}
