

import 'package:flutter_geen/storage/dao/widget_dao.dart';

abstract class SearchEvent{//事件基
  const SearchEvent();
}

class EventTextChanged extends SearchEvent {
  final SearchArgs args;//参数
  const EventTextChanged({this.args});
}
class EventCheckUsers extends SearchEvent {
  final Map<String,dynamic> user;
  final int status;
  EventCheckUsers(this.user,this.status);

}

class EventDelImgs extends SearchEvent {
  final Map<String,dynamic> user;
  final int status;
  EventDelImgs(this.user,this.status);

}
class EventResetCheckUsers extends SearchEvent {
  final Map<String,dynamic> user;
  final int status;
  EventResetCheckUsers(this.user,this.status);

}