import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_geen/app/api/issues_api.dart';
import 'package:flutter_geen/blocs/detail/detail_bloc.dart';
import 'package:flutter_geen/blocs/detail/detail_event.dart';
import 'package:flutter_geen/views/dialogs/common_dialog.dart';
import 'package:flutter_geen/views/dialogs/delete_category_dialog.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter/material.dart';

class ErpUser {
  String name;
  int id;
  bool isSelected;
  int city;

  ErpUser({this.name, this.id, this.city, this.isSelected});
}

class ErpUserPage extends StatefulWidget {
  final String uuid;

  const ErpUserPage({Key key, this.uuid}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return _NaviPageState();
  }
}

class _NaviPageState extends State<ErpUserPage> {
  List<Map<String, dynamic>> user = []; //二级分类集合
  List<Map<String, dynamic>> user1 = []; //二级分类集合
  List<Map<String, dynamic>> user2 = []; //二级分类集合
  List<Map<String, dynamic>> user3 = []; //二级分类集合
  List<String> _datas = ["销售部门", "服务部门", "其他部门"]; //一级分类集合
  int selectId = 0;
  String selectName = "";
  String selectUuid = "";
  int index; //一级分类下标
  bool select = false;

  @override
  void initState() {
    super.initState();
    getHttp();
  }

  void getHttp() async {
    try {
      var result = await IssuesApi.getErpUser();
      if (result['code'] == 200) {
      } else {}
      var y = result['data'];
      var users = y['data'] as List;
      for (int i = 0; i < users.length; i++) {
        var e = users[i];
        if (e['status'] == 0) {
          continue;
        }
        if (e['department_id'] == 6) {
          e['relname'] = e['relname'] + "(销售经理)";
        }
        if (e['department_id'] == 7) {
          e['relname'] = e['relname'] + "(服务经理)";
        }

        if (e['department_id'] == 6 ||
            e['department_id'] == 8 ||
            e['department_id'] == 9 ||
            e['department_id'] == 10) {
          user1.add(e);
        } else if (e['department_id'] == 7 ||
            e['department_id'] == 11 ||
            e['department_id'] == 12 ||
            e['department_id'] == 13) {
          user2.add(e);
        } else {
          user3.add(e);
        }
      }

      /// 初始化
      setState(() {
        index = 0;
        user = user1;
      });
    } catch (e) {
      print(e);
    }
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
              titleSpacing: 40.w,
              leadingWidth: 60.w,
              leading: IconButton(
                icon: Icon(Icons.arrow_back, color: Colors.black),
                onPressed: () => Navigator.of(context).pop(),
              ),
              title: Text("请选择",
                  style: TextStyle(
                    fontFamily: "Quicksand",
                    fontWeight: FontWeight.w900,
                    fontStyle: FontStyle.italic,
                    fontSize: 38.sp,
                    decoration: TextDecoration.none,
                    color: Colors.black,
                  )),
              //leading:const Text('Demo',style: TextStyle(color: Colors.black, fontSize: 15)),
              backgroundColor: Colors.white,
              elevation: 0,

              //bottom: bar(),
            ),
            body: Column(
              children: [
                Container(
                  height: ScreenUtil().screenHeight - 400.h,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: <Widget>[
                      Expanded(
                        flex: 2,
                        child: Container(
                          color: Colors.white,
                          child: ListView.builder(
                            itemCount: _datas.length,
                            itemBuilder: (BuildContext context, int position) {
                              return getRow(position);
                            },
                          ),
                        ),
                      ),
                      Expanded(
                          flex: 5,
                          child: ListView(
                            children: <Widget>[
                              Container(
                                //height: double.infinity,
                                alignment: Alignment.topLeft,
                                padding: EdgeInsets.only(left: 20.w),
                                color: Colors.white,
                                child: user.length ==0? Container(
                                  height: 300,
                                  alignment: Alignment.center,
                                  child:  Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    crossAxisAlignment: CrossAxisAlignment.center,
                                    children: <Widget>[
                                      Icon(Icons.loop, color: Colors.grey, size: 80.0),
                                      Container(
                                        padding:  EdgeInsets.only(top: 16.0),
                                        child:  Text(
                                          "加载中",
                                          style:  TextStyle(
                                            color: Colors.grey,
                                          ),
                                        ),
                                      )
                                    ],
                                  ),
                                ):getChip(index), //传入一级分类下标
                              ),
                            ],
                          )),
                    ],
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(
                      top: 50.h, bottom: 0.h, left: 10.h, right: 10.h),
                  child: Container(
                    width: ScreenUtil().screenWidth * 0.89,
                    height: 70.h,
                    child: RaisedButton(
                      elevation: 0,
                      shape: RoundedRectangleBorder(
                          borderRadius:
                              BorderRadius.all(Radius.circular(40.w))),
                      color: Colors.lightBlue,
                      onPressed: () async {
                        if (selectId == 0) {
                          showToastRed(context, '请选择用户', true);
                          return;
                        }

                        var actionList =
                        await IssuesApi.distribute(widget.uuid,index,selectUuid);
                        if (actionList['code'] == 200) {
                          BlocProvider.of<DetailBloc>(context)
                              .add(HuaFenDetailEvent(selectName, selectId));
                          showToast(context, '划分成功', true);
                          Navigator.pop(context, selectId);
                        } else {
                          showToastRed(
                              context, actionList['message'], true);
                          Navigator.pop(context, selectId);
                        }

                      },
                      child: Text("提交",
                          style:
                              TextStyle(color: Colors.white, fontSize: 40.sp)),
                    ),
                  ),
                ),
              ],
            )));
  }

  Widget getRow(int i) {
    Color textColor = Theme.of(context).primaryColor; //字体颜色
    return GestureDetector(
      child: Container(
        alignment: Alignment.center,
        padding: EdgeInsets.symmetric(vertical: 15, horizontal: 10),
        //Container下的color属性会与decoration下的border属性冲突，所以要用decoration下的color属性
        decoration: BoxDecoration(
          color: index == i ? Colors.grey.withAlpha(33) : Colors.white,
          border: Border(
            left: BorderSide(
                width: 5,
                color:
                    index == i ? Theme.of(context).primaryColor : Colors.white),
          ),
        ),
        child: Text(
          _datas[i],
          style: TextStyle(
            color: index == i ? textColor : Colors.black,
            fontWeight: index == i ? FontWeight.w600 : FontWeight.w400,
            fontSize: 16,
          ),
        ),
      ),
      onTap: () {
        setState(() {
          index = i; //记录选中的下标
          textColor = Colors.green;
        });
      },
    );
  }

  Widget getChip(int i) {
    //更新对应下标数据
    _updateArticles(i);
    return Wrap(
      spacing: 24.w, //两个widget之间横向的间隔
      direction: Axis.horizontal, //方向
      alignment: WrapAlignment.start, //内容排序方式
      children: List<Widget>.generate(
        user.length,
        (int index) {
          return ActionChip(
            //标签文字
            label: Text(
              user[index]['relname'],
              style: TextStyle(
                  fontSize: 32.sp,
                  color: user[index]['id'] == selectId
                      ? Colors.white
                      : Colors.black),
            ),
            //点击事件
            onPressed: () {
              setState(() {
                selectId = user[index]['id'];
                selectName = user[index]['relname'];
                selectUuid= user[index]['uuid'];
                //bindDialog(context,user[index]['store_name'],""+user[index]['depart_name']+":"+user[index]['relname']);
              });
            },
            elevation: 3,
            backgroundColor: user[index]['id'] == selectId
                ? Colors.blue
                : Colors.grey.shade200,
          );
        },
      ).toList(),
    );
  }

  ///
  /// 根据一级分类下标更新二级分类集合
  ///
  List<Map<String, dynamic>> _updateArticles(int i) {
    setState(() {
      if (i == 0) {
        user = user1;
      }
      if (i == 1) {
        user = user2;
      }
      if (i == 2) {
        user = user3;
      }
    });
    return user;
  }
}

bindDialog(BuildContext context, String title, String content) {
  showDialog(
      context: context,
      builder: (ctx) => Dialog(
            elevation: 5,
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(10.w))),
            child: Container(
              width: 50.w,
              child: DeleteCategoryDialog(
                title: title,
                content: content,
                onSubmit: () {
                  Navigator.of(context).pop();
                },
              ),
            ),
          ));
}
