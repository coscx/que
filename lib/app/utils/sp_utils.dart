///lib/utils/sp_utils.dart
import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

class SPUtil {
  ///静态实例
  static  SharedPreferences _sharedPreferences;
  // 如果_sp已存在，直接返回，为null时创建
  static Future<SharedPreferences> get sp async {
    if (_sharedPreferences == null) {
      _sharedPreferences = await SharedPreferences.getInstance();
    }
    return _sharedPreferences;
  }
  ///应用启动时需要调用
  ///初始化
  static Future<bool> init() async {
    _sharedPreferences = await SharedPreferences.getInstance();
    return true;
  }

  //清除数据
  static void remove(String key) async {
    if ((await sp).containsKey(key)) {
      (await sp).remove(key);
    }
  }

  // 异步保存基本数据类型
  static Future save(String key, dynamic value) async {
    if (value is String) {
      (await sp).setString(key, value);
    } else if (value is bool) {
      (await sp).setBool(key, value);
    } else if (value is double) {
      (await sp).setDouble(key, value);
    } else if (value is int) {
      (await sp).setInt(key, value);
    } else if (value is List<String>) {
      (await sp).setStringList(key, value);
    }
  }

  // 异步读取
  static Future<String> getString(String key) async {
    return (await sp).getString(key);
  }

  static Future<int> getInt(String key) async {
    return (await sp).getInt(key);
  }

  static Future<bool> getBool(String key) async {
    return (await sp).getBool(key);
  }

  static Future<double> getDouble(String key) async {
    return (await sp).getDouble(key);
  }

  ///保存自定义对象
  static Future saveObject(String key, dynamic value) async {
    ///通过 json 将Object对象编译成String类型保存
    (await sp).setString(key, json.encode(value));
  }

  ///获取自定义对象
  ///返回的是 Map<String,dynamic> 类型数据
  static dynamic getObject(String key) async {
    String _data = (await sp).getString(key);
    if (_data == null) {
      return null;
    }
    return (_data.isEmpty) ? null : json.decode(_data);
  }

  ///保存列表数据
  static Future<bool> putObjectList(String key, List<Object> list) async {
    ///将Object的数据类型转换为String类型
    List<String> _dataList = list?.map((value) {
      return json.encode(value);
    })?.toList();
    return (await sp).setStringList(key, _dataList);
  }

  ///获取对象集合数据
  ///返回的是List<Map<String,dynamic>>类型
  static Future<List<Map>> getObjectList(String key) async {
    if ((await sp) == null) return null;
    List<String> dataLis = (await sp).getStringList(key);
    return dataLis?.map((value) {
      Map _dataMap = json.decode(value);
      return _dataMap;
    })?.toList();
  }
}
