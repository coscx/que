import 'package:flutter/cupertino.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
///底部弹框

class BottomCustomAlterWidget extends StatefulWidget {

  final confirmCallback;

  final title;

  final option1;

  final option2;

  const BottomCustomAlterWidget(this.confirmCallback, this.title, this.option1,
      this.option2);

  @override
  _BottomCustomAlterWidgetState createState() => _BottomCustomAlterWidgetState();



}

class _BottomCustomAlterWidgetState extends State<BottomCustomAlterWidget> {

final controller = TextEditingController();

String inputValue = "";

@override
Widget build(BuildContext context) {
  return CupertinoActionSheet(


    title: Text(

      widget.title,

      style: TextStyle(fontWeight: FontWeight.w100, fontSize: 30.sp),

    ),

    actions: [

      CupertinoActionSheetAction(

          onPressed: () {
            Navigator.pop(context);

            widget.confirmCallback(widget.option1);
          },

          child: Text(widget.option1 ,style: TextStyle(fontWeight: FontWeight.bold, fontSize: 30.sp))),

      CupertinoActionSheetAction(

          onPressed: () {
            Navigator.pop(context);

            widget.confirmCallback(widget.option2);
          },

          child: Text(widget.option2 ,style: TextStyle(fontWeight: FontWeight.bold, fontSize: 30.sp))),

    ],

    cancelButton: CupertinoActionSheetAction(

      onPressed: () {
        Navigator.pop(context);
      },

      child: Text('取消', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 30.sp)),

    ),

  );
}

}

