import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_geen/app/api/issues_api.dart';
import 'package:flutter_geen/app/enums.dart';
import 'package:flutter_geen/app/res/cons.dart';
import 'package:flutter_geen/app/utils/convert.dart';
import 'package:flutter_geen/repositories/itf/widget_repository.dart';
import 'dart:convert';
import 'flow_event.dart';
import 'flow_state.dart';



class FlowBloc extends Bloc<FlowEvent, FlowState> {
  final WidgetRepository repository;

  FlowBloc({@required this.repository});

  @override
  FlowState get initialState => FlowWidgetsLoading();

  Color get activeHomeColor {

    if (state is FlowWidgetsLoaded) {
      return Colors.grey;
    }
    return Color(Cons.tabColors[0]);
  }

  @override
  Stream<FlowState> mapEventToState(FlowEvent event) async* {
    if (event is FlowEventTabTap) {

      yield* _mapLoadWidgetToState();
    }
    if (event is EventFlowCheckUser) {

      var user=event.user;
      List<dynamic> users =state.props.elementAt(2);
      var status = event.status;
      try {
        var newUsers= users.where((element) =>
        element['memberId'] != user['memberId']
        ).toList();
        String reason;
        String checked;
        String score;
        String type;
       if(status ==1){
         reason="，已拒绝该用户";checked="3";score="-1";type="1";
       }
        if(status ==2){
          reason="，颜值100分";  checked="2";score="100";type="4";
        }
        if(status ==3){
          reason="，颜值80分";  checked="2";score="80";type="3";
        }
        if(status ==4){
          reason="，颜值60分";  checked="2";score="60";type="2";
        }
        if(status ==5){
          reason="，已隐藏该用户";  checked="10";score="-2";type="5";
        }

        var result= await IssuesApi.checkUser(user['memberId'].toString(), checked,type,score);
        if  (result['code']==200){


        } else{

        }

        yield FlowCheckUserSuccess(photos: newUsers,Reason:reason);
      } catch (err) {
        print(err);
        yield FlowWidgetsLoadFailed();
      }

    }

    if (event is EventFlowResetCheckUser) {

      var user=event.user;
      List<dynamic> users =state.props.elementAt(2);
      var status = event.status;
      try {
        var newUsers= users.where((element) =>
        element['memberId'] != user['memberId']
        ).toList();
        String reason;
        String checked;
        String score;
        String type;
        reason="已撤回该用户"; checked="1";score="60";type="6";


      var result= await IssuesApi.checkUser(user['memberId'].toString(), checked,type,score);
      if  (result['code']==200){


      } else{

      }


        yield FlowCheckUserSuccess(photos: newUsers,Reason:reason);
      } catch (err) {
        print(err);
        yield FlowWidgetsLoadFailed();
      }

    }

    if (event is EventFlowDelImg) {

      var img=event.user;
      List<dynamic> oldUsers = state.props.elementAt(2);
      var newUserBond=jsonDecode(jsonEncode(oldUsers));
      var status = event.status;
      try {
        var newUsers= newUserBond.map((item) {
          if(item['memberId'] == img['memberId']){
            List<dynamic>  images = item['imageurl'];
            var items= images.where((element) =>
            element['imgId'] != img['imgId']
            ).toList();
            item['imageurl']=items;
            return item;
          }else{
            return item;
          }

        }).toList();
        var result= await IssuesApi.delPhoto(img['imgId'].toString());
        if  (result['code']==200){


        } else{

        }
        yield FlowDelImgSuccess(photos: newUsers);
      } catch (err) {
        print(err);
        yield FlowWidgetsLoadFailed();
      }

    }
    if (event is EventFlowGetCreditId) {


      try {

        yield FlowDelImgSuccess(photos: state.props.elementAt(2));
      } catch (err) {
        print(err);
        yield FlowWidgetsLoadFailed();
      }

    }
    if (event is EventFlowLoadMore) {
       var data =event.user01;
       var count = state.props.elementAt(1);
      yield FlowWidgetsLoaded(photos: data,count: count);

    }
    if (event is EventFlowFresh) {
      try {

        var result= await IssuesApi.getFlowData(1,event.selectItems);
        if  (result['message']=="Unauthenticated.") {
          yield FlowUnauthenticated();
        }else{
          if  (result['code']==200){


          } else{

          }
        }

        yield FlowWidgetsLoaded(photos: result['data']['data'],count:result['data']['total'].toString() );

      } catch (err) {
        print(err);
        yield FlowWidgetsLoadFailed();
      }

    }
    if (event is EventFlowSearchErpUser) {
      try {

        var result= await IssuesApi.getFlowData(1,[]);
        if  (result['message']=="Unauthenticated.") {
          yield FlowUnauthenticated();
        }else{
          if  (result['code']==200){


          } else{

          }
        }

        yield FlowWidgetsLoaded(photos: result['data']['data'],count:result['data']['total'].toString());

      } catch (err) {
        print(err);
        yield FlowWidgetsLoadFailed();
      }

    }
  }

  Stream<FlowState> _mapLoadWidgetToState() async* {
    yield FlowWidgetsLoading();
    try {

      var result= await IssuesApi.getPhoto('', '1','1','0');
      if  (result['message']=="Unauthenticated.") {
        yield FlowUnauthenticated();
      }else{
        if  (result['code']==200){


        } else{

        }
      }


      yield FlowWidgetsLoaded(photos: result['data']['data'],count:result['data']['total'].toString());

    } catch (err) {
      print(err);
      yield FlowWidgetsLoadFailed();
    }
  }

}
