import 'dart:io';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_geen/views/app/bloc_wrapper.dart';
import 'views/app/flutter_geen.dart';
// import 'package:flutter_bmfbase/BaiduMap/bmfmap_base.dart' show BMFMapSDK, BMF_COORD_TYPE;
// import 'package:flutter_bmfbase/BaiduMap/bmfmap_base.dart';
void main() {
  WidgetsFlutterBinding.ensureInitialized();
  // if(Platform.isIOS){
  //   BMFMapSDK.setApiKeyAndCoordType(
  //       '请输入百度开放平台申请的iOS端API KEY', BMF_COORD_TYPE.BD09LL);
  // }else if(Platform.isAndroid){
  //   // Android 目前不支持接口设置Apikey,
  //   // 请在主工程的Manifest文件里设置，详细配置方法请参考[https://lbsyun.baidu.com/ 官网][https://lbsyun.baidu.com/)demo
  //   BMFMapSDK.setCoordType(BMF_COORD_TYPE.BD09LL);}
  GestureBinding.instance.resamplingEnabled = true;
  runApp(BlocWrapper(child: FlutterGeen()));
}
