import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_geen/model/node_model.dart';
import 'package:flutter_geen/model/widget_model.dart';



/// 说明: 详情状态类

abstract class DetailState  {
  const DetailState();

  @override
  List<Object> get props => [];
}

class DetailWithData extends DetailState {

  final Map<String,dynamic>  userdetails ;
  final Map<String,dynamic>  connectList ;
  final Map<String,dynamic>  appointList ;
  final Map<String,dynamic>  actionList ;
  final Map<String,dynamic>  callList ;
  const DetailWithData({this.userdetails,this.connectList,this.appointList,this.actionList,this.callList});

  @override
  List<Object> get props => [userdetails,connectList,appointList,actionList,callList];

  @override
  String toString() {
    return 'DetailWithData{widget: }';
  }

}
class DelSuccessData extends DetailState {

  final Map<String,dynamic>  userdetails ;
  final Map<String,dynamic>  connectList ;
  final Map<String,dynamic>  appointList ;
  final Map<String,dynamic>  actionList ;
  final String  reason ;
  final Map<String,dynamic>  callList ;
  const DelSuccessData({this.userdetails,this.connectList,this.appointList,this.reason,this.actionList,this.callList});

  @override
  List<Object> get props => [userdetails,connectList,reason,actionList,callList];

  @override
  String toString() {
    return 'DelSuccessData{widget: }';
  }

}
class DetailLoading extends DetailState {}

class DetailEmpty extends DetailState {}

class DetailFailed extends DetailState {}