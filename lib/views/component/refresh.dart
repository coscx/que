// 下拉刷新头部、底部组件
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

class DYrefreshHeader extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return WaterDropHeader(
      waterDropColor: Colors.blue,
      refresh: SizedBox(
        width: 25.0,
        height: 25.0,
        child: CircularProgressIndicator(
          strokeWidth: 2.0,
          valueColor: AlwaysStoppedAnimation<Color>(Colors.blue),
        ),
      ),
      complete: Container(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Icon(
              Icons.insert_emoticon,
              color: Colors.blue,
            ),
            Container(
              width: 15.0,
            ),
            Text(
              '更新好啦~',
              style: TextStyle(color: Colors.blue),
            )
          ],
        ),
      ),
      idleIcon: Icon(
        Icons.favorite,
        size: 14.0,
        color: Colors.white,
      ),
    );
  }
}

class DYrefreshFooter extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ClassicFooter(
      textStyle: TextStyle(color: Colors.blue),
      loadingText: '我正在努力...',
      failedText: '加载失败了~',
      idleText: '上拉加载更多~',
      canLoadingText: '释放加载更多~',
      noDataText: '没有更多啦~',
      failedIcon: Icon(Icons.insert_emoticon, color: Colors.blue),
      canLoadingIcon: Icon(Icons.insert_emoticon, color: Colors.blue),
      idleIcon: Icon(Icons.insert_emoticon, color: Colors.blue),
      loadingIcon: SizedBox(
        width: 25.0,
        height: 25.0,
        child: CircularProgressIndicator(
          strokeWidth: 2.0,
          valueColor: AlwaysStoppedAnimation<Color>(Colors.blue),
        ),
      ),
    );
  }
}