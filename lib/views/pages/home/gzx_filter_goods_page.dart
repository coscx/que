import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_geen/blocs/global/global_bloc.dart';
import 'package:flutter_geen/blocs/home/home_bloc.dart';
import 'package:flutter_geen/blocs/home/home_event.dart';
import 'package:flutter_geen/views/pages/home/multi_select.dart';
import 'package:flutter_geen/views/pages/utils/gzx_style.dart';
import 'package:flutter_screenutil/screenutil.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_geen/views/pages/utils/common.dart';
import 'package:flutter_geen/views/dialogs/common_dialog.dart';
import 'package:flutter_range_slider/flutter_range_slider.dart' as frs;
typedef _CallBack = void Function(List<String> selectStr);

class ExpansionPanelItem {
  final String headerText;
  final Widget body;
  bool isExpanded;

  ExpansionPanelItem({this.headerText, this.body, this.isExpanded});
}

class SelectItem {
  String name;
  String id;
  bool isSelect;
  int type;

  SelectItem({this.name, this.id, this.isSelect, this.type});
}

class GZXFilterGoodsPage extends StatefulWidget {
  final List<SelectItem> selectItems;

  GZXFilterGoodsPage({
    @required this.selectItems,
  });

  @override
  _GZXFilterGoodsPageState createState() => _GZXFilterGoodsPageState();
}

class _GZXFilterGoodsPageState extends State<GZXFilterGoodsPage> {
  List<ExpansionPanelItem> _expansionPanelItems;
  int minValue ;
  int maxValue;
  List<SelectItem> _value = [];
  List<SelectItem> _valueFrom = [];
  List<SelectItem> _valueEducation = [];
  List<SelectItem> _valueIncome = [];
  List<SelectItem> _valueHouse = [];
  List<SelectItem> _valueMarriage = [];

  List _value3 = ['65-5130', '5130-1.1万', '1.1万-1.5万'];
  List _value4 = ['10%的选择', '52%的选择', '23%的选择'];
  List<SelectItem> _value5 = [];
  List<SelectItem> _value6 = [];
  List<SelectItem> _value7 = [];

  List<SelectItem> _value8 = [];

  List<SelectItem> _value9 = [];
  List<SelectItem> _value10 = [];

  bool _isHideValue1 = true;
  bool _isHideOtherLocation = true;

  bool _isHideValue8 = true;
  bool _isHideValue9 = true;
  bool _isHideValue10 = true;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    minValue =18;
    maxValue=80;
    for (int i = 1; i < fromLevel.length; i++) {
      SelectItem ff = SelectItem();
      ff.id = i.toString();
      ff.type = 0;
      ff.name = fromLevel[i];
      ff.isSelect = false;
      _valueFrom.add(ff);
    }
    for (int i = 1; i < EduLevel.length; i++) {
      SelectItem ff = SelectItem();
      ff.id = i.toString();
      ff.type = 1;
      ff.name = EduLevel[i];
      ff.isSelect = false;
      _valueEducation.add(ff);
    }
    for (int i = 1; i < IncomeLevel.length; i++) {
      SelectItem ff = SelectItem();
      ff.id = i.toString();
      ff.type = 2;
      ff.name = IncomeLevel[i];
      ff.isSelect = false;
      _valueIncome.add(ff);
    }

    for (int i = 1; i < hasHouseLevel.length; i++) {
      SelectItem ff = SelectItem();
      ff.id = i.toString();
      ff.type = 3;
      ff.name = hasHouseLevel[i];
      ff.isSelect = false;
      _valueHouse.add(ff);
    }
    for (int i = 1; i < marriageLevel.length; i++) {
      SelectItem ff = SelectItem();
      ff.id = i.toString();
      ff.type = 4;
      ff.name = marriageLevel[i];
      ff.isSelect = false;
      _valueMarriage.add(ff);
    }

    _expansionPanelItems = <ExpansionPanelItem>[
      ExpansionPanelItem(
          headerText: 'Panel A',
          // body: Container(
          //
          //   width: double.infinity,
          //   child: Image.network('http://pic1.win4000.com/wallpaper/2019-02-15/5c664c46823f8.jpg'),
          // ),
          body: Container(
            padding: EdgeInsets.all(16.0),
            height: 200,
            width: 200,
            child: GridView.count(
              crossAxisCount: 3,
              reverse: false,
              scrollDirection: Axis.vertical,
              controller: ScrollController(
                initialScrollOffset: 0.0,
              ),
              crossAxisSpacing: 10.0,
              mainAxisSpacing: 20.0,
              childAspectRatio: 2,
              physics: BouncingScrollPhysics(),
              primary: false,
              children: _value.map((i) {
                return Container(
                  decoration: BoxDecoration(
                    border: Border.all(
                      color: Colors.lightBlue,
                    ),
                  ),
                  child: Center(
                    child: Text(
                      i.id,
                    ),
                  ),
                );
              }).toList(),
            ),
          ),
          isExpanded: false),
      ExpansionPanelItem(
          headerText: 'Panel B',
          body: Container(
            padding: EdgeInsets.all(16.0),
            width: double.infinity,
            child: Image.network(
                'http://pic1.win4000.com/wallpaper/2019-02-14/5c651084373de.jpg'),
          ),
          isExpanded: false),
      ExpansionPanelItem(
          headerText: 'Panel C',
          body: Container(
            padding: EdgeInsets.all(16.0),
            width: double.infinity,
            child: Image.network(
                'http://pic1.win4000.com/wallpaper/2019-02-14/5c65107a0ee05.jpg'),
          ),
          isExpanded: false)
    ];
  }

  Widget _typeGridWidget(List<SelectItem> items, int type,
      {double childAspectRatio = 2.0}) {
    return MultiChipFilters(
      data: items,
      avatarBuilder: (_, index) => null,
      labelBuilder: (_, selected, name) {
        return name == null ? Container() : Text(name);
      },
      onChange: _doSelectStart,
      selectedS: widget.selectItems,
    );
  }

  _doSelectStart(List<SelectItem> s) {
    print("-----------");
    for (int i = 0; i < s.length; i++) {
      print(s[i].id + "/" + s[i].type.toString());
    }
    print("-----------");
  }

  Widget _buildGroup(List<SelectItem> sel) {

    for(int i=0;i< _value.length;i++){

      for(int j=0;j< sel.length;j++){
         if (sel[j].type == _value[i].type && sel[j].id == _value[i].id){
           _value[i].isSelect = true;
         }
      }

    }

    return Column(
      children: <Widget>[
        Row(
          children: <Widget>[
            SizedBox(
              width: 6,
            ),
            Expanded(
              child: Text('来源渠道',
                  style: TextStyle(fontSize: 12, color: Color(0xFF6a6a6a))),
            ),
            GestureDetector(
              onTap: () {
                setState(() {
                  _isHideValue1 = !_isHideValue1;
                });
              },
              child: Icon(
                _isHideValue1
                    ? Icons.keyboard_arrow_down
                    : Icons.keyboard_arrow_up,
                color: Colors.grey,
              ),
            ),
            SizedBox(
              width: 6,
            ),
          ],
        ),
        _typeGridWidget(_value, 0),
        // Offstage(
        //   offstage: _isHideValue1,
        //   child: _typeGridWidget(_value1,0),
        // ),
        Container(
            margin: EdgeInsets.only(top: 6),
            decoration: BoxDecoration(
//      color: Colors.red,
                border: Border(
                    bottom: BorderSide(
                        width: 1, color: GZXColors.mainBackgroundColor)))),
      ],
    );
  }
  Widget buildRangerSlider(String title){
    return Column(
      children: [
        Container(

          padding:   EdgeInsets.only(left: 10.w, top: 0.h, right: 0.w, bottom: 0.h),
          alignment: Alignment.centerLeft,
          child: Text(title,
              style: TextStyle(fontSize: 12, color: Color(0xFF6a6a6a))),
        ),
        Row(
          children: [
            Container(
              padding:   EdgeInsets.only(left: 20.w, top: 0.h, right: 0.w, bottom: 0.h),
              child: Text(minValue.toString()+"岁",
                  style: TextStyle(fontSize: 26.sp, color: Color(0xFF6a6a6a))),
            ),

            Container(
              padding:   EdgeInsets.only(left: 0.w, top: 0.h, right: 0.w, bottom: 0.h),
              width: ScreenUtil().screenWidth*0.55,
              child: frs.RangeSlider(
                min: 18.0,
                max: 80.0,
                lowerValue: minValue.toDouble(),
                upperValue: maxValue.toDouble(),
                divisions: 62,
                showValueIndicator: true,
                valueIndicatorMaxDecimals: 0,
                onChanged: (double newLowerValue, double newUpperValue) {
                  minValue = newLowerValue.round();
                  maxValue = newUpperValue.round();
                  int j=0,k =0;
                  for (int i = 0; i < widget.selectItems.length; i++) {
                    if (widget.selectItems[i].type == 300) {
                      j = 1;
                      widget.selectItems[i].id=  minValue.toString();
                      break;
                    }
                  }
                  for (int i = 0; i < widget.selectItems.length; i++) {

                    if (widget.selectItems[i].type == 301) {
                      widget.selectItems[i].id=  maxValue.toString();
                      k = 1;
                      break;
                    }

                  }
                  if (j == 0) {

                    SelectItem s = SelectItem();
                    s.type = 300;
                    s.id = minValue.toString();
                    widget.selectItems.add(s);
                  }
                  if (k == 0) {

                    SelectItem s = SelectItem();
                    s.type = 301;
                    s.id = maxValue.toString();
                    widget.selectItems.add(s);
                  }
                  setState(() {
                  });

                },
                onChangeStart:
                    (double startLowerValue, double startUpperValue) {
                  print(
                      'Started with values: $startLowerValue and $startUpperValue');
                },
                onChangeEnd: (double newLowerValue, double newUpperValue) {
                  print(
                      'Ended with values: $newLowerValue and $newUpperValue');
                },
              ),

            ),
            Container(
              padding:   EdgeInsets.only(left: 0.w, top: 0.h, right: 0.w, bottom: 0.h),
              child: Text(maxValue.toString()+"岁",
                  style: TextStyle(fontSize: 26.sp, color: Color(0xFF6a6a6a))),
            ),
          ],
        ),
      ],
    );


  }
  Widget _buildGroup1(String title, bool isShowExpansionIcon,
      List<SelectItem> items, List<SelectItem> sel) {
    for(int i=0;i< items.length;i++){

      for(int j=0;j< sel.length;j++){
        if (sel[j].type == items[i].type && sel[j].id == items[i].id){
          items[i].isSelect = true;
        }
      }

    }
    return Column(children: [
      SizedBox(
        height: 6,
      ),
      Row(
        children: <Widget>[
          SizedBox(
            width: 6,
          ),
          Expanded(
            child: Text(title,
                style: TextStyle(fontSize: 12, color: Color(0xFF6a6a6a))),
          ),
          !isShowExpansionIcon
              ? SizedBox()
              : GestureDetector(
                  onTap: () {
                    setState(() {
                      _isHideValue1 = !_isHideValue1;
                    });
                  },
                  child: Icon(
                    _isHideValue1
                        ? Icons.keyboard_arrow_down
                        : Icons.keyboard_arrow_up,
                    color: Colors.grey,
                  ),
                ),
          SizedBox(
            width: 6,
          ),
        ],
      ),
      _typeGridWidget(items, 1),
//      Offstage(
//        offstage: _isHideValue1,
//        child: _typeGridWid2(_value1),
//      ),
      Container(
          margin: EdgeInsets.only(top: 6),
          decoration: BoxDecoration(
//      color: Colors.red,
              border: Border(
                  bottom: BorderSide(
                      width: 1, color: GZXColors.mainBackgroundColor))))
    ]);
  }

  Widget _buildGroup2() {
    return Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            height: 6,
          ),
          Padding(
            padding: EdgeInsets.only(left: 6),
            child: Text('价格区间(元)',
                style: TextStyle(fontSize: 12, color: Color(0xFF6a6a6a))),
          ),
          SizedBox(
            height: 6,
          ),
          Row(
            children: <Widget>[
              Expanded(
                child: Container(
                  margin: EdgeInsets.only(left: 6, right: 6),
                  height: 25,
                  decoration: BoxDecoration(
                    color: GZXColors.mainBackgroundColor,
                    borderRadius: BorderRadius.circular(15),
                  ),
                  child: Text('最低价',
                      style: TextStyle(fontSize: 11, color: Colors.grey)),
                  alignment: Alignment.center,
                ),
              ),
              Container(
                width: 20,
                height: 1,
                color: Colors.grey[500],
              ),
              Expanded(
                child: Container(
                  margin: EdgeInsets.only(left: 6, right: 6),
                  height: 25,
                  decoration: BoxDecoration(
                    color: GZXColors.mainBackgroundColor,
                    borderRadius: BorderRadius.circular(15),
                  ),
                  child: Text('最低价',
                      style: TextStyle(fontSize: 11, color: Colors.grey)),
                  alignment: Alignment.center,
                ),
              )
            ],
          ),
          GridView.count(
            primary: false,
            shrinkWrap: true,
            crossAxisCount: 3,
            mainAxisSpacing: 6.0,
            crossAxisSpacing: 6.0,
            childAspectRatio: 2,
            padding: EdgeInsets.only(left: 6, right: 6, top: 6),
//    padding: EdgeInsets.all(6),
            children: List.generate(
              3,
              (index) {
                return Container(
                    alignment: Alignment.center,
//                height: 164.0,
                    decoration: BoxDecoration(
                        color: GZXColors.mainBackgroundColor,
                        borderRadius: BorderRadius.circular(3.0)),
                    child: Center(
                        child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Text(_value3[index],
                            style: TextStyle(
                                color: Color(0xFF333333), fontSize: 12.0)),
                        Text(_value4[index],
                            style: TextStyle(
                                color: Color(0xFF333333), fontSize: 11.0))
                      ],
                    )));
              },
            ),
          ),
//      Offstage(
//        offstage: _isHideValue1,
//        child: _typeGridWid2(_value1),
//      ),
//    Offstage(offstage: _isHideOtherLocation,child: Container(
//      child: Column(
//        children: <Widget>[
//          Expanded(
//            child: Text('发货地', style: TextStyle(fontSize: 11, color: Color(0xFF6a6a6a))),
//          ),
//          _typeGridWid2(_value5),
//        ],
//      ),
//    ),),
          Container(
              margin: EdgeInsets.only(top: 6),
              decoration: BoxDecoration(
//      color: Colors.red,
                  border: Border(
                      bottom: BorderSide(
                          width: 1, color: GZXColors.mainBackgroundColor))))
        ]);
  }

//   Widget _buildGroup3() {
//     return Column(
//       children: <Widget>[
//         Row(
//           children: <Widget>[
//             SizedBox(
//               width: 6,
//             ),
//             Expanded(
//               child: Text('发货地', style: TextStyle(fontSize: 12, color: Color(0xFF6a6a6a))),
//             ),
//             GestureDetector(
//               onTap: () {
//                 setState(() {
//                   _isHideOtherLocation = !_isHideOtherLocation;
//                 });
//               },
//               child: Icon(
//                 _isHideOtherLocation ? Icons.keyboard_arrow_down : Icons.keyboard_arrow_up,
//                 color: Colors.grey,
//               ),
//             ),
//             SizedBox(
//               width: 6,
//             ),
//           ],
//         ),
// //        _typeGridWid2(_value),
//         Row(
//           children: <Widget>[
//             SizedBox(
//               width: 6,
//             ),
//             Container(
// //                height: 64.0,
//                 padding: EdgeInsets.only(left: 8, top: 6, right: 8, bottom: 6),
//                 decoration:
//                     BoxDecoration(color: GZXColors.mainBackgroundColor, borderRadius: BorderRadius.circular(3.0)),
//                 child: Row(
//                   children: <Widget>[
//                     Icon(
//                       Icons.location_on,
//                       size: 14,
//                       color: Colors.grey,
//                     ),
//                     SizedBox(
//                       width: 2,
//                     ),
//                     Text('深圳', style: TextStyle(color: Color(0xFF333333), fontSize: 12.0)),
//                   ],
//                 )),
//             SizedBox(
//               width: 6,
//             ),
//             Row(
//               children: <Widget>[
//                 Icon(
//                   Icons.refresh,
//                   size: 14,
//                   color: Colors.grey,
//                 ),
//                 SizedBox(
//                   width: 2,
//                 ),
//                 Text('定位', style: TextStyle(color: Colors.grey, fontSize: 12.0)),
//               ],
//             )
//           ],
//         ),
//         Offstage(
//           offstage: _isHideOtherLocation,
//           child: Container(
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: <Widget>[
//                 Padding(
//                   padding: EdgeInsets.only(left: 6, top: 6),
//                   child: Text('区域', style: TextStyle(fontSize: 11, color: Color(0xFF6a6a6a))),
//                 ),
//                 _typeGridWidget(_value5, 3,childAspectRatio: 3),
//                 Padding(
//                   padding: EdgeInsets.only(left: 6, top: 6),
//                   child: Text('城市', style: TextStyle(fontSize: 11, color: Color(0xFF6a6a6a))),
//                 ),
//                 _typeGridWidget(_value6, 3,childAspectRatio: 3),
//                 Padding(
//                   padding: EdgeInsets.only(left: 6, top: 6),
//                   child: Text('省份', style: TextStyle(fontSize: 11, color: Color(0xFF6a6a6a))),
//                 ),
//                 _typeGridWidget(_value7, 3,childAspectRatio: 3),
//               ],
//             ),
//           ),
//         ),
//         Container(
//             margin: EdgeInsets.only(top: 6),
//             decoration: BoxDecoration(
// //      color: Colors.red,
//                 border: Border(bottom: BorderSide(width: 1, color: GZXColors.mainBackgroundColor)))),
//       ],
//     );
//   }
//
//   Widget _buildGroup4() {
//     return Column(children: <Widget>[
//       SizedBox(
//         height: 6,
//       ),
//       Row(
//         children: <Widget>[
//           SizedBox(
//             width: 6,
//           ),
//           Expanded(
//             child: Text('我喜欢', style: TextStyle(fontSize: 11, color: Color(0xFF6a6a6a))),
//           ),
//         ],
//       ),
//       SizedBox(
//         height: 6,
//       ),
//       Row(
//         children: <Widget>[
//           SizedBox(
//             width: 6,
//           ),
//           Container(
// //                height: 64.0,
//               padding: EdgeInsets.all(16),
//               decoration: BoxDecoration(color: GZXColors.mainBackgroundColor, borderRadius: BorderRadius.circular(3.0)),
//               child: Row(
//                 children: <Widget>[
//                   Text('购买过的店', style: TextStyle(color: Color(0xFF333333), fontSize: 12.0)),
//                 ],
//               )),
//           SizedBox(
//             width: 6,
//           ),
//         ],
//       ),
//       Container(
//           margin: EdgeInsets.only(top: 6),
//           decoration: BoxDecoration(
// //      color: Colors.red,
//               border: Border(bottom: BorderSide(width: 1, color: GZXColors.mainBackgroundColor)))),
//     ]);
//   }
//
//   Widget _buildGroup5(String title, List<SelectItem> items, bool isHideValue, VoidCallback onTapExpansion) {
//     return Column(
//       children: <Widget>[
//         SizedBox(
//           height: 6,
//         ),
//         Row(
//           children: <Widget>[
//             SizedBox(
//               width: 6,
//             ),
//             Expanded(
//               child: Text(title, style: TextStyle(fontSize: 12, color: Color(0xFF6a6a6a))),
//             ),
//             GestureDetector(
// //              onTap: () {
// //                setState(() {
// //                  isHideValue = !isHideValue;
// //                });
// //              },
//               onTap: onTapExpansion,
//               child: Icon(
//                 isHideValue ? Icons.keyboard_arrow_down : Icons.keyboard_arrow_up,
//                 color: Colors.grey,
//               ),
//             ),
//             SizedBox(
//               width: 6,
//             ),
//           ],
//         ),
//         Offstage(
//           offstage: isHideValue,
//           child: _typeGridWidget(items,5),
//         ),
//         Container(
//             margin: EdgeInsets.only(top: 6),
//             decoration: BoxDecoration(
// //      color: Colors.red,
//                 border: Border(bottom: BorderSide(width: 1, color: GZXColors.mainBackgroundColor)))),
//       ],
//     );
//   }

  doi(i) {
    i++;
  }

  @override
  Widget build(BuildContext context) {
    var i = 0;
    doi(i);
    print('doi${i}');
    return Container(
      margin: EdgeInsets.only(left: ScreenUtil().screenWidth / 4, top: 0),
      color: Colors.white,
      height: ScreenUtil().screenHeight,
//      padding: EdgeInsets.only(top: ScreenUtil.statusBarHeight),
      child: Column(
        children: <Widget>[
          Expanded(
            child:
                ListView(primary: false, shrinkWrap: true, children: <Widget>[
              _buildGroup1('来源渠道', false, _valueFrom, widget.selectItems),
              _buildGroup1('客户学历', false, _valueEducation, widget.selectItems),
              _buildGroup1('客户收入', false, _valueIncome, widget.selectItems),
              _buildGroup1('客户房产', false, _valueHouse, widget.selectItems),
              _buildGroup1('客户婚姻状况', false, _valueMarriage, widget.selectItems),
              buildRangerSlider("年龄选择")
                  // _buildGroup2(),
              // _buildGroup3(),
              // _buildGroup4(),
              // _buildGroup5('尺寸', _value8, _isHideValue8, () {
              //   setState(() {
              //     _isHideValue8 = !_isHideValue8;
              //   });
              // }),
              // _buildGroup5('硬盘容量', _value9, _isHideValue9, () {
              //   setState(() {
              //     _isHideValue9 = !_isHideValue9;
              //   });
              // }),
              // _buildGroup5('内存容量', _value10, _isHideValue10, () {
              //   setState(() {
              //     _isHideValue10 = !_isHideValue10;
              //   });
              //}),
            ]),
          ),
          Container(
            padding:
            EdgeInsets.only(left: 25.w, top: 6.h, right: 25.w, bottom: 16.h),
            height: 88.h,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: <Widget>[
                Container(
//            margin: EdgeInsets.only(left: 6, right: 6),
                  padding:
                      EdgeInsets.only(left: 50.w, top: 6.h, right: 50.w, bottom: 6.h),
                  height: 68.h,
//                  width: 44,
                  decoration: BoxDecoration(
                    color: Color(0xFFfea000),
                    borderRadius:
                        BorderRadius.horizontal(left: Radius.circular(34.w)),
                  ),
                  child: GestureDetector(
                    onTap: (){

                     widget.selectItems.removeWhere((e) => e.type <100);

                      for(int j=0;j< _valueFrom.length;j++){

                        _valueFrom[j].isSelect =false;

                      }
                      for(int j=0;j< _valueEducation.length;j++){

                        _valueEducation[j].isSelect =false;

                      }
                      for(int j=0;j< _valueIncome.length;j++){

                        _valueIncome[j].isSelect =false;

                      }
                      for(int j=0;j< _valueHouse.length;j++){

                        _valueHouse[j].isSelect =false;

                      }
                      for(int j=0;j< _valueMarriage.length;j++){

                        _valueMarriage[j].isSelect =false;

                      }

                     showToastBottom(context, "重置成功", true);

                      setState(() {

                      });
                    },
                    child: Text(
                      '重置',
                      style: TextStyle(color: Colors.white, fontSize: 30.sp),
                      textAlign: TextAlign.center,
                    ),
                  ),
                  alignment: Alignment.centerLeft,
                ),
                Container(
//            margin: EdgeInsets.only(left: 6, right: 6),
                  padding:
                      EdgeInsets.only(left: 50.w, top: 6.h, right: 50.w, bottom: 6.h),
                  height: 68.h,
                  decoration: BoxDecoration(
                    color: Color(0xFFfe7201),
                    borderRadius:
                        BorderRadius.horizontal(right: Radius.circular(34.w)),
                  ),
                  child: GestureDetector(
                    child: Text('确定',
                        style: TextStyle(fontSize: 30.sp, color: Colors.white)),
                    onTap: () {
                      var sex = BlocProvider.of<GlobalBloc>(context).state.sex;
                      var mode = BlocProvider.of<GlobalBloc>(context)
                          .state
                          .currentPhotoMode;
                      BlocProvider.of<HomeBloc>(context).add(EventSearchErpUser(
                          null, widget.selectItems, sex, mode, false, 0, 0, ""));
                      Navigator.pop(context);
                    },
                  ),
                  alignment: Alignment.centerLeft,
                ),
                SizedBox(
                  width: 6.w,
                )
              ],
            ),
          )
        ],
      ),
    );
  }
}
