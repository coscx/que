import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_geen/views/dialogs/ww_middle_bottom_dialog_widget.dart';
import 'package:flutter_geen/views/dialogs/ww_top_dialog_item_data.dart';
import 'package:flutter_geen/views/dialogs/ww_top_dialog_widget.dart';


const colorWithHex12 = Color(0xFF121D34);
const colorWithHex9 = Color(0xFF999999);
const colorWithQ = Color(0xFF2989F2);
const colorWithDialogLine = Color.fromRGBO(255, 255, 255, 0.2);
const colorWithDialogBg = Color.fromRGBO(0, 0, 0, 0.4);

class WWDialog {
  // 中间弹窗
  static Future<T> showMiddleDialog<T>(@required BuildContext context,{
    Color bgColor: Colors.white,
    bool isShowCloseButton: false,
    bool isNeedCloseDiaLog: true,
    DiaLogLocation location: DiaLogLocation.middle,
    bool isSystemBottomDialog: false,
    Widget customTitleWidget,
    String title,
    Color titleColor: colorWithHex12,
    double titleFontSize: 17.0,
    FontWeight titleFontWeight: FontWeight.w500,
    TextAlign titleAlign: TextAlign.center,
    Widget customContentWidget,
    String content,
    Color contentColor: colorWithHex12,
    double contentFontSize: 13.0,
    double notTitleContentFontSize: 17.0,
    FontWeight contentFontWeight: FontWeight.w400,
    TextAlign contentAlign: TextAlign.center,
    List<Widget> customWidgetButtons,
    List<String> buttons,
    Color cancelButtonColor: colorWithHex9,
    Color otherButtonColor: colorWithQ,
    double cancelButtonFontSize: 17.0,
    double otherButtonFontSize: 17.0,
    FontWeight cancelButtonFontWeight: FontWeight.w400,
    FontWeight otherButtonFontWeight: FontWeight.w500,
    buttonArrangeType arrangeType: buttonArrangeType.row,
    Function(int index, BuildContext context) onTap
  }) {
    return showDialog(
        context: context,
        builder: (context) {
          return TTBaseDialog(
              bgColor: bgColor,
              isShowCloseButton: isShowCloseButton,
              isNeedCloseDiaLog: isNeedCloseDiaLog,
              customTitleWidget: customTitleWidget,
              location: location,
              isSystemBottomDialog: isSystemBottomDialog,
              title: title,
              titleColor: titleColor,
              titleFontSize: titleFontSize,
              titleFontWeight: titleFontWeight,
              titleAlign: titleAlign,
              customContentWidget: customContentWidget,
              content:content,
              contentColor:contentColor,
              contentFontSize:contentFontSize,
              notTitleContentFontSize:notTitleContentFontSize,
              contentFontWeight:contentFontWeight,
              contentAlign:contentAlign,
              customWidgetButtons: customWidgetButtons,
              buttons:buttons,
              cancelButtonColor:cancelButtonColor,
              otherButtonColor:otherButtonColor,
              cancelButtonFontSize:cancelButtonFontSize,
              otherButtonFontSize:otherButtonFontSize,
              cancelButtonFontWeight:cancelButtonFontWeight,
              otherButtonFontWeight:otherButtonFontWeight,
              arrangeType:arrangeType,
              onTap:onTap
          );
        });
  }

  // 底部弹窗
  static Future<T> showBottomDialog<T>(@required BuildContext context,{
    Color bgColor: Colors.white,
    bool isShowCloseButton: false,
    bool isNeedCloseDiaLog: true,
    DiaLogLocation location: DiaLogLocation.bottom,
    bool isSystemBottomDialog: true,
    Widget customTitleWidget,
    String title,
    Color titleColor: colorWithHex12,
    double titleFontSize: 17.0,
    FontWeight titleFontWeight: FontWeight.w500,
    TextAlign titleAlign: TextAlign.center,
    Widget customContentWidget,
    String content,
    Color contentColor: colorWithHex12,
    double contentFontSize: 13.0,
    double notTitleContentFontSize: 17.0,
    FontWeight contentFontWeight: FontWeight.w400,
    TextAlign contentAlign: TextAlign.center,
    List<Widget> customWidgetButtons,
    List<String> buttons,
    Color cancelButtonColor: colorWithHex9,
    Color otherButtonColor: colorWithQ,
    double cancelButtonFontSize: 17.0,
    double otherButtonFontSize: 17.0,
    FontWeight cancelButtonFontWeight: FontWeight.w400,
    FontWeight otherButtonFontWeight: FontWeight.w500,
    buttonArrangeType arrangeType: buttonArrangeType.row,
    Function(int index, BuildContext context) onTap
  }) {
    return showCupertinoModalPopup(
        context: context,
        builder: (context) {
          return TTBaseDialog(
              bgColor: bgColor,
              isShowCloseButton: isShowCloseButton,
              isNeedCloseDiaLog: isNeedCloseDiaLog,
              customTitleWidget: customTitleWidget,
              location: location,
              isSystemBottomDialog: isSystemBottomDialog,
              title: title,
              titleColor: titleColor,
              titleFontSize: titleFontSize,
              titleFontWeight: titleFontWeight,
              titleAlign: titleAlign,
              customContentWidget: customContentWidget,
              content:content,
              contentColor:contentColor,
              contentFontSize:contentFontSize,
              notTitleContentFontSize:notTitleContentFontSize,
              contentFontWeight:contentFontWeight,
              contentAlign:contentAlign,
              customWidgetButtons: customWidgetButtons,
              buttons:buttons,
              cancelButtonColor:cancelButtonColor,
              otherButtonColor:otherButtonColor,
              cancelButtonFontSize:cancelButtonFontSize,
              otherButtonFontSize:otherButtonFontSize,
              cancelButtonFontWeight:cancelButtonFontWeight,
              otherButtonFontWeight:otherButtonFontWeight,
              arrangeType:arrangeType,
              onTap:onTap
          );
        });
  }

  // 顶部弹窗
  static Future<T> showTopDialog<T>(@required BuildContext context,{
    Color barrierColor: colorWithDialogBg,
    Color bgColor: Colors.white,
    Widget customContentWidget,
    Color contentColor: colorWithHex12,
    double contentFontSize: 13.0,
    FontWeight contentFontWeight: FontWeight.w400,
    TextAlign contentAlign: TextAlign.center,
    double rightMargin: 10,
    double topMargin: 30,
    double dialogWidth: 100,
    DiaLogTriangleType triangleType: DiaLogTriangleType.none,
    double maxDialogHeight: 264,
    double baseContentHeight: 44,
    Color lineColor: colorWithDialogLine,
    List<TopDialogItemData>listDatasource,
    List<Widget> customListDatasource,
    Function(TopDialogItemData item) onTap
  }) {
    return showDialog(
        context: context,
        barrierColor: barrierColor,
        builder: (context) {
          return TTTopDialog(
              bgColor: bgColor,
              customContentWidget: customContentWidget,
              contentColor: contentColor,
              contentFontSize: contentFontSize,
              contentFontWeight: contentFontWeight,
              contentAlign: contentAlign,
              rightMargin: rightMargin,
              topMargin: topMargin,
              dialogWidth: dialogWidth,
              triangleType: triangleType,
              maxDialogHeight: maxDialogHeight,
              baseContentHeight: baseContentHeight,
              lineColor: lineColor,
              listDatasource: listDatasource,
              customListDatasource: customListDatasource,
              onTap: onTap
          );
        });
  }
}

/// 默认自定义按钮（中间、底部弹窗自定义按钮）
Widget defaultCustomButton(context,{
  text: '确认',
  textColor: colorWithQ,
  textFontSize: 17.0,
  fontWeight:FontWeight.w500,
  needCloseDialog: true,
  buttonHeight:44.0,
  onTap
}) => FlatButton(
  onPressed: (){
    if(needCloseDialog) {
      Navigator.pop(context);
    }
    if(onTap != null) {
      onTap();
    }
  },
  child:Text(text,style: TextStyle(fontSize: textFontSize, color: textColor, fontWeight: fontWeight)),
  highlightColor: Colors.transparent,
  splashColor: Colors.transparent,
  height: buttonHeight,
);

/// 默认自定义按钮(顶部弹窗)
Widget defaultContentButton(context,text,{
  textColor: colorWithQ,
  textFontSize: 15.0,
  fontWeight:FontWeight.w400,
  buttonHeight:44.0,
  onTap
}) => FlatButton(
  onPressed: (){
    if(onTap != null) {
      Navigator.pop(context);
      onTap();
    }
  },
  child:Text(text,style: TextStyle(fontSize: textFontSize, color: textColor, fontWeight: fontWeight)),
  highlightColor: Colors.transparent,
  splashColor: Colors.transparent,
  height: buttonHeight,
);

enum DiaLogLocation {
  middle,
  bottom
}

enum buttonArrangeType {
  row,
  column
}

enum DiaLogTriangleType {
  none,
  left,
  middle,
  right
}
