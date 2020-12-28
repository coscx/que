import 'package:equatable/equatable.dart';
import 'package:flutter_geen/model/widget_model.dart';


/// 说明: 详情事件

abstract class DetailEvent extends Equatable {
  const DetailEvent();
  @override
  List<Object> get props => [];
}


class FetchWidgetDetail extends DetailEvent {
  final WidgetModel widgetModel;
  final Map<String,dynamic> photo;
  const FetchWidgetDetail(this.widgetModel,this.photo);

  @override
  List<Object> get props => [widgetModel];

  @override
  String toString() {
    return 'FetchWidgetDetail{widgetModel: $widgetModel}';
  }
}


class ResetDetailState extends DetailEvent {

}