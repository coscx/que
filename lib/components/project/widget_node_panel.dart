import 'package:flutter/material.dart';

import 'package:flutter_geen/app/res/toly_icon.dart';

import 'package:flutter_geen/components/permanent/circle.dart';
import 'package:flutter_geen/components/permanent/code/code_widget.dart';
import 'package:flutter_geen/components/permanent/panel.dart';

import 'package:toggle_rotate/toggle_rotate.dart';

import '../permanent/feedback_widget.dart';
import '../permanent/code/highlighter_style.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

/// 说明: 一个Widget的知识点对应的界面

class WidgetNodePanel extends StatefulWidget {
  final String text;
  final String subText;
  final String code;
  final Widget show;
  final HighlighterStyle codeStyle;
  final String codeFamily;
  final bool showMore;
  bool showControl;
  final void Function(String tag,bool value) callSetState;
  String name;
  WidgetNodePanel(
      {this.text,
      this.subText,
      this.code,
      this.show,
      this.codeStyle,
      this.codeFamily,
      this.showMore, this.showControl,this.callSetState,this.name
      });

  @override
  _WidgetNodePanelState createState() => _WidgetNodePanelState();
}

class _WidgetNodePanelState extends State<WidgetNodePanel> {
  CrossFadeState _crossFadeState = CrossFadeState.showFirst;

  bool get isFirst => _crossFadeState == CrossFadeState.showFirst;

  Color get themeColor => Theme.of(context).primaryColor;

@override
  void initState() {
    // TODO: implement initState
    super.initState();

  }
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          buildNodeTitle(),
          SizedBox(
            height: 2.h,
          ),
          //_buildCode(context),
          Padding(
            padding: const EdgeInsets.only(top: 0, bottom: 0),
            child:   Visibility(
                visible:widget.showControl,
                replacement:Text('data'),
                maintainState:true,
                child:Column(
                  children: [
                    widget.show,
                    widget.showMore ? Container(
                        margin: EdgeInsets.only(left: 10.w, right: 20.w,top: 10.h,bottom: 10.h),
                        child: Text("查看更多")
                    ):Container()
                  ],
                )
            ),
          ),

          //_buildNodeInfo(),
          Divider(),
        ],
      ),
    );
  }

  Widget buildNodeTitle() => GestureDetector(
    onTap: _toggleCodePanel,
      child:Row(
        children: <Widget>[
          Padding(
            padding:  EdgeInsets.symmetric(horizontal: 8.w),
            child: Circle(
              color: themeColor,
              radius: 5,
            ),
          ),
          Expanded(
            child: Text(
              '${widget.text}',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 30.sp),
            ),
          ),
          //_buildShareButton(),
          _buildCodeButton(widget.showControl)
        ],
      ) ,
  );

  Widget _buildNodeInfo() => Container(
        width: double.infinity,
        child: Panel(
            child: Text(
          '${widget.subText}',
          style: TextStyle(fontSize: 14.sp),
        )),
      );

  Widget _buildCodeButton(bool show ) => Padding(
        padding:  EdgeInsets.only(right: 18.w),
        child: Icon(
            TolyIcon.icon_code,
            color: themeColor,
          ),

      );

  Widget _buildShareButton() => FeedbackWidget(
        mode: FeedMode.fade,
        a: 0.4,
        onPressed: _doShare,
        child: Padding(
          padding: const EdgeInsets.only(
            right: 10,
          ),
          child: Icon(
            TolyIcon.icon_share,
            size: 20,
            color: themeColor,
          ),
        ),
      );

  Widget _buildCode(BuildContext context) => AnimatedCrossFade(
        firstCurve: Curves.easeInCirc,
        secondCurve: Curves.easeInToLinear,
        firstChild: Container(),
        secondChild: Container(
          width: MediaQuery.of(context).size.width,
          child: CodeWidget(
            fontFamily: widget.codeFamily,
            code: isFirst?'':widget.code,
            style: widget.codeStyle ??
                HighlighterStyle.fromColors(HighlighterStyle.lightColor),
          ),
        ),
        duration: Duration(milliseconds: 200),
        crossFadeState: _crossFadeState,
      );

  //执行分享
  _doShare() {
    //Share.share(widget.code);
  }

  // 折叠代码面板
  _toggleCodePanel() {
    setState(() {
      _crossFadeState =
          !isFirst ? CrossFadeState.showFirst : CrossFadeState.showSecond;
      widget.showControl =!widget.showControl;
      widget.callSetState(widget.name,widget.showControl);
    });
  }
}
