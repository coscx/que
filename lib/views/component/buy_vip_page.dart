import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_geen/app/api/issues_api.dart';

import 'package:flutter_geen/blocs/bloc_exp.dart';

import 'package:flutter_geen/storage/dao/widget_dao.dart';
import 'package:flutter_geen/views/pages/home/gzx_filter_goods_page.dart';

import 'package:flutter_geen/views/pages/utils/DyBehaviorNull.dart';
import 'package:flutter_geen/views/items/single_choice.dart';
import 'package:flutter_my_picker/flutter_my_picker.dart';
import 'package:flutter_picker/Picker.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_range_slider/flutter_range_slider.dart' as frs;
import 'package:flutter_geen/views/dialogs/common_dialog.dart';
bool select1 = false;
bool select2 = false;
bool select3 = false;

class BuyVipPage extends StatefulWidget {
  final Map<String,dynamic> args;

  BuyVipPage({
    @required this.args,
  });

  @override
  _BuyVipPagePageState createState() => _BuyVipPagePageState();
}

class StoreItem {
  String name;
  int id;
  String price;
  String month;
  String count;
  String tag;
  bool isSelect;
  int index;
  int type;

  StoreItem(
      {this.name,
      this.id,
      this.isSelect,
      this.index,
      this.type,
      this.price,
      this.month,
      this.count,
      this.tag});
}

class _BuyVipPagePageState extends State<BuyVipPage>
    with WidgetsBindingObserver {
  DateTime startBirthDay = DateTime.now();
  String startBirthDayTitle = DateTime.now().toString().substring(0,19);
  String startBirthDayValue = DateTime.now().toString().substring(0,19);
  String store = "";
  String storeName = "选择会员套餐";
  String price = "";
  String month = "";
  String count = "";
  String tag = "";
  int type =0;
  int vipId=0;
  int minValue;
  int maxValue;
  int sexSelect = 0;
  List<String> pickerStoreData = [];
  List<StoreItem> pickerStoreItem = [];
  bool _isButton1Disabled = false;
  final _vipPriceController = TextEditingController(text: '');
  final _vipMonthController = TextEditingController(text: '');
  final _vipCountController = TextEditingController(text: '');
  final _tagController = TextEditingController(text: '');
  FocusNode _remarkFieldNode = FocusNode();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    minValue = 18;
    maxValue = 80;
    Future.delayed(Duration(milliseconds: 1)).then((e) async {
      var result = await IssuesApi.getStoreVips();
      if (result['code'] == 200) {
        var y = result['data'];
        List<dynamic> da = y['data'] as List;

        StoreItem ff = StoreItem();
        ff.id = 0;
        ff.type = 600;
        ff.name = "请选择";
        ff.index = 0;
        ff.isSelect = false;
        pickerStoreItem.add(ff);
        pickerStoreData.add(ff.name);
        da.forEach((value) {
          StoreItem ff = StoreItem();
          ff.id = value['id'];
          ff.type = 600;
          ff.name = value['name'];
          ff.price = value['favorable'];
          ff.month = value['time'].toString();
          ff.count = value['meet'].toString();
          ff.tag = value['description'];
          ff.index = 0;
          ff.isSelect = false;
          pickerStoreItem.add(ff);
          pickerStoreData.add(value['name']);
        });
        StoreItem ff1 = StoreItem();
        ff1.id = 9999;
        ff1.type = 9999;
        ff1.name = "自定义套餐";
        ff1.index = 0;
        ff1.isSelect = false;
        pickerStoreItem.add(ff1);
        pickerStoreData.add(ff1.name);
      } else {}
    });
  }

  @override
  Widget build(BuildContext context) {
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
                  child: Text("购买会员套餐",
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
                  BlocProvider.of<SearchBloc>(context)
                      .add(EventTextChanged(args: SearchArgs()));
                  BlocProvider.of<SearchBloc>(context).add(EventClearPage());
                  BlocProvider.of<GlobalBloc>(context)
                      .add(EventSearchPhotoPage(0));
                  return true;
                },
                child: GestureDetector(
                  behavior: HitTestBehavior.translucent,
                  onTap: () {
                    // 触摸收起键盘
                    FocusScope.of(context).requestFocus(FocusNode());
                  },
                  child: ScrollConfiguration(
                      behavior: DyBehaviorNull(),
                      child: ListView(
                        physics: const BouncingScrollPhysics(),
                        shrinkWrap: true,
                        children: <Widget>[
                          buildStore("套餐选择:"),
                          buildVipPrice(),
                          buildVipMonth(),
                          buildVipCount(),
                          buildBirthday("支付时间"),
                          buildTag(),
                          buildSubmit()
                        ],
                      )),
                ))));
  }

  Widget buildSubmit() {
    return Padding(
      padding: EdgeInsets.only(top: 50.h, bottom: 0.h, left: 30.h, right: 30.h),
      child: Container(
        width: ScreenUtil().screenWidth * 0.7,
        height: 70.h,
        child: RaisedButton(
          elevation: 0,
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(40.w))),
          color: Colors.lightBlue,
          onPressed: () async {
            var data = Map<String, dynamic>();
            if (type == 9999) {
              tag =_tagController.text;
              price =_vipPriceController.text;
              month =_vipMonthController.text;
              count =_vipCountController.text;
            }
            if (vipId==0){
              showToastRed(context, "请选择套餐" , true);
              return;
            }
            if (price==""){
              showToastRed(context, "请输入套餐价格" , true);
              return;
            }
            if (month==""){
              showToastRed(context, "请输入套餐时长" , true);
              return;
            }
            if (count==""){
              showToastRed(context, "请输入套餐次数" , true);
              return;
            }
            if (startBirthDayValue==""){
              showToastRed(context, "请选择支付时间" , true);
              return;
            }
            if (tag==""){
              showToastRed(context, "请输入支付备注" , true);
              return;
            }

            data['favorable'] = price;
            data['store_id'] = widget.args['store_id'];
            data['time'] = month;
            data['meet'] = count;
            data['pay_time'] = startBirthDayValue;
            data['description'] = tag;
            data['name'] = "自定义套餐";
            data['original'] = price;
            data['services[0]'] = "";
            var results = await IssuesApi.addMealFree(widget.args['uuid'], data);
            if (results['code'] == 200) {

              var id = results['data']['id'];
              var data1 = Map<String, dynamic>();
              data1['pay_price'] = price;
              data1['customer_uuid'] = widget.args['uuid'];
              data1['pay_time'] = startBirthDayValue;
              data1['remark'] = tag;
              data1['vip_id'] = vipId;
              if(type==9999){
                data1['vip_id'] = id['id'];
                data1['free'] = 1;
              }
              data['services[0]'] = "";
              var result = await IssuesApi.buyVip(widget.args['uuid'], data1);
              if (result['code'] == 200) {
                //print(result['data'] );
                showToast(context, "购买成功" , true);
                BlocProvider.of<DetailBloc>(context)
                    .add(FetchWidgetDetail(widget.args));
                Navigator.of(context).pop();
              }else{
                showToastRed(context, result['message'] , true);
              }

            } else {
              showToastRed(context, results['message'] , true);
            }

          },
          child: Text("提交",
              style: TextStyle(color: Colors.white, fontSize: 40.sp)),
        ),
      ),
    );
  }

  Widget buildVipPrice() {
    return Column(
      children: [
        Row(
          children: [
            Container(
              padding: EdgeInsets.only(
                  top: 0.h, bottom: 0.h, left: 30.h, right: 0.h),
              child: Text("套餐价格:",
                  style: TextStyle(color: Colors.black, fontSize: 30.sp)),
            ),
            Container(
              width: ScreenUtil().screenWidth * 0.5,
              decoration: BoxDecoration(
                border: Border.all(
                  color: Colors.grey.withOpacity(0.5),
                  width: 1.0,
                ),
                borderRadius: BorderRadius.circular(15.0),
              ),
              margin:
                  const EdgeInsets.symmetric(vertical: 10.0, horizontal: 10.0),
              child: Row(
                children: <Widget>[
                  Padding(
                    padding:
                        EdgeInsets.symmetric(vertical: 10.0, horizontal: 15.0),
                    child: Container(),
                  ),
                  Container(),
                  Expanded(
                    child: TextField(
                      enabled: _isButton1Disabled,
                      controller: _vipPriceController,
                      decoration: InputDecoration(
                        border: InputBorder.none,
                        hintText: '请输入套餐价格...',
                        hintStyle: TextStyle(color: Colors.grey),
                      ),
                      inputFormatters: <TextInputFormatter>[
                        LengthLimitingTextInputFormatter(11) //限制长度
                      ],
                      onChanged: (str) {
                        setState(() {});
                      },
                    ),
                  )
                ],
              ),
            ),
            Container(
              padding:
                  EdgeInsets.only(top: 0.h, bottom: 0.h, left: 0.h, right: 0.h),
              child: Text("元",
                  style: TextStyle(color: Colors.black, fontSize: 30.sp)),
            ),
          ],
        )
      ],
    );
  }

  Widget buildVipMonth() {
    return Column(
      children: [
        Row(
          children: [
            Container(
              padding: EdgeInsets.only(
                  top: 0.h, bottom: 0.h, left: 30.h, right: 0.h),
              child: Text("服务时长:",
                  style: TextStyle(color: Colors.black, fontSize: 30.sp)),
            ),
            Container(
              width: ScreenUtil().screenWidth * 0.5,
              decoration: BoxDecoration(
                border: Border.all(
                  color: Colors.grey.withOpacity(0.5),
                  width: 1.0,
                ),
                borderRadius: BorderRadius.circular(15.0),
              ),
              margin:
                  const EdgeInsets.symmetric(vertical: 10.0, horizontal: 10.0),
              child: Row(
                children: <Widget>[
                  Padding(
                    padding:
                        EdgeInsets.symmetric(vertical: 10.0, horizontal: 15.0),
                    child: Container(),
                  ),
                  Container(),
                  Expanded(
                    child: TextField(
                      enabled: _isButton1Disabled,
                      controller: _vipMonthController,
                      decoration: InputDecoration(
                        border: InputBorder.none,
                        hintText: '请输入服务时长...',
                        hintStyle: TextStyle(color: Colors.grey),
                      ),
                      inputFormatters: <TextInputFormatter>[
                        LengthLimitingTextInputFormatter(11) //限制长度
                      ],
                      onChanged: (str) {
                        setState(() {});
                      },
                    ),
                  )
                ],
              ),
            ),
            Container(
              padding:
                  EdgeInsets.only(top: 0.h, bottom: 0.h, left: 0.h, right: 0.h),
              child: Text("个月",
                  style: TextStyle(color: Colors.black, fontSize: 30.sp)),
            ),
          ],
        )
      ],
    );
  }

  Widget buildVipCount() {
    return Column(
      children: [
        Row(
          children: [
            Container(
              padding: EdgeInsets.only(
                  top: 0.h, bottom: 0.h, left: 30.h, right: 0.h),
              child: Text("排约次数:",
                  style: TextStyle(color: Colors.black, fontSize: 30.sp)),
            ),
            Container(
              width: ScreenUtil().screenWidth * 0.5,
              decoration: BoxDecoration(
                border: Border.all(
                  color: Colors.grey.withOpacity(0.5),
                  width: 1.0,
                ),
                borderRadius: BorderRadius.circular(15.0),
              ),
              margin:
                  const EdgeInsets.symmetric(vertical: 10.0, horizontal: 10.0),
              child: Row(
                children: <Widget>[
                  Padding(
                    padding:
                        EdgeInsets.symmetric(vertical: 10.0, horizontal: 15.0),
                    child: Container(),
                  ),
                  Container(),
                  Expanded(
                    child: TextField(
                      enabled: _isButton1Disabled,
                      controller: _vipCountController,
                      decoration: InputDecoration(
                        border: InputBorder.none,
                        hintText: '请输入排约次数...',
                        hintStyle: TextStyle(color: Colors.grey),
                      ),
                      inputFormatters: <TextInputFormatter>[
                        LengthLimitingTextInputFormatter(11) //限制长度
                      ],
                      onChanged: (str) {
                        setState(() {});
                      },
                    ),
                  )
                ],
              ),
            ),
            Container(
              padding:
                  EdgeInsets.only(top: 0.h, bottom: 0.h, left: 0.h, right: 0.h),
              child: Text("次",
                  style: TextStyle(color: Colors.black, fontSize: 30.sp)),
            ),
          ],
        )
      ],
    );
  }

  Widget buildTag() {
    return Column(
      children: [
        Container(
          padding:
              EdgeInsets.only(top: 0.h, bottom: 0.h, left: 0.h, right: 0.h),
          child: Text("支付备注",
              style: TextStyle(color: Colors.black, fontSize: 30.sp)),
        ),
        Column(
          children: [
            Container(
              padding: EdgeInsets.only(
                  top: 20.h, bottom: 0.h, left: 0.h, right: 0.h),
              width: ScreenUtil().screenWidth * 0.9,
              child: TextField(
                controller: _tagController,
                focusNode: _remarkFieldNode,
                style: TextStyle(color: Colors.black),
                minLines: 7,
                maxLines: 7,
                cursorColor: Colors.green,
                cursorRadius: Radius.circular(3.w),
                cursorWidth: 5.w,
                showCursor: true,
                decoration: InputDecoration(
                  contentPadding: EdgeInsets.all(10.w),
                  hintText: "请输入...",
                  border: OutlineInputBorder(),
                ),
                onChanged: (v) {},
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget buildBirthday(String title) {
    return Container(
      padding: EdgeInsets.only(left: 20.w, top: 0.h, right: 0.w, bottom: 0.h),
      child: Column(
        children: [
          Container(
            child: Row(
              //mainAxisAlignment: MainAxisAlignment.center,
              //crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  padding: EdgeInsets.only(
                      left: 10.w, top: 0.h, right: 0.w, bottom: 0.h),
                  alignment: Alignment.centerLeft,
                  child: Text(title,
                      style: TextStyle(fontSize: 30.sp, color: Colors.black)),
                ),
                Container(
                  padding: EdgeInsets.only(
                      left: 30.w, top: 0.h, right: 0.w, bottom: 0.h),
                  child: ElevatedButton(
                    onPressed: () {
                      MyPicker.showPicker(
                          context: context,
                          current: startBirthDay,
                          mode: MyPickerMode.dateTime,
                          onConfirm: (v) {
                            //_change('yyyy-MM-dd HH:mm'),
                            print(v);
                            setState(() {
                              startBirthDay = v;
                              startBirthDayTitle =
                                  v.toString().substring(0, 19);

                              startBirthDayValue = startBirthDayTitle;
                            });
                          });
                    },
                    child: Text(
                      startBirthDayTitle == "" ? " " : startBirthDayTitle,
                      style: TextStyle(
                          fontSize: 30.sp,
                          color: startBirthDayValue == ""
                              ? Colors.black
                              : Colors.white),
                    ),
                    style: ElevatedButton.styleFrom(
                        onPrimary: Colors.white,
                        primary: startBirthDayValue == ""
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
      ),
    );
  }

  Widget buildStore(String title) {
    int storeId = 0;

    return Container(
      padding: EdgeInsets.only(left: 0.w, top: 20.h, right: 0.w, bottom: 0.h),
      child: Column(
        children: [
          Container(
            child: Row(
              //mainAxisAlignment: MainAxisAlignment.start,
              //crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  padding: EdgeInsets.only(
                      left: 30.w, top: 0.h, right: 0.w, bottom: 0.h),
                  alignment: Alignment.center,
                  child: Text(title,
                      style: TextStyle(fontSize: 30.sp, color: Colors.black)),
                ),
                Container(
                  padding: EdgeInsets.only(
                      left: 30.w, top: 0.h, right: 0.w, bottom: 0.h),
                  child: ElevatedButton(
                    onPressed: () {
                      new Picker(
                              selecteds: [storeId],
                              itemExtent: 40,
                              selectionOverlay:
                                  CupertinoPickerDefaultSelectionOverlay(
                                background: Colors.transparent,
                              ),
                              cancelText: "取消",
                              confirmText: "确定",
                              selectedTextStyle: TextStyle(
                                  fontSize: 40.sp, color: Colors.redAccent),
                              textStyle: TextStyle(
                                  fontSize: 25.sp, color: Colors.black),
                              adapter: PickerDataAdapter<String>(
                                  pickerdata: pickerStoreData),
                              changeToFirst: true,
                              hideHeader: false,
                              onConfirm: (Picker picker, List value) {
                                print(value.toString());
                                print(picker.adapter.text);
                                setState(() {
                                  storeName = pickerStoreData[value[0]];
                                  price = pickerStoreItem[value[0]].price;
                                  month = pickerStoreItem[value[0]].month;
                                  count = pickerStoreItem[value[0]].count;
                                  tag = pickerStoreItem[value[0]].tag;
                                  _tagController.text = tag;
                                  _vipPriceController.text = price;
                                  _vipMonthController.text = month;
                                  _vipCountController.text = count;
                                  _isButton1Disabled = false;
                                  type=pickerStoreItem[value[0]].type;
                                  vipId=pickerStoreItem[value[0]].id;
                                  if (pickerStoreItem[value[0]].type == 9999) {
                                    _tagController.clear();
                                    _vipPriceController.clear();
                                    _vipMonthController.clear();
                                    _vipCountController.clear();
                                    _isButton1Disabled = true;
                                  }
                                });
                              })
                          .showModal(
                              this.context); //_scaffoldKey.currentState);
                    },
                    child: Text(
                      storeName == "" ? " " : storeName,
                      style: TextStyle(
                          fontSize: 30.sp,
                          color: storeName == "选择会员套餐"
                              ? Colors.black
                              : Colors.white),
                    ),
                    style: ElevatedButton.styleFrom(
                        onPrimary: Colors.white,
                        primary: storeName == "选择会员套餐"
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
      ),
    );
  }

  Widget buildRangerSlider(String title) {
    return Container(
      padding: EdgeInsets.only(left: 20.w, top: 0.h, right: 0.w, bottom: 0.h),
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
