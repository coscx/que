/*
 * @discripe: 正在直播列表
 */
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_geen/app/router.dart';
import 'package:flutter_geen/blocs/detail/detail_bloc.dart';
import 'package:flutter_geen/blocs/detail/detail_event.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:cached_network_image/cached_network_image.dart';

final String defaultImg =
    'https://img.bosszhipin.com/beijin/mcs/useravatar/20171211/4d147d8bb3e2a3478e20b50ad614f4d02062e3aec7ce2519b427d24a3f300d68_s.jpg';
final _random = Random();

int next(int min, int max) => min + _random.nextInt(max - min);

class MyFlow extends StatelessWidget {
  final List<dynamic> liveData;

  MyFlow({this.liveData});

  // 跳转直播间
  void _goToLiveRoom(context, item) {
    Map<String, dynamic> photo = Map<String, dynamic>();
    photo['uuid'] = item['uuid'];
    BlocProvider.of<DetailBloc>(context).add(FetchWidgetDetail(photo));
    Navigator.pushNamed(context, UnitRouter.widget_detail);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      child: Column(children: <Widget>[
        //_listTableHeader(),
        _listTableInfo(context, liveData),
      ]),
    );
  }


  String getExt(String name) {
    var m = "";
    var d = name.split(".");
    for (int i = 0; i < d.length; i++) {
      m = d[i];
    }
    return m;
  }

  // 直播列表详情
  Widget _listTableInfo(context, List<dynamic> liveData) {
    final liveList = <Widget>[];

    var boxWidth = ScreenUtil().screenWidth / 2 - 40.w;
    var imageHeight = 200.h;
    var boxMargin = 10.w;

    liveData.asMap().keys.forEach((index) {
      var item = liveData[index];
      liveList.add(
        GestureDetector(
          onTap: () {
            _goToLiveRoom(context, item);
          },
          child: Padding(
            key: ObjectKey(item['id']),
            padding:
                EdgeInsets.only(left: 20.w, right: 20.w, bottom: boxMargin * 2),
            child: Column(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.all(
                    Radius.circular(12.w),
                  ),
                  child: Container(
                    width: boxWidth,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: <Widget>[
                        CachedNetworkImage(
                          imageUrl: item['img'] != ""
                              ? (getExt(item['img']) != "mp4"
                                  ? item['img']
                                  : defaultImg)
                              : defaultImg,
                          imageBuilder: (context, imageProvider) => Container(
                            height: imageHeight,
                            decoration: BoxDecoration(
                              image: DecorationImage(
                                image: imageProvider,
                                fit: BoxFit.cover,
                              ),
                            ),
                            child: Stack(
                              children: <Widget>[
                                Positioned(
                                  child: Container(
                                    width: boxWidth,
                                    height: 70.h,
                                    padding: EdgeInsets.only(
                                      left: 10.w,
                                      right: 10.w,
                                    ),
                                    decoration:
                                        BoxDecoration(color: Color(0x20000000)),
                                    child: Row(
                                      children: <Widget>[
                                        Container(
                                          width: ScreenUtil().screenWidth / 2 -
                                              70.w,
                                          //height: 200.h,
                                          child: Text(item['title'],
                                              maxLines: 3,
                                              overflow: TextOverflow.ellipsis,
                                              style: TextStyle(
                                                  fontSize: 25.sp,
                                                  color: Colors.white)),
                                        ),
                                      ],
                                    ),
                                  ),
                                  bottom: 0,
                                  left: 0,
                                ),
                              ],
                            ),
                          ),
                          placeholder: (context, url) => Image.asset(
                            'assets/images/default/img_default.png',
                            height: imageHeight,
                            fit: BoxFit.fill,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                Container(
                  width: ScreenUtil().screenWidth / 2 - 50.w,
                  color: Colors.transparent,
                  child: Column(
                    children: [
                      SizedBox(
                        height: 30.h,
                        child: Row(children: [
                          Container(
                            width: 80.w,
                            padding: EdgeInsets.only(left: 0.w, right: 0.w),
                            //width: 200.w,
                            child: Text(
                              item['customer_name'],
                              textAlign: TextAlign.start,
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                                fontSize: 23.sp,
                              ),
                            ),
                          ),
                          Container(
                            padding: EdgeInsets.only(left: 0.w, right: 5.w),
                            //width: 200.w,
                            child: Text(
                              item['gender'] == 1 ? "男" : "女",
                              textAlign: TextAlign.start,
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                                fontSize: 23.sp,
                              ),
                            ),
                          ),
                          Container(
                            padding: EdgeInsets.only(left: 0.w, right: 5.w),
                            //width: 200.w,
                            child: Text(
                              item['age'].toString(),
                              textAlign: TextAlign.start,
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                                fontSize: 30.sp,
                              ),
                            ),
                          ),
                          Container(
                            padding: EdgeInsets.only(left: 0.w, right: 0.w),
                            //width: 200.w,
                            child: Text(
                              "来源:" + item['store'],
                              textAlign: TextAlign.start,
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                                fontSize: 23.sp,
                              ),
                            ),
                          )
                        ]),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      );
    });

    return Wrap(
      children: liveList,
    );
  }
}
