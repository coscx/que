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
import 'package:flutter_geen/views/items/tag.dart';
import 'package:flutter_geen/app/router.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_geen/views/items/CustomsExpansionPanelList.dart';
import 'package:flutter_geen/views/pages/home/home_page.dart';
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
      child: ScrollConfiguration(
          behavior: DyBehaviorNull(),
          child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            BlocBuilder<DetailBloc, DetailState>(builder: _buildTitle),
            BlocBuilder<DetailBloc, DetailState>(builder: _buildDetail)
          ],
        ),
      )));

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
  int _position = 0;


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
               Padding(
                padding: EdgeInsets.only(left: 15.w, right: 5.w,bottom: 5.h),
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
          Container(
              margin: EdgeInsets.only(left: 15.w, right: 5.w,bottom: 0.h),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[

                    //CustomsExpansionPanelList()
                    //_item(context),
                    WidgetNodePanel(
                        codeFamily: 'Inconsolata',
                        text: "接待信息",
                        code: "",
                        show: Container(
                          width: 500,
                          // height: 300,
                          child:
                          Wrap(
                              alignment: WrapAlignment.start,
                              direction: Axis.horizontal,
                              spacing: 0,
                              runSpacing: 0,
                              children: <Widget>[
                                _item(context),
                                _item(context),



                              ]
                          ),

                        )
                    ),


                  ],
                ),


            ),



        ],
      );
    }
    return Container();
  }



  Widget _buildTitle(BuildContext context, DetailState state) {
    //print('build---${state.runtimeType}---');
    if (state is DetailWithData) {
      return header(state.userdetails);
      return WidgetDetailTitle(
        usertail: state.userdetails,

      );
    }
    return Container();
  }
  Widget _item(BuildContext context) {
    bool isDark = false;

    return  Container(
      padding:  EdgeInsets.only(
        top: 10.h,
        bottom: 0
      ),
      width: double.infinity,
      height: 80.h,
      child:  Material(
          color:  Colors.transparent ,
          child: InkWell(
            onTap: (){},
            child: Container(
                margin: EdgeInsets.only(left: 10.w, right: 20.w),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Row(
                      children: <Widget>[
                        Icon(
                          Icons.account_circle_outlined,
                          size: 18,
                          color: Colors.black54,
                        ),

                        Container(
                          margin: EdgeInsets.only(left: 15.w),
                          child: Text(
                            "姓名",
                            style: TextStyle(fontSize: 15.0, color: Colors.grey),
                          ),
                        ),
                        SizedBox(
                          width: ScreenUtil().setWidth(10),
                        ),
                        Visibility(
                            visible: true,
                            child: Text(
                              "用户已接待，有意愿继续服务",
                              style: TextStyle(
                                  fontSize: 12.0, color: Colors.black),
                            )),
                      ]),
                  //Visibility是控制子组件隐藏/可见的组件
                  Visibility(
                    visible: true,
                    child: Row(
                        children: <Widget>[
                          Container(
                            margin: EdgeInsets.only(right: 10.w),
                            child: Row(children: <Widget>[

                              SizedBox(
                                width: ScreenUtil().setWidth(10),
                              ),
                              Visibility(
                                  visible: true,
                                  child: Text(
                                    "2021-01-12 15:35:30",
                                    style: TextStyle(
                                        fontSize: 7.0, color: Colors.grey),
                                  )),



                              Visibility(
                                  visible: false,
                                  child: CircleAvatar(
                                    backgroundImage: AssetImage("rightImageUri"),
                                  ))
                            ]),
                          ),

                          Icon(
                            Icons.arrow_forward_ios_outlined,
                            size: 15,
                            color: Colors.black54,
                          )

                        ]),
                  )
                ],
              ),
            ),
          )),
    );
  }
  avatar(String url) {
    return Container(
      width: 60,
      height: 60,
      decoration: BoxDecoration(
        border: Border.all(
          width: 2,
          color: Colors.white,
        ),
        borderRadius: BorderRadius.all(Radius.circular(30)),
      ),
      child: CircleAvatar(
        child: ClipOval(
          child: Image.network(
            url,
            fit: BoxFit.cover,
            width: 60,
            height: 60,
          ),
        ),
        backgroundColor: Colors.white,
      ),
    );
  }

  header(Map<String,dynamic> user) {
    return Container(
      height: 120.h,
      margin: EdgeInsets.only(top: 8.h,bottom: 20.h,left: 8.w),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: <Widget>[
          Padding(
            padding: EdgeInsets.only(left: 10.w, right: 10.w),
            child: avatar("https://img.bosszhipin.com/beijin/mcs/useravatar/20171211/4d147d8bb3e2a3478e20b50ad614f4d02062e3aec7ce2519b427d24a3f300d68_s.jpg"),
          ),
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                 Container(
                 margin: EdgeInsets.fromLTRB(10.w, 10.h, 5.w, 0.h),
                 child:
                 Text(
                  user['user']['userName'],
                    style: TextStyle(
                      color: Colors.black,
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
                    ),
                  )),
                  Container(
                      color: Colors.black12,
                      padding: EdgeInsets.fromLTRB(5.w, 0.h, 5.w, 0.h),
                      margin: EdgeInsets.fromLTRB(5.w, 10.h, 5.w, 0.h),
                      alignment: Alignment.centerLeft,
                      height: 24.h,
                      child: Text(
                        user['user']['age'].toString(),
                        style: TextStyle(color: Colors.black, fontSize: 8),
                      ))
                ],
              ),
              Row(
                children: <Widget>[
                   Tag(
                      color: Colors.black12,
                      borderColor: Colors.black12,
                      borderWidth: 0,
                      margin: EdgeInsets.fromLTRB(10.w, 10.h, 5.w, 0.h),
                      height: 40.h,
                      text: Text(
                        user['user']['addressed'].toString(),
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 12,
                        ),
                      ),

                  )
                ],
              ),
            ],
          ),
        ],
      ),
    );
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
            margin: EdgeInsets.fromLTRB(13.w, 0.h, 0.w, 10.h),
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
                  margin: EdgeInsets.fromLTRB(2.w, 20.h, 2.w, 0.h),
                child: CachedNetworkImage(imageUrl: e['imagepath'],
                width: 160.w,
                height: 300.h,
                  ),
                )

              )



            ],

          ),

        ],

      ),
      padding:  EdgeInsets.all(4.w),
      decoration:const BoxDecoration(
      color: Colors.red,
      borderRadius: BorderRadius.all(Radius.circular(10)),
      ),
    ),

    Positioned(
        top: 0.h,
        right: 0.w,
        child:
        FeedbackWidget(
        onPressed: () {
            _deletePhoto(context,e);
        },
        child: const Icon(
            CupertinoIcons.delete_solid,
            color: Colors.white,
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
