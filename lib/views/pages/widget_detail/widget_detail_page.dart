import 'dart:async';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_geen/components/imageview/image_preview_page.dart';
import 'package:flutter_geen/components/imageview/image_preview_view.dart';
import 'package:flutter_geen/views/component/goods_add_menu.dart';
import 'package:flutter_geen/views/dialogs/popup_window.dart';
import 'package:flutter_geen/views/dialogs/ww_dialog.dart';
import 'package:flutter_geen/views/items/bottom_sheet.dart';
import 'package:flutter_geen/views/pages/utils/DyBehaviorNull.dart';
import 'package:flutter_geen/views/pages/widget_detail/detail_dialog.dart';
import 'package:flutter_geen/app/res/cons.dart';
import 'package:flutter_geen/blocs/bloc_exp.dart';
import 'package:flutter_geen/components/permanent/feedback_widget.dart';
import 'package:flutter_geen/views/items/tag.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:lottie/lottie.dart';
import 'package:flutter_geen/app/api/issues_api.dart';
import 'package:fluwx/fluwx.dart' as fluwx;
import 'package:flutter_geen/views/items/share.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:flutter_geen/views/dialogs/common_dialog.dart';
import 'detail_common.dart';
import 'detail_item.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:flutter_geen/views/component/refresh.dart';

class WidgetDetailPage extends StatefulWidget {
  WidgetDetailPage();

  @override
  _WidgetDetailPageState createState() => _WidgetDetailPageState();
}

class _WidgetDetailPageState extends State<WidgetDetailPage> {
  String memberId;

  int connectStatus = 4;
  int canEdit = 0;
  String call = "";
  String uuid = "";
  int status = 10;
  bool showBaseControl = false;
  bool showEduControl = false;
  bool showMarriageControl = false;
  bool showSimilarControl = false;
  bool showSelectControl = false;
  bool showPhotoControl = false;
  bool showAppointControl = false;
  bool showConnectControl = false;
  bool showActionControl = false;
  bool showCallControl = false;

  Map<String, dynamic> userDetail;
  final List<ShareOpt> list = [
    ShareOpt(
        title: '微信',
        img: 'assets/packages/images/login_wechat.svg',
        shareType: ShareType.SESSION,
        doAction: (shareType, shareInfo) async {
          if (shareInfo == null) return;

          /// 分享到好友
          var model = fluwx.WeChatShareWebPageModel(
            shareInfo.url,
            title: shareInfo.title,
            thumbnail: fluwx.WeChatImage.network(shareInfo.img),
            scene: fluwx.WeChatScene.SESSION,
          );
          fluwx.shareToWeChat(model);
        }),
  ];
  final GlobalKey _addKey = GlobalKey();
  RefreshController _refreshController =
      RefreshController(initialRefresh: false);

  get sexConfirmCallback => null;

  @override
  void initState() {
    Future.delayed(Duration(seconds: 1)).then((e) async {
      Map<String, dynamic> photo = Map();
      photo['uuid'] = userDetail['uuid'];
      BlocProvider.of<DetailBloc>(context).add(FetchWidgetDetailNoFresh(photo));
    });


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
        child: Scaffold(
          //endDrawer: CategoryEndDrawer(),
          appBar: AppBar(
            backgroundColor: Colors.white,
            elevation: 0,
            //去掉Appbar底部阴影
            leading: IconButton(
              icon: Icon(Icons.arrow_back, color: Colors.black),
              onPressed: () => Navigator.of(context).pop(),
            ),
            title: Text("用户详情",
                style: TextStyle(
                  fontFamily: "Quicksand",
                  fontWeight: FontWeight.w900,
                  fontStyle: FontStyle.italic,
                  fontSize: 38.sp,
                  decoration: TextDecoration.none,
                  color: Colors.black,
                )),
            actions: <Widget>[
              _buildCallButton(),
              _buildAppointButton(),
              _buildConnectButton(),
              _buildRightMenu()
            ],
          ),
          body: BlocListener<DetailBloc, DetailState>(
              listener: (ctx, state) {
                if (state is DetailWithData) {
                  if (state.reason != null) {
                    var result = state.reason['result'];
                    if (result == "delete_success") {
                      showPhotoControl = true;
                      showToast(context, state.reason['reason'], true);
                    }
                    if (result == "delete_fail") {
                      showPhotoControl = true;
                      showToastRed(context, state.reason['reason'], true);
                    }
                    if (result == "upload_success") {
                      showPhotoControl = true;
                    }
                  }
                }
              },
              child: Builder(builder: _buildContent)),
        ));
  }

  Widget _buildRightMenu() {
    return Container(
      margin: EdgeInsets.fromLTRB(0.w, 15.h, 20.w, 0.h),
      child: IconButton(
        tooltip: '用户操作',
        key: _addKey,
        onPressed: () {

          showAddMenu(userDetail);
        },
        icon: Icon(
          Icons.wifi_tethering,
          color: Colors.black,
          key: const Key('add'),
        ),
      ),
    );
  }

  // 下拉刷新
  void _onRefresh() async {
    Map<String, dynamic> photo = Map();
    photo['uuid'] = userDetail['uuid'];
    BlocProvider.of<DetailBloc>(context).add(FetchWidgetDetailNoFresh(photo));
    _refreshController.refreshCompleted();
  }

  // 上拉加载
  void _onLoading() async {
    _refreshController.loadComplete();
  }

  void showAddMenu(Map<String, dynamic> args) {
    final RenderBox button =
        _addKey.currentContext.findRenderObject() as RenderBox;

    showPopupWindow<void>(
      context: context,
      isShowBg: true,
      offset: Offset(button.size.width - 7.w, -15.h),
      anchor: button,
      child: GoodsAddMenu(
        args: args,
      ),
    );
  }

  Future<void> _makePhoneCall(String phoneNumber) async {
    final Uri launchUri = Uri(
      scheme: 'tel',
      path: phoneNumber,
    );
    await launch(launchUri.toString());
  }

  List<PopupMenuItem<String>> buildItems() {
    final map = {
      "移入良缘库": Icons.archive_outlined,
      "移入公海": Icons.copyright_rounded,
      "划分客户": Icons.pivot_table_chart,
    };
    return map.keys
        .toList()
        .map((e) => PopupMenuItem<String>(
            value: e,
            child: Wrap(
              spacing: 5.h,
              children: <Widget>[
                Icon(
                  map[e],
                  color: Colors.black,
                ),
                Text(e),
              ],
            )))
        .toList();
  }

  Widget _buildContent(BuildContext context) => WillPopScope(
      onWillPop: () => _whenPop(context),
      child: ScrollConfiguration(
          behavior: DyBehaviorNull(),
          child: SmartRefresher(
              enablePullDown: true,
              enablePullUp: false,
              header: DYrefreshHeader(),
              footer: DYrefreshFooter(),
              controller: _refreshController,
              onRefresh: _onRefresh,
              onLoading: _onLoading,
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    BlocBuilder<DetailBloc, DetailState>(builder: _buildTitle),
                    BlocBuilder<DetailBloc, DetailState>(builder: _buildDetail)
                  ],
                ),
              ))));

  Widget _buildAppointButton() => Builder(
      builder: (ctx) => GestureDetector(
          onLongPress: () => Scaffold.of(ctx).openEndDrawer(),
          child: Padding(
            padding: EdgeInsets.only(top: 10.h),
            child: Container(
              width: 60.h,
              height: 60.h,
              margin: EdgeInsets.fromLTRB(10.w, 0.h, 5.w, 0.h),
              child: Lottie.asset(
                  'assets/packages/lottie_flutter/appointment.json'),
            ),
          ),
          onTap: () async {
            if (canEdit == 1) {
              var d = await appointDialog(context, userDetail);
              if (d != null) {
                if (d == true) {
                  setState(() {
                    showBaseControl = false;
                    showEduControl = false;
                    showMarriageControl = false;
                    showSimilarControl = false;
                    showSelectControl = false;
                    showPhotoControl = false;
                    showConnectControl = false;
                    showAppointControl = true;
                    showActionControl = false;
                    showCallControl = false;
                  });
                }
              }
            } else {
              showToastRed(ctx, "权限不足", true);
            }
          }));

  Widget _buildCallButton() => Builder(
      builder: (ctx) => GestureDetector(
          onLongPress: () => Scaffold.of(ctx).openEndDrawer(),
          child: Padding(
            padding: EdgeInsets.only(top: 15.h),
            child: Container(
              width: 60.h,
              height: 60.h,
              margin: EdgeInsets.fromLTRB(10.w, 0.h, 0.w, 0.h),
              child: Lottie.asset(
                  'assets/packages/lottie_flutter/phone-call.json'),
            ),
          ),
          onTap: () async {
            if (canEdit == 0) {
              showToastRed(ctx, "暂无权限", true);
              return;
            }
            WWDialog.showBottomDialog(context,
                content: '请选择',
                contentColor: colorWithHex9,
                contentFontSize: 30.sp,
                location: DiaLogLocation.bottom,
                arrangeType: buttonArrangeType.column,
                buttons: ['查看号码', '拨打电话'],
                otherButtonFontSize: 30.sp,
                otherButtonFontWeight: FontWeight.w400,
                onTap: (int index, BuildContext context) async {
              if (index == 0) {
                var actionList = await IssuesApi.viewCall(uuid);
                if (actionList['code'] == 200) {
                  showCupertinoAlertDialog(actionList['data']);
                } else {
                  showToast(ctx, "暂无权限", true);
                }
              }
              if (index == 1) {
                var actionList = await IssuesApi.viewCall(uuid);
                if (actionList['code'] == 200) {
                  _makePhoneCall(actionList['data']);
                } else {
                  showToast(ctx, "暂无权限", true);
                }
              }
            });
          }));

  Widget _buildConnectButton() {
    return FeedbackWidget(
      onPressed: () async {
        if (canEdit == 1) {
          var d = await commentDialog(context, connectStatus, userDetail);
          if (d != null) {
            if (d == true) {
              setState(() {
                showBaseControl = false;
                showEduControl = false;
                showMarriageControl = false;
                showSimilarControl = false;
                showSelectControl = false;
                showPhotoControl = false;
                showConnectControl = true;
                showAppointControl = false;
                showActionControl = false;
                showCallControl = false;
              });
            }
          }
        } else {
          showToastRed(context, "暂无权限", true);
        }
      },
      child: Padding(
        padding: EdgeInsets.only(right: 20.0, top: 10.h),
        child: Container(
          width: 60.h,
          height: 60.h,
          margin: EdgeInsets.fromLTRB(10.w, 5.h, 5.w, 0.h),
          child: Lottie.asset('assets/packages/lottie_flutter/chat.json'),
        ),
      ),
    );
  }

  showBottomAlert(BuildContext context, confirmCallback, String title,
      String option1, String option2) {
    showCupertinoModalPopup(
        context: context,
        builder: (context) {
          return BottomCustomAlterWidget(
              confirmCallback, title, option1, option2);
        });
  }

  void showCupertinoAlertDialog(String mobile) {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return CupertinoAlertDialog(
            title: Text("手机号码"),
            content: Column(
              children: <Widget>[
                SizedBox(
                  height: 10,
                ),
                Align(
                  child: Text(mobile),
                  alignment: Alignment(0, 0),
                ),
              ],
            ),
            actions: <Widget>[
              CupertinoDialogAction(
                child: Text("取消"),
                onPressed: () {
                  Navigator.pop(context);
                  print("取消");
                },
              ),
              CupertinoDialogAction(
                child: Text("复制"),
                onPressed: () {
                  Clipboard.setData(ClipboardData(text: mobile));
                  showToast(context, "复制成功", true);
                  Navigator.pop(context);
                  print("确定");
                },
              ),
            ],
          );
        });
  }

  final List<int> colors = Cons.tabColors;

  Future<bool> _whenPop(BuildContext context) async {
    if (Scaffold.of(context).isEndDrawerOpen) return true;
    return true;
  }

  List<Widget> _listViewConnectList(List<dynamic> connectList) {
    return connectList
        .map((e) => item_connect(
            context,
            e['username'],
            e['connect_time'] == null ? "" : e['connect_time'],
            e['connect_message'],
            e['subscribe_time'] == null ? "" : e['subscribe_time'],
            e['connect_status'].toString(),
            e['connect_type'].toString(),userDetail['role_id']))
        .toList();
  }

  List<Widget> _listViewAppointList(List<dynamic> connectList) {
    return connectList
        .map((e) => item_appoint(
            context,
            e['username'],
            e['other_name'] == null ? "" : e['other_name'],
            e['appointment_address'],
            e['appointment_time'] == null ? "" : e['appointment_time'],
            e['can_write'].toString(),
            e['remark'].toString(),
            e['feedback1'].toString(),e["other_id"].toString()))
        .toList();
  }

  List<Widget> _listViewActionList(List<dynamic> connectList) {
    return connectList
        .map((e) => itemAction(
            context,
            e['username'],
            e['title'] == null ? "" : e['title'],
            e['content'] == null ? "" : e['content'],
            e['created_at'].toString()))
        .toList();
  }

  List<Widget> _listViewCallList(List<dynamic> connectList) {
    return connectList
        .map((e) => itemCall(context, e['username'], e['count'].toString(),
            e['updated_at'].toString()))
        .toList();
  }

  Widget _buildDetail(BuildContext context, DetailState state) {
    if (state is DetailWithData) {
      return _buildStateDetail(context, state.userdetails, state.connectList,
          state.appointList, state.actionList, state.callList);
    }
    if (state is DetailLoading) {}
    return Container(
      child: Container(
          padding: EdgeInsets.only(top: ScreenUtil().screenHeight * 0.2),
          child: Column(
            children: [
              SizedBox(
                height: 0.h,
              ),
              Lottie.asset(
                  'assets/packages/lottie_flutter/890-loading-animation.json'),
            ],
          )),
    );
  }

  Widget _buildStateDetail(
      BuildContext context,
      Map<String, dynamic> userDetails,
      Map<String, dynamic> connectLists,
      Map<String, dynamic> appointLists,
      Map<String, dynamic> actionLists,
      Map<String, dynamic> callLists) {
    void callSetState(String tag, bool value) {
      setState(() {
        if (tag == "base") {
          showBaseControl = value;
          showEduControl = false;
          showMarriageControl = false;
          showSimilarControl = false;
          showSelectControl = false;
          showPhotoControl = false;
          showConnectControl = false;
          showAppointControl = false;
          showActionControl = false;
          showCallControl = false;
        }
        if (tag == "education") {
          showBaseControl = false;
          showEduControl = value;
          showMarriageControl = false;
          showSimilarControl = false;
          showSelectControl = false;
          showPhotoControl = false;
          showConnectControl = false;
          showAppointControl = false;
          showActionControl = false;
          showCallControl = false;
        }
        if (tag == "marriage") {
          showBaseControl = false;
          showEduControl = false;
          showMarriageControl = value;
          showSimilarControl = false;
          showSelectControl = false;
          showPhotoControl = false;
          showConnectControl = false;
          showAppointControl = false;
          showActionControl = false;
          showCallControl = false;
        }
        if (tag == "similar") {
          showBaseControl = false;
          showEduControl = false;
          showMarriageControl = false;
          showSimilarControl = value;
          showSelectControl = false;
          showPhotoControl = false;
          showConnectControl = false;
          showAppointControl = false;
          showActionControl = false;
          showCallControl = false;
        }
        if (tag == "select") {
          showBaseControl = false;
          showEduControl = false;
          showMarriageControl = false;
          showSimilarControl = false;
          showSelectControl = value;
          showPhotoControl = false;
          showConnectControl = false;
          showAppointControl = false;
          showActionControl = false;
          showCallControl = false;
        }
        if (tag == "photo") {
          showBaseControl = false;
          showEduControl = false;
          showMarriageControl = false;
          showSimilarControl = false;
          showSelectControl = false;
          showPhotoControl = value;
          showConnectControl = false;
          showAppointControl = false;
          showActionControl = false;
          showCallControl = false;
        }
        if (tag == "connect") {
          showBaseControl = false;
          showEduControl = false;
          showMarriageControl = false;
          showSimilarControl = false;
          showSelectControl = false;
          showPhotoControl = false;
          showConnectControl = value;
          showAppointControl = false;
          showActionControl = false;
          showCallControl = false;
        }
        if (tag == "appoint") {
          showBaseControl = false;
          showEduControl = false;
          showMarriageControl = false;
          showSimilarControl = false;
          showSelectControl = false;
          showPhotoControl = false;
          showConnectControl = false;
          showAppointControl = value;
          showActionControl = false;
          showCallControl = false;
        }
        if (tag == "action") {
          showBaseControl = false;
          showEduControl = false;
          showMarriageControl = false;
          showSimilarControl = false;
          showSelectControl = false;
          showPhotoControl = false;
          showConnectControl = false;
          showAppointControl = false;
          showActionControl = value;
          showCallControl = false;
        }
        if (tag == "call") {
          showBaseControl = false;
          showEduControl = false;
          showMarriageControl = false;
          showSimilarControl = false;
          showSelectControl = false;
          showPhotoControl = false;
          showConnectControl = false;
          showAppointControl = false;
          showActionControl = false;
          showCallControl = value;
        }
      });
    }

    var info = userDetails['info'];
    var demand = userDetails['demand'];
    canEdit = userDetails['can_edit'];
    call = info['mobile'];
    uuid = info['uuid'];
    status = info['status'];

    userDetail = info;
    List<dynamic> connectList =connectLists==null?[]: connectLists['data'];
    List<dynamic> appointList = appointLists==null?[]:appointLists['data'];
    List<dynamic> actionList = actionLists==null?[]:actionLists['data'];
    List<dynamic> callList = callLists==null?[]:callLists['data'];
    if (connectList.length > 0) {
      Map<String, dynamic> e = connectList.first;
      if (e != null) connectStatus = e['connect_status'];
    }
    List<Widget> connectListView = _listViewConnectList(connectList);
    List<Widget> appointListView = _listViewAppointList(appointList);
    List<Widget> actionListView = _listViewActionList(actionList);
    List<Widget> callListView = _listViewCallList(callList);

    //String level = getLevel(info['status']);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        buildBase(
            context, info, canEdit, showBaseControl, callSetState, "base"),
        buildEdu(
            context, info, canEdit, showEduControl, callSetState, "education"),
        buildMarriage(context, info, canEdit, showMarriageControl, callSetState,
            "marriage"),
        buildSimilar(context, info, canEdit, showSimilarControl, callSetState,
            "similar"),
        buildUserSelect(context, demand, canEdit, showSelectControl,
            info['uuid'], callSetState, "select"),
        buildPhoto(context, userDetails, canEdit, showPhotoControl,
            callSetState, "photo"),
        buildConnect(
            connectListView, showConnectControl, callSetState, "connect"),
        buildAppoint(
            appointListView, showAppointControl, callSetState, "appoint"),
        buildAction(actionListView, showActionControl, callSetState, "action"),
        buildCall(callListView, showCallControl, callSetState, "call"),
      ],
    );
  }

  Widget _buildTitle(BuildContext context, DetailState state) {
    if (state is DetailWithData) {
      return header(context,state.userdetails);
    }
    return Container();
  }




}
