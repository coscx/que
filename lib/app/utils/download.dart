import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';
import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:path_provider/path_provider.dart';
import 'package:image_gallery_saver/image_gallery_saver.dart';

class LocalImageCache {
  static LocalImageCache instance = LocalImageCache();
  String _tmepPath = "";
  void init() async {
    var tempDir = await getTemporaryDirectory();
    _tmepPath = tempDir.path;
  }


  /**
   * 直接下载图片到本地临时目录
   * ios必须带有后缀，不然exists会永远=false
   */


  Future<String> download(BuildContext context, String url,{String ext = ""}) async {
    try {
      var dio = await Dio()
          .get(url, options: Options(responseType: ResponseType.bytes));
      Uint8List image = Uint8List.fromList(dio.data);
      return await ImageGallerySaver.saveImage(image);
    } catch (ex) {
      print("image download error:${ex.toString()}");
      return null;
    }
  }


}

