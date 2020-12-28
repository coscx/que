import 'dart:math';
import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_geen/app/api/issues_api.dart';
import 'package:flutter_geen/app/utils/convert.dart';

import 'package:flutter_geen/app/router.dart';
import 'package:flutter_geen/blocs/bloc_exp.dart';
import 'package:flutter_geen/blocs/home/home_bloc.dart';
import 'package:flutter_geen/blocs/home/home_bloc.dart';
import 'package:flutter_geen/components/permanent/feedback_widget.dart';
import 'package:flutter_geen/components/permanent/overlay_tool_wrapper.dart';

import 'package:flutter_geen/model/widget_model.dart';
import 'package:flutter_geen/views/common/empty_page.dart';
import 'package:flutter_geen/views/items/home_item_support.dart';
import 'package:flutter_geen/views/pages/home/toly_app_bar.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

import 'background.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage>
    with AutomaticKeepAliveClientMixin {
  RefreshController _refreshController = RefreshController(initialRefresh: false);

  @override
  void initState() {
    super.initState();

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
    BlocProvider.of<GlobalBloc>(context).add(EventResetIndexPhotoPage());
    BlocProvider.of<GlobalBloc>(context).add((EventSetIndexNum()));
    var sex =BlocProvider.of<GlobalBloc>(context).state.sex;
    var mode =BlocProvider.of<GlobalBloc>(context).state.currentPhotoMode;
    BlocProvider.of<HomeBloc>(context).add(EventFresh(sex,mode));
    _refreshController.refreshCompleted();
  }

  // 上拉加载
  void _onLoading() async {

    List<dynamic> oldUsers = BlocProvider.of<HomeBloc>(context).state.props.elementAt(2);
    var currentPage =BlocProvider.of<GlobalBloc>(context).state.indexPhotoPage;
    var sex =BlocProvider.of<GlobalBloc>(context).state.sex;
    var mode =BlocProvider.of<GlobalBloc>(context).state.currentPhotoMode;
    BlocProvider.of<GlobalBloc>(context).add(EventIndexPhotoPage(currentPage));
    var result= await IssuesApi.getPhoto('', (++currentPage).toString(),sex.toString(),mode.toString());
    if  (result['code']==200){

    } else{

    }
    List<dynamic> newUsers =[];
    oldUsers.forEach((element) {
      newUsers.add(element);
    });
    newUsers.addAll(result['data']['photo_list']);
    BlocProvider.of<HomeBloc>(context).add(EventLoadMore(newUsers));
    _refreshController.loadComplete();
  }
  @override
  Widget build(BuildContext context) {
    super.build(context);

    return Scaffold(
        body:  BlocListener<HomeBloc, HomeState>(
        listener: (ctx, state) {
      if (state is CheckUserSuccess) {

        BlocProvider.of<GlobalBloc>(context).add((EventSetIndexNum()));
        Scaffold.of(context).showSnackBar(SnackBar(
          content: Text('审核成功'+state.Reason),
          backgroundColor: Colors.green,
        ));

      }
      if (state is DelImgSuccess) {
        Scaffold.of(context).showSnackBar(SnackBar(
          content: Text('删除成功'),
          backgroundColor: Colors.blue,
        ));

      }
    },
    child:BlocBuilder<HomeBloc, HomeState>(builder: (ctx, state) {
      return Stack(
        children: <Widget>[

          BlocBuilder<GlobalBloc, GlobalState>(builder: _buildBackground),

          ScrollConfiguration(
          behavior: DyBehaviorNull(),
          child:
              SmartRefresher(
                enablePullDown: true,
                enablePullUp: true,
                header: DYrefreshHeader(),
                footer: DYrefreshFooter(),
                controller: _refreshController,
                onRefresh: _onRefresh,
                onLoading: _onLoading,
                child:  CustomScrollView(
                  physics: BouncingScrollPhysics(),
                  slivers: <Widget>[
                    BlocBuilder<GlobalBloc, GlobalState>(builder: _buildHeadNum),
                     SliverToBoxAdapter(
                    child:  BlocBuilder<GlobalBloc, GlobalState>(builder: _buildHead),


                    ),


                    _buildContent(ctx, state),
                  ],
                ),
              )
          ),

        ],
      );
    }
    )
        )
    );
  }
  void _onValueChanged(int value) {
    BlocProvider.of<GlobalBloc>(context).add(EventSetIndexSex(value));
    var mode =BlocProvider.of<GlobalBloc>(context).state.currentPhotoMode;
    BlocProvider.of<HomeBloc>(context).add(EventFresh(value,mode));
  }

  Widget _buildHead(BuildContext context, GlobalState state) {

    return Container(
        child:  Container(child:

        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          mainAxisSize: MainAxisSize.max,
//                交叉轴的布局方式，对于column来说就是水平方向的布局方式
          crossAxisAlignment: CrossAxisAlignment.center,
          //就是字child的垂直布局方向，向上还是向下
          verticalDirection: VerticalDirection.down,
          children: <Widget>[
            SizedBox(
              width: 1,
            ),
            SizedBox(
              width: 40,
              child: Text("筛选:"),
            ),
            CupertinoSegmentedControl<int>(
              //unselectedColor: Colors.yellow,
              //selectedColor: Colors.green,
              //pressedColor: Colors.blue,
              //borderColor: Colors.red,
              groupValue: state.sex==0 ? 1: state.sex,
              onValueChanged: _onValueChanged,
              padding: EdgeInsets.only(right: 0),
              children: {
                1: state.sex ==1 ?Padding(
                  padding: EdgeInsets.only(left: 40, right: 40),
                  child: Text("男"),
                ):Text("男"),
                2: state.sex ==2 ?Padding(
                  padding: EdgeInsets.only(left: 40, right: 40),
                  child: Text("女"),
                ):Text("女"),

              },
            ),

            buildHeadTxt(context,state),
            PopupMenuButton<String>(
              itemBuilder: (context) => buildItems(),
              offset: Offset(0, 40),
              color: Color(0xffF4FFFA),
              elevation: 1,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(20),
                    bottomRight: Radius.circular(20),
                    topRight: Radius.circular(5),
                    bottomLeft: Radius.circular(5),
                  )),
              onSelected: (e) {
                print(e);
                if (e == '待审') {
                  BlocProvider.of<GlobalBloc>(context).add(EventSetIndexMode(1));
                  var sex =BlocProvider.of<GlobalBloc>(context).state.sex;
                  BlocProvider.of<HomeBloc>(context).add(EventFresh(sex,1));
                }
                if (e == '已审') {
                  BlocProvider.of<GlobalBloc>(context).add(EventSetIndexMode(2));
                  var sex =BlocProvider.of<GlobalBloc>(context).state.sex;
                  BlocProvider.of<HomeBloc>(context).add(EventFresh(sex,2));
                }
                if (e == '隐藏') {
                  BlocProvider.of<GlobalBloc>(context).add(EventSetIndexMode(4));
                  var sex =BlocProvider.of<GlobalBloc>(context).state.sex;
                  BlocProvider.of<HomeBloc>(context).add(EventFresh(sex,4));
                }
              },
              onCanceled: () => print('onCanceled'),
            )

          ],
        )



        )
    );
  }
  List<PopupMenuItem<String>> buildItems() {
    final map = {
      "待审": Icons.zoom_in,
      "已审": Icons.check,
      "隐藏": Icons.app_blocking,
    };
    return map.keys
        .toList()
        .map((e) => PopupMenuItem<String>(
        value: e,
        child: Wrap(
          spacing: 10,
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
    if(state.currentPhotoMode==1){
     return SizedBox(
        width: 50,
        child: Text("待审核"),
      );

    }
    if(state.currentPhotoMode==2){
      return SizedBox(
        width: 50,
        child: Text("已审核"),
      );

    }
    if(state.currentPhotoMode==4){
      return SizedBox(
        width: 50,
        child: Text("已隐藏"),
      );

    }
    return SizedBox(
      width: 50,
      child: Text("待审核"),
    );
  }
  Widget _buildPersistentHeader(List<String> num) => SliverPersistentHeader(
      pinned: true,
      delegate: FlexHeaderDelegate(
          minHeight: 25 + 56.0,
          maxHeight: 120.0,
          childBuilder: (offset, max, min) {
            double dy = max - 25 - offset;

            if (dy < min - 25) {
              dy = min - 25;
            }
            return TolyAppBar(
              maxHeight: dy,
              onItemClick: _switchTab,
              nums: num,
            );
          }));

  Widget _buildBackground(BuildContext context, GlobalState state) {
    if (state.showBackGround) {
      return BackgroundShower();
    }
    return Container();
  }
  Widget _buildHeadNum(BuildContext context, GlobalState state) {

    return _buildPersistentHeader(state.headNum);
  }
  Widget _buildContent(BuildContext context, HomeState state) {
    if (state is WidgetsLoading) {
      return SliverToBoxAdapter(
        child: Container(),
      );
    }

    if (state is WidgetsLoaded) {
      List<WidgetModel> items = state.widgets;
      List<dynamic>  photos=state.photos;
      if (items.isEmpty) return EmptyPage();
      return photos.isNotEmpty?SliverList(
        delegate: SliverChildBuilderDelegate(
            (_, int index) => _buildHomeItem(items[0],photos[index]),
            childCount: photos.length),
      ):SliverToBoxAdapter(
          child:Center(child: Container(
        alignment: FractionalOffset.center,
        child:  Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Icon(Icons.airplay, color: Colors.orangeAccent, size: 120.0),
            Container(
              padding:  EdgeInsets.only(top: 16.0),
              child:  Text(
                "暂时没有需要审核的用户了，(""^ _ ^)/~┴┴",
                style:  TextStyle(
                  fontSize: 20,
                  color: Colors.orangeAccent,
                ),
              ),
            )
          ],
        ),
      ),));
    }

    if (state is WidgetsLoadFailed) {
      return SliverToBoxAdapter(
        child: Container(
          child: Center(child: Container(
            alignment: FractionalOffset.center,
            child:  Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Icon(Icons.event_busy, color: Colors.orangeAccent, size: 120.0),
                Container(
                  padding:  EdgeInsets.only(top: 16.0),
                  child:  Text(
                    "数据异常，(≡ _ ≡)/~┴┴",
                    style:  TextStyle(
                      fontSize: 20,
                      color: Colors.orangeAccent,
                    ),
                  ),
                )
              ],
            ),
          ),),
        ),
      );
    }
    if (state is CheckUserSuccess) {
      List<WidgetModel> items = state.widgets;
      List<dynamic>  photos=state.photos;
      if (items.isEmpty) return EmptyPage();
      return photos.isNotEmpty?SliverList(
        delegate: SliverChildBuilderDelegate(
                (_, int index) => _buildHomeItem(items[index],photos[index]),
            childCount: photos.length),
      ):SliverToBoxAdapter(
          child:Center(child: Container(
        alignment: FractionalOffset.center,
        child:  Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Icon(Icons.airplay, color: Colors.orangeAccent, size: 120.0),
            Container(
              padding:  EdgeInsets.only(top: 16.0),
              child:  Text(
                "暂时没有需要审核的用户了，(""^ _ ^)/~┴┴",
                style:  TextStyle(
                  fontSize: 20,
                  color: Colors.orangeAccent,
                ),
              ),
            )
          ],
        ),
      ),));
    }
    if (state is DelImgSuccess) {
      List<WidgetModel> items = state.widgets;
      List<dynamic>  photos=state.photos;
      if (items.isEmpty) return EmptyPage();
      return photos.isNotEmpty?SliverList(
        delegate: SliverChildBuilderDelegate(
                (_, int index) => _buildHomeItem(items[index],photos[index]),
            childCount: photos.length),
      ):SliverToBoxAdapter(
          child:Center(child: Container(
        alignment: FractionalOffset.center,
        child:  Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Icon(Icons.airplay, color: Colors.orangeAccent, size: 120.0),
            Container(
              padding:  EdgeInsets.only(top: 16.0),
              child:  Text(
                "暂时没有需要审核的用户了，(""^ _ ^)/~┴┴",
                style:  TextStyle(
                  fontSize: 20,
                  color: Colors.orangeAccent,
                ),
              ),
            )
          ],
        ),
      ),));
    }
    return SliverToBoxAdapter(
      child: Container(),
    );
  }

  Widget _buildHomeItem(WidgetModel model,Map<String,dynamic> photo) =>
      //BlocBuilder<GlobalBloc, GlobalState>(
       // condition: (p, c) => (p.itemStyleIndex != c.itemStyleIndex),
       // builder: (_, state) {
           HomeItemSupport.get(model, 6 ,photo);
       // },
     // );

  _switchTab(int index, Color color) {
    BlocProvider.of<HomeBloc>(context)
        .add(EventTabTap(Convert.toFamily(index)));
  }

  _toDetailPage(WidgetModel model,Map<String,dynamic> photo) {
    BlocProvider.of<DetailBloc>(context).add(FetchWidgetDetail(model,photo));
    Navigator.pushNamed(context, UnitRouter.widget_detail, arguments: model);
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
      complete: Row(
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

class DyBehaviorNull extends ScrollBehavior {
  @override
  Widget buildViewportChrome(BuildContext context, Widget child, AxisDirection axisDirection) {
    if (Platform.isAndroid || Platform.isFuchsia) {
      return child;
    } else {
      return super.buildViewportChrome(context,child,axisDirection);
    }
  }
}