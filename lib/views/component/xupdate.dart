import 'dart:convert';

import 'package:flutter_xupdate/flutter_xupdate.dart';

class CheckUpdate{
  // 将自定义的json内容解析为UpdateEntity实体类
  UpdateEntity customParseJson(String json) {
    AppInfo appInfo = AppInfo.fromJson(json);
    return UpdateEntity(
        isForce: appInfo.isForce, // 是否强制更新
        hasUpdate: appInfo.hasUpdate, // 是否需要更新  默认true， 手动自行判断
        isIgnorable: appInfo.isIgnorable, // 是否显示 “忽略该版本”
        versionCode: appInfo.versionCode, // 新版本号
        versionName: appInfo.versionName, // 新版名称
        updateContent: appInfo.updateLog, // 新版更新日志
        downloadUrl: appInfo.apkUrl, // 新版本下载链接
        apkSize: appInfo.apkSize); // 新版本大小
  }
  // 自定义JSON更新
  checkUpdateByUpdateEntity(Map jsonData) async {
    var versionCode = jsonData["versionCode"].replaceAll('.', '');
    var updateText = jsonData["updateLog"].split('。');
    var updateLog = '';
    updateText.forEach((t) {
      updateLog += '\r\n$t';
    });
    var rusultJson = {
      "isForce": jsonData["isForce"] == 1,
      "hasUpdate": true,
      "isIgnorable": false,
      "versionCode": int.parse(versionCode),
      "versionName": jsonData["versionName"],
      "updateLog": updateLog,
      "apkUrl": jsonData["apkUrl"],
      "apkSize":jsonData["apkSize"]
    };
    FlutterXUpdate.updateByInfo(updateEntity: customParseJson(json.encode(rusultJson)));
  }

  // 初始化插件
  Future<dynamic> initXUpdate () async {
    FlutterXUpdate.init(
      //是否输出日志
        debug: true,
        //是否使用post请求
        isPost: false,
        //post请求是否是上传json
        isPostJson: false,
        //是否开启自动模式
        isWifiOnly: false,
        ///是否开启自动模式
        isAutoMode: false,
        //需要设置的公共参数
        supportSilentInstall: false,
        //在下载过程中，如果点击了取消的话，是否弹出切换下载方式的重试提示弹窗
        enableRetry: false)
        .then((value) {
      print("初始化成功: $value");
    }).catchError((error) {
      print(error);
    });
    FlutterXUpdate.setUpdateHandler(
        onUpdateError: (Map<String, dynamic> message) async {
          print("初始化成功: $message");
        }, onUpdateParse: (String json) async {
      //这里是自定义json解析
      return customParseJson(json);
    });
  }
}

// 使用Dart Data Class Generator插件进行创建  使用命令: Generate from JSON
class AppInfo {
  final bool isForce;
  final bool hasUpdate;
  final bool isIgnorable;
  final int versionCode;
  final String versionName;
  final String updateLog;
  final String apkUrl;
  final int apkSize;

  AppInfo({
    this.isForce,
    this.hasUpdate,
    this.isIgnorable,
    this.versionCode,
    this.versionName,
    this.updateLog,
    this.apkUrl,
    this.apkSize,
  });

  Map<String, dynamic> toMap() {
    return {
      'isForce': isForce,
      'hasUpdate': hasUpdate,
      'isIgnorable': isIgnorable,
      'versionCode': versionCode,
      'versionName': versionName,
      'updateLog': updateLog,
      'apkUrl': apkUrl,
      'apkSize': apkSize,
    };
  }

  static AppInfo fromMap(Map<String, dynamic> map) {
    if (map == null) return null;

    return AppInfo(
      isForce: map['isForce'],
      hasUpdate: map['hasUpdate'],
      isIgnorable: map['isIgnorable'],
      versionCode: map['versionCode'],
      versionName: map['versionName'],
      updateLog: map['updateLog'],
      apkUrl: map['apkUrl'],
      apkSize: int.parse(map['apkSize']),
    );
  }

  String toJson() => json.encode(toMap());

  static AppInfo fromJson(String source) => fromMap(json.decode(source));

  @override
  String toString() {
    return 'AppInfo isForce: $isForce, hasUpdate: $hasUpdate, isIgnorable: $isIgnorable, versionCode: $versionCode, versionName: $versionName, updateLog: $updateLog, apkUrl: $apkUrl, apkSize: $apkSize';
  }
}