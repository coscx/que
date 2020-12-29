import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_geen/model/node_model.dart';
import 'package:flutter_geen/model/widget_model.dart';



/// 说明: 详情状态类

abstract class DetailState extends Equatable {
  const DetailState();

  @override
  List<Object> get props => [];
}

class DetailWithData extends DetailState {

  final Map<String,dynamic>  userdetails ;
  const DetailWithData({this.userdetails});

  @override
  List<Object> get props => [userdetails];

  @override
  String toString() {
    return 'DetailWithData{widget: }';
  }

}

class DetailLoading extends DetailState {}

class DetailEmpty extends DetailState {}

class DetailFailed extends DetailState {}