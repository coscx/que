import 'dart:io';
import 'dart:typed_data';

import 'package:fluwx/fluwx.dart' as fluwx;


class WxSdk {
  // static bool wxIsInstalled;
  static Future init() async {
    fluwx.registerWxApi(
        appId: "你的appid",
        doOnAndroid: true,
        doOnIOS: true,
        universalLink: "你的universalLink");

  }

  static Future<bool> wxIsInstalled() async {
    return await fluwx.isWeChatInstalled;
  }



  /**
   * 分享图片到微信，
   * file=本地路径
   * url=网络地址
   * asset=内置在app的资源图片
   * scene=分享场景，1好友会话，2朋友圈，3收藏
   */
  static void ShareImage(
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

  /**
   * 分享文本
   * content=分享内容
   * scene=分享场景，1好友会话，2朋友圈，3收藏
   */
  static void ShareText(String content, {String title, int scene = 1}) {
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

  /***
   * 分享视频
   * videoUrl=视频网上地址
   * thumbFile=缩略图本地路径
   * scene=分享场景，1好友会话，2朋友圈，3收藏
   */
  static void ShareVideo(String videoUrl,
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

  /**
   * 分享链接
   * url=链接
   * thumbFile=缩略图本地路径
   * scene=分享场景，1好友会话，2朋友圈，3收藏
   */
  static void ShareUrl(String url,
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
    fluwx.WeChatImage image = null;
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
  static bool strNoEmpty(String value) {
    if (value == null) return false;

    return value.trim().isNotEmpty;
  }

  /// 字符串不为空
  static bool mapNoEmpty(Map value) {
    if (value == null) return false;
    return value.isNotEmpty;
  }

  ///判断List是否为空
  static bool listNoEmpty(List list) {
    if (list == null) return false;

    if (list.length == 0) return false;

    return true;
  }


}
