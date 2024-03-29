import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
class EmptyPage extends StatelessWidget {


  @override
  Widget build(BuildContext context) {
    return Center(child: Container(
      alignment: FractionalOffset.center,
      child:  Container(
        padding:  EdgeInsets.only(top: 200.h),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
             Icon(Icons.event_busy, color: Colors.orangeAccent, size: 120.0),
             Container(
              padding:  EdgeInsets.only(top: 16.0),
              child:  Text(
                "啥也没搜到，(≡ _ ≡)/~┴┴",
                style:  TextStyle(
                  fontSize: 20,
                  color: Colors.orangeAccent,
                ),
              ),
            )
          ],
        ),
      ),
    ),);
  }
}
