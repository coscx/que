import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_geen/blocs/bloc_exp.dart';
import 'package:flutter_geen/storage/dao/widget_dao.dart';

import 'package:flutter_screenutil/flutter_screenutil.dart';

class AppSearchBar extends StatefulWidget {
  @override
  _AppSearchBarState createState() => _AppSearchBarState();
}

class _AppSearchBarState extends State<AppSearchBar> {
  TextEditingController _controller = TextEditingController(); //文本控制器
  bool showClear = true;

  @override
  Widget build(BuildContext context) => Container(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Container(
                width: ScreenUtil().screenWidth * 0.65,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.all(Radius.circular(100.w)),
                    color: Color(0xFFf8f8f8)),
                child: Container(
                  child: TextField(
                    textAlign: TextAlign.start,
                    autofocus: false,
                    //自动聚焦，闪游标
                    controller: _controller,
                    maxLines: 1,
                    decoration: InputDecoration(
                      contentPadding: EdgeInsets.only(top: 22.h),
                      hintText: '手机号、用户名、id...',
                      hintStyle: TextStyle(
                        fontSize: 28.sp,
                      ),
                      suffixIcon: showClear
                          ? Container(
                              padding: EdgeInsets.only(top: 0),
                              child: IconButton(
                                icon:
                                    Icon(Icons.clear, color: Color(0xFF444444)),
                                onPressed: () {
                                  // 清空搜索内容
                                  _controller.clear();
                                },
                              ),
                            )
                          : Container(),
                      prefixIcon: Icon(
                        Icons.search,
                        color: Color(0xFF444444),
                      ),
                      border: InputBorder.none,
                    ),
                    onChanged: (str) => {if (str.length > 0) {} else {}},

                    onSubmitted: (str) {
                      //提交后
                      BlocProvider.of<SearchBloc>(context).add(EventTextChanged(
                          args: SearchArgs(name: str, stars: [1, 2, 3, 4, 5])));
                      BlocProvider.of<GlobalBloc>(context)
                          .add(EventSearchPhotoPage(0));
                      FocusScope.of(context).requestFocus(FocusNode()); //收起键盘
//            _controller.clear();
                    },
                  ),
                )),
            buildSubmit()
          ],
        ),
      );

  Widget buildSubmit() {
    return Container(
      height: 70.h,
      width: 180.w,
      padding: EdgeInsets.only(top: 0.h, bottom: 0.h, left: 10.h, right: 0.h),
      child: CupertinoButton(
        child: Text("确定",style: TextStyle(
          fontSize: 28.sp,color: Colors.black
        ),),
        pressedOpacity: 0.1,
        padding: EdgeInsets.zero,
        color: Color(0xFFf8f8f8),
        borderRadius: BorderRadius.all(Radius.circular(35.w)),
        onPressed: () {
          //提交后
          BlocProvider.of<SearchBloc>(context).add(EventTextChanged(
              args: SearchArgs(name: _controller.text, stars: [1, 2, 3, 4, 5])));
          BlocProvider.of<GlobalBloc>(context)
              .add(EventSearchPhotoPage(0));
          FocusScope.of(context).requestFocus(FocusNode()); //收起键盘
        },
      ),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
}
