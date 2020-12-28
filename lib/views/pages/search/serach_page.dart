import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_geen/app/router.dart';
import 'package:flutter_geen/app/res/toly_icon.dart';
import 'package:flutter_geen/blocs/bloc_exp.dart';
import 'package:flutter_geen/components/permanent/circle.dart';
import 'package:flutter_geen/storage/dao/widget_dao.dart';
import 'package:flutter_geen/model/widget_model.dart';
import 'package:flutter_geen/views/items/photo_search_widget_list_item.dart';
import 'package:flutter_geen/views/items/photo_widget_list_item.dart';
import 'package:flutter_geen/views/items/techno_widget_list_item.dart';
import 'package:flutter_geen/views/pages/search/app_search_bar.dart';
import 'package:flutter_geen/views/pages/search/error_page.dart';
import 'package:flutter_geen/views/common/loading_page.dart';
import 'package:flutter_geen/views/pages/search/not_search_page.dart';
import 'package:flutter_geen/components/permanent/multi_chip_filter.dart';

import 'empty_page.dart';


class SearchPage extends StatefulWidget {
  @override
  _SearchPageState createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  var _scaffoldkey = new GlobalKey<ScaffoldState>();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        key: _scaffoldkey,
      body: WillPopScope(
        onWillPop: () async {
          //返回时 情空搜索
          BlocProvider.of<SearchBloc>(context).add(EventTextChanged(args: SearchArgs()));
          return true;
        },
        child: CustomScrollView(
          slivers: <Widget>[
              _buildSliverAppBar(),
            SliverToBoxAdapter(child: _buildStarFilter()),
        BlocListener<SearchBloc, SearchState>(
          listener: (ctx, state) {
            if (state is CheckUserSuccesses) {


              _scaffoldkey.currentState.showSnackBar(SnackBar(
                content: Text('审核成功'+state.Reason),
                backgroundColor: Colors.green,
              ));

            }
            if (state is DelImgSuccesses) {
              _scaffoldkey.currentState.showSnackBar(SnackBar(
                content: Text('删除成功'),
                backgroundColor: Colors.blue,
              ));

            }
          },
          child:BlocBuilder<SearchBloc, SearchState>(builder:_buildBodyByState)
        )
          ],
        ),
      ),
    );
  }

  Widget _buildSliverAppBar() {
    return SliverAppBar(
            pinned: true,
            title: AppSearchBar(),
            actions: <Widget>[
              Padding(
                padding: const EdgeInsets.only(right: 15.0),
                child: Icon(TolyIcon.icon_sound),
              )
            ],
          );
  }

  Widget _buildStarFilter() => Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.only(top: 10.0, left: 20, bottom: 5),
            child: Wrap(
              spacing: 5,
              crossAxisAlignment: WrapCrossAlignment.center,
              children: <Widget>[
                Circle(
                  radius: 5,
                  color: Colors.orange,
                ),
                Text(
                  '用户查询',
                  style: TextStyle(
                      color: Theme.of(context).primaryColor,
                      fontWeight: FontWeight.bold),
                ),
              ],
            ),
          ),
          MultiChipFilter<int>(
            data: [1, 2, 3, 4, 5],
            avatarBuilder: (_, index) =>
                CircleAvatar(child: Text((index + 1).toString())),
            labelBuilder: (_, selected) => Icon(
              Icons.star,
              color: selected ? Colors.blue : Colors.grey,
              size: 18,
            ),
            onChange: _doSelectStart,
          ),
          Divider()
        ],
      );

  Widget _buildBodyByState(BuildContext context,SearchState state) {
    if (state is SearchStateNoSearch)
      return SliverToBoxAdapter(child: NotSearchPage(),);
    if (state is SearchStateLoading)
      return SliverToBoxAdapter(child: LoadingPage());
    if (state is SearchStateError)
      return SliverToBoxAdapter(child: ErrorPage());
    if (state is SearchStateSuccess)
      return _buildSliverList(state.result,state.photos);

    if (state is CheckUserSuccesses)
      return _buildSliverList(state.widgets,state.photos);
    if (state is DelImgSuccesses)
      return _buildSliverList(state.widgets,state.photos);


    if (state is SearchStateEmpty)
      return SliverToBoxAdapter(child: EmptyPage());
    return NotSearchPage();
  }

  Widget _buildSliverList(List<WidgetModel> models , List<dynamic>  photos) => SliverList(
        delegate: SliverChildBuilderDelegate(
            (_, int index) => Container(
                child: InkWell(
                    //onTap: () => _toDetailPage(models[0],photos[index]),
                    child:  PhotoSearchWidgetListItem(isClip: false, data: models[0],photo: photos[index],)
                )),
            childCount: photos.length),
      );

  _doSelectStart(List<int> select) {
    List<int> temp = select.map((e)=>e+1).toList();
    if (temp.length < 5) {
      temp.addAll(List.generate(5 - temp.length, (e) => -1));
    }
    BlocProvider.of<SearchBloc>(context)
        .add(EventTextChanged(args: SearchArgs(name: '', stars: temp)));
  }

  _toDetailPage(WidgetModel model,Map<String,dynamic>  photos) {
   //Map<String,dynamic> photo;
    BlocProvider.of<DetailBloc>(context).add(FetchWidgetDetail(model,photos));
    Navigator.pushNamed(context, UnitRouter.widget_detail,arguments: model);
  }
}
