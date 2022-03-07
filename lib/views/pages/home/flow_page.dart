import 'dart:math';
import 'package:bot_toast/bot_toast.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_geen/app/api/issues_api.dart';
import 'package:flutter_geen/app/router.dart';
import 'package:flutter_geen/blocs/bloc_exp.dart';
import 'package:flutter_geen/blocs/flow/flow_bloc.dart';
import 'package:flutter_geen/components/permanent/overlay_tool_wrapper.dart';
import 'package:flutter_geen/views/dialogs/delete_category_dialog.dart';
import 'package:flutter_geen/views/pages/home/gzx_filter_goods_page.dart';
import 'package:flutter_geen/views/dialogs/user_detail.dart';
import 'package:flutter_geen/views/items/SearchParamModel.dart';

import 'package:flutter_geen/views/items/drop_menu_leftWidget.dart';

import 'package:flutter_geen/views/common/empty_page.dart';


import 'package:flutter_geen/views/pages/utils/DyBehaviorNull.dart';

import 'package:permission_handler/permission_handler.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'flow.dart';

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

class FlowPage extends StatefulWidget {
  @override
  _FlowPageState createState() => _FlowPageState();
}

class _FlowPageState extends State<FlowPage>
    with AutomaticKeepAliveClientMixin {

  RefreshController _refreshController =
      RefreshController(initialRefresh: false);

  bool _showFilter = false;
  bool _showSort = false;

  bool _showAge = false;
  int _showAgeMin = 16;
  int _showAgeMax = 70;

  int _selectedIndex = 999;
  String serveType = "1";
  String totalCount = "";
  String title = "微信推文";
  static List<SortModel> _leftWidgets = [
    SortModel(name: "服务中", isSelected: true, code: "2"),
    SortModel(name: "跟进中", isSelected: false, code: "1"),
    SortModel(name: "已签约", isSelected: false, code: "3"),
    SortModel(name: "即将过期", isSelected: false, code: "4"),
  ];

  SearchParamList searchParamList = SearchParamList(list: []);
  List<SelectItem> selectItems = <SelectItem>[];



  @override
  void initState() {
    super.initState();
    BlocProvider.of<FlowBloc>(context).add(EventFlowFresh(0, 0, null, null, 0, 0, "0", null));
    WidgetsBinding.instance.addPostFrameCallback((callback) {
      OverlayToolWrapper.of(context).showFloating();
    });
    Future.delayed(Duration(milliseconds: 2500)).then((e) async {
      //_onRefresh();
    });
  }

  @override
  void dispose() {
    _refreshController?.dispose();
    super.dispose();
  }

  // 下拉刷新
  void _onRefresh() async {
    BlocProvider.of<GlobalBloc>(context).add(EventResetIndexFlowPage());

    var sex = BlocProvider.of<GlobalBloc>(context).state.sex;
    var mode = BlocProvider.of<GlobalBloc>(context).state.currentPhotoMode;
    BlocProvider.of<FlowBloc>(context).add(EventFlowFresh(
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
    List<dynamic> oldUsers =
        BlocProvider.of<FlowBloc>(context).state.props.elementAt(0);
    var currentPage = BlocProvider.of<GlobalBloc>(context).state.indexFlowPage;
    BlocProvider.of<GlobalBloc>(context).add(EventIndexFlowPage(currentPage));
    currentPage++;
    var result = await IssuesApi.getFlowData(currentPage);
    if (result['code'] == 200) {
    } else {

    }
    List<dynamic> newUsers = [];
    oldUsers.forEach((element) {
      newUsers.add(element);
    });
    newUsers.addAll(result['data']['data']);
    BlocProvider.of<FlowBloc>(context).add(EventFlowLoadMore(newUsers));
    _refreshController.loadComplete();
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

            appBar: AppBar(
              titleSpacing: 40.w,
              leadingWidth: 0,
              title: Row(
                children: [
                  Text(title,
                      style: TextStyle(
                          color: Colors.black,
                          fontSize: 48.sp,
                          fontWeight: FontWeight.bold)),

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


              ],

              //bottom: bar(),
            ),
            body: BlocListener<FlowBloc, FlowState>(
                listener: (ctx, state) {
                  if (state is FlowCheckUserSuccess) {
                    BlocProvider.of<GlobalBloc>(context)
                        .add((EventSetIndexNum()));
                    Scaffold.of(context).showSnackBar(SnackBar(
                      content: Text('审核成功' + state.Reason),
                      backgroundColor: Colors.green,
                    ));
                  }
                  if (state is FlowDelImgSuccess) {
                    Scaffold.of(context).showSnackBar(SnackBar(
                      content: Text('删除成功'),
                      backgroundColor: Colors.blue,
                    ));
                  }
                  if (state is FlowUnauthenticated) {
                    Navigator.of(context)
                        .pushReplacementNamed(UnitRouter.login);
                  }

                  if (state is FlowWidgetsLoaded) {
                    var data = state.photos;
                    // print(data.toString());
                    var mode = BlocProvider.of<GlobalBloc>(context)
                        .state
                        .currentPhotoMode;
                    if (mode == 0) {
                      title = "微信推文";
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
                  }
                },
                child: Container(

                  child:
                      BlocBuilder<FlowBloc, FlowState>(builder: (ctx, state) {
                    return Stack(
                      children: <Widget>[
                        //BlocBuilder<GlobalBloc, GlobalState>(builder: _buildBackground),

                        Container(
                          padding: EdgeInsets.only(top: 0.h),
                          child: ScrollConfiguration(
                              behavior: DyBehaviorNull(),
                              child: SmartRefresher(
                                enablePullDown: true,
                                enablePullUp: true,
                                header: DYrefreshHeader(),
                                footer: DYrefreshFooter(),
                                controller: _refreshController,
                                onRefresh: _onRefresh,
                                onLoading: _onLoading,
                                child: CustomScrollView(
                                  physics: BouncingScrollPhysics(),
                                  slivers: <Widget>[
                                    _buildContent(ctx, state),
                                  ],
                                ),
                              )),
                        ),
                      ],
                    );
                  }),
                ))));
  }

  Widget _buildContent(BuildContext context, FlowState state) {
    if (state is FlowWidgetsLoading) {
      return SliverToBoxAdapter(
        child: Container(),
      );
    }

    if (state is FlowWidgetsLoaded) {
      List<dynamic> photos = state.photos;
      if (photos.isEmpty) return SliverToBoxAdapter(child: EmptyPage());
      return photos.isNotEmpty
          ? SliverToBoxAdapter(
          child: Center(
            child: Container(
              alignment: FractionalOffset.center,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  MyFlow(liveData: photos,)
                ],
              ),
            ),
          ))
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

    if (state is FlowWidgetsLoadFailed) {
      return SliverToBoxAdapter(
        child: Container(
          child: Center(
            child: Container(
              alignment: FractionalOffset.center,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Icon(Icons.event_busy,
                      color: Colors.orangeAccent, size: 120.0),
                  Container(
                    padding: EdgeInsets.only(top: 16.0),
                    child: Text(
                      "数据异常，(≡ _ ≡)/~┴┴",
                      style: TextStyle(
                        fontSize: 20,
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

    return SliverToBoxAdapter(
      child: Container(),
    );
  }



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

// 下拉刷新头部、底部组件
class DYrefreshHeader extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return WaterDropHeader(
      waterDropColor: Colors.blue,
      refresh: SizedBox(
        width: 25.0,
        height: 25.0,
        child: CircularProgressIndicator(
          strokeWidth: 2.0,
          valueColor: AlwaysStoppedAnimation<Color>(Colors.blue),
        ),
      ),
      complete: Container(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Icon(
              Icons.insert_emoticon,
              color: Colors.blue,
            ),
            Container(
              width: 15.0,
            ),
            Text(
              '更新好啦~',
              style: TextStyle(color: Colors.blue),
            )
          ],
        ),
      ),
      idleIcon: Icon(
        Icons.favorite,
        size: 14.0,
        color: Colors.white,
      ),
    );
  }
}

class DYrefreshFooter extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ClassicFooter(
      textStyle: TextStyle(color: Colors.blue),
      loadingText: '我正在努力...',
      failedText: '加载失败了~',
      idleText: '上拉加载更多~',
      canLoadingText: '释放加载更多~',
      noDataText: '没有更多啦~',
      failedIcon: Icon(Icons.insert_emoticon, color: Colors.blue),
      canLoadingIcon: Icon(Icons.insert_emoticon, color: Colors.blue),
      idleIcon: Icon(Icons.insert_emoticon, color: Colors.blue),
      loadingIcon: SizedBox(
        width: 25.0,
        height: 25.0,
        child: CircularProgressIndicator(
          strokeWidth: 2.0,
          valueColor: AlwaysStoppedAnimation<Color>(Colors.blue),
        ),
      ),
    );
  }
}






