import 'dart:async';
import 'dart:io';
import 'dart:typed_data';
import 'dart:ui' as ui;

import 'package:ai_barcode/ai_barcode.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_geen/views/items/share.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fluwx/fluwx.dart' as fluwx;
import 'package:path_provider/path_provider.dart';
import 'package:qr_flutter/qr_flutter.dart';

class LoginDialog extends Dialog {
  LoginDialog({Key key}) : super(key: key);
  CreatorController _creatorController = CreatorController();
  GlobalKey repaintWidgetKey = GlobalKey(); // 绘图key值
  @override
  Widget build(BuildContext context) {
    return Material(
      type: MaterialType.transparency,
      child: Container(
        color: Colors.transparent,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Container(
              width: 640.w,
              height: 640.h,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.all(Radius.circular(6)),
              ),
              child: Container(
                // alignment: Alignment.topCenter,
                // maxHeight: 800.h,
                child: Stack(
                  alignment: AlignmentDirectional.bottomCenter,
                  children: <Widget>[
                    Padding(
                      padding: EdgeInsets.only(
                        left: 30.w,
                        right: 30.w,
                        top: 30.h,
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: <Widget>[
                          Container(
                            padding: EdgeInsets.only(
                              bottom: 10.h,
                            ),
                            child: Text(
                              "渠道二维码",
                              style: TextStyle(
                                  fontSize: 40.sp, fontWeight: FontWeight.w700),
                            ),
                            alignment: Alignment.center,
                          ),
                          RepaintBoundary(
                              key: repaintWidgetKey,
                              child: Container(
                                alignment: Alignment.center,
                                //width: 400.w,
                                //height: 400.h,
                                color: Colors.white,
                                // child: PlatformAiBarcodeCreatorWidget(
                                //   creatorController: _creatorController,
                                //   initialValue: "http://baidu.com",
                                // ),
                                child: Container(
                                  padding: EdgeInsets.all(25.w),
                                  child: QrImage(
                                    data: "http://baidu.com/s",
                                    version: QrVersions.auto,
                                    size: 250,
                                  ),
                                ),
                              )),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: <Widget>[buildSubmit(context)],
                          )
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
            GestureDetector(
              onTap: () => Navigator.of(context).pop(),
              child: Container(
                margin: EdgeInsets.only(top: 25.w),
                child: Image.asset(
                  'assets/images/login/close.png',
                  color: Colors.white,
                  width: 60.w,
                  height: 60.h,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

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
        })
  ];

  /// 把图片ByteData写入File，并触发微信分享
  Future<String> _shareUiImage() async {
    ByteData sourceByteData = await _capturePngToByteData();
    if (sourceByteData == null) {
      return "";
    }
    Uint8List sourceBytes = sourceByteData.buffer.asUint8List();
    Directory tempDir = await getTemporaryDirectory();

    String storagePath = tempDir.path;
    File file = new File('$storagePath/capture.png');
    //print(await file.length());
    if (!file.existsSync()) {
      file.createSync();
    }
    file.writeAsBytesSync(sourceBytes);
    //ShareImage(title: "图片分享", file: file.path);
    return file.path;
  }

  /// 截屏图片生成图片流ByteData
  Future<ByteData> _capturePngToByteData() async {
    try {
      RenderRepaintBoundary boundary =
          repaintWidgetKey.currentContext.findRenderObject();
      double dpr = ui.window.devicePixelRatio; // 获取当前设备的像素比
      ui.Image image = await boundary.toImage(pixelRatio: dpr);
      ByteData _byteData =
          await image.toByteData(format: ui.ImageByteFormat.png);
      return _byteData;
    } catch (e) {
      print(e);
    }
    return null;
  }

  /// 分享图片到微信，
  /// file=本地路径
  /// url=网络地址
  /// asset=内置在app的资源图片
  /// scene=分享场景，1好友会话，2朋友圈，3收藏
  void ShareImage(
      {String title,
      String decs,
      String file,
      String url,
      String asset,
      int scene = 1}) async {
    fluwx.WeChatScene wxScene = fluwx.WeChatScene.SESSION;
    if (scene == 2) {
      wxScene = fluwx.WeChatScene.TIMELINE;
    } else if (scene == 3) {
      wxScene = fluwx.WeChatScene.FAVORITE;
    }
    fluwx.WeChatShareImageModel model = null;

    if (file != null) {
      model = fluwx.WeChatShareImageModel(fluwx.WeChatImage.file(File(file)),
          title: title, description: decs, scene: wxScene);
    } else if (url != null) {
      model = fluwx.WeChatShareImageModel(fluwx.WeChatImage.network(url),
          title: title, description: decs, scene: wxScene);
    } else if (asset != null) {
      model = fluwx.WeChatShareImageModel(fluwx.WeChatImage.asset(asset),
          title: title, description: decs, scene: wxScene);
    } else {
      throw Exception("缺少图片资源信息");
    }
    fluwx.shareToWeChat(model);
  }

  /// 分享文本
  /// content=分享内容
  /// scene=分享场景，1好友会话，2朋友圈，3收藏
  void ShareText(String content, {String title, int scene = 1}) {
    fluwx.WeChatScene wxScene = fluwx.WeChatScene.SESSION;
    if (scene == 2) {
      wxScene = fluwx.WeChatScene.TIMELINE;
    } else if (scene == 3) {
      wxScene = fluwx.WeChatScene.FAVORITE;
    }
    fluwx.WeChatShareTextModel model =
        fluwx.WeChatShareTextModel(content, title: title, scene: wxScene);
    fluwx.shareToWeChat(model);
  }

  /// *
  /// 分享视频
  /// videoUrl=视频网上地址
  /// thumbFile=缩略图本地路径
  /// scene=分享场景，1好友会话，2朋友圈，3收藏
  void ShareVideo(String videoUrl,
      {String thumbFile, String title, String desc, int scene = 1}) {
    fluwx.WeChatScene wxScene = fluwx.WeChatScene.SESSION;
    if (scene == 2) {
      wxScene = fluwx.WeChatScene.TIMELINE;
    } else if (scene == 3) {
      wxScene = fluwx.WeChatScene.FAVORITE;
    }
    fluwx.WeChatImage image = null;
    if (thumbFile != null) {
      image = fluwx.WeChatImage.file(File(thumbFile));
    }
    var model = fluwx.WeChatShareVideoModel(
        videoUrl: videoUrl,
        thumbnail: image,
        title: title,
        description: desc,
        scene: wxScene);
    fluwx.shareToWeChat(model);
  }

  /// 分享链接
  /// url=链接
  /// thumbFile=缩略图本地路径
  /// scene=分享场景，1好友会话，2朋友圈，3收藏
  void ShareUrl(String url,
      {String thumbFile,
      Uint8List thumbBytes,
      String title,
      String desc,
      int scene = 1,
      String networkThumb,
      String assetThumb}) {
    desc = desc ?? "";
    title = title ?? "";
    if (desc.length > 54) {
      desc = desc.substring(0, 54) + "...";
    }
    if (title.length > 20) {
      title = title.substring(0, 20) + "...";
    }
    fluwx.WeChatScene wxScene = fluwx.WeChatScene.SESSION;
    if (scene == 2) {
      wxScene = fluwx.WeChatScene.TIMELINE;
    } else if (scene == 3) {
      wxScene = fluwx.WeChatScene.FAVORITE;
    }
    fluwx.WeChatImage image;
    if (thumbFile != null) {
      image = fluwx.WeChatImage.file(File(thumbFile));
    } else if (thumbBytes != null) {
      image = fluwx.WeChatImage.binary(thumbBytes);
    } else if (strNoEmpty(networkThumb)) {
      image = fluwx.WeChatImage.network(Uri.encodeFull(networkThumb));
    } else if (strNoEmpty(assetThumb)) {
      image = fluwx.WeChatImage.asset(assetThumb, suffix: ".png");
    }
    var model = fluwx.WeChatShareWebPageModel(
      url,
      thumbnail: image,
      title: title,
      description: desc,
      scene: wxScene,
    );
    fluwx.shareToWeChat(model);
  }

  /// 字符串不为空
  bool strNoEmpty(String value) {
    if (value == null) return false;

    return value.trim().isNotEmpty;
  }

  /// 字符串不为空
  bool mapNoEmpty(Map value) {
    if (value == null) return false;
    return value.isNotEmpty;
  }

  ///判断List是否为空
  bool listNoEmpty(List list) {
    if (list == null) return false;

    if (list.length == 0) return false;

    return true;
  }

  Widget buildSubmit(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(top: 20.h, bottom: 0.h, left: 30.h, right: 30.h),
      child: Container(
        width: ScreenUtil().screenWidth * 0.6,
        height: 70.h,
        child: RaisedButton(
          elevation: 0,
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(40.w))),
          color: Colors.lightBlue,
          onPressed: () async {
            var d = await _shareUiImage();

            showDialog(
                context: context,
                barrierDismissible: false,
                builder: (BuildContext context) {
                  return Container(
                    child: Image.file(File(d)),
                  );
                }
            );
            // showModalBottomSheet(
            //     backgroundColor: Colors.transparent,
            //     context: context,
            //     builder: (BuildContext context) {
            //       return ShareWidget(
            //         ShareInfo(
            //             'Hello world',
            //             'http://www.baidu.com',
            //             "https://gimg2.baidu.com/image_search/src=http%3A%2F%2Fimg.mp.sohu.com%2Fupload%2F20170601%2Faf68bce89ac945e7ad00da688a25fb08.png&refer=http%3A%2F%2Fimg.mp.sohu.com&app=2002&size=f9999,10000&q=a80&n=0&g=0n&fmt=jpeg?sec=1613110527&t=2cdb6d82fcfc0482bb12ffd8cac9b01a",
            //             ""),
            //         list: list,
            //       );
            //     });
          },
          child: Text("分享我的推广码",
              style: TextStyle(color: Colors.white, fontSize: 35.sp)),
        ),
      ),
    );
  }
}
