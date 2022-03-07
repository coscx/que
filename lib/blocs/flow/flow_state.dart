import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_geen/app/enums.dart';
import 'package:flutter_geen/model/widget_model.dart';

/// 说明: 主页状态类

abstract class FlowState extends Equatable {
  const FlowState();

  @override
  List<Object> get props => [];
}

class FlowWidgetsLoading extends FlowState {
  const FlowWidgetsLoading();

  @override
  List<Object> get props => [];
}

class FlowWidgetsLoaded extends FlowState {
  final List<dynamic>  photos ;
  final String  count ;
  const FlowWidgetsLoaded(
      {this.photos,this.count});

  @override
  List<Object> get props => [photos,count];

  @override
  String toString() {
    return 'WidgetsLoaded{widgets: $photos}';
  }
}
class FlowWidgetsLoadmore extends FlowState {
  final List<WidgetModel> widgets;
  final WidgetFamily activeFamily;
  final List<dynamic>  photos ;

  const FlowWidgetsLoadmore(
      {this.activeFamily, this.widgets = const [],this.photos});

  @override
  List<Object> get props => [activeFamily, widgets,photos];

  @override
  String toString() {
    return 'WidgetsLoaded{widgets: $widgets}';
  }
}
class FlowWidgetsLoadFailed extends FlowState {
  const FlowWidgetsLoadFailed();

  @override
  List<Object> get props => [];
}
class FlowUnauthenticated extends FlowState {
  const FlowUnauthenticated();

  @override
  List<Object> get props => [];
}

class FlowCheckUserSuccess extends FlowState {
  final List<WidgetModel> widgets;
  final WidgetFamily activeFamily;
  final List<dynamic>  photos ;
  final String Reason;
  const FlowCheckUserSuccess(
      {this.activeFamily, this.widgets = const [],this.photos,this.Reason});

  @override
  List<Object> get props => [activeFamily, widgets,photos];

  @override
  String toString() {
    return 'WidgetsLoaded{widgets: $widgets}';
  }
}

class FlowDelImgSuccess extends FlowState {
  final List<WidgetModel> widgets;
  final WidgetFamily activeFamily;
  final List<dynamic>  photos ;
  final int photoCurrentPage ;

  const FlowDelImgSuccess(
      {this.activeFamily, this.widgets = const [],this.photos,this.photoCurrentPage});

  @override
  List<Object> get props => [activeFamily, widgets,photos];

  @override
  String toString() {
    return 'WidgetsLoaded{widgets: $widgets}';
  }
}

class FlowGetCreditIdSuccess extends FlowState {
  final List<WidgetModel> widgets;
  final WidgetFamily activeFamily;
  final List<dynamic>  photos ;
  final int photoCurrentPage ;

  const FlowGetCreditIdSuccess(
      {this.activeFamily, this.widgets = const [],this.photos,this.photoCurrentPage});

  @override
  List<Object> get props => [activeFamily, widgets,photos];

  @override
  String toString() {
    return 'WidgetsLoaded{widgets: $widgets}';
  }
}