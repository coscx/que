import 'package:equatable/equatable.dart';
import 'package:flutter_geen/model/widget_model.dart';


/// 说明: 详情事件

abstract class DetailEvent extends Equatable {
  const DetailEvent();
  @override
  List<Object> get props => [];
}


class FetchWidgetDetail extends DetailEvent {
  final Map<String,dynamic> photo;
  const FetchWidgetDetail(this.photo);

  @override
  List<Object> get props => [];

  @override
  String toString() {
    return 'FetchWidgetDetail{widgetModel: }';
  }
}


class ResetDetailState extends DetailEvent {

}

class FreshDetailState extends DetailEvent {
  final Map<String,dynamic> photo;
  const FreshDetailState(this.photo);

  @override
  List<Object> get props => [];

  @override
  String toString() {
    return 'FetchWidgetDetail{widgetModel: }';
  }
}


class EventDelDetailImg extends DetailEvent {
  final Map<String,dynamic> img;
  final Map<String,dynamic> user;
  EventDelDetailImg(this.img,this.user);

}