import 'dart:io';
import 'package:amap_map_fluttify/amap_map_fluttify.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_geen/views/app/bloc_wrapper.dart';
import 'views/app/flutter_geen.dart';
Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  GestureBinding.instance.resamplingEnabled = true;
  runApp(BlocWrapper(child: FlutterGeen()));
  await enableFluttifyLog(false);
  await AmapService.instance.init(
      iosKey: "75f93121afcd226f0e822a19cf40e0ca",
      androidKey: "a130ae881342a409182da1c28197bf8e"
  );


}
