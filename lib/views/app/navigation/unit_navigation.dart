import 'dart:math';
import 'dart:math' as math;
import 'dart:io';
import 'package:flutter_2d_amap/flutter_2d_amap.dart';
import 'package:flutter_geen/app/api/issues_api.dart';
import 'package:flutter_geen/storage/app_storage.dart';
import 'package:flutter_geen/views/pages/about/bottom_sheet.dart';
import 'package:flutter_geen/views/pages/about/person_center_page.dart';
import 'package:flutter_geen/views/pages/home/flow_page.dart';
import 'package:flutter_geen/views/app/navigation/unit_bottom_bar.dart';
import 'package:flutter_geen/views/pages/chat/conversation_list.dart';
import 'package:flutter_geen/views/pages/chat/view/util/ImMessage.dart';
import 'package:flutter_geen/views/pages/home/home_page.dart';
import 'package:flutter_geen/app/res/cons.dart';
import 'package:flutter_geen/app/router.dart';
import 'package:flutter_geen/blocs/bloc_exp.dart';
import 'package:flutter_geen/components/permanent/overlay_tool_wrapper.dart';
import 'package:flutter_geen/storage/dao/local_storage.dart';
import 'package:flt_im_plugin/flt_im_plugin.dart';
import 'package:flt_im_plugin/value_util.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_nfc_reader/flutter_nfc_reader.dart';
import 'package:flutter_geen/views/component/xupdate.dart';
import 'package:flutter_geen/views/component/back_top_window.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:package_info/package_info.dart';
import 'package:umeng_analytics_push/umeng_analytics_push.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_geen/app/utils/key_utils.dart';
/// 说明: 主题结构 左右滑页 + 底部导航栏
class UnitNavigation extends StatefulWidget {
  @override
  _UnitNavigationState createState() => _UnitNavigationState();
}

class _UnitNavigationState extends State<UnitNavigation>
    with SingleTickerProviderStateMixin {
  FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin;
  PageController _controller; //页面控制器，初始0
  //List<Conversion> conversions = [];
  String debugLable = 'Unknown';
  FltImPlugin im = FltImPlugin();
  static String tfSender = "";
  CheckUpdate checkUpdate = CheckUpdate();
  static const double offset = 23.0;

  @override
  void initState() {
    super.initState();

    initNav();
  }

  Future<void> initNav() async {
    FltImPlugin()
        .init(host: "mm.3dsqq.com", apiURL: "http://mm.3dsqq.com:8000");
    _controller = PageController();
    tfSender = ValueUtil.toStr(2);
    var ss = await LocalStorage.get("im_token");
    var memberId = await LocalStorage.get("memberId");
    if (memberId != "" && memberId != null) {
      tfSender = memberId.toString();
    }
    if (ss == "" || ss == null) {
      login(success: () {
        listenNative();
        BlocProvider.of<ChatBloc>(context).add(EventNewMessage());
      });
    } else {
      loginByToken(ss, success: () {
        listenNative();
        BlocProvider.of<ChatBloc>(context).add(EventNewMessage());
      });
    }
    var count = 0;
    BlocProvider.of<GlobalBloc>(context).add(EventSetMemberId(tfSender));
    BlocProvider.of<GlobalBloc>(context).add(EventSetBar3(count));
    // Map response = await im.getConversations();
    // var conversions = response["data"];
    // conversions.map((e) {
    //   if (e['unreadCount'] > 0){
    //     count=count+e['unreadCount'];
    //   }
    // }).toList();
    //BlocProvider.of<GlobalBloc>(context).add(EventSetBar3(1));
    var saveMode = BlocProvider.of<GlobalBloc>(context).state.showBackGround;
    if (saveMode) {
      final sp = AppStorage().sp;
      var mode = await sp;
      int modes = mode.getInt("currentPhotoMode");
      BlocProvider.of<GlobalBloc>(context).add(EventSetIndexMode(modes));
    }

    FlutterNfcReader.onTagDiscovered().listen((onData) {
      (onData.id);
      // print(onData.content);
      BlocProvider.of<GlobalBloc>(context).add(EventSetCreditId(onData.id));
      _userDetail(context);
    });

      var UmengInit = await LocalStorage.get("UmengInit");
      var UmengInits = UmengInit.toString();
      if (UmengInits != "push_init_ok") {
        // await UmengAnalyticsPush.initUmeng(false, true);
        // var token = await UmengAnalyticsPush.deviceToken();
        // print("push_token:"+token);
        // if (token != "" && token != null) {
        //   IssuesApi.addToken(token);
        // }
        Flutter2dAMap.updatePrivacy(true);
        Flutter2dAMap.setApiKey(
          iOSKey: flutter2dAMapIOSKey,
          webKey: flutter2dAMapWebKey,
        );
      } else {
        try{
          var token = await UmengAnalyticsPush.deviceToken();
          print("push_token:"+token);
          if (token != "" && token != null) {
            IssuesApi.addToken(token);
          }
        }catch(e){
          print(e);
        }


      }
    Future.delayed(Duration(seconds: 5)).then((e) async {
      var result = await IssuesApi.getUserStatus();
      if (result['code'] == 402) {
        var ss = await LocalStorage.remove("im_token");
        var memberId = await LocalStorage.remove("memberId");
        var sss = await LocalStorage.remove("token");
        if (!mounted) return;
        Navigator.pushNamed(context, UnitRouter.login);
        Navigator.of(context).pushNamedAndRemoveUntil(
          UnitRouter.login,
              (route) => route == null,
        );
      }


    });

    Future.delayed(Duration(seconds: 1)).then((e) async {
      _checkUpdateVersion();
    });
  }

  @override
  void dispose() {
    _controller.dispose(); //释放控制器
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
        onWillPop: AndroidBackTop.backDesktop, //页面将要消失时，调用原生的返回桌面方法
        child: BlocListener<HomeBloc, HomeState>(listener: (ctx, state) {
          if (state is GetCreditIdSuccess) {}
        }, child: BlocBuilder<HomeBloc, HomeState>(
          builder: (_, state) {
            final Color color =
                BlocProvider.of<HomeBloc>(context).activeHomeColor;
            final String id =
                BlocProvider.of<GlobalBloc>(context).state.memberId;

            return Scaffold(
                //drawer: HomeDrawer(),
                //endDrawer: HomeRightDrawer(),
                floatingActionButtonLocation:
                    const _CenterDockedFloatingActionButtonLocation(offset),
                floatingActionButton: _buildSearchButton(color),
                body: wrapOverlayTool(
                  child: PageView(
                    physics: const NeverScrollableScrollPhysics(),
                    controller: _controller,
                    children: <Widget>[
                      HomePage(),
                      FlowPage(),
                      ImConversationListPage(
                        memberId: id,
                      ),
                      MinePage(),
                    ],
                  ),
                ),
                bottomNavigationBar: UnitBottomBar(
                    color: Colors.white,
                    itemData: Cons.ICONS_MAP,
                    onItemClick: _onTapNav));
          },
        )));
  }

// Platform messages are asynchronous, so we initialize in an async method.
  Future<void> initPlatformState() async {
    String platformVersion;
    // If the widget was removed from the tree while the asynchronous platform
    // message was in flight, we want to discard the reply rather than calling
    // setState to update our non-existent appearance.
    if (!mounted) return;

    setState(() {
      debugLable = platformVersion;
    });
  }

  _userDetail(BuildContext context) {
    // showDialog(
    //     context: context,
    //     builder: (ctx) => UserDetailDialog()
    //
    // );
  }

  login({void Function() success}) async {
    if (tfSender == null || tfSender.length == 0) {
      print('发送用户id 必须填写');
      return;
    }
    final res = await FltImPlugin().login(uid: tfSender);
    print(res);
    int code = ValueUtil.toInt(res['code']);
    if (code == 0) {
      success?.call();
      tfSender = null;
    } else {
      String message = ValueUtil.toStr(res['message']);
      print(message);
    }
  }

  Future<String> getImToken() async {
    var ss = await LocalStorage.get("token");
    var sss = ss.toString();
    return sss;
  }

  loginByToken(String token, {void Function() success}) async {
    if (tfSender == null || tfSender.length == 0) {
      print('发送用户id 必须填写');
      return;
    }
    final res = await FltImPlugin().login(uid: tfSender, token: token);
    print(res);
    int code = ValueUtil.toInt(res['code']);
    if (code == 0) {
      success?.call();
      tfSender = null;
    } else {
      String message = ValueUtil.toStr(res['message']);
      print(message);
    }
  }

  listenNative() {
    im.onBroadcast.listen((event) {
      NativeResponse response = NativeResponse.fromMap(event);
      Map data = response.data;
      String type = ValueUtil.toStr(data['type']);
      var result = data['result'];
      if (response.code == 0) {
        if (type == 'onNewMessage') {
          //loadConversions();
          int error = ValueUtil.toInt(data['error']);
          onNewMessage(result, error);
        } else if (type == 'onNewGroupMessage') {
          //loadConversions();
          int error = ValueUtil.toInt(data['error']);
          onNewGroupMessage(result, error);
        } else if (type == 'onGroupNotification') {
          onGroupNotification(result);
        } else if (type == 'deletePeerMessageSuccess') {
          deletePeerMessageSuccess(result, data['id']);
        } else if (type == 'onSystemMessage') {
          //loadConversions();
        } else if (type == 'onPeerMessageACK') {
          int error = ValueUtil.toInt(data['error']);
          onPeerMessageACK(result, error);
        } else if (type == 'onPeerMessage') {
          onPeerMessage(result);
        } else if (type == 'onPeerSecretMessage') {
          onPeerSecretMessage(result);
        } else if (type == 'onGroupMessage') {
          onGroupMessage(result);
        } else if (type == 'onGroupMessageACK') {
          onGroupMessageACK(result);
        } else if (type == 'onImageUploadSuccess') {
          String url = ValueUtil.toStr(data['URL']);
          onImageUploadSuccess(result, url);
        } else if (type == 'onAudioDownloadSuccess') {
          onAudioDownloadSuccess(result);
        } else if (type == 'onAudioDownloadFail') {
          onAudioDownloadFail(result);
        } else if (type == 'onPeerMessageFailure') {
          onPeerMessageFailure(result);
        } else if (type == 'onAudioUploadSuccess') {
          String url = ValueUtil.toStr(data['URL']);
          onAudioUploadSuccess(result, url);
        } else if (type == 'onAudioUploadFail') {
          onAudioUploadFail(result);
        } else if (type == 'onImageUploadFail') {
          onImageUploadFail(result);
        } else if (type == 'onVideoUploadSuccess') {
          String url = ValueUtil.toStr(data['URL']);
          String thumbnailURL = ValueUtil.toStr(data['thumbnailURL']);
          onVideoUploadSuccess(result, url, thumbnailURL);
        } else if (type == 'onVideoUploadFail') {
          onVideoUploadFail(result);
        } else {
          print("onConnect:" + result.toString());
        }
      } else {
        print(response.message);
      }
    });
  }

  // OverlayToolWrapper 在此 添加 因为Builder外层: 因为需要 Scaffold 的上下文，打开左右滑页
  Widget wrapOverlayTool({Widget child}) {
    return Builder(
        builder: (ctx) => OverlayToolWrapper(
              child: child,
            ));
  }

  Widget _buildSearchButton(Color color) {
    return GestureDetector(
        // elevation: 5,
        // disabledElevation: 12.0,
        //backgroundColor: Colors.white,

        child: Container(
          height: 70,
          width: 70,
          child: Image.asset("assets/packages/images/tab_match.webp"),
        ),
        onTap: () {
          //showBottomPop(context);
          showCupertinoModalBottomSheet(
            expand: true,
            bounce: false,
            context: context,
            duration: const Duration(milliseconds: 200),
            backgroundColor: Colors.white,
            builder: (context) => PhotoShareBottomSheet(),
          );
        }
        //Navigator.of(context).pushNamed(UnitRouter.search),
        );
  }

  _onTapNav(int index) {
    _controller.jumpToPage(index);
    if (index == 1) {
      //BlocProvider.of<CollectBloc>(context).add(EventSetCollectData());
    }
  }

  // 系统通知栏消息推送
  void _showNotification(String title, String body) async {
    flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();
    var initializationSettingsAndroid =
        AndroidInitializationSettings('ic_launcher');
    var initializationSettingsIOS = IOSInitializationSettings(
        onDidReceiveLocalNotification:
            (int id, String title, String body, String payload) async => null);
    var initializationSettings = InitializationSettings(
        android: initializationSettingsAndroid, iOS: initializationSettingsIOS);

    flutterLocalNotificationsPlugin.initialize(initializationSettings,
        onSelectNotification: (String payload) async {
      if (payload != null) {
        print('notification payload: ' + payload);
      }
      // 点击通知栏跳转的页面(暂为空白)
      var memberId = await LocalStorage.get("memberId");
      Navigator.pushNamed(context, UnitRouter.chat_list, arguments: memberId);
    });

    var androidPlatformChannelSpecifics = AndroidNotificationDetails(
      '0',
      title,
      body,
      importance: Importance.max,
      priority: Priority.high,
      ticker: 'ticker',
    );
    var iOSPlatformChannelSpecifics = IOSNotificationDetails();
    var platformChannelSpecifics = NotificationDetails(
        android: androidPlatformChannelSpecifics,
        iOS: iOSPlatformChannelSpecifics);
    await flutterLocalNotificationsPlugin.show(
        randomBit(8, type: 'num'), title, body, platformChannelSpecifics,
        payload: body);
  }

  // 生成随机串
  static dynamic randomBit(int len, {String type}) {
    String character = type == 'num'
        ? '0123456789'
        : 'qwertyuiopasdfghjklzxcvbnmQWERTYUIOPASDFGHJKLZXCVBNM';
    String left = '';
    for (var i = 0; i < len; i++) {
      left = left + character[Random().nextInt(character.length)];
    }
    return type == 'num' ? int.parse(left) : left;
  }

  // 获取版本
  Future<dynamic> initPackageInfo() async {
    PackageInfo packageInfo = await PackageInfo.fromPlatform();
    // version = packageInfo.version;
  }

  // 检查是否需要版本更新
  void _checkUpdateVersion() async {
    await initPackageInfo();
    try {
      var response =
          await IssuesApi.getVersion("app/version/detail?", 'mobile', 'json');
      if (response["code"] != 0) {
        //setState(() {
        // versionData = response["data"];
        //});
        Map<String, dynamic> versionData = {};
        versionData['isForce'] = response["data"]['isForce'];
        versionData['hasUpdate'] = true;
        versionData['isIgnorable'] = false;
        versionData['versionCode'] = response["data"]['versionCode'];
        versionData['versionName'] = response["data"]['versionName'];
        versionData['updateLog'] = response["data"]['updateLog'];
        versionData['apkUrl'] = response["data"]['apkUrl'];
        versionData['apkSize'] = response["data"]['apkSize'];
        // 后台返回的版本号是带小数点的（2.8.1）所以去除小数点用于做对比
        var targetVersion = response["data"]['versionCode'].replaceAll(
            '.', ''); //response["data"]["versionCode"].replaceAll('.', '');
        var version = "120";
        PackageInfo packageInfo = await PackageInfo.fromPlatform();
        String versions = packageInfo.version;//版本号
        var appVersion = versions.replaceAll(
            '.', '');
        // 当前App运行版本
        var currentVersion = appVersion; //.replaceAll('.', '');
        if (int.parse(targetVersion) > int.parse(currentVersion)) {
          if (Platform.isAndroid) {
            // 安卓弹窗提示本地下载， 交由flutter_xupdate 处理，不用我们干嘛。
            await checkUpdate.initXUpdate();
            checkUpdate.checkUpdateByUpdateEntity(
                versionData); // flutter_xupdate 自定义JSON 方式，
          } else if (Platform.isIOS) {
            // IOS 跳转 AppStore
            //showIOSDialog(); // 弹出ios提示更新框
          }
        }
      }
    } catch (e) {
      print(e);
    }
  }

  void onPeerMessageACK(result, int error) {
    Map<String, dynamic> message = Map<String, dynamic>.from(result);
    //EventBusUtil.fire(PeerRecAckEvent(message['content']));
    Map<String, dynamic> m = Map<String, dynamic>.from(result);

    BlocProvider.of<PeerBloc>(context).add(EventReceiveNewMessageAck(m));
  }

  onPeerMessageFailure(Map result) {
    // IMMessage
  }

  /// OutboxObserver
  onImageUploadSuccess(Map result, String url) {
    print(url);

    ///IMessage
  }

  onAudioUploadSuccess(Map result, String url) {
    /// IMessage
  }

  onAudioUploadFail(Map result) {
    //IMessage
  }

  onImageUploadFail(Map result) {
    // IMessage
  }

  onVideoUploadSuccess(Map result, url, thumbnailURL) {}

  onVideoUploadFail(Map result) {}

  /// AudioDownloaderObserver
  onAudioDownloadSuccess(Map result) {
    // IMessage
  }

  onAudioDownloadFail(Map result) {
    //IMessage
  }

  void onPeerMessage(result) {
    Map<String, dynamic> message = Map<String, dynamic>.from(result);
    String title = "通知";
    String content = "消息";
    var type = message['type'];
    if (type == "MESSAGE_TEXT") {
      title = "通知";
      content = message['content']['text'];
    } else {
      title = "通知";
      content = '聊天消息';
    }

    //_showNotification(title,content);
    BlocProvider.of<PeerBloc>(context).add(EventReceiveNewMessage(message));
  }

  void onPeerSecretMessage(result) {}

  void onGroupMessage(result) {
    Map<String, dynamic> message = Map<String, dynamic>.from(result);
    String title = "通知";
    String content = "消息";
    var type = message['type'];
    if (type == "MESSAGE_TEXT") {
      title = "通知";
      content = message['content']['text'];
    } else {
      title = "通知";
      content = '聊天消息';
    }

    //_showNotification(title,content);
    BlocProvider.of<GroupBloc>(context)
        .add(EventGroupReceiveNewMessage(message));
  }

  void onGroupMessageACK(result) {
    Map<String, dynamic> message = Map<String, dynamic>.from(result);
    String title = "通知";
    String content = "消息";
    var type = message['type'];
    if (type == "MESSAGE_TEXT") {
      title = "通知";
      content = message['content']['text'];
    } else {
      title = "通知";
      content = '聊天消息';
    }

    //_showNotification(title,content);
    BlocProvider.of<GroupBloc>(context)
        .add(EventGroupReceiveNewMessageAck(message));
  }

  void onNewMessage(result, int error) async {
    var count = 1;
    //Map response = await im.getConversations();
    //var  conversions = response["data"];
    // conversions.map((e) {
    //   if (e['unreadCount'] > 0){
    //     count=count+e['unreadCount'];
    //   }
    // }).toList();

    BlocProvider.of<GlobalBloc>(context).add(EventSetBar3(count));
    BlocProvider.of<ChatBloc>(context).add(EventNewMessage());
  }

  void onNewGroupMessage(result, int error) async {
    var count = 1;
    print(result);
    //Map response = await im.getConversations();
    //var  conversions = response["data"];
    // conversions.map((e) {
    //   if (e['unreadCount'] > 0){
    //     count=count+e['unreadCount'];
    //   }
    // }).toList();

    BlocProvider.of<GlobalBloc>(context).add(EventSetBar3(count));
    BlocProvider.of<ChatBloc>(context).add(EventNewMessage());
  }

  void onGroupNotification(result) async {
    print(result);
    Map<String, dynamic> message = Map<String, dynamic>.from(result);
    BlocProvider.of<GroupBloc>(context)
        .add(EventGroupReceiveNewMessage(message));
    onNewGroupMessage(result, 0);
  }

  void deletePeerMessageSuccess(result, id) async {
    print(result);
    BlocProvider.of<PeerBloc>(context).add(EventDeleteMessage(id));
    onNewMessage(result, 0);
  }
}

abstract class _DockedFloatingActionButtonLocation
    extends FloatingActionButtonLocation {
  const _DockedFloatingActionButtonLocation();

  @protected
  double getDockedY(ScaffoldPrelayoutGeometry scaffoldGeometry) {
    final double contentBottom = scaffoldGeometry.contentBottom;
    final double bottomSheetHeight = scaffoldGeometry.bottomSheetSize.height;
    final double fabHeight = scaffoldGeometry.floatingActionButtonSize.height;
    final double snackBarHeight = scaffoldGeometry.snackBarSize.height;

    double fabY = contentBottom - fabHeight / 2.0;
    if (snackBarHeight > 0.0)
      fabY = math.min(
          fabY,
          contentBottom -
              snackBarHeight -
              fabHeight -
              kFloatingActionButtonMargin);
    if (bottomSheetHeight > 0.0)
      fabY =
          math.min(fabY, contentBottom - bottomSheetHeight - fabHeight / 2.0);

    final double maxFabY = scaffoldGeometry.scaffoldSize.height - fabHeight;
    return math.min(maxFabY, fabY);
  }
}

/// offset值用来控制偏移量。
/// 在bottomNavigationBar中，0坐标为控件左上角，
/// 因此offset为正时，表示往下偏移；offset为负时，表示往上偏移
class _CenterDockedFloatingActionButtonLocation
    extends _DockedFloatingActionButtonLocation {
  const _CenterDockedFloatingActionButtonLocation(this.offset);

  final double offset;

  @override
  Offset getOffset(ScaffoldPrelayoutGeometry scaffoldGeometry) {
    final double fabX = (scaffoldGeometry.scaffoldSize.width -
            scaffoldGeometry.floatingActionButtonSize.width) /
        2.0;
    return Offset(fabX, getDockedY(scaffoldGeometry) + offset);
  }

  @override
  String toString() => 'FloatingActionButtonLocation.centerDocked';
}
