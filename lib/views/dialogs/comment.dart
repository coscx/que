/*
 * @discripe: 登录弹窗弹窗
 */
import 'package:fbutton/fbutton.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
class CommentDialog extends Dialog  {
  CommentDialog({Key key}) : super(key: key);
  final _Controller = TextEditingController(text: '');
  @override
  Widget build(BuildContext context) {
    return Material(
      type: MaterialType.transparency,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Container(
            width: 400.w,
            height: 1000.h,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.all(Radius.circular(6)),
            ),
            child: OverflowBox(
              alignment: Alignment.bottomCenter,
              maxHeight: 1000.h,
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
                      child: Image.asset('assets/images/more.png',
                        width: 30.w,
                      ),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(
                      left: 30.w,
                      right: 30.w,
                      top: 230.h,
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: <Widget>[
                        SizedBox(
                          height: 50.h,
                        ),
                        Container(
                          width:300.w,
                          child: TextField(
                            controller: _Controller,
                            style: TextStyle(color: Colors.blue),
                            minLines: 5,
                            maxLines: 5,
                            cursorColor: Colors.green,
                            cursorRadius: Radius.circular(3.w),
                            cursorWidth: 5.w,
                            showCursor: true,
                            decoration: InputDecoration(
                              contentPadding: EdgeInsets.all(10.w),
                              hintText: "请输入...",
                              border: OutlineInputBorder(),
                            ),
                            onChanged: (v){},
                          )
                          ,
                        ),
                        Padding(
                          padding: EdgeInsets.only(top: 20.h, bottom: 15.h),
                          child: RaisedButton(
                            elevation: 0,
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.all(Radius.circular(20))),
                            color: Colors.lightBlue,
                            onPressed: (){
                              if (_Controller.text.isEmpty){
                                return;
                              }
                              Navigator.of(context).pop();
                            },
                            child: Text("提交",
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
