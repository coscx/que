import 'package:flt_im_plugin/flt_im_plugin.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_geen/app/router.dart';
import 'package:flutter_geen/app/res/toly_icon.dart';
import 'package:flutter_geen/blocs/bloc_exp.dart';
import 'package:flutter_geen/storage/dao/local_storage.dart';
import 'package:flutter_geen/views/dialogs/delete_category_dialog.dart';
import 'package:flutter_geen/views/pages/login/login_page.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
class SettingPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.of(context).pop(),
        ),
        backgroundColor: Colors.white,
        elevation: 0, //去掉Appbar底部阴影
        title: Text('应用设置',style: TextStyle(color: Colors.black, fontSize: 48.sp,fontWeight: FontWeight.normal)),
      ),
      body: ListView(
        children: <Widget>[
          ListTile(
            leading: Icon(
              Icons.palette,
              color: Theme.of(context).primaryColor,
            ),
            title: Text('主题色设置'),
            trailing: _nextIcon(context),
            onTap: () => Navigator.of(context).pushNamed(UnitRouter.theme_color_setting),
          ),
          Divider(),
          ListTile(
            leading: Icon(
              Icons.translate,
              color: Theme.of(context).primaryColor,
            ),
            title: Text('字体设置'),
            trailing: _nextIcon(context),
            onTap: () => Navigator.of(context).pushNamed(UnitRouter.font_setting),
          ),
          // Divider(),
          // ListTile(
          //   leading: Icon(
          //     TolyIcon.icon_item,
          //     color: Theme.of(context).primaryColor,
          //   ),
          //   title: Text('item样式设置'),
          //   trailing: _nextIcon(context),
          //   onTap: () => Navigator.of(context).pushNamed(UnitRouter.item_style_setting),
          // ),
          // Divider(),
          // ListTile(
          //   leading: Icon(
          //     TolyIcon.icon_code,
          //     color: Theme.of(context).primaryColor,
          //   ),
          //   title: Text('代码高亮样式'),
          //   trailing: _nextIcon(context),
          //   onTap: () => Navigator.of(context).pushNamed(UnitRouter.code_style_setting),
          // ),
          Divider(),
          _buildShowBg(context),
          Divider(),
          _buildShowOver(context),
          Divider(),
          ListTile(
            leading: Icon(
              Icons.info,
              color: Theme.of(context).primaryColor,
            ),
            title: Text('版本信息'),
            trailing: _nextIcon(context),
            onTap: () => Navigator.of(context).pushNamed(UnitRouter.version_info),
          ),

          Divider(),
          SizedBox(
            height: 20,
          ),
          buildButton(context,"退出登录",Colors.blue),
        ],
      ),
    );
  }
  _exit(BuildContext context) {
    showDialog(
        context: context,
        builder: (ctx) => Dialog(
          elevation: 5,
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(10))),
          child: Container(
            width: 50,
            child: DeleteCategoryDialog(
              title: '退出登录',
              content: '是否确定继续执行?',
              onSubmit: () {
                FltImPlugin im = FltImPlugin();
                im.logout();
                Future.delayed(Duration(milliseconds: 1)).then((e) async {
                  var ss = await LocalStorage.remove("im_token");
                  var memberId = await LocalStorage.remove("memberId");
                  var sss = await LocalStorage.remove("token");
                  Navigator.pushNamed(context, UnitRouter.login);
                  Navigator.of(context).pushNamedAndRemoveUntil(
                    'login',
                        (route) => route == null,
                  );
                });
                // Navigator.of(context).pushAndRemoveUntil(
                //     new MaterialPageRoute(builder: (context) => LoginPage()
                //     ), (route) => route == null);

              },
            ),
          ),
        ));
  }
  Widget buildButton(BuildContext context,String txt,MaterialColor color){
    return    Column(
      children: [
        ElevatedButton(
          onPressed: () {
            _exit(context);
          },
          child: Text(txt,style:TextStyle(
              fontSize: 33.sp, color: Colors.white)),
          style: ElevatedButton.styleFrom(
              onPrimary: Colors.white,
              primary: Theme
                  .of(context)
                  .primaryColor,
              shadowColor: Colors.black12,
              shape: StadiumBorder(),
              padding: EdgeInsets.symmetric(
                  horizontal: 65.w, vertical: 15.h)),
        ),

      ],
    );
  }

  Widget _buildShowBg(BuildContext context) =>
      BlocBuilder<GlobalBloc, GlobalState>(
          builder: (_, state) => SwitchListTile(
                value: state.showBackGround,
                secondary: Icon(
                  TolyIcon.icon_background,
                  color: Theme.of(context).primaryColor,
                ),
                title: Text('主页选择记忆'),
                onChanged: (show) {
                  BlocProvider.of<GlobalBloc>(context)
                      .add(EventSwitchShowBg(show));
                },
              ));

  Widget _buildShowOver(BuildContext context) =>
      BlocBuilder<GlobalBloc, GlobalState>(
          builder: (_, state) => SwitchListTile(
            value: state.showPerformanceOverlay,
            secondary: Icon(
              TolyIcon.icon_show,
              color: Theme.of(context).primaryColor,
            ),
            title: Text('显示性能浮层'),
            onChanged: (show) {
              BlocProvider.of<GlobalBloc>(context)
                  .add(EventSwitchShowOver(show));
            },
          ));

  Widget _nextIcon(BuildContext context) =>
      Icon(Icons.chevron_right, color: Theme.of(context).primaryColor);
}
