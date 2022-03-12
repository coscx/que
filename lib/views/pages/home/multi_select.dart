import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'gzx_filter_goods_page.dart';

typedef BoolWidgetBuilder = Widget Function(BuildContext context, bool selected,String name);

class MultiChipFilters extends StatefulWidget {
  final List<SelectItem> data;
  List<SelectItem> selectedS = <SelectItem>[];
  final BoolWidgetBuilder labelBuilder;
  final IndexedWidgetBuilder avatarBuilder;
  final Function(List<SelectItem>) onChange;
   double childAspectRatio;
  MultiChipFilters({@required this.data,@required this.labelBuilder,this.avatarBuilder,@required this.onChange,@required this.selectedS,this.childAspectRatio});

  @override
  _MultiChipFilterState createState() => _MultiChipFilterState();
}

class _MultiChipFilterState extends State<MultiChipFilters> {
  List<int> _selected = <int>[];

  @override
  Widget build(BuildContext context) {
    if(widget.childAspectRatio==null){
      widget.childAspectRatio =2.0;
    }
    return Container(
      padding: EdgeInsets.only(left: 30.w,right: 20.w),
      alignment: Alignment.centerLeft,
      child: Wrap(
        runSpacing: 5.w,
        spacing: 20.w,
        // primary: false,
        // shrinkWrap: true,
        // crossAxisCount: 4,
        // mainAxisSpacing: 6.h,
        // crossAxisSpacing: 12.h,
        // childAspectRatio:widget.childAspectRatio,
        // padding: EdgeInsets.only(left: 6.w, right: 6.w, top: 6.h),
//    padding: EdgeInsets.all(6),
        children: widget.data.map((e) =>
            _buildChild(context,widget.data.indexOf(e),e)).toList(),
      ),
    );
  }

  Widget _buildChild(BuildContext context,int index,SelectItem t) {
    bool selected = t.isSelect;
    return ChoiceChip(
      backgroundColor: Colors.grey.withAlpha(33),
      selectedColor: Theme
          .of(context)
          .primaryColor,
      padding: EdgeInsets.only(left: 20.w,right: 20.w),
      labelPadding: EdgeInsets.only(left: 0.w,right: 0.w),
      selectedShadowColor: Colors.black,
     shadowColor: Colors.transparent,
      pressElevation: 5,
      elevation: 3,
      avatar: widget.avatarBuilder==null?null:widget.avatarBuilder(context,index),
      label: widget.labelBuilder(context,selected,t.name),
      selected: selected,
      onSelected: (bool value) {
        setState(() {
          if (value) {
            widget.selectedS.add(t);

          } else {

            widget.selectedS.removeWhere((i) => (i.id == t.id && i.type == t.type));
          }
          t.isSelect = value;
          if(widget.onChange!=null) widget.onChange(widget.selectedS);
        });
      },
    );
  }
}