import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
class OriginAuthority extends StatefulWidget {
  final int isSelected;

  OriginAuthority({Key key, @required this.isSelected,@required this.authorityChanged})
      : assert(authorityChanged != null),
        super(key: key);

  @override
  __OriginAuthorityState createState() => __OriginAuthorityState();

  // 文章的心得发生变化的联动
  final ValueChanged<int> authorityChanged;
}

class __OriginAuthorityState extends State<OriginAuthority> {

  // 权限
  List<String> _authorities = ['全部', '只看 男','只看 女'];
  int selected = 0;
  @override
  void initState() {
    selected = widget.isSelected;
  }
  ValueChanged<int> onSelectedChanged(int _index) {
    widget.authorityChanged(_index);
    setState(() {
      selected = _index;
    });
  }

  // 迭代器生成list
  Iterable<Widget> get _inputSelects sync* {
    for (int i = 0; i < _authorities.length; i++) {
      yield InputSelect(
        index: i,
        choice: _authorities[i],
        parent: this, widget: null,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(left: 40.w,top: 0.w,bottom: 0,right: 10.w),
      // decoration: BoxDecoration(
      //   border: Border(
      //     top: BorderSide(color: Colors.grey, width: 0.1),
      //   ),
      // ),
      child: Row(
        //mainAxisAlignment: MainAxisAlignment.start,
        //crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Container(
            //color: Colors.orange,
            alignment: Alignment.centerLeft,
            child: Text(
              "性别",
              style: TextStyle(
                color: Color(0xff182748),
                fontSize: 26.sp,
              ),
            ),
          ),
          Container(
            padding: EdgeInsets.only(left: 100.w,top: 0.w,bottom: 0,right: 0.w),
            child: Wrap(
              // 使用迭代器的方法生成list
              children: _inputSelects.toList(),
            ),
          ),
          // Container(
          //   alignment: Alignment.centerLeft,
          //   padding: const EdgeInsets.symmetric(vertical: 4.0),
          //   child: Text(
          //     "©版权摘要说明: ${_authorities_detail[selected] == null ? "" : _authorities_detail[selected]}",
          //     style: TextStyle(
          //       color: Colors.grey[500],
          //       fontSize: 10.0,
          //       fontWeight: FontWeight.normal,
          //     ),
          //   ),
          // ),
        ],
      ),
    );
  }
}
// 实现 ChoiceInput 
// index 为标识ChoiceInput 
// parent 为父控件
class InputSelect extends StatelessWidget {
  const InputSelect(
      {@required this.index,
        @required this.widget,
        @required this.parent,
        @required this.choice})
      : super();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(left: 10.w,top: 0.w,bottom: 0,right: 10.w),
      child: ChoiceChip(
          label: Text(choice),
          //未选定的时候背景
          selectedColor: Colors.lightBlue,
          backgroundColor: Colors.grey.withAlpha(33),
          //被禁用得时候背景
          //disabledColor: ,
          labelStyle: TextStyle( fontSize: 30.sp,color: parent.selected == index? Colors.white:Colors.black),
          labelPadding: EdgeInsets.only(left: 16.w, right: 16.w),
          materialTapTargetSize: MaterialTapTargetSize.padded,
          onSelected: (bool value) {
            parent.onSelectedChanged(index);
          },
          selected: parent.selected == index),
    );
  }

  final int index;
  final widget;
  final parent;
  final String choice;
}
