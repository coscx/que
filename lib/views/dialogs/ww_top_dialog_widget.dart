
import 'package:flutter/material.dart';
import 'package:flutter_geen/views/dialogs/ww_dialog.dart';
import 'package:flutter_geen/views/dialogs/ww_top_dialog_item_data.dart';


var cardShadowColor = Color(0xFFdfdfdf);

class TTTopDialog extends StatefulWidget {
  /// 背景颜色 默认白色
  final Color bgColor;
  /// 自定义的content组件 优先级：customContentWidget > content
  final Widget customContentWidget;
  /// 内容文字颜色 默认 0x121D34
  final Color contentColor;
  /// 内容字号 默认13
  final double contentFontSize;
  /// 内容字重 默认400
  final FontWeight contentFontWeight;
  /// 内容区域布局 默认居中
  final TextAlign contentAlign;
  /// 弹窗右边距离屏幕右边的值 默认10
  final double rightMargin;
  /// 弹窗顶部距离屏幕上边的值 默认30
  final double topMargin;
  /// 弹窗宽度 默认 100
  final double dialogWidth;
  /// 顶部弹窗三角类型 默认无三角
  final DiaLogTriangleType triangleType;
  /// 顶部弹窗最大高度 默认44*6 = 264
  final double maxDialogHeight;
  /// 顶部弹窗ListTitle高度 默认44
  final double baseContentHeight;
  /// 顶部弹窗分割线颜色 默认白色 不透明度0.2
  final Color lineColor;
  /// 顶部弹窗数据源（回调可以统一处理的数据源）
  final List<TopDialogItemData> listDatasource;
  /// 顶部弹窗数据源（回调需要单独处理的数据源）
  final List<Widget> customListDatasource;
  /// 回调(传当前点击的map)
  final Function(TopDialogItemData item) onTap;
  TTTopDialog({
    this.bgColor,
    this.customContentWidget,
    this.contentColor,
    this.contentFontSize,
    this.contentAlign,
    this.contentFontWeight,
    this.rightMargin,
    this.topMargin,
    this.dialogWidth,
    this.triangleType,
    this.maxDialogHeight,
    this.baseContentHeight,
    this.lineColor,
    this.listDatasource,
    this.customListDatasource,
    this.onTap
  });

  @override
  _TTTopDialogState createState() => _TTTopDialogState();
}

class _TTTopDialogState extends State<TTTopDialog> {
  @override
  Widget build(BuildContext context) {
    return _createBaseTopDialog();
  }

  Widget _createBaseTopDialog() {
    if(widget.customListDatasource == null && widget.listDatasource == null && widget.customContentWidget == null) {
      Navigator.pop(context);
      print("请检查你的参数是否正确");
      return Container();
    }

    return Material(
        color: Colors.transparent,
        child: CustomContainer(
            decoration: BoxDecoration(
                color: Colors.transparent
            ),
            onTap: (){
              Navigator.pop(context);
            },
            child: widget.customContentWidget != null
                ? _getCustomContentWidget()
                : _getDefaultContentWidget()
        )
    );
  }

  /// 获取自定义弹窗内容的widget
  Widget _getCustomContentWidget() {
    double screenW = MediaQuery.of(context).size.width;
    return Padding(
      padding: EdgeInsets.only(left:screenW - widget.rightMargin - widget.dialogWidth,right: widget.rightMargin,top: widget.topMargin),
      child: Stack(
        alignment: Alignment.topRight,
        children: [
          Container(
            // color: Colors.greenAccent,
            width: widget.dialogWidth,
            child: Column(
              children: [
                widget.triangleType == DiaLogTriangleType.none
                    ? Container()
                    : Container(
                  // color: Colors.orange,
                  height: 10,
                ),
                Container(
                  decoration: BoxDecoration(
                      color: widget.bgColor,
                      borderRadius: BorderRadius.circular(6.0),
                      boxShadow: widget.triangleType == DiaLogTriangleType.none
                          ? [
                        BoxShadow(
                            color: cardShadowColor.withOpacity(0.6),
                            blurRadius: 10, //阴影模糊程度
                            spreadRadius: 7.5 //阴影扩散程度
                        )
                      ]:[]
                  ),
                  child: Padding(
                    padding: EdgeInsets.all(15),
                    child: widget.customContentWidget,
                  ),
                )
              ],
            ),
          ),
          widget.triangleType == DiaLogTriangleType.none
              ? Container()
              : Container(
            width: double.infinity, // PS:这个很重要 不设置的话三角形没有size 无法准确画三角形
            child: CustomPaint(
                painter:TrianglePainter(widget.bgColor,widget.triangleType)
            ),
          )
        ],
      ),
    );
  }

  /// 获取弹窗中间的内容Widget
  Widget _getDefaultContentWidget() {
    bool isCustomContent = widget.customListDatasource != null ? true : false;
    double screenW = MediaQuery.of(context).size.width;

    double dialogRealHeight = isCustomContent ?
    widget.customListDatasource.length * (widget.baseContentHeight + 1) :
    widget.listDatasource.length * (widget.baseContentHeight + 1);

    double dialogHeight = dialogRealHeight > widget.maxDialogHeight ? widget.maxDialogHeight : dialogRealHeight;
    ScrollPhysics listViewScrollPhysics = (dialogRealHeight > widget.maxDialogHeight) ? const ScrollPhysics() : const NeverScrollableScrollPhysics();

    return Padding(
      padding: EdgeInsets.only(left:screenW - widget.rightMargin - widget.dialogWidth,right: widget.rightMargin,top: widget.topMargin),
      child: Stack(
        alignment: Alignment.topRight,
        children: [
          Container(
            // color: Colors.orange,
            width: widget.dialogWidth,
            // 10:三角形的高度
            height: widget.triangleType == DiaLogTriangleType.none ? dialogHeight : dialogHeight + 10,
            child: Column(
              children: [
                widget.triangleType == DiaLogTriangleType.none
                    ? Container()
                    : Container(
                  // color: Colors.red,
                  height: 10,
                ),
                Container(
                  decoration: BoxDecoration(
                      color: widget.bgColor,
                      borderRadius: BorderRadius.circular(6.0),
                      boxShadow: widget.triangleType == DiaLogTriangleType.none
                          ? [
                        BoxShadow(
                            color: cardShadowColor.withOpacity(0.6),
                            blurRadius: 10, //阴影模糊程度
                            spreadRadius: 7.5 //阴影扩散程度
                        )
                      ]:[]
                  ),
                  height: dialogHeight,
                  child: Scrollbar(
                    // Scrollbar显示滚动条
                    child: ListView.builder(
                      physics: listViewScrollPhysics,
                      itemCount: isCustomContent ? widget.customListDatasource.length : widget.listDatasource.length,
                      itemBuilder: this._getBaseDialogContent,
                    ),
                  ),
                )
              ],
            ),
          ),
          widget.triangleType == DiaLogTriangleType.none
              ? Container()
              : Container(
            width: double.infinity, // PS:这个很重要 不设置的话三角形没有size 无法准确画三角形
            child: CustomPaint(
                painter:TrianglePainter(widget.bgColor,widget.triangleType)
            ),
          ),
        ],
      ),
    );
  }

  /// 获取弹窗默认cell的内容widget
  Widget _getBaseDialogContent(context,index) {
    bool isCustomContent = widget.customListDatasource != null ? true : false;
    return Column(
      children: [
        CustomContainer(
          height: widget.baseContentHeight,
          onTap: (){
            if(widget.onTap != null) {
              widget.onTap(widget.listDatasource[index]);
            }
            Navigator.pop(context);
          },
          child: Center(
            child: isCustomContent
                ? widget.customListDatasource[index]
                : Container(
              padding: EdgeInsets.only(left: 10,right: 10),
              width: double.infinity,
              child: Text(
                widget.listDatasource[index].name,
                textAlign: widget.contentAlign,
                style: TextStyle(
                  color: widget.contentColor,
                  fontSize: widget.contentFontSize,
                  fontWeight: widget.contentFontWeight,
                ),
              ),
            ),
          ),
        ),
        (index == (isCustomContent ? widget.customListDatasource.length - 1 : widget.listDatasource.length - 1))
            ? Container()
            : Divider(
            height: 1,
            indent: widget.triangleType == DiaLogTriangleType.none ? 0 : 10,
            endIndent:widget.triangleType == DiaLogTriangleType.none ? 0 : 10,
            color: widget.lineColor
        )
      ],
    );
  }
}

/// 自定义的Container
class CustomContainer extends Container {
  final Widget child;
  final double width;
  final double height;
  final Decoration decoration;
  final Function onTap;  // 添加点击事件

  CustomContainer({
    Key key,
    this.child,
    this.width,
    this.height,
    this.decoration,
    this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Widget widget = Container(
      width: this.width,
      height: this.height,
      decoration: decoration,
      child: InkWell( // 添加点击事件
        child: child,
        onTap: onTap,
        // 去除水波纹效果
        splashColor:Colors.transparent,
        highlightColor: Colors.transparent,
      ),
    );
    return widget;
  }
}

/// 三角形
class TrianglePainter extends CustomPainter {

  Color color; // 填充颜色
  DiaLogTriangleType type; // 三角位置
  Paint _paint; // 画笔
  Path _path; // 绘制路径
  double angle; // 角度

  TrianglePainter(this.color,this.type) {
    _paint = Paint()
      ..strokeWidth = 1.0 //线宽
      ..color = color
      ..isAntiAlias = true;
    _path = Path();
  }

  @override
  void paint(Canvas canvas, Size size) {
    // TODO: implement paint
    final baseX = size.width;
    final double TriangleW = 16.0;
    final double TriangleH = 10.0;
    // 起点
    if(this.type == DiaLogTriangleType.left) {
      // 左三角
      _path.moveTo(20, TriangleH);
      _path.lineTo(20 + TriangleW, TriangleH);
      _path.lineTo(20 + TriangleW/2 + 1, 0);
      _path.lineTo(20 + TriangleW/2 - 1, 0);
    }else if(this.type == DiaLogTriangleType.middle) {
      // 中间三角
      _path.moveTo((baseX - TriangleW)/2, TriangleH);
      _path.lineTo((baseX - TriangleW)/2 + TriangleW, TriangleH);
      _path.lineTo(baseX/2 + 1, 0);
      _path.lineTo(baseX/2 - 1, 0);
    }else {
      // 右三角
      _path.moveTo(baseX - 20 - TriangleW, TriangleH);
      _path.lineTo(baseX - 20, TriangleH);
      _path.lineTo(baseX - 20 - TriangleW/2 + 1, 0);
      _path.lineTo(baseX - 20 - TriangleW/2 - 1, 0);
    }
    canvas.drawPath(_path, _paint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    // TODO: implement shouldRepaint
    return false;
  }
}