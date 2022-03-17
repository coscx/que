import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_geen/app/router.dart';
import 'package:flutter_geen/blocs/detail/detail_bloc.dart';
import 'package:flutter_geen/blocs/detail/detail_event.dart';
import 'package:flutter_geen/components/permanent/circle_text.dart';
import 'package:flutter_geen/components/permanent/feedback_widget.dart';
import 'package:flutter_geen/views/pages/utils/common.dart';
import 'package:flutter_geen/views/pages/widget_detail/detail_item.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class PopularCardAppoint extends StatelessWidget {
  final Map<String, dynamic> photo;

  const PopularCardAppoint({
    Key key,
    this.photo,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Container(
        //height: 60,
        //color: Colors.blue,
        alignment: Alignment.center,

        child: Container(
            // color: Colors.blue,
            margin: EdgeInsets.symmetric(horizontal: 14.w, vertical: 8.h),
            child: Stack(children: <Widget>[
              Container(
                  //color: Theme.of(context).primaryColor.withAlpha(33),
                  //shape: true ? TechnoShapeBorder(color: Theme.of(context).primaryColor.withAlpha(100)) : null,
                  decoration: new BoxDecoration(
//背景
                    color: Color.fromRGBO(255, 255, 255, 100),
                    //设置四周圆角 角度
                    borderRadius: BorderRadius.all(Radius.circular(20.h)),
                    //设置四周边框
                    //border: new Border.all(width: 1, color: Colors.red),
                  ),
                  child: Container(
                      padding: EdgeInsets.only(
                          top: 10.h, bottom: 10.h, left: 10.w, right: 10.w),
                      decoration: new BoxDecoration(
//背景
                        color: Color.fromRGBO(255, 255, 255, 100),
                        //设置四周圆角 角度
                        borderRadius: BorderRadius.all(Radius.circular(20.h)),
                        //设置四周边框
                        //border: new Border.all(width: 1, color: Colors.red),
                      ),
                      child: Column(
                        children: [
                          Container(
                            child: buildContent(context),
                          ),

                          //buildMiddle(context),
                        ],
                      ))),
              // _buildCollectTag(Theme.of(context).primaryColor, showBadge)
            ])),
      ),
    );
  }
  Widget buildContent(BuildContext context) => Container(


    decoration: new BoxDecoration(
//背景
      color: Color.fromRGBO(255, 255, 255, 0),
      //设置四周圆角 角度
      borderRadius: BorderRadius.all(Radius.circular(0.h)),


      //设置四周边框
      //border: new Border.all(width: 1, color: Colors.red),
    ),

    height: 170.h,
    padding:  EdgeInsets.only(top: 20.h, left: 0, right: 10.w, bottom: 0.h),
    child: Column(
      children: [
        Row(
          children: <Widget>[
            buildLeading(),

            Expanded(
              child: Container(
                padding:  EdgeInsets.only(top: 0.h, left: 15.h, right: 0.w, bottom: 0.h),
                child: Column(
                  //mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    // _buildTitle(),
                    _titleTop(),
                    _buildMiddles(),
                    _buildSummary(),

                  ],
                ),
              ),
            ),

          ],
        ),
      ],
    ),
  );
  Widget buildLeading() => Padding(
    padding:  EdgeInsets.only(top: 0.h),
    child: Container(
      //tag: "hero_widget_image_${photo['uuid'].toString()}",
      child: (photo['head_img'] == "" || photo['head_img'] ==null)
          ? Container(
        // width: 100.w,
        // height: 100.h,h
        color: Colors.transparent,
        child: CircleText(
          text: photo['name'],
          size: 140.w,
          fontSize: 50.sp,
          color: Colors.blue,
          //shadowColor: Colors.transparent,
        ),
      )
          : Container(
        child: Container(
          padding:  EdgeInsets.only(left: 0.w, bottom: 0.h, top: 0.h,right: 0.w),
          child: CircleAvatar(
            foregroundColor: Colors.white10,
            radius:(70.sp) ,
            child: ClipOval(
              child: photo['head_img'] ==null ?Container():CachedNetworkImage(imageUrl: photo['head_img'],
                fit: BoxFit.cover,
                width: 140.w,
                height: 140.h,

              ),
            ),
          ),
        ),
      )
      ,
    ),
  );
  Widget _titleTop() {
    String level = getLevel(photo['status']);
    return Padding(
      padding:  EdgeInsets.only(left: 1.w, bottom: 0.h, top: 0.h),
      child: Container(
        child: Text(photo['name']+" "+(photo['gender']==1?"男":"女")+" "+photo['age'].toString()+"岁 "+""
            +((photo['height']==0||photo['height']==null)?"": photo['height'].toString()+"cm")+" "+level,
            overflow: TextOverflow.ellipsis,
            style:  TextStyle(
                fontSize: 30.sp,
                fontWeight: FontWeight.bold,
                shadows: [
                  Shadow(color: Colors.white, offset: Offset(.3, .3))
                ])),
      ),
    );
  }
  Widget _buildSummary() {
    return Padding(
      padding:  EdgeInsets.only(left: 1.w, bottom: 0.h, top: 5.h),
      child: Container(
        child: Text(
          //尾部摘要
          (photo['has_house']==null?"":hasHouseLevel[photo['has_house']])+" "+(photo['has_car']==null?"":hasCarLevel[photo['has_car']])+" " +(marriageLevel[photo['marriage']]) +" 生日:" +

              (photo['birthday']==null ? "-":(photo['birthday'].length > 10? photo['birthday'].toString().substring(0,10):"")) +" 收入:"+photo['income'].toString()+"w",
          maxLines: 3,
          overflow: TextOverflow.ellipsis,
          style: TextStyle(color: Colors.black, fontSize: 23.sp, shadows: [
            const Shadow(color: Colors.white, offset: const Offset(.5, .5))
          ]),
        ),
      ),
    );
  }
  Widget _buildMiddles() {
    return Padding(
      padding:  EdgeInsets.only(left: 1.w, bottom: 0.h, top: 5.h),
      child: Container(
        child: Text(
          //尾部摘要
          (photo['sale_name']==null?"": "红娘: "+photo['sale_name'].toString())+" 沟通"+photo['connect_count'].toString()+"次 " +(photo['appointment_count']==0?"未排约":(photo['appointment']==null?"":photo['appointment'].toString()))+" id:"+photo['id'].toString(),
          maxLines: 3,
          overflow: TextOverflow.ellipsis,
          style: TextStyle(color: Colors.black, fontSize: 23.sp, shadows: [
            const Shadow(color: Colors.white, offset: const Offset(.5, .5))
          ]),
        ),
      ),
    );
  }
}

// Widget Content List
class ContentCard extends StatelessWidget {
  const ContentCard({
    Key key,
    @required this.title,
    @required this.location,
    @required this.description,
    @required this.age,
  }) : super(key: key);

  final String title, location, description, age;

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Container(
      width: size.width / 1.2,
      height: 150.h,
      margin: EdgeInsets.only(left: 120.w, top: 10.h),
      padding: EdgeInsets.all(5.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        // mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Row(
            children: <Widget>[
              Text(
                this.title,
                style: TextStyle(
                  fontWeight: FontWeight.w600,
                  fontSize: 30.sp,
                ),
              ),
              SizedBox(width: 5.w),
              Text(
                this.location,
                style: TextStyle(
                  fontSize: 30.sp,
                ),
              ),
              SizedBox(width: 5.w),
              Text(
                this.age + "岁",
                style: TextStyle(
                  fontSize: 30.sp,
                ),
              ),
            ],
          ),
          SizedBox(height: 15.h),
          Row(
            children: [
              Icon(
                Icons.location_on,
                size: 28.sp,
                color: Colors.green,
              ),
              Text(
                this.description,
                style: TextStyle(
                  fontWeight: FontWeight.w400,
                  fontSize: 30.sp,
                ),
                overflow: TextOverflow.ellipsis,
                maxLines: 3,
              ),
            ],
          ),
        ],
      ),
    );
  }
}

// Widget Image List
class ImageCard extends StatelessWidget {
  final String imageSource;

  const ImageCard({
    Key key,
    @required this.imageSource,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 120.w,
      height: 160.h,
      clipBehavior: Clip.antiAlias,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(15.w),
          bottomLeft: Radius.circular(15.w),
        ),
      ),
      child: this.imageSource != ""
          ? CachedNetworkImage(
              imageUrl: this.imageSource,
              fit: BoxFit.cover,
            )
          : Image.asset("assets/packages/images/ic_user_none_round.png"),
    );
  }
}
