
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_geen/app/router.dart';
import 'package:flutter_geen/storage/dao/local_storage.dart';
import 'package:flutter_geen/views/dialogs/CustomDialog.dart';
import 'unit_paint.dart';
import 'package:jverify/jverify.dart';
/// 说明: app 闪屏页

class UnitSplash extends StatefulWidget {
  final double size;

  UnitSplash({this.size = 200});

  @override
  _UnitSplashState createState() => _UnitSplashState();
}

class _UnitSplashState extends State<UnitSplash> with TickerProviderStateMixin {
  AnimationController _controller;
  double _factor;
  Animation _curveAnim;

  bool _animEnd = false;
  bool _getPreLoginSuccess = false;
  /// 统一 key
  final String f_result_key = "result";
  /// 错误码
  final  String  f_code_key = "code";
  /// 回调的提示信息，统一返回 flutter 为 message
  final  String  f_msg_key  = "message";
  /// 运营商信息
  final  String  f_opr_key  = "operator";


  String _platformVersion = 'Unknown';
  String _result = "token=";
  var controllerPHone = new TextEditingController();
  final Jverify jverify = new Jverify();
  bool _loading = false;
  String _token;


  @override
  void initState() {
    SystemUiOverlayStyle systemUiOverlayStyle = SystemUiOverlayStyle(statusBarColor: Colors.transparent);
    SystemChrome.setSystemUIOverlayStyle(systemUiOverlayStyle);

    _controller =
        AnimationController(duration: Duration(milliseconds: 1000), vsync: this)
          ..addListener(_listenAnimation)
          ..addStatusListener(_listenStatus)
          ..forward();

    _curveAnim = CurvedAnimation(parent: _controller, curve: Curves.fastOutSlowIn);
    super.initState();
    initPlatformState();
  }

  void _listenAnimation() {
    setState(() {
      return _factor = _curveAnim.value;
    });
  }
  Future<void> initPlatformState() async {
    String platformVersion;

    // 初始化 SDK 之前添加监听
    jverify.addSDKSetupCallBackListener((JVSDKSetupEvent event){
      print("receive sdk setup call back event :${event.toMap()}");

      jverify.isInitSuccess().then((map) {
        bool result = map[f_result_key];
        print(_result);
        jverify.checkVerifyEnable().then((map) {
          bool result = map[f_result_key];
          if (result) {
            jverify.preLogin().then((map) {
              print("预取号接口回调：${map.toString()}");
              int code = map[f_code_key];
              String message = map[f_msg_key];
              _getPreLoginSuccess=true;

            });
          }else {

              _result = "[2016],msg = 当前网络环境不支持认证";
               print(_result);
          }
        });


      });

    });

    jverify.setDebugMode(true); // 打开调试模式
    jverify.setup(
        appKey: "334db8731c1e38a9c7c3f512",//"你自己应用的 AppKey",
        channel: "devloper-default"); // 初始化sdk,  appKey 和 channel 只对ios设置有效
    // If the widget was removed from the tree while the asynchronous platform
    // message was in flight, we want to discard the reply rather than calling
    // setState to update our non-existent appearance.
    if (!mounted) return;
    /// 授权页面点击时间监听
    jverify.addAuthPageEventListener((JVAuthPageEvent event) {
      print("receive auth page event :${event.toMap()}");
    });
  }

  void _listenStatus(AnimationStatus status) {
    if (status == AnimationStatus.completed) {
      setState(() {
        _animEnd = true;
        Future.delayed(Duration(milliseconds: 1000)).then((e) async {
          var ss = await LocalStorage.get("token");
          var sss =ss.toString();
          if(sss == "" || ss == null || ss == "null"){

            if(_getPreLoginSuccess){
              loginAuth();
            }else{
                Navigator.of(context).pushReplacementNamed(UnitRouter.login);
            }

          } else{
            //LocalStorage.save("token", '');
            var agree = await LocalStorage.get("agree");
            var agrees =agree.toString();
            if(agrees == "1"){
              Navigator.of(context).pushReplacementNamed(UnitRouter.nav);

            } else{
              //LocalStorage.save("token", '');
              showDialog(context: context, builder: (ctx) => _buildDialog());
            }

          }

        });
      });
    }
  }
  /// SDK 请求授权一键登录
  void loginAuth() {

    jverify.checkVerifyEnable().then((map) {
      bool result = map[f_result_key];
      if (result) {

        final screenSize = MediaQuery.of(context).size;
        final screenWidth = screenSize.width;
        final screenHeight = screenSize.height;
        bool isiOS = Platform.isIOS;

        /// 自定义授权的 UI 界面，以下设置的图片必须添加到资源文件里，
        /// android项目将图片存放至drawable文件夹下，可使用图片选择器的文件名,例如：btn_login.xml,入参为"btn_login"。
        /// ios项目存放在 Assets.xcassets。
        ///
        JVUIConfig uiConfig = JVUIConfig();
        uiConfig.authBackgroundImage = "onekey_bg";

        uiConfig.navHidden = false;
        uiConfig.navColor = Colors.blue.value;
        uiConfig.navText = "";
        uiConfig.navTextColor = Colors.blue.value;
        uiConfig.navReturnImgPath = "";//图片必须存在

        uiConfig.logoWidth = 320;
        uiConfig.logoHeight = 242;
        //uiConfig.logoOffsetX = isiOS ? 0 : null;//(screenWidth/2 - uiConfig.logoWidth/2).toInt();
        uiConfig.logoOffsetY = 0;
        uiConfig.logoVerticalLayoutItem = JVIOSLayoutItem.ItemSuper;
        uiConfig.logoHidden = false;
        uiConfig.logoImgPath = "logo";

        uiConfig.numberFieldWidth = 200;
        uiConfig.numberFieldHeight = 40 ;

        //uiConfig.numFieldOffsetX = isiOS ? 0 : null;//(screenWidth/2 - uiConfig.numberFieldWidth/2).toInt();
        uiConfig.numFieldOffsetY = isiOS ? 20 : 320;
        uiConfig.numberVerticalLayoutItem = JVIOSLayoutItem.ItemLogo;
        uiConfig.numberColor = Colors.black.value;
        uiConfig.numberSize = 22;

        uiConfig.sloganOffsetY = isiOS ? 20 : 500;
        uiConfig.sloganVerticalLayoutItem = JVIOSLayoutItem.ItemNumber;
        uiConfig.sloganTextColor = Colors.white.value;
        uiConfig.sloganTextSize = 22;
//        uiConfig.slogan
        //uiConfig.sloganHidden = 0;

        uiConfig.logBtnWidth = 290;
        uiConfig.logBtnHeight = 45;
        //uiConfig.logBtnOffsetX = isiOS ? 0 : null;//(screenWidth/2 - uiConfig.logBtnWidth/2).toInt();
        uiConfig.logBtnOffsetY = isiOS ? 20 : 380;
        uiConfig.logBtnVerticalLayoutItem = JVIOSLayoutItem.ItemSlogan;
        uiConfig.logBtnText = "本机号码安全登录";
        uiConfig.logBtnTextColor = Colors.white.value;
        uiConfig.logBtnTextSize = 16;
        uiConfig.logBtnBackgroundPath="login_btn_normal";
        uiConfig.loginBtnNormalImage = "login_btn_normal";//图片必须存在
        uiConfig.loginBtnPressedImage = "login_btn_press";//图片必须存在
        uiConfig.loginBtnUnableImage = "login_btn_unable";//图片必须存在

        uiConfig.privacyHintToast = true;//only android 设置隐私条款不选中时点击登录按钮默认显示toast。

        uiConfig.privacyState = true;//设置默认勾选
        uiConfig.privacyCheckboxSize = 20;
        uiConfig.checkedImgPath = "check_images";//图片必须存在
        uiConfig.uncheckedImgPath = "uncheck_images";//图片必须存在
        uiConfig.privacyCheckboxInCenter = true;
        //uiConfig.privacyCheckboxHidden = false;

        //uiConfig.privacyOffsetX = isiOS ? (20 + uiConfig.privacyCheckboxSize) : null;
        uiConfig.privacyOffsetY = 15;// 距离底部距离
        uiConfig.privacyVerticalLayoutItem = JVIOSLayoutItem.ItemSuper;
        uiConfig.clauseName = "";
        uiConfig.clauseUrl = "http://www.baidu.com";
        uiConfig.clauseBaseColor = Colors.black.value;
        uiConfig.clauseNameTwo = "";
        uiConfig.clauseUrlTwo = "http://www.hao123.com";
        uiConfig.clauseColor = Colors.red.value;
        uiConfig.privacyText = ["同意","","","授权手机号"];
        uiConfig.privacyTextSize = 13;
        //uiConfig.privacyWithBookTitleMark = true;
        //uiConfig.privacyTextCenterGravity = false;
        uiConfig.authStatusBarStyle =  JVIOSBarStyle.StatusBarStyleDarkContent;
        uiConfig.privacyStatusBarStyle = JVIOSBarStyle.StatusBarStyleDefault;
        uiConfig.modelTransitionStyle = JVIOSUIModalTransitionStyle.CrossDissolve;

        uiConfig.statusBarColorWithNav = true;
        uiConfig.virtualButtonTransparent = true;

        uiConfig.privacyStatusBarColorWithNav = true;
        uiConfig.privacyVirtualButtonTransparent = true;

        uiConfig.needStartAnim = true;
        uiConfig.needCloseAnim = true;

        uiConfig.privacyNavColor =  Colors.blue.value;;
        uiConfig.privacyNavTitleTextColor = Colors.white.value;
        uiConfig.privacyNavTitleTextSize = 16;

        uiConfig.privacyNavTitleTitle  ="ios lai le";//only ios
        uiConfig.privacyNavTitleTitle1 = "协议11 web页标题";
        uiConfig.privacyNavTitleTitle2 = "协议22 web页标题";
        uiConfig.privacyNavReturnBtnImage = "return_bgs";//图片必须存在;

        /// 添加自定义的 控件 到授权界面
        List<JVCustomWidget> widgetList = [];
        /// 步骤 1：调用接口设置 UI
        jverify.setCustomAuthorizationView(true, uiConfig, landscapeConfig: uiConfig,widgets: widgetList);

        /// 步骤 2：调用一键登录接口
        /// 方式一：使用同步接口 （如果想使用异步接口，则忽略此步骤，看方式二）
        /// 先，添加 loginAuthSyncApi 接口回调的监听
        jverify.addLoginAuthCallBackListener((event){
          print("通过添加监听，获取到 loginAuthSyncApi 接口返回数据，code=${event.code},message = ${event.message},operator = ${event.operator}");
          Navigator.of(context).pushReplacementNamed(UnitRouter.login);
        });
        /// 再，执行同步的一键登录接口
        jverify.loginAuthSyncApi(autoDismiss: true);
      } else {


        /*
        final String text_widgetId = "jv_add_custom_text";// 标识控件 id
        JVCustomWidget textWidget = JVCustomWidget(text_widgetId, JVCustomWidgetType.textView);
        textWidget.title = "新加 text view 控件";
        textWidget.left = 20;
        textWidget.top = 360 ;
        textWidget.width = 200;
        textWidget.height  = 40;
        textWidget.backgroundColor = Colors.yellow.value;
        textWidget.isShowUnderline = true;
        textWidget.textAlignment = JVTextAlignmentType.center;
        textWidget.isClickEnable = true;
        // 添加点击事件监听
        jverify.addClikWidgetEventListener(text_widgetId, (eventId) {
          print("receive listener - click widget event :$eventId");
          if (text_widgetId == eventId) {
            print("receive listener - 点击【新加 text】");
          }
        });
        widgetList.add(textWidget);
        final String btn_widgetId = "jv_add_custom_button";// 标识控件 id
        JVCustomWidget buttonWidget = JVCustomWidget(btn_widgetId, JVCustomWidgetType.button);
        buttonWidget.title = "新加 button 控件";
        buttonWidget.left = 100;
        buttonWidget.top = 400;
        buttonWidget.width = 150;
        buttonWidget.height  = 40;
        buttonWidget.isShowUnderline = true;
        buttonWidget.backgroundColor = Colors.brown.value;
        //buttonWidget.btnNormalImageName = "";
        //buttonWidget.btnPressedImageName = "";
        //buttonWidget.textAlignment = JVTextAlignmentType.left;
        // 添加点击事件监听
        jverify.addClikWidgetEventListener(btn_widgetId, (eventId) {
          print("receive listener - click widget event :$eventId");
          if (btn_widgetId == eventId) {
            print("receive listener - 点击【新加 button】");
          }
        });
        widgetList.add(buttonWidget);
        */


        /* 弹框模式
        JVPopViewConfig popViewConfig = JVPopViewConfig();
        popViewConfig.width = (screenWidth - 100.0).toInt();
        popViewConfig.height = (screenHeight - 150.0).toInt();
        uiConfig.popViewConfig = popViewConfig;
        */


        /*
        /// 方式二：使用异步接口 （如果想使用异步接口，则忽略此步骤，看方式二）
        /// 先，执行异步的一键登录接口
        jverify.loginAuth(true).then((map) {
          /// 再，在回调里获取 loginAuth 接口异步返回数据（如果是通过添加 JVLoginAuthCallBackListener 监听来获取返回数据，则忽略此步骤）
          int code = map[f_code_key];
          String content = map[f_msg_key];
          String operator = map[f_opr_key];
          setState(() {
            _loading = false;
            _result = "接口异步返回数据：[$code] message = $content";
          });
          print("通过接口异步返回，获取到 loginAuth 接口返回数据，code=$code,message = $content,operator = $operator");
        });
        */

      }
    });
  }

  static Widget _buildDialog() => Dialog(
    backgroundColor: Colors.white,
    elevation: 5,
    shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(10))),
    child: Container(
      width: 50,
      child: DeleteDialog(),
    ),
  );

  @override
  Widget build(BuildContext context) {
    final double winH = MediaQuery.of(context).size.height;
    final double winW = MediaQuery.of(context).size.width;

    return Scaffold(
      body: Stack(
        alignment: Alignment.center,
        children: <Widget>[
          _buildLogo(Colors.blue),
          Container(
            width: winW,
            height: winH,
            child: CustomPaint(
              painter: UnitPainter(factor: _factor),
            ),
          ),
          _buildText(winH, winW),
          _buildHead(),
          _buildPower(),
        ],
      ),
    );
  }

  Widget _buildText(double winH, double winW) {
    final shadowStyle = TextStyle(
      fontSize: 40,
      color: Theme.of(context).primaryColor,
      fontWeight: FontWeight.bold,
      shadows: [
        const Shadow(
          color: Colors.grey,
          offset: Offset(1.0, 1.0),
          blurRadius: 1.0,
        )
      ],
    );

    return Positioned(
      top: winH / 1.4,
      child: AnimatedOpacity(
          duration: const Duration(milliseconds: 600),
          opacity: _animEnd ? 1.0 : 0.0,
          child: Text(
            '鹊桥门店管理系统',
            style: shadowStyle,
          )),
    );
  }

  final colors = [Colors.red, Colors.yellow, Colors.blue];

  Widget _buildLogo(Color primaryColor) {
    return SlideTransition(
      position: Tween<Offset>(
        begin: const Offset(0, 0),
        end: const Offset(0, -1.5),
      ).animate(_controller),
      child: RotationTransition(
          turns: _controller,
          child: ScaleTransition(
            scale: Tween(begin: 2.0, end: 1.0).animate(_controller),
            child: FadeTransition(
                opacity: _controller,
                child: Container(
                  height: 120,
                  child: FlutterLogo(
                    size: 60,
                  ),
                )),
          )),
    );
  }

  Widget _buildHead() => SlideTransition(
      position: Tween<Offset>(
        end: const Offset(0, 0),
        begin: const Offset(0, -5),
      ).animate(_controller),
      child: Container(
        height: 45,
        width: 45,
        child: Image.asset('assets/images/ic_launcher.png'),
      ));

  Widget _buildPower() => Positioned(
        bottom: 30,
        right: 30,
        child: AnimatedOpacity(
            duration: const Duration(milliseconds: 300),
            opacity: _animEnd ? 1.0 : 0.0,
            child: const Text("Power off QueQiao Group",
                style: TextStyle(
                    color: Colors.grey,
                    shadows: [
                      Shadow(
                          color: Colors.black,
                          blurRadius: 1,
                          offset: Offset(0.3, 0.3))
                    ],
                    fontSize: 16))),
      );
}
