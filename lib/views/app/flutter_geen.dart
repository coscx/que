import 'package:bot_toast/bot_toast.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_geen/app/router.dart';
import 'package:flutter_geen/blocs/bloc_exp.dart';
import 'package:flutter_geen/storage/dao/local_storage.dart';
import 'package:flutter_geen/views/app/splash/unit_splash.dart';
import 'package:flutter_geen/views/pages/login/login_page.dart';
import 'package:flutter_screenutil/screenutil_init.dart';
import 'package:umeng_analytics_push/umeng_analytics_push.dart';
import 'navigation/unit_navigation.dart';
import 'package:flutter_geen/views/component/protocol_model.dart';

/// 说明: 主程序
class FlutterGeen extends StatelessWidget {
  final bool isPad;
  final bool animate;
  final int jump;

  FlutterGeen({this.isPad, this.animate, this.jump});

  final EasyLoadingBuilder = EasyLoading.init();
  final botToastBuilder = BotToastInit(); //1.调用BotToastInit
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<GlobalBloc, GlobalState>(builder: (_, state) {
      return ScreenUtilInit(
          designSize: isPad ? Size(1536, 2048) : Size(750, 1334),
          allowFontScaling: true,
          child: MaterialApp(
//            debugShowMaterialGrid: true,
            showPerformanceOverlay: state.showPerformanceOverlay,
//            showSemanticsDebugger: true,
//            checkerboardOffscreenLayers:true,
//            checkerboardRasterCacheImages:true,
            title: '鹊桥缘遇',
            debugShowCheckedModeBanner: false,
            onGenerateRoute: UnitRouter.generateRoute,
            theme: ThemeData(
              primarySwatch: state.themeColor,
              fontFamily: state.fontFamily,
            ),
            home: (jump == 0
                ? Agree()
                : (animate == true
                    ? UnitSplash(
                        size: 200,
                        animate: animate,
                      )
                    : UnitNavigation())),
            builder: (context, child) {
              child = EasyLoadingBuilder(context, child); //do something
              child = botToastBuilder(context, child);
              return child;
            },
            navigatorObservers: [BotToastNavigatorObserver()], //2.注册路由观察者
          ));
    });
  }
}

class Agree extends StatefulWidget {
  @override
  _AgreeState createState() => _AgreeState();
}

class _AgreeState extends State<Agree> with ProtocolModel {
  @override
  void initState() {
    Future.delayed(Duration.zero, () async {
      var agree = await LocalStorage.get("agree");
      var agrees = agree.toString();
      if (agrees == "4") {
        Navigator.of(context).pushReplacementNamed(UnitRouter.login);
      } else {
        var isAgreement = await showProtocolFunction(context);
        if (isAgreement) {
          LocalStorage.save("agree", '4');
          Navigator.of(context).pushReplacementNamed(UnitRouter.login);
        }
      }
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
    );
  }
}
