// import 'package:amap_map_fluttify/amap_map_fluttify.dart';
// import 'package:flutter/cupertino.dart';
// import 'package:flutter/material.dart';
// class SelectLocationFromMapPage extends StatefulWidget {
//   @override
//   _SelectLocationFromMapPageState createState() =>
//       _SelectLocationFromMapPageState();
// }
//
// class _SelectLocationFromMapPageState extends State<SelectLocationFromMapPage> {
//   AmapController _controller;
//   List<Poi> poiList;
//   static List<PoiModel> list = new List();
//   static List<PoiModel> searchlist = new List();
//   PoiModel poiModel;
//   String keyword = "";
//   String address = "";
//   bool isloading = true;
//
//   @override
//   void initState() {
//     super.initState();
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       resizeToAvoidBottomPadding: false, //防止底部布局被顶起
//       appBar: AppBar(
//         title: Text(
//         '选择位置信息',
//         style: CustomTextStyle.appBarTitleTextStyle,
//         ),
//         elevation: 0.0,
//         centerTitle: true,
//       ),
//
//       body: Column(
//         children: <Widget>[
//           Theme(
//             data: new ThemeData(
//                 primaryColor: Color(0xFFFFCA28), hintColor: Color(0xFFFFCA28)),
//             child: Container(
//               color: Color(0xFFFFCA28),
//               padding: EdgeInsets.all(5),
//               child: Container(
//                 height: 36,
//                 margin: EdgeInsets.only(left: 5, right: 5, bottom: 5),
//                 child: TextField(
//                   style: TextStyle(fontSize: 16, letterSpacing: 1.0),
//                   controller: TextEditingController.fromValue(TextEditingValue(
//                     // 设置内容
//                     text: keyword,
//                     selection: TextSelection.fromPosition(TextPosition(
//                         affinity: TextAffinity.downstream,
//                         offset: keyword?.length ?? 0)),
//                     // 保持光标在最后
//                   )),
//                   decoration: InputDecoration(
//                     border: OutlineInputBorder(
//                       borderRadius: BorderRadius.all(Radius.circular(40)),
//                     ),
//                     hintText: '输入关键字',
//                     hintStyle:
//                     TextStyle(color: Color(0xFFBEBEBE), fontSize: 14),
//                     contentPadding:
//                     const EdgeInsets.symmetric(vertical: 8, horizontal: 1),
//                     prefixIcon: Icon(
//                       Icons.search,
//                       color: Colors.grey,
//                       size: 20,
//                     ),
//                     suffixIcon: IconButton(
//                       icon: Icon(
//                         Icons.clear,
//                         color: Colors.grey,
//                         size: 20,
//                       ),
//                       onPressed: () {
//                         keyword = "";
//                         setState(() {});
//                       },
//                     ),
//                     fillColor: Colors.white,
//                     filled: true,
//                   ),
//
//                   inputFormatters: [],
//                   //内容改变的回调
//                   onChanged: (text) {
//                     print('change $text');
//                     keyword = text;
//                   },
//                   //内容提交(按回车)的回调
//                   onSubmitted: (text) {
//                     print('submit $text');
//                     // 触发关闭弹出来的键盘。
//                     keyword = text;
//                     setState(() {
//                       isloading = true;
//                       FocusScope.of(context).requestFocus(FocusNode());
//                     });
//
//                     searchAroundAddress(text.toString());
//                   },
//                   //按回车时调用
//                   onEditingComplete: () {
//                     print('onEditingComplete');
//                   },
//                 ),
//               ),
//             ),
//           ),
//           Container(
//             height: 300,
//             child: Stack(
//               children: <Widget>[
//                 AmapView(
//                   showZoomControl: false,
//                   centerCoordinate: LatLng(39, 110),
//                   maskDelay: Duration(milliseconds: 500),
//                   zoomLevel: 16,
//                   onMapCreated: (controller) async {
//                     _controller = controller;
//                     if (await requestPermission()) {
//                       await controller.showMyLocation(true);
//                       await controller?.showLocateControl(true);
//                       final latLng = await _controller?.getLocation();
//                       await enableFluttifyLog(false); // 关闭log
//                       _loadData(latLng);
//                     }
//                   },
//                   onMapMoveEnd: (MapMove move) async {
//                     _loadData(move.latLng);
//                   },
//                 ),
//                 Center(
//                   child: Icon(
//                     Icons.place,
//                     size: 36.0,
//                     color: Color(0xFFFF0000),
//                   ),
//                 ),
//               ],
//             ),
//           ),
//           Expanded(
//             flex: 1,
//             child: Visibility(
//               visible: !isloading,
//               maintainSize: false,
//               maintainSemantics: false,
//               maintainInteractivity: false,
//               replacement: PageLoading(),
//               child: ListView.builder(
//                   itemCount: list.length,
//                   itemBuilder: (BuildContext context, int position) {
//                     print("itemBuilder" + list.length.toString());
//                     PoiModel item = list[position];
//                     return InkWell(
//                       child: Column(
//                         children: <Widget>[
//                           Container(
//                             margin:
//                             EdgeInsets.only(top: 8, bottom: 5, left: 10),
//                             child: Row(
//                               children: <Widget>[
//                                 Icon(
//                                   Icons.place,
//                                   size: 20.0,
//                                   color: position == 0
//                                       ? Colors.green
//                                       : Colors.grey,
//                                 ),
//                                 Text(item.title,
//                                     style: TextStyle(
//                                         fontSize: 16,
//                                         color: position == 0
//                                             ? Colors.green
//                                             : Color(0xFF787878)))
//                               ],
//                             ),
//                           ),
//                           Container(
//                             margin:
//                             EdgeInsets.only(top: 5, bottom: 5, left: 18),
//                             alignment: Alignment.centerLeft,
//                             child: Text(
//                               item.address,
//                               style: TextStyle(
//                                 fontSize: 14,
//                                 color: Color(0xFF646464),
//                               ),
//                             ),
//                           ),
//                           Divider(
//                             height: 1,
//                           )
//                         ],
//                       ),
//                       onTap: () async {
//                         await _controller.setCenterCoordinate(
//                             item.latLng,
//                             zoomLevel: 16);
//                         Navigator.pop(context, {
//                         'address': item.address,
//                         });
//                       },
//                     );
//                   }),
//             ),
//           ),
//         ],
//       ),
//     );
//   }
//
//   void _loadData(LatLng latLng) async {
//     setState(() {
//       isloading = true;
//     });
//
//     /// 逆地理编码（坐标转地址）
//     ReGeocode reGeocodeList = await AmapSearch.searchReGeocode(
//       latLng,
//     );
//
//     print(await reGeocodeList.toFutureString());
//     address = await reGeocodeList.formatAddress;
//
//
//     final poiList = await AmapSearch.searchKeyword(
//       address.toString(),
//       city: "西安",
//     );
//
//     poiModel = new PoiModel("当前位置", address, latLng);
//     list.clear();
//     list.add(poiModel);
//     for (var poi in poiList) {
//       String title = await poi.title;
//       String cityName = await poi.cityName;
//       String provinceName = await poi.provinceName;
//       String address = await poi.address;
//       LatLng latLng = await poi.latLng;
//
//       list.add(new PoiModel(
//           title.toString(),
//           provinceName.toString() + cityName.toString() + address.toString(),
//           latLng));
//     }
//
//     setState(() {
//       isloading = false;
//     });
//   }
//
//   void searchAroundAddress(String text) async {
//     final poiList = await AmapSearch.searchKeyword(
//       text,
//       city: "西安",
//     );
//
//     list.clear();
//     list.add(poiModel);
//     for (var poi in poiList) {
//       String title = await poi.title;
//       LatLng latLng = await poi.latLng;
//       String cityName = await poi.cityName;
//       String provinceName = await poi.provinceName;
//       String address = await poi.address;
//       list.add(new PoiModel(
//           title.toString(),
//           provinceName.toString() + cityName.toString() + address.toString(),
//           latLng));
//     }
//     setState(() {
//       isloading = false;
//       FocusScope.of(context).requestFocus(FocusNode());
//     });
//   }
// }
//
// class PoiModel {
//   LatLng latLng;
//   String title;
//   String address;
//
//   PoiModel(this.title, this.address, this.latLng);
// }
// class PageLoading extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return Center(
//       child: Row(
//         mainAxisAlignment: MainAxisAlignment.center,
//         crossAxisAlignment: CrossAxisAlignment.center,
//         children: <Widget>[
//           CupertinoActivityIndicator(),
// //          Text(‘  正在加载‘, style: TextStyle(fontSize: 16.0),),
//         ],
//       ),
//     );
//   }