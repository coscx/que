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



final _random = Random();
int next(int min, int max) => min + _random.nextInt(max - min);
final int _baseLiveNum = next(1e3.round() + 1, 1e4.round());

class MyFlow extends StatelessWidget  {
  final List<dynamic> liveData;
  MyFlow({this.liveData});
  // 跳转直播间
  void _goToLiveRoom(context, item) {
    Map<String,dynamic> photo = Map<String,dynamic>();
    photo['uuid'] = item['uuid'];
    BlocProvider.of<DetailBloc>(context).add(FetchWidgetDetail(photo));
    Navigator.pushNamed(context, UnitRouter.widget_detail);
  }

  @override
  Widget build(BuildContext context) {
     return Container(
            color: Colors.white,
            child: Column(
                children: <Widget>[
                  //_listTableHeader(),
                  _listTableInfo(context,liveData),
                ]
            ),
          );

  }

  Iterable<Widget> _numberList() {
    int liveDataLen = 0;
    String liveDataLenStr = liveDataLen.toString();
    return liveDataLenStr.split('').map((number) => Image.asset(
      'assets/images/num/$number.webp',
      height: 13.h,
    ));
  }

  // 直播列表头部
  Widget _listTableHeader() {
    var numberList = _numberList();
    return Container(
      height: 52.h,
      margin: EdgeInsets.only(
        left: 15.w,
        right: 15.w,
      ),
      child: Row(
        children: <Widget>[
          Container(
            width: 25.w,
            margin: EdgeInsets.only(right: 5.w),
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage('assets/images/cqe.webp'),
                fit: BoxFit.fitWidth,
              ),
            ),
          ),
          Expanded(
            child: Text(
              '猜你喜欢',
              style: TextStyle(
                  color: Color(0xff333333),
                  fontSize: 24.sp,
                  fontWeight: FontWeight.bold
              ),
            ),
          ),
          Row(
            children: <Widget>[
              Padding(
                padding: EdgeInsets.only(right: 1.5.w),
                child:  Text(
                  '当前共',
                  style: TextStyle(
                    color: Color(0xfff8632e),
                    fontSize: 24.sp,
                  ),
                ),
              ),
              ...numberList,
              Padding(
                padding: EdgeInsets.only(left: 1.5.w),
                child: Text(
                  '位嘉宾',
                  style: TextStyle(
                    color: Color(0xfff8632e),
                    fontSize: 23.sp,
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.only(left: 5.w),
                child: Image.asset(
                  'assets/images/cfk.webp',
                  height: 24.h,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  List<Widget> _renderTag(showKingTag) {
    if (showKingTag) {
      return [
        Container(
          height: 18.h,
          decoration: BoxDecoration(
            color: Color(0xfffcf0e2),
            borderRadius: BorderRadius.all(
              Radius.circular(9),
            ),
          ),
          child: Center(
            child: Padding(
              padding: EdgeInsets.only(
                left: 6.w, right: 6.w,
              ),
              child: Text(
                '推荐',
                textAlign: TextAlign.start,
                style: TextStyle(
                  fontSize: 10.sp,
                  color: Color(0xfff7802c),
                ),
              ),
            ),
          ),
        ),
      ];
    }
    return [
      Text(
        '颜值',
        textAlign: TextAlign.start,
        style: TextStyle(
          fontSize: 12.sp,
          color: Color(0xffa2a2a2),
        ),
        strutStyle: StrutStyle(
          forceStrutHeight: true,
          fontSize: 13.sp,
          height: 1,
        ),
      ),
      Padding(
        padding: EdgeInsets.only(right:2.w),
      ),
      Image.asset(
        'assets/images/dg.webp',
        height: 7.h,
      ),
    ];
  }

  // 直播列表详情
  Widget _listTableInfo(context,List<dynamic> liveData) {

    final liveList = List<Widget>();
    var fontStyle = TextStyle(
      color: Colors.white,
      fontSize: 26.sp,
    );
    var boxWidth = ScreenUtil().screenWidth /2 -40.w;
    var imageHeight = 200.h;
    var boxMargin = 10.w;

    liveData.asMap().keys.forEach((index) {
      var item = liveData[index];
      var showKingTag = index % 5 == 0;
      liveList.add(
        GestureDetector(
          onTap: () {
            _goToLiveRoom(context, item);
          },
          child: Padding(
            key: ObjectKey(item['id']),
            padding: EdgeInsets.only(
                left: 20.w,
                right: 20.w,
                bottom: boxMargin * 2
            ),
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
                          imageUrl: item['img']!=""?item['img']: 'https://img.bosszhipin.com/beijin/mcs/useravatar/20171211/4d147d8bb3e2a3478e20b50ad614f4d02062e3aec7ce2519b427d24a3f300d68_s.jpg',
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
                                    decoration: BoxDecoration(color: Color(0x20000000)),
                                    child: Row(
                                      children: <Widget>[

                                        Container(
                                          width: ScreenUtil().screenWidth/2 -70.w,
                                          //height: 200.h,
                                          child: Text(
                                              item['title'],
                                              maxLines: 3,
                                              overflow: TextOverflow.ellipsis,
                                              style: TextStyle(
                                                  fontSize: 25.sp, color: Colors.white)
                                          ),
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
                  width: ScreenUtil().screenWidth/2 -50.w,
                  color: Colors.transparent,
                  child: Column(
                    children: [
                      SizedBox(
                        height:30.h,

                        child: Row(
                            children: [
                              Container(

                                padding: EdgeInsets.only(left: 0.w, right: 5.w),
                                //width: 200.w,
                                child: Text(
                                  item['customer_name'],
                                  textAlign: TextAlign.start,
                                  overflow: TextOverflow.ellipsis,
                                  style: TextStyle(
                                    fontSize:23.sp,

                                  ),
                                ),
                              ),

                              Container(

                                padding: EdgeInsets.only(left: 0.w, right: 5.w),
                                //width: 200.w,
                                child: Text(
                                  item['gender'] ==1 ?"男":"女",
                                  textAlign: TextAlign.start,
                                  overflow: TextOverflow.ellipsis,
                                  style: TextStyle(
                                    fontSize:23.sp,

                                  ),
                                ),
                              )
                              ,


                              Container(

                                padding: EdgeInsets.only(left: 0.w, right: 5.w),
                                //width: 200.w,
                                child: Text(
                                  item['age'].toString(),
                                  textAlign: TextAlign.start,
                                  overflow: TextOverflow.ellipsis,
                                  style: TextStyle(
                                    fontSize:30.sp,

                                  ),
                                ),
                              )
                              ,


                              Container(

                                padding: EdgeInsets.only(left: 0.w, right: 0.w),
                                //width: 200.w,
                                child: Text(
                                  "来源:"+item['store'],
                                  textAlign: TextAlign.start,
                                  overflow: TextOverflow.ellipsis,
                                  style: TextStyle(
                                    fontSize:23.sp,

                                  ),
                                ),
                              )

                            ]
                        ),
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