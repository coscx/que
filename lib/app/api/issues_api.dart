import 'dart:convert';
import 'dart:typed_data';
import 'package:dio/dio.dart';
import 'package:flutter_geen/model/github/issue_comment.dart';
import 'package:flutter_geen/model/github/issue.dart';
import 'package:flutter_geen/model/github/repository.dart';
import 'package:flutter_geen/storage/dao/local_storage.dart';
import 'package:flutter_geen/views/pages/home/gzx_filter_goods_page.dart';
import 'package:http_parser/http_parser.dart';
import 'package:flutter_geen/views/items/SearchParamModel.dart';
import 'package:city_pickers/modal/result.dart';

import '../router.dart';
const kBaseUrl = 'https://cores.queqiaochina.com';
const NewBaseUrl = 'https://erp.queqiaochina.com';
class IssuesApi {
  /// 自定义Header
  static Map<String, dynamic> httpHeaders = {
    'Accept': 'application/json,*/*',
    'Content-Type': 'application/json',
    'authorization': ""
  };
  static Dio dio= Dio(BaseOptions(baseUrl: kBaseUrl,headers: httpHeaders));
  // static Dio dio=addInterceptors(dios);
  // static Dio addInterceptors(Dio dio) {
  //   return dio..interceptors.add(InterceptorsWrapper(onError: (DioError dioError) {
  //     if (dioError.response?.statusCode == 401) {
  //         //print(dioError);
  //         return dioError;
  //     }
  //   }));
  // }



  static Future<Map<String,dynamic>> login( String username, String password) async {
    var data={'username':username,'password':password};
    Response<dynamic> rep;
    try {
       rep = await dio.post('/api/v1/auth/loginApp', queryParameters: data);
       //var datas = json.decode(rep.data);
       return rep.data;
    } on DioError catch(e){
      var dd=e.response.data;
      return dd;
    }


  }
  static Future<Map<String,dynamic>> getYesterdayConnect( String keyWord, String page,String sex,String is_passive ) async {
    var ss = await LocalStorage.get("token");
    var token =ss.toString();
    dio.options.headers['authorization']="Bearer "+token;
    var data={'name':keyWord,'currentPage':page,'status':"all",'is_passive':"all","pageSize":20,'gender':sex};
    try {
    Response<dynamic> rep = await dio.get('/api/v1/customer/personal/connectApp',queryParameters:data );
    return rep.data;

    } on DioError catch(e){
      var dd=e.response.data;
      return dd;
    }
  }
  static Future<Map<String,dynamic>> getUser(  String page ) async {
    var ss = await LocalStorage.get("token");
    var token =ss.toString();
    dio.options.headers['authorization']="Bearer "+token;
    var data={'currentPage':page,'status':"all",'is_passive':"all","store_id":1,"pageSize":100};
    try {
      Response<dynamic> rep = await dio.get('/api/v1/system/user/list',queryParameters:data );
      return rep.data;

    } on DioError catch(e){
      var dd=e.response.data;
      return dd;
    }
  }
  static Future<Map<String,dynamic>> getStoreList(  String page ) async {
    var ss = await LocalStorage.get("token");
    var token =ss.toString();
    dio.options.headers['authorization']="Bearer "+token;
    var data={'currentPage':page,'status':"all",'is_passive':"all","store_id":1,"pageSize":100};
    try {
      Response<dynamic> rep = await dio.get('/api/v1/system/user/getTreeStores',queryParameters:data );
      return rep.data;

    } on DioError catch(e){
      var dd=e.response.data;
      return dd;
    }
  }
  static Future<Map<String,dynamic>> searchErpUser( String keyWord, String page,String sex,String mode,SearchParamList search ,bool _showAge, int _showAgeMax, int _showAgeMin,String serveType,final List<SelectItem> selectItems ) async {
    var ss = await LocalStorage.get("token");
    var token =ss.toString();
    dio.options.headers['authorization']="Bearer "+token;
    Map<String,dynamic> searchParm={};
    var channel = <String>[];
    var education = <String>[];
    var income = <String>[];
    var house = <String>[];
    var marriage = <String>[];
    var startBirthday ="";
    var endBirthday ="";
    var storeId="0";
    selectItems.map((e) {
      if (e.type == 100) {

          searchParm['store_id'] = e.id;
      }
      if (e.type == 120) {
        if (e.id == "1"){
          searchParm['status'] = 1;
        }
        if (e.id == "2"){
          searchParm['status'] = 2;
        }
        if (e.id == "30"){
          searchParm['status'] = 30;
        }
        if (e.id == "100"){
          searchParm['status'] = 0;
        }
      }
      if (e.type == 130) {

          searchParm['connect'] = e.id;

      }
      if (e.type == 0) {
        channel.add(e.id);
      }
      if (e.type == 1) {
       education.add(e.id);
      }
      if (e.type == 2) {
        income.add(e.id);
      }
      if (e.type == 3) {
        house.add(e.id);
      }
      if (e.type == 4) {
        marriage.add(e.id);
      }

      if (e.type == 500) {
        startBirthday = e.id.toString();
      }
      if (e.type == 501) {
        endBirthday = e.id.toString();
      }
      if (e.type == 600) {
        storeId = e.id;
      }

    } ).toList();
    if (channel.length > 0){
    searchParm['channel_multi'] = channel.join(",");

    }

    if (education.length > 0){

      searchParm['education_multi'] = education.join(",");
    }

    if (income.length > 0){

      searchParm['income_multi'] = income.join(",");
    }
    if (house.length > 0){

      searchParm['house_multi'] = house.join(",");
    }

    if (marriage.length > 0){

      searchParm['marriage_multi'] = marriage.join(",");
    }
    if (startBirthday !=""&&endBirthday !=""){

      searchParm['startBirthday'] = startBirthday;
      searchParm['endBirthday'] = endBirthday;
    }
    // if (storeId !=""){
    //
    //   searchParm['store_id'] = storeId;
    //
    // }

    String is_passive="all";
    if(_showAge){
      searchParm['startAge'] = _showAgeMin;
      searchParm['endAge'] = _showAgeMax;
    }
    searchParm['gender'] = sex;
    //searchParm['is_passive'] = is_passive;
    //searchParm['store_id'] = 1;
    searchParm['pageSize'] = 20;
    searchParm['currentPage'] = page;
    var data={'keywords':keyWord,'currentPage':page,'status':"all",'is_passive':is_passive,"store_id":1,"pageSize":20,'gender':sex};
    String url="/api/v1/customer/system/index";
    if(mode=="0"){//全部
      url="/api/v1/customer/system/index";
    }
    if(mode=="1"){//良缘
      url="/api/v1/customer/passive/index";
    }
    if(mode=="2"){//我的
      url="/api/v1/customer/personal/indexApp";
      searchParm['type'] = serveType;
    }
    if(mode=="3"){//我的
      url="/api/v1/customer/public/index";
    }
    try {
      Response<dynamic> rep = await dio.get(url,queryParameters:searchParm );
      return rep.data;

    } on DioError catch(e){
      var dd=e.response.data;
      return dd;
    }
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
  static Future<Map<String,dynamic>> getVersion(String uuid, String type, String url ) async {
    var ss = await LocalStorage.get("token");
    var token =ss.toString();
    dio.options.headers['authorization']="Bearer "+token;
    var data={'resources':json.encode([{'type':type,'file_url':url}])};
    try {
      Response<dynamic> rep = await dio.post('/api/v1/auth/version',queryParameters:data );
      var dd=rep.data;
      return dd;
    } on DioError catch(e){
      var dd=e.response.data;
      return dd;
    }
  }
  static Future<Map<String,dynamic>> addCustomer(String mobile,String name,int gender,String birthday,int marriage,int channel,) async {
    var ss = await LocalStorage.get("token");
    var token =ss.toString();

    Map<String,dynamic> data={};
    data['mobile']=mobile;
    data['name']=name;
    data['gender']=gender;
    data['birthday']=birthday;
    data['marriage']=marriage;
    data['channel']=channel;

    dio.options.headers['authorization']="Bearer "+token;
    try {
      Response<dynamic> rep = await dio.post('/api/v1/customer/personal/addCustomer',queryParameters:data );
      var dd=rep.data;
      return dd;
    } on DioError catch(e){
      var dd=e.response.data;
      return dd;
    }
  }
  static Future<Map<String,dynamic>> addConnect(String uuid, Map<String,dynamic> data) async {

    var ss = await LocalStorage.get("token");
    var token =ss.toString();
    dio.options.headers['authorization']="Bearer "+token;
    try {
      Response<dynamic> rep = await dio.post('/api/v1/customer/addConnect',queryParameters:data );
      var dd=rep.data;
      return dd;
    } on DioError catch(e){
      var dd=e.response.data;
      return dd;
    }
  }
  static Future<Map<String,dynamic>> addAppoint(String uuid, Map<String,dynamic> data) async {

    var ss = await LocalStorage.get("token");
    var token =ss.toString();
    dio.options.headers['authorization']="Bearer "+token;
    try {
      Response<dynamic> rep = await dio.post('/api/v1/customer/addAppointment',queryParameters:data );
      var dd=rep.data;
      return dd;
    } on DioError catch(e){
      var dd=e.response.data;
      return dd;
    }
  }
  static Future<Map<String,dynamic>> buyVip(String uuid, Map<String,dynamic> data) async {

    var ss = await LocalStorage.get("token");
    var token =ss.toString();
    dio.options.headers['authorization']="Bearer "+token;
    try {
      Response<dynamic> rep = await dio.post('/api/v1/customer/buyVipApp',queryParameters:data );
      var dd=rep.data;
      return dd;
    } on DioError catch(e){
      var dd=e.response.data;
      return dd;
    }
  }
  static Future<Map<String,dynamic>> addMealFree(String uuid, Map<String,dynamic> data) async {

    var ss = await LocalStorage.get("token");
    var token =ss.toString();
    dio.options.headers['authorization']="Bearer "+token;
    try {
      Response<dynamic> rep = await dio.post('/api/v1/store/addMealFree',queryParameters:data );
      var dd=rep.data;
      return dd;
    } on DioError catch(e){
      var dd=e.response.data;
      return dd;
    }
  }
  static Future<Map<String,dynamic>> loginWx(String code) async {

    var ss = await LocalStorage.get("token");
    var token =ss.toString();
    dio.options.headers['authorization']="Bearer "+token;
    Map<String,dynamic> Param={};
    Param['code']=code;
    try {
      Response<dynamic> rep = await dio.post('/api/v1/auth/loginAppByWechat',queryParameters:Param );
      var dd=rep.data;
      return dd;
    } on DioError catch(e){
      var dd=e.response.data;
      return dd;
    }
  }

  static Future<Map<String,dynamic>> bindAppWeChat(String code) async {

    var ss = await LocalStorage.get("token");
    var token =ss.toString();
    dio.options.headers['authorization']="Bearer "+token;
    Map<String,dynamic> Param={};
    Param['code']=code;
    try {
      Response<dynamic> rep = await dio.post('/api/v1/auth/bindAppWeChat',queryParameters:Param );
      var dd=rep.data;
      return dd;
    } on DioError catch(e){
      var dd=e.response.data;
      return dd;
    }
  }
  static Future<Map<String,dynamic>> editCustomerOnce(String uuid, String type, int answer ) async {
    var ss = await LocalStorage.get("token");
    var token =ss.toString();
    dio.options.headers['authorization']="Bearer "+token;
    Map<String,dynamic> searchParam={};
    searchParam[type]=answer;
    try {
      Response<dynamic> rep = await dio.post('/api/v1/customer/editCustomer/'+uuid,queryParameters:searchParam );
      var dd=rep.data;
      return dd;
    } on DioError catch(e){
      var dd=e.response.data;
      return dd;
    }
  }
  static Future<Map<String,dynamic>> editCustomerDemandOnce(String uuid, String type, String answer ) async {
    var ss = await LocalStorage.get("token");
    var token =ss.toString();
    dio.options.headers['authorization']="Bearer "+token;
    Map<String,dynamic> searchParam={};
    searchParam[type]=answer;
    try {
      Response<dynamic> rep = await dio.post('/api/v1/customer/editCustomerDemand/'+uuid,queryParameters:searchParam );
      var dd=rep.data;
      return dd;
    } on DioError catch(e){
      var dd=e.response.data;
      return dd;
    }
  }
  static Future<Map<String,dynamic>> editCustomerOnceString(String uuid, String type, String answer ) async {
    var ss = await LocalStorage.get("token");
    var token =ss.toString();
    dio.options.headers['authorization']="Bearer "+token;
    Map<String,dynamic> searchParam={};
    searchParam[type]=answer;
    try {
      Response<dynamic> rep = await dio.post('/api/v1/customer/editCustomer/'+uuid,queryParameters:searchParam );
      var dd=rep.data;
      return dd;
    } on DioError catch(e){
      var dd=e.response.data;
      return dd;
    }
  }
  static Future<Map<String,dynamic>> getFlowData(int page,final List<SelectItem> selectItems) async {
    var ss = await LocalStorage.get("token");
    var token =ss.toString();
    Map<String,dynamic> searchParm={};
    searchParm['currentPage'] = page;

    selectItems.map((e) {

      if (e.type == 300) {
        searchParm['start_age'] = e.id;
      }
      if (e.type == 301) {
        searchParm['end_age'] = e.id;
      }
      if (e.type == 600) {
        if (e.id !="0"){
          searchParm['store_id'] = e.id;
        }

      }
      if (e.type == 1000) {
        searchParm['gender'] = e.id;
      }
    } ).toList();

    Dio dioA= Dio();
    dioA.options.headers['authorization']="Bearer "+token;
    try {
      Response<dynamic> rep = await dioA.post(NewBaseUrl+'/api/IPadCommonArticle',data: searchParm );
      var dd=rep.data;
      return dd;
    } on DioError catch(e){
      var dd=e.response.data;
      return dd;
    }
  }
  static Future<Map<String,dynamic>> editCustomerAddress(String uuid, int type,Result result ) async {
    var ss = await LocalStorage.get("token");
    var token =ss.toString();
    dio.options.headers['authorization']="Bearer "+token;
    Map<String,dynamic> searchParam={};
   if(type ==1){
     searchParam['np_province_code']=result.provinceId;
     searchParam['np_province_name']=result.provinceName;
     searchParam['np_city_code']=result.cityId;
     searchParam['np_city_name']=result.cityName;
     searchParam['np_area_code']=result.areaId;
     searchParam['np_area_name']=result.areaName;
   }else{
     searchParam['lp_province_code']=result.provinceId;
     searchParam['lp_province_name']=result.provinceName;
     searchParam['lp_city_code']=result.cityId;
     searchParam['lp_city_name']=result.cityName;
     searchParam['lp_area_code']=result.areaId;
     searchParam['lp_area_name']=result.areaName;

   }


    try {
      Response<dynamic> rep = await dio.post('/api/v1/customer/editCustomer/'+uuid,queryParameters:searchParam );
      var dd=rep.data;
      return dd;
    } on DioError catch(e){
      var dd=e.response.data;
      return dd;
    }
  }
  static Future<Map<String,dynamic>> editCustomerDemandAddress(String uuid, int type,Result result ) async {
    var ss = await LocalStorage.get("token");
    var token =ss.toString();
    dio.options.headers['authorization']="Bearer "+token;
    Map<String,dynamic> searchParam={};
    if(type ==1){
      searchParam['wish_np_province_code']=result.provinceId;
      searchParam['wish_np_province_name']=result.provinceName;
      searchParam['wish_np_city_code']=result.cityId;
      searchParam['wish_np_city_name']=result.cityName;
      searchParam['wish_np_area_code']=result.areaId;
      searchParam['wish_np_area_name']=result.areaName;
    }else{
      searchParam['wish_lp_province_code']=result.provinceId;
      searchParam['wish_lp_province_name']=result.provinceName;
      searchParam['wish_lp_city_code']=result.cityId;
      searchParam['wish_lp_city_name']=result.cityName;
      searchParam['wish_lp_area_code']=result.areaId;
      searchParam['wish_lp_area_name']=result.areaName;

    }


    try {
      Response<dynamic> rep = await dio.post('/api/v1/customer/editCustomerDemand/'+uuid,queryParameters:searchParam );
      var dd=rep.data;
      return dd;
    } on DioError catch(e){
      var dd=e.response.data;
      return dd;
    }
  }
  static Future<Map<String,dynamic>> getErpUser() async {
    var ss = await LocalStorage.get("token");
    var token =ss.toString();
    Map<String,dynamic> searchParm={};
    searchParm['pageSize'] = 1000;

    Dio dioA= Dio();
    dioA.options.headers['authorization']="Bearer "+token;
    try {
      Response<dynamic> rep = await dioA.post(NewBaseUrl+'/api/UserList',data: searchParm );
      var dd=rep.data;
      return dd;
    } on DioError catch(e){
      var dd=e.response.data;
      return dd;
    }
  }
  static Future<Map<String,dynamic>> getDashBord() async {
    var ss = await LocalStorage.get("token");
    var token =ss.toString();
    Map<String,dynamic> searchParm={};
    searchParm['pageSize'] = 1000;

    Dio dioA= Dio();
    dioA.options.headers['authorization']="Bearer "+token;
    try {
      Response<dynamic> rep = await dioA.post(NewBaseUrl+'/api/DashBord',data: searchParm );
      var dd=rep.data;
      return dd;
    } on DioError catch(e){
      var dd=e.response.data;
      return dd;
    }
  }

  static Future<Map<String,dynamic>> getStoreVips() async {
    var ss = await LocalStorage.get("token");
    var token =ss.toString();
    Map<String,dynamic> searchParm={};
    searchParm['pageSize'] = 50;

    Dio dioA= Dio();
    dioA.options.headers['authorization']="Bearer "+token;
    try {
      Response<dynamic> rep = await dioA.post(NewBaseUrl+'/api/GetStoreVips',data: searchParm );
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

    try {
      Response<dynamic> rep = await dio.get('/api/v1/customer/connectList',queryParameters:data );
      return rep.data;

    } on DioError catch(e){
      var dd=e.response.data;
      return dd;
    }
  }
  static Future<Map<String,dynamic>> getOnlyStoreList() async {
    var ss = await LocalStorage.get("token");
    var token =ss.toString();
    dio.options.headers['authorization']="Bearer "+token;
    var data={'customer_uuid':"uuid"};

    try {
      Response<dynamic> rep = await dio.get('/api/v1/store/select',queryParameters:data );
      return rep.data;

    } on DioError catch(e){
      var dd=e.response.data;
      return dd;
    }
  }
  static Future<Map<String,dynamic>> getActionList( String uuid, String page ) async {
    var ss = await LocalStorage.get("token");
    var token =ss.toString();
    dio.options.headers['authorization']="Bearer "+token;
    var data={'customer_uuid':uuid,'currentPage':page,"pageSize":20};

    try {
      Response<dynamic> rep = await dio.get('/api/v1/customer/actionList',queryParameters:data );
      return rep.data;

    } on DioError catch(e){
      var dd=e.response.data;
      return dd;
    }
  }
  static Future<Map<String,dynamic>> getCallList( String uuid, String page ) async {
    var ss = await LocalStorage.get("token");
    var token =ss.toString();
    dio.options.headers['authorization']="Bearer "+token;
    var data={'customer_uuid':uuid,'currentPage':page,"pageSize":20};

    try {
      Response<dynamic> rep = await dio.get('/api/v1/customer/callLogs',queryParameters:data );
      return rep.data;

    } on DioError catch(e){
      var dd=e.response.data;
      return dd;
    }
  }

  static Future<Map<String,dynamic>> getAppointmentList( String uuid, String page ) async {
    var ss = await LocalStorage.get("token");
    var token =ss.toString();
    dio.options.headers['authorization']="Bearer "+token;
    var data={'customer_uuid':uuid,'currentPage':page,"pageSize":20};

    try {
      Response<dynamic> rep = await dio.get('/api/v1/customer/appointmentList',queryParameters:data );
      return rep.data;

    } on DioError catch(e){
      var dd=e.response.data;
      return dd;
    }
  }
  static Future<Map<String,dynamic>> addToken( String token ) async {
    var ss = await LocalStorage.get("memberId");
    var memberId =ss.toString();
    var data={'memberId':memberId,'token':token,"pageSize":20};
    Dio dioA= Dio();
    try {
      Response<dynamic> rep = await dioA.get('http://mm.3dsqq.com:8000/addtoken',queryParameters:data);
      return rep.data;

    } on DioError catch(e){
      var dd=e.response.data;
      return dd;
    }
  }

  static Future<Map<String,dynamic>> viewCall( String uuid ) async {
    var ss = await LocalStorage.get("token");
    var token =ss.toString();
    dio.options.headers['authorization']="Bearer "+token;
    var data={'customer_uuid':uuid};
    try {
      Response<dynamic> rep = await dio.get('/api/v1/auth/getCustomerMobile/'+uuid,queryParameters:data);
      return rep.data;

    } on DioError catch(e){
      var dd=e.response.data;
      return dd;
    }
  }
  static Future<Map<String,dynamic>> claimCustomer( String uuid ) async {
    var ss = await LocalStorage.get("token");
    var token =ss.toString();
    dio.options.headers['authorization']="Bearer "+token;
    var data={'customer_uuids[0]':uuid};
    try {
      Response<dynamic> rep = await dio.post('/api/v1/customer/public/claimCustomerApp',queryParameters:data);
      return rep.data;

    } on DioError catch(e){
      var dd=e.response.data;
      return dd;
    }
  }
  static Future<Map<String,dynamic>> distribute( String uuid ,int type,String userUuid) async {
    if (type == 0 ){
      type = 1;
    }else if (type == 1 ){
      type =2;
    }else{
      type =1;
    }

    var ss = await LocalStorage.get("token");
    var token =ss.toString();
    dio.options.headers['authorization']="Bearer "+token;
    var data={'customer_uuids[0]':uuid,'type':type,'user_uuid':userUuid};
    try {
      Response<dynamic> rep = await dio.post('/api/v1/customer/system/distribute',queryParameters:data );
      return rep.data;

    } on DioError catch(e){
      var dd=e.response.data;
      return dd;
    }
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
    var data={'app':keyWord,'currentPage':page,'status':"all",'is_passive':"all","pageSize":20};
    try {
      Response<dynamic> rep = await dio.get('/api/v1/customer/system/index',queryParameters:data );
      return rep.data;

    } on DioError catch(e){
      var dd=e.response.data;
      return dd;
    }
  }
  static Future<Map<String,dynamic>> delPhoto( String imgId, ) async {
    var ss = await LocalStorage.get("token");
    var token =ss.toString();
    dio.options.headers['authorization']="Bearer "+token;
    var data={'ids[0]':imgId};
    try {
      Response<dynamic> rep = await dio.post('/api/v1/customer/deleteResources',queryParameters:data );
      return rep.data;

    } on DioError catch(e){
      var dd=e.response.data;
      return dd;
    }
  }
  static Future<Map<String,dynamic>> getData( ) async {
    var ss = await LocalStorage.get("token");
    var token =ss.toString();
    var data={'token':token};
    Dio dioA= Dio();
    Response<dynamic> rep = await dioA.post('http://bigd.gugu2019.com/admin/data/infoflu.html',queryParameters:data );
    var datas = json.decode(rep.data);
    return datas;
  }
  static Future<Map<String,dynamic>> getBigData( ) async {
    var ss = await LocalStorage.get("token");
    var token =ss.toString();
    var data={'token':token};
    Dio dioA= Dio();
    Response<dynamic> rep = await dioA.post('http://bigd.gugu2019.com/admin/data/datamenuflu.html',queryParameters:data );
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
    try{
      Response<dynamic> rep = await dio.get('/api/v1/customer/detail/'+memberId );
      //var datas = json.decode(rep.data);
      return rep.data;
    } on DioError catch(e){
      var dd=e.response.data;
      return dd;
    }
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
