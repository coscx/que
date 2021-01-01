import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_geen/components/imageview/image_preview_page.dart';
import 'package:flutter_geen/components/imageview/image_preview_view.dart';
import 'package:flutter_geen/views/dialogs/comment.dart';
import 'package:flutter_geen/views/dialogs/delete_category_dialog.dart';
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


  WidgetDetailPage();

  @override
  _WidgetDetailPageState createState() => _WidgetDetailPageState();
}

class _WidgetDetailPageState extends State<WidgetDetailPage> {
  String memberId ;
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Theme(
        data: ThemeData(
        appBarTheme: AppBarTheme.of(context).copyWith(
      brightness: Brightness.light,
    ),
    ),
    child:Scaffold(
      endDrawer: CategoryEndDrawer(),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0, //去掉Appbar底部阴影
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: Text("用户详情",
            style:TextStyle(
              fontFamily: "Quicksand",
              fontWeight: FontWeight.w900,
              fontStyle: FontStyle.italic,
              fontSize: 22.0,
              decoration: TextDecoration.none,
              color: Colors.black,
            )
        ),
        actions: <Widget>[
          _buildToHome(),
          _buildCollectButton(context),
        ],
      ),
      body: Builder(builder: _buildContent),
    ));
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
            child: Icon(Icons.home,
            color: Colors.black,),
          ),
          onTap: () => Navigator.of(ctx).pop()));

  Widget _buildCollectButton( BuildContext context) {
    //监听 CollectBloc 伺机弹出toast
    return BlocListener<DetailBloc, DetailState>(
        listener: (ctx, st) {
          if (st is DetailWithData){
            Map<String,dynamic> user=st.props.elementAt(0);
            memberId= user['user']['memberId'].toString();
          }

         // bool collected = st.widgets.contains(model);
         // String msg = collected ? "收藏【${model.name}】组件成功!" : "已取消【${model.name}】组件收藏!";
         // _showToast(ctx, msg, collected);
        },
        child: FeedbackWidget(

          onPressed: () {
            //BlocProvider.of<TimeBloc>(context).add(EventGetTimeLine(memberId??"12221"));
            //Navigator.pushNamed(context, UnitRouter.time_line, arguments: memberId);
            _comment(context);
          } ,
          child: BlocBuilder<CollectBloc, CollectState>(
              builder: (_, s) => Padding(
                    padding: const EdgeInsets.only(right: 20.0),
                    child: Icon(
                          TolyIcon.icon_star_ok,
                      color: Colors.black,
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

      return true;

  }

  Widget _buildDetail(BuildContext context, DetailState state) {
    //print('build---${state.runtimeType}---');
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


        ],
      );
    }
    return Container();
  }
  Widget _buildTitle(BuildContext context, DetailState state) {
    //print('build---${state.runtimeType}---');
    if (state is DetailWithData) {
      return WidgetDetailTitle(
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
          Stack(
          children: <Widget>[
          Container(
          child: Stack(
          children: <Widget>[

            Column(
              children:<Widget> [
              GestureDetector(
               onTap: () {
                 ImagePreview.preview(
                     context,
                     images: List.generate(1, (index) {
                   return ImageOptions(
                     url: e['imagepath'],
                     tag: e['imagepath'],
                   );
                 }),
                 );
               }
               ,
                child: Container(
                child: CachedNetworkImage(imageUrl: e['imagepath'],
                width: 80,
                height: 150,
                  ),
                )

              )



            ],

          ),

        ],

      ),
      padding: const EdgeInsets.all(2),
      decoration:const BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.all(Radius.circular(10)),
      ),
    ),

    Positioned(
        top: 5,
        right: 5,
        child:
        FeedbackWidget(
        onPressed: () {
            _deletePhoto(context,e);
        },
        child: const Icon(
            CupertinoIcons.delete_solid,
            color: Colors.red,
        ),
        )
        ),
      ]
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

_comment(BuildContext context) {
  showDialog(
      context: context,
      builder: (ctx) => CommentDialog()

  );
}


_deletePhoto(BuildContext context,Map<String,dynamic> img) {
  showDialog(
      context: context,
      builder: (ctx) => Dialog(
        elevation: 5,
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(10))),
        child: Container(
          width: 50,
          child: DeleteCategoryDialog(
            title: '删除图片',
            content: '是否确定继续执行?',
            onSubmit: () {
              //BlocProvider.of<HomeBloc>(context).add(EventDelImg(img,1));
              Navigator.of(context).pop();
            },
          ),
        ),
      ));
}
class WidgetDetailTitle extends StatelessWidget {
  final Map<String,dynamic> usertail;
  WidgetDetailTitle({this.usertail});

  @override
  Widget build(BuildContext context) {
    return Container(
        child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Row(
          children: <Widget>[
            _buildLeft(usertail),
            _buildRight(usertail),
          ],
        ),
        Divider(),
      ],
    ));
  }

  final List<int> colors = Cons.tabColors;

  Widget _buildLeft(Map<String,dynamic> usertail) => Expanded(
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

  Widget _buildRight(Map<String,dynamic> usertail) => Column(
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
                      child: Image(image: FadeInImage.assetNetwork(
                        placeholder:'assets/images/ic_launcher.png',
                        image:usertail['user']['img'],
                      ).image))),
            ),
          ),
          StarScore(
            score: 0,
            star: Star(size: 15, fillColor: Colors.blue),
          )
        ],
      );
}
