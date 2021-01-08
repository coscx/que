import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_geen/app/api/issues_api.dart';
import 'package:flutter_geen/model/widget_model.dart';
import 'package:flutter_geen/repositories/itf/widget_repository.dart';

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
