import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_geen/app/enums.dart';
import 'package:flutter_geen/model/widget_model.dart';

/// 说明: 主页状态类

abstract class ConnectState extends Equatable {
  const ConnectState();

  @override
  List<Object> get props => [];
}

class ConnectWidgetsLoading extends ConnectState {
  const ConnectWidgetsLoading();

  @override
  List<Object> get props => [];
}

class ConnectWidgetsLoaded extends ConnectState {
  final List<dynamic>  photos ;
  final String  count ;
  const ConnectWidgetsLoaded(
      {this.photos,this.count});

  @override
  List<Object> get props => [photos,count];

  @override
  String toString() {
    return 'WidgetsLoaded{widgets: $photos}';
  }
}
class ConnectWidgetsLoadmore extends ConnectState {
  final List<WidgetModel> widgets;
  final WidgetFamily activeFamily;
  final List<dynamic>  photos ;

  const ConnectWidgetsLoadmore(
      {this.activeFamily, this.widgets = const [],this.photos});

  @override
  List<Object> get props => [activeFamily, widgets,photos];

  @override
  String toString() {
    return 'WidgetsLoaded{widgets: $widgets}';
  }
}
class ConnectWidgetsLoadFailed extends ConnectState {
  const ConnectWidgetsLoadFailed();

  @override
  List<Object> get props => [];
}
class ConnectUnauthenticated extends ConnectState {
  const ConnectUnauthenticated();

  @override
  List<Object> get props => [];
}

class ConnectCheckUserSuccess extends ConnectState {
  final List<WidgetModel> widgets;
  final WidgetFamily activeFamily;
  final List<dynamic>  photos ;
  final String Reason;
  const ConnectCheckUserSuccess(
      {this.activeFamily, this.widgets = const [],this.photos,this.Reason});

  @override
  List<Object> get props => [activeFamily, widgets,photos];

  @override
  String toString() {
    return 'WidgetsLoaded{widgets: $widgets}';
  }
}

class ConnectDelImgSuccess extends ConnectState {
  final List<WidgetModel> widgets;
  final WidgetFamily activeFamily;
  final List<dynamic>  photos ;
  final int photoCurrentPage ;

  const ConnectDelImgSuccess(
      {this.activeFamily, this.widgets = const [],this.photos,this.photoCurrentPage});

  @override
  List<Object> get props => [activeFamily, widgets,photos];

  @override
  String toString() {
    return 'WidgetsLoaded{widgets: $widgets}';
  }
}

class ConnectGetCreditIdSuccess extends ConnectState {
  final List<WidgetModel> widgets;
  final WidgetFamily activeFamily;
  final List<dynamic>  photos ;
  final int photoCurrentPage ;

  const ConnectGetCreditIdSuccess(
      {this.activeFamily, this.widgets = const [],this.photos,this.photoCurrentPage});

  @override
  List<Object> get props => [activeFamily, widgets,photos];

  @override
  String toString() {
    return 'WidgetsLoaded{widgets: $widgets}';
  }
}