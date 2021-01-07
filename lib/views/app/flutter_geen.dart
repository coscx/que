import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_geen/app/router.dart';
import 'package:flutter_geen/blocs/bloc_exp.dart';
import 'package:flutter_geen/views/app/splash/unit_splash.dart';
import 'package:flutter_screenutil/screenutil_init.dart';


/// 说明: 主程序

class FlutterGeen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<GlobalBloc, GlobalState>(builder: (_, state) {
      return ScreenUtilInit(
          designSize: Size(750, 1334),
      allowFontScaling: true,
      child:MaterialApp(
//            debugShowMaterialGrid: true,
            showPerformanceOverlay: state.showPerformanceOverlay,
//            showSemanticsDebugger: true,
//            checkerboardOffscreenLayers:true,
//            checkerboardRasterCacheImages:true,
            title: '鹊桥',
            debugShowCheckedModeBanner: false,
            onGenerateRoute: UnitRouter.generateRoute,
            theme: ThemeData(
              primarySwatch: state.themeColor,
              fontFamily: state.fontFamily,
            ),
            home: UnitSplash(),
            builder: EasyLoading.init(),
      ));
    });
  }

}
