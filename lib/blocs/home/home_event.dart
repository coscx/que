import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_geen/app/enums.dart';
import 'package:flutter_geen/storage/po/widget_po.dart';
import 'package:flutter_geen/model/widget_model.dart';
import 'package:flutter_geen/views/items/SearchParamModel.dart';


abstract class HomeEvent extends Equatable {
  const HomeEvent();
  @override
  List<Object> get props => [];
}

class EventTabTap extends HomeEvent {
  final WidgetFamily family;

  EventTabTap(this.family);

}

class EventSearchErpUser extends HomeEvent {
  final SearchParamList search;
  final int sex;
  final int mode;
  EventSearchErpUser(this.search,this.sex,this.mode);

}
class EventTabPhoto extends HomeEvent {
  final Map<String,dynamic> family;

  EventTabPhoto(this.family);

}
class EventCheckUser extends HomeEvent {
  final Map<String,dynamic> user;
  final int status;
  EventCheckUser(this.user,this.status);

}
class EventResetCheckUser extends HomeEvent {
  final Map<String,dynamic> user;
  final int status;
  EventResetCheckUser(this.user,this.status);

}
class EventDelImg extends HomeEvent {
  final Map<String,dynamic> user;
  final int status;
  EventDelImg(this.user,this.status);

}

class EventFresh extends HomeEvent {

  final int sex;
  final int mode;
  final SearchParamList search;
  EventFresh(this.sex,this.mode,this.search);
}
class EventGetCreditId extends HomeEvent {

  final String CreditIds;
  EventGetCreditId(this.CreditIds);
}
class EventLoadMore extends HomeEvent {
  final List<dynamic> user01;
  EventLoadMore(this.user01);
}
class EventPagePlus extends HomeEvent {


}