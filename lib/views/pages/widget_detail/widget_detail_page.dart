import 'dart:async';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flui/flui.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_geen/components/imageview/image_preview_page.dart';
import 'package:flutter_geen/components/imageview/image_preview_view.dart';
import 'package:flutter_geen/views/dialogs/comment.dart';
import 'package:flutter_geen/views/dialogs/delete_category_dialog.dart';
import 'package:flutter_geen/views/pages/utils/object_util.dart';
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
import 'package:flutter_geen/views/pages/utils/loading.dart';
import 'package:multi_image_picker/multi_image_picker.dart';
import 'package:flutter_geen/app/api/issues_api.dart';
import 'dart:typed_data';
import 'package:dio/dio.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:flutter_geen/views/pages/utils/dialog_util.dart';
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
          onTap: () async {
                List<Asset> images = List<Asset>();
                List<Asset> resultList = List<Asset>();
                String error = 'No Error Dectected';
                //Navigator.of(ctx).pop();
                try {
                  resultList = await MultiImagePicker.pickImages(
                    // 选择图片的最大数量
                    maxImages: 1,
                    // 是否支持拍照
                    enableCamera: true,
                    materialOptions: MaterialOptions(
                      // 显示所有照片，值为 false 时显示相册
                        startInAllView: true,
                        allViewTitle: '所有照片',
                        actionBarColor: '#2196F3',
                        textOnNothingSelected: '没有选择照片'
                    ),
                  );
                } on Exception catch (e) {
                  e.toString();
                }
                if (!mounted) return;
                images = (resultList == null) ? [] : resultList;
                // 上传照片时一张一张上传
                for(int i = 0; i < images.length; i++) {
                   // 获取 ByteData
                   ByteData byteData = await images[i].getByteData();
                   try {
                      var resultConnectList= await IssuesApi.uploadPhoto("1",byteData);
                      // print(resultConnectList['data']);

                     var result= await IssuesApi.editCustomer("","1",resultConnectList['data']);
                     if(result['code']==200){
                       _showToast(ctx,result['message'],true);
                     }else{
                       _showToast(ctx,result['message'],true);
                     }
                   } on DioError catch(e){
                     var dd=e.response.data;
                     _showToast(ctx,dd['message'],true);
                   }



                }
              }

          ));

  Widget _buildCollectButton( BuildContext context) {
    //监听 CollectBloc 伺机弹出toast
    return BlocListener<DetailBloc, DetailState>(
        listener: (ctx, st) {
          if (st is DetailWithData){
            //Map<String,dynamic> user=st.props.elementAt(0);
            //memberId= user['user']['memberId'].toString();
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
      duration: Duration(milliseconds:  3000 ),
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
  List<Widget> _listViewConnectList(List<dynamic>connectList ){
    return connectList.map((e) =>
    _item(context,e['username'],e['connect_time'],e['connect_message'],e['subscribe_time'],e['connect_status'].toString(),e['connect_type'].toString())
    ).toList();
  }
  Widget _buildDetail(BuildContext context, DetailState state) {
    //print('build---${state.runtimeType}---');
    if (state is DetailWithData) {
      var info = state.userdetails['info'];
      List<dynamic> connectList = state.connectList['data'];
      List<Widget> list = _listViewConnectList(connectList);
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Container(
            margin: EdgeInsets.only(left: 15.w, right: 5.w,bottom: 0.h),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[

                //CustomsExpansionPanelList()
                //_item(context),
                WidgetNodePanel(
                    codeFamily: 'Inconsolata',
                    text: "基础资料",
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
                            _item_detail(context,Colors.black,Icons.format_list_numbered,"编号",info['code'].toString(),false),
                            _item_detail(context,Colors.black,Icons.backpack_outlined,"姓名",info['name'].toString(),true),
                            _item_detail(context,Colors.black,Icons.support_agent,"性别",info['gender']==1?"男生":"女生",true),
                            _item_detail(context,Colors.black,Icons.contact_page_outlined,"年龄",info['age']==0?"-":info['age'].toString()+"岁",false),
                            _item_detail(context,Colors.black,Icons.broken_image_outlined,"生日",info['birthday'].toString()+"("+info['chinese_zodiac']+"-"+info['zodiac']+")",true),
                            _item_detail(context,Colors.red,Icons.settings_backup_restore_outlined,"八字",info['bazi'].toString(),false),
                            _item_detail(context,Colors.orange,Icons.whatshot,"五行",info['wuxing'].toString(),false),
                            _item_detail(context,Colors.black,Icons.local_activity_outlined,"籍贯",info['native_place'].toString(),true),
                            _item_detail(context,Colors.black,Icons.house_outlined,"居住",info['location_place'].toString(),true),
                            _item_detail(context,Colors.black,Icons.point_of_sale,"销售",info['sale_user'].toString(),false),
                            _item_detail(context,Colors.black,Icons.gamepad_outlined,"民族",info['nation']==1?"汉族":"其他",true),
                            _item_detail(context,Colors.black,Icons.height,"身高",info['height']==0?"-":info['height'].toString(),true),
                            _item_detail(context,Colors.black,Icons.line_weight,"体重",info['weight']==0?"-":info['weight'].toString(),true),
                            _item_detail(context,Colors.black,Icons.design_services_outlined,"服务",info['serve_user'].toString(),false),
                            _item_detail(context,Colors.black,Icons.integration_instructions_outlined,"兴趣",info['interest'].toString(),true),
                            _item_detail(context,Colors.black,Icons.blur_on_outlined,"血型",info['blood_type']==0?"-":info['blood_type'].toString(),true),
                            _item_detail(context,Colors.black,Icons.developer_mode,"择偶",info['demands'].toString(),true),
                            _item_detail(context,Colors.black,Icons.bookmarks_outlined,"备注",info['remark'].toString(),true),

                          ]
                      ),

                    )
                ),


              ],
            ),


          ),

          Container(
            margin: EdgeInsets.only(left: 15.w, right: 5.w,bottom: 0.h),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[

                //CustomsExpansionPanelList()
                //_item(context),
                WidgetNodePanel(
                    codeFamily: 'Inconsolata',
                    text: "学历工作及资产",
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
                            _item_detail_gradute(context,Colors.redAccent,Icons.menu_book,"个人学历",info['education']==0?"-":info['education'].toString(),false),
                            _item_detail_gradute(context,Colors.black,Icons.school,"毕业院校",info['school'].toString()==""?"-":info['school'].toString(),true),
                            _item_detail_gradute(context,Colors.black,Icons.tab,"所学专业",info['major']==""?"-":info['major'].toString(),true),
                            _item_detail_gradute(context,Colors.black,Icons.reduce_capacity,"企业类型",info['work']==0?"-":info['work'].toString()+"",false),
                            _item_detail_gradute(context,Colors.black,Icons.location_city,"所属行业",info['work_job']==""?"-":info['work_job'].toString(),true),
                            _item_detail_gradute(context,Colors.black,Icons.description_outlined,"职位描述",info['work_industry']==""?"-":info['work_industry'].toString(),false),
                            _item_detail_gradute(context,Colors.black,Icons.more_outlined,"加班情况",info['work_overtime']==""?"-":info['work_overtime'].toString(),false),
                            _item_detail_gradute(context,Colors.redAccent,Icons.monetization_on_outlined,"收入情况",info['income']==0?"-":info['income'].toString(),true),
                            _item_detail_gradute(context,Colors.redAccent,Icons.house_outlined,"是否有房",info['has_house']==0?"-":info['has_house'].toString(),true),
                            _item_detail_gradute(context,Colors.black,Icons.copyright_rounded,"房贷情况",info['loan_record']==0?"-":info['loan_record'].toString(),false),
                            _item_detail_gradute(context,Colors.black,Icons.car_rental,"是否有车",info['has_car']==0?"-":info['has_car'].toString(),true),
                            _item_detail_gradute(context,Colors.black,Icons.wb_auto_outlined,"车辆档次",info['car_type']==0?"-":info['car_type'].toString(),true),

                          ]
                      ),

                    )
                ),


              ],
            ),


          ),

          Container(
            margin: EdgeInsets.only(left: 15.w, right: 5.w,bottom: 0.h),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[

                //CustomsExpansionPanelList()
                //_item(context),
                WidgetNodePanel(
                    codeFamily: 'Inconsolata',
                    text: "婚姻及父母家庭",
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
                            _item_detail_gradute(context,Colors.redAccent,Icons.wc,"婚姻状态",info['marriage']==0?"-":info['marriage'].toString(),true),
                            _item_detail_gradute(context,Colors.black,Icons.child_care,"子女信息",info['has_child']==0?"-":info['has_child'].toString(),true),
                            _item_detail_gradute(context,Colors.black,Icons.mark_chat_read_outlined,"子女备注",info['child_remark']==""?"-":info['child_remark'].toString(),true),
                            _item_detail_gradute(context,Colors.black,Icons.looks_one_outlined,"独生子女",info['only_child']==0?"-":info['only_child'].toString()+"",true),
                            _item_detail_gradute(context,Colors.black,Icons.watch_later_outlined,"父母状况",info['parents']==0?"-":info['parents'].toString(),true),
                            _item_detail_gradute(context,Colors.black,Icons.attribution_rounded,"父亲职业",info['father_work']==""?"-":info['father_work'].toString(),true),
                            _item_detail_gradute(context,Colors.black,Icons.sports_motorsports_outlined,"母亲职业",info['mother_work']==""?"-":info['mother_work'].toString(),true),
                            _item_detail_gradute(context,Colors.redAccent,Icons.monetization_on,"父母收入",info['parents_income']==""?"-":info['parents_income'].toString(),true),
                            _item_detail_gradute(context,Colors.redAccent,Icons.nine_k,"父母社保",info['parents_insurance']==0?"-":info['parents_insurance'].toString(),true),

                          ]
                      ),

                    )
                ),


              ],
            ),


          ),
          Container(
            margin: EdgeInsets.only(left: 15.w, right: 5.w,bottom: 0.h),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[

                //CustomsExpansionPanelList()
                //_item(context),
                WidgetNodePanel(
                    codeFamily: 'Inconsolata',
                    text: "用户画像相关",
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
                            _item_detail_gradute(context,Colors.redAccent,Icons.fastfood,"宗教信仰",info['faith']==0?"-":info['faith'].toString(),true),
                            _item_detail_gradute(context,Colors.black,Icons.smoking_rooms,"是否吸烟",info['smoke']==0?"-":info['smoke'].toString(),true),
                            _item_detail_gradute(context,Colors.black,Icons.wine_bar,"是否喝酒",info['drinkwine']==""?"-":info['drinkwine'].toString(),true),
                            _item_detail_gradute(context,Colors.black,Icons.nightlife,"生活作息",info['live_rest']==0?"-":info['live_rest'].toString()+"",true),
                            _item_detail_gradute(context,Colors.black,Icons.child_friendly_outlined,"生育欲望",info['want_child']==0?"-":info['want_child'].toString(),true),
                            _item_detail_gradute(context,Colors.black,Icons.margin,"结婚预期",info['marry_time']==""?"-":info['marry_time'].toString(),true),

                          ]
                      ),

                    )
                ),


              ],
            ),


          ),
          Container(
            margin: EdgeInsets.only(left: 15.w, right: 5.w,bottom: 0.h),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[

                //CustomsExpansionPanelList()
                //_item(context),
                WidgetNodePanel(
                    codeFamily: 'Inconsolata',
                    text: "用户图片",
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
                            _buildLinkTo(
                              context,
                              state.userdetails,
                            ),

                          ]
                      ),

                    )
                ),


              ],
            ),


          ),

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
                        text: "客户沟通记录",
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
                                ...list

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

    if(state is DetailLoading){

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
  Widget _item_photo(BuildContext context) {
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

  Widget _item_detail(BuildContext context,Color color,IconData icon,String name ,String answer,bool show) {
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
                          icon,
                          size: 18,
                          color: Colors.black54,
                        ),

                        Container(
                          margin: EdgeInsets.only(left: 15.w),
                          child: Text(
                            name,
                            style: TextStyle(fontSize: 15.0, color: Colors.grey),
                          ),
                        ),
                        SizedBox(
                          width: ScreenUtil().setWidth(10),
                        ),
                        Visibility(
                            visible: true,
                            child: Container(
                              width: 530.w,
                              child: Text(
                                answer,
                                maxLines: 2,
                                style: TextStyle(
                                    fontSize: 14.0, color: color),
                              ),
                            )),
                      ]),
                  //Visibility是控制子组件隐藏/可见的组件
                  Visibility(
                    visible: show,
                    child: Row(
                        children: <Widget>[
                          Container(
                            margin: EdgeInsets.only(right: 10.w),
                            child: Row(children: <Widget>[

                              SizedBox(
                                width: ScreenUtil().setWidth(10),
                              ),
                              Visibility(
                                  visible: false,
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
  Widget _item_detail_gradute(BuildContext context,Color color,IconData icon,String name ,String answer,bool show) {
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
                          icon,
                          size: 18,
                          color: Colors.black54,
                        ),

                        Container(
                          margin: EdgeInsets.only(left: 15.w),
                          child: Text(
                            name,
                            style: TextStyle(fontSize: 15.0, color: Colors.grey),
                          ),
                        ),
                        SizedBox(
                          width: ScreenUtil().setWidth(10),
                        ),
                        Visibility(
                            visible: true,
                            child: Container(
                              width: 470.w,
                              child: Text(
                                answer,
                                maxLines: 2,
                                style: TextStyle(
                                    fontSize: 14.0, color: color),
                              ),
                            )),
                      ]),
                  //Visibility是控制子组件隐藏/可见的组件
                  Visibility(
                    visible: show,
                    child: Row(
                        children: <Widget>[
                          Container(
                            margin: EdgeInsets.only(right: 10.w),
                            child: Row(children: <Widget>[

                              SizedBox(
                                width: ScreenUtil().setWidth(10),
                              ),
                              Visibility(
                                  visible: false,
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
  Widget _item(BuildContext context,String name ,String connectTime,String content,String subscribeTime,String connectStatus,String connectType) {
    bool isDark = false;

    return  Container(
      padding:  EdgeInsets.only(
        top: 10.h,
        bottom: 0
      ),
      width: double.infinity,
      //height: 180.h,
      child:  Material(
          color:  Colors.transparent ,
          child: InkWell(
            onTap: (){
              _showBottom(context,content);

              },
            child: Container(
                margin: EdgeInsets.only(left: 10.w, right: 20.w),
              child: Column(
                children: [
                  Row(
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
                                name==null?"":name,
                                style: TextStyle(fontSize: 15.0, color: Colors.black54),
                              ),
                            ),
                            SizedBox(
                              width: ScreenUtil().setWidth(10),
                            ),
                            Visibility(
                                visible: true,
                                child: Container(
                                  width: 460.w,
                                  child: Text(
                                   content,
                                    maxLines: 4,
                                    overflow: TextOverflow.ellipsis,
                                    style: TextStyle(
                                        fontSize: 12.0, color: Colors.black,fontWeight: FontWeight.w900),
                                  ),
                                )),
                          ]),
                      //Visibility是控制子组件隐藏/可见的组件
                      Visibility(
                        visible: true,
                        child: Row(
                            children: <Widget>[


                              Icon(
                                Icons.arrow_forward_ios_outlined,
                                size: 15,
                                color: Colors.black54,
                              )

                            ]),
                      )
                    ],
                  ),

                  Container(
                    margin: EdgeInsets.only(left: 10.w,top: 10.h),
                    child: Row(children: <Widget>[

                      SizedBox(
                        width: ScreenUtil().setWidth(10),
                      ),
                      Visibility(
                          visible: true,
                          child: Text(
                            "沟通时间:"+connectTime,
                            style: TextStyle(
                                fontSize: 12.0, color: Colors.black54),
                          )),
                      SizedBox(
                        width: ScreenUtil().setWidth(20),
                      ),

                        Visibility(
                          visible: true,
                          child: Text(
                            "预约时间:"+subscribeTime,
                            style: TextStyle(
                                fontSize: 12.0, color: Colors.black54),
                          )),
                    ]),
                  ),

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
                  user['info']['name'],
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
                        user['info']['age'].toString(),
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
                        user['info']['native_place'].toString(),
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

    List<dynamic> imgList =userdetail['pic'];
    List<Widget> list = [];
    imgList.map((e) => {

      list.add( Column(
      children:<Widget> [
          Stack(
          children: <Widget>[
          Container(
            margin: EdgeInsets.fromLTRB(13.w, 25.h, 0.w, 10.h),
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
                     url: e,
                     tag: e,
                   );
                 }),
                 );
               }
               ,
                child: Container(
                  margin: EdgeInsets.fromLTRB(2.w, 0.h, 2.w, 0.h),
                child: CachedNetworkImage(imageUrl: e,
                width: 140.w,
                height: 240.h,
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
        top: 25.h,
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
     list.add(
         GestureDetector(
             child: Padding(
               padding:  EdgeInsets.only(left: 35.w),
               child: Container(
                   child:
                   Image.asset(
                       "assets/images/add.png",
                     width: 160.w,
                     height: 300.h,

                   )
               ),
             ),
             onTap: () async {
               _getPermission(context);
               List<Asset> images = List<Asset>();
               List<Asset> resultList = List<Asset>();
               String error = 'No Error Dectected';
               //Navigator.of(ctx).pop();
               try {
                 resultList = await MultiImagePicker.pickImages(
                   // 选择图片的最大数量
                   maxImages: 1,
                   // 是否支持拍照
                   enableCamera: true,
                   materialOptions: MaterialOptions(
                     // 显示所有照片，值为 false 时显示相册
                       startInAllView: true,
                       allViewTitle: '所有照片',
                       actionBarColor: '#2196F3',
                       textOnNothingSelected: '没有选择照片'
                   ),
                 );
               } on Exception catch (e) {
                 e.toString();
               }
               if (!mounted) return;
               images = (resultList == null) ? [] : resultList;
               // 上传照片时一张一张上传
               for(int i = 0; i < images.length; i++) {
                 // 获取 ByteData
                 _loading();
                 ByteData byteData = await images[i].getByteData();
                 try {
                   var resultConnectList= await IssuesApi.uploadPhoto("1",byteData);
                   // print(resultConnectList['data']);

                   var result= await IssuesApi.editCustomer(userdetail['info']['uuid'],"1",resultConnectList['data']);
                   if(result['code']==200){
                     _showToast(context,result['message'],false);
                   }else{
                     _showToast(context,result['message'],false);
                   }
                 } on DioError catch(e){
                   var dd=e.response.data;
                   EasyLoading.showSuccess(dd['message']);
                   //_showToast(context,dd['message'],false);
                 }
                 EasyLoading.dismiss();
               }
             }

         )

     );

    return Wrap(
      children: [
        ...list
      ],
    );
  }
}
_getPermission(BuildContext context) {
  //请求读写权限
  ObjectUtil.getPermissions([
    PermissionGroup.storage,
    PermissionGroup.camera,

  ]).then((res) {
    if (res[PermissionGroup.storage] == PermissionStatus.denied ||
        res[PermissionGroup.storage] == PermissionStatus.unknown) {
      //用户拒绝，禁用，或者不可用
      DialogUtil.showBaseDialog( context, '获取不到权限，APP不能正常使用',
          right: '去设置', left: '取消', rightClick: (res) {
            PermissionHandler().openAppSettings();
          });
    } else if (res[PermissionGroup.storage] == PermissionStatus.granted) {
    } else if (res[PermissionGroup.storage] == PermissionStatus.restricted) {
      //用户同意IOS的回调
    }
  });
}
_loading(){
  Timer _timer;
  double _progress;
  _progress = 0;
  _timer?.cancel();
  _timer = Timer.periodic(const Duration(milliseconds: 100),
          (Timer timer) {
                EasyLoading.showProgress(_progress,
                    status: '${(_progress * 100).toStringAsFixed(0)}%');
                _progress += 0.03;

                if (_progress >= 1) {
                  _timer?.cancel();
                  EasyLoading.dismiss();
                }
        });
}

_comment(BuildContext context) {
  showDialog(
      context: context,
      builder: (ctx) => CommentDialog()

  );
}

_showBottom(BuildContext context,String text){
  showFLBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return FLCupertinoActionSheet(
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 5),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[

                Container(
                  child: Text(
                    text,
                    textAlign: TextAlign.left,
                    style: TextStyle(fontSize: 16,fontWeight: FontWeight.w900),
                  ),
                )
              ],
            ),
          ),
          cancelButton: CupertinoActionSheetAction(
            child: const Text('关闭'),
            isDefaultAction: true,
            onPressed: () {
              Navigator.pop(context, 'Cancel');
            },
          ),
        );
      }).then((value) {
    //print(value);
  });
}
_deletePhoto(BuildContext context,String img) {
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
