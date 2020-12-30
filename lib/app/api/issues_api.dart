import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter_geen/model/github/issue_comment.dart';
import 'package:flutter_geen/model/github/issue.dart';
import 'package:flutter_geen/model/github/repository.dart';
import 'package:flutter_geen/storage/dao/local_storage.dart';


const kBaseUrl = 'http://as.gugu2019.com';

class IssuesApi {
  static Dio dio = Dio(BaseOptions(baseUrl: kBaseUrl));

  static Future<Map<String,dynamic>> login( String username, String password) async {

    var data={'username':username,'password':password};
    Response<dynamic> rep = await dio.post('/admin/auth/applogin.html',queryParameters:data );
     var datas = json.decode(rep.data);

    return datas;
  }
  static Future<Map<String,dynamic>> getPhoto( String keyWord, String page,String sex,String mode ) async {
    var ss = await LocalStorage.get("token");
    var token =ss.toString();
    var data={'keywords':keyWord,'pages':page,'token':token,'sexc':sex,'sel':mode};
    Response<dynamic> rep = await dio.post('/admin/service/photoflu.html',queryParameters:data );
    var datas = json.decode(rep.data);

    return datas;
  }
  static Future<Map<String,dynamic>> searchPhoto( String keyWord, String page, ) async {
    var ss = await LocalStorage.get("token");
    var token =ss.toString();
    var data={'keywords':keyWord,'pages':page,'token':token,};
    Response<dynamic> rep = await dio.post('/admin/service/photoflu.html',queryParameters:data );
    var datas = json.decode(rep.data);

    return datas;
  }
  static Future<Map<String,dynamic>> delPhoto( String imgId, ) async {
    var ss = await LocalStorage.get("token");
    var token =ss.toString();
    var data={'imgId':imgId,'token':token};
    Response<dynamic> rep = await dio.post('/admin/service/photodelflu.html',queryParameters:data );
    var datas = json.decode(rep.data);

    return datas;
  }
  static Future<Map<String,dynamic>> getData( ) async {
    var ss = await LocalStorage.get("token");
    var token =ss.toString();
    var data={'token':token};
    Response<dynamic> rep = await dio.post('/admin/data/infoflu.html',queryParameters:data );
    var datas = json.decode(rep.data);
    return datas;
  }
  static Future<Map<String,dynamic>> getBigData( ) async {
    var ss = await LocalStorage.get("token");
    var token =ss.toString();
    var data={'token':token};
    Response<dynamic> rep = await dio.post('/admin/data/datamenuflu.html',queryParameters:data );
    var datas = json.decode(rep.data);
    return datas;
  }
  static Future<Map<String,dynamic>> checkUser( String memberId, String checked, String type, String score) async {
    var ss = await LocalStorage.get("token");
    var token =ss.toString();
    var data={'uid':memberId,'memid':memberId,'type':type,'score':score,'checked':checked,'token':token};
    Response<dynamic> rep = await dio.post('/admin/service/photoauditflu.html',queryParameters:data );
    var datas = json.decode(rep.data);

    return datas;
  }
  static Future<Map<String,dynamic>> getPhotoNum( ) async {
    var ss = await LocalStorage.get("token");
    var token =ss.toString();
    var data={'token':token};
    Response<dynamic> rep = await dio.post('/admin/service/photonumflu.html',queryParameters:data );
    var datas = json.decode(rep.data);

    return datas;
  }
  static Future<Map<String,dynamic>> getUserDetail( String memberId) async {
    var ss = await LocalStorage.get("token");
    var token =ss.toString();
    var data={'id':memberId,'token':token};
    Response<dynamic> rep = await dio.post('/admin/user/userdetailflu.html',queryParameters:data );
    var datas = json.decode(rep.data);

    return datas;
  }

  static Future<Map<String,dynamic>> getTimeLine( String memberId) async {
    var ss = await LocalStorage.get("token");
    var token =ss.toString();
    var data={'memberId':memberId,'token':token};
    Response<dynamic> rep = await dio.post('/admin/user/gettimeline.html',queryParameters:data );
    var datas = json.decode(rep.data);

    return datas;
  }
  static Future<Repository> getRepoFlutterUnit() async {
    Response<dynamic> rep = await dio.get('/repository/name/FlutterUnit');
    dynamic repoStr = rep.data['data']['repositoryData'];
    return Repository.fromJson(json.decode(repoStr));
  }

  static Future<List<Issue>> getIssues(
      {int page = 1, int pageSize = 100}) async {
    List<dynamic> res = (await dio.get('/point',
            queryParameters: {"page": page, "pageSize": pageSize}))
        .data['data'] as List;
    return res.map((e) => Issue.fromJson(json.decode(e['pointData']))).toList();
  }

  static Future<List<IssueComment>> getIssuesComment(int pointId) async {
    List<dynamic> res = (await dio.get('/pointComment/$pointId')).data['data'] as List;
    return res
        .map((e) => IssueComment.fromJson(json.decode(e['pointCommentData'])))
        .toList();
  }




}
