import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_geen/app/api/issues_api.dart';
import 'package:flutter_geen/model/widget_model.dart';
import 'package:flutter_geen/repositories/itf/widget_repository.dart';
import 'dart:convert';
import 'detail_event.dart';
import 'detail_state.dart';



class DetailBloc extends Bloc<DetailEvent, DetailState> {
  final WidgetRepository repository;

  DetailBloc({@required this.repository});

  @override
  DetailState get initialState => DetailLoading();

  @override
  Stream<DetailState> mapEventToState(DetailEvent event) async* {
    if (event is FetchWidgetDetail) {
      yield* _mapLoadWidgetToState(event.photo);
    }
    if(event is ResetDetailState){
      yield DetailLoading();
    }
    if(event is FreshDetailState){
      var result= await IssuesApi.getUserDetail(event.photo['uuid'].toString());
      if  (result['code']==200){

      } else{

      }

      var resultConnectList= await IssuesApi.getConnectList(event.photo['uuid'].toString(),"1");
      if  (resultConnectList['code']==200){

      } else{

      }

      if(result['data'].isEmpty){
        yield DetailEmpty();
      }else{
        yield DetailWithData(userdetails: result['data'],connectList: resultConnectList['data']);
      }
    }
    if(event is EditDetailEventAddress){
      Map<String ,dynamic> userdetails=state.props.elementAt(0);
      Map<String ,dynamic> connectList=state.props.elementAt(1);
      //Map<String ,dynamic>  info = userdetails['info'];
      //if (event.value is int)
      Map<String ,dynamic> result = Map.from(userdetails);
      if(event.type==1){
        result['info']['np_province_code']=event.result.provinceId;
        result['info']['np_province_name']=event.result.provinceName;
        result['info']['np_city_code']=event.result.cityId;
        result['info']['np_city_name']=event.result.cityName;
        result['info']['np_area_code']=event.result.areaId;
        result['info']['np_area_name']=event.result.areaName;
        result['info']['native_place']=event.result.provinceName+event.result.cityName+event.result.areaName;

      }else{
        result['info']['lp_province_code']=event.result.provinceId;
        result['info']['lp_province_name']=event.result.provinceName;
        result['info']['lp_city_code']=event.result.cityId;
        result['info']['lp_city_name']=event.result.cityName;
        result['info']['lp_area_code']=event.result.areaId;
        result['info']['lp_area_name']=event.result.areaName;
        result['info']['location_place']=event.result.provinceName+event.result.cityName+event.result.areaName;
      }

      yield DetailWithData(userdetails: result,connectList: connectList);

    }
    if(event is EditDetailEvent){
         Map<String ,dynamic> userdetails=state.props.elementAt(0);
         Map<String ,dynamic> connectList=state.props.elementAt(1);
         //Map<String ,dynamic>  info = userdetails['info'];
         //if (event.value is int)
         Map<String ,dynamic> result = Map.from(userdetails);
         result['info'][event.key] =event.value;
        yield DetailWithData(userdetails: result,connectList: connectList);

    }
    if(event is AddConnectEvent){
      Map<String ,dynamic> userdetails=state.props.elementAt(0);
      Map<String ,dynamic> connectList=state.props.elementAt(1);
      Map<String ,dynamic> result = Map.from(connectList);
      List<dynamic> res = result['data'];
      Map<String ,dynamic> connect ={};
      connect['id'] = 0;
      connect['username'] = "";
      connect['connect_type'] = event.connect_type;
      connect['connect_status'] = event.connect_status;
      connect['connect_time'] = event.connect_time;
      connect['subscribe_time'] = event.subscribe_time;
      connect['connect_message'] = event.connect_message;
      connect['customer_uuid'] = event.photo['uuid'];
      res=res.reversed.toList();
      res.add(connect);
      result['data']=res.reversed.toList();

      var resultConnectList= await IssuesApi.addConnect(event.photo['uuid'],connect);

      yield DetailWithData(userdetails: userdetails,connectList: result);

    }
    if(event is UploadImgSuccessEvent){
      String imgUrl="https://queqiaoerp.oss-cn-shanghai.aliyuncs.com/"+event.value;
      Map<String ,dynamic> userdetails=state.props.elementAt(0);
      Map<String ,dynamic> connectList=state.props.elementAt(1);
      Map<String ,dynamic> result = Map.from(userdetails);
      //List<Map<String ,dynamic>>   ss = userdetails['pics'];
      Map<String ,dynamic> img ={};
      img["file_url"] =imgUrl;
      img["id"] = 0;
      img["customer_id"] = 0;
      userdetails['pics'].add(img);

      yield DetailWithData(userdetails: result,connectList: connectList);

    }

    if(event is EditDetailEventString){
      Map<String ,dynamic> userdetails=state.props.elementAt(0);
      Map<String ,dynamic> connectList=state.props.elementAt(1);
      //Map<String ,dynamic>  info = userdetails['info'];
      //if (event.value is int)
      Map<String ,dynamic> result = Map.from(userdetails);
      result['info'][event.key] =event.value;
      yield DetailWithData(userdetails: result,connectList: connectList);

    }
    if(event is EventDelDetailImg){
      var result1= await IssuesApi.delPhoto(event.img['id'].toString());
      if  (result1['code']==200){
            var result= await IssuesApi.getUserDetail(event.user['uuid'].toString());
            if  (result['code']==200){

            } else{

            }

            var resultConnectList= await IssuesApi.getConnectList(event.user['uuid'].toString(),"1");
            if  (resultConnectList['code']==200){

            } else{

            }

            if(result['data'].isEmpty){
              yield DetailEmpty();
            }else{
              yield DetailWithData(userdetails: result['data'],connectList: resultConnectList['data']);
            }
      } else{

      }


    }

  }

  Stream<DetailState> _mapLoadWidgetToState(
      Map<String,dynamic> photo) async* {
    yield DetailLoading();
    try {

      var result= await IssuesApi.getUserDetail(photo['uuid'].toString());
      if  (result['code']==200){

      } else{

      }

      var resultConnectList= await IssuesApi.getConnectList(photo['uuid'].toString(),"1");
      if  (resultConnectList['code']==200){

      } else{

      }

      if(result['data'].isEmpty){
        yield DetailEmpty();
      }else{
        yield DetailWithData(userdetails: result['data'],connectList: resultConnectList['data']);
      }

    } catch (e) {
      yield DetailFailed();
    }
  }
}
