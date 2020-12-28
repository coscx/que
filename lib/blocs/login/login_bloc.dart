import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_geen/app/api/issues_api.dart';
import 'package:flutter_geen/app/enums.dart';
import 'package:flutter_geen/app/res/cons.dart';
import 'package:flutter_geen/repositories/itf/widget_repository.dart';
import 'package:flutter_geen/storage/dao/local_storage.dart';

import 'login_event.dart';
import 'login_state.dart';



class LoginBloc extends Bloc<LoginEvent, LoginState> {


  LoginBloc();

  @override
  LoginState get initialState => LoginInital();

  Color get activeHomeColor {
    return Color(Cons.tabColors[0]);
  }

  @override
  Stream<LoginState> mapEventToState(LoginEvent event) async* {
    if (event is EventLogin) {
      yield LoginLoading();
     var result= await IssuesApi.login(event.username, event.password);
     if  (result['code']==200){

       LocalStorage.save("token", result['msg']['token']);
       LocalStorage.save("memberId", result['msg']['id'].toString());
       LocalStorage.save("im_token", result['msg']['im_token'].toString());
       yield LoginSuccess();
     } else{
       yield LoginFailed(reason: result['msg']);
     }
    }
    if (event is EventLoginFailed) {
      yield LoginInital();

    }
  }


}
