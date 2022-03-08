
import 'package:flutter/material.dart';
import 'package:flutter_geen/views/dialogs/ww_dialog.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

const colorH = Color(0xFFEEEEEE);
const colorWithCloseButton = Color(0xFFB2B4C6);

/// 中间和底部弹窗Widget
class TTBaseDialog extends StatefulWidget {

  /// 背景颜色 默认白色
  final Color bgColor;
  /// 是否有关闭按钮 默认没有
  final bool isShowCloseButton;
  /// 点击按钮是否需要关闭弹窗 默认为true
  final bool isNeedCloseDiaLog;
  /// 弹窗位置(中间、底部)
  final DiaLogLocation location;
  /// 是否是系统底部弹窗
  final bool isSystemBottomDialog;

  /// 自定义标题组件 优先级：customTitleWidget > title
  final Widget customTitleWidget;
  /// 标题
  final String title;
  /// 标题颜色 默认 0x121D34
  final Color titleColor;
  /// 标题字号 默认17
  final double titleFontSize;
  /// 标题字重 默认 500
  final FontWeight titleFontWeight;
  /// 标题区域布局 默认居中
  final TextAlign titleAlign;

  /// 自定义的content组件 优先级：customContentWidget > content
  final Widget customContentWidget;
  /// 内容
  final String content;
  /// 内容文字颜色 默认 0x121D34
  final Color contentColor;
  /// 有标题内容字号 默认13
  final double contentFontSize;
  /// 无标题内容字号 默认17
  final double notTitleContentFontSize;
  /// 内容字重 默认400
  final FontWeight contentFontWeight;
  /// 内容区域布局 默认居中
  final TextAlign contentAlign;

  /// 自定义按钮list 优先级：widgetButtons > buttons
  final List<Widget> customWidgetButtons;
  /// 按钮list
  final List<String> buttons;
  /// 取消按钮字体颜色 默认 0x999999
  final Color cancelButtonColor;
  /// 其他按钮字体颜色 默认蓝色0x2989F2
  final Color otherButtonColor;
  /// 取消按钮字体大小 默认17
  final double cancelButtonFontSize;
  /// 其他按钮字体大小 默认17
  final double otherButtonFontSize;
  /// 取消按钮字重 默认400
  final FontWeight cancelButtonFontWeight;
  /// 按钮字重  默认500
  final FontWeight otherButtonFontWeight;
  /// 按钮排列方式 默认横向排列
  final buttonArrangeType arrangeType;
  /// 点击返回index 0 1
  final Function(int index, BuildContext context) onTap;

  TTBaseDialog({
    this.bgColor,
    this.isShowCloseButton,
    this.isNeedCloseDiaLog,
    this.customTitleWidget,
    this.location,
    this.isSystemBottomDialog,
    this.title,
    this.titleColor,
    this.titleFontSize,
    this.titleFontWeight,
    this.titleAlign,
    this.customContentWidget,
    this.content,
    this.contentColor,
    this.contentFontSize,
    this.notTitleContentFontSize,
    this.contentAlign,
    this.contentFontWeight,
    this.customWidgetButtons,
    this.buttons,
    this.cancelButtonColor,
    this.otherButtonColor,
    this.cancelButtonFontSize,
    this.otherButtonFontSize,
    this.cancelButtonFontWeight,
    this.otherButtonFontWeight,
    this.arrangeType,
    this.onTap,
  });

  @override
  _TTBaseDialogState createState() => _TTBaseDialogState();
}

class _TTBaseDialogState extends State<TTBaseDialog> {
  @override
  Widget build(BuildContext context) {
    return (widget.location == DiaLogLocation.bottom) ? _createBaseBottomDialog() : _createBaseMiddleDiaLog();
  }

  /// Bottom弹窗
  Widget _createBaseBottomDialog() {
    bool emptyTitle =
    ((widget.title == null || widget.title.length == 0 ) && widget.customTitleWidget == null); // 是否有标题
    bool emptyContent =
    ((widget.content == null || widget.content.length == 0) && widget.customContentWidget == null); // 是否有内容
    return Material(
        color: Colors.transparent,
        child: Container(
          width: double.infinity,
          child: Container(
            margin: widget.isSystemBottomDialog ? EdgeInsets.only(left: 20.w,bottom: 10.h,right: 20.w) : EdgeInsets.all(0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  decoration: BoxDecoration(
                      color: widget.bgColor,
                      borderRadius: BorderRadius.circular(12.w)
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Container(
                          child: emptyTitle
                              ? Container()
                              : (widget.customTitleWidget != null)
                              ? widget.customTitleWidget
                              : Container(
                            child: Text(
                              widget.title,
                              style: TextStyle(color: widget.titleColor, fontSize: widget.titleFontSize, fontWeight: widget.titleFontWeight),
                            ),
                            margin: EdgeInsets.only(top: 20.h),
                          )
                      ),
                      Container(
                        child: emptyContent
                            ? Container()
                            : (widget.customContentWidget != null)
                            ? widget.customContentWidget
                            : Container(
                          child:  Text(
                            widget.content,
                            style: TextStyle(color: widget.contentColor, fontSize: widget.contentFontSize,fontWeight: widget.contentFontWeight),
                          ),
                          margin: EdgeInsets.all(25.w),
                        ),
                        // height: 45,
                        width: double.infinity,
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                            border: Border(
                              bottom: BorderSide(
                                color: colorH,
                                width: 2.w,
                              ),
                            )
                        ),
                      ),
                      (widget.customWidgetButtons != null)
                          ? _createCustomButtons(widget.arrangeType)
                          : _createDefaultButtons(widget.arrangeType,80.h)
                    ],
                  ),
                ),
                widget.isSystemBottomDialog ? SizedBox(height: 16.h) : SizedBox(),
                widget.isSystemBottomDialog
                    ? Container(
                  width: double.infinity,
                  child: defaultCustomButton(context,
                      text: '取消',
                      textFontSize: 30.sp,
                      buttonHeight: 90.h
                  ),
                  decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12.w)
                  ),
                )
                    : Container()
              ],
            ),
          ),
        )
    );
  }

  /// 中间弹窗相关方法
  Widget _createBaseMiddleDiaLog() {
    bool emptyTitle = ((widget.title == null || widget.title.length == 0) && widget.customTitleWidget == null); // 是否有标题
    bool emptyContent = ((widget.content == null || widget.content.length == 0) && widget.customContentWidget == null); // 是否有内容
    return Material(
      color: Colors.transparent,
      child: Center(
        child: ClipRRect(
          borderRadius: BorderRadius.circular(6.w),
          child: Container(
            color: widget.bgColor,
            width: (270),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                Padding(
                  padding: EdgeInsets.only(top: 20.h, left: 20.w, right: 20.w),
                  child: Stack(
                    children: [
                      Align(
                          alignment: Alignment.center,
                          child: emptyTitle
                              ? Container()
                              : widget.customTitleWidget != null
                              ? widget.customTitleWidget
                              : Container(
                            width: double.infinity,
                            child: Text(
                              widget.title,
                              textAlign: widget.titleAlign,
                              style: TextStyle(
                                  color: widget.titleColor,
                                  fontSize: widget.titleFontSize,
                                  fontWeight: widget.titleFontWeight),
                            ),
                          )
                      ),
                      Align(
                          alignment: Alignment.centerLeft,
                          child: (widget.isShowCloseButton == false)
                              ? Container()
                              : InkWell(
                            child: Icon(
                                Icons.close,
                                color: colorWithCloseButton),
                            onTap: () {
                              Navigator.pop(context);
                            },
                          )
                      )
                    ],
                  ),
                ),
                SizedBox(height: emptyTitle ? 20.h : 10.h),
                emptyContent
                    ? Container()
                    : _getContentWidget(emptyTitle, emptyContent),
                SizedBox(height: 20.h),
                Container(
                  decoration: BoxDecoration(
                    border: Border(
                      bottom: BorderSide(
                        color: colorH,
                        width: 1.h,
                      ),
                    ),
                  ),
                ),
                // 创建按钮
                (widget.customWidgetButtons != null)
                    ? _createCustomButtons(widget.arrangeType)
                    :_createDefaultButtons(widget.arrangeType, 44.h)
              ],
            ),
          ),
        ),
      ),
    );
  }

  /// 创建默认buttons组
  Widget _createDefaultButtons(buttonArrangeType type, double buttonHeight) {
    return (widget.buttons == null || widget.buttons.length == 0)
        ? Container()
        : (type == buttonArrangeType.column)
        ? _createDefaultColumnButtons(buttonHeight)
        : _createDefaultRowButtons(buttonHeight);
  }

  /// 创建默认列的buttons
  _createDefaultColumnButtons(double buttonHeight) {
    return Container(
      child: Column(
        children: widget.buttons.map((res) {
          int index = widget.buttons.indexOf(res);
          return GestureDetector(
            child: Container(
                width: double.infinity,
                child: defaultCustomButton(context,
                    textColor: widget.otherButtonColor,
                    textFontSize: widget.otherButtonFontSize,
                    fontWeight: widget.otherButtonFontWeight,
                    needCloseDialog: widget.isNeedCloseDiaLog,
                    text: res,
                    buttonHeight: buttonHeight,
                    onTap: (){
                      if(widget.onTap != null) {
                        widget.onTap(index, context);
                      }
                    }),
                decoration: (index == widget.buttons.length - 1)
                    ? BoxDecoration()
                    : BoxDecoration(
                  border: Border(
                    bottom: BorderSide(
                      color: colorH,
                      width: 2.h,
                    ),
                  ),
                )

            ),
          );
        }).toList(),
      ),
    );
  }

  /// 创建默认行的buttons
  _createDefaultRowButtons(double buttonHeight) {
    return Container(
      child: Row(
        children: widget.buttons.map((res) {
          int index = widget.buttons.indexOf(res);
          return Expanded(
            flex: 1,
            child: Container(
                child: defaultCustomButton(
                    context,
                    needCloseDialog: widget.isNeedCloseDiaLog,
                    text: res,
                    textColor: (index == 0) ? widget.cancelButtonColor : widget.otherButtonColor,
                    textFontSize: (index == 0) ? widget.cancelButtonFontSize : widget.otherButtonFontSize,
                    fontWeight: (index == 0) ? widget.cancelButtonFontWeight : widget.otherButtonFontWeight,
                    buttonHeight: buttonHeight,
                    onTap: (){
                      if(widget.onTap != null) {
                        widget.onTap(index, context);
                      }
                    }),
                decoration: (index == widget.buttons.length - 1)
                    ? BoxDecoration()
                    : BoxDecoration(
                  border: Border(
                    right: BorderSide(
                      color: colorH,
                      width: 2.h,
                    ),
                  ),
                )
            ),
          );
        }).toList(),
      ),
    );
  }

  /// 创建自定义buttons
  Widget _createCustomButtons(buttonArrangeType type) {
    return (widget.customWidgetButtons == null || widget.customWidgetButtons.length == 0)
        ? Container()
        : (type == buttonArrangeType.column)
        ? _createCustomColumnButtons()
        : _createCustomRowButtons();
  }

  /// 创建自定义列的buttons
  _createCustomColumnButtons() {
    return Container(
      child: Column(
        children: widget.customWidgetButtons.map((buttonWidget) {
          int index = widget.customWidgetButtons.indexOf(buttonWidget);
          return Container(
              width: double.infinity,
              child: buttonWidget,
              decoration: (index == widget.customWidgetButtons.length - 1)
                  ? BoxDecoration()
                  : BoxDecoration(
                border: Border(
                  bottom: BorderSide(
                    color: colorH,
                    width: 1.h,
                  ),
                ),
              )
          );
        }).toList(),
      ),
    );
  }

  /// 创建自定义行的buttons
  _createCustomRowButtons() {
    return Container(
      child: Row(
        children: widget.customWidgetButtons.map((buttonWidget) {
          int index = widget.customWidgetButtons.indexOf(buttonWidget);
          return Expanded(
              flex: 1,
              child: Container(
                  child: buttonWidget,
                  decoration: (index == widget.customWidgetButtons.length - 1)
                      ? BoxDecoration()
                      : BoxDecoration(
                    border: Border(
                      right: BorderSide(
                        color: colorH,
                        width: 1.h,
                      ),
                    ),
                  )
              )
          );
        }).toList(),
      ),
    );
  }

  /// 获取弹窗content Widget
  _getContentWidget(emptyTitle, emptyContent) {
    return Container(
        width: double.infinity, // 跟外部容器等宽
        margin: EdgeInsets.only(left: 20.w, right: 20.w),
        child: (widget.customContentWidget != null)
            ? widget.customContentWidget
            : Text(
          widget.content,
          textAlign: widget.contentAlign,
          style: TextStyle(
              color: widget.contentColor,
              fontSize: emptyTitle
                  ? widget.notTitleContentFontSize
                  : widget.contentFontSize,
              fontWeight: widget.contentFontWeight),
        )
    );
  }
}