import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
typedef ChangeCallback = void Function(String value);
class PopupMenu extends StatefulWidget {
  final Widget user;
  final ChangeCallback callback;
  const PopupMenu({Key key,@required this.user,@required this.callback}) : super(key: key);
  @override
  _PopupMenuState createState() => _PopupMenuState();
}

class _PopupMenuState extends State<PopupMenu> {
  Color bgColor = Colors.white;

  GlobalKey anchorKey = GlobalKey();

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      child: Container(
        key: anchorKey,
        child: widget.user,
      ),
      onLongPressStart: (detail) {
        bgColor = Colors.grey;
        setState(() {});
        _showMenu(context, detail,widget.callback);
      },
    );
  }

  PopupMenuButton _popMenu() {
    return PopupMenuButton(
      itemBuilder: (context) => _getPopupMenu(context),
      onSelected:(value){
        print('onSelected'+value.toString());
        _selectValueChange(value);
      },
      onCanceled: () {
        print('onCanceled');
        bgColor = Colors.white;
        setState(() {});
      },
    );
  }

  _selectValueChange(String value) {
    setState(() {});
  }

  _showMenu(BuildContext context, LongPressStartDetails detail,ChangeCallback callback) async{
    RenderBox renderBox = anchorKey.currentContext.findRenderObject();
    var offset = renderBox.localToGlobal(Offset(0.0, 30.h));
    final RelativeRect position = RelativeRect.fromLTRB(
        detail.globalPosition.dx, //取点击位置坐弹出x坐标
        offset.dy, //取text高度做弹出y坐标（这样弹出就不会遮挡文本）
        detail.globalPosition.dx,
        offset.dy);
    var pop = _popMenu();
   var  newValue = await  showMenu(
      context: context,
      items: pop.itemBuilder(context),
      position: position, //弹出框位置
    );
    if (!mounted) return null;
    if (newValue == null) {
      if (pop.onCanceled != null){
        pop.onCanceled();
        return null;
      }
    }
    if (pop.onSelected != null) {
      callback(newValue);
      pop.onSelected(newValue);
    }
  }

  _getPopupMenu(BuildContext context) {
    return [
      PopupMenuItem(
        value: '删除聊天',
        child: Text('删除聊天'),
      ),

    ];
  }
}
