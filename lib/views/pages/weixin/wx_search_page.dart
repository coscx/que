import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_geen/app/api/issues_api.dart';

import 'package:flutter_geen/blocs/bloc_exp.dart';

import 'package:flutter_geen/storage/dao/widget_dao.dart';
import 'package:flutter_geen/views/pages/home/gzx_filter_goods_page.dart';

import 'package:flutter_geen/views/pages/utils/DyBehaviorNull.dart';
import 'package:flutter_geen/views/items/single_choice.dart';
import 'package:flutter_picker/Picker.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_range_slider/flutter_range_slider.dart' as frs;



class WxSearchPage extends StatefulWidget {
  final List<SelectItem> selectItems;
  WxSearchPage({
    @required this.selectItems,
  });
  @override
  _WxSearchPageState createState() => _WxSearchPageState();
}

class StoreItem {
  String name;
  String id;
  bool isSelect;
  int index;
  int type;

  StoreItem({this.name, this.id, this.isSelect, this.index, this.type});
}
class _WxSearchPageState extends State<WxSearchPage> {
  bool select1 = false;
  bool select2 = false;
  bool select3 = false;
  bool changed =false;
  String store = "";
  String storeName = "选择门店";
  int minValue;
  int maxValue;
  int sexSelect = 0;
  List<String> pickerStoreData = [];
  List<StoreItem> pickerStoreItem = [];
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    minValue = 18;
    maxValue = 80;
    Future.delayed(Duration(milliseconds: 1)).then((e) async {
      var result = await IssuesApi.getOnlyStoreList();
      if (result['code'] == 200) {
        List<dynamic> da = result['data'];

        StoreItem ff = StoreItem();
        ff.id = "0";
        ff.type = 600;
        ff.name = "请选择";
        ff.index = 0;
        ff.isSelect = false;
        pickerStoreItem.add(ff);
        pickerStoreData.add(ff.name);
        da.forEach((value) {
          StoreItem ff = StoreItem();
          ff.id = value['id'].toString();
          ff.type = 600;
          ff.name = value['name'];
          ff.index = 0;
          ff.isSelect = false;
          pickerStoreItem.add(ff);
          pickerStoreData.add(value['name']);
        });
      } else {

      }
    });
  }

  @override
  Widget build(BuildContext context) {
    for (int j = 0; j < widget.selectItems.length; j++) {
      if (widget.selectItems[j].type == 1000) {
        sexSelect = int.parse(widget.selectItems[j].id);
      }
    }
    return Theme(
        data: ThemeData(
          appBarTheme: AppBarTheme.of(context).copyWith(
            brightness: Brightness.light,
          ),
        ),
        child: Scaffold(
            appBar: AppBar(
              backgroundColor: Colors.white,
              elevation: 0,
              //去掉Appbar底部阴影
              leadingWidth: 150.w,
              leading: IconButton(
                icon: Icon(Icons.arrow_back, color: Colors.black),
                onPressed: () => Navigator.of(context).pop(),
              ),
              title: Container(
                  padding: EdgeInsets.only(left: 0.w, top: 0.w, bottom: 0),
                  child: Text("用户搜索",
                      style: TextStyle(
                        fontFamily: "Quicksand",
                        fontWeight: FontWeight.w900,
                        fontStyle: FontStyle.italic,
                        fontSize: 45.sp,
                        decoration: TextDecoration.none,
                        color: Colors.black,
                      ))),
              actions: <Widget>[],
            ),
            body: WillPopScope(
                onWillPop: () async {
                  //返回时 情空搜索
                  // BlocProvider.of<SearchBloc>(context)
                  //     .add(EventTextChanged(args: SearchArgs()));
                  // BlocProvider.of<SearchBloc>(context).add(EventClearPage());
                  // BlocProvider.of<GlobalBloc>(context)
                  //     .add(EventSearchPhotoPage(0));
                  return true;
                },
                child: ScrollConfiguration(
                    behavior: DyBehaviorNull(),
                    child: ListView(
                      physics: const BouncingScrollPhysics(),
                      shrinkWrap: true,
                      children: <Widget>[

                        Container(

                          padding: EdgeInsets.only(top: 20.h, bottom: 0.h,left: 0.h,right: 0.h),
                          child: Row(
                            children: [
                              OriginAuthority(
                                authorityChanged: (int value) {
                                  int j = 0, k = 0;
                                  for (int i = 0;
                                  i < widget.selectItems.length;
                                  i++) {
                                    if (widget.selectItems[i].type == 1000) {
                                      j = 1;
                                      widget.selectItems[i].id =
                                          value.toString();
                                      widget.selectItems[i].name =
                                          value.toString();
                                      break;
                                    }
                                  }

                                  if (j == 0) {
                                    SelectItem s = SelectItem();
                                    s.type = 1000;
                                    s.name =  value.toString();;
                                    s.id =  value.toString();
                                    widget.selectItems.add(s);
                                  }
                                }, isSelected: sexSelect,
                              )
                            ],
                          ),
                        ),
                        buildRangerSlider("年龄"),
                        buildStore("门店选择"),
                        Padding(
                          padding: EdgeInsets.only(top: 40.h, bottom: 0.h,left: 30.h,right: 30.h),
                          child: Container(
                            width: ScreenUtil().screenWidth*0.7,
                            height: 70.h,
                            child: RaisedButton(
                              elevation: 0,
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.all(Radius.circular(40.w))),
                              color: Colors.lightBlue,
                              onPressed: (){
                                setState(() {
                                  changed =true;
                                });

                                Navigator.of(context).pop(changed);
                              },
                              child: Text("提交",
                                  style: TextStyle(color: Colors.white, fontSize: 40.sp)),
                            ),
                          ),
                        ),
                      ],
                    )))));
  }
  Widget buildStore(String title) {
    int storeId = 0;
    for (int j = 0; j < widget.selectItems.length; j++) {
      if (widget.selectItems[j].type == 600) {
        storeId = int.parse(widget.selectItems[j].id);
        storeName = widget.selectItems[j].name;
      }
    }
    for (int j = 0; j < pickerStoreItem.length; j++) {
      if (pickerStoreItem[j].id == storeId.toString()) {
        storeId = j;
      }
    }

    return Column(
      children: [
        Container(
          padding:
          EdgeInsets.only(left: 40.w, top: 20.h, right: 0.w, bottom: 0.h),
          alignment: Alignment.centerLeft,
          child: Text(title,
              style: TextStyle(fontSize: 24.sp, color: Color(0xFF6a6a6a))),
        ),
        Container(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                padding: EdgeInsets.only(
                    left: 10.w, top: 0.h, right: 0.w, bottom: 0.h),
                child: ElevatedButton(
                  onPressed: () {
                     Picker(
                       height: 400.h,
                        selecteds: [storeId],
                        itemExtent: 40,
                        selectionOverlay:
                        CupertinoPickerDefaultSelectionOverlay(
                          background: Colors.transparent,
                        ),
                        cancelText: "取消",
                        cancelTextStyle:  TextStyle(
                            fontSize: 30.sp, color: Colors.black),
                        confirmTextStyle: TextStyle(
                            fontSize: 30.sp, color: Colors.blue),
                        confirmText: "确定",
                        selectedTextStyle: TextStyle(
                            fontSize: 38.sp, color: Colors.redAccent),
                        textStyle:
                        TextStyle(fontSize: 25.sp, color: Colors.black),
                        adapter: PickerDataAdapter<String>(
                            pickerdata: pickerStoreData),
                        changeToFirst: true,
                        hideHeader: false,
                        onConfirm: (Picker picker, List value) {
                          print(value.toString());
                          print(picker.adapter.text);
                          setState(() {
                            store = pickerStoreItem[value[0]].id;
                            storeName = pickerStoreItem[value[0]].name;
                            int j = 0, k = 0;
                            for (int i = 0;
                            i < widget.selectItems.length;
                            i++) {
                              if (widget.selectItems[i].type == 600) {
                                j = 1;
                                widget.selectItems[i].id =
                                    pickerStoreItem[value[0]].id;
                                widget.selectItems[i].name =
                                    pickerStoreItem[value[0]].name;
                                break;
                              }
                            }

                            if (j == 0) {
                              SelectItem s = SelectItem();
                              s.type = 600;
                              s.name = pickerStoreItem[value[0]].name;
                              s.id = pickerStoreItem[value[0]].id;
                              widget.selectItems.add(s);
                            }
                          });
                        })
                        .showModal(this.context); //_scaffoldKey.currentState);
                  },
                  child: Text(
                    storeName == "" ? " " : storeName,
                    style: TextStyle(
                        fontSize: 30.sp,
                        color:
                        storeName == "选择门店" ? Colors.black : Colors.white),
                  ),
                  style: ElevatedButton.styleFrom(
                      onPrimary: Colors.white,
                      primary: storeName == "选择门店"
                          ? Colors.grey.withAlpha(33)
                          : Colors.blue,
                      shadowColor: Colors.black12,
                      shape: StadiumBorder(),
                      padding: EdgeInsets.symmetric(
                          horizontal: 35.w, vertical: 10.h)),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
  Widget buildRangerSlider(String title) {


    for (int j = 0; j < widget.selectItems.length; j++) {
      if (widget.selectItems[j].type == 300) {
        minValue = int.parse(widget.selectItems[j].id);

      }
    }
    for (int j = 0; j < widget.selectItems.length; j++) {
      if (widget.selectItems[j].type == 301) {
        maxValue = int.parse(widget.selectItems[j].id);

      }
    }

    return Container(
      padding: EdgeInsets.only(left: 20.w, top: 20.h, right: 0.w, bottom: 0.h),
      child: Column(
        children: [
          Container(
            padding:
                EdgeInsets.only(left: 20.w, top: 0.h, right: 0.w, bottom: 0.h),
            alignment: Alignment.centerLeft,
            child: Text(title,
                style: TextStyle(fontSize: 26.sp, color: Color(0xFF6a6a6a))),
          ),
          Row(
            children: [
              Container(
                padding: EdgeInsets.only(
                    left: 20.w, top: 0.h, right: 0.w, bottom: 0.h),
                child: Text(minValue.toString() + "岁",
                    style:
                        TextStyle(fontSize: 26.sp, color: Color(0xFF6a6a6a))),
              ),
              Container(
                padding: EdgeInsets.only(
                    left: 0.w, top: 0.h, right: 0.w, bottom: 0.h),
                width: ScreenUtil().screenWidth * 0.75,
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
                    int j = 0, k = 0;
                    for (int i = 0; i < widget.selectItems.length; i++) {
                      if (widget.selectItems[i].type == 300) {
                        j = 1;
                        widget.selectItems[i].id = minValue.toString();
                        break;
                      }
                    }
                    for (int i = 0; i < widget.selectItems.length; i++) {
                      if (widget.selectItems[i].type == 301) {
                        widget.selectItems[i].id = maxValue.toString();
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
                    setState(() {});
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
                padding: EdgeInsets.only(
                    left: 0.w, top: 0.h, right: 0.w, bottom: 0.h),
                child: Text(maxValue.toString() + "岁",
                    style:
                        TextStyle(fontSize: 26.sp, color: Color(0xFF6a6a6a))),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget buildChild(String name, bool selected) {
    return ChoiceChip(
      backgroundColor: Colors.grey.withAlpha(33),
      selectedColor: Theme.of(context).primaryColor,
      padding: EdgeInsets.only(left: 20.w, right: 20.w),
      labelPadding: EdgeInsets.only(left: 0.w, right: 0.w),
      selectedShadowColor: Colors.black,
      shadowColor: Colors.transparent,
      pressElevation: 5,
      elevation: 3,
      label: Text(
        name,
        style: TextStyle(
            color: selected ? Colors.white : Colors.black,
            fontSize: 30.sp,
            fontWeight: FontWeight.normal),
        overflow: TextOverflow.ellipsis,
      ),
      selected: selected,
      onSelected: (bool value) {
        setState(() {
          selected = value;
        });
      },
    );
  }
}
