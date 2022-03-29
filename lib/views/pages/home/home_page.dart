import 'dart:convert';
import 'dart:math';
import 'dart:io';
import 'package:bot_toast/bot_toast.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_geen/app/api/issues_api.dart';
import 'package:flutter_geen/app/router.dart';
import 'package:flutter_geen/blocs/bloc_exp.dart';
import 'package:flutter_geen/blocs/home/home_bloc.dart';
import 'package:flutter_geen/components/permanent/overlay_tool_wrapper.dart';
import 'package:flutter_geen/storage/app_storage.dart';
import 'package:flutter_geen/storage/dao/local_storage.dart';
import 'package:flutter_geen/views/dialogs/delete_category_dialog.dart';
import 'package:flutter_geen/views/pages/home/gzx_filter_goods_page.dart';
import 'package:flutter_geen/views/dialogs/user_detail.dart';
import 'package:flutter_geen/views/items/SearchParamModel.dart';
import 'package:flutter_geen/views/items/drop_menu_leftWidget.dart';
import 'package:flutter_geen/model/widget_model.dart';
import 'package:flutter_geen/views/common/empty_page.dart';
import 'package:flutter_geen/views/items/home_item_support.dart';
import 'package:flutter_geen/views/component/refresh.dart';
import 'package:flutter_geen/views/pages/utils/DyBehaviorNull.dart';
import 'package:flutter_geen/views/component/app_bar_component.dart';
import 'package:lottie/lottie.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
//import 'package:flutter_qr_reader/flutter_qr_reader.dart';

class SortCondition {
  String name;
  bool isSelected;
  int id;
  bool all;

  SortCondition({this.name, this.id, this.isSelected, this.all}) {}
}

class StoreSelect {
  String name;
  int id;
  bool isSelected;
  int city;

  StoreSelect({this.name, this.id, this.city, this.isSelected});
}

class CitySelect {
  String name;
  int id;
  bool isSelected;

  CitySelect({this.name, this.id, this.isSelected});
}

var _scaffoldKey = new GlobalKey<ScaffoldState>();

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage>
    with AutomaticKeepAliveClientMixin {
  //QrReaderViewController _controller;
  RefreshController _refreshController =
      RefreshController(initialRefresh: false);
  ScrollController _scrollController = ScrollController();

  bool _showFilter = false;
  bool _showSort = false;
  bool _showAge = false;
  int _showAgeMin = 16;
  int _showAgeMax = 70;
  int _visibleCount = 0;
  String serveType = "1";
  String totalCount = "";
  String title = "客户管理";
  static List<SortModel> _leftWidgets = [
    SortModel(name: "服务中", isSelected: true, code: "2"),
    SortModel(name: "跟进中", isSelected: false, code: "1"),
    SortModel(name: "已签约", isSelected: false, code: "3"),
    SortModel(name: "即将过期", isSelected: false, code: "4"),
  ];
  SearchParamList searchParamList = SearchParamList(list: []);
  List<SelectItem> selectItems = <SelectItem>[];
  int roleId = 0;

  @override
  void initState() {
    super.initState();
    //
    // WidgetsBinding.instance.addPostFrameCallback((callback) {
    //   OverlayToolWrapper.of(context).showFloating();
    // });
  }

  @override
  void dispose() {
    _refreshController?.dispose();
    super.dispose();
  }

  // 下拉刷新
  void _onRefresh() async {
    BlocProvider.of<GlobalBloc>(context).add(EventResetIndexPhotoPage());
    //BlocProvider.of<GlobalBloc>(context).add((EventSetIndexNum()));
    var sex = BlocProvider.of<GlobalBloc>(context).state.sex;
    var mode = BlocProvider.of<GlobalBloc>(context).state.currentPhotoMode;
    BlocProvider.of<HomeBloc>(context).add(EventFresh(
        sex,
        mode,
        searchParamList,
        _showAge,
        _showAgeMax,
        _showAgeMin,
        serveType,
        selectItems));
    _refreshController.refreshCompleted();
  }

  // 上拉加载
  void _onLoading() async {
    try{
      List<dynamic> oldUsers =
      BlocProvider.of<HomeBloc>(context).state.props.elementAt(0);
      var currentPage = BlocProvider.of<GlobalBloc>(context).state.indexPhotoPage;
      var sex = BlocProvider.of<GlobalBloc>(context).state.sex;
      var mode = BlocProvider.of<GlobalBloc>(context).state.currentPhotoMode;
      BlocProvider.of<GlobalBloc>(context).add(EventIndexPhotoPage(currentPage));
      var result = await IssuesApi.searchErpUser(
          '',
          (++currentPage).toString(),
          sex.toString(),
          mode.toString(),
          searchParamList,
          _showAge,
          _showAgeMax,
          _showAgeMin,
          serveType,
          selectItems);
      if (result['code'] == 200) {
      } else {}
      List<dynamic> newUsers = [];
      oldUsers.forEach((element) {
        newUsers.add(element);
      });
      if (result['data'] is List){

      }else{
        if (result['data']['data']!=null)
          newUsers.addAll(result['data']['data']);
      }

      BlocProvider.of<HomeBloc>(context).add(EventLoadMore(newUsers));
    }catch(e){
      print(e);
    }

    _refreshController.loadComplete();
  }

  Future _scan() async {
    await Permission.camera.request();

    Navigator.pushNamed(context, UnitRouter.qr_view).then((barcode) async {
      //String barcode = "";//await scanner.scan();
      if (barcode == null) {
        print('nothing return.');
      } else {
        //this._outputController.text = barcode;
        print(barcode);
        BotToast.showLoading();
        //BlocProvider.of<GlobalBloc>(context).add(EventSetCreditId(barcode));
        var result = await IssuesApi.getUserDetail(
            'a87ca69e-7092-493e-9f13-2955aeaf2d0f');
        if (result['code'] == 200) {
          _userDetail(context, result['data']);
        } else {
          _createUser(context, null);
        }

        BotToast.closeAllLoading();
      }
    });
  }

  _userDetail(BuildContext context, Map<String, dynamic> user) {
    showDialog(context: context, builder: (ctx) => UserDetailDialog(user));
  }

  _createUser(BuildContext context, Map<String, dynamic> img) {
    showDialog(
        context: context,
        builder: (ctx) => Dialog(
              elevation: 5,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(Radius.circular(10.w))),
              child: Container(
                width: 50.w,
                child: DeleteCategoryDialog(
                  title: '未查到数据',
                  content: '是否录入？',
                  onSubmit: () {
                    Future.delayed(Duration(milliseconds: 500)).then((e) async {
                      Navigator.pushNamed(context, UnitRouter.create_user_page);
                    });
                    Navigator.of(context).pop();
                    //BlocProvider.of<DetailBloc>(context).add(EventDelDetailImg(img,detail['info']));

                    //
                  },
                ),
              ),
            ));
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);

    return Theme(
        data: ThemeData(
          appBarTheme: AppBarTheme.of(context).copyWith(
            brightness: Brightness.light,
          ),
        ),
        child: Scaffold(
            key: _scaffoldKey,
            endDrawer: GZXFilterGoodsPage(
              selectItems: selectItems,
            ),
            appBar: AppBar(
              titleSpacing: 40.w,
              leadingWidth: 0,
              title: Row(
                children: [
                  Text(title,
                      style: TextStyle(
                          color: Theme.of(context).primaryColor,
                          fontSize: 48.sp,
                          fontWeight: FontWeight.bold)),
                  totalCount == ""
                      ? Container()
                      : Text('      共:',
                          style: TextStyle(
                              color: Colors.black,
                              fontSize: 30.sp,
                              fontWeight: FontWeight.w200)),
                  Text(totalCount,
                      style: TextStyle(
                          color: Colors.redAccent,
                          fontSize: 30.sp,
                          fontWeight: FontWeight.normal)),
                ],
              ),
              //leading:const Text('Demo',style: TextStyle(color: Colors.black, fontSize: 15)),
              backgroundColor: Colors.white,
              elevation: 0,
              //去掉Appbar底部阴影
              actions: <Widget>[
                Container(
                  child: IconButton(
                    icon: Icon(
                      Icons.search,
                      color: Colors.black87,
                    ),
                    onPressed: () {
                      Navigator.pushNamed(context, UnitRouter.search);
                    },
                  ),
                ),
                SizedBox(width: 20),
                // Container(
                //   height: 20,
                //   width: 20,
                //   child: IconButton(
                //     padding: EdgeInsets.zero,
                //     icon: Icon(
                //       Icons.crop_free,
                //       size: 24.0,
                //       color: Colors.black,
                //     ),
                //     onPressed: () {
                //       //Navigator.of(context).pushNamed(UnitRouter.qr_view);
                //       _scan();
                //       //FlutterAdPlugin.jumpAdList;
                //     },
                //   ),
                // ),
              ],

              //bottom: bar(),
            ),
            body: BlocListener<HomeBloc, HomeState>(
                listener: (ctx, state) {
                  if (state is CheckUserSuccess) {
                    BlocProvider.of<GlobalBloc>(context)
                        .add((EventSetIndexNum()));
                    Scaffold.of(context).showSnackBar(SnackBar(
                      content: Text('审核成功' + state.Reason),
                      backgroundColor: Colors.green,
                    ));
                  }
                  if (state is DelImgSuccess) {
                    Scaffold.of(context).showSnackBar(SnackBar(
                      content: Text('删除成功'),
                      backgroundColor: Colors.blue,
                    ));
                  }
                  if (state is Unauthenticated) {
                    Navigator.of(context)
                        .pushReplacementNamed(UnitRouter.login);
                  }

                  if (state is WidgetsLoaded) {
                    var data = state.photos;
                    // print(data.toString());
                    var mode = BlocProvider.of<GlobalBloc>(context)
                        .state
                        .currentPhotoMode;

                    if (mode == 0) {
                      title = "客户管理";
                    }
                    if (mode == 1) {
                      title = "缔结良缘库";
                    }
                    if (mode == 2) {
                      title = "我的客户";
                    }
                    if (mode == 3) {
                      title = "销售公海";
                    }
                    //setState(() {
                    totalCount = state.count;
                    //});
                    if (state.mode !=null){
                      if (state.mode !=1){
                        _scrollController.jumpTo(0);
                      }
                    }else{
                      _scrollController.jumpTo(0);
                    }

                  }
                },
                child: Container(
                  decoration: new BoxDecoration(
                    //背景
                    color: Color.fromRGBO(247, 247, 247, 100),
                    //设置四周圆角 角度
                    borderRadius: BorderRadius.all(Radius.circular(0.h)),
                    //设置四周边框
                    //border: new Border.all(width: 1, color: Colors.red),
                  ),
                  child:
                      BlocBuilder<HomeBloc, HomeState>(builder: (ctx, state) {
                    return Stack(
                      children: <Widget>[
                        //BlocBuilder<GlobalBloc, GlobalState>(builder: _buildBackground),
                        Container(
                          padding: EdgeInsets.only(top: 150.h),
                          child: ScrollConfiguration(
                              behavior: DyBehaviorNull(),
                              child: SmartRefresher(
                                physics: MyScrollPhysics(),
                                enablePullDown: true,
                                enablePullUp: true,
                                header: DYrefreshHeader(),
                                footer: DYrefreshFooter(),
                                controller: _refreshController,
                                onRefresh: _onRefresh,
                                onLoading: _onLoading,
                                child: CustomScrollView(
                                  controller:_scrollController,
                                  physics: BouncingScrollPhysics(),
                                  slivers: <Widget>[
                                    _buildContent(ctx, state),
                                  ],
                                ),
                              )),
                        ),
                        Container(
                          padding: EdgeInsets.only(top: 70.h),
                          child: BlocBuilder<GlobalBloc, GlobalState>(
                              builder: _buildHead),
                        ),
                        bar(
                          selectItems: selectItems,
                          roleId: roleId,
                        ),
                      ],
                    );
                  }),
                ))));
  }

  void _onValueChanged(int value) {
    BlocProvider.of<GlobalBloc>(context).add(EventSetIndexSex(value));
    var mode = BlocProvider.of<GlobalBloc>(context).state.currentPhotoMode;
    BlocProvider.of<GlobalBloc>(context).add(EventResetIndexPhotoPage());
      BlocProvider.of<HomeBloc>(context).add(EventSearchErpUser(
          searchParamList,
          selectItems,
          value,
          mode,
          _showAge,
          _showAgeMax,
          _showAgeMin,
          serveType));

  }

  Widget _buildHead(BuildContext context, GlobalState state) {
    return Container(
        child: Container(
            child: Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      mainAxisSize: MainAxisSize.max,
      //                交叉轴的布局方式，对于column来说就是水平方向的布局方式
      crossAxisAlignment: CrossAxisAlignment.center,
      //就是字child的垂直布局方向，向上还是向下
      verticalDirection: VerticalDirection.down,
      children: <Widget>[
        SizedBox(
          width: 1.w,
        ),
        Container(
          width: 100.w,
          child: Text(
            "筛选:",
            style: TextStyle(
              fontSize: 32.sp,
              color: Colors.black,
            ),
          ),
        ),
        CupertinoSegmentedControl<int>(
          //unselectedColor: Colors.yellow,
          //selectedColor: Colors.green,
          //pressedColor: Colors.blue,
          //borderColor: Colors.red,
          groupValue: state.sex == 0 ? 1 : state.sex,
          onValueChanged: _onValueChanged,
          padding: EdgeInsets.only(right: 0.w),
          children: {
            1: state.sex == 1
                ? Padding(
                    padding: EdgeInsets.only(left: 50.w, right: 40.w),
                    child: Text("男",
                        style: TextStyle(
                          fontSize: 30.sp,
                          color: Colors.white,
                        )),
                  )
                : Text("男",
                    style: TextStyle(
                      fontSize: 30.sp,
                      color: Colors.blue,
                    )),
            2: state.sex == 2
                ? Padding(
                    padding: EdgeInsets.only(left: 50.w, right: 40.w),
                    child: Text("女",
                        style: TextStyle(
                          fontSize: 30.sp,
                          color: Colors.white,
                        )),
                  )
                : Text("女",
                    style: TextStyle(
                      fontSize: 30.sp,
                      color: Colors.blue,
                    )),
          },
        ),
        buildHeadTxt(context, state),
        PopupMenuButton<String>(
          itemBuilder: (context) => buildItems(),
          padding: EdgeInsets.only(right: 0.w),
          offset: Offset(-45.w, 10.h),
          color: Colors.white,
          elevation: 1,
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.only(
            topLeft: Radius.circular(20.w),
            bottomRight: Radius.circular(20.w),
            topRight: Radius.circular(5.w),
            bottomLeft: Radius.circular(20.w),
          )),
          onSelected: (e) async {
            //print(e);
            var ccMode = 0;
            if (e == '全部') {
              BlocProvider.of<GlobalBloc>(context).add(EventSetIndexMode(0));
              var sex = BlocProvider.of<GlobalBloc>(context).state.sex;

              BlocProvider.of<HomeBloc>(context).add(EventTab(
                  sex,
                  0,
                  searchParamList,
                  _showAge,
                  _showAgeMax,
                  _showAgeMin,
                  serveType,
                  selectItems));
              ccMode = 10;
            }
            if (e == '我的') {
              BlocProvider.of<GlobalBloc>(context).add(EventSetIndexMode(2));
              var sex = BlocProvider.of<GlobalBloc>(context).state.sex;
              BlocProvider.of<HomeBloc>(context).add(EventTab(
                  sex,
                  2,
                  searchParamList,
                  _showAge,
                  _showAgeMax,
                  _showAgeMin,
                  serveType,
                  selectItems));
              ccMode = 2;
            }
            if (e == '良缘') {
              BlocProvider.of<GlobalBloc>(context).add(EventSetIndexMode(1));
              var sex = BlocProvider.of<GlobalBloc>(context).state.sex;
              BlocProvider.of<HomeBloc>(context).add(EventTab(
                  sex,
                  1,
                  searchParamList,
                  _showAge,
                  _showAgeMax,
                  _showAgeMin,
                  serveType,
                  selectItems));
              ccMode = 1;
            }
            if (e == '公海') {
              BlocProvider.of<GlobalBloc>(context).add(EventSetIndexMode(3));
              var sex = BlocProvider.of<GlobalBloc>(context).state.sex;
              BlocProvider.of<HomeBloc>(context).add(EventTab(
                  sex,
                  3,
                  searchParamList,
                  _showAge,
                  _showAgeMax,
                  _showAgeMin,
                  serveType,
                  selectItems));
              ccMode = 3;
            }
            var saveMode =
                BlocProvider.of<GlobalBloc>(context).state.showBackGround;
            if (saveMode) {
              final sp = AppStorage().sp;
              await sp
                ..setInt("currentPhotoMode", ccMode);
            }
            BlocProvider.of<GlobalBloc>(context).add(EventResetIndexPhotoPage());
            setState(() {
              roleId = ccMode;
            });

          },
          onCanceled: () => print('onCanceled'),
        )
      ],
    )));
  }

  List<PopupMenuItem<String>> buildItems() {
    final map = {
      "全部": Icons.margin,
      "我的": Icons.person_outline,
      "良缘": Icons.wc,
      "公海": Icons.album_outlined,
    };
    return map.keys
        .toList()
        .map((e) => PopupMenuItem<String>(
            value: e,
            child: Row(
              //spacing: 10.w,
              children: <Widget>[
                Icon(
                  map[e],
                  color: Colors.blue,
                ),
                Text(e),
              ],
            )))
        .toList();
  }

  Widget buildHeadTxt(BuildContext context, GlobalState state) {
    if (state.currentPhotoMode == 0) {
      return SizedBox(
        width: 70.w,
        child: Text("全部"),
      );
    }
    if (state.currentPhotoMode == 2) {
      return SizedBox(
        width: 70.w,
        child: Text("我的"),
      );
    }
    if (state.currentPhotoMode == 1) {
      return SizedBox(
        width: 70.w,
        child: Text("良缘"),
      );
    }
    if (state.currentPhotoMode == 3) {
      return SizedBox(
        width: 70.w,
        child: Text("公海"),
      );
    }
    return SizedBox(
      width: 70.w,
      child: Text("全部"),
    );
  }

  Widget _buildContent(BuildContext context, HomeState state) {
    if (state is WidgetsLoading) {
      return SliverToBoxAdapter(
          child: Container(
        height: 500.h,
        width: 500.w,
        alignment: FractionalOffset.center,
        child: Lottie.asset(
            'assets/packages/lottie_flutter/890-loading-animation.json'),
      ));
    }
    if (state is WidgetsInit) {
      return SliverToBoxAdapter(
          child: Container(
            margin: EdgeInsets.only(top: ScreenUtil().screenHeight/2-300.h),
            height: 100.h,
            width: 100.w,
            alignment: FractionalOffset.center,
            child: Lottie.asset(
                'assets/packages/lottie_flutter/16379-an-ios-like-loading.json'),
          ));
    }
    if (state is WidgetsLoaded) {
      List<dynamic> photos = state.photos;
      if (photos==null) return SliverToBoxAdapter(child: EmptyPage());
      if (photos.isEmpty) return SliverToBoxAdapter(child: EmptyPage());
      return photos.isNotEmpty
          ? SliverList(
              delegate: SliverChildBuilderDelegate(
                  (_, int index) => _buildHomeItem(photos[index]),
                  childCount: photos.length),
            )
          : SliverToBoxAdapter(
              child: Center(
              child: Container(
                alignment: FractionalOffset.center,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    Icon(Icons.airplay,
                        color: Colors.orangeAccent, size: 120.0),
                    Container(
                      padding: EdgeInsets.only(top: 16.0),
                      child: Text(
                        "暂时没有用户了，(" "^ _ ^)/~┴┴",
                        style: TextStyle(
                          fontSize: 40.sp,
                          color: Colors.orangeAccent,
                        ),
                      ),
                    )
                  ],
                ),
              ),
            ));
    }

    if (state is WidgetsLoadFailed) {
      return SliverToBoxAdapter(
        child: Container(
          child: Center(
            child: Container(
              padding: EdgeInsets.only(top: 150.h),
              alignment: FractionalOffset.center,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Icon(Icons.event_busy,
                      color: Colors.orangeAccent, size: 200.sp),
                  Container(
                    padding: EdgeInsets.only(top: 16.h),
                    child: Text(
                      "数据异常，(≡ _ ≡)/~┴┴",
                      style: TextStyle(
                        fontSize: 40.sp,
                        color: Colors.orangeAccent,
                      ),
                    ),
                  )
                ],
              ),
            ),
          ),
        ),
      );
    }
    if (state is CheckUserSuccess) {
      List<WidgetModel> items = state.widgets;
      List<dynamic> photos = state.photos;
      if (items.isEmpty) return EmptyPage();
      return photos.isNotEmpty
          ? SliverList(
              delegate: SliverChildBuilderDelegate(
                  (_, int index) => _buildHomeItem(photos[index]),
                  childCount: photos.length),
            )
          : SliverToBoxAdapter(
              child: Center(
              child: Container(
                alignment: FractionalOffset.center,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    Icon(Icons.airplay,
                        color: Colors.orangeAccent, size: 120.0),
                    Container(
                      padding: EdgeInsets.only(top: 16.0),
                      child: Text(
                        "暂时没有需要审核的用户了，(" "^ _ ^)/~┴┴",
                        style: TextStyle(
                          fontSize: 20,
                          color: Colors.orangeAccent,
                        ),
                      ),
                    )
                  ],
                ),
              ),
            ));
    }
    if (state is DelImgSuccess) {
      List<WidgetModel> items = state.widgets;
      List<dynamic> photos = state.photos;
      if (items.isEmpty) return EmptyPage();
      return photos.isNotEmpty
          ? SliverList(
              delegate: SliverChildBuilderDelegate(
                  (_, int index) => _buildHomeItem(photos[index]),
                  childCount: photos.length),
            )
          : SliverToBoxAdapter(
              child: Center(
              child: Container(
                alignment: FractionalOffset.center,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    Icon(Icons.airplay,
                        color: Colors.orangeAccent, size: 120.0),
                    Container(
                      padding: EdgeInsets.only(top: 16.0),
                      child: Text(
                        "暂时没有需要审核的用户了，(" "^ _ ^)/~┴┴",
                        style: TextStyle(
                          fontSize: 20,
                          color: Colors.orangeAccent,
                        ),
                      ),
                    )
                  ],
                ),
              ),
            ));
    }
    return SliverToBoxAdapter(
      child: Container(),
    );
  }

  Widget _buildHomeItem(Map<String, dynamic> photo) {
    bool isVip;
    var vipExpireTime = photo['vip_expire_time'];
    if (vipExpireTime == null) {
      isVip = false;
    } else {
      isVip = true;
    }
    return HomeItemSupport.get(null, 6, photo, isVip);
  }

  // _switchTab(int index, Color color) {
  //   BlocProvider.of<HomeBloc>(context).add(EventTabTap());
  // }

  @override
  bool get wantKeepAlive => true;
}

class FlexHeaderDelegate extends SliverPersistentHeaderDelegate {
  FlexHeaderDelegate({
    @required this.minHeight,
    @required this.maxHeight,
    @required this.childBuilder,
  });

  final double minHeight; //最小高度
  final double maxHeight; //最大高度
  final Widget Function(double offset, double max, double min)
      childBuilder; //最大高度

  @override
  double get minExtent => minHeight;

  @override
  double get maxExtent => max(maxHeight, minHeight);

  @override
  Widget build(
      BuildContext context, double shrinkOffset, bool overlapsContent) {
    return childBuilder(shrinkOffset, maxHeight, minHeight);
  }

  @override //是否需要重建
  bool shouldRebuild(FlexHeaderDelegate oldDelegate) {
    return maxHeight != oldDelegate.maxHeight ||
        minHeight != oldDelegate.minHeight;
  }
}

class bar extends StatelessWidget implements PreferredSizeWidget {
  final List<SelectItem> selectItems;
  final int roleId;

  bar({
    @required this.selectItems,
    this.roleId,
  });

  @override
  // TODO: implement preferredSize
  Size get preferredSize => Size.fromHeight(580.h);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(left: 20.w, right: 20.w),
      child: Column(
        children: [
          Expanded(
              child: AppBarComponent(
            selectItems: selectItems,
            state: _scaffoldKey,
            mode: roleId,
          )),
        ],
      ),
    );
  }
}
