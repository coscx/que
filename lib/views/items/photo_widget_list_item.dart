import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_geen/app/res/style/shape/techno_shape.dart';
import 'package:flutter_star/flutter_star.dart';
import 'package:flutter_geen/app/res/cons.dart';
import 'package:flutter_geen/app/res/style/shape/coupon_shape_border.dart';
import 'package:flutter_geen/blocs/collect/collect_bloc.dart';
import 'package:flutter_geen/blocs/collect/collect_state.dart';
import 'package:flutter_geen/blocs/detail/detail_bloc.dart';
import 'package:flutter_geen/blocs/detail/detail_event.dart';
import 'package:flutter_geen/blocs/home/home_bloc.dart';
import 'package:flutter_geen/blocs/home/home_event.dart';
import 'package:flutter_geen/components/permanent/circle_image.dart';
import 'package:flutter_geen/components/permanent/circle_text.dart';
import 'package:flutter_geen/components/permanent/feedback_widget.dart';
import 'package:flutter_geen/components/permanent/tag.dart';
import 'package:flutter_geen/model/widget_model.dart';
import 'package:flutter_geen/app/router.dart';
import 'package:flutter_geen/views/dialogs/delete_category_dialog.dart';
import 'package:flutter_geen/views/pages/home/PreviewImagesWidget.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
class PhotoWidgetListItem extends StatelessWidget {
  final bool hasTopHole;
  final bool hasBottomHole;
  final bool isClip;
  final Map<String,dynamic>  photo;
  PhotoWidgetListItem(
      {
      this.hasTopHole = true,
      this.hasBottomHole = false,
      this.isClip = true,
      this.photo,
      });

  final List<int> colors = Cons.tabColors;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 15, vertical: 8),
      child: Stack(
        children: <Widget>[
      Material(
      color: Theme.of(context).primaryColor.withAlpha(66),
        shape: true ? TechnoShapeBorder(color: Theme.of(context).primaryColor.withAlpha(100)) : null,
        child:
          isClip
              ? ClipPath(
                  clipper: ShapeBorderClipper(
                      shape: CouponShapeBorder(
                          hasTopHole: hasTopHole,
                          hasBottomHole: hasBottomHole,
                          hasLine: false,
                          edgeRadius: 25,
                          lineRate: 0.20)),
                  child: buildContent( context),
                )
              : Container(
            padding:  EdgeInsets.only(top: 10.h,bottom: 10.h,left: 10.w,right: 10.w),
              child:
              Column(
            children: [
              FeedbackWidget(
                onPressed: () {
                  BlocProvider.of<DetailBloc>(context).add(FetchWidgetDetail(photo));
                  Navigator.pushNamed(context, UnitRouter.widget_detail);
                },
                child:  buildContent( context),
              ),

              //buildMiddle(context),

        ],
      ))

          ),
          _buildCollectTag(Theme.of(context).primaryColor)
    ]
      )
    );
  }
Widget buildCard (BuildContext context,Map<String,dynamic> img){
    return     Stack(
        children: <Widget>[
          Container(
            child: Stack(
              children: <Widget>[

                Column(
                  children:<Widget> [
                 GestureDetector(

                onLongPress: () => _onLongPress(context,img['imagepath']),
                child: Container(
                      child: CachedNetworkImage(imageUrl: img['imagepath'],
                      width: 80,
                      height: 150,
                      ),
                      )

                )



                  ],

                ),

              ],

            ),
            padding: const EdgeInsets.all(2),
            decoration:const BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.all(Radius.circular(10)),
            ),
          ),

          Positioned(
              top: 5,
              right: 5,
              child:
              FeedbackWidget(
                onPressed: () {
                  _deletePhoto(context,img);
                },
                child: const Icon(
                  CupertinoIcons.delete_solid,
                  color: Colors.red,
                ),
              )
          ),
        ]
    );

}

  Widget buildAiFaceCard (BuildContext context,Map<String,dynamic> img){
    return   ClipPath(
      clipper: ShapeBorderClipper(
          shape: CouponShapeBorder(
              hasTopHole: false,
              hasBottomHole: false,
              hasLine: true,
              edgeRadius: 5,
              lineRate: 0.10)),
      child: Stack(
          children: <Widget>[
            Container(
              child: Stack(
                children: <Widget>[

                  Column(
                    children:<Widget> [
                      GestureDetector(

                          onLongPress: () => _onLongPress(context,img['imagepath']),
                          child: Container(
                            child: CachedNetworkImage(imageUrl: img['imagepath'],
                              width: 80,
                              height: 150,
                            ),
                          )

                      )



                    ],

                  ),

                ],

              ),
              padding: const EdgeInsets.all(2),
              decoration:const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.all(Radius.circular(10)),
              ),
            ),


          ]
      ),
    );

  }
  _onLongPress(BuildContext context,  String img) {
    Navigator.of(context).push(PageRouteBuilder(
        pageBuilder: (c, a, s) => PreviewImagesWidget([img],initialPage: 1,)));
  }
  Widget buildMiddle (BuildContext context,){
    List<dynamic> imgList =photo['imageurl'];
    List<Widget> list = [];
    imgList.map((images) => {

      list.add( buildCard(context,images))

    }


    ).toList();
    return          Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Expanded(child:
          Wrap(
          spacing: 5, //主轴上子控件的间距
            runSpacing: 0, //交叉轴上子控件之间的间距
            children: [
              ...list,
              buildFaceCard(context,photo['faceurl'])
            ],

          )
        ),

        buildWhereButton( context,photo['checked'])

        ]
    );
  }
  Widget buildFaceCard(BuildContext context,dynamic url){

    if (url is Map){
     return  buildAiFaceCard(context,url);
    }else{
      return Container();
    }



  }

  Widget buildWhereButton(BuildContext context,int checked){

    if (checked==1){
      return Column(
        children: [

          buildRefuseButton(context,"拒绝",Colors.red),
          build100Button(context,"通过1",Colors.green),
          build80Button(context,"通过2",Colors.blue),
          build60Button(context,"通过3",Colors.purple),
          buildHideButton(context,"隐藏",Colors.deepPurple),

        ],
      );
    }else{
      return Column(
        children: [

          buildResetButton(context,"撤回",Colors.red),


        ],
      );
    }



  }
  _deletePhoto(BuildContext context,Map<String,dynamic> img) {
    showDialog(
        context: context,
        builder: (ctx) => Dialog(
          elevation: 5,
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(10))),
          child: Container(
            width: 50,
            child: DeleteCategoryDialog(
              title: '删除图片',
              content: '是否确定继续执行?',
              onSubmit: () {
                BlocProvider.of<HomeBloc>(context).add(EventDelImg(img,1));
                Navigator.of(context).pop();
              },
            ),
          ),
        ));
  }
  _refuseUser(BuildContext context) {
    showDialog(
        context: context,
        builder: (ctx) => Dialog(
          elevation: 5,
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(10))),
          child: Container(
            width: 50,
            child: DeleteCategoryDialog(
              title: '拒绝此用户',
              content: '是否确定继续执行?',
              onSubmit: () {
                BlocProvider.of<HomeBloc>(context).add(EventCheckUser(photo,1));
                Navigator.of(context).pop();
              },
            ),
          ),
        ));
  }
  _resetUser(BuildContext context) {
    showDialog(
        context: context,
        builder: (ctx) => Dialog(
          elevation: 5,
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(10))),
          child: Container(
            width: 50,
            child: DeleteCategoryDialog(
              title: '撤回此用户的审核结果',
              content: '是否确定继续执行?',
              onSubmit: () {
                BlocProvider.of<HomeBloc>(context).add(EventResetCheckUser(photo,1));
                Navigator.of(context).pop();
              },
            ),
          ),
        ));
  }
  _hideUser(BuildContext context) {
    showDialog(
        context: context,
        builder: (ctx) => Dialog(
          elevation: 5,
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(10))),
          child: Container(
            width: 50,
            child: DeleteCategoryDialog(
              title: '隐藏该用户',
              content: '是否确定继续执行?',
              onSubmit: () {
                BlocProvider.of<HomeBloc>(context).add(EventCheckUser(photo,5));
                Navigator.of(context).pop();
              },
            ),
          ),
        ));
  }
  Widget buildButton(BuildContext context,String txt,MaterialColor color){
    return    Column(
      children: [

        RaisedButton(
          elevation: 0,
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(20))),
          color: color,
          onPressed: (){

          },
          child: Text(txt,
              style: TextStyle(color: Colors.white, fontSize: 18)),
        ),
      ],
      );
}
  Widget build100Button(BuildContext context,String txt,MaterialColor color){
    return    Column(
      children: [

        RaisedButton(
          elevation: 0,
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(20))),
          color: color,
          onPressed: (){
            BlocProvider.of<HomeBloc>(context).add(EventCheckUser(photo,2));
          },
          child: Text(txt,
              style: TextStyle(color: Colors.white, fontSize: 18)),
        ),
      ],
    );
  }
  Widget build80Button(BuildContext context,String txt,MaterialColor color){
    return    Column(
      children: [

        RaisedButton(
          elevation: 0,
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(20))),
          color: color,
          onPressed: (){
            BlocProvider.of<HomeBloc>(context).add(EventCheckUser(photo,3));
          },
          child: Text(txt,
              style: TextStyle(color: Colors.white, fontSize: 18)),
        ),
      ],
    );
  }
  Widget build60Button(BuildContext context,String txt,MaterialColor color){
    return    Column(
      children: [

        RaisedButton(
          elevation: 0,
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(20))),
          color: color,
          onPressed: (){
            BlocProvider.of<HomeBloc>(context).add(EventCheckUser(photo,4));
          },
          child: Text(txt,
              style: TextStyle(color: Colors.white, fontSize: 18)),
        ),
      ],
    );
  }
  Widget buildRefuseButton(BuildContext context,String txt,MaterialColor color){
    return    Column(
      children: [

        RaisedButton(
          elevation: 0,
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(20))),
          color: color,
          onPressed: (){
            _refuseUser(context);
          },
          child: Text(txt,
              style: TextStyle(color: Colors.white, fontSize: 18)),
        ),
      ],
    );
  }
  Widget buildResetButton(BuildContext context,String txt,MaterialColor color){
    return    Column(
      children: [

        RaisedButton(
          elevation: 0,
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(20))),
          color: color,
          onPressed: (){
            _resetUser(context);
          },
          child: Text(txt,
              style: TextStyle(color: Colors.white, fontSize: 18)),
        ),
      ],
    );
  }
  Widget buildHideButton(BuildContext context,String txt,MaterialColor color){
    return    Column(
      children: [

        RaisedButton(
          elevation: 0,
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(20))),
          color: color,
          onPressed: (){
            _hideUser(context);
          },
          child: Text(txt,
              style: TextStyle(color: Colors.white, fontSize: 18)),
        ),
      ],
    );
  }
  Widget buildContent(BuildContext context) => Container(
        color: Colors.lightBlue.withAlpha(0),
        height: 95,
        padding: const EdgeInsets.only(top: 4, left: 0, right: 10, bottom: 10),
        child: Row(
          children: <Widget>[
            buildLeading(),
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  _buildTitle(),

                  _buildSummary(),

                ],
              ),
            ),
          ],
        ),
      );

  Widget buildLeading() => Padding(
        padding:  EdgeInsets.only(top: 10.h),
        child: Container(
          //tag: "hero_widget_image_${photo['uuid'].toString()}",
          child: (photo['head_img'] == "" || photo['head_img'] ==null)
              ? Container(
                  // width: 110.w,
                  // height: 210.h,
                  color: Colors.transparent,
                  child: CircleText(
                    text: photo['name'],
                    size: 140.sp,
                    color: invColor,
                    shadowColor: Colors.transparent,
                  ),
                )
              : Container(
            child: CircleAvatar(
              foregroundColor: Colors.white10,
              radius:(60.w) ,
              child: ClipOval(
                child: photo['head_img'] ==null ?Container():CachedNetworkImage(imageUrl: photo['head_img'],
                  fit: BoxFit.cover,
                  width: 120.w,
                  height: 120.h,

                ),
              ),
            ),
          )
          ,
        ),
      );

  Color get invColor {
    return Colors.blue;
  }

  Widget _buildCollectTag(Color color) {
    return Positioned(
        top: 0,
        right: 40,
        child: BlocBuilder<CollectBloc, CollectState>(builder: (_, s) {
          bool show = true;
          return Opacity(
            opacity: show ? 1.0 : 0.0,
            child: SizedOverflowBox(
              alignment: Alignment.bottomCenter,
              size: const Size(0, 20 - 6.0),
              child: Tag(
                color: color,
                shadowHeight: 6.0,
                size: const Size(15, 20),
              ),
            ),
          );
        }));
  }

  Widget _buildTitle() {
    return Expanded(
      child: Row(
        children: <Widget>[
          const SizedBox(width: 1),
          Expanded(
            child: Text(photo['name']+" "+photo['mobile']+" "+(photo['gender']==1?"男":"女")+" "+photo['age'].toString()+"岁 "+(photo['status']==0?"C":(photo['status']==1?"B":"A")),
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    shadows: [
                      Shadow(color: Colors.white, offset: Offset(.3, .3))
                    ])),
          ),

          // StarScore(
          //   star: Star(emptyColor: Colors.white, size: 15, fillColor: invColor),
          //   score: data.lever,
          // ),
        ],
      ),
    );
  }

  Widget _buildSummary() {
    return Padding(
      padding: const EdgeInsets.only(left: 1, bottom: 1, top: 1),
      child: Container(
        child: Text(
          //尾部摘要
          "房: "+photo['has_house'].toString()+"套 车: "+photo['has_car'].toString()+"辆 " +(photo['marriage']==2?"已婚":"未婚") +" 生日:" +(photo['birthday']==null ? "-":photo['birthday'].toString()),
          maxLines: 3,
          overflow: TextOverflow.ellipsis,
          style: TextStyle(color: Colors.black, fontSize: 14, shadows: [
            const Shadow(color: Colors.white, offset: const Offset(.5, .5))
          ]),
        ),
      ),
    );
  }
}
