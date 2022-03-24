import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_geen/app/api/issues_api.dart';
import 'package:flutter_geen/blocs/global/global_bloc.dart';
import 'package:flutter_geen/views/pages/home/flow_page.dart';
import 'package:flutter_geen/views/pages/home/gzx_filter_goods_page.dart';

import 'package:gzx_dropdown_menu/gzx_dropdown_menu.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../blocs/home/home_bloc.dart';
import '../../blocs/home/home_event.dart';



class AppBarComponent extends StatefulWidget {
  final List<SelectItem> selectItems;
  final GlobalKey<ScaffoldState> state;
  AppBarComponent({
    @required this.selectItems,@required this.state,
  });
  @override
  _AppBarComponentState createState() => _AppBarComponentState();
}

class _AppBarComponentState extends State<AppBarComponent> {
  List<CitySelect> firstLevels = <CitySelect>[];
  List<StoreSelect> all = <StoreSelect>[];
  final String title = "";
  final Color bgColor = Colors.black;
  final Color textColor = Colors.redAccent;
  List<String> _dropDownHeaderItemStrings = ['全部门店', '客户状态', '沟通状态', '筛选'];
  List<SortCondition> _brandSortConditions = [];
  List<SortCondition> _distanceSortConditions = [];
  SortCondition _selectBrandSortCondition;
  SortCondition _selectDistanceSortCondition;
  GZXDropdownMenuController _dropdownMenuController =
  GZXDropdownMenuController();
  List<StoreSelect> secondtLevels = <StoreSelect>[];
  GlobalKey _stackKey = GlobalKey();

  @override
  void initState() {
    // TODO: implement initState

    _brandSortConditions
        .add(SortCondition(name: '客户状态', id: 0, isSelected: true, all: true));
    _brandSortConditions
        .add(SortCondition(name: 'A级客户', id: 2, isSelected: false, all: true));
    _brandSortConditions
        .add(SortCondition(name: 'B级客户', id: 1, isSelected: false, all: true));
    _brandSortConditions.add(
        SortCondition(name: 'C级客户', id: 100, isSelected: false, all: true));
    _brandSortConditions
        .add(SortCondition(name: 'D级客户', id: 30, isSelected: false, all: true));

    _selectBrandSortCondition = _brandSortConditions[0];

    _distanceSortConditions
        .add(SortCondition(name: '沟通状态', id: 0, isSelected: true, all: true));
    _distanceSortConditions.add(
        SortCondition(name: '1.新分未联系', id: 1, isSelected: false, all: true));
    _distanceSortConditions.add(
        SortCondition(name: '2.号码无效', id: 2, isSelected: false, all: true));
    _distanceSortConditions.add(
        SortCondition(name: '3.号码未接通', id: 3, isSelected: false, all: true));
    _distanceSortConditions.add(
        SortCondition(name: '4.可继续沟通', id: 4, isSelected: false, all: true));
    _distanceSortConditions.add(
        SortCondition(name: '5.有意向面谈', id: 5, isSelected: false, all: true));
    _distanceSortConditions.add(
        SortCondition(name: '6.确定到店时间', id: 6, isSelected: false, all: true));
    _distanceSortConditions.add(SortCondition(
        name: '7.已到店，意愿需跟进', id: 7, isSelected: false, all: true));
    _distanceSortConditions.add(SortCondition(
        name: '8.已到店，考虑7天付款', id: 8, isSelected: false, all: true));
    _distanceSortConditions.add(SortCondition(
        name: '9.高级会员，支付预付款', id: 9, isSelected: false, all: true));
    _distanceSortConditions.add(SortCondition(
        name: '10.高级会员，费用已结清', id: 10, isSelected: false, all: true));
    _distanceSortConditions.add(
        SortCondition(name: '11.毁单', id: 11, isSelected: false, all: true));
    _distanceSortConditions.add(SortCondition(
        name: '12.放弃并放入公海', id: 12, isSelected: false, all: true));
    _distanceSortConditions.add(SortCondition(
        name: '13.放弃并放入D级', id: 13, isSelected: false, all: true));

    _selectDistanceSortCondition = _distanceSortConditions[0];

    CitySelect ta = CitySelect();
    ta.name = "全部门店";
    ta.id = 0;
    firstLevels.add(ta);

    Future.delayed(Duration(milliseconds: 1)).then((e) async {
      var result = await IssuesApi.getStoreList("1");
      if (result['code'] == 200) {
        all.clear();

        List<dynamic> da = result['data'];
        da.forEach((value) {
          CitySelect cc1 = CitySelect();
          cc1.name = value['name'];
          cc1.id = value['city_code'] ==null?0 :int.parse(value['city_code']);
          firstLevels.add(cc1);

          List<dynamic> stores = value['data'];
          stores.forEach((value) {
            StoreSelect ddd1 = StoreSelect();
            ddd1.id = value['id'];
            ddd1.name = value['name'];
            ddd1.city = cc1.id;
            all.add(ddd1);
          });
        });
      } else {}
    });

    super.initState();
  }
bool getSelect(){
    var f = <SelectItem>[];
  for (int i = 0; i < widget.selectItems.length; i++) {
    if (widget.selectItems[i].type <100 ) {
      f.add(widget.selectItems[i]);
    }

  }
  return f.length > 0;
}
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Stack(
        key: _stackKey,
        children: <Widget>[
          Column(
            children: <Widget>[
              Container(
                decoration: new BoxDecoration(),
                child: GZXDropDownHeader(
                  items: [
                    GZXDropDownHeaderItem(_dropDownHeaderItemStrings[0],
                        style: TextStyle(color: (_dropDownHeaderItemStrings[0] =="全部门店" || _dropDownHeaderItemStrings[0] =="全部")?Colors.black:Colors.redAccent)),
                    GZXDropDownHeaderItem(_dropDownHeaderItemStrings[1], style: TextStyle(color: (_dropDownHeaderItemStrings[1] =="客户状态" )?Colors.black:Colors.redAccent)),
                    GZXDropDownHeaderItem(_dropDownHeaderItemStrings[2], style: TextStyle(color: (_dropDownHeaderItemStrings[2] =="沟通状态" )?Colors.black:Colors.redAccent)),
                    GZXDropDownHeaderItem(_dropDownHeaderItemStrings[3], style: TextStyle(color: (getSelect() == false )?Colors.black:Colors.redAccent),
                        iconSize: 18),
                  ],
                  stackKey: _stackKey,
                  controller: _dropdownMenuController,
                  onItemTap: (index) {
                    if (index == 3) {
                      widget.state.currentState.openEndDrawer();
                      _dropdownMenuController.hide();
                    }
                  },
                ),
              ),
            ],
          ),
          GZXDropDownMenu(
            controller: _dropdownMenuController,
            animationMilliseconds: 350,
            menus: [
              GZXDropdownMenuBuilder(
                  dropDownHeight: 40 * 8.0,
                  dropDownWidget: _buildQuanChengWidget((selectValue) {
                    _dropDownHeaderItemStrings[0] = selectValue.name;
                    _dropdownMenuController.hide();
                    setState(() {});
                    if (selectValue.type == 101) {
                      if (selectValue.id == "1") {
                        selectValue.id = "0";
                      } else {
                        return;
                      }
                    }
                    int k = 0;
                    for (int i = 0; i < widget.selectItems.length; i++) {
                      if (widget.selectItems[i].type == 100) {
                        widget.selectItems[i].id = selectValue.id.toString();
                        k = 1;
                        break;
                      }
                    }
                    if (k > 0) {
                    } else {
                      SelectItem s = SelectItem();
                      s.type = 100;
                      s.id = selectValue.id.toString();
                      widget.selectItems.add(s);
                    }
                    var sex = BlocProvider.of<GlobalBloc>(context).state.sex;
                    var mode = BlocProvider.of<GlobalBloc>(context)
                        .state
                        .currentPhotoMode;
                    BlocProvider.of<HomeBloc>(context).add(EventSearchErpUser(
                        null, widget.selectItems, sex, mode, false, 0, 0, ""));
                  })),
              GZXDropdownMenuBuilder(
                  dropDownHeight: 40.0 * _brandSortConditions.length,
                  dropDownWidget:
                  _buildConditionListWidget(_brandSortConditions, (value) {
                    _selectBrandSortCondition = value;
                    _dropDownHeaderItemStrings[1] =
                        _selectBrandSortCondition.name;
                    _dropdownMenuController.hide();
                    setState(() {});
                    int k = 0;
                    for (int i = 0; i < widget.selectItems.length; i++) {
                      if (widget.selectItems[i].type == 120) {
                        widget.selectItems[i].id = value.id.toString();
                        k = 1;
                        break;
                      }
                    }
                    if (k > 0) {
                    } else {
                      SelectItem s = SelectItem();
                      s.type = 120;
                      s.id = value.id.toString();
                      widget.selectItems.add(s);
                    }
                    var sex = BlocProvider.of<GlobalBloc>(context).state.sex;
                    var mode = BlocProvider.of<GlobalBloc>(context)
                        .state
                        .currentPhotoMode;
                    BlocProvider.of<HomeBloc>(context).add(EventSearchErpUser(
                        null, widget.selectItems, sex, mode, false, 0, 0, ""));
                  })),
              GZXDropdownMenuBuilder(
                  dropDownHeight: 40.0 * _distanceSortConditions.length,
                  dropDownWidget: _buildConditionListWidget(
                      _distanceSortConditions, (value) {
                    _selectDistanceSortCondition = value;
                    _dropDownHeaderItemStrings[2] =
                        _selectDistanceSortCondition.name;
                    _dropdownMenuController.hide();
                    setState(() {});
                    int k = 0;
                    for (int i = 0; i < widget.selectItems.length; i++) {
                      if (widget.selectItems[i].type == 130) {
                        widget.selectItems[i].id = value.id.toString();
                        k = 1;
                        break;
                      }
                    }
                    if (k > 0) {
                    } else {
                      SelectItem s = SelectItem();
                      s.type = 130;
                      s.id = value.id.toString();
                      widget.selectItems.add(s);
                    }
                    var sex = BlocProvider.of<GlobalBloc>(context).state.sex;
                    var mode = BlocProvider.of<GlobalBloc>(context)
                        .state
                        .currentPhotoMode;
                    BlocProvider.of<HomeBloc>(context).add(EventSearchErpUser(
                        null, widget.selectItems, sex, mode, false, 0, 0, ""));
                  })),
            ],
          ),

        ],
      ),
    );
  }

  int _selectTempFirstLevelIndex = 0;
  int _selectFirstLevelIndex = 0;

  int _selectSecondLevelIndex = -1;

  _buildQuanChengWidget(void itemOnTap(SelectItem selectValue)) {
//    List firstLevels = new List<int>.filled(15, 0);

    return Row(
      children: <Widget>[
        Container(
          width: 200.w,
          child: ListView(
            children: firstLevels.map((item) {
              int index = firstLevels.indexOf(item);
              return GestureDetector(
                onTap: () {
                  _selectTempFirstLevelIndex = index;

                  if (_selectTempFirstLevelIndex == 0) {
                    SelectItem s = SelectItem();
                    s.type = 101;
                    s.id = "1";
                    s.name = "全部门店";
                    itemOnTap(s);
                    return;
                  } else {
                    secondtLevels = [];
                    for (int i = 0; i < all.length; i++) {
                      if (all[i].city == item.id) {
                        StoreSelect ddd1 = StoreSelect();
                        ddd1.id = all[i].id;
                        ddd1.name = all[i].name;
                        ddd1.city = item.id;
                        secondtLevels.add(ddd1);
                      }
                    }
                    setState(() {});
                  }
                  setState(() {});
                },
                child: Container(
                    height: 80.h,
                    color: _selectTempFirstLevelIndex == index
                        ? Colors.grey[100]
                        : Colors.white,
                    alignment: Alignment.center,
                    child: _selectTempFirstLevelIndex == index
                        ? Text(
                      '${item.name}',
                      style: TextStyle(
                        color: Colors.red,
                      ),
                    )
                        : Text('${item.name}')),
              );
            }).toList(),
          ),
        ),
        Expanded(
          child: Container(
            color: Colors.grey[100],
            child: _selectTempFirstLevelIndex == 0
                ? Container()
                : ListView(
              children: secondtLevels.map((item) {
                int index = secondtLevels.indexOf(item);
                return GestureDetector(
                    onTap: () {
                      _selectSecondLevelIndex = index;
                      _selectFirstLevelIndex = _selectTempFirstLevelIndex;
                      if (_selectSecondLevelIndex == 0) {
                        SelectItem s = SelectItem();
                        s.type = 100;
                        s.id = item.id.toString();
                        s.name = item.name;
                        itemOnTap(s);
                      } else {
                        SelectItem s = SelectItem();
                        s.type = 100;
                        s.id = item.id.toString();
                        s.name = item.name;
                        itemOnTap(s);
                      }
                    },
                    child: Container(
                      height: 80.h,
                      alignment: Alignment.centerLeft,
                      child: Row(children: <Widget>[
                        SizedBox(
                          width: 40.w,
                        ),
                        _selectFirstLevelIndex ==
                            _selectTempFirstLevelIndex &&
                            _selectSecondLevelIndex == index
                            ? Text(
                          '${item.name}',
                          style: TextStyle(
                            color: Colors.red,
                          ),
                        )
                            : Text('${item.name}'),
                      ]),
                    ));
              }).toList(),
            ),
          ),
        )
      ],
    );
  }

  _buildConditionListWidget(items, void itemOnTap(SortCondition)) {
    return ListView.separated(
      shrinkWrap: true,
      scrollDirection: Axis.vertical,
      itemCount: items.length,
      // item 的个数
      separatorBuilder: (BuildContext context, int index) =>
          Divider(height: 1.0),
      // 添加分割线
      itemBuilder: (BuildContext context, int index) {
        SortCondition goodsSortCondition = items[index];
        return GestureDetector(
          onTap: () {
            for (var value in items) {
              value.isSelected = false;
            }

            goodsSortCondition.isSelected = true;

            itemOnTap(goodsSortCondition);
          },
          child: Container(
//            color: Colors.blue,
            height: 40,
            child: Row(
              children: <Widget>[
                SizedBox(
                  width: 16,
                ),
                Expanded(
                  child: Text(
                    goodsSortCondition.name,
                    style: TextStyle(
                      color: goodsSortCondition.isSelected
                          ? Colors.red
                          : Colors.black,
                    ),
                  ),
                ),
                goodsSortCondition.isSelected
                    ? Icon(
                  Icons.check,
                  color: Theme.of(context).primaryColor,
                  size: 16,
                )
                    : SizedBox(),
                SizedBox(
                  width: 16,
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}