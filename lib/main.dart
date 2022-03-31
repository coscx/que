import 'dart:io';

// import 'package:amap_map_fluttify/amap_map_fluttify.dart';
//import 'package:amap_map_fluttify/amap_map_fluttify.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_2d_amap/flutter_2d_amap.dart';
import 'package:flutter_geen/storage/app_storage.dart';
import 'package:flutter_geen/storage/dao/local_storage.dart';
import 'package:flutter_geen/views/app/bloc_wrapper.dart';
import 'package:fluwx/fluwx.dart';
import 'package:umeng_analytics_push/umeng_analytics_push.dart';
import 'views/app/flutter_geen.dart';
import 'package:device_info/device_info.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  GestureBinding.instance.resamplingEnabled = true;
  bool isIPad = false;
  if (Platform.isAndroid == false) {
    DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();
    IosDeviceInfo info = await deviceInfo.iosInfo;
    isIPad = info.utsname.machine.toLowerCase().contains("ipad");
    isIPad = info.model == "iPad";
  }
  _init();
  final sp = AppStorage().sp;
  var mode = await sp;
  bool animate = mode.getBool("animate");
  if(animate==null){
    animate =true;
  }
  var ss = await LocalStorage.get("token");
  var sss =ss.toString();
  var jump =0;
  if(sss == "" || ss == null || ss == "null"){
    // Navigator.of(context).pushReplacementNamed(UnitRouter.login);
  } else{
    jump = 1;
    //LocalStorage.save("token", '');
    // var agree = await LocalStorage.get("agree");
    // var agrees =agree.toString();
    // if("1" == "1"){
    //   Navigator.of(context).pushReplacementNamed(UnitRouter.nav);
    // } else{
    //   //LocalStorage.save("token", '');
    //   showDialog(context: context, builder: (ctx) => _buildDialog());
    // }
  }
  runApp(BlocWrapper(child: FlutterGeen(isPad: isIPad, animate: animate,jump: jump,)));
  SystemUiOverlayStyle systemUiOverlayStyle = SystemUiOverlayStyle(statusBarColor: Colors.transparent);
  SystemChrome.setSystemUIOverlayStyle(systemUiOverlayStyle);
}
Future<void> _init() async {
  var agree = await LocalStorage.get("agree");
  var agrees =agree.toString();
  if(agrees == "4"){
    UmengAnalyticsPush.initUmeng(false, true);
    Flutter2dAMap.updatePrivacy(true);
    Flutter2dAMap.setApiKey(
      iOSKey: '75f93121afcd226f0e822a19cf40e0ca',
      webKey: 'a130ae881342a409182da1c28197bf8e',
    );
    LocalStorage.save("UmengInit", 'push_init_ok');
  }
  registerWxApi(
      appId: "wx45bdf8edd00e99ef",
      doOnAndroid: true,
      doOnIOS: true,
      universalLink: "https://your.univerallink.com/link/");
  var result = await isWeChatInstalled;
  print("wx is installed $result");
}