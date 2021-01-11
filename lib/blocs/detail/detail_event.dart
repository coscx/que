import 'package:equatable/equatable.dart';
import 'package:flutter_geen/model/widget_model.dart';
import 'package:city_pickers/modal/result.dart';

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
  List<Object> get props => [photo];

  @override
  String toString() {
    return 'FetchWidgetDetail{widgetModel: }';
  }
}

class EditDetailEvent extends DetailEvent {
  final String key;
  final int value;
  const EditDetailEvent(this.key,this.value);
  @override
  List<Object> get props => [key,value];

  @override
  String toString() {
    return 'FetchWidgetDetail{widgetModel: }';
  }
}
class EditDetailEventAddress extends DetailEvent {
  final int type;
  final Result result;
  const EditDetailEventAddress(this.result,this.type);
  @override
  List<Object> get props => [result,type];

  @override
  String toString() {
    return 'FetchWidgetDetail{widgetModel: }';
  }
}
class EditDetailEventString extends DetailEvent {
  final String key;
  final String value;
  const EditDetailEventString(this.key,this.value);
  @override
  List<Object> get props => [key,value];

  @override
  String toString() {
    return 'FetchWidgetDetail{widgetModel: }';
  }
}
class ResetDetailState extends DetailEvent {

}
class UploadImgSuccessEvent extends DetailEvent {
  final Map<String,dynamic> photo;
  final String value;
  const UploadImgSuccessEvent(this.photo,this.value);

  @override
  List<Object> get props => [photo,value];

  @override
  String toString() {
    return 'FetchWidgetDetail{widgetModel: }';
  }
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