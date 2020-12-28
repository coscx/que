import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_star/flutter_star.dart';
import 'package:flutter_geen/app/res/cons.dart';
import 'package:flutter_geen/app/res/toly_icon.dart';
import 'package:flutter_geen/app/utils/Toast.dart';
import 'package:flutter_geen/blocs/bloc_exp.dart';
import 'package:flutter_geen/components/permanent/feedback_widget.dart';
import 'package:flutter_geen/components/permanent/panel.dart';
import 'package:flutter_geen/components/project/widget_node_panel.dart';
import 'package:flutter_geen/model/node_model.dart';
import 'package:flutter_geen/model/widget_model.dart';
import 'package:flutter_geen/views/pages/widget_detail/category_end_drawer.dart';
import 'package:flutter_geen/app/router.dart';
class WidgetDetailPage extends StatefulWidget {
  final WidgetModel model;

  WidgetDetailPage({this.model});

  @override
  _WidgetDetailPageState createState() => _WidgetDetailPageState();
}

class _WidgetDetailPageState extends State<WidgetDetailPage> {
  List<WidgetModel> _modelStack = [];
  String memberId ;
  @override
  void initState() {
    _modelStack.add(widget.model);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      endDrawer: CategoryEndDrawer(widget: _modelStack.last),
      appBar: AppBar(
        title: Text("用户详情"),
        actions: <Widget>[
          _buildToHome(),
          _buildCollectButton(_modelStack.last, context),
        ],
      ),
      body: Builder(builder: _buildContent),
    );
  }

  Widget _buildContent(BuildContext context) => WillPopScope(
      onWillPop: () => _whenPop(context),
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            BlocBuilder<DetailBloc, DetailState>(builder: _buildTitle),
            BlocBuilder<DetailBloc, DetailState>(builder: _buildDetail)
          ],
        ),
      ));

  Widget _buildToHome() => Builder(
      builder: (ctx) => GestureDetector(
          onLongPress: () => Scaffold.of(ctx).openEndDrawer(),
          child: Padding(
            padding: const EdgeInsets.all(15.0),
            child: Icon(Icons.home),
          ),
          onTap: () => Navigator.of(ctx).pop()));

  Widget _buildCollectButton(WidgetModel model, BuildContext context) {
    //监听 CollectBloc 伺机弹出toast
    return BlocListener<DetailBloc, DetailState>(
        listener: (ctx, st) {
          if (st is DetailWithData){
            Map<String,dynamic> user=st.props.elementAt(3);
            memberId= user['user']['memberId'].toString();
          }

         // bool collected = st.widgets.contains(model);
         // String msg = collected ? "收藏【${model.name}】组件成功!" : "已取消【${model.name}】组件收藏!";
         // _showToast(ctx, msg, collected);
        },
        child: FeedbackWidget(

          onPressed: () {
            BlocProvider.of<TimeBloc>(context).add(EventGetTimeLine(memberId??"12221"));
            Navigator.pushNamed(context, UnitRouter.time_line, arguments: memberId);
          } ,
          child: BlocBuilder<CollectBloc, CollectState>(
              builder: (_, s) => Padding(
                    padding: const EdgeInsets.only(right: 20.0),
                    child: Icon(
                      s.widgets.contains(model)
                          ? TolyIcon.icon_star_ok
                          : TolyIcon.icon_star_add,
                      size: 25,
                    ),
                  )),
        ));
  }

  _showToast(BuildContext ctx, String msg, bool collected) {
    Toasts.toast(
      ctx,
      msg,
      duration: Duration(milliseconds: collected ? 1500 : 600),
      action: collected
          ? SnackBarAction(
              textColor: Colors.white,
              label: '收藏夹管理',
              onPressed: () => Scaffold.of(ctx).openEndDrawer())
          : null,
    );
  }

  final List<int> colors = Cons.tabColors;



  Future<bool> _whenPop(BuildContext context) async {
    if (Scaffold.of(context).isEndDrawerOpen) return true;

    _modelStack.removeLast();
    if (_modelStack.length > 0) {
      setState(() {
        Map<String,dynamic> photo;
        BlocProvider.of<DetailBloc>(context).add(FetchWidgetDetail(_modelStack.last,photo));
      });
      return false;
    } else {
      return true;
    }
  }

  Widget _buildDetail(BuildContext context, DetailState state) {
    print('build---${state.runtimeType}---');
    if (state is DetailWithData) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Row(
            children: <Widget>[
              const Padding(
                padding: EdgeInsets.only(left: 15, right: 5),
                child: Icon(
                  Icons.photo,
                  color: Colors.blue,
                ),
              ),
              const Text(
                '用户图片',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
              ),
            ],
          ),
          _buildLinkTo(
            context,
            state.userdetails,
          ),
          Divider(),
          //_buildNodes(state.nodes, state.widgetModel.name)
          WidgetNodePanel(
            codeFamily: 'Inconsolata',
            text: "滑动次数 (39次 A:39)",
            code: "待完善",
            show: Container(),
          ),
          WidgetNodePanel(
            codeFamily: 'Inconsolata',
            text: "滑动过他的 (39人 A:39)",
            code: "待完善",
            show: Container(),
          ),
          WidgetNodePanel(
            codeFamily: 'Inconsolata',
            text: "配对人数 (39人 A:39)",
            code: "待完善",
            show: Container(),
          ),
          WidgetNodePanel(
            codeFamily: 'Inconsolata',
            text: "TA喜欢的 (39人 A:39)",
            code: "待完善",
            show: Container(),
          ),
          WidgetNodePanel(
            codeFamily: 'Inconsolata',
            text: "喜欢TA的 (39人 A:39)",
            code: "待完善",
            show: Container(),
          ),
          WidgetNodePanel(
            codeFamily: 'Inconsolata',
            text: "AI照片 (39张 A:39)",
            code: "待完善",
            show: Container(),
          )
          ,
          WidgetNodePanel(
            codeFamily: 'Inconsolata',
            text: "被投诉记录 (39次 A:39)",
            code: "待完善",
            show: Container(),
          )
          ,
          WidgetNodePanel(
            codeFamily: 'Inconsolata',
            text: "解除配对 (39次 A:39)",
            code: "待完善",
            show: Container(),
          )
          ,
          WidgetNodePanel(
            codeFamily: 'Inconsolata',
            text: "TA的定位",
            code: "待完善",
            show: Container(),
          )
          ,
          WidgetNodePanel(
            codeFamily: 'Inconsolata',
            text: "订单记录",
            code: "待完善",
            show: Container(),
          )
          ,

        ],
      );
    }
    return Container();
  }
  Widget _buildTitle(BuildContext context, DetailState state) {
    print('build---${state.runtimeType}---');
    if (state is DetailWithData) {
      return WidgetDetailTitle(
        model: _modelStack.last,
        usertail: state.userdetails,

      );
    }
    return Container();
  }
  Widget _buildLinkTo(BuildContext context, Map<String,dynamic> userdetail) {

    List<dynamic> imgList =userdetail['images'];
    List<Widget> list = [];
    imgList.map((e) => {

      list.add( Column(
      children:<Widget> [
        Container(
          margin: EdgeInsets.all(10),
          width: 110,
          height: 200,
          child: Image(
            image: FadeInImage.assetNetwork(
              placeholder:'assets/images/ic_launcher.png',
              image:e['imagepath'],
            ).image,
          ),

        )

      ],

    ))

    }


    ).toList();


    return Wrap(
      children: [
        ...list
      ],
    );
  }
}

class WidgetDetailTitle extends StatelessWidget {
  final WidgetModel model;
  final Map<String,dynamic> usertail;
  WidgetDetailTitle({this.model,this.usertail});

  @override
  Widget build(BuildContext context) {
    return Container(
        child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Row(
          children: <Widget>[
            _buildLeft(model,usertail),
            _buildRight(model,usertail),
          ],
        ),
        Divider(),
      ],
    ));
  }

  final List<int> colors = Cons.tabColors;

  Widget _buildLeft(WidgetModel model,Map<String,dynamic> usertail) => Expanded(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.only(top: 20.0, left: 20),
              child: Text(
                "用户名："  + usertail['user']['userName'],
                style: TextStyle(
                    fontSize: 20,
                    color: Color(0xff1EBBFD),
                    fontWeight: FontWeight.bold),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Panel(child: Text(
                   "性别："  + (usertail['user']['sex'].toString()=="1"?"男":"女")+
                   " 年龄："  + usertail['user']['age'].toString()+
                   " 手机号："  + usertail['user']['tel'].toString()+
                   " 颜值："  + usertail['user']['facescore'].toString()
              )),
            )
          ],
        ),
      );

  Widget _buildRight(WidgetModel model,Map<String,dynamic> usertail) => Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Container(
            height: 100,
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Hero(
                  tag: "hero_widget_image_${usertail['user']['memberId'].toString()}",
                  child: ClipRRect(
                      borderRadius: BorderRadius.all(Radius.circular(8)),
                      child: model.image == null
                          ? Image.asset('assets/images/caver.webp')
                          : Image(image: FadeInImage.assetNetwork(
                        placeholder:'assets/images/ic_launcher.png',
                        image:usertail['user']['img'],
                      ).image))),
            ),
          ),
          StarScore(
            score: model.lever,
            star: Star(size: 15, fillColor: Colors.blue),
          )
        ],
      );
}
