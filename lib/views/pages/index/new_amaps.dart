import 'package:bot_toast/bot_toast.dart';
import 'package:flutter/material.dart';
import 'package:flutter_2d_amap/flutter_2d_amap.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class AMaps extends StatefulWidget {
  const AMaps({Key key}) : super(key: key);

  @override
  _AMapsState createState() => _AMapsState();
}

class _AMapsState extends State<AMaps> {
  String keyword = "";
  String address = "";
  String city = "";
  bool isloading = true;
  bool isFirst = false;
  String returnAddress = "";
  List<PoiSearch> _list = [];
  int _index = 0;
  final ScrollController _controller = ScrollController();
  AMap2DController _aMap2DController;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.white,
          elevation: 0,
          //去掉Appbar底部阴影
          leading: IconButton(
            icon: Icon(Icons.arrow_back, color: Colors.black),
            onPressed: () => Navigator.of(context).pop(),
          ),
          title: Text("地址选择",
              style: TextStyle(
                fontFamily: "Quicksand",
                fontWeight: FontWeight.w900,
                fontStyle: FontStyle.italic,
                fontSize: 38.sp,
                decoration: TextDecoration.none,
                color: Colors.black,
              )),
          actions: <Widget>[
            Container(
              margin: EdgeInsets.only(right: 10.w),
              child: IconButton(
                icon: Icon(Icons.add_circle_outline_rounded),
                onPressed: () {
                  if (returnAddress == "") {
                    BotToast.showSimpleNotification(title: returnAddress);
                  }
                  Navigator.pop(context, returnAddress);
                },
                color: Colors.deepOrange,
                splashColor: Colors.grey,
                highlightColor: Colors.blue[300],
                tooltip: '确认选择',
              ),
            ),
            SizedBox(
              width: 10.w,
            )
          ],
        ),
        body: SafeArea(
          child: Column(
            children: <Widget>[
              Expanded(
                flex: 9,
                child: AMap2DView(
                  onPoiSearched: (result) {
                    if (result.isEmpty) {
                      print('无搜索结果返回');
                      return;
                    }
                    _controller.animateTo(0.0,
                        duration: const Duration(milliseconds: 10),
                        curve: Curves.ease);
                    setState(() {
                      _index = 0;
                      _list = result;
                      var item = result[0];
                      returnAddress = item.title+"#"+item.provinceName+item.cityName+item.adName+item.title+"#"+item.longitude+"#"+item.latitude;
                    });
                  },
                  onPoiLocation: (result) {
                    setState(() {
                      city = result.cityName;
                      //print(city);
                      var item =result;
                      returnAddress = item.cityCode+"#"+item.address+"#"+item.longitude+"#"+item.latitude;
                    });

                  },
                  onAMap2DViewCreated: (controller) {
                    _aMap2DController = controller;
                  },
                ),
              ),
              Container(
                // color: Colors.transparent,
                padding: EdgeInsets.all(5.w),
                child: Container(
                  height: 72.h,
                  margin:
                      EdgeInsets.only(left: 10.w, right: 10.w, bottom: 10.h),
                  child: TextField(
                    style: TextStyle(fontSize: 32.sp, letterSpacing: 2.w),
                    controller:
                        TextEditingController.fromValue(TextEditingValue(
                      // 设置内容
                      text: keyword,
                      selection: TextSelection.fromPosition(TextPosition(
                          affinity: TextAffinity.downstream,
                          offset: keyword?.length ?? 0)),
                      // 保持光标在最后
                    )),
                    decoration: InputDecoration(
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(40.w)),
                      ),
                      hintText: '输入关键字',
                      hintStyle:
                          TextStyle(color: Color(0xFFBEBEBE), fontSize: 30.sp),
                      contentPadding:
                          EdgeInsets.symmetric(vertical: 8.h, horizontal: 1.w),
                      prefixIcon: Icon(
                        Icons.search,
                        color: Colors.grey,
                        size: 50.sp,
                      ),
                      suffixIcon: IconButton(
                        icon: Icon(
                          Icons.clear,
                          color: Colors.grey,
                          size: 40.sp,
                        ),
                        onPressed: () {
                          keyword = "";
                          setState(() {});
                        },
                      ),
                      fillColor: Colors.white,
                      filled: true,
                    ),

                    inputFormatters: [],
                    //内容改变的回调
                    onChanged: (text) {
                      print('change $text');
                      keyword = text;
                    },
                    //内容提交(按回车)的回调
                    onSubmitted: (text) {
                      print('submit $text');
                      // 触发关闭弹出来的键盘。
                      keyword = text;
                      setState(() {
                        isloading = true;
                        FocusScope.of(context).requestFocus(FocusNode());
                      });
                      _aMap2DController.search(text.toString(), city: city);
                    },
                    //按回车时调用
                    onEditingComplete: () {
                      print('onEditingComplete');
                    },
                  ),
                ),
              ),
              Expanded(
                flex: 11,
                child: ListView.separated(
                    controller: _controller,
                    shrinkWrap: true,
                    itemCount: _list.length,
                    separatorBuilder: (_, index) {
                      return  Divider(height: 1.2.h);
                    },
                    itemBuilder: (_, index) {
                      return InkWell(
                        onTap: () {
                          setState(() {
                            _index = index;
                            if (_aMap2DController != null) {
                              _aMap2DController.move(
                                  _list[index].latitude ?? '',
                                  _list[index].longitude ?? '');

                              var item = _list[index];
                              returnAddress = item.title+"#"+item.provinceName+item.cityName+item.adName+item.title+"#"+item.longitude+"#"+item.latitude;


                            }
                          });
                        },
                        child: Container(
                          alignment: Alignment.centerLeft,
                          padding:  EdgeInsets.symmetric(horizontal: 16.w),
                          height: 100.h,
                          child: Row(
                            children: <Widget>[
                              Expanded(
                                child: Text(
                                  '${_list[index].provinceName} ${_list[index].cityName} ${_list[index].adName} ${_list[index].title}',
                                ),
                              ),
                              Opacity(
                                  opacity: _index == index ? 1 : 0,
                                  child: const Icon(Icons.done,
                                      color: Colors.blue))
                            ],
                          ),
                        ),
                      );
                    }),
              )
            ],
          ),
        ),
      ),
    );
  }
}
