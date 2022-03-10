import 'package:bot_toast/bot_toast.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fluttertoast/fluttertoast.dart';
showToast(BuildContext ctx, String msg, bool collected) {
  if (msg ==null){
    msg="ti";
  }
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
    backgroundColor: Colors.white,
    leading: (cancel) => Container(
        child: IconButton(
          icon: Icon(Icons.mood_sharp, color: Colors.green),
          onPressed: cancel,
        )),
    title: (text)=>Container(
      child: Text(msg,style: new TextStyle(
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
      //BotToast.showText(text: 'Tap toast');
    },); //弹出简单通知Toast
}
showToastBottom(BuildContext ctx, String msg, bool collected) {
  if (msg ==null){
    msg="ti";
  }
  Fluttertoast.showToast(
      msg: msg,
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.CENTER,  // 消息框弹出的位置
      backgroundColor: Colors.grey,
      textColor: Colors.white,
      fontSize: 30.sp
  );
}
showToastRed(BuildContext ctx, String msg, bool collected) {
  if (msg ==null){
    msg="ti";
  }
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
    backgroundColor: Colors.white,
    leading: (cancel) => Container(
        child: IconButton(
          icon: Icon(Icons.error, color: Colors.redAccent),
          onPressed: cancel,
        )),
    title: (text)=>Container(
      child: Text(msg,style: new TextStyle(
          color: Colors.black, fontSize: 30.sp)),
    ),
    duration: const Duration(seconds: 5),

    trailing: (cancel) => Container(
      child: IconButton(
        icon: Icon(Icons.cancel),
        onPressed: cancel,
      ),
    ),
    onTap: () {
      //BotToast.showText(text: 'Tap toast');
    },); //弹出简单通知Toast
}