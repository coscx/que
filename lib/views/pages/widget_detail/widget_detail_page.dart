import 'dart:async';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:city_pickers/city_pickers.dart';
import 'package:city_pickers/modal/result.dart';
import 'package:flui/flui.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_geen/components/imageview/image_preview_page.dart';
import 'package:flutter_geen/components/imageview/image_preview_view.dart';
import 'package:flutter_geen/components/permanent/circle.dart';
import 'package:flutter_geen/views/dialogs/comment.dart';
import 'package:flutter_geen/views/dialogs/delete_category_dialog.dart';
import 'package:flutter_geen/views/pages/utils/object_util.dart';
import 'package:flutter_picker/Picker.dart';
import 'package:flutter_star/flutter_star.dart';
import 'package:flutter_geen/app/res/cons.dart';
import 'package:flutter_geen/app/res/toly_icon.dart';
import 'package:flutter_geen/app/utils/Toast.dart';
import 'package:flutter_geen/blocs/bloc_exp.dart';
import 'package:flutter_geen/components/permanent/feedback_widget.dart';
import 'package:flutter_geen/components/permanent/panel.dart';
import 'package:flutter_geen/components/project/widget_node_panel.dart';
import 'package:flutter_geen/views/pages/widget_detail/category_end_drawer.dart';
import 'package:flutter_geen/views/items/tag.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_geen/views/pages/home/home_page.dart';
import 'package:flutter_geen/views/pages/utils/user_detail_array.dart';
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
              fontSize: 38.sp,
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
      duration: Duration(milliseconds:  5000 ),
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
    _item(context,e['username'],e['connect_time']==null?"":e['connect_time'],e['connect_message'],e['subscribe_time']==null?"":e['subscribe_time'],e['connect_status'].toString(),e['connect_type'].toString())
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
                            GestureDetector(
                                onTap: (){

                                },child: _item_detail(context,Colors.black,Icons.format_list_numbered,"编号",info['code'].toString(),false)),
                            GestureDetector(
                                onTap: (){

                                },child: _item_detail(context,Colors.black,Icons.backpack_outlined,"姓名",info['name'].toString(),true)),
                              GestureDetector(
                                  onTap: (){
                                    showPickerArray(context,[["男生","女生"]],info['gender']==0?[1]:[_getIndexOfList(_sexLevel,info['gender'].toString())]);
                                  },child:  _item_detail(context,Colors.black,Icons.support_agent,"性别",info['gender']==1?"男生":"女生",true)),
                            GestureDetector(
                            onTap: (){

                            },child: _item_detail(context,Colors.black,Icons.contact_page_outlined,"年龄",info['age']==0?"-":info['age'].toString()+"岁",false)),
                            GestureDetector(
                            onTap: (){
                              showPickerDateTime(context);
                            },child:  _item_detail(context,Colors.black,Icons.broken_image_outlined,"生日",info['birthday'].toString()+"("+info['chinese_zodiac']+"-"+info['zodiac']+")",true)),
                            GestureDetector(
                            onTap: (){

                            },child:  _item_detail(context,Colors.red,Icons.settings_backup_restore_outlined,"八字",info['bazi'].toString(),false)),
                            GestureDetector(
                            onTap: (){

                                  },child:  _item_detail(context,Colors.orange,Icons.whatshot,"五行",info['wuxing'].toString(),false)),
                            GestureDetector(
                            onTap: () async {
                              Result result = await CityPickers.showCityPicker(
                                  context: context,
                                  locationCode: info['np_area_code'] =="" ? (info['np_city_code'] ==""? "320500":info['np_city_code'] ) :info['np_area_code'] ,
                                  cancelWidget: Text("取消",style: TextStyle(color: Colors.black),),
                                  confirmWidget: Text("确定",style: TextStyle(color: Colors.black),)
                              );
                              print(result);
                            },child:  _item_detail(context,Colors.black,Icons.local_activity_outlined,"籍贯",info['native_place'].toString(),true)),
                            GestureDetector(
                            onTap: () async {
                              Result result = await CityPickers.showCityPicker(
                                  context: context,
                                  locationCode: '320505',
                                  cancelWidget: Text("取消",style: TextStyle(color: Colors.black),),
                                  confirmWidget: Text("确定",style: TextStyle(color: Colors.black),)
                              );
                              print(result);
                            },child:  _item_detail(context,Colors.black,Icons.house_outlined,"居住",info['location_place'].toString(),true)),
                            GestureDetector(
                            onTap: (){

                            },child:  _item_detail(context,Colors.black,Icons.point_of_sale,"销售",info['sale_user'].toString(),false)),
                            GestureDetector(
                            onTap: (){
                            showPickerArray(context,[_nationLevel],info['nation']==0?[1]:[_getIndexOfList(_nationLevel,info['nation'].toString()+"")]);
                            },child: _item_detail(context,Colors.black,Icons.gamepad_outlined,"民族",info['nation']==1?"汉族":"其他",true)),
                            GestureDetector(
                            onTap: (){
                              showPickerArray(context,[_getHeightList()],info['height']==0?[70]:[_getIndexOfList(_getHeightList(),info['height'].toString()+" cm")]);
                            },child:  _item_detail(context,Colors.black,Icons.height,"身高",info['height']==0?"-":info['height'].toString()+"cm",true)),
                            GestureDetector(
                            onTap: (){
                              showPickerArray(context,[_getWeightList()],info['weight']==0?[35]:[_getIndexOfList(_getWeightList(),info['weight'].toString()+" kg")]);
                            },child:  _item_detail(context,Colors.black,Icons.line_weight,"体重",info['weight']==0?"-":info['weight'].toString()+"kg",true)),
                            GestureDetector(
                            onTap: (){

                            },child:  _item_detail(context,Colors.black,Icons.design_services_outlined,"服务",info['serve_user']==""?"-":info['serve_user'].toString(),false)),
                            GestureDetector(
                            onTap: (){

                            },child:  _item_detail(context,Colors.black,Icons.integration_instructions_outlined,"兴趣",info['interest']==""?"-":info['interest'].toString(),true)),
                            GestureDetector(
                            onTap: (){
                            showPickerArray(context,[_floodLevel],info['blood_type']==0?[3]:[info['blood_type']]);
                            },child:  _item_detail(context,Colors.black,Icons.blur_on_outlined,"血型",info['blood_type']==0?"-":_getFloodLevel(info['blood_type']),true)),
                            GestureDetector(
                            onTap: (){

                            },child:   _item_detail(context,Colors.black,Icons.developer_mode,"择偶",info['demands'].toString(),true)),
                            GestureDetector(
                            onTap: (){

                            },child:    _item_detail(context,Colors.black,Icons.bookmarks_outlined,"备注",info['remark'].toString(),true)),

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
                            _item_detail_gradute(context,Colors.redAccent,Icons.menu_book,"个人学历",info['education']==0?"-":_getEduLevel(info['education']),true),
                            _item_detail_gradute(context,Colors.black,Icons.school,"毕业院校",info['school'].toString()==""?"-":info['school'].toString(),true),
                            _item_detail_gradute(context,Colors.black,Icons.tab,"所学专业",info['major']==""?"-":info['major'].toString(),true),
                            _item_detail_gradute(context,Colors.black,Icons.reduce_capacity,"企业类型",info['work']==0?"-":_getCompanyLevel(info['work'])+"",true),
                            _item_detail_gradute(context,Colors.black,Icons.location_city,"所属行业",info['work_job']==""?"-":_getWorkType(info['work_job']),true),
                            _item_detail_gradute(context,Colors.black,Icons.description_outlined,"职位描述",info['work_industry']==""?"-":info['work_industry'].toString(),true),
                            _item_detail_gradute(context,Colors.black,Icons.more_outlined,"加班情况",info['work_overtime']==""?"-":_getWorkOverTime(info['work_overtime']),true),
                            _item_detail_gradute(context,Colors.redAccent,Icons.monetization_on_outlined,"收入情况",info['income']==0?"-":_getIncome(info['income']),true),
                            _item_detail_gradute(context,Colors.redAccent,Icons.house_outlined,"是否有房",info['has_house']==0?"-":_getHasHouse(info['has_house']),true),
                            _item_detail_gradute(context,Colors.black,Icons.copyright_rounded,"房贷情况",info['loan_record']==0?"-":_getHouseFuture(info['loan_record']),true),
                            _item_detail_gradute(context,Colors.black,Icons.car_rental,"是否有车",info['has_car']==0?"-":_getHasCar(info['has_car']),true),
                            _item_detail_gradute(context,Colors.black,Icons.wb_auto_outlined,"车辆档次",info['car_type']==0?"-":_getCarLevel(info['car_type']),true),

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
                            _item_detail_gradute(context,Colors.redAccent,Icons.wc,"婚姻状态",info['marriage']==0?"-":_getMarriageLevel(info['marriage']),true),
                            _item_detail_gradute(context,Colors.redAccent,Icons.child_care,"子女信息",info['has_child']==0?"-":_getChildLevel(info['has_child']),true),
                            _item_detail_gradute(context,Colors.black,Icons.mark_chat_read_outlined,"子女备注",info['child_remark']==""?"-":info['child_remark'].toString(),true),
                            _item_detail_gradute(context,Colors.black,Icons.looks_one_outlined,"独生子女",info['only_child']==0?"-":_getOnlyChildLevel(info['only_child'])+"",true),
                            _item_detail_gradute(context,Colors.black,Icons.watch_later_outlined,"父母状况",info['parents']==0?"-":_getParentLevel(info['parents']),true),
                            _item_detail_gradute(context,Colors.black,Icons.attribution_rounded,"父亲职业",info['father_work']==""?"-":info['father_work'].toString(),true),
                            _item_detail_gradute(context,Colors.black,Icons.sports_motorsports_outlined,"母亲职业",info['mother_work']==""?"-":info['mother_work'].toString(),true),
                            _item_detail_gradute(context,Colors.redAccent,Icons.monetization_on,"父母收入",info['parents_income']==""?"-":info['parents_income'].toString(),true),
                            _item_detail_gradute(context,Colors.redAccent,Icons.nine_k,"父母社保",info['parents_insurance']==0?"-":_getParentProtectLevel(info['parents_insurance']),true),

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
                            _item_detail_gradute(context,Colors.black,Icons.fastfood,"宗教信仰",info['faith']==0?"-":_getFaithLevel(info['faith']),true),
                            _item_detail_gradute(context,Colors.black,Icons.smoking_rooms,"是否吸烟",info['smoke']==0?"-":_getSmokeLevel(info['smoke']),true),
                            _item_detail_gradute(context,Colors.black,Icons.wine_bar,"是否喝酒",info['drinkwine']==""?"-":_getDrinkLevel(info['drinkwine']),true),
                            _item_detail_gradute(context,Colors.black,Icons.nightlife,"生活作息",info['live_rest']==0?"-":_getLifeLevel(info['live_rest'])+"",true),
                            _item_detail_gradute(context,Colors.black,Icons.child_friendly_outlined,"生育欲望",info['want_child']==0?"-":_getCreatLevel(info['want_child']),true),
                            _item_detail_gradute(context,Colors.black,Icons.margin,"结婚预期",info['marry_time']==""?"-":_getMarriageDateLevel(info['marry_time']),true),

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
    return Container(
      child: Container(child:
      Column(
        children: [
          SizedBox(
            height: 0.h,
          ),
          Image.asset("assets/images/loadings.gif"),
        ],
      )),
    );
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
                            style: TextStyle(fontSize: 30.sp, color: Colors.grey),
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
                                  fontSize: 12.sp, color: Colors.black),
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
                                        fontSize: 7.sp, color: Colors.grey),
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
      //height: 80.h,
      child:  Material(
          color:  Colors.transparent ,
          child: Container(
            child: Container(
              margin: EdgeInsets.only(left: 10.w, right: 20.w,top: 10.h,bottom: 10.h),
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
                            style: TextStyle(fontSize: 30.sp, color: Colors.grey),
                          ),
                        ),
                        SizedBox(
                          width: ScreenUtil().setWidth(10),
                        ),
                        Visibility(
                            visible: true,
                            child: Container(
                              width: 506.w,
                              child: Text(
                                answer,
                                maxLines: 20,
                                style: TextStyle(
                                    fontSize: 28.sp, color: color),
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
                                        fontSize: 14.sp, color: Colors.grey),
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
                            size: 30.sp,
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
      //height: 180.h,
      child:  Material(
          color:  Colors.transparent ,
          child: InkWell(
            onTap: (){},
            child: Container(
              margin: EdgeInsets.only(left: 10.w, right: 20.w,top: 10.h,bottom: 10.h),
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
                            style: TextStyle(fontSize: 30.sp, color: Colors.grey),
                          ),
                        ),
                        SizedBox(
                          width: ScreenUtil().setWidth(10),
                        ),
                        Visibility(
                            visible: true,
                            child: Container(
                              width: 427.w,
                              child: Text(
                                answer,
                                maxLines: 20,
                                style: TextStyle(
                                    fontSize: 28.sp, color: color),
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
                                        fontSize: 14.sp, color: Colors.grey),
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
                            size: 30.sp,
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
                            Circle(
                              //connectType 沟通类型 1-线上沟通 2-到店沟通
                              color: connectType=="1"?Colors.green:Colors.redAccent,
                              radius: 5,
                            ),

                            Container(
                              margin: EdgeInsets.only(left: 15.w),
                              child: Text(
                                name==null?"":name,
                                style: TextStyle(fontSize: 30.sp, color: Colors.black54),
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
                                        fontSize: 25.sp, color: Colors.black,fontWeight: FontWeight.w900),
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
                        width: ScreenUtil().setWidth(10.w),
                      ),
                      Visibility(
                          visible: true,
                          child: Text(
                            "沟通时间:"+(connectTime==null?"":connectTime),
                            style: TextStyle(
                                fontSize: 20.sp, color: Colors.black54),
                          )),
                      SizedBox(
                        width: ScreenUtil().setWidth(10.w),
                      ),

                        Visibility(
                          visible: true,
                          child: Text(
                            "预约时间:"+(subscribeTime==null?"":subscribeTime),
                            style: TextStyle(
                                fontSize: 20.sp, color: Colors.black54),
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
    return Stack(
      children: [
        Container(
          width: 150.w,
          height: 150.h,
          decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage("assets/images/radio_header_1.png"),
                //fit: BoxFit.contain,
              ),
          ),
          margin: EdgeInsets.only(left: 12.w),

        ),
        Container(
          margin: EdgeInsets.only(left: 42.w,top: 22.h),

          child: CircleAvatar(
            radius:(45.w) ,
            child: ClipOval(
              child: Image.network(
                url,
                 fit: BoxFit.cover,
                width: 90.w,
                height: 90.h,
              ),
            ),
            backgroundColor: Colors.white,
          ),
        ),
      ],
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
            padding: EdgeInsets.only(left: 0.w, right: 0.w),
            child: user['pic'].length> 0? avatar(user['pic'][0]) :Image.asset("assets/packages/images/ic_user_none_round.png"),
          ),
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                 Container(
                 margin: EdgeInsets.fromLTRB(10.w, 5.h, 5.w, 0.h),
                 child:
                 Text(
                  user['info']['name'],
                    style: TextStyle(
                      color: Colors.black,
                      fontWeight: FontWeight.bold,
                      fontSize: 32.sp,
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
                        style: TextStyle(color: Colors.black, fontSize: 18.sp),
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
                          fontSize: 24.sp,
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

    List<dynamic> imgList =userdetail['pics'];
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
                     url: e['file_url'],
                     tag: e['file_url'],
                   );
                 }),
                 );
               },
                child: Container(
                  margin: EdgeInsets.fromLTRB(2.w, 0.h, 2.w, 0.h),
                child: CachedNetworkImage(imageUrl: e['file_url'],
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
            _deletePhoto(context,e,userdetail);
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
               //_getPermission(context);
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
                       startInAllView: false,
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
                   var resultConnectList= await IssuesApi.uploadPhoto("1",byteData,_loading);
                   // print(resultConnectList['data']);

                   var result= await IssuesApi.editCustomer(userdetail['info']['uuid'],"1",resultConnectList['data']);
                   if(result['code']==200){
                     BlocProvider.of<DetailBloc>(context).add(FetchWidgetDetail(userdetail['info']));
                     _showToast(context,"上传成功",false);
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
showPickerArray(BuildContext context,List<List<String >> pickerData,List<int > select) {
   Picker(
      adapter: PickerDataAdapter<String>(pickerdata: pickerData, isArray: true),
      hideHeader: true,
      title: new Text("请选择"),
      cancelText: "取消",
      confirmText: "确定",
       selecteds:select,
     // columnPadding: EdgeInsets.only(top: 50.h,bottom: 50.h,left: 50.w,right: 50.w),
       selectedTextStyle: TextStyle(
         fontSize: 20,
         color: Colors.redAccent,
       ),
      onConfirm: (Picker picker, List value) {
        print(value.toString());
        print(picker.getSelectedValues());
      }
  ).showDialog(context);
}
showPickerDateTime(BuildContext context) {
   Picker(
      adapter:  DateTimePickerAdapter(
        type: PickerDateTimeType.kYMDHM,
        isNumberMonth: true,
        //strAMPM: const["上午", "下午"],
        // yearSuffix: "年",
        // monthSuffix: "月",
        // daySuffix: "日",
        value: DateTime.parse("1999-01-01 08:00:00"),
        maxValue: DateTime.now(),
        minuteInterval: 1,
        minHour: 0,
        maxHour: 23,
        // twoDigitYear: true,
      ),
      title: new Text("选择时间"),
       cancelText: "取消",
       confirmText: "确定",
       textAlign: TextAlign.center,
      selectedTextStyle: TextStyle(color: Colors.blue),
      delimiter: [
        PickerDelimiter(column: 4, child: Container(
          width: 16.0,
          alignment: Alignment.center,
          child: Text(':', style: TextStyle(fontWeight: FontWeight.bold)),
          color: Colors.white,
        ))
      ],
      footer: Container(
        height: 50.0,
        alignment: Alignment.center,
        child: Text(''),
      ),
      onConfirm: (Picker picker, List value) {
        print(picker.adapter.text);
      },
      onSelect: (Picker picker, int index, List<int> selecteds) {

         var stateText = picker.adapter.toString();

      }
  ).showDialog(context);
}
_getEduLevel(info) {

  try {
    return _EduLevel[info];
  } catch (e) {
    return "未知";
  }

}
_getWorkType(info) {


  try {
    return _WorkTypeLevel[info];
  } catch (e) {
    return "未知";
  }

}
_getWorkOverTime(info) {


  try {
    return _WorkOverTimeLevel[info];
  } catch (e) {
    return "未知";
  }

}
_getIncome(info) {

  try {
    return _IncomeLevel[info];
  } catch (e) {
    return "未知";
  }

}

_getHasHouse(info) {


  try {
    return _hasHouseLevel[info];
  } catch (e) {
    return "未知";
  }

}

_getHouseFuture(info) {


  try {
    return _houseFutureLevel[info];
  } catch (e) {
    return "未知";
  }

}

_getHasCar(info) {


  try {
    return _hasCarLevel[info];
  } catch (e) {
    return "未知";
  }

}
_getCarLevel(info) {


  try {
    return _carLevelLevel[info];
  } catch (e) {
    return "未知";
  }

}


_getMarriageLevel(info) {


  try {
    return _marriageLevel[info];
  } catch (e) {
    return "未知";
  }

}
_getChildLevel(info) {


  try {
    return _childLevel[info];
  } catch (e) {
    return "未知";
  }

}
_getOnlyChildLevel(info) {


  try {
    return _onlyChildLevel[info];
  } catch (e) {
    return "未知";
  }

}
_getParentLevel(info) {


  try {
    return _parentLevel[info];
  } catch (e) {
    return "未知";
  }

}
_getParentProtectLevel(info) {


  try {
    return _parentProtectLevel[info];
  } catch (e) {
    return "未知";
  }

}
_getFaithLevel(info) {


  try {
    return _faithLevel[info];
  } catch (e) {
    return "未知";
  }

}

_getSmokeLevel(info) {


  try {
    return _smokeLevel[info];
  } catch (e) {
    return "未知";
  }

}

_getDrinkLevel(info) {


  try {
    return _drinkLevel[info];
  } catch (e) {
    return "未知";
  }

}
_getLifeLevel(info) {


  try {
    return _lifeLevel[info];
  } catch (e) {
    return "未知";
  }

}

_getCreatLevel(info) {
  try {
    return _creatLevel[info];
  } catch (e) {
    return "未知";
  }

}

_getMarriageDateLevel(info) {


  try {
    return _marriageDateLevel[info];
  } catch (e) {
    return "未知";
  }

}
_getFloodLevel(info) {


  try {
    return _floodLevel[info];
  } catch (e) {
    return "未知";
  }

}

_getSexLevel(info) {


  try {
    return _sexLevel[info];
  } catch (e) {
    return "未知";
  }

}
_getCompanyLevel(info) {


  try {
    return _companyTypeLevel[info];
  } catch (e) {
    return "未知";
  }

}
int _getIndexOfList(List<String> orc,String input) {
    var index =orc.indexOf(input);
    return index;
}
List<String> _getAgeList() {

  List<String> age =[] ;
  for (var i = 14; i < 99; i++) {
    age.add(i.toString()+" 岁");
  }
  return age;
}
List<String> _getWeightList() {

  List<String> weight =[] ;
  for (var i = 30; i < 200; i++) {
    weight.add(i.toString()+" kg");
  }
  return weight;
}
List<String> _getHeightList() {

  List<String> height=[] ;
  for (var i = 100; i < 200; i++) {
    height.add(i.toString()+" cm");
  }
  return height;
}





List<String> _nationLevel = [
  "汉族","蒙古族","回族","藏族","维吾尔族","苗族","彝族","壮族","布依族","朝鲜族","满族","侗族","瑶族","白族","土家族",
  "哈尼族","哈萨克族","傣族","黎族","傈僳族","佤族","畲族","高山族","拉祜族","水族","东乡族","纳西族","景颇族","柯尔克孜族",
  "土族","达斡尔族","仫佬族","羌族","布朗族","撒拉族","毛南族","仡佬族","锡伯族","阿昌族","普米族","塔吉克族","怒族", "乌孜别克族",
  "俄罗斯族","鄂温克族","德昂族","保安族","裕固族","京族","塔塔尔族","独龙族","鄂伦春族","赫哲族","门巴族","珞巴族","基诺族"
];
List<String> _sexLevel = [
  "未知",
  "男生",
  "女生",
];
List<String> _floodLevel = [
  "未知",
  "A型",
  "B型",
  "O型",
  "AB型",


];
List<String> _EduLevel = [
  "未知",
  "高中及以下",
  "大专",
  "本科",
  "硕士",
  "博士及以上",
  "国外留学",
  "其他",

];
List<String> _WorkTypeLevel = [
  "未知",
  "企事业单位公务员",
  "教育医疗",
  "民营企业",
  "私营业主",
  "其他",

];
List<String> _companyTypeLevel = [
  "未知",
  "企事业单位公务员",
  "教育医疗",
  "民营企业",
  "私营业主",
  "其他",

];
List<String> _WorkOverTimeLevel = [
  "未知",
  "不加班",
  "偶尔加班",
  "经常加班",

];
List<String> _IncomeLevel = [
  "未知",
  "5万及以下",
  "5-10万",
  "10-15万",
  "15-20万",
  "20-30万",
  "30-50万",
  "50-70万",
  "70-100万",
  "100万以上",
];
List<String> _hasHouseLevel = [
  "未知",
  "无房",
  "1套房",
  "2套房",
  "3套房及以上",
  "其他",
];
List<String> _houseFutureLevel = [
  "未知",
  "无房贷",
  "已还清",
  "在还贷",

];
List<String> _hasCarLevel = [
  "未知",
  "有车",
  "无车",
];
List<String> _carLevelLevel = [
  "未知",
  "无车产",
  "5-10万车",
  "10-20万车",
  "20-30万车",
  "30-50万车",
  "50万以上车",
];
List<String> _marriageLevel = [
  "未知",
  "未婚",
  "离异带孩",
  "离异单身",
  "离异未育",
  "丧偶",
];
List<String> _childLevel = [
  "未知",
  "有",
  "无",
];
List<String> _onlyChildLevel = [
  "未知",
  "有",
  "无",
];
List<String> _parentLevel = [
  "未知",
  "父母同在",
  "父歿母在",
  "父在母歿",
  "父母同歿",
];
List<String> _parentProtectLevel = [
  "未知",
  "父亲有医保",
  "母亲有医保",
  "父母均有医保",
];
List<String> _faithLevel = [
  "未知",
  "无信仰",
  "基督教",
  "天主教",
  "佛教",
  "道教",
  "伊斯兰教",
  "其他宗教",

];
List<String> _smokeLevel = [
  "未知",
  "不吸烟",
  "偶尔吸烟",
  "经常吸烟",
  "有戒烟计划",
];
List<String> _drinkLevel = [
  "未知",
  "不喝酒",
  "偶尔喝",
  "应酬喝",
  "经常喝",
  "有戒酒计划",
];
List<String> _lifeLevel = [
  "未知",
  "很规律",
  "经常熬夜",
];
List<String> _creatLevel = [
  "未知",
  "想要孩子",
  "可以考虑",
  "想要孩子",
];
List<String> _marriageDateLevel = [
  "未知",
  "半年内",
  "一年内",
  "2年内",
  "还没想好",
];
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
_loading(int a, int b){
                double _progress;
                _progress = 0;
                _progress = a / b;
                EasyLoading.showProgress(_progress, status: '${(_progress * 100).toStringAsFixed(0)}%');
                //_progress += 0.03;
                if (_progress >= 1) {
                  EasyLoading.dismiss();
                }
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
        return ScrollConfiguration(
            behavior: DyBehaviorNull(),
        child:FLCupertinoActionSheet(
          child: Container(
            color: Colors.white,
            constraints: BoxConstraints(
              minHeight: 450.h,
              // minWidth: double.infinity, // //宽度尽可能大
            ),
            padding:  EdgeInsets.only(left: 25.w, right: 25.w,top: 25.h,bottom: 20.h),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[

                Container(
                  child: Text(
                    text,
                    textAlign: TextAlign.left,
                    style: TextStyle(fontSize: 32.sp,fontWeight: FontWeight.w900),
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
        ));
      }).then((value) {
    //print(value);
  });
}

_deletePhoto(BuildContext context,Map<String,dynamic> img,Map<String,dynamic> detail) {
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
              BlocProvider.of<DetailBloc>(context).add(EventDelDetailImg(img,detail['info']));
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
                    fontSize: 20.sp,
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
