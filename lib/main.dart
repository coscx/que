import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_geen/views/app/bloc_wrapper.dart';
import 'views/app/flutter_geen.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  GestureBinding.instance.resamplingEnabled = true;
  runApp(BlocWrapper(child: FlutterGeen()));
}
