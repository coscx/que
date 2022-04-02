import 'dart:math';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_geen/app/api/issues_api.dart';
import 'package:flutter_geen/app/router.dart';
import 'package:flutter_geen/blocs/bloc_exp.dart';
import 'package:flutter_geen/views/pages/home/gzx_filter_goods_page.dart';
import 'package:flutter_geen/views/component/refresh.dart';
import 'package:flutter_geen/views/items/SearchParamModel.dart';
import 'package:flutter_geen/views/items/drop_menu_leftWidget.dart';
import 'package:flutter_geen/views/items/connect_widget_list_item.dart';
import 'package:flutter_geen/views/common/empty_page.dart';
import 'package:flutter_geen/views/pages/utils/DyBehaviorNull.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';


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

class ConnectPage extends StatefulWidget {
  @override
  _ConnectPageState createState() => _ConnectPageState();
}

class _ConnectPageState extends State<ConnectPage>
    with AutomaticKeepAliveClientMixin {

  RefreshController _refreshController =
      RefreshController(initialRefresh: false);
   List<SelectItem> selectItems = <SelectItem>[];
  bool _showFilter = false;
  bool _showSort = false;

  bool _showAge = false;
  int _showAgeMin = 16;
  int _showAgeMax = 70;

  int _selectedIndex = 999;
  String serveType = "1";
  String totalCount = "";
  String title = "昨日今日沟通";
  static List<SortModel> _leftWidgets = [
    SortModel(name: "服务中", isSelected: true, code: "2"),
    SortModel(name: "跟进中", isSelected: false, code: "1"),
    SortModel(name: "已签约", isSelected: false, code: "3"),
    SortModel(name: "即将过期", isSelected: false, code: "4"),
  ];

  SearchParamList searchParamList = SearchParamList(list: []);




  @override
  void initState() {
    super.initState();
    BlocProvider.of<ConnectBloc>(context).add(EventConnectFresh(0, 0, null, null, 0, 0, "0", []));
    // WidgetsBinding.instance.addPostFrameCallback((callback) {
    //   OverlayToolWrapper.of(context).showFloating();
    // });
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
    BlocProvider.of<GlobalBloc>(context).add(EventResetIndexConnectPage());

    var sex = BlocProvider.of<GlobalBloc>(context).state.sex;
    var mode = BlocProvider.of<GlobalBloc>(context).state.currentPhotoMode;
    BlocProvider.of<ConnectBloc>(context).add(EventConnectFresh(
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
        BlocProvider.of<ConnectBloc>(context).state.props.elementAt(0);
    var currentPage = BlocProvider.of<GlobalBloc>(context).state.indexConnectPage;
    BlocProvider.of<GlobalBloc>(context).add(EventIndexConnectPage(currentPage));
    currentPage++;
    var result = await IssuesApi.getYesterdayConnect("",currentPage.toString(),"","");
    if (result['code'] == 200) {
    } else {

    }
    List<dynamic> newUsers = [];
    oldUsers.forEach((element) {
      newUsers.add(element);
    });
    newUsers.addAll(result['data']['data']);
    BlocProvider.of<ConnectBloc>(context).add(EventConnectLoadMore(newUsers));
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
              backgroundColor: Colors.white,
              elevation: 0,
              //去掉Appbar底部阴影
              leading: IconButton(
                icon: Icon(Icons.arrow_back, color: Colors.black),
                onPressed: () => Navigator.of(context).pop(),
              ),
              title: Text("昨日今日沟通",
                  style: TextStyle(
                    fontFamily: "Quicksand",
                    fontWeight: FontWeight.w900,
                    fontStyle: FontStyle.italic,
                    fontSize: 38.sp,
                    decoration: TextDecoration.none,
                    color: Colors.black,
                  )),
              //去掉Appbar底部阴影
              actions: <Widget>[

                SizedBox(width: 20),


              ],

              //bottom: bar(),
            ),
            body: BlocListener<ConnectBloc, ConnectState>(
                listener: (ctx, state) {
                  if (state is ConnectCheckUserSuccess) {
                    BlocProvider.of<GlobalBloc>(context)
                        .add((EventSetIndexNum()));
                    Scaffold.of(context).showSnackBar(SnackBar(
                      content: Text('审核成功' + state.Reason),
                      backgroundColor: Colors.green,
                    ));
                  }
                  if (state is ConnectDelImgSuccess) {
                    Scaffold.of(context).showSnackBar(SnackBar(
                      content: Text('删除成功'),
                      backgroundColor: Colors.blue,
                    ));
                  }
                  if (state is ConnectUnauthenticated) {
                    Navigator.of(context)
                        .pushReplacementNamed(UnitRouter.login);
                  }

                  if (state is ConnectWidgetsLoaded) {

                    totalCount = state.count;

                  }
                },
                child: Container(

                  child:
                      BlocBuilder<ConnectBloc, ConnectState>(builder: (ctx, state) {
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

  Widget _buildContent(BuildContext context, ConnectState state) {
    if (state is ConnectWidgetsLoading) {
      return SliverToBoxAdapter(
        child: Container(),
      );
    }

    if (state is ConnectWidgetsLoaded) {
      List<dynamic> photos = state.photos;
      if (photos==null) return SliverToBoxAdapter(child: EmptyPage());
      if (photos.isEmpty) return SliverToBoxAdapter(child: EmptyPage());
      return photos.isNotEmpty
          ? SliverList(
        delegate: SliverChildBuilderDelegate(
                (_, int index) => ConnectWidgetListItem(photo:photos[index]),
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

    if (state is ConnectWidgetsLoadFailed) {
      return SliverToBoxAdapter(
        child: Container(
          child: Center(
            child: Container(
              padding: EdgeInsets.only(top: 200.h),
              alignment: FractionalOffset.center,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Icon(Icons.event_busy,
                      color: Colors.orangeAccent, size: 200.sp),
                  Container(
                    padding: EdgeInsets.only(top: 20.h),
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








