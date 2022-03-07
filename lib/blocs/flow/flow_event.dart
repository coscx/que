import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_geen/app/enums.dart';
import 'package:flutter_geen/storage/po/widget_po.dart';
import 'package:flutter_geen/model/widget_model.dart';
import 'package:flutter_geen/views/items/SearchParamModel.dart';
import 'package:flutter_geen/views/pages/home/gzx_filter_goods_page.dart';


abstract class FlowEvent extends Equatable {
  const FlowEvent();
  @override
  List<Object> get props => [];
}

class FlowEventTabTap extends FlowEvent {


}

class EventFlowSearchErpUser extends FlowEvent {
  final SearchParamList search;
  final List<SelectItem> selectItems ;
  final int sex;
  final int mode;
  final bool showAge;
  final int minAge;
  final int maxAge;
  final String serveType ;
  EventFlowSearchErpUser(this.search,this.selectItems,this.sex,this.mode,this.showAge,this.maxAge,this.minAge,this.serveType);

}
class EventFlowTabPhoto extends FlowEvent {
  final Map<String,dynamic> family;

  EventFlowTabPhoto(this.family);

}
class EventFlowCheckUser extends FlowEvent {
  final Map<String,dynamic> user;
  final int status;
  EventFlowCheckUser(this.user,this.status);

}
class EventFlowResetCheckUser extends FlowEvent {
  final Map<String,dynamic> user;
  final int status;
  EventFlowResetCheckUser(this.user,this.status);

}
class EventFlowDelImg extends FlowEvent {
  final Map<String,dynamic> user;
  final int status;
  EventFlowDelImg(this.user,this.status);

}

class EventFlowFresh extends FlowEvent {

  final int sex;
  final int mode;
  final bool showAge;
  final int minAge;
  final int maxAge;
  final String serveType ;
  final SearchParamList search;
  final List<SelectItem> selectItems ;
  EventFlowFresh(this.sex,this.mode,this.search,this.showAge,this.maxAge,this.minAge,this.serveType,this.selectItems);
}
class EventFlowGetCreditId extends FlowEvent {

  final String CreditIds;
  EventFlowGetCreditId(this.CreditIds);
}
class EventFlowLoadMore extends FlowEvent {
  final List<dynamic> user01;
  EventFlowLoadMore(this.user01);
}
class EventFlowPagePlus extends FlowEvent {


}

