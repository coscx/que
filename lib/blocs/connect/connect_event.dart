import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_geen/app/enums.dart';
import 'package:flutter_geen/storage/po/widget_po.dart';
import 'package:flutter_geen/model/widget_model.dart';
import 'package:flutter_geen/views/items/SearchParamModel.dart';
import 'package:flutter_geen/views/pages/home/gzx_filter_goods_page.dart';


abstract class ConnectEvent extends Equatable {
  const ConnectEvent();
  @override
  List<Object> get props => [];
}

class ConnectEventTabTap extends ConnectEvent {


}

class EventConnectSearchErpUser extends ConnectEvent {
  final SearchParamList search;
  final List<SelectItem> selectItems ;
  final int sex;
  final int mode;
  final bool showAge;
  final int minAge;
  final int maxAge;
  final String serveType ;
  EventConnectSearchErpUser(this.search,this.selectItems,this.sex,this.mode,this.showAge,this.maxAge,this.minAge,this.serveType);

}
class EventConnectTabPhoto extends ConnectEvent {
  final Map<String,dynamic> family;

  EventConnectTabPhoto(this.family);

}
class EventConnectCheckUser extends ConnectEvent {
  final Map<String,dynamic> user;
  final int status;
  EventConnectCheckUser(this.user,this.status);

}
class EventConnectResetCheckUser extends ConnectEvent {
  final Map<String,dynamic> user;
  final int status;
  EventConnectResetCheckUser(this.user,this.status);

}
class EventConnectDelImg extends ConnectEvent {
  final Map<String,dynamic> user;
  final int status;
  EventConnectDelImg(this.user,this.status);

}

class EventConnectFresh extends ConnectEvent {

  final int sex;
  final int mode;
  final bool showAge;
  final int minAge;
  final int maxAge;
  final String serveType ;
  final SearchParamList search;
  final List<SelectItem> selectItems ;
  EventConnectFresh(this.sex,this.mode,this.search,this.showAge,this.maxAge,this.minAge,this.serveType,this.selectItems);
}
class EventConnectGetCreditId extends ConnectEvent {

  final String CreditIds;
  EventConnectGetCreditId(this.CreditIds);
}
class EventConnectLoadMore extends ConnectEvent {
  final List<dynamic> user01;
  EventConnectLoadMore(this.user01);
}
class EventConnectPagePlus extends ConnectEvent {


}

