import 'dart:typed_data';
import 'package:flutter/services.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:city_pickers/city_pickers.dart';
import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_geen/app/api/issues_api.dart';
import 'package:flutter_geen/blocs/detail/detail_bloc.dart';
import 'package:flutter_geen/blocs/detail/detail_event.dart';
import 'package:flutter_geen/components/imageview/image_preview_page.dart';
import 'package:flutter_geen/components/imageview/image_preview_view.dart';
import 'package:flutter_geen/components/permanent/feedback_widget.dart';
import 'package:flutter_geen/components/project/widget_node_panel.dart';
import 'package:flutter_geen/views/dialogs/common_dialog.dart';
import 'package:flutter_geen/views/dialogs/delete_category_dialog.dart';
import 'package:flutter_picker/Picker.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_geen/views/pages/utils/common.dart';
import 'package:multi_image_picker/multi_image_picker.dart';


Widget buildBase(BuildContext context, Map<String,dynamic> info,int canEdit){
  String level = getLevel(info['status']);

  return Container(
    margin: EdgeInsets.only(left: 15.w, right: 5.w, bottom: 0.h),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        //CustomsExpansionPanelList()
        //_item(context),
        WidgetNodePanel(
            showMore: false,
            codeFamily: 'Inconsolata',
            text: "基础资料",
            code: "",
            show: Container(
              width: ScreenUtil().screenWidth * 0.98,
              // height: 300,
              child: Wrap(
                  alignment: WrapAlignment.start,
                  direction: Axis.horizontal,
                  spacing: 0,
                  runSpacing: 0,
                  children: <Widget>[
                    GestureDetector(
                        onTap: () {},
                        child: _item_detail(
                            context,
                            Colors.black,
                            Icons.format_list_numbered,
                            "编号",
                            info['code'].toString(),
                            false)),
                    GestureDetector(
                        onTap: () {},
                        child: _item_detail(
                            context,
                            Colors.black,
                            Icons.store,
                            "门店",
                            info['app_store_name'].toString(),
                            false)),
                    GestureDetector(
                        onTap: () {},
                        child: _item_detail(context, Colors.black,
                            Icons.store, "状态", level, false)),
                    GestureDetector(
                        onTap: () {
                          if (canEdit == 0) {
                            showToastRed(context, "暂无权限修改", false);
                            return;
                          }
                          showEditDialog(context, "请输入姓名", "",
                              info['name'].toString(), "name", 1, info);
                        },
                        child: _item_detail(
                            context,
                            Colors.black,
                            Icons.drive_file_rename_outline,
                            "姓名",
                            info['name'].toString(),
                            true)),
                    GestureDetector(
                        onTap: () {
                          if (canEdit == 0) {
                            showToastRed(context, "暂无权限修改", false);
                            return;
                          }
                          showPickerArray(
                              context,
                              [
                                ["未知", "男生", "女生"]
                              ],
                              info['gender'] == 0
                                  ? [1]
                                  : [info['gender']],
                              "gender",
                              info,
                              "",
                              true);
                        },
                        child: _item_detail(
                            context,
                            Colors.black,
                            Icons.rice_bowl_outlined,
                            "性别",
                            info['gender'] == 1 ? "男生" : "女生",
                            true)),
                    GestureDetector(
                        onTap: () {},
                        child: _item_detail(
                            context,
                            Colors.black,
                            Icons.contact_page_outlined,
                            "年龄",
                            info['age'] == 0
                                ? "-"
                                : info['age'].toString() + "岁",
                            false)),
                    GestureDetector(
                        onTap: () {
                          if (canEdit == 0) {
                            showToastRed(context, "暂无权限修改", false);
                            return;
                          }
                          showPickerDateTime(
                              context,
                              info['birthday'] == null
                                  ? "-"
                                  : info['birthday'].toString(),
                              "birthday",
                              info);
                        },
                        child: _item_detail(
                            context,
                            Colors.black,
                            Icons.broken_image_outlined,
                            "生日",
                            info['birthday'] == null
                                ? "-"
                                : info['picker.adapter.text'] != ""
                                ? info['birthday'].toString()
                                : info['birthday']
                                .toString()
                                .substring(0, 10) +
                                "(" +
                                info['chinese_zodiac'] +
                                "-" +
                                info['zodiac'] +
                                ")",
                            true)),
                    GestureDetector(
                        onTap: () {},
                        child: _item_detail(
                            context,
                            Colors.red,
                            Icons.settings_backup_restore_outlined,
                            "八字",
                            info['bazi'].toString(),
                            false)),
                    GestureDetector(
                        onTap: () {},
                        child: _item_detail(
                            context,
                            Colors.orange,
                            Icons.whatshot,
                            "五行",
                            info['wuxing'].toString(),
                            false)),
                    GestureDetector(
                        onTap: () async {
                          if (canEdit == 0) {
                            showToastRed(context, "暂无权限修改", false);
                            return;
                          }
                          Result result =
                          await CityPickers.showCityPicker(
                              context: context,
                              locationCode: info['np_area_code'] == ""
                                  ? (info['np_city_code'] == ""
                                  ? "320500"
                                  : info['np_city_code'])
                                  : info['np_area_code'],
                              cancelWidget: Text(
                                "取消",
                                style: TextStyle(color: Colors.black),
                              ),
                              confirmWidget: Text(
                                "确定",
                                style: TextStyle(color: Colors.black),
                              ));
                          print(result);
                          if (result != null) {
                            var results =
                            await IssuesApi.editCustomerAddress(
                                info['uuid'], 1, result);
                            if (results['code'] == 200) {
                              BlocProvider.of<DetailBloc>(context)
                                  .add(EditDetailEventAddress(result, 1));
                              showToast(context, "编辑成功", false);
                            } else {
                              showToast(
                                  context, results['message'], false);
                            }
                          }
                        },
                        child: _item_detail(
                            context,
                            Colors.black,
                            Icons.local_activity_outlined,
                            "籍贯",
                            info['native_place'] == null
                                ? "-"
                                : (info['native_place'] == ""
                                ? "-"
                                : info['native_place'].toString()),
                            true)),
                    GestureDetector(
                        onTap: () async {
                          if (canEdit == 0) {
                            showToastRed(context, "暂无权限修改", false);
                            return;
                          }
                          Result result =
                          await CityPickers.showCityPicker(
                              context: context,
                              locationCode: info['lp_area_code'] == ""
                                  ? (info['lp_city_code'] == ""
                                  ? "320500"
                                  : info['lp_city_code'])
                                  : info['lp_area_code'],
                              cancelWidget: Text(
                                "取消",
                                style: TextStyle(color: Colors.black),
                              ),
                              confirmWidget: Text(
                                "确定",
                                style: TextStyle(color: Colors.black),
                              ));
                          print(result);
                          if (result != null) {
                            var results =
                            await IssuesApi.editCustomerAddress(
                                info['uuid'], 2, result);
                            if (results['code'] == 200) {
                              BlocProvider.of<DetailBloc>(context)
                                  .add(EditDetailEventAddress(result, 2));
                              showToast(context, "编辑成功", false);
                            } else {
                              showToast(
                                  context, results['message'], false);
                            }
                          }
                        },
                        child: _item_detail(
                            context,
                            Colors.black,
                            Icons.house_outlined,
                            "居住",
                            info['location_place'] == null
                                ? "-"
                                : (info['location_place'] == ""
                                ? "-"
                                : info['location_place'].toString()),
                            true)),
                    GestureDetector(
                        onTap: () {},
                        child: _item_detail(
                            context,
                            Colors.black,
                            Icons.point_of_sale,
                            "销售",
                            info['sale_user'].toString(),
                            false)),
                    GestureDetector(
                        onTap: () {
                          if (canEdit == 0) {
                            showToastRed(context, "暂无权限修改", false);
                            return;
                          }
                          showPickerArray(
                              context,
                              [nationLevel],
                              info['nation'] == 0
                                  ? [1]
                                  : [info['nation']],
                              "nation",
                              info,
                              "",
                              true);
                        },
                        child: _item_detail(
                            context,
                            Colors.black,
                            Icons.gamepad_outlined,
                            "民族",
                            info['nation'] == ""
                                ? "-"
                                : getNationLevel((info['nation'])),
                            true)),
                    GestureDetector(
                        onTap: () {
                          if (canEdit == 0) {
                            showToastRed(context, "暂无权限修改", false);
                            return;
                          }
                          showPickerArray(
                              context,
                              [getHeightList()],
                              info['height'] == 0
                                  ? [70]
                                  : [
                                getIndexOfList(getHeightList(),
                                    info['height'].toString())
                              ],
                              "height",
                              info,
                              "身高(cm)",
                              false);
                        },
                        child: _item_detail(
                            context,
                            Colors.black,
                            Icons.height,
                            "身高",
                            info['height'] == 0
                                ? "-"
                                : info['height'].toString() + "cm",
                            true)),
                    GestureDetector(
                        onTap: () {
                          if (canEdit == 0) {
                            showToastRed(context, "暂无权限修改", false);
                            return;
                          }
                          showPickerArray(
                              context,
                              [getWeightList()],
                              info['weight'] == 0
                                  ? [35]
                                  : [
                                getIndexOfList(getWeightList(),
                                    info['weight'].toString())
                              ],
                              "weight",
                              info,
                              "体重(kg)",
                              false);
                        },
                        child: _item_detail(
                            context,
                            Colors.black,
                            Icons.line_weight,
                            "体重",
                            info['weight'] == 0
                                ? "-"
                                : info['weight'].toString() + "kg",
                            true)),
                    GestureDetector(
                        onTap: () {},
                        child: _item_detail(
                            context,
                            Colors.black,
                            Icons.design_services_outlined,
                            "服务",
                            info['serve_user'] == ""
                                ? "-"
                                : info['serve_user'].toString(),
                            false)),
                    GestureDetector(
                        onTap: () {
                          if (canEdit == 0) {
                            showToastRed(context, "暂无权限修改", false);
                            return;
                          }
                          showEditDialog(
                              context,
                              "请输入兴趣",
                              "",
                              info['interest'] == null
                                  ? "-"
                                  : (info['interest'] == ""
                                  ? "-"
                                  : info['interest'].toString()),
                              "interest",
                              5,
                              info);
                        },
                        child: _item_detail(
                            context,
                            Colors.black,
                            Icons.integration_instructions_outlined,
                            "兴趣",
                            info['interest'] == ""
                                ? "-"
                                : info['interest'].toString(),
                            true)),
                    GestureDetector(
                        onTap: () {
                          if (canEdit == 0) {
                            showToastRed(context, "暂无权限修改", false);
                            return;
                          }
                          showPickerArray(
                              context,
                              [floodLevel],
                              info['blood_type'] == 0
                                  ? [3]
                                  : [info['blood_type']],
                              "blood_type",
                              info,
                              "",
                              true);
                        },
                        child: _item_detail(
                            context,
                            Colors.black,
                            Icons.blur_on_outlined,
                            "血型",
                            info['blood_type'] == 0
                                ? "-"
                                : getFloodLevel(info['blood_type']),
                            true)),
                    GestureDetector(
                        onTap: () {
                          if (canEdit == 0) {
                            showToastRed(context, "暂无权限修改", false);
                            return;
                          }
                          showEditDialog(
                              context,
                              "请输入择偶要求",
                              "",
                              info['demands'] == null
                                  ? ""
                                  : (info['demands'] == ""
                                  ? ""
                                  : info['demands'].toString()),
                              "demands",
                              5,
                              info);
                        },
                        child: _item_detail(
                            context,
                            Colors.black,
                            Icons.developer_mode,
                            "择偶",
                            info['demands'] == null
                                ? "-"
                                : (info['demands'] == ""
                                ? "-"
                                : info['demands'].toString()),
                            true)),
                    GestureDetector(
                        onTap: () {
                          if (canEdit == 0) {
                            showToastRed(context, "暂无权限修改", false);
                            return;
                          }
                          showEditDialog(
                              context,
                              "请输入备注",
                              "",
                              info['remark'] == null
                                  ? ""
                                  : (info['remark'] == ""
                                  ? ""
                                  : info['remark'].toString()),
                              "remark",
                              5,
                              info);
                        },
                        child: _item_detail(
                            context,
                            Colors.black,
                            Icons.bookmarks_outlined,
                            "备注",
                            info['remark'] == null
                                ? "-"
                                : (info['remark'] == ""
                                ? "-"
                                : info['remark'].toString()),
                            true)),
                  ]),
            )),
      ],
    ),
  );
}

Widget buildEdu(BuildContext context, Map<String,dynamic> info,int canEdit){
 return Container(
    margin: EdgeInsets.only(left: 15.w, right: 5.w, bottom: 0.h),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        //CustomsExpansionPanelList()
        //_item(context),
        WidgetNodePanel(
            showMore: false,
            codeFamily: 'Inconsolata',
            text: "学历工作及资产",
            code: "",
            show: Container(
              width: ScreenUtil().screenWidth * 0.98,
              // height: 300,
              child: Wrap(
                  alignment: WrapAlignment.start,
                  direction: Axis.horizontal,
                  spacing: 0,
                  runSpacing: 0,
                  children: <Widget>[
                    GestureDetector(
                        onTap: () {
                          if (canEdit == 0) {
                            showToastRed(context, "暂无权限修改", false);
                            return;
                          }
                          showPickerArray(
                              context,
                              [EduLevel],
                              info['education'] == 0
                                  ? [1]
                                  : [info['education']],
                              "education",
                              info,
                              "",
                              true);
                        },
                        child: item_detail_gradute(
                            context,
                            Colors.redAccent,
                            Icons.menu_book,
                            "个人学历",
                            info['education'] == 0
                                ? "-"
                                : getEduLevel(info['education']),
                            true)),
                    GestureDetector(
                        onTap: () {
                          if (canEdit == 0) {
                            showToastRed(context, "暂无权限修改", false);
                            return;
                          }
                          showEditDialog(
                              context,
                              "请输入毕业院校",
                              "",
                              info['school'] == null
                                  ? ""
                                  : (info['school'] == ""
                                  ? ""
                                  : info['school'].toString()),
                              "school",
                              1,
                              info);
                        },
                        child: item_detail_gradute(
                            context,
                            Colors.black,
                            Icons.school,
                            "毕业院校",
                            info['school'].toString() == ""
                                ? "-"
                                : info['school'].toString(),
                            true)),
                    GestureDetector(
                        onTap: () {
                          if (canEdit == 0) {
                            showToastRed(context, "暂无权限修改", false);
                            return;
                          }
                          showEditDialog(
                              context,
                              "请输入所学专业",
                              "",
                              info['major'] == null
                                  ? ""
                                  : (info['major'] == ""
                                  ? ""
                                  : info['major'].toString()),
                              "major",
                              1,
                              info);
                        },
                        child: item_detail_gradute(
                            context,
                            Colors.black,
                            Icons.tab,
                            "所学专业",
                            info['major'] == ""
                                ? "-"
                                : info['major'].toString(),
                            true)),
                    GestureDetector(
                        onTap: () {
                          if (canEdit == 0) {
                            showToastRed(context, "暂无权限修改", false);
                            return;
                          }
                          showPickerArray(
                              context,
                              [companyTypeLevel],
                              info['work'] == 0 ? [1] : [info['work']],
                              "work",
                              info,
                              "",
                              true);
                        },
                        child: item_detail_gradute(
                            context,
                            Colors.black,
                            Icons.reduce_capacity,
                            "企业类型",
                            info['work'] == 0
                                ? "-"
                                : getCompanyLevel(info['work']) + "",
                            true)),
                    GestureDetector(
                        onTap: () {
                          if (canEdit == 0) {
                            showToastRed(context, "暂无权限修改", false);
                            return;
                          }
                          showPickerArray(
                              context,
                              [WorkTypeLevel],
                              info['work_job'] == 0
                                  ? [1]
                                  : [info['work_job']],
                              "work_job",
                              info,
                              "",
                              true);
                        },
                        child: item_detail_gradute(
                            context,
                            Colors.black,
                            Icons.location_city,
                            "所属行业",
                            info['work_job'] == ""
                                ? "-"
                                : getWorkType(info['work_job']),
                            true)),
                    GestureDetector(
                        onTap: () {
                          if (canEdit == 0) {
                            showToastRed(context, "暂无权限修改", false);
                            return;
                          }
                          showEditDialog(
                              context,
                              "请输入职位描述",
                              "",
                              info['work_industry'] == null
                                  ? ""
                                  : (info['work_industry'] == ""
                                  ? ""
                                  : info['work_industry'].toString()),
                              "work_industry",
                              5,
                              info);
                        },
                        child: item_detail_gradute(
                            context,
                            Colors.black,
                            Icons.description_outlined,
                            "职位描述",
                            info['work_industry'] == ""
                                ? "-"
                                : info['work_industry'].toString(),
                            true)),
                    GestureDetector(
                        onTap: () {
                          if (canEdit == 0) {
                            showToastRed(context, "暂无权限修改", false);
                            return;
                          }
                          showPickerArray(
                              context,
                              [WorkOverTimeLevel],
                              info['work_overtime'] == 0
                                  ? [1]
                                  : [info['work_overtime']],
                              "work_overtime",
                              info,
                              "",
                              true);
                        },
                        child: item_detail_gradute(
                            context,
                            Colors.black,
                            Icons.more_outlined,
                            "加班情况",
                            info['work_overtime'] == ""
                                ? "-"
                                : getWorkOverTime(info['work_overtime']),
                            true)),
                    GestureDetector(
                        onTap: () {
                          if (canEdit == 0) {
                            showToastRed(context, "暂无权限修改", false);
                            return;
                          }
                          // showPickerArray(context,[IncomeLevel],info['income']==0?[1]:[info['income']],"income",info,"",true);
                          showEditDialog(
                              context,
                              "请输入收入",
                              "",
                              info['income'].toString(),
                              "income",
                              1,
                              info);
                        },
                        child: item_detail_gradute(
                            context,
                            Colors.redAccent,
                            Icons.monetization_on_outlined,
                            "收入情况",
                            info['income'] == 0
                                ? "-"
                                : info['income'].toString() + "万",
                            true)),
                    GestureDetector(
                        onTap: () {
                          if (canEdit == 0) {
                            showToastRed(context, "暂无权限修改", false);
                            return;
                          }
                          showPickerArray(
                              context,
                              [hasHouseLevel],
                              info['has_house'] == 0
                                  ? [1]
                                  : [info['has_house']],
                              "has_house",
                              info,
                              "",
                              true);
                        },
                        child: item_detail_gradute(
                            context,
                            Colors.redAccent,
                            Icons.house_outlined,
                            "是否有房",
                            info['has_house'] == 0
                                ? "-"
                                : getHasHouse(info['has_house']),
                            true)),
                    GestureDetector(
                        onTap: () {
                          if (canEdit == 0) {
                            showToastRed(context, "暂无权限修改", false);
                            return;
                          }
                          showPickerArray(
                              context,
                              [houseFutureLevel],
                              info['loan_record'] == 0
                                  ? [1]
                                  : [info['loan_record']],
                              "loan_record",
                              info,
                              "",
                              true);
                        },
                        child: item_detail_gradute(
                            context,
                            Colors.black,
                            Icons.copyright_rounded,
                            "房贷情况",
                            info['loan_record'] == 0
                                ? "-"
                                : getHouseFuture(info['loan_record']),
                            true)),
                    GestureDetector(
                        onTap: () {
                          if (canEdit == 0) {
                            showToastRed(context, "暂无权限修改", false);
                            return;
                          }
                          showPickerArray(
                              context,
                              [hasCarLevel],
                              info['has_car'] == 0
                                  ? [1]
                                  : [info['has_car']],
                              "has_car",
                              info,
                              "",
                              true);
                        },
                        child: item_detail_gradute(
                            context,
                            Colors.black,
                            Icons.car_rental,
                            "是否有车",
                            info['has_car'] == 0
                                ? "-"
                                : getHasCar(info['has_car']),
                            true)),
                    GestureDetector(
                        onTap: () {
                          if (canEdit == 0) {
                            showToastRed(context, "暂无权限修改", false);
                            return;
                          }
                          showPickerArray(
                              context,
                              [carLevelLevel],
                              info['car_type'] == 0
                                  ? [1]
                                  : [info['car_type']],
                              "car_type",
                              info,
                              "",
                              true);
                        },
                        child: item_detail_gradute(
                            context,
                            Colors.black,
                            Icons.wb_auto_outlined,
                            "车辆档次",
                            info['car_type'] == 0
                                ? "-"
                                : getCarLevel(info['car_type']),
                            true)),
                  ]),
            )),
      ],
    ),
  );

}


Widget buildMarriage(BuildContext context, Map<String,dynamic> info,int canEdit){

  return Container(
    margin: EdgeInsets.only(left: 15.w, right: 5.w, bottom: 0.h),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        //CustomsExpansionPanelList()
        //_item(context),
        WidgetNodePanel(
            showMore: false,
            codeFamily: 'Inconsolata',
            text: "婚姻及父母家庭",
            code: "",
            show: Container(
              width: ScreenUtil().screenWidth * 0.98,
              // height: 300,
              child: Wrap(
                  alignment: WrapAlignment.start,
                  direction: Axis.horizontal,
                  spacing: 0,
                  runSpacing: 0,
                  children: <Widget>[
                    GestureDetector(
                        onTap: () {
                          if (canEdit == 0) {
                            showToastRed(context, "暂无权限修改", false);
                            return;
                          }
                          showPickerArray(
                              context,
                              [marriageLevel],
                              info['marriage'] == 0
                                  ? [1]
                                  : [info['marriage']],
                              "marriage",
                              info,
                              "",
                              true);
                        },
                        child: item_detail_gradute(
                            context,
                            Colors.redAccent,
                            Icons.wc,
                            "婚姻状态",
                            info['marriage'] == 0
                                ? "-"
                                : getMarriageLevel(info['marriage']),
                            true)),
                    GestureDetector(
                        onTap: () {
                          if (canEdit == 0) {
                            showToastRed(context, "暂无权限修改", false);
                            return;
                          }
                          showPickerArray(
                              context,
                              [childLevel],
                              info['has_child'] == 0
                                  ? [1]
                                  : [info['has_child']],
                              "has_child",
                              info,
                              "",
                              true);
                        },
                        child: item_detail_gradute(
                            context,
                            Colors.redAccent,
                            Icons.child_care,
                            "子女信息",
                            info['has_child'] == 0
                                ? "-"
                                : getChildLevel(info['has_child']),
                            true)),
                    GestureDetector(
                        onTap: () {
                          if (canEdit == 0) {
                            showToastRed(context, "暂无权限修改", false);
                            return;
                          }
                          showEditDialog(
                              context,
                              "请输入子女备注",
                              "",
                              info['child_remark'] == null
                                  ? ""
                                  : (info['child_remark'] == ""
                                  ? ""
                                  : info['child_remark'].toString()),
                              "child_remark",
                              5,
                              info);
                        },
                        child: item_detail_gradute(
                            context,
                            Colors.black,
                            Icons.mark_chat_read_outlined,
                            "子女备注",
                            info['child_remark'] == ""
                                ? "-"
                                : info['child_remark'].toString(),
                            true)),
                    GestureDetector(
                        onTap: () {
                          if (canEdit == 0) {
                            showToastRed(context, "暂无权限修改", false);
                            return;
                          }
                          showPickerArray(
                              context,
                              [onlyChildLevel],
                              info['only_child'] == 0
                                  ? [1]
                                  : [info['only_child']],
                              "only_child",
                              info,
                              "",
                              true);
                        },
                        child: item_detail_gradute(
                            context,
                            Colors.black,
                            Icons.looks_one_outlined,
                            "独生子女",
                            info['only_child'] == 0
                                ? "-"
                                : getOnlyChildLevel(info['only_child']) +
                                "",
                            true)),
                    GestureDetector(
                        onTap: () {
                          if (canEdit == 0) {
                            showToastRed(context, "暂无权限修改", false);
                            return;
                          }
                          showPickerArray(
                              context,
                              [parentLevel],
                              info['parents'] == 0
                                  ? [1]
                                  : [info['parents']],
                              "parents",
                              info,
                              "",
                              true);
                        },
                        child: item_detail_gradute(
                            context,
                            Colors.black,
                            Icons.watch_later_outlined,
                            "父母状况",
                            info['parents'] == 0
                                ? "-"
                                : getParentLevel(info['parents']),
                            true)),
                    GestureDetector(
                        onTap: () {
                          if (canEdit == 0) {
                            showToastRed(context, "暂无权限修改", false);
                            return;
                          }
                          showEditDialog(
                              context,
                              "请输入父亲职业",
                              "",
                              info['father_work'] == null
                                  ? ""
                                  : (info['father_work'] == ""
                                  ? ""
                                  : info['father_work'].toString()),
                              "father_work",
                              1,
                              info);
                        },
                        child: item_detail_gradute(
                            context,
                            Colors.black,
                            Icons.attribution_rounded,
                            "父亲职业",
                            info['father_work'] == ""
                                ? "-"
                                : info['father_work'].toString(),
                            true)),
                    GestureDetector(
                        onTap: () {
                          if (canEdit == 0) {
                            showToastRed(context, "暂无权限修改", false);
                            return;
                          }
                          showEditDialog(
                              context,
                              "请输入母亲职业",
                              "",
                              info['mother_work'] == null
                                  ? ""
                                  : (info['mother_work'] == ""
                                  ? ""
                                  : info['mother_work'].toString()),
                              "mother_work",
                              1,
                              info);
                        },
                        child: item_detail_gradute(
                            context,
                            Colors.black,
                            Icons.sports_motorsports_outlined,
                            "母亲职业",
                            info['mother_work'] == ""
                                ? "-"
                                : info['mother_work'].toString(),
                            true)),
                    GestureDetector(
                        onTap: () {
                          if (canEdit == 0) {
                            showToastRed(context, "暂无权限修改", false);
                            return;
                          }
                          showEditDialog(
                              context,
                              "请输入父母收入",
                              "",
                              info['parents_income'] == null
                                  ? ""
                                  : (info['parents_income'] == ""
                                  ? ""
                                  : info['parents_income']
                                  .toString()),
                              "parents_income",
                              1,
                              info);
                        },
                        child: item_detail_gradute(
                            context,
                            Colors.redAccent,
                            Icons.monetization_on,
                            "父母收入",
                            info['parents_income'] == ""
                                ? "-"
                                : info['parents_income'].toString(),
                            true)),
                    GestureDetector(
                        onTap: () {
                          if (canEdit == 0) {
                            showToastRed(context, "暂无权限修改", false);
                            return;
                          }
                          showPickerArray(
                              context,
                              [parentProtectLevel],
                              info['parents_insurance'] == 0
                                  ? [1]
                                  : [info['parents_insurance']],
                              "parents_insurance",
                              info,
                              "",
                              true);
                        },
                        child: item_detail_gradute(
                            context,
                            Colors.redAccent,
                            Icons.nine_k,
                            "父母社保",
                            info['parents_insurance'] == 0
                                ? "-"
                                : getParentProtectLevel(
                                info['parents_insurance']),
                            true)),
                  ]),
            )),
      ],
    ),
  );
}

Widget buildSimilar(BuildContext context, Map<String,dynamic> info,int canEdit){

  return Container(
    margin: EdgeInsets.only(left: 15.w, right: 5.w, bottom: 0.h),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        //CustomsExpansionPanelList()
        //_item(context),
        WidgetNodePanel(
            showMore: false,
            codeFamily: 'Inconsolata',
            text: "用户画像相关",
            code: "",
            show: Container(
              width: ScreenUtil().screenWidth * 0.98,
              // height: 300,
              child: Wrap(
                  alignment: WrapAlignment.start,
                  direction: Axis.horizontal,
                  spacing: 0,
                  runSpacing: 0,
                  children: <Widget>[
                    GestureDetector(
                        onTap: () {
                          if (canEdit == 0) {
                            showToastRed(context, "暂无权限修改", false);
                            return;
                          }
                          showPickerArray(
                              context,
                              [faithLevel],
                              info['faith'] == 0 ? [0] : [info['faith']],
                              "faith",
                              info,
                              "",
                              true);
                        },
                        child: item_detail_gradute(
                            context,
                            Colors.black,
                            Icons.fastfood,
                            "宗教信仰",
                            info['faith'] == 0
                                ? "-"
                                : getFaithLevel(info['faith']),
                            true)),
                    GestureDetector(
                        onTap: () {
                          if (canEdit == 0) {
                            showToastRed(context, "暂无权限修改", false);
                            return;
                          }
                          showPickerArray(
                              context,
                              [smokeLevel],
                              info['smoke'] == 0 ? [0] : [info['smoke']],
                              "smoke",
                              info,
                              "",
                              true);
                        },
                        child: item_detail_gradute(
                            context,
                            Colors.black,
                            Icons.smoking_rooms,
                            "是否吸烟",
                            info['smoke'] == 0
                                ? "-"
                                : getSmokeLevel(info['smoke']),
                            true)),
                    GestureDetector(
                        onTap: () {
                          if (canEdit == 0) {
                            showToastRed(context, "暂无权限修改", false);
                            return;
                          }
                          showPickerArray(
                              context,
                              [drinkLevel],
                              info['drinkwine'] == 0
                                  ? [0]
                                  : [info['drinkwine']],
                              "drinkwine",
                              info,
                              "",
                              true);
                        },
                        child: item_detail_gradute(
                            context,
                            Colors.black,
                            Icons.wine_bar,
                            "是否喝酒",
                            info['drinkwine'] == 0
                                ? "-"
                                : getDrinkLevel(info['drinkwine']),
                            true)),
                    GestureDetector(
                        onTap: () {
                          if (canEdit == 0) {
                            showToastRed(context, "暂无权限修改", false);
                            return;
                          }
                          showPickerArray(
                              context,
                              [lifeLevel],
                              info['live_rest'] == 0
                                  ? [0]
                                  : [info['live_rest']],
                              "live_rest",
                              info,
                              "",
                              true);
                        },
                        child: item_detail_gradute(
                            context,
                            Colors.black,
                            Icons.nightlife,
                            "生活作息",
                            info['live_rest'] == 0
                                ? "-"
                                : getLifeLevel(info['live_rest']) + "",
                            true)),
                    GestureDetector(
                        onTap: () {
                          if (canEdit == 0) {
                            showToastRed(context, "暂无权限修改", false);
                            return;
                          }
                          showPickerArray(
                              context,
                              [creatLevel],
                              info['want_child'] == 0
                                  ? [0]
                                  : [info['want_child']],
                              "want_child",
                              info,
                              "",
                              true);
                        },
                        child: item_detail_gradute(
                            context,
                            Colors.black,
                            Icons.child_friendly_outlined,
                            "生育欲望",
                            info['want_child'] == 0
                                ? "-"
                                : getCreatLevel(info['want_child']),
                            true)),
                    GestureDetector(
                        onTap: () {
                          if (canEdit == 0) {
                            showToastRed(context, "暂无权限修改", false);
                            return;
                          }
                          showPickerArray(
                              context,
                              [marriageDateLevel],
                              info['marry_time'] == 0
                                  ? [0]
                                  : [info['marry_time']],
                              "marry_time",
                              info,
                              "",
                              true);
                        },
                        child: item_detail_gradute(
                            context,
                            Colors.black,
                            Icons.margin,
                            "结婚预期",
                            info['marry_time'] == 0
                                ? "-"
                                : getMarriageDateLevel(
                                info['marry_time']),
                            true)),
                  ]),
            )),
      ],
    ),
  );
}

Widget buildPhoto(BuildContext context, Map<String,dynamic> userdetails,int canEdit){
  return Container(
    margin: EdgeInsets.only(left: 15.w, right: 5.w, bottom: 0.h),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        //CustomsExpansionPanelList()
        //_item(context),
        WidgetNodePanel(
            showMore: false,
            codeFamily: 'Inconsolata',
            text: "用户图片",
            code: "",
            show: Container(
              width: ScreenUtil().screenWidth * 0.98,
              // height: 300,
              child: Wrap(
                  alignment: WrapAlignment.start,
                  direction: Axis.horizontal,
                  spacing: 0,
                  runSpacing: 0,
                  children: <Widget>[
                    _buildLinkTo(
                      context,
                      userdetails,
                    ),
                  ]),
            )),
      ],
    ),
  );
}

Widget buildConnect(List<Widget> connectList){
  //_buildNodes(state.nodes, state.widgetModel.name)
  return Container(
    margin: EdgeInsets.only(left: 15.w, right: 5.w, bottom: 0.h),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        //CustomsExpansionPanelList()
        //_item(context),
        WidgetNodePanel(
            showMore: connectList.length == 20 ? true : false,
            codeFamily: 'Inconsolata',
            text: "客户沟通记录",
            code: "",
            show: connectList.length > 0
                ? Container(
              width: ScreenUtil().screenWidth * 0.98,
              // height: 300,
              child: Wrap(
                  alignment: WrapAlignment.start,
                  direction: Axis.horizontal,
                  spacing: 0,
                  runSpacing: 0,
                  children: <Widget>[...connectList]),
            )
                : Container(
              child: Text("暂无沟通"),
            )),
      ],
    ),
  );
}

Widget buildAppoint(List<Widget> appointListView){

  //_buildNodes(state.nodes, state.widgetModel.name)
  return Container(
    margin: EdgeInsets.only(left: 15.w, right: 5.w, bottom: 0.h),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        //CustomsExpansionPanelList()
        //_item(context),
        WidgetNodePanel(
            showMore: appointListView.length == 20 ? true : false,
            codeFamily: 'Inconsolata',
            text: "客户排约记录",
            code: "",
            show: appointListView.length > 0
                ? Container(
              width: ScreenUtil().screenWidth * 0.98,
              // height: 300,
              child: Wrap(
                  alignment: WrapAlignment.start,
                  direction: Axis.horizontal,
                  spacing: 0,
                  runSpacing: 0,
                  children: <Widget>[...appointListView]),
            )
                : Container(
              child: Text("暂无排约"),
            )),
      ],
    ),
  );

}

Widget buildAction(List<Widget> actionListView){

  return Container(
    margin: EdgeInsets.only(left: 15.w, right: 5.w, bottom: 0.h),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        //CustomsExpansionPanelList()
        //_item(context),
        WidgetNodePanel(
            showMore: actionListView.length == 20 ? true : false,
            codeFamily: 'Inconsolata',
            text: "客户操作记录",
            code: "",
            show: actionListView.length > 0
                ? Container(
              width: ScreenUtil().screenWidth * 0.98,
              // height: 300,
              child: Wrap(
                  alignment: WrapAlignment.start,
                  direction: Axis.horizontal,
                  spacing: 0,
                  runSpacing: 0,
                  children: <Widget>[...actionListView]),
            )
                : Container(
              child: Text("暂无记录"),
            )),
      ],
    ),
  );
}

Widget buildCall(List<Widget> callListView){

  return Container(
    margin: EdgeInsets.only(left: 15.w, right: 5.w, bottom: 0.h),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        //CustomsExpansionPanelList()
        //_item(context),
        WidgetNodePanel(
            showMore: callListView.length == 20 ? true : false,
            codeFamily: 'Inconsolata',
            text: "电话查看记录",
            code: "",
            show: callListView.length > 0
                ? Container(
              width: ScreenUtil().screenWidth * 0.98,
              // height: 300,
              child: Wrap(
                  alignment: WrapAlignment.start,
                  direction: Axis.horizontal,
                  spacing: 0,
                  runSpacing: 0,
                  children: <Widget>[...callListView]),
            )
                : Container(
              child: Text("暂无记录"),
            )),
      ],
    ),
  );
}

Widget _item_detail(BuildContext context, Color color, IconData icon,
    String name, String answer, bool show) {
  bool isDark = false;

  return Container(
    padding: EdgeInsets.only(top: 10.h, bottom: 0),
    width: double.infinity,
    //height: 80.h,
    child: Material(
        color: Colors.transparent,
        child: Container(
          child: Container(
            margin: EdgeInsets.only(
                left: 10.w, right: 20.w, top: 10.h, bottom: 10.h),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Row(children: <Widget>[
                  Icon(
                    icon,
                    size: 32.sp,
                    color: Colors.black54,
                  ),
                  Container(
                    margin: EdgeInsets.only(left: 15.w),
                    child: Text(
                      name,
                      style: TextStyle(fontSize: 30.sp, color: Colors.grey),
                    ),
                  ),
                  SizedBox(
                    width: ScreenUtil().setWidth(10.w),
                  ),
                  Visibility(
                      visible: true,
                      child: Container(
                        width: ScreenUtil().screenWidth * 0.71,
                        child: Text(
                          answer,
                          maxLines: 20,
                          style: TextStyle(fontSize: 28.sp, color: color),
                        ),
                      )),
                ]),
                //Visibility是控制子组件隐藏/可见的组件
                Visibility(
                  visible: show,
                  child: Row(children: <Widget>[
                    Container(
                      margin: EdgeInsets.only(right: 10.w),
                      child: Row(children: <Widget>[
                        SizedBox(
                          width: ScreenUtil().setWidth(10.w),
                        ),
                        Visibility(
                            visible: false,
                            child: Text(
                              "2021-01-12 15:35:30",
                              style: TextStyle(
                                  fontSize: 14.sp, color: Colors.grey),
                            )),
                        Visibility(
                            visible: false,
                            child: CircleAvatar(
                              backgroundImage: AssetImage("rightImageUri"),
                            ))
                      ]),
                    ),
                    Icon(
                      Icons.arrow_forward_ios_outlined,
                      size: 30.sp,
                      color: Colors.black54,
                    )
                  ]),
                )
              ],
            ),
          ),
        )),
  );
}


showEditDialog(BuildContext context, String title, String hintText,
    String text, String type, int maxLine, Map<String, dynamic> info) {
  TextEditingController _controller =
  TextEditingController.fromValue(TextEditingValue(
    text: '${text == null ? "" : text}', //判断keyword是否为空
  ));
  showCupertinoDialog(
      context: context,
      builder: (context) {
        return CupertinoAlertDialog(
          title: Text(title),
          content: Container(
            //elevation: 0.0,
            child: Column(
              children: <Widget>[
                //Text(text),
                TextField(
                  minLines: maxLine,
                  maxLines: maxLine,
                  controller: _controller,
                  decoration: InputDecoration(
                    hintText: hintText,

                    //filled: true,
                    //fillColor: Colors.white
                  ),
                ),
              ],
            ),
          ),
          actions: <Widget>[
            CupertinoDialogAction(
              onPressed: () {
                Navigator.pop(context);
              },
              child: Text('取消'),
            ),
            Container(
              child: CupertinoDialogAction(
                onPressed: () async {
                  var result = await IssuesApi.editCustomerOnceString(
                      info['uuid'], type, _controller.text);
                  if (result['code'] == 200) {
                    BlocProvider.of<DetailBloc>(context)
                        .add(EditDetailEventString(type, _controller.text));
                    //showToast(context,"编辑成功",false);
                  } else {
                    showToast(context, result['message'], false);
                  }
                  Navigator.pop(context);
                },
                child: Text('确定'),
              ),
            ),
          ],
        );
      });
}

String getLevel(int status){
  if (status ==0){
    return "C级";
  }
  if (status ==1){
    return "B级";
  }
  if (status ==2){
    return "A级";
  }
  if (status ==30){
    return "D级";
  }
  if (status ==5){
    return "M级";
  }
  if (status ==-1){
    return "P级";
  }
  return "";
}

showPickerArray(
    BuildContext context,
    List<List<String>> pickerData,
    List<int> select,
    String type,
    Map<String, dynamic> info,
    String title,
    bool isIndex) {
  Picker(
      itemExtent: 40,
      magnification: 1.2,
      selectionOverlay: CupertinoPickerDefaultSelectionOverlay(
        background: Colors.transparent,
      ),
      adapter: PickerDataAdapter<String>(pickerdata: pickerData, isArray: true),
      hideHeader: true,
      title: new Text("请选择" + title),
      cancelText: "取消",
      confirmText: "确定",
      selecteds: select,
      // columnPadding: EdgeInsets.only(top: 50.h,bottom: 50.h,left: 50.w,right: 50.w),
      selectedTextStyle: TextStyle(
        fontSize: 34.sp,
        color: Colors.redAccent,
      ),
      textStyle: TextStyle(
        fontSize: 28.sp,
        color: Colors.black,
      ),
      onConfirm: (Picker picker, List value) async {
        print(value.toString());
        print(picker.getSelectedValues());
        int values;
        if (isIndex) {
          values = value.first;
        } else {
          values = int.parse(picker.getSelectedValues().first);
        }

        var result =
        await IssuesApi.editCustomerOnce(info['uuid'], type, values);
        if (result['code'] == 200) {
          BlocProvider.of<DetailBloc>(context)
              .add(EditDetailEvent(type, values));
          showToast(context, "编辑成功", false);
        } else {
          showToast(context, result['message'], false);
        }
      }).showDialog(context);
}

showPickerDateTime(
    BuildContext context, String date, String type, Map<String, dynamic> info) {
  String dates = "";
  if (date == "-") {
    dates = "1999-01-01 08:00:00";
  } else {
    dates = date;
  }
  Picker(
      itemExtent: 40,
      magnification: 1.2,
      selectionOverlay: CupertinoPickerDefaultSelectionOverlay(
        background: Colors.transparent,
      ),
      adapter: DateTimePickerAdapter(
        type: PickerDateTimeType.kYMD,
        isNumberMonth: true,
        //strAMPM: const["上午", "下午"],
        // yearSuffix: "年",
        // monthSuffix: "月",
        // daySuffix: "日",
        value: DateTime.parse(dates),
        maxValue: DateTime.now(),
        minuteInterval: 1,
        minHour: 0,
        maxHour: 23,
        // twoDigitYear: true,
      ),
      title: new Text("选择日期"),
      cancelText: "取消",
      confirmText: "确定",
      textAlign: TextAlign.center,
      selectedTextStyle: TextStyle(color: Colors.redAccent),
      delimiter: [
        PickerDelimiter(
            column: 4,
            child: Container(
              width: 16.w,
              alignment: Alignment.center,
              child: Text('', style: TextStyle(fontWeight: FontWeight.bold)),
              color: Colors.white,
            ))
      ],
      footer: Container(
        height: 50.h,
        alignment: Alignment.center,
        child: Text(''),
      ),
      onConfirm: (Picker picker, List value) async {
        var result = await IssuesApi.editCustomerOnceString(
            info['uuid'], type, picker.adapter.text);
        if (result['code'] == 200) {
          BlocProvider.of<DetailBloc>(context)
              .add(EditDetailEventString(type, picker.adapter.text));
          showToast(context, "编辑成功", false);
        } else {
          showToast(context, result['message'], false);
        }
        print(picker.adapter.text);
      },
      onSelect: (Picker picker, int index, List<int> selecteds) {
        var stateText = picker.adapter.toString();
      }).showDialog(context);
}


Widget _buildLinkTo(BuildContext context, Map<String, dynamic> userdetail) {
  List<dynamic> imgList = userdetail['pics'];
  List<Widget> list = [];
  if (imgList != null && imgList.length > 0 ) {
    imgList.map((e) {
      if (e == null) return e;
      list.add(Column(
        children: <Widget>[
          Stack(children: <Widget>[
            Container(
              margin: EdgeInsets.fromLTRB(13.w, 25.h, 0.w, 10.h),
              child: Stack(
                children: <Widget>[
                  Column(
                    children: <Widget>[
                      GestureDetector(
                          onTap: () {
                            ImagePreview.preview(
                              context,
                              images: List.generate(1, (index) {
                                return ImageOptions(
                                  url: e['file_url'],
                                  tag: e['file_url'],
                                );
                              }),
                            );
                          },
                          child: Container(
                            margin: EdgeInsets.fromLTRB(2.w, 0.h, 2.w, 0.h),
                            child: CachedNetworkImage(
                              imageUrl: e['file_url'],
                              width: 140.w,
                              height: 240.h,
                            ),
                          ))
                    ],
                  ),
                ],
              ),
              padding: EdgeInsets.all(4.w),
              decoration: const BoxDecoration(
                color: Colors.red,
                borderRadius: BorderRadius.all(Radius.circular(10)),
              ),
            ),
            Positioned(
                top: 25.h,
                right: 0.w,
                child: FeedbackWidget(
                  onPressed: () {
                    _deletePhoto(context, e, userdetail);
                  },
                  child: const Icon(
                    CupertinoIcons.delete_solid,
                    color: Colors.white,
                  ),
                )),
          ])
        ],
      ));
    }).toList();
  }

  list.add(GestureDetector(
      child: Padding(
        padding: EdgeInsets.only(left: 35.w),
        child: Container(
            child: Image.asset(
              "assets/images/add.png",
              width: 160.w,
              height: 300.h,
            )),
      ),
      onTap: () async {
        //_getPermission(context);
        List<Asset> images = List<Asset>();
        List<Asset> resultList = List<Asset>();
        String error = 'No Error Dectected';
        //Navigator.of(ctx).pop();
        try {
          resultList = await MultiImagePicker.pickImages(
            // 选择图片的最大数量
            maxImages: 1,
            // 是否支持拍照
            enableCamera: true,
            materialOptions: MaterialOptions(
              // 显示所有照片，值为 false 时显示相册
                startInAllView: false,
                allViewTitle: '所有照片',
                actionBarColor: '#2196F3',
                textOnNothingSelected: '没有选择照片'),
          );
        } on Exception catch (e) {
          e.toString();
        }
        //if (!mounted) return;
        images = (resultList == null) ? [] : resultList;
        // 上传照片时一张一张上传
        for (int i = 0; i < images.length; i++) {
          // 获取 ByteData

          ByteData byteData = await images[i].getByteData(quality: 60);
          try {
            var resultConnectList =
            await IssuesApi.uploadPhoto("1", byteData, _loading);
            // print(resultConnectList['data']);

            var result = await IssuesApi.editCustomer(
                userdetail['info']['uuid'], "1", resultConnectList['data']);
            if (result['code'] == 200) {
              BlocProvider.of<DetailBloc>(context).add(UploadImgSuccessEvent(
                  userdetail, resultConnectList['data']));
              showToast(context, "上传成功", false);
            } else {
              showToast(context, result['message'], false);
            }
          } on DioError catch (e) {
            var dd = e.response.data;
            EasyLoading.showSuccess(dd['message']);
            //showToast(context,dd['message'],false);
          }
          EasyLoading.dismiss();
        }
      }));

  return Wrap(
    children: [...list],
  );
}

_deletePhoto(BuildContext context, Map<String, dynamic> img,
    Map<String, dynamic> detail) {
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
              BlocProvider.of<DetailBloc>(context)
                  .add(EventDelDetailImg(img, detail['info']));
              Navigator.of(context).pop();
            },
          ),
        ),
      ));
}

_loading(int a, int b) {
  double _progress;
  _progress = 0;
  _progress = a / b;
  EasyLoading.showProgress(_progress,
      status: '${(_progress * 100).toStringAsFixed(0)}%');
  //_progress += 0.03;
  if (_progress >= 1) {
    EasyLoading.dismiss();
  }
}
Widget item_detail_gradute(BuildContext context, Color color, IconData icon,
    String name, String answer, bool show) {
  bool isDark = false;

  return Container(
    padding: EdgeInsets.only(top: 10.h, bottom: 0),
    width: double.infinity,
    //height: 180.h,
    child: Material(
        color: Colors.transparent,
        child: Container(
          child: Container(
            margin: EdgeInsets.only(
                left: 10.w, right: 20.w, top: 10.h, bottom: 10.h),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Row(children: <Widget>[
                  Icon(
                    icon,
                    size: 32.sp,
                    color: Colors.black54,
                  ),
                  Container(
                    margin: EdgeInsets.only(left: 15.w),
                    child: Text(
                      name,
                      style: TextStyle(fontSize: 30.sp, color: Colors.grey),
                    ),
                  ),
                  SizedBox(
                    width: ScreenUtil().setWidth(10.w),
                  ),
                  Visibility(
                      visible: true,
                      child: Container(
                        width: ScreenUtil().screenWidth * 0.6,
                        child: Text(
                          answer,
                          maxLines: 20,
                          style: TextStyle(fontSize: 28.sp, color: color),
                        ),
                      )),
                ]),
                //Visibility是控制子组件隐藏/可见的组件
                Visibility(
                  visible: show,
                  child: Row(children: <Widget>[
                    Container(
                      margin: EdgeInsets.only(right: 10.w),
                      child: Row(children: <Widget>[
                        SizedBox(
                          width: ScreenUtil().setWidth(10.w),
                        ),
                        Visibility(
                            visible: false,
                            child: Text(
                              "2021-01-12 15:35:30",
                              style: TextStyle(
                                  fontSize: 14.sp, color: Colors.grey),
                            )),
                        Visibility(
                            visible: false,
                            child: CircleAvatar(
                              backgroundImage: AssetImage("rightImageUri"),
                            ))
                      ]),
                    ),
                    Icon(
                      Icons.arrow_forward_ios_outlined,
                      size: 30.sp,
                      color: Colors.black54,
                    )
                  ]),
                )
              ],
            ),
          ),
        )),
  );
}