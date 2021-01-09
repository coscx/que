import 'dart:convert';
import 'dart:typed_data';
import 'package:dio/dio.dart';
import 'package:flutter_geen/model/github/issue_comment.dart';
import 'package:flutter_geen/model/github/issue.dart';
import 'package:flutter_geen/model/github/repository.dart';
import 'package:flutter_geen/storage/dao/local_storage.dart';
import 'package:http_parser/http_parser.dart';
import 'package:flutter_geen/views/items/SearchParamModel.dart';
const kBaseUrl = 'https://ctx.gugu2019.com';

class IssuesApi {
  /// 自定义Header
  static Map<String, dynamic> httpHeaders = {
    'Accept': 'application/json,*/*',
    'Content-Type': 'application/json',
    'authorization': ""
  };
  static Dio dio = Dio(BaseOptions(baseUrl: kBaseUrl,headers: httpHeaders));

  static Future<Map<String,dynamic>> login( String username, String password) async {
    var data={'username':username,'password':password};
    Response<dynamic> rep;
    try {
       rep = await dio.post('/api/v1/auth/login', queryParameters: data);
       //var datas = json.decode(rep.data);
       return rep.data;
    } on DioError catch(e){
      var dd=e.response.data;
      return dd;
    }

  }
  static Future<Map<String,dynamic>> getPhoto( String keyWord, String page,String sex,String is_passive ) async {
    var ss = await LocalStorage.get("token");
    var token =ss.toString();
    dio.options.headers['authorization']="Bearer "+token;
    var data={'name':keyWord,'currentPage':page,'status':"all",'is_passive':is_passive,"store_id":1,"pageSize":20,'gender':sex};
    Response<dynamic> rep = await dio.get('/api/v1/customer/system/index',queryParameters:data );
    var datas = (rep.data);
    return datas;
  }

  static Future<Map<String,dynamic>> searchErpUser( String keyWord, String page,String sex,String is_passive,SearchParamList search ) async {
    var ss = await LocalStorage.get("token");
    var token =ss.toString();
    dio.options.headers['authorization']="Bearer "+token;
    Map<String,dynamic> searchParm={};
    search.list.map((e) {
      if (e.paramCode=="customerLevel"){
        searchParm['status'] = e.selected;
      }
    }).toList();
    if(is_passive=="0") is_passive="all";

    searchParm['gender'] = sex;
    searchParm['is_passive'] = is_passive;
    searchParm['store_id'] = 1;
    searchParm['pageSize'] = 20;
    searchParm['currentPage'] = page;
    var data={'keywords':keyWord,'currentPage':page,'status':"all",'is_passive':is_passive,"store_id":1,"pageSize":20,'gender':sex};
    Response<dynamic> rep = await dio.get('/api/v1/customer/system/index',queryParameters:searchParm );
    var datas = (rep.data);
    return datas;
  }
  static Future<Map<String,dynamic>> editCustomer(String uuid, String type, String url ) async {
    url="https://queqiaoerp.oss-cn-shanghai.aliyuncs.com/"+url;
    var ss = await LocalStorage.get("token");
    var token =ss.toString();
    dio.options.headers['authorization']="Bearer "+token;
    var data={'resources':json.encode([{'type':type,'file_url':url}])};
    try {
    Response<dynamic> rep = await dio.post('/api/v1/customer/editCustomer/'+uuid,queryParameters:data );
    var dd=rep.data;
    return dd;
    } on DioError catch(e){
      var dd=e.response.data;
      return dd;
    }
  }
  static Future<Map<String,dynamic>> getConnectList( String uuid, String page ) async {
    var ss = await LocalStorage.get("token");
    var token =ss.toString();
    dio.options.headers['authorization']="Bearer "+token;
    var data={'customer_uuid':uuid,'currentPage':page,"pageSize":20};
    Response<dynamic> rep = await dio.get('/api/v1/customer/connectList',queryParameters:data );
    var datas = (rep.data);
    return datas;
  }
  static Future<Map<String,dynamic>> uploadPhoto(  String type, ByteData byteData,Function fd) async {
    var ss = await LocalStorage.get("token");
    var token =ss.toString();
    dio.options.headers['authorization']="Bearer "+token;
    String url = '';
    List<int> imageData = byteData.buffer.asUint8List();
    MultipartFile multipartFile = MultipartFile.fromBytes(
      imageData,
      // 文件名
      filename: 'some-file-name.jpg',
      // 文件类型
      contentType: MediaType("image", "jpg"),
    );
    FormData formData = FormData.fromMap({
      // 后端接口的参数名称
      "resource": multipartFile
    });
    Map<String, dynamic> params = Map();
    params['type']=type;
    // 使用 dio 上传图片
    Response<dynamic> rep = await dio.post('/api/v1/customer/uploadPic',data:formData,queryParameters:params,onSendProgress: fd );
    var datas = (rep.data);
    return datas;
  }
  static Future<Map<String,dynamic>> searchPhoto( String keyWord, String page, ) async {
    var ss = await LocalStorage.get("token");
    var token =ss.toString();
    dio.options.headers['authorization']="Bearer "+token;
    var data={'name':keyWord,'currentPage':page,'status':"all",'is_passive':"all","store_id":1,"pageSize":20};
    Response<dynamic> rep = await dio.get('/api/v1/customer/system/index',queryParameters:data );
    var datas = (rep.data);
    return datas;
  }
  static Future<Map<String,dynamic>> delPhoto( String imgId, ) async {
    var ss = await LocalStorage.get("token");
    var token =ss.toString();
    dio.options.headers['authorization']="Bearer "+token;
    var data={'ids':imgId};
    Response<dynamic> rep = await dio.post('/api/v1/customer/deleteResources',queryParameters:data );
    var datas = (rep.data);
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
    dio.options.headers['authorization']="Bearer "+token;
    var data={};
    Response<dynamic> rep = await dio.get('/api/v1/customer/detail/'+memberId );
    //var datas = json.decode(rep.data);
    return rep.data;
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
